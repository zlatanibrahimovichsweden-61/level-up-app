# Validation run - 2026-10-13T00:09:42Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 538 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 5233 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-10-13T00:09:42Z - finished 2026-10-13T00:19:13Z

---

## 1. Environment

```text
started (UTC)  : 2026-10-13T00:09:42Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/wt_cld
branch         : cld
commit         : 262b7cb
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
  _fe_analyzer_shared 99.0.0 (109.0.0 available)
  analyzer 12.1.0 (14.5.0 available)
  analyzer_buffer 0.3.3 (0.3.4 available)
  archive 4.3.0 (4.5.1 available)
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
  image 4.10.1 (4.10.2 available)
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
92 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 538 hand-written Dart files

Formatted 60 files (0 changed) in 0.51 seconds.
Formatted 60 files (0 changed) in 0.43 seconds.
Formatted 60 files (0 changed) in 0.40 seconds.
Formatted 60 files (0 changed) in 0.50 seconds.
Formatted 60 files (0 changed) in 0.40 seconds.
Formatted 60 files (0 changed) in 0.43 seconds.
Formatted 60 files (0 changed) in 0.65 seconds.
Formatted 60 files (0 changed) in 0.56 seconds.
Formatted 58 files (0 changed) in 0.55 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing wt_cld...                                             
No issues found! (ran in 13.7s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**5233 passed, 0 failed, 0 skipped** (exit 0)


### Full test output

```text
00:00 +0: loading F:/level/level_up/wt_cld/test/audit_e4/a_cold_start_signed_out_test.dart
00:00 +0: F:/level/level_up/wt_cld/test/audit_e4/a_cold_start_signed_out_test.dart: A1 signed-out cold start: onboarding, idle, then Login - zero requests of any kind
00:01 +1: F:/level/level_up/wt_cld/test/audit_e4/a_cold_start_signed_out_test.dart: A1 signed-out cold start: onboarding, idle, then Login - zero requests of any kind
00:01 +2: F:/level/level_up/wt_cld/test/audit_e4/a_cold_start_signed_out_test.dart: A1 signed-out cold start: onboarding, idle, then Login - zero requests of any kind
A1 provider created at signed-out boot: Provider<PreferencesStore?>
A1 provider created at signed-out boot: NotifierProvider<LocaleController, Locale>
A1 provider created at signed-out boot: Provider<SecureStorage>
A1 provider created at signed-out boot: NotifierProvider<AuthController, AuthStatus>
A1 provider created at signed-out boot: Provider<GoRouter>
A1 provider created at signed-out boot: NotifierProvider<ThemeModeController, ThemeMode>
A1 provider created at signed-out boot: AsyncNotifierProvider<LoginNotifier, OtpRequestResult?>
A1 provider created at signed-out boot: StreamProvider<bool>
00:02 +3: F:/level/level_up/wt_cld/test/audit_e4/b_cold_start_with_tokens_test.dart: B0 signed in, valid tokens: every call is made after the status resolved, at /home, with a valid Bearer, once
B0 calls:
#1 GET /me bearer=valid [auth=AuthAuthenticated; at=/home]
#2 GET /leaderboard bearer=valid [auth=AuthAuthenticated; at=/home]
00:03 +4: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +5: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +6: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +7: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +8: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +9: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +10: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +11: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +12: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +13: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +14: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +15: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +16: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:03 +17: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:04 +18: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:04 +19: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: E4-01 (debug builds): the production dioProvider refreshes an expired access token C0 through the unmodified production dioProvider a 401 authentication_required is refreshed ONCE and the screen gets its answer: one /auth/refresh, /me replayed with the minted token, still signed in
00:04 +20: F:/level/level_up/wt_cld/test/audit_e4/d_account_states_test.dart: E1 account_banned on verify: ONE verify, no tokens written, signed out, no second attempt reaches the server, nothing else fires
00:04 +21: F:/level/level_up/wt_cld/test/audit_e4/d_account_states_test.dart: E1 account_banned on verify: ONE verify, no tokens written, signed out, no second attempt reaches the server, nothing else fires
00:04 +22: F:/level/level_up/wt_cld/test/audit_e4/d_account_states_test.dart: E1 account_banned on verify: ONE verify, no tokens written, signed out, no second attempt reaches the server, nothing else fires
00:04 +23: F:/level/level_up/wt_cld/test/audit_e4/d_account_states_test.dart: E1 account_banned on verify: ONE verify, no tokens written, signed out, no second attempt reaches the server, nothing else fires
00:04 +24: F:/level/level_up/wt_cld/test/audit_e4/d_account_states_test.dart: E1 account_banned on verify: ONE verify, no tokens written, signed out, no second attempt reaches the server, nothing else fires
00:05 +25: F:/level/level_up/wt_cld/test/audit_e4/d_account_states_test.dart: E1 account_banned on verify: ONE verify, no tokens written, signed out, no second attempt reaches the server, nothing else fires
00:05 +26: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:05 +27: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +28: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +29: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +30: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +31: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +32: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +33: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +34: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:06 +35: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:07 +36: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:07 +37: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:07 +38: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:08 +39: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:08 +40: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:08 +41: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:08 +41: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: C5 sign-in through the UI, then the session dies on a dead refresh: the retained OTP args (NR-29) are gone, so the OTP route cannot bring the previous phone back; a user-initiated sign-out likewise
unhandled element <filter/>; Picture key: Svg loader
00:08 +42: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:08 +43: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +44: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +45: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +46: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +47: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +48: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +49: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +50: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +51: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +52: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +53: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +54: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +55: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +56: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:09 +57: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:10 +58: F:/level/level_up/wt_cld/test/audit_e4/e_privacy_logs_storage_test.dart: (f) dynamic leak probe P7 a full sign-in / profile / forced sign-out journey with sentinel values prints NOTHING that contains a sentinel, a token, or the phone number, and reports no framework error
00:10 +59: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H1 E4-04a (fixed): after a forced sign-out the catalogue, Mistakes overview and subject-tree providers do not EXIST any more - nothing of the previous student's data is left in memory
00:10 +60: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H1 E4-04a (fixed): after a forced sign-out the catalogue, Mistakes overview and subject-tree providers do not EXIST any more - nothing of the previous student's data is left in memory
unhandled element <filter/>; Picture key: Svg loader
00:10 +61: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +62: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +63: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +64: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +65: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +66: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +67: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +68: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
00:11 +69: F:/level/level_up/wt_cld/test/audit_e4/i_image_traffic_test.dart: I1 image loaders: they request only what is on screen, never repeat while idle, and never touch the API host
I1 image traffic (all refused by the tripwire):
  /home (cold, signed in): 3 image requests
  /leaderboard: +13 on open
  /profile: +0 on open
  /profile/edit: +0 on open
  /support: +0 on open
  /home: +3 on open
  rebuild storm (locale+theme x2): +6
  hosts: {picsum.photos}
00:11 +70: F:/level/level_up/wt_cld/test/audit_e4/g_inert_and_session_scope_test.dart: G2 signed in and walking every reachable route: none of the data-layer repositories / push objects added this run is ever instantiated
00:11 +71: F:/level/level_up/wt_cld/test/audit_e4/g_inert_and_session_scope_test.dart: G2 signed in and walking every reachable route: none of the data-layer repositories / push objects added this run is ever instantiated
00:11 +72: F:/level/level_up/wt_cld/test/audit_e4/g_inert_and_session_scope_test.dart: G2 signed in and walking every reachable route: none of the data-layer repositories / push objects added this run is ever instantiated
00:11 +73: F:/level/level_up/wt_cld/test/audit_e4/g_inert_and_session_scope_test.dart: G2 signed in and walking every reachable route: none of the data-layer repositories / push objects added this run is ever instantiated
G2 providers created across the whole session:
  AsyncNotifierProvider<CreateSupportTicketNotifier, SupportTicket?>
  AsyncNotifierProvider<EditProfileNotifier, StudentProfile?>
  AsyncNotifierProvider<LeaderboardNotifier, LeaderboardResults>(LeaderboardScope.system)
  AsyncNotifierProvider<LoginNotifier, OtpRequestResult?>
  AsyncNotifierProvider<MeNotifier, StudentProfile>
  AsyncNotifierProvider<MistakesOverviewNotifier, List<MistakesSubject>>
  AsyncNotifierProvider<MistakesTreeNotifier, MistakesTree>(sub-bio)
  AsyncNotifierProvider<NotificationsNotifier, InboxResults>(null)
  AsyncNotifierProvider<SubjectTreeNotifier, SubjectTree>(sub-bio)
  AsyncNotifierProvider<SubjectsNotifier, List<Subject>>
  AsyncNotifierProvider<SupportTicketsNotifier, SupportTicketsResults>
  FutureProvider<LegalDocumentContent>((document: LegalDocument.privacy, language: en))
  FutureProvider<LegalDocumentContent>((document: LegalDocument.terms, language: en))
  NotifierProvider<AuthController, AuthStatus>
  NotifierProvider<LocaleController, Locale>
  NotifierProvider<ThemeModeController, ThemeMode>
  Provider<CatalogRepository>
  Provider<Dio>
  Provider<GoRouter>
  Provider<LeaderboardRepository>
  Provider<LegalRepository>
  Provider<MistakesRepository>
  Provider<NotificationsRepository>
  Provider<PreferencesStore?>
  Provider<ProfileRepository>
  Provider<ReturnTarget>
  Provider<SecureStorage>
  Provider<SupportRepository>
  StreamProvider<bool>
00:12 +74: F:/level/level_up/wt_cld/test/audit_e4/c_refresh_and_signout_test.dart: C6b return target: a DIFFERENT student signing in next lands on Home, never on the previous student's location
00:12 +75: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H1b E4-04a (fixed): the same when A is still ON /learn/mistakes at the end - the provider of that very screen was listened to the whole time, and is gone after the sign-out
00:12 +76: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H1b E4-04a (fixed): the same when A is still ON /learn/mistakes at the end - the provider of that very screen was listened to the whole time, and is gone after the sign-out
00:12 +77: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H1b E4-04a (fixed): the same when A is still ON /learn/mistakes at the end - the provider of that very screen was listened to the whole time, and is gone after the sign-out
00:12 +78: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H1b E4-04a (fixed): the same when A is still ON /learn/mistakes at the end - the provider of that very screen was listened to the whole time, and is gone after the sign-out
00:12 +79: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H1b E4-04a (fixed): the same when A is still ON /learn/mistakes at the end - the provider of that very screen was listened to the whole time, and is gone after the sign-out
00:12 +80: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:12 +80: F:/level/level_up/wt_cld/test/audit_e4/g_inert_and_session_scope_test.dart: G3c every Dio call in lib/ passes a RELATIVE path, so the Bearer that AuthInterceptor attaches to every request can only ever go to the API host (never to a server-supplied absolute URL)
G3c Dio call sites scanned: 63; not a literal "/path": [lib/core/network/interceptors/auth_interceptor.dart: fetch(options), lib/features/quiz/repository/quiz_history_repository.dart: put(_favoritePath(questionId), lib/features/quiz/repository/quiz_history_repository.dart: delete(_favoritePath(questionId), lib/features/quiz/repository/quiz_history_repository.dart: get(path)]
00:12 +81: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:12 +82: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +83: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +84: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +85: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +86: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +87: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +88: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +89: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +90: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +91: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +92: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +93: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +94: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +95: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +96: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +97: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +98: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +99: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +100: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +101: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +102: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +103: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:13 +104: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +105: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +106: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +107: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +108: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +109: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +110: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +111: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +112: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +113: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +114: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +115: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +116: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +117: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +118: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +119: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +120: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +121: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +122: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +123: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +124: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +125: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +126: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +127: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +128: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +129: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +130: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:14 +131: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +131: F:/level/level_up/wt_cld/test/audit_e4/g_inert_and_session_scope_test.dart: G4 after a signed-in session over every route, a forced sign-out leaves no provider holding a student alive (E4-04/05 fixed: the catalogue, subject-tree and Mistakes-overview providers are autoDispose) - every provider added this run is dropped
G4 tokenless requests at sign-out: [GET /me]
G4 providers alive after sign-out:
  AsyncNotifierProvider<LoginNotifier, OtpRequestResult?>
  NotifierProvider<AuthController, AuthStatus>
  NotifierProvider<LocaleController, Locale>
  NotifierProvider<ThemeModeController, ThemeMode>
  Provider<CatalogRepository>
  Provider<Dio>
  Provider<GoRouter>
  Provider<LeaderboardRepository>
  Provider<LegalRepository>
  Provider<MistakesRepository>
  Provider<NotificationsRepository>
  Provider<PreferencesStore?>
  Provider<ProfileRepository>
  Provider<ReturnTarget>
  Provider<SecureStorage>
  Provider<SupportRepository>
  StreamProvider<bool>
00:15 +132: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +133: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +134: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +135: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +136: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +137: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +138: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +139: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:15 +140: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +141: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +142: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +143: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +144: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +145: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +146: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +147: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +148: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +149: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +150: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +151: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +152: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +153: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +154: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +155: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +156: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +157: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +158: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +159: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +160: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +161: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +162: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +163: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +164: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +165: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +166: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +167: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +168: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +169: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +170: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +171: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +172: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +173: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +174: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +175: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +176: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +177: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +178: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +179: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +180: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +181: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +182: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +183: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +184: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +185: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +186: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +187: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +188: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +189: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +190: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +191: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +192: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +193: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +194: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +195: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +196: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +197: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +198: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +199: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +200: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +201: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +202: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:16 +203: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +204: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +205: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +206: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +207: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +208: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +209: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +210: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +211: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +212: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +213: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +214: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +215: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +216: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +217: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +218: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +219: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +220: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +221: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +222: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +223: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +224: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +225: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +226: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +227: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +228: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +229: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +230: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +231: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +232: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +233: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +234: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +235: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +236: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +237: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +238: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +239: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +240: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +241: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +242: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +243: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +244: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +245: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +246: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +247: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +248: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +249: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +250: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +251: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +252: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +253: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +254: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +255: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +256: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +257: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +258: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +259: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +260: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +261: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +262: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +263: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +264: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +265: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +266: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +267: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +268: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +269: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +270: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +271: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +272: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +273: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +274: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +275: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +276: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +277: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +278: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:17 +279: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +280: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +281: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +282: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +283: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +284: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +285: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +286: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +287: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +288: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +289: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +290: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +291: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +292: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +293: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +294: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +295: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +296: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +297: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +298: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +299: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +300: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +301: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +302: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +303: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +304: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +305: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +306: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +307: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +308: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +309: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +310: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +311: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +312: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +313: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +314: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +315: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +316: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +317: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +318: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +319: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +320: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +321: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +322: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +323: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +324: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:18 +325: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +326: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +327: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +328: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +329: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +330: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +331: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +332: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +333: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +334: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +335: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +336: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +337: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +338: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +339: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +340: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +341: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +342: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +343: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:19 +344: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +345: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +346: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +347: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +348: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +349: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +350: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +351: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +352: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +353: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +354: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +355: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +356: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +357: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +358: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +359: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +360: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +361: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +362: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +363: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:20 +364: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +365: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +366: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +367: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +368: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +369: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +370: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +371: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +372: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +373: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +374: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +375: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +376: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +377: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +378: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +379: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +380: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +381: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +382: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +383: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +384: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +385: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +386: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +387: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:21 +388: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:22 +389: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:23 +390: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:23 +391: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:23 +392: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:23 +393: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:23 +394: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:24 +395: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:24 +396: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:24 +397: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +398: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +399: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +400: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +401: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +402: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +403: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +404: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +405: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +406: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +407: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +408: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +409: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +410: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +411: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +412: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +413: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +414: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +415: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +416: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +417: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +418: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +419: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +420: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +421: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +422: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +423: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +424: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +425: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +426: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +427: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +428: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +429: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +430: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +431: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +432: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +433: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +434: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +435: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +436: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +437: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:25 +438: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:26 +438: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell a signed-out cold start at a shell location bounces to /login and signs in to /home ΓÇö no session ended in this process, so there is no owner to match (O-10)
unhandled element <filter/>; Picture key: Svg loader
00:26 +439: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:26 +440: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:26 +441: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:26 +442: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:26 +443: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
00:26 +444: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
T6[healthy] -> /home
T6[healthy] -> /leaderboard
T6[healthy] -> /learn
T6[healthy] -> /learn/mistakes
00:26 +445: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6a sweep, healthy server
T6[healthy] -> /learn/subject/sub-bio
T6[healthy] -> /learn/mistakes/subject/sub-bio
T6[healthy] -> /message
T6[healthy] -> /account
T6[healthy] -> /profile
T6[healthy] -> /profile/edit
T6[healthy] -> /settings
T6[healthy] -> /refer
T6[healthy] -> /support
T6[healthy] -> /support/new
T6[healthy] -> /friends
T6[healthy] -> /notifications
T6[healthy] -> /legal/privacy
T6[healthy] -> /legal/terms
T6[healthy] initial requests per route:
  /home -> (none)
  /leaderboard -> (none)
  /learn -> GET /catalog/subjects
  /learn/mistakes -> GET /me/mistakes
  /learn/subject/sub-bio -> GET /catalog/subjects/sub-bio/tree
  /learn/mistakes/subject/sub-bio -> GET /me/mistakes/subjects/sub-bio, GET /me/mistakes
  /message -> (none)
  /account -> (none)
  /profile -> (none)
  /profile/edit -> (none)
  /settings -> (none)
  /refer -> (none)
  /support -> GET /support/tickets
  /support/new -> (none)
  /friends -> (none)
  /notifications -> GET /me/notifications
  /legal/privacy -> GET /reference/legal-documents/privacy
  /legal/terms -> GET /reference/legal-documents/terms
00:26 +446: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +447: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +448: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +449: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +450: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +451: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +452: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +453: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +454: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +455: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +456: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +457: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +458: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +459: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +460: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +461: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +462: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +463: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +464: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +465: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +466: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +467: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +468: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +469: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +470: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +471: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +472: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +473: F:/level/level_up/wt_cld/test/core/router/w1_otp_args_signout_test.dart: the args end with the session after a forced sign-out, /login/otp without args of its own cannot bring the previous page back
00:26 +474: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +475: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +476: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +477: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +478: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +479: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +480: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +481: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +482: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +483: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +484: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +485: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +486: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +487: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +488: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +489: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +490: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +491: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +492: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +493: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +494: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router return-to-target ΓÇö inside the tab shell ...also when the controller is already signed out at the very first parse (the redirect meets an empty configuration): the bounce still happens and sign-in lands on /home
00:26 +495: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +496: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +497: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +498: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +499: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +500: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +501: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +502: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +503: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +504: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +505: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +506: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +507: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +508: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +509: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +510: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +511: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +512: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +513: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +514: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +515: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +516: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +517: F:/level/level_up/wt_cld/test/audit_e4/h_cross_student_state_test.dart: H5 E4-05b (fixed) [Account > Sign Out; A still on the screen]: student B sees NONE of student A's subject tree (A's units) while B's own GET .../tree is still in flight
00:27 +518: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +519: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +520: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +521: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +522: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +523: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +524: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +525: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +526: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +527: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +528: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +529: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +530: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +531: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +532: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +533: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +534: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +535: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +536: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +537: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +538: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +539: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +540: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +541: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +542: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +543: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +544: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +545: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +546: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +547: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +548: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +549: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +550: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +551: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +552: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +553: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +554: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +555: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:27 +556: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:28 +557: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:28 +558: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:28 +559: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:28 +560: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:28 +561: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:28 +562: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:28 +563: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +564: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +565: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +566: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +567: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +568: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +569: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +570: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +571: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:29 +572: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:30 +573: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:30 +574: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:30 +575: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:30 +576: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +577: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +578: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +579: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +580: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +581: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +582: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +583: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +584: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +585: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +586: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:31 +587: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +588: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +589: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +590: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +591: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +592: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +593: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +594: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +595: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +596: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +597: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +598: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +599: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +600: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:32 +601: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +602: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +603: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +604: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +605: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +606: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +607: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +608: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +609: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +610: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +611: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +612: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +613: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +614: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +615: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +616: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +617: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +618: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +619: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +620: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +621: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +622: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:33 +623: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
00:34 +624: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6b sweep, account pending deletion (every protected read is a 403 except /me): no retry, no sign-out
T6[pending-deletion] -> /home
T6[pending-deletion] -> /leaderboard
T6[pending-deletion] -> /learn
T6[pending-deletion] -> /learn/mistakes
T6[pending-deletion] -> /learn/subject/sub-bio
T6[pending-deletion] -> /learn/mistakes/subject/sub-bio
T6[pending-deletion] -> /message
T6[pending-deletion] -> /account
T6[pending-deletion] -> /profile
T6[pending-deletion] -> /profile/edit
T6[pending-deletion] -> /settings
T6[pending-deletion] -> /refer
T6[pending-deletion] -> /support
T6[pending-deletion] -> /support/new
T6[pending-deletion] -> /friends
T6[pending-deletion] -> /notifications
T6[pending-deletion] -> /legal/privacy
T6[pending-deletion] -> /legal/terms
T6[pending-deletion] initial requests per route:
  /home -> (none)
  /leaderboard -> (none)
  /learn -> GET /catalog/subjects
  /learn/mistakes -> GET /me/mistakes
  /learn/subject/sub-bio -> GET /catalog/subjects/sub-bio/tree
  /learn/mistakes/subject/sub-bio -> GET /me/mistakes/subjects/sub-bio, GET /me/mistakes
  /message -> (none)
  /account -> (none)
  /profile -> (none)
  /profile/edit -> (none)
  /settings -> (none)
  /refer -> (none)
  /support -> GET /support/tickets
  /support/new -> (none)
  /friends -> (none)
  /notifications -> GET /me/notifications
  /legal/privacy -> GET /reference/legal-documents/privacy
  /legal/terms -> GET /reference/legal-documents/terms
00:34 +625: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +626: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +627: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +628: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +629: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +630: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +631: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +632: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +633: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +634: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +635: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +636: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +637: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +638: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +639: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +640: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +641: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router not remembered ΓÇö lands on Home ...and over a shell page, what comes back is the shell page beneath it ΓÇö never the non-shell page
00:34 +642: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:34 +643: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:34 +644: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:34 +645: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:34 +646: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:34 +647: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:34 +648: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:34 +649: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:35 +650: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:35 +651: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:35 +652: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +653: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +654: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +655: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +656: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +657: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +658: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +659: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +660: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +661: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +662: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +663: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +664: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +665: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +666: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:36 +667: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +668: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +669: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +670: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +671: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +672: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +673: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +674: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +675: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +676: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +677: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +678: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +679: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +680: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +681: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +682: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +683: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +684: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +685: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +686: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +687: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +688: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:37 +689: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +690: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +691: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +692: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +693: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +694: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +695: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +696: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +697: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +698: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +699: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +700: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +701: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
00:38 +702: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6c sweep, sick server (every protected call is a 500)
T6[server-500] -> /home
T6[server-500] -> /leaderboard
T6[server-500] -> /learn
T6[server-500] -> /learn/mistakes
T6[server-500] -> /learn/subject/sub-bio
T6[server-500] -> /learn/mistakes/subject/sub-bio
T6[server-500] -> /message
T6[server-500] -> /account
T6[server-500] -> /profile
T6[server-500] -> /profile/edit
T6[server-500] -> /settings
T6[server-500] -> /refer
T6[server-500] -> /support
T6[server-500] -> /support/new
T6[server-500] -> /friends
T6[server-500] -> /notifications
T6[server-500] -> /legal/privacy
T6[server-500] -> /legal/terms
T6[server-500] initial requests per route:
  /home -> (none)
  /leaderboard -> (none)
  /learn -> GET /catalog/subjects
  /learn/mistakes -> GET /me/mistakes
  /learn/subject/sub-bio -> GET /catalog/subjects/sub-bio/tree
  /learn/mistakes/subject/sub-bio -> GET /me/mistakes/subjects/sub-bio, GET /me/mistakes
  /message -> (none)
  /account -> (none)
  /profile -> (none)
  /profile/edit -> (none)
  /settings -> (none)
  /refer -> (none)
  /support -> GET /support/tickets
  /support/new -> (none)
  /friends -> (none)
  /notifications -> GET /me/notifications
  /legal/privacy -> GET /reference/legal-documents/privacy
  /legal/terms -> GET /reference/legal-documents/terms
00:38 +703: F:/level/level_up/wt_cld/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:38 +704: F:/level/level_up/wt_cld/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:38 +705: F:/level/level_up/wt_cld/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:38 +706: F:/level/level_up/wt_cld/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:38 +707: F:/level/level_up/wt_cld/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:38 +708: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +709: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +710: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +711: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +712: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +713: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +714: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +715: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +716: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +717: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +718: F:/level/level_up/wt_cld/test/core/widgets/w4_study_progress_row_grows_test.dart: en 2.0x ┬╖ the counter is drawn WHOLE: its box holds its natural line
00:39 +719: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +720: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +721: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +722: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +723: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +724: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +725: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +726: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +727: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:39 +728: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +729: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +730: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +731: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +732: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +733: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +734: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +735: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +736: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +737: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +738: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +739: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +740: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +741: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +742: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +743: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +744: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +745: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +746: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +747: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +748: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +749: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +750: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +751: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +752: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:40 +753: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +754: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +755: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +756: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +757: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +758: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +759: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +760: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +761: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +762: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +763: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +764: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +765: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:41 +766: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +767: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +768: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +769: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +770: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +771: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +772: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +773: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +774: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +775: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +776: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +777: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +778: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +779: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +780: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +781: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +782: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +783: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +784: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +785: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +786: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +787: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +788: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +789: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +790: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +791: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +792: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +793: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +794: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +795: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +796: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +797: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +798: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +799: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:42 +800: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +801: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +802: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +803: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +804: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +805: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +806: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +807: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +808: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +809: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
00:43 +810: F:/level/level_up/wt_cld/test/audit_e4/f_timers_and_repeats_test.dart: T6d sweep, dead network (every protected call fails at the transport)
T6[dead-network] -> /home
T6[dead-network] -> /leaderboard
T6[dead-network] -> /learn
T6[dead-network] -> /learn/mistakes
T6[dead-network] -> /learn/subject/sub-bio
T6[dead-network] -> /learn/mistakes/subject/sub-bio
T6[dead-network] -> /message
T6[dead-network] -> /account
T6[dead-network] -> /profile
T6[dead-network] -> /profile/edit
T6[dead-network] -> /settings
T6[dead-network] -> /refer
T6[dead-network] -> /support
T6[dead-network] -> /support/new
T6[dead-network] -> /friends
T6[dead-network] -> /notifications
T6[dead-network] -> /legal/privacy
T6[dead-network] -> /legal/terms
T6[dead-network] initial requests per route:
  /home -> (none)
  /leaderboard -> (none)
  /learn -> GET /catalog/subjects
  /learn/mistakes -> GET /me/mistakes
  /learn/subject/sub-bio -> GET /catalog/subjects/sub-bio/tree
  /learn/mistakes/subject/sub-bio -> GET /me/mistakes/subjects/sub-bio, GET /me/mistakes
  /message -> (none)
  /account -> (none)
  /profile -> (none)
  /profile/edit -> (none)
  /settings -> (none)
  /refer -> (none)
  /support -> GET /support/tickets
  /support/new -> (none)
  /friends -> (none)
  /notifications -> GET /me/notifications
  /legal/privacy -> GET /reference/legal-documents/privacy
  /legal/terms -> GET /reference/legal-documents/terms
00:43 +811: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student A is returned to the nested location after a forced sign-out ΓÇö and again after a SECOND one from there
00:43 +812: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student A is returned to the nested location after a forced sign-out ΓÇö and again after a SECOND one from there
00:43 +813: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student A is returned to the nested location after a forced sign-out ΓÇö and again after a SECOND one from there
00:43 +814: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student A is returned to the nested location after a forced sign-out ΓÇö and again after a SECOND one from there
00:43 +815: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student A is returned to the nested location after a forced sign-out ΓÇö and again after a SECOND one from there
00:43 +816: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student B signing in after student A was forced out lands on Home
00:43 +817: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student B signing in after student A was forced out lands on Home
00:43 +818: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student B signing in after student A was forced out lands on Home
00:43 +819: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student B signing in after student A was forced out lands on Home
00:43 +820: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student B signing in after student A was forced out lands on Home
00:43 +821: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router O-10 ΓÇö the return target belongs to the student whose session ended a session that signed in here binds by the id it signed in with, with no /me student B signing in after student A was forced out lands on Home
00:44 +822: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /message still lands on /login when remember and clear throw
00:44 +823: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +824: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +825: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +826: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +827: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +828: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +829: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +830: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +831: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +832: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +833: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +834: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +835: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +836: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router a failing return target cannot stop the bounce a forced sign-out from /settings still lands on /login when remember and clear throw
00:44 +837: F:/level/level_up/wt_cld/test/dev/mock_backend_notifications_test.dart: GET /me/notifications - validation a cursor this mock did not issue is 400 on `cursor`
00:44 +838: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +839: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +840: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +841: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +842: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +843: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +844: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +845: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +846: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +847: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +848: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +849: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +850: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-in unknown location shows the shared error state with genericError and no Retry (EN, LTR)
00:44 +851: F:/level/level_up/wt_cld/test/dev/mock_backend_notifications_test.dart: POST /me/notifications/{id}/read marking an already-read row leaves its readAt alone
00:44 +852: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +853: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +854: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +855: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +856: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +857: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +858: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +859: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the same screen in Arabic (RTL), still without Retry
00:44 +860: F:/level/level_up/wt_cld/test/dev/mock_backend_notifications_test.dart: the real notifier over the mock All: 16 rows on page one, 19 after Load more, none ignored
00:44 +861: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the DARK theme renders the same error state without exceptions (EN)
00:44 +862: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the DARK theme renders the same error state without exceptions (EN)
00:44 +863: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the DARK theme renders the same error state without exceptions (EN)
00:44 +864: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the DARK theme renders the same error state without exceptions (EN)
00:44 +865: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder the DARK theme renders the same error state without exceptions (EN)
00:45 +866: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back with nothing to pop goes Home
00:45 +867: F:/level/level_up/wt_cld/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:45 +868: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +869: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +870: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +871: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +872: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +873: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +874: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +875: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +876: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +877: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder back pops when the unknown location was pushed over a screen
00:45 +878: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: through the real router errorBuilder a signed-out cold start at an unknown location goes to /login, not the error screen
00:45 +879: F:/level/level_up/wt_cld/test/core/router/return_target_test.dart: (tearDownAll)
00:45 +879: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_history_test.dart: the six quiz-history operations answer through buildMockDio
00:45 +880: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_history_test.dart: GET /catalog/modules follows the mock session track
00:45 +881: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_history_test.dart: the quiz-engine routes around the new ones still work
00:46 +882: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:46 +883: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:46 +884: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable ΓÇö the 159:1852 variant
00:46 +885: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:46 +886: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:46 +887: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:46 +888: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:46 +889: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:46 +890: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:46 +891: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:46 +892: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:46 +893: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:46 +894: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent ΓÇö a repeat call replays the same summary
00:46 +895: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me ΓÇö what invalidating the profile shows
00:46 +896: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered ΓÇö expected, not a bug
00:46 +897: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 ΓÇö the polling path is walkable
00:46 +898: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:46 +899: F:/level/level_up/wt_cld/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:47 +900: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order 22 tickets page 20 / 2 by cursor, and hasMore says when to stop
00:47 +901: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order most recently active first, ties by ticketId descending
00:47 +902: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order references run TK-1001 (oldest) to TK-1022 (newest)
00:47 +903: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order timestamps are fixed UTC instants in 2026-09 / 2026-10
00:47 +904: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order the statuses cover all four known values and one the app does not know
00:47 +905: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order the frame samples are in the list
00:47 +906: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order one subject runs close to the 120-character limit
00:47 +907: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order the wire shape is the six contract fields
00:47 +908: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - paging and order the request carries no limit and the mock does not need one
00:47 +909: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - cursor a malformed cursor is 400 validation_failed on field cursor
00:47 +910: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - cursor a cursor issued for a thread is not a ticket-list cursor
00:47 +911: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets - cursor a ticket that moves to the top between pages cannot repeat a row
00:47 +912: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId} an open ticket: details, closedAt null, the contract fields
00:47 +913: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId} a closed ticket carries its closedAt
00:47 +914: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId} the wire shape is the nine contract fields, attachments empty
00:47 +915: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId} an unknown id is 404 not_found
00:47 +916: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId} a malformed id is the same 404
00:47 +917: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages the long thread has 25 replies: pages of 20 then 5, oldest first
00:47 +918: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages replies mix student and staff
00:47 +919: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages a ticket with no replies answers an empty, final page
00:47 +920: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages other tickets hold 0 to 3 replies
00:47 +921: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages the wire shape is the five contract fields, attachments empty
00:47 +922: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages the opening text is NOT a message
00:47 +923: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages an unknown ticket is 404 not_found
00:47 +924: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages a malformed cursor is 400 validation_failed on field cursor
00:47 +925: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: GET /support/tickets/{ticketId}/messages another ticket's cursor is not this ticket's cursor
00:47 +926: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets creates an open ticket that appears first in the list
00:47 +927: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets it can then be read and replied to
00:47 +928: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets references keep counting
00:47 +929: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets subject and details are stored TRIMMED
00:47 +930: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets the response wire shape has the nine contract fields
00:47 +931: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets validation - 400 validation_failed with a field map an empty or whitespace-only subject
00:47 +932: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets validation - 400 validation_failed with a field map an empty or whitespace-only details
00:47 +933: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets validation - 400 validation_failed with a field map both bad: both fields are named
00:47 +934: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets validation - 400 validation_failed with a field map missing keys and non-string values
00:47 +935: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets validation - 400 validation_failed with a field map subject: 120 characters pass, 121 do not - after trimming
00:47 +936: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets validation - 400 validation_failed with a field map details: 4000 characters pass, 4001 do not - after trimming
00:47 +937: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets validation - 400 validation_failed with a field map a rejected create writes nothing and spends no budget
00:47 +938: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets the daily limit - 429 rate_limited 5 creates per session, then 429 with Retry-After
00:47 +939: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets the daily limit - 429 rate_limited the refused create writes nothing
00:47 +940: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets the daily limit - 429 rate_limited it stays 429 for every later create, valid or not
00:47 +941: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets the daily limit - 429 rate_limited replies have their own budget: a reply still works
00:47 +942: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets the daily limit - 429 rate_limited a new session starts with a fresh budget
00:47 +943: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages creates a student reply, appended last in the thread
00:47 +944: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages the body is stored TRIMMED
00:47 +945: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages the ticket moves to the top and its lastActivityAt is the reply's createdAt
00:47 +946: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages a reply on the long thread makes it 26: pages of 20 then 6
00:47 +947: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages the response wire shape has the five contract fields
00:47 +948: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages a ticket whose status the app does not know still takes replies
00:47 +949: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages a closed ticket is 409 ticket_closed and nothing is written
00:47 +950: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages the closed check comes before the content check
00:47 +951: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages an unknown ticket is 404 not_found
00:47 +952: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages validation - 400 validation_failed on field body empty, whitespace-only, missing and non-string
00:47 +953: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages validation - 400 validation_failed on field body 4000 characters pass, 4001 do not - after trimming
00:47 +954: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: POST /support/tickets/{ticketId}/messages validation - 400 validation_failed on field body a rejected reply writes nothing
00:47 +955: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: the fixtures are neutral sample data no e-mail address and no phone-like number anywhere
00:47 +956: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:47 +957: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:47 +958: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:47 +959: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:47 +960: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:47 +961: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:47 +962: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:47 +963: F:/level/level_up/wt_cld/test/dev/mock_backend_support_test.dart: sessions are independent a create and a reply in one session do not show in another
00:47 +964: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 ┬º2)
00:47 +965: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:47 +966: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:47 +967: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:47 +968: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected ΓÇö the coded list is Egyptian
00:47 +969: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register echoes inviteCodeApplied a request with no inviteCode gets no inviteCodeApplied key
00:47 +970: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register echoes inviteCodeApplied the recognised code answers true
00:47 +971: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register echoes inviteCodeApplied case, spaces and hyphens are ignored, as on the real server
00:47 +972: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register echoes inviteCodeApplied any other code answers false and STILL creates the account
00:47 +973: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: POST /auth/register echoes inviteCodeApplied the field parses through the AuthResult model
00:47 +974: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:47 +975: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:47 +976: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:47 +977: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:47 +978: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 ΓÇö the split is easy to get backwards
00:47 +979: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:47 +980: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:47 +981: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:47 +982: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:47 +983: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:47 +984: F:/level/level_up/wt_cld/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:48 +985: F:/level/level_up/wt_cld/test/dev/mock_backend_w3d_hooks_test.dart: PUT /me/fcm-token a token is accepted (204) through the real repository
00:48 +986: F:/level/level_up/wt_cld/test/dev/mock_backend_w3d_hooks_test.dart: PUT /me/fcm-token an empty token is 400 validation_failed on field token
00:48 +987: F:/level/level_up/wt_cld/test/dev/mock_backend_w3d_hooks_test.dart: PUT /me/fcm-token a token over 4096 characters is 400 on field token
00:48 +988: F:/level/level_up/wt_cld/test/dev/mock_backend_w3d_hooks_test.dart: PUT /me/fcm-token the lifecycle registers a fake gateway's token, and the Noop registers nothing
00:48 +989: F:/level/level_up/wt_cld/test/dev/mock_backend_w3d_hooks_test.dart: GET /me/invite serves the fixture, which parses into the real MyInvite
00:48 +990: F:/level/level_up/wt_cld/test/dev/mock_backend_w3d_hooks_test.dart: POST /me/track-transfer the stock school student (secondary2) is 403 not_eligible
00:48 +991: F:/level/level_up/wt_cld/test/dev/mock_backend_w3d_hooks_test.dart: POST /me/track-transfer a university student is 409 not_allowed
00:48 +992: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: dormant until a request is recorded - nothing changes before it no pending state, and the profile comes back untouched
00:49 +993: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: dormant until a request is recorded - nothing changes before it NO route is denied: every method and path falls through
00:49 +994: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: POST - requestAccountDeletion 202 with {requestedAt, effectiveAt}, effectiveAt = requestedAt + 30 days, both UTC
00:49 +995: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: POST - requestAccountDeletion a second request is 409 deletion_already_requested and moves nothing
00:49 +996: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: DELETE - cancelAccountDeletion 204 with no body, and the account is not pending any more
00:49 +997: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: DELETE - cancelAccountDeletion with nothing pending it is 404 no_pending_deletion
00:49 +998: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: DELETE - cancelAccountDeletion cancelling twice: 204 then 404
00:49 +999: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: DELETE - cancelAccountDeletion a new request after a cancel opens a fresh window
00:49 +1000: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: GET /me carries pendingDeletion only while pending present as {effectiveAt} - parsed by the real PendingDeletion
00:49 +1001: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: GET /me carries pendingDeletion only while pending the key is ABSENT again after a cancel - never null
00:49 +1002: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: GET /me carries pendingDeletion only while pending decorating does not mutate the profile it was given
00:49 +1003: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: default-deny while pending (openapi.yaml:63-83) the allowlist is exactly the contract's four
00:49 +1004: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: default-deny while pending (openapi.yaml:63-83) the four allowlisted calls are never denied
00:49 +1005: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: default-deny while pending (openapi.yaml:63-83) every other authenticated call is 403 account_pending_deletion
00:49 +1006: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: default-deny while pending (openapi.yaml:63-83) the anonymous ladder and the public reads are outside the rule
00:49 +1007: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: default-deny while pending (openapi.yaml:63-83) lifted by a cancel: the same call is let through again
00:49 +1008: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: default-deny while pending (openapi.yaml:63-83) the denial is recognised by the app's one predicate
00:49 +1009: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: routing only POST and DELETE answer on the deletion path - other methods there are not deletion operations, pending or not
00:49 +1010: F:/level/level_up/wt_cld/test/dev/mock_deletion_test.dart: through buildMockDio and the real repository request, then default-deny, then cancel - on one mock session
00:49 +1011: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends 22 friends page 20 / 2 by cursor, and hasMore says when to stop
00:49 +1012: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends ordered by name, ties broken by studentId
00:49 +1013: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends every fifth friend hides their score: points is OMITTED, not null
00:49 +1014: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends decodes through the real model: level is an int, friendsSince is UTC
00:49 +1015: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends the names are the invented board peers mock_backend already serves
00:49 +1016: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends a walk survives the last row of page one being removed (keyset)
00:49 +1017: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cursors a cursor from another list is 400 validation_failed on cursor
00:49 +1018: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cursors a cursor for the other direction is rejected too
00:49 +1019: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cursors "AAAA" is not a cursor this API issued
00:49 +1020: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cursors "not base64 !!" is not a cursor this API issued
00:49 +1021: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cursors "" is not a cursor this API issued
00:49 +1022: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cursors a cursor that is not a string is rejected
00:49 +1023: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends/suggestions bounded: 100 students in total across five pages of 20
00:49 +1024: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends/suggestions never the caller, a friend, a requester or a blocked student
00:49 +1025: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends/suggestions a card is name and avatar only - no points, level or phone
00:49 +1026: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends/suggestions the bound slides: a student who drops out is replaced by the next
00:49 +1027: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends/suggestions blocking a suggestion removes them from the list
00:49 +1028: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friends/suggestions one suggestion is long enough to wrap
00:49 +1029: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friend-requests direction is REQUIRED
00:49 +1030: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friend-requests direction must be incoming or outgoing
00:49 +1031: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friend-requests incoming: 22 requests page 20 / 2, newest first
00:49 +1032: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friend-requests outgoing: one short page naming the recipients
00:49 +1033: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: GET /friend-requests the other party is a card - no points, level or phone
00:49 +1034: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests sends a request: 201 pending, and it heads the outgoing list
00:49 +1035: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests and still heads the list when the device clock is behind the fixtures
00:49 +1036: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests the suggestion is gone from the list once asked
00:49 +1037: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests asking again is 409 friend_request_already_pending
00:49 +1038: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests asking the recipient of an existing outgoing request is 409 pending
00:49 +1039: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests asking a friend is 409 already_friends
00:49 +1040: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests asking someone who already asked ACCEPTS theirs: 201 accepted
00:49 +1041: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests the target is unavailable: ONE answer for six different causes
00:49 +1042: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests through the app: 404 friend_target_unavailable
00:49 +1043: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests a student who left since the list was served: refused, then unlisted
00:49 +1044: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests a missing studentId is 400 validation_failed on studentId
00:49 +1045: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /friend-requests a studentId that is not a UUID is 400 validation_failed
00:49 +1046: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline cancel removes an outgoing request: 204, then 404 friend_request_not_found
00:49 +1047: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline cancel is sender only: an INCOMING request id is not found, and stays
00:49 +1048: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline accept makes a friend: 200 Friend, the request is gone, the list grows
00:49 +1049: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline accept is recipient only: an OUTGOING request id is not found
00:49 +1050: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline accept when the sender has left: request deleted, 404 friend_target_unavailable
00:49 +1051: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline decline deletes the request: 204, then 404; the sender may ask again
00:49 +1052: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline decline is recipient only: an OUTGOING request id is not found
00:50 +1053: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: cancel, accept and decline a malformed request id is the same answer as an unknown one
00:50 +1054: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: DELETE /friends/{studentId} removes a friend: 204, and they can be asked again
00:50 +1055: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: DELETE /friends/{studentId} idempotent: 204 for a non-friend, an unknown id and the caller
00:50 +1056: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks 21 blocked students page 20 / 1, most recently blocked first
00:50 +1057: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks a block lands at the top of the list
00:50 +1058: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks and still does when the device clock is behind the fixtures
00:50 +1059: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks blocking is idempotent: no duplicate row
00:50 +1060: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks blocking a friend ends the friendship
00:50 +1061: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks blocking removes a pending request in either direction
00:50 +1062: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks a blocked student cannot be asked: the same 404 as any unavailable target
00:50 +1063: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks 204 for every well-formed id, storing nothing for an unknown or own one
00:50 +1064: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks a block of a student on the other Track is stored but never listed
00:50 +1065: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks unblock is idempotent 204 and restores nothing
00:50 +1066: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: blocks a missing or malformed studentId is 400 validation_failed
00:50 +1067: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /student-reports 202 for every well-formed id; stored only for a real, different student
00:50 +1068: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /student-reports a repeat stores nothing
00:50 +1069: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /student-reports reporting changes no list: it is not a block and not an unfriend
00:50 +1070: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: POST /student-reports a missing or malformed studentId is 400 validation_failed
00:50 +1071: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits 31 social writes inside a minute: the 31st is 429 with Retry-After
00:50 +1072: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits Retry-After counts down with the window
00:50 +1073: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits every kind of social write spends the one budget
00:50 +1074: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: university answers the four fixture modules
00:50 +1075: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: university answers the four fixture modules
00:50 +1076: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: university answers the four fixture modules
00:50 +1077: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits a refused write spends nothing
00:50 +1078: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits a refused write spends nothing
00:50 +1079: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits a refused write spends nothing
00:50 +1080: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: university a subject is filed in at most one module, and one in none
00:50 +1081: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits reports have their OWN budget, apart from the social one
00:50 +1082: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits reports have their OWN budget, apart from the social one
00:50 +1083: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits reports have their OWN budget, apart from the social one
00:50 +1084: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: rate limits reports have their OWN budget, apart from the social one
00:50 +1085: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: the mock backend's own university catalog every filed subject exists in GET /catalog/subjects
00:50 +1086: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: the mock backend's own university catalog every filed subject exists in GET /catalog/subjects
00:50 +1087: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: the mock backend's own university catalog every filed subject exists in GET /catalog/subjects
00:50 +1088: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: the mock backend's own university catalog every filed subject exists in GET /catalog/subjects
00:50 +1089: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: the shape of the mock a route or a method it does not serve is null, so the harness keeps looking
00:50 +1090: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: routing serves GET /catalog/modules and nothing else
00:50 +1091: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: the shape of the mock state is per graph: a fresh session starts from the fixtures again
00:50 +1092: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: routing a route it does not serve is the interceptor's generic 404
00:50 +1093: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: the shape of the mock no phone number appears anywhere in the fixtures
00:50 +1094: F:/level/level_up/wt_cld/test/dev/mock_friends_test.dart: the shape of the mock no phone number appears anywhere in the fixtures
00:50 +1095: F:/level/level_up/wt_cld/test/dev/mock_modules_test.dart: decodes through the real model, keys and nulls included
00:50 +1096: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: a valid token is stored and answered 204
00:50 +1097: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: a valid token a repeat is 204 too: the call is idempotent
00:50 +1098: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: a valid token one token per session, the latest wins
00:50 +1099: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: a valid token 4096 characters is the longest accepted
00:50 +1100: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: a valid token the reply is 204 with no body
00:50 +1101: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: 400 validation_failed on field token an empty token
00:50 +1102: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: 400 validation_failed on field token a whitespace-only token
00:50 +1103: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: 400 validation_failed on field token a token longer than 4096 characters
00:50 +1104: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: 400 validation_failed on field token an absent token
00:50 +1105: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: 400 validation_failed on field token a token that is not a string
00:50 +1106: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: 400 validation_failed on field token a refusal stores nothing and keeps the previous token
00:50 +1107: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: only that one route is served other methods on the path fall through
00:50 +1108: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: only that one route is served other paths fall through
00:50 +1109: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: only that one route is served an unserved route is a 404 through the harness
00:50 +1110: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: the lifecycle against the mock a gateway with a token registers it once per sign-in
00:50 +1111: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: the lifecycle against the mock a rotation replaces the token on the mock
00:50 +1112: F:/level/level_up/wt_cld/test/dev/mock_push_test.dart: the lifecycle against the mock the Noop gateway never reaches the mock
00:51 +1113: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order 26 quizzes page 20 / 6 by cursor, and hasMore says when to stop
00:51 +1114: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order ordered by when each was STARTED, with the id as the tie-break
00:51 +1115: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order only FINISHED quizzes are listed: the open one is absent
00:51 +1116: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order timestamps are fixed UTC instants in 2026-09 / 2026-10
00:51 +1117: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order all three modes appear, and only a normal quiz names a subject
00:51 +1118: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order a normal quiz whose subject is gone reads as an empty name
00:51 +1119: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order scopeName: a label for one pooled mode and empty for the other
00:51 +1120: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order limit is honoured
00:51 +1121: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order a limit outside 1..100 is a 400 on `limit`, never clamped
00:51 +1122: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order a cursor this mock did not issue is a 400 on `cursor`
00:51 +1123: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order a FAVOURITES cursor is foreign to the history list
00:51 +1124: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order a bad limit AND a bad cursor are reported together
00:51 +1125: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes - paging and order no finished quiz at all is an empty page, not an error
00:51 +1126: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review a finished quiz answers the full review
00:51 +1127: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review an unanswered question reveals NOTHING; an answered one does
00:51 +1128: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review right, wrong and unanswered are all reachable
00:51 +1129: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review explanationAvailable: always false unanswered, not always true answered
00:51 +1130: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review the totals match the history row, and the recount matches the score
00:51 +1131: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review a question whose content is gone is omitted; the totals stay frozen
00:51 +1132: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review subjectName: null in the review, empty in the history
00:51 +1133: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review an unknown, malformed or foreign id is ONE 403 insufficient_scope
00:51 +1134: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review the open quiz is 403 quiz_not_finished, after the ownership check
00:51 +1135: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review there is no 404 for a quiz id
00:51 +1136: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /quizzes/{quizId} - the review a review reflects favourites live
00:51 +1137: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE 22 favourites page 20 / 2 by cursor, most recently favourited first
00:51 +1138: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE a row carries a stem and a subject, and never an answer
00:51 +1139: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE PUT adds a question to the top of the list
00:51 +1140: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE PUT is idempotent: a repeat keeps the original favoritedAt
00:51 +1141: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE DELETE removes a question; a repeat and a non-favourite are fine
00:51 +1142: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE the writes answer a real 204 with no body
00:51 +1143: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE an id outside the bank is a 204 and leaves no row
00:51 +1144: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE the cursor is a keyset: an unfavourite between pages repeats nothing
00:52 +1145: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE limit is honoured; outside 1..100 is a 400 on `limit`
00:52 +1146: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE a cursor this mock did not issue, or another list's, is a 400
00:52 +1147: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: favourites - GET /me/favorites, PUT and DELETE no favourite at all is an empty page, not an error
00:52 +1148: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /me/quiz-summary counts DISTINCT questions answered correctly, finished or not
00:52 +1149: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /me/quiz-summary with no finished quiz it still counts the open quiz
00:52 +1150: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /me/quiz-summary is not a count of favourites or of history rows
00:52 +1151: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: GET /me/quiz-summary is a non-negative integer, as the contract bounds it
00:52 +1152: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: routing serves exactly its six operations and nothing else
00:52 +1153: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: routing leaves the quiz-engine routes to the interceptor
00:52 +1154: F:/level/level_up/wt_cld/test/dev/mock_quiz_history_test.dart: routing two sessions start from the same fixtures
00:52 +1155: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 1 - startRecovery 200, and the body parses into the REAL model
00:52 +1156: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 1 - startRecovery the masked number is masked: it ends in four digits and shows no full number
00:52 +1157: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 1 - startRecovery every start issues a new recovery id
00:52 +1158: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 1 - startRecovery the unknown phone is 404 recovery_unavailable
00:52 +1159: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 1 - startRecovery the throttled phone is 429 otp_throttled
00:52 +1160: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 1 - startRecovery a phone that is not E.164 (or is absent) is 400 validation_failed on phone
00:52 +1161: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 2 - verifyParentOtp a correct code is 200 with a rebind token, parsed by the REAL model
00:52 +1162: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 2 - verifyParentOtp the magic codes are the documented errors
00:52 +1163: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 2 - verifyParentOtp a wrong code does not spend the recovery id: the right one still works afterwards
00:52 +1164: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 2 - verifyParentOtp the recovery id is spent by a correct code
00:52 +1165: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 2 - verifyParentOtp an id this mock did not issue is 401 registration_token_invalid
00:52 +1166: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 2 - verifyParentOtp a code that is not 6 characters is 400 validation_failed on code
00:52 +1167: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 3 - submitNewPhone 202 with the code timing, parsed by the existing OtpRequestResult
00:52 +1168: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 3 - submitNewPhone a number that belongs to another account is 409 phone_already_registered, and the token survives it
00:52 +1169: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 3 - submitNewPhone the throttled phone is 429 otp_throttled here too (step 3 documents the 429), and the token survives it
00:52 +1170: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 3 - submitNewPhone a malformed number is 400 validation_failed on newPhone
00:52 +1171: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 3 - submitNewPhone a rebind token this mock did not issue is 401 registration_token_invalid
00:52 +1172: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 3 - submitNewPhone a recovery id is not a rebind token
00:52 +1173: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 4 - confirmRecovery a correct code authenticates the student on the NEW phone
00:52 +1174: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 4 - confirmRecovery the rebind token is spent: a replay is 401 registration_token_invalid
00:52 +1175: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 4 - confirmRecovery the magic codes are the documented errors, and none spends the token
00:52 +1176: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 4 - confirmRecovery a missing or malformed device, or a short code, is 400 validation_failed
00:52 +1177: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: step 4 - confirmRecovery a token this mock did not issue is 401 registration_token_invalid
00:52 +1178: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: routing only POST, only the four recovery paths
00:52 +1179: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: the mock encodes no lock: the same wrong code can be sent over and over and is answered the same way every time
00:52 +1180: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: through buildMockDio and the real repository the whole ladder, ending in an authenticated session
00:52 +1181: F:/level/level_up/wt_cld/test/dev/mock_recovery_test.dart: through buildMockDio and the real repository each documented failure arrives typed, through the real ErrorInterceptor
00:52 +1182: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: the fixture parses into the real MyInvite
00:52 +1183: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: the code satisfies the contract's own pattern
00:52 +1184: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: the counts obey the contract: non-negative, points not above 10 each
00:52 +1185: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: the points are deliberately NOT 10 x friends: the server figure is shown
00:52 +1186: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: stateless: every call returns the same record
00:52 +1187: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: only that one route is served other methods fall through
00:52 +1188: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: only that one route is served other paths fall through
00:52 +1189: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: only that one route is served an unserved route is a 404 through the harness
00:52 +1190: F:/level/level_up/wt_cld/test/dev/mock_referral_test.dart: the reply is a 200 with the three contract keys and nothing else
00:53 +1191: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: GET - the states of the contract starts not accepted, with a version configured
00:53 +1192: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: GET - the states of the contract nothing configured: currentVersion null, isCurrent false (inert)
00:53 +1193: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: GET - the states of the contract accepted and current
00:53 +1194: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: GET - the states of the contract an older acceptance does not make the student current
00:53 +1195: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms the current version is recorded: 204, then the GET agrees
00:53 +1196: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms idempotent: a repeat is 204 and the FIRST acceptance time stands
00:53 +1197: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms a later version is a new record; the earlier one is replaced as "most recent" and the student is not current until they accept
00:53 +1198: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms a different version is 400 validation_failed on termsVersion, and nothing is recorded
00:53 +1199: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms an empty version is 400 validation_failed on termsVersion, and nothing is recorded
00:53 +1200: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms a number is 400 validation_failed on termsVersion, and nothing is recorded
00:53 +1201: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms null is 400 validation_failed on termsVersion, and nothing is recorded
00:53 +1202: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms an absent termsVersion is 400 validation_failed
00:53 +1203: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms the refusal never names the required version
00:53 +1204: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: POST - acceptTerms with no version configured, ANY version is refused
00:53 +1205: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: routing only the one path, only GET and POST
00:53 +1206: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: through buildMockDio and the real repository read, accept, read again; a stale version is a typed 400
00:53 +1207: F:/level/level_up/wt_cld/test/dev/mock_terms_test.dart: the Terms document and the acceptance agree on the version both mocks name the same Terms version
00:53 +1208: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: a valid transfer by a final-year school student is accepted and carries the chosen University block
00:53 +1209: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: a valid transfer by a final-year school student any ACTIVE year may be chosen, not only the first
00:53 +1210: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: a valid transfer by a final-year school student the block decodes as a ProfileUniversity
00:53 +1211: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: the contract's order of refusals 409 track_transfer_not_allowed comes first: already University
00:53 +1212: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: the contract's order of refusals 403 track_transfer_not_eligible comes before body validation
00:53 +1213: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: the contract's order of refusals an unknown stage cannot be proven eligible
00:53 +1214: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: the contract's order of refusals 400 only once the student is eligible
00:53 +1215: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: the contract's order of refusals a refused call changes nothing: the desk keeps no state
00:53 +1216: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field every id missing
00:53 +1217: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field an id that is not a UUID
00:53 +1218: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field an id that is not a string
00:53 +1219: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field an unknown university
00:53 +1220: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field a faculty outside the university
00:53 +1221: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field a study year that is not a year of that faculty
00:53 +1222: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field a `soon` study year is refused
00:53 +1223: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field acknowledgeIrreversible missing
00:53 +1224: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field acknowledgeIrreversible must be the boolean true
00:53 +1225: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: 400 validation_failed names the field several problems are reported together
00:53 +1226: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: only that one route is served other methods on the path fall through
00:53 +1227: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: only that one route is served other paths fall through
00:53 +1228: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: through the real repository a final-year student transfers once, then the account is University and a second attempt is 409
00:53 +1229: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: through the real repository a school student below the final year gets 403 not_eligible
00:54 +1230: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: through the real repository a university student gets 409 not_allowed
00:54 +1231: F:/level/level_up/wt_cld/test/dev/mock_track_transfer_test.dart: through the real repository a bad id arrives as a ValidationException on that field, and the track does not move
00:54 +1232: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:55 +1233: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:55 +1234: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:55 +1235: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:55 +1236: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:55 +1237: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:55 +1238: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 60 tall, as drawn
00:55 +1239: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 360.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1240: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 60 tall, as drawn
00:55 +1241: F:/level/level_up/wt_cld/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` authenticated ΓåÆ AuthenticatedResult with parsed tokens + opaque profile
00:55 +1242: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1243: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1244: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1245: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1246: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1247: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1248: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1249: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1250: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1251: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ en ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1252: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 360.0 dp ┬╖ ar ┬╖ 1.0x ┬╖ exactly 60 tall, as drawn
00:55 +1253: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 360.0 dp ┬╖ ar ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1254: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ ar ┬╖ 1.0x ┬╖ exactly 60 tall, as drawn
00:55 +1255: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: the 60 is a floor, not a height (RESPONSIVE #6) 402.0 dp ┬╖ ar ┬╖ 2.0x ┬╖ a long label wraps INSIDE the button
00:55 +1256: F:/level/level_up/wt_cld/test/features/account_shells/disabled_action_button_test.dart: in a BOUNDED parent it is still exactly 60, not the room
00:56 +1257: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1258: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1259: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1260: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1261: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1262: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1263: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1264: F:/level/level_up/wt_cld/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:57 +1265: F:/level/level_up/wt_cld/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:58 +1266: F:/level/level_up/wt_cld/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:58 +1267: F:/level/level_up/wt_cld/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:58 +1268: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:58 +1269: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:58 +1270: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1271: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1272: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1273: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1274: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1275: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1276: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1277: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1278: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) en: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
00:59 +1279: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:59 +1280: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
01:00 +1281: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
01:00 +1282: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
01:00 +1283: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
01:00 +1284: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
01:00 +1285: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
01:00 +1286: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) ar: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
01:00 +1287: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) ar: banned ΓåÆ contract copy inline, entry + resend locked, "Back to login" lands on /login, never the success view
01:00 +1288: F:/level/level_up/wt_cld/test/features/auth/login_validation_test.dart: header matches 82:819 / 337:15652 (Wave 01 walk) the bird is tinted per canvas ΓÇö cream on dark (W01-1)
01:00 +1289: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
01:00 +1290: F:/level/level_up/wt_cld/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill dark: glyph and digits in the frame's one colour
01:00 +1291: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the DARK theme renders the banned state without exceptions, with the same copy and controls
01:00 +1292: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the DARK theme renders the banned state without exceptions, with the same copy and controls
01:00 +1293: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the DARK theme renders the banned state without exceptions, with the same copy and controls
01:00 +1294: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the DARK theme renders the banned state without exceptions, with the same copy and controls
01:00 +1295: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the DARK theme renders the banned state without exceptions, with the same copy and controls
01:00 +1296: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
01:00 +1297: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
01:00 +1298: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the SCREEN guard alone keeps a completed code from reaching verify once banned (the notifier has no guard here)
01:01 +1299: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the SCREEN guard alone keeps a completed code from reaching verify once banned (the notifier has no guard here)
01:01 +1300: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) the SCREEN guard alone keeps a completed code from reaching verify once banned (the notifier has no guard here)
01:01 +1301: F:/level/level_up/wt_cld/test/features/auth/otp_elevation_test.dart: #31 the code card dark: a LAVENDER glow, and it is the only one in the file
01:01 +1302: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: input view: back chip at start AND the language pill at end
01:01 +1303: F:/level/level_up/wt_cld/test/features/auth/otp_screen_test.dart: input view: back chip at start AND the language pill at end
01:01 +1304: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) positive control for the SCREEN-guard test: the same recorder, NOT banned, DOES receive the programmatic code
01:01 +1305: F:/level/level_up/wt_cld/test/features/auth/otp_banned_test.dart: OtpScreen (real router) positive control for the SCREEN-guard test: the same recorder, NOT banned, DOES receive the programmatic code
01:01 +1306: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1307: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1308: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1309: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1310: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1311: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1312: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1313: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1314: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1315: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1316: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1317: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1318: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1319: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1320: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1321: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1322: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:01 +1323: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1324: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1325: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1325: F:/level/level_up/wt_cld/test/features/auth/otp_elevation_test.dart: ┬º7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
01:02 +1326: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1327: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1328: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1329: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1330: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
01:02 +1331: F:/level/level_up/wt_cld/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
unhandled element <filter/>; Picture key: Svg loader
01:03 +1332: F:/level/level_up/wt_cld/test/features/auth/r2b_login_reentrancy_test.dart: the Login screen two taps in the same frame request ONE code
01:04 +1333: F:/level/level_up/wt_cld/test/features/auth/r2b_login_reentrancy_test.dart: the Login screen two taps in the same frame request ONE code
01:04 +1334: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_layout_test.dart: the code row fills its card and fits the screen at 320.0dp (en)
01:04 +1335: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_layout_test.dart: the code row fills its card and fits the screen at 320.0dp (en)
01:04 +1336: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_layout_test.dart: the code row fills its card and fits the screen at 320.0dp (en)
01:04 +1337: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_layout_test.dart: the code row fills its card and fits the screen at 320.0dp (en)
01:04 +1338: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_layout_test.dart: the code row fills its card and fits the screen at 320.0dp (en)
01:04 +1339: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_layout_test.dart: the code row fills its card and fits the screen at 320.0dp (en)
01:04 +1340: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:04 +1341: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:05 +1342: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:05 +1343: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:05 +1344: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:05 +1345: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:05 +1346: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:05 +1347: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
01:05 +1348: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (en)
unhandled element <filter/>; Picture key: Svg loader
01:05 +1349: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_layout_test.dart: the code row fills its card and fits the screen at 390.0dp (en)
01:05 +1350: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (ar)
01:05 +1351: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue can be reached and tapped on landscape 915x412 (ar)
01:06 +1352: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1353: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1354: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1355: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1356: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1357: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1358: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1359: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1360: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1361: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1362: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1363: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1364: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:06 +1365: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1366: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1367: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1368: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1369: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1370: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1371: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1372: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1373: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1374: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1375: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1376: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1377: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1378: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1379: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1380: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1381: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1382: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1383: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1384: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1385: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1386: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1387: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1388: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1389: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1390: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1391: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1392: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1393: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1394: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1395: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1396: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1397: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1398: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1399: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1400: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1401: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1402: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1403: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1404: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1405: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1406: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1407: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1408: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1409: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1410: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:07 +1411: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1412: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1413: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1414: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1415: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1416: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1417: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1418: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:08 +1419: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue consumes the target once, for the student who signed in (ar)
01:08 +1420: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue consumes the target once, for the student who signed in (ar)
01:08 +1421: F:/level/level_up/wt_cld/test/features/auth/r2b_otp_success_test.dart: Continue consumes the target once, for the student who signed in (ar)
01:08 +1422: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1423: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1424: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1425: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1426: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1427: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1428: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1429: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1430: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1431: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1432: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1433: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1434: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1435: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1436: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1437: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1438: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1439: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1440: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:08 +1441: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:09 +1442: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:09 +1443: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:09 +1444: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:09 +1445: F:/level/level_up/wt_cld/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:09 +1446: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1447: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1448: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1449: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1450: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1451: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1452: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1453: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:09 +1454: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1455: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1456: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1457: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1458: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1459: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1460: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1461: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1462: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1463: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1464: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1465: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1466: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1467: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1468: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1469: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1470: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1471: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1472: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1473: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1474: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1475: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1476: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1477: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:10 +1478: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:11 +1479: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:11 +1480: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:11 +1481: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:12 +1482: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:12 +1483: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:12 +1484: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:12 +1485: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:13 +1486: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:13 +1487: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:13 +1488: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:13 +1489: F:/level/level_up/wt_cld/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:13 +1490: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:14 +1491: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:14 +1492: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:15 +1493: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:15 +1494: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:15 +1495: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:15 +1496: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +1497: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +1498: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +1499: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +1500: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +1501: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +1502: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +1503: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1504: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1505: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1506: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1507: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1508: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1509: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1510: F:/level/level_up/wt_cld/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +1511: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1512: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1513: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1514: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1515: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1516: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1517: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1518: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
01:16 +1519: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:16 +1520: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:16 +1521: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1522: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1523: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1524: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1525: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1526: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1527: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1528: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1529: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1530: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1531: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1532: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1533: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1534: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1535: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1536: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1537: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1538: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1539: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +1540: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1541: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1542: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1543: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1544: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1545: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1546: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1547: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1548: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1549: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +1550: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: title falls back to the bare title when the name is not cached
01:18 +1551: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1552: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1553: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1554: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1555: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1556: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1557: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1558: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1559: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1560: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1561: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1562: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1563: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1564: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1565: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1566: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1567: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1568: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1569: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1570: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1571: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
01:18 +1572: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1573: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1574: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1575: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1576: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1577: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1578: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1579: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1580: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:18 +1581: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:19 +1582: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:19 +1583: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:19 +1584: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
01:19 +1585: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
01:19 +1586: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1587: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1588: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1589: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1590: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1591: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1592: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1593: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1594: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1595: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1596: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1597: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1598: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1599: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1600: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1601: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1602: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:19 +1603: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
01:19 +1604: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
01:19 +1605: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1606: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1607: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1608: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1609: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1610: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1611: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1612: F:/level/level_up/wt_cld/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:19 +1613: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
01:19 +1614: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
01:19 +1615: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:19 +1616: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:19 +1617: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:19 +1618: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:20 +1619: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:20 +1620: F:/level/level_up/wt_cld/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:20 +1621: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1622: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1623: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1624: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1625: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1626: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1627: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1628: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1629: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1630: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1631: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1632: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1633: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1634: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1635: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1636: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1637: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1638: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1639: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1640: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1641: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1642: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1643: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1644: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:20 +1645: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1646: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1647: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1648: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1649: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1650: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1651: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1652: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1653: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1654: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1655: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1656: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1657: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1658: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1659: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
01:21 +1660: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:21 +1661: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: search clearing the query restores the full list
01:21 +1662: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: search clearing the query restores the full list
01:21 +1663: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:21 +1664: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:22 +1665: F:/level/level_up/wt_cld/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:22 +1666: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1667: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1668: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1669: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1670: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1671: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1672: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1673: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +1674: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:22 +1675: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:22 +1676: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:22 +1677: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:22 +1678: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:22 +1679: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1680: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1681: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1682: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1683: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1684: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1685: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1686: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1687: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1688: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1689: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1690: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1691: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1692: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1693: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1694: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1695: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1696: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1697: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1698: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1699: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:23 +1700: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1701: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1702: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1703: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1704: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1705: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1706: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1707: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1708: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1709: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1710: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1711: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1712: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1713: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1714: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1715: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1716: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1717: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1718: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1719: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1720: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1721: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1722: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1723: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1724: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1725: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1726: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1727: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1728: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:24 +1729: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1730: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1731: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1732: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1733: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1734: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1735: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1736: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1737: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:24 +1738: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1739: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1740: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1741: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1742: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1743: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1744: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1745: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1746: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1747: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1748: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1749: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1750: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1751: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1752: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1753: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1754: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1755: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1756: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1757: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1758: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1759: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1760: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1761: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1762: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1763: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1764: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1765: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1766: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1767: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1768: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1769: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1770: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:25 +1771: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:25 +1772: F:/level/level_up/wt_cld/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:25 +1773: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:25 +1774: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:25 +1775: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:25 +1776: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:25 +1777: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:25 +1778: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:25 +1779: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: each face keeps its own direction (BUG-020) the app's language does not move a card's text at all
01:25 +1780: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: each face keeps its own direction (BUG-020) the app's language does not move a card's text at all
01:25 +1781: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_flip_card_test.dart: each face keeps its own direction (BUG-020) the app's language does not move a card's text at all
01:25 +1782: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1783: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1784: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1785: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1786: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1787: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1788: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1789: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1790: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1791: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1792: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1793: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1794: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1795: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1796: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1797: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1798: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1799: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1800: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1801: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the route hands LecturesView the subject id it was opened with
01:25 +1802: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1803: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1804: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1805: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1806: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1807: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1808: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1809: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1810: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1811: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1812: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1813: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1814: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1815: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ en
01:25 +1816: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:25 +1817: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1818: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1819: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1820: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1821: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1822: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1823: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1824: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1825: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1826: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1827: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
01:26 +1828: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1829: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1830: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1831: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1832: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1833: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1834: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1835: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1836: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1837: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1838: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1839: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1840: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1841: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1842: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1843: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1844: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1845: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1846: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1847: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1848: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1849: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1850: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1851: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1852: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1853: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1854: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1855: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1856: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1857: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1858: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1859: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1860: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1861: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1862: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1863: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1864: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1865: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1866: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1867: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1868: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1869: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1870: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1871: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1872: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1873: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1874: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1875: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1876: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1877: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1878: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:26 +1879: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start pushes exactly the study path, ids in the path only
01:26 +1880: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start pushes exactly the study path, ids in the path only
01:26 +1881: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start pushes exactly the study path, ids in the path only
01:26 +1882: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start pushes exactly the study path, ids in the path only
01:26 +1883: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start pushes exactly the study path, ids in the path only
01:26 +1884: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start pushes exactly the study path, ids in the path only
01:26 +1885: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start pushes exactly the study path, ids in the path only
01:26 +1886: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1887: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1888: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1889: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1890: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1891: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1892: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1893: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1894: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1895: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1896: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1897: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1898: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1899: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1900: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1901: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1902: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1903: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1904: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1905: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1906: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1907: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1908: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1909: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1910: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1911: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1912: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1913: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1914: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1915: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1916: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1917: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1918: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1919: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1920: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1921: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1922: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1923: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1924: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1925: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1926: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
01:26 +1927: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1928: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1929: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1930: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1931: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1932: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1933: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1934: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1935: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1936: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1937: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1938: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1939: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1940: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1941: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1942: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1943: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1944: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1945: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1946: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1947: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1948: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1949: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1950: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1951: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1952: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1953: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1954: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1955: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1956: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1957: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1958: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1959: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1960: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1961: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1962: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1963: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1964: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1965: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1966: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1967: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1968: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1969: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1970: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1971: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1972: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1973: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1974: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1975: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1976: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1977: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1978: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1979: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1980: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1981: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1982: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1983: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1984: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1985: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1986: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1987: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1988: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1989: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1990: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1991: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:26 +1992: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +1993: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +1994: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +1995: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +1996: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +1997: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +1998: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +1999: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
01:26 +2000: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: geometry against the frame (402 wide, 20 margins) disc, card and buttons sit where 225:5582 puts them
01:26 +2001: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab on its own a quiz tab row tap still goes to /quiz/setup, never the flashcards path
01:26 +2002: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start is enabled online with cards
01:26 +2003: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: geometry against the frame (402 wide, 20 margins) on a tall screen the spare room is UNDER the buttons
01:26 +2004: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the Flashcard tab on its own a picked Flashcard tab falls back to Normal when a reloaded tree no longer offers it
01:27 +2005: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start is disabled while offline, with the banner
01:27 +2006: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: geometry against the frame (402 wide, 20 margins) on a short screen the card shrinks first
01:27 +2007: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start follows connectivity: offline disables it, back online enables it
01:27 +2008: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start follows connectivity: offline disables it, back online enables it
01:27 +2009: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start follows connectivity: offline disables it, back online enables it
01:27 +2010: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start follows connectivity: offline disables it, back online enables it
01:27 +2011: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start follows connectivity: offline disables it, back online enables it
01:27 +2012: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start follows connectivity: offline disables it, back online enables it
01:27 +2013: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: Start follows connectivity: offline disables it, back online enables it
01:27 +2014: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
01:27 +2015: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:27 +2016: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:27 +2017: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:27 +2018: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:27 +2019: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:27 +2020: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:27 +2021: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:27 +2022: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:28 +2023: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:28 +2024: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:28 +2025: F:/level/level_up/wt_cld/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:28 +2026: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2027: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2028: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2029: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2030: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2031: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2032: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2033: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2034: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2035: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2036: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2037: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2038: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:28 +2039: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2040: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2041: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2042: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2043: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2044: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2045: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2046: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2047: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2048: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2049: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2050: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2051: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2052: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2053: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2054: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2055: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2056: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2057: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2058: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2059: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:29 +2060: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2061: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2062: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2063: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2064: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2065: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2066: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2067: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2068: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2069: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2070: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2071: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2072: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2073: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2074: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2075: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2076: F:/level/level_up/wt_cld/test/features/home/home_bell_test.dart: tapping the bell pushes /notifications, and back returns Home
01:30 +2077: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:30 +2078: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:30 +2079: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:30 +2080: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:30 +2081: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:30 +2082: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2083: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2084: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2085: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2086: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2087: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2088: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2089: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2090: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2091: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2092: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2093: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2094: F:/level/level_up/wt_cld/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:31 +2095: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) one segment per server quiz type, all the same width
01:31 +2096: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) one segment per server quiz type, all the same width
01:31 +2097: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) one segment per server quiz type, all the same width
01:31 +2098: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) one segment per server quiz type, all the same width
01:31 +2099: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) one segment per server quiz type, all the same width
01:31 +2100: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2101: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2102: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2103: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2104: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2105: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2106: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2107: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:31 +2108: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2109: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2110: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2111: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2112: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2113: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2114: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2115: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2116: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2117: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2118: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2119: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2120: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2121: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2122: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2123: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2124: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2125: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2126: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2127: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2128: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2129: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2130: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2131: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2132: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:32 +2133: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:33 +2134: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:33 +2135: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:33 +2136: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
01:33 +2137: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2138: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2139: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2140: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2141: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2142: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2143: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2144: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2145: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2146: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2147: F:/level/level_up/wt_cld/test/features/home/w4_home_banner_test.dart: 360.0 dp ┬╖ en ┬╖ 1.0x ┬╖ exactly 140 tall, as drawn
01:33 +2148: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2149: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2150: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2151: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2152: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2153: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2154: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2155: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2156: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2157: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2158: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2159: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2160: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2161: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2162: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2163: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2164: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:33 +2165: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2166: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2167: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2168: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2169: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2170: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2171: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2172: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2173: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2174: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2175: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2176: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2177: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2178: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2179: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2180: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2181: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2182: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2183: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2184: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2185: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2186: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2187: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2188: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2189: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2190: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2191: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2192: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2193: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2194: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2195: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2196: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2197: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2198: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2199: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle ┬╖ 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
01:34 +2200: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the ids come from the path: another lecture, another subject
01:34 +2201: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the ids come from the path: another lecture, another subject
01:34 +2202: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the ids come from the path: another lecture, another subject
01:34 +2203: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the ids come from the path: another lecture, another subject
01:34 +2204: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: states error ΓåÆ the generic line and a Retry that refetches
01:34 +2205: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: states error ΓåÆ the generic line and a Retry that refetches
01:34 +2206: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: states error ΓåÆ the generic line and a Retry that refetches
01:34 +2207: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) the worst label keeps its full size, and the GROOVE gives way ΓÇö #81
01:34 +2208: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) the worst label keeps its full size, and the GROOVE gives way ΓÇö #81
01:34 +2209: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) the worst label keeps its full size, and the GROOVE gives way ΓÇö #81
01:34 +2210: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) the worst label keeps its full size, and the GROOVE gives way ΓÇö #81
01:34 +2211: F:/level/level_up/wt_cld/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) the worst label keeps its full size, and the GROOVE gives way ΓÇö #81
01:34 +2212: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2213: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2214: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2215: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2216: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2217: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2218: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2219: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2220: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:34 +2221: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2222: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2223: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2224: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2225: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2226: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2227: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2228: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2229: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2230: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2231: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2232: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2233: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2234: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2235: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2236: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2237: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2238: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2239: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2240: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2241: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2242: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2243: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2244: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2245: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2246: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2247: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2248: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2249: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn ΓåÆ subject ΓåÆ Flashcard tab ΓåÆ lecture ΓåÆ Setup ΓåÆ Start ΓåÆ study, and back the same way
01:35 +2250: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: the states online: no banner, and the buttons are on
01:35 +2251: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: surface ┬╖ 59:2090 / 337:5460 dark ┬╖ a hairline on ALL FOUR sides
01:35 +2252: F:/level/level_up/wt_cld/test/features/home/top_student_section_test.dart: surface ┬╖ 59:2090 / 337:5460 dark ┬╖ a hairline on ALL FOUR sides
01:35 +2253: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
01:35 +2254: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
01:35 +2255: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
01:35 +2256: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
01:35 +2257: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
01:36 +2258: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
01:36 +2259: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
01:36 +2260: F:/level/level_up/wt_cld/test/features/flashcards/flashcard_study_screen_test.dart: Arabic the card and row keep their margins; the pill leads on the right
01:36 +2261: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2262: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2263: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2264: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2265: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2266: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2267: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2268: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2269: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2270: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:36 +2271: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:37 +2272: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2273: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2274: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2275: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2276: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2277: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2278: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2279: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2280: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2281: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2282: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2283: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2284: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2285: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2286: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2287: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2288: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2289: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:37 +2290: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2291: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2292: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2293: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2294: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2295: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2296: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2297: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2298: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2299: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2300: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2301: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2302: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2303: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2304: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2305: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2306: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2307: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2308: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2309: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2310: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2311: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2312: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2313: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2314: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2315: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2316: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2317: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2318: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2319: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2320: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:38 +2321: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2322: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2323: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2324: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2325: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2326: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2327: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2328: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2329: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2330: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2331: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2332: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2333: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2334: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2335: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2336: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2337: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2338: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2339: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: en ┬╖ states loading: a spinner, and the bar names the document
01:39 +2340: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2341: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2342: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2343: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2344: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2345: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2346: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2347: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2348: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2349: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2350: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2351: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2352: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2353: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2354: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2355: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:39 +2356: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2357: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2358: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2359: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2360: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2361: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2362: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2363: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2364: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2365: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2366: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2367: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2368: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2369: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2370: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2371: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2372: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2373: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2374: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2375: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2376: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2377: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2378: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2379: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2380: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2381: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2382: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2383: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2384: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2385: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2386: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2387: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2388: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2389: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:40 +2390: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2391: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2392: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2393: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2394: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2395: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2396: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2397: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2398: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2399: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2400: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2401: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2402: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2403: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2404: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2405: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2406: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2407: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2408: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2409: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2410: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2411: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2412: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "User Agreement" opens the Terms viewer; back returns to Login
01:41 +2413: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: language and document switching the language while open fetches the other one
01:41 +2414: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: an empty board says so instead of showing a blank list
01:41 +2415: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: an empty board says so instead of showing a blank list
01:41 +2416: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: an empty board says so instead of showing a blank list
01:41 +2417: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "Privacy Policy" opens the Privacy viewer
01:41 +2418: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "Privacy Policy" opens the Privacy viewer
01:41 +2419: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "Privacy Policy" opens the Privacy viewer
01:41 +2420: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out "Privacy Policy" opens the Privacy viewer
01:41 +2421: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: Arabic (RTL) the loaded board renders in Arabic, right-to-left
01:41 +2422: F:/level/level_up/wt_cld/test/features/legal/legal_document_screen_test.dart: rendering the served Markdown ar: table columns and cells follow the reading direction
01:42 +2423: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out the line has two links and no Cookie Policy, from the existing fragments, in reading order
01:42 +2424: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out the line has two links and no Cookie Policy, from the existing fragments, in reading order
01:42 +2425: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out the line has two links and no Cookie Policy, from the existing fragments, in reading order
01:42 +2426: F:/level/level_up/wt_cld/test/features/legal/legal_routes_test.dart: en ┬╖ from Login, signed out the line has two links and no Cookie Policy, from the existing fragments, in reading order
01:42 +2427: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2428: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2429: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2430: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2431: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2432: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2433: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2434: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2435: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2436: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2437: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2438: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2439: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2440: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2441: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2442: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:42 +2443: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2444: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2445: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2446: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2447: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2448: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2449: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2450: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2451: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2452: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2453: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2454: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2455: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2456: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2457: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2458: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2459: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2460: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2461: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2462: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2463: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2464: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2465: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2466: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2467: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2468: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2469: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2470: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2471: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2472: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2473: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2474: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2475: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2476: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2477: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2478: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2479: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2480: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2481: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2482: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2483: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2484: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2485: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2486: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2487: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2488: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2489: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2490: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2491: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2492: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2493: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2494: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2495: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2496: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:43 +2497: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2498: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2499: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2500: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2501: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2502: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2503: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2504: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2505: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2506: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2507: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2508: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2509: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2510: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2511: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2512: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2513: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2514: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2515: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2516: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2517: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2518: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2519: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2520: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2521: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2522: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2523: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2524: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2525: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2526: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2527: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2528: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2529: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2530: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2531: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2532: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2533: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2534: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2535: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2536: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2537: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2538: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2539: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2540: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2541: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2542: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2543: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2544: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2545: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2546: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2547: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2548: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2549: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2550: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2551: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:44 +2552: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:45 +2553: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:45 +2554: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2555: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2556: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2557: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2558: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2559: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2560: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2561: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2562: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2563: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2564: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2565: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2566: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2567: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2568: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2569: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2570: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2571: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2572: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2573: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2574: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2575: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2576: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2577: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2578: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2579: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2580: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2581: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2582: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2583: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2584: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2585: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2586: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2587: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2588: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2589: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2590: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2591: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2592: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2593: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:45 +2594: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: the four states en loading: a spinner under the chips
01:46 +2595: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: the overview renders one card per subject, in the SERVER order
01:46 +2596: F:/level/level_up/wt_cld/test/features/leaderboard/leaderboard_screen_test.dart: a failed append (the footer) 429 ┬╖ scrolling again does not ask the server again
01:46 +2597: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:46 +2598: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:46 +2599: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:46 +2600: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:46 +2601: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:46 +2602: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:46 +2603: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2604: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2605: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2606: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2607: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2608: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2609: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2610: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2611: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2612: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2613: F:/level/level_up/wt_cld/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
01:47 +2614: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:47 +2615: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:47 +2616: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2617: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2618: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2619: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2620: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2621: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2622: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2623: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2624: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2625: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2626: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2627: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2628: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2629: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2630: F:/level/level_up/wt_cld/test/features/onboarding/r2b_onboarding_scroll_test.dart: 320x568 at 2.0x (en): no overflow, and both buttons work
01:48 +2631: F:/level/level_up/wt_cld/test/features/profile/avatar_picker_empty_test.dart: en ┬╖ dark ┬╖ an empty list reads "nothing here", with no Retry and no error
01:48 +2632: F:/level/level_up/wt_cld/test/features/profile/avatar_picker_empty_test.dart: en ┬╖ dark ┬╖ an empty list reads "nothing here", with no Retry and no error
01:48 +2633: F:/level/level_up/wt_cld/test/features/profile/avatar_picker_empty_test.dart: en ┬╖ dark ┬╖ an empty list reads "nothing here", with no Retry and no error
01:48 +2634: F:/level/level_up/wt_cld/test/features/profile/avatar_picker_empty_test.dart: en ┬╖ dark ┬╖ an empty list reads "nothing here", with no Retry and no error
01:48 +2635: F:/level/level_up/wt_cld/test/features/profile/avatar_picker_empty_test.dart: en ┬╖ dark ┬╖ an empty list reads "nothing here", with no Retry and no error
01:48 +2636: F:/level/level_up/wt_cld/test/features/profile/avatar_picker_empty_test.dart: en ┬╖ dark ┬╖ an empty list reads "nothing here", with no Retry and no error
01:49 +2637: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2638: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2639: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2640: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2641: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2642: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2643: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2644: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2645: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2646: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2647: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2648: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2649: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2650: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2651: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2652: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2653: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2654: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2655: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2656: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2657: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2658: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2659: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2660: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2661: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2662: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:49 +2663: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2664: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2665: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2666: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2667: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2668: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2669: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2670: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2671: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2672: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2673: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2674: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2675: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2676: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2677: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2678: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:50 +2679: F:/level/level_up/wt_cld/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:51 +2680: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2681: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2682: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2683: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2684: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2685: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2686: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2687: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:51 +2688: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:52 +2689: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:52 +2690: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:52 +2691: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en a refused name marks the name field with the approved line, keeps what was typed, and is not resent
01:52 +2692: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: paging a failed append: scrolling to and fro asks nothing more, only Retry does ┬╖ ar
01:52 +2693: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: paging a failed append: scrolling to and fro asks nothing more, only Retry does ┬╖ ar
01:52 +2694: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: paging a failed append: scrolling to and fro asks nothing more, only Retry does ┬╖ ar
01:52 +2695: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: paging a failed append: scrolling to and fro asks nothing more, only Retry does ┬╖ ar
01:52 +2696: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: paging a failed append: scrolling to and fro asks nothing more, only Retry does ┬╖ ar
01:52 +2697: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2698: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2699: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2700: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2701: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2702: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2703: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2704: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2705: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2706: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2707: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2708: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2709: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2710: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2711: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2712: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2713: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2714: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2715: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2716: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2717: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:52 +2718: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2719: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2720: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2721: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2722: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2723: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2724: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2725: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2726: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2727: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2728: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2729: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2730: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2731: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2732: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2733: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2734: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2735: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2736: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2737: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2738: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:53 +2739: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2740: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2741: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2742: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2743: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2744: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2745: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2746: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
01:54 +2747: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2748: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2749: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2750: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2751: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2752: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2753: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2754: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2755: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2756: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2757: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2758: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2759: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2760: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2761: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2762: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2763: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2764: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2765: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2766: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2767: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2768: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2769: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2770: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2771: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2772: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2773: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2774: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:54 +2775: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:55 +2776: F:/level/level_up/wt_cld/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
01:55 +2777: F:/level/level_up/wt_cld/test/features/notifications/notifications_screen_test.dart: both canvases the selected chip is flat and purple on both canvases
01:55 +2778: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) dark: the chevron is cream (404:7651)
01:55 +2779: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) dark: the chevron is cream (404:7651)
01:55 +2780: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) dark: the chevron is cream (404:7651)
01:55 +2781: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) dark: the chevron is cream (404:7651)
01:55 +2782: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) dark: the chevron is cream (404:7651)
01:55 +2783: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) dark: the chevron is cream (404:7651)
01:55 +2784: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
01:55 +2785: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
01:55 +2786: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en typing the refused name back brings the mark back, and Save sends nothing
01:55 +2787: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en typing the refused name back brings the mark back, and Save sends nothing
01:55 +2788: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en typing the refused name back brings the mark back, and Save sends nothing
01:55 +2789: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en typing the refused name back brings the mark back, and Save sends nothing
01:55 +2790: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en typing the refused name back brings the mark back, and Save sends nothing
01:55 +2791: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en typing the refused name back brings the mark back, and Save sends nothing
01:55 +2792: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: en typing the refused name back brings the mark back, and Save sends nothing
01:55 +2793: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2794: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2795: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2796: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2797: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2798: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2799: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2800: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2801: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2802: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:55 +2803: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2804: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2805: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2806: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2807: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2808: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2809: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2810: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2811: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2812: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2813: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2814: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2815: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2816: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2817: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2818: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2819: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2820: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2821: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2822: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2823: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2824: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2825: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2826: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2827: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2828: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2829: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2830: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2831: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2832: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2833: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2834: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2835: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:56 +2836: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2837: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2838: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2839: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2840: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2841: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2842: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2843: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2844: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2845: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2846: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2847: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2848: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:57 +2849: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2850: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2851: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2852: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2853: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2854: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2855: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2856: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2857: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:58 +2858: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2859: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2860: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2861: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2862: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2863: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2864: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2865: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2866: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2867: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2868: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2869: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2870: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2871: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2872: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2873: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2874: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2875: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2876: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2877: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2878: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2879: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2880: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2881: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2882: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2883: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2884: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2885: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2886: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
01:59 +2887: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2888: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2889: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2890: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2891: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2892: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2893: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2894: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2895: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2896: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2897: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2898: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: the refused name holds back the whole save: an email changed beside it is not sent, and goes out once the name is back to the saved one
01:59 +2899: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
01:59 +2900: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
01:59 +2901: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2902: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2903: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2904: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2905: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2906: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2907: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2908: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2909: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:00 +2910: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: disabled rows are present AND non-interactive and every row is a BUTTON to TalkBack, never an image
02:00 +2911: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2912: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2913: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2914: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2915: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2916: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2917: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2918: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2919: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2920: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2921: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2922: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Arabic mirrors the insets: badge 17 from the right, chevron 12 from the left
02:00 +2923: F:/level/level_up/wt_cld/test/features/profile/edit_profile_name_not_allowed_test.dart: other failures are not remembered: Save sends again a 422 with another code
02:00 +2924: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
02:00 +2925: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
02:01 +2926: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: the sign-out drops the first student's profile from memory
02:01 +2927: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:01 +2928: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:01 +2929: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:01 +2930: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:01 +2931: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
02:01 +2932: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
02:01 +2933: F:/level/level_up/wt_cld/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
02:01 +2934: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:02 +2935: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2936: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2937: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2938: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2939: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2940: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2941: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2942: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2943: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2944: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2945: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2946: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2947: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2948: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2949: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:02 +2950: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2951: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2952: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2953: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2954: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2955: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2956: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2957: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:02 +2958: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2959: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2960: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2961: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2962: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2963: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2964: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2965: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2966: F:/level/level_up/wt_cld/test/features/profile/r2b_confirm_dialog_scroll_test.dart: Go to Uni at 360x640 and the largest text (en): no overflow, every line reachable
02:03 +2967: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2968: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2969: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2970: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2971: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2972: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2973: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2974: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2975: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2976: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2977: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2978: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2979: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2980: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2981: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2982: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2983: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2984: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2985: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2986: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:03 +2987: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2988: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2989: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2990: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2991: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2992: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2993: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2994: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2995: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2996: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2997: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2998: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +2999: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3000: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3001: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3002: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3003: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3004: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3005: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3006: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3007: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3008: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3009: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3010: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3011: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3012: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3013: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3014: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3015: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3016: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3017: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3018: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3019: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3020: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:04 +3021: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:04 +3022: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the Arabic name in AR
02:05 +3023: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
02:05 +3024: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
02:05 +3025: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
02:05 +3026: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
02:05 +3027: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:05 +3028: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:05 +3029: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:05 +3030: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3031: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3032: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3033: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3034: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3035: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3036: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3037: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3038: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3039: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3040: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3041: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3042: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:06 +3043: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3044: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3045: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3046: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3047: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3048: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3049: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3050: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3051: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3052: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3053: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3054: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3055: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3056: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3057: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3058: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3059: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3060: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3061: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3062: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (en)
02:07 +3063: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) the rows take the frame geometry of 404:6782, with no chevron
02:07 +3064: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) the rows take the frame geometry of 404:6782, with no chevron
02:07 +3065: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: save offline shows the offline line, not a generic error
02:08 +3066: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3067: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3068: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3069: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3070: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3071: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3072: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3073: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3074: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3075: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3076: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3077: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3078: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3079: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3080: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3081: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3082: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3083: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3084: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3085: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3086: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3087: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3088: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3089: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3090: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3091: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3092: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3093: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3094: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3095: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3096: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (en)
02:08 +3097: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) en: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3098: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) en: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3099: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
02:08 +3100: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
02:08 +3101: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
02:08 +3102: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Keep editing" stays put
02:08 +3103: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Keep editing" stays put
02:08 +3104: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged the Save button is exactly 60 tall (ar)
02:08 +3105: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3106: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3107: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3108: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3109: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3110: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3111: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3112: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3113: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3114: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3115: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:08 +3116: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
02:09 +3117: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
02:09 +3118: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
02:09 +3119: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
02:09 +3120: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 1.0x: the frame is unchanged at the frame width too: 60 tall (ar)
02:09 +3121: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3122: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3123: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3124: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3125: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3126: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3127: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3128: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3129: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3130: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3131: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3132: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3133: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3134: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3135: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3136: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3137: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3138: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3139: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3140: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3141: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3142: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3143: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3144: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3145: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3146: F:/level/level_up/wt_cld/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:09 +3147: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3148: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3149: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3150: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3151: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3152: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3153: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3154: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:09 +3155: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:10 +3156: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:10 +3157: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
02:10 +3158: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 2.0x: the button never shrinks and never overflows narrow, where the label needs more than 60: the button GROWS to hold it (en)
02:10 +3159: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 2.0x: the button never shrinks and never overflows narrow, where the label needs more than 60: the button GROWS to hold it (en)
02:10 +3160: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 2.0x: the button never shrinks and never overflows narrow, where the label needs more than 60: the button GROWS to hold it (en)
02:10 +3161: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 ┬╖ 180:4704 ┬╖ 180:4445) Logout: the No / Yes pair (180:4757) Yes revokes, then signs out
02:10 +3162: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 ┬╖ 180:4704 ┬╖ 180:4445) Logout: the No / Yes pair (180:4757) Yes revokes, then signs out
02:10 +3163: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: locales and themes EN lays out LTR
02:10 +3164: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: locales and themes EN lays out LTR
02:10 +3165: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: locales and themes EN lays out LTR
02:10 +3166: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: locales and themes EN lays out LTR
02:10 +3167: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: locales and themes EN lays out LTR
02:10 +3168: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3169: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3170: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3171: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3172: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3173: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3174: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3175: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3176: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3177: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3178: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3179: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3180: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3181: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3182: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3183: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic: the lesson counts take the one, two, few and many forms
02:10 +3184: F:/level/level_up/wt_cld/test/features/profile/w1_edit_profile_save_height_test.dart: 2.0x: the button never shrinks and never overflows wide: still at least 60, no overflow (ar)
02:10 +3185: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:10 +3186: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:10 +3187: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:10 +3188: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:10 +3189: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:10 +3190: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:10 +3191: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:10 +3192: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3193: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3194: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3195: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3196: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3197: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3198: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3199: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3200: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3201: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3202: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3203: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3204: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3205: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3206: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3207: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3208: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3209: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3210: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3211: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3212: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3213: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3214: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3215: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3216: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3217: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3218: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3219: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3220: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3221: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3222: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3223: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3224: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3225: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3226: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3227: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3228: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3229: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3230: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3231: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:11 +3232: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
02:11 +3233: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
02:11 +3234: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
02:11 +3235: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the avatar block (176:1343 ┬╖ 176:1346) light: the badge carries the frame's pencil, 17 x 17, centred, in #384F47
02:11 +3236: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 ┬╖ 180:4704 ┬╖ 180:4445) the Γ£ò (180:4706) a button named "Close", not an image (W11-7)
02:11 +3237: F:/level/level_up/wt_cld/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 ┬╖ 180:4704 ┬╖ 180:4445) the Γ£ò (180:4706) a button named "Close", not an image (W11-7)
02:11 +3238: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3239: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3240: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3241: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3242: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3243: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3244: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3245: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3246: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:11 +3247: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3248: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3249: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3250: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3251: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3252: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3253: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3254: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3255: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3256: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3257: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3258: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3259: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3260: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3261: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3262: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3263: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3264: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3265: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3266: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3267: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3268: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
02:12 +3269: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
02:12 +3270: F:/level/level_up/wt_cld/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
02:12 +3271: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3272: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3273: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3274: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3275: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3276: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3277: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3278: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3279: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3280: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3281: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3282: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3283: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3284: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3285: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3286: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3287: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3288: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3289: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3290: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3291: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3292: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3293: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3294: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3295: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3296: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3297: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3298: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3299: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3300: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3301: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3302: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
02:12 +3303: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the locked rows follow the frames (owner ruling, #105) university (180:6349): Phone, Faculty, Academic Year, City, University name
02:12 +3304: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) offline pins the banner on Lessons and keeps the rows
02:12 +3305: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) offline pins the banner on Lessons and keeps the rows
02:13 +3306: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the locked rows follow the frames (owner ruling, #105) I2: a locked row is announced once: its label, its value and why it is locked
02:13 +3307: F:/level/level_up/wt_cld/test/features/quiz/quiz_repository_test.dart: createQuiz school: sends lessonId and OMITS lectureId/quizType entirely
02:13 +3308: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3309: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3310: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3311: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3312: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3313: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3314: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3315: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3316: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3317: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3318: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3319: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3320: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3321: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3322: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3323: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3324: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3325: F:/level/level_up/wt_cld/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
02:13 +3326: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the action sheet (216:3341) a drag handle over two plain, full-width rows and one hairline: no title, no Γ£ò, no icons
02:13 +3327: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the action sheet (216:3341) dark (337:8135): the handle #FCFBF9, the hairline the same #4B675E at 60%
02:13 +3328: F:/level/level_up/wt_cld/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the action sheet (216:3341) the scrim dismisses it, and nothing changes
02:13 +3329: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:14 +3330: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:14 +3331: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:14 +3332: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:15 +3333: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:15 +3334: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:15 +3335: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:16 +3336: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:16 +3337: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:16 +3338: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:16 +3339: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:16 +3340: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3341: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3342: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3343: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3344: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3345: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3346: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3347: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3348: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3349: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3350: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3351: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3352: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3353: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3354: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3355: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3356: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3357: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3358: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3359: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3360: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:16 +3361: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3362: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3363: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3364: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3365: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3366: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3367: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3368: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3369: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3370: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:17 +3371: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3372: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3373: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3374: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3375: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3376: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3377: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3378: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3379: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3380: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3381: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3382: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3383: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3384: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3385: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3386: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3387: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3388: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3389: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3390: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3391: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3392: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3393: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3394: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3395: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3396: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3397: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3398: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3399: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3400: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3401: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3402: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3403: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3404: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3405: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3406: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3407: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3408: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3409: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3410: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3411: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3412: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3413: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:17 +3414: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:18 +3415: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:18 +3416: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:18 +3417: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:18 +3418: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:18 +3419: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
02:18 +3420: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back with no subject in hand, the scope stands alone
02:18 +3421: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back with no subject in hand, the scope stands alone
02:18 +3422: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
02:18 +3423: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
02:18 +3424: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
02:18 +3425: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
02:18 +3426: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
02:18 +3427: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
02:18 +3428: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
02:18 +3429: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
02:18 +3430: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
02:18 +3431: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
02:18 +3432: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3433: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3434: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3435: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3436: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3437: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3438: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3439: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3440: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3441: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3442: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3443: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3444: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3445: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3446: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3447: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3448: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3449: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:18 +3450: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:18 +3451: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:18 +3452: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:18 +3453: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:18 +3454: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:19 +3455: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:19 +3456: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:19 +3457: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3458: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3459: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3460: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3461: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3462: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3463: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3464: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3465: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3466: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3467: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3468: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:19 +3469: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: the AI glyph is absent when the server has no explanation
02:19 +3470: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3471: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3472: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3473: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3474: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3475: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3476: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3477: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3478: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: rendering 2x text ┬╖ the counter is drawn whole, inside the header ┬╖ ar
02:19 +3479: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3480: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3481: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3482: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3483: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3484: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3485: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3486: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3487: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3488: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3489: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3490: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3491: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:19 +3492: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3493: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3494: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3495: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3496: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3497: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3498: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3499: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3500: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3501: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3502: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3503: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3504: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3505: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:20 +3506: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3507: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3508: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3509: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3510: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3511: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3512: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3513: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3514: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3515: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3516: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3517: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3518: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3519: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3520: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3521: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3522: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
02:20 +3523: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
02:20 +3524: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
02:20 +3525: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
02:20 +3526: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
02:20 +3527: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
02:20 +3528: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
02:20 +3529: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row keeps its own token, which is GREEN in light
02:20 +3530: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
02:20 +3531: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
02:20 +3532: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
02:21 +3533: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
02:21 +3534: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:21 +3535: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:21 +3536: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility every dark row is translucent and glassed - none is left opaque beside a glassed neighbour
02:21 +3537: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz Start hands the subject on to the quiz, display only (APIΓåÆUI Wave 13)
02:21 +3538: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz Start hands the subject on to the quiz, display only (APIΓåÆUI Wave 13)
02:21 +3539: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3540: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3541: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3542: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3543: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3544: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3545: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3546: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3547: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3548: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3549: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3550: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3551: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3552: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3553: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:21 +3554: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
02:21 +3555: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
02:21 +3556: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
02:21 +3557: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
02:22 +3558: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
02:22 +3559: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
02:22 +3560: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
02:22 +3561: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
02:22 +3562: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
02:22 +3563: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
02:22 +3564: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
02:22 +3565: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:22 +3566: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:22 +3567: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:22 +3568: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3569: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3570: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3571: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3572: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3573: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3574: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3575: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3576: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3577: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3578: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3579: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3580: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3581: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3582: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3583: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3584: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3585: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3586: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3587: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3588: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3589: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3590: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3591: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3592: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3593: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3594: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3595: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3596: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3597: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3598: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3599: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3600: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:23 +3601: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3602: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3603: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3604: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3605: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3606: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3607: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3608: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3609: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3610: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3611: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3612: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3613: F:/level/level_up/wt_cld/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable ΓÇö no regression
02:24 +3614: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
02:24 +3615: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
02:24 +3616: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
02:24 +3617: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
02:24 +3618: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
02:24 +3619: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds ΓÇö no level, no points total, no meter
02:24 +3620: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds ΓÇö no level, no points total, no meter
02:24 +3621: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds ΓÇö no level, no points total, no meter
02:24 +3622: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds ΓÇö no level, no points total, no meter
02:24 +3623: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds ΓÇö no level, no points total, no meter
02:24 +3624: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds ΓÇö no level, no points total, no meter
02:24 +3625: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds ΓÇö no level, no points total, no meter
02:24 +3626: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3627: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3628: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3629: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3630: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3631: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3632: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3633: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3634: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3635: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3636: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3637: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3638: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3639: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3640: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3641: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3642: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3643: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3644: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3645: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3646: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3647: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3648: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
02:24 +3649: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3650: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3651: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3652: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3653: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3654: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3655: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3656: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3657: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3658: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) header: 63 tall over the frame's rule, chip 21 in and centred, title #000000
02:24 +3659: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
02:24 +3660: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
02:24 +3661: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
02:24 +3662: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
02:24 +3663: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
02:24 +3664: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
02:24 +3665: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
02:24 +3666: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) dark header: cream title over the same rule
02:24 +3667: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: the length chips are raised, not outlined dark keeps the same black shadow and takes no Glass
02:24 +3668: F:/level/level_up/wt_cld/test/features/quiz/quiz_setup_screen_test.dart: the length chips are raised, not outlined dark keeps the same black shadow and takes no Glass
02:25 +3669: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 ┬╖ 337:6628) Arabic: the subject line reads ╪º┘ä╪ú╪¡┘è╪º╪í ΓÇö ╪º┘ä╪»╪▒╪│ ╪º┘ä╪ú┘ê┘ä
02:25 +3670: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 ┬╖ 337:6628) Arabic: the subject line reads ╪º┘ä╪ú╪¡┘è╪º╪í ΓÇö ╪º┘ä╪»╪▒╪│ ╪º┘ä╪ú┘ê┘ä
02:25 +3671: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3672: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3673: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3674: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3675: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3676: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3677: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3678: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3679: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3680: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3681: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3682: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3683: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3684: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3685: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3686: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3687: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3688: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3689: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3690: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3691: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3692: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3693: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3694: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3695: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3696: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3697: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3698: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
02:25 +3699: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) chips: "Correct" and "Wrong" lead with the frame's 16 discs, 10 before the label
02:25 +3700: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 ┬╖ 337:6628) dark: title #FCFBF9, subtitle #EEEEEE, same rule
02:25 +3701: F:/level/level_up/wt_cld/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 ┬╖ 337:6628) dark: title #FCFBF9, subtitle #EEEEEE, same rule
02:25 +3702: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
02:25 +3703: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
02:25 +3704: F:/level/level_up/wt_cld/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
02:25 +3705: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) chips: an idle label is #384F47 in light, cream in dark
02:25 +3706: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) chips: an idle label is #384F47 in light, cream in dark
02:26 +3707: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) chips: an idle label is #384F47 in light, cream in dark
02:26 +3708: F:/level/level_up/wt_cld/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) chips: an idle label is #384F47 in light, cream in dark
02:26 +3709: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3710: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3711: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3712: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3713: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3714: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3715: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3716: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3717: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3718: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3719: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3720: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3721: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3722: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3723: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3724: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3725: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3726: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3727: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3728: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3729: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3730: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3731: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3732: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3733: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3734: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:26 +3735: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3736: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3737: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3738: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3739: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3740: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3741: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3742: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3743: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3744: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3745: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3746: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3747: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3748: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3749: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3750: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:27 +3751: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3752: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3753: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3754: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3755: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3756: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3757: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3758: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3759: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3760: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3761: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:28 +3762: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:29 +3763: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:29 +3764: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:29 +3765: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ en a refused name goes back to Sign Up_1, marked with the approved line; the draft and its token are kept, and nothing is resent
02:29 +3766: F:/level/level_up/wt_cld/test/features/registration/registration_return_target_test.dart: School registration landing goes Home even with a target remembered, and clears it
02:29 +3767: F:/level/level_up/wt_cld/test/features/registration/registration_return_target_test.dart: School registration landing goes Home even with a target remembered, and clears it
02:29 +3768: F:/level/level_up/wt_cld/test/features/registration/registration_return_target_test.dart: School registration landing goes Home even with a target remembered, and clears it
02:29 +3769: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:29 +3770: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:29 +3771: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:29 +3772: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:29 +3773: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3774: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3775: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3776: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3777: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3778: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3779: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3780: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3781: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3782: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3783: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3784: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3785: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3786: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3787: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3788: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3789: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3790: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3791: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3792: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3793: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3794: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3795: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3796: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3797: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3798: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3799: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3800: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3801: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3802: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3803: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3804: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3805: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3806: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3807: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3808: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3809: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3810: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3811: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3812: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3813: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3814: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3815: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3816: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3817: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3818: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3819: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:30 +3820: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3821: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3822: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3823: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3824: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3825: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3826: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3827: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3828: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3829: F:/level/level_up/wt_cld/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
02:31 +3830: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:31 +3831: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:31 +3832: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:31 +3833: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:31 +3834: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:31 +3835: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:31 +3836: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3837: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3838: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3839: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3840: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3841: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3842: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3843: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3844: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3845: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:32 +3846: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
02:33 +3847: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:33 +3848: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:33 +3849: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:33 +3850: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:33 +3851: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:33 +3852: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: School ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:33 +3853: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3854: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3855: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3856: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3857: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3858: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3859: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3860: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3861: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3862: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3863: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3864: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3865: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3866: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3867: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3868: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:33 +3869: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:34 +3870: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:34 +3871: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:34 +3872: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:34 +3873: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:34 +3874: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:35 +3875: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:35 +3876: F:/level/level_up/wt_cld/test/features/registration/school_picker_append_failure_test.dart: network error ┬╖ en ┬╖ one failed append is one request; scrolling asks no more, only Retry does
02:35 +3877: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:35 +3878: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:35 +3879: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:35 +3880: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:35 +3881: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:35 +3882: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3883: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3884: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3885: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3886: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3887: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3888: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3889: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3890: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3891: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3892: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:36 +3893: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3894: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3895: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3896: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3897: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3898: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3899: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3900: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3901: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3902: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a picked school is still shown by name after the student leaves the form and comes back, and its id is what is sent
02:37 +3903: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:37 +3904: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:37 +3905: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:37 +3906: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:37 +3907: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3908: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3909: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3910: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3911: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3912: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3913: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3914: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3915: F:/level/level_up/wt_cld/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
02:38 +3916: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3917: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3918: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3919: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3920: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3921: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3922: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3923: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3924: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3925: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:38 +3926: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3927: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3928: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3929: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3930: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3931: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3932: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3933: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3934: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3935: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3936: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3937: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3938: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3939: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3940: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3941: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3942: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:39 +3943: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:39 +3944: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:39 +3945: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:39 +3946: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:39 +3947: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:39 +3948: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:39 +3949: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3950: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3951: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3952: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3953: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3954: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3955: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3956: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3957: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3958: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3959: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3960: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3961: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3962: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3963: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:40 +3964: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:41 +3965: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:41 +3966: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:41 +3967: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:41 +3968: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:41 +3969: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
02:41 +3970: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ en the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:41 +3971: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ en the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:41 +3972: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ en the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:41 +3973: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ en the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:41 +3974: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ en the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:41 +3975: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ ar after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:41 +3976: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ ar after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:42 +3977: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ ar after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:42 +3978: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ ar after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:42 +3979: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ ar after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:42 +3980: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ ar after a refused name the trip back through Sign Up_1 keeps the picked school; the corrected name is sent once with it and the same token
02:42 +3981: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card dark: NO hairline at all, and G16 instead
02:42 +3982: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card dark: NO hairline at all, and G16 instead
02:42 +3983: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card dark: NO hairline at all, and G16 instead
02:42 +3984: F:/level/level_up/wt_cld/test/features/settings/settings_elevation_test.dart: #28 the section card dark: NO hairline at all, and G16 instead
02:42 +3985: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink the heading constants are Inter's own metrics
02:42 +3986: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink the heading constants are Inter's own metrics
02:42 +3987: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
02:42 +3988: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
02:42 +3989: F:/level/level_up/wt_cld/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
02:42 +3990: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a skipped school still reads as answered after the student comes back, and no schoolId is sent
02:42 +3991: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a skipped school still reads as answered after the student comes back, and no schoolId is sent
02:42 +3992: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a skipped school still reads as answered after the student comes back, and no schoolId is sent
02:43 +3993: F:/level/level_up/wt_cld/test/features/registration/school_pick_survives_return_test.dart: School ┬╖ en a skipped school still reads as answered after the student comes back, and no schoolId is sent
02:43 +3994: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:43 +3995: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ ar the corrected name goes forward through a filled-in wizard and is sent once, with the same token
02:43 +3996: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +3997: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +3998: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +3999: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4000: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4001: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4002: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4003: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4004: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4005: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4006: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:43 +4007: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4008: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4009: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4010: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4011: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4012: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4013: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4014: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4015: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4016: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4017: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4018: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4019: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4020: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4021: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4022: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4023: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4024: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4025: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4026: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:44 +4027: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:45 +4028: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:45 +4029: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
02:45 +4030: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4031: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4032: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4033: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4034: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4035: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4036: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4037: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4038: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4039: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4040: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4041: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4042: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4043: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4044: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4045: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4046: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4047: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4048: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4049: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4050: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4051: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4052: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:45 +4053: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:46 +4054: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:46 +4055: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:46 +4056: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:46 +4057: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:46 +4058: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
02:46 +4059: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ en: the form sliding back shows no banner of its own
02:46 +4060: F:/level/level_up/wt_cld/test/features/registration/registration_name_not_allowed_test.dart: University ┬╖ en: the form sliding back shows no banner of its own
02:46 +4061: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:46 +4062: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:46 +4063: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:46 +4064: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:46 +4065: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:46 +4066: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:46 +4067: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:46 +4068: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:47 +4069: F:/level/level_up/wt_cld/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
02:47 +4070: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4071: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4072: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4073: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4074: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4075: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4076: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4077: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:47 +4078: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4079: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4080: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4081: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4082: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4083: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4084: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4085: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4086: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4087: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4088: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:48 +4089: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4090: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4091: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4092: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4093: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4094: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4095: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4096: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4097: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4098: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4099: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4100: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
02:49 +4101: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4102: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4103: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4104: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4105: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4106: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4107: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4108: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
02:49 +4109: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4110: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4111: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4112: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4113: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4114: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4115: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4116: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4117: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4118: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4119: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4120: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4121: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:50 +4122: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4123: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4124: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4125: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4126: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4127: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4128: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4129: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4130: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4131: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4132: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4133: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4134: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4135: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4136: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4137: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4138: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4139: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4140: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4141: F:/level/level_up/wt_cld/test/features/support/create_support_ticket_screen_test.dart: the form shows the heading, both fields and the button ┬╖ en
02:51 +4142: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4143: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4144: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4145: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4146: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4147: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4148: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4149: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4150: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4151: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4152: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4153: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4154: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4155: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4156: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4157: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4158: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4159: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4160: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4161: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4162: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4163: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4164: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4165: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4166: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4167: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4168: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4169: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4170: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4171: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4172: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4173: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4174: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
02:51 +4175: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: the Leaderboard tab is the real board, not a placeholder
02:51 +4176: F:/level/level_up/wt_cld/test/features/shell/main_shell_test.dart: the Leaderboard tab is the real board, not a placeholder
02:51 +4177: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: no invented data a shell fetches nothing
02:51 +4178: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: no invented data a shell fetches nothing
02:51 +4179: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
02:52 +4180: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
02:52 +4181: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
02:52 +4182: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
02:52 +4183: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
02:52 +4184: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
02:52 +4185: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4186: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4187: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4188: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4189: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4190: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4191: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4192: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4193: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4194: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4195: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4196: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4197: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4198: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4199: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4200: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4201: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4202: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4203: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4204: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4205: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4206: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4207: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4208: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4209: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4210: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4211: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4212: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4213: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4214: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4215: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4216: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4217: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4218: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4219: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4220: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4221: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4222: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4223: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4224: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4225: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4226: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:52 +4227: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4228: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4229: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4230: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4231: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4232: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4233: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4234: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4235: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4236: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4237: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4238: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4239: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4240: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4241: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4242: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4243: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4244: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4245: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4246: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4247: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4248: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4249: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4250: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4251: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4252: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4253: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4254: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4255: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4256: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4257: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4258: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4259: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4260: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4261: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4262: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4263: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4264: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4265: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4266: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4267: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4268: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4269: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4270: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4271: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4272: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4273: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:53 +4274: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en loading: a spinner, with the create card above it
02:54 +4275: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4276: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4277: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4278: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4279: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4280: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4281: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4282: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4283: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4284: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4285: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4286: F:/level/level_up/wt_cld/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
02:54 +4287: F:/level/level_up/wt_cld/test/features/support/support_list_screen_test.dart: the four states en error: genericError, the card stays, a Retry that re-asks
02:54 +4288: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:54 +4289: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:54 +4290: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:54 +4291: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4292: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4293: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4294: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4295: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4296: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4297: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4298: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4299: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4300: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4301: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4302: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4303: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4304: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4305: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4306: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4307: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4308: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4309: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4310: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4311: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4312: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4313: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4314: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4315: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4316: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4317: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4318: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4319: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4320: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4321: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4322: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4323: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4324: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4325: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4326: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4327: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4328: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4329: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4330: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:55 +4331: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4332: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4333: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4334: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4335: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4336: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4337: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4338: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4339: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4340: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4341: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4342: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4343: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4344: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4345: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4346: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4347: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4348: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4349: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4350: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4351: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4352: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4353: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4354: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4355: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4356: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4357: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4358: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4359: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4360: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4361: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4362: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4363: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4364: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4365: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4366: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4367: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4368: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4369: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4370: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4371: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4372: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4373: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4374: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4375: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4376: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4377: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4378: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4379: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4380: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4381: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4382: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4383: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4384: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4385: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4386: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4387: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4388: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4389: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4390: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4391: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4392: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4393: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4394: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4395: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4396: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4397: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4398: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4399: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4400: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4401: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4402: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4403: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4404: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4405: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4406: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4407: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4408: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4409: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4410: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4411: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4412: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4413: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4414: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4415: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4416: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4417: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4418: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4419: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4420: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4421: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4422: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4423: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4424: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:56 +4425: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4426: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4427: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4428: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4429: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4430: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4431: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4432: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4433: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/new resolves to the create screen, without a nav bar
02:57 +4434: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4435: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4436: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4437: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4438: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4439: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4440: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4441: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4442: F:/level/level_up/wt_cld/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
02:57 +4443: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4444: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4445: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4446: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4447: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4448: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4449: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4450: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4451: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4452: F:/level/level_up/wt_cld/test/features/support/support_routes_test.dart: through the real router /support/tickets/x resolves to the thread for "x"
02:57 +4453: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:57 +4454: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:57 +4455: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:57 +4456: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:57 +4457: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:57 +4458: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4459: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4460: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4461: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4462: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4463: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4464: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4465: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4466: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4467: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4468: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4469: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4470: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4471: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4472: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4473: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4474: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4475: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4476: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4477: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4478: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4479: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4480: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4481: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4482: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:58 +4483: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4484: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4485: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4486: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4487: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4488: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4489: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4490: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4491: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4492: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4493: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4494: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4495: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the four states en loading: a spinner, and the way back is already there
02:59 +4496: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
02:59 +4497: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
02:59 +4498: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
02:59 +4499: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
03:00 +4500: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
03:00 +4501: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
03:00 +4502: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
03:00 +4503: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
03:00 +4504: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
03:00 +4505: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: level card ┬╖ light
03:00 +4506: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4507: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4508: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4509: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4510: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4511: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4512: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4513: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4514: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4515: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4516: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4517: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4518: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4519: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4520: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4521: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4522: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4523: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4524: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:00 +4525: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:01 +4526: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:01 +4527: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:01 +4528: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:01 +4529: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:01 +4530: F:/level/level_up/wt_cld/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
03:01 +4531: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:01 +4532: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:01 +4533: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:01 +4534: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:01 +4535: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:01 +4536: F:/level/level_up/wt_cld/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:01 +4537: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4538: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4539: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4540: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4541: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4542: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4543: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4544: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4545: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4546: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4547: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4548: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4549: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4550: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:01 +4551: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4552: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4553: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4554: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4555: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4556: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4557: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4558: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4559: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4560: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4561: F:/level/level_up/wt_cld/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
03:02 +4562: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4563: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4564: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4565: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4566: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4567: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4568: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4569: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4570: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4571: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4572: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4573: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
03:02 +4574: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:02 +4575: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:02 +4576: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4577: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4578: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4579: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4580: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4581: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4582: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4583: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4584: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4585: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4586: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4587: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4588: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4589: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4590: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4591: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4592: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4593: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4594: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4595: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4596: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4597: F:/level/level_up/wt_cld/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
03:03 +4598: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4599: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4600: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4601: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4602: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4603: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4604: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4605: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4606: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4607: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4608: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4609: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4610: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:03 +4611: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4612: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4613: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4614: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4615: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4616: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4617: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4618: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4619: F:/level/level_up/wt_cld/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
03:04 +4620: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4621: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4622: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4623: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4624: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4625: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4626: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4627: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4628: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4629: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4630: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4631: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4632: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4633: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4634: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4635: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4636: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4637: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
03:04 +4638: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a failed page: scrolling to and fro asks nothing more, only Retry does
03:04 +4639: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 1 selected
03:04 +4640: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling it opens scrolled to the END of a long thread
03:04 +4641: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 2 selected
03:04 +4642: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4643: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4644: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4645: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4646: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4647: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4648: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4649: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4650: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4651: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4652: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4653: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4654: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4655: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: paging and scrolling a send scrolls to the end
03:05 +4656: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ dark ┬╖ tab 3 selected
03:05 +4657: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4658: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4659: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4660: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4661: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4662: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4663: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4664: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4665: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4666: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4667: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4668: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4669: F:/level/level_up/wt_cld/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
03:05 +4670: F:/level/level_up/wt_cld/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ dark ┬╖ tab 4 selected
03:05 +4671: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4672: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4673: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4674: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4675: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4676: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4677: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4678: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4679: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4680: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4681: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4682: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4683: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4684: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4685: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4686: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4687: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4688: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4689: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4690: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4691: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4692: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4693: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4694: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4695: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field holds at most 4000 characters
03:05 +4696: F:/level/level_up/wt_cld/test/guards/rules_test.dart: ARB key drift detects a key missing from Arabic
03:05 +4697: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4698: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4699: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4700: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4701: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4702: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4703: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4704: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4705: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4706: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4707: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4708: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4709: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4710: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4711: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4712: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4713: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4714: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4715: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4716: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4717: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4718: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4719: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4720: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4721: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the field is at least 56 high and the bar sits at the bottom
03:05 +4722: F:/level/level_up/wt_cld/test/guards/rules_test.dart: mirror-glyph swaps (the RTL double flip) allows the unconditional LTR glyph
03:05 +4723: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the send tap target is exactly 48 x 48 (the glyph itself is 24), disabled, enabled and in flight
03:05 +4724: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the send tap target is exactly 48 x 48 (the glyph itself is 24), disabled, enabled and in flight
03:05 +4725: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the send tap target is exactly 48 x 48 (the glyph itself is 24), disabled, enabled and in flight
03:05 +4726: F:/level/level_up/wt_cld/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a failing run reports its failures ΓÇö the 2026-09-12 defect
03:05 +4727: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:05 +4728: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:05 +4729: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:05 +4730: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:05 +4731: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:05 +4732: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:05 +4733: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:06 +4734: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:06 +4735: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:06 +4736: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:06 +4737: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:06 +4738: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a tap anywhere on the pill, its padding included, focuses the field
03:06 +4739: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer nothing to send: the glyph does nothing, an empty or blank text sends nothing
03:06 +4740: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer tapping the glyph sends the TRIMMED text, appends it as You, clears the field and asks the list again
03:06 +4741: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4742: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4743: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4744: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4745: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4746: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4747: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4748: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer the keyboard's Send action sends, exactly like the glyph
03:06 +4749: F:/level/level_up/wt_cld/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint every runnable release-build command pairs --flavor with a matching entrypoint
03:06 +4750: F:/level/level_up/wt_cld/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint every runnable release-build command pairs --flavor with a matching entrypoint
03:06 +4751: F:/level/level_up/wt_cld/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint every runnable release-build command pairs --flavor with a matching entrypoint
03:07 +4752: F:/level/level_up/wt_cld/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint every runnable release-build command pairs --flavor with a matching entrypoint
03:07 +4753: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a failed send ┬╖ en 429 with a Retry-After: rateLimitedIn(seconds)
03:07 +4754: F:/level/level_up/wt_cld/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the scan actually finds the release commands it is guarding
03:07 +4755: F:/level/level_up/wt_cld/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the scan actually finds the release commands it is guarding
03:07 +4756: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: (setUpAll)
03:07 +4757: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: (setUpAll)
03:07 +4758: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: (setUpAll)
03:07 +4759: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: (setUpAll)
03:07 +4759: F:/level/level_up/wt_cld/test/features/support/support_ticket_screen_test.dart: the composer a failed send ┬╖ en pending deletion: its own copy
03:07 +4760: F:/level/level_up/wt_cld/test/guards/workflow_test.dart: the Dart layer of the flavor contract stays intact (CW18a) AppConfig.init is called by bootstrap() and by the mock entrypoint, nowhere else
03:07 +4761: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4762: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4763: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4764: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4765: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4766: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4767: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4768: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4769: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4770: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:07 +4771: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:08 +4772: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:08 +4773: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:08 +4774: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:08 +4775: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:08 +4776: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:08 +4777: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:08 +4778: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:09 +4779: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:09 +4780: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:09 +4781: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:09 +4782: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:09 +4783: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:09 +4784: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:09 +4785: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:10 +4786: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:10 +4787: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:10 +4788: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:10 +4789: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:10 +4790: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:10 +4791: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:10 +4792: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:11 +4793: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:11 +4794: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:11 +4795: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:11 +4796: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:11 +4797: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:11 +4798: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:11 +4799: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4799: F:/level/level_up/wt_cld/test/journeys/harness_selfcheck_test.dart: overflow capture sees an overflow (positive control)
OVERFLOW[journey] (known) right 0.697px @ lib/features/home/widgets/level_card.dart:140
OVERFLOW[journey] (known) right 14px @ lib/features/home/widgets/coming_soon_section.dart:88
OVERFLOW[journey] (known) right 14px @ lib/features/home/widgets/coming_soon_section.dart:88
OVERFLOW[journey] (known) right 46px @ lib/features/home/widgets/top_student_section.dart:277
OVERFLOW[journey] (known) right 54px @ lib/features/home/widgets/top_student_section.dart:277
OVERFLOW[journey] (known) right 48px @ lib/features/home/widgets/top_student_section.dart:277
03:12 +4800: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4801: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4802: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4803: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4804: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4805: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4806: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4807: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4808: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4809: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:12 +4810: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:13 +4811: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:13 +4812: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:13 +4813: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:13 +4814: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:14 +4814: F:/level/level_up/wt_cld/test/journeys/banned_journey_test.dart: banned account in en
unhandled element <filter/>; Picture key: Svg loader
03:14 +4815: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:14 +4816: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:16 +4817: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:16 +4818: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:16 +4819: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in en
03:16 +4820: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:17 +4821: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:17 +4822: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:18 +4823: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:19 +4824: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:19 +4825: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:19 +4826: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:20 +4827: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
03:20 +4828: F:/level/level_up/wt_cld/test/journeys/double_tap_journey_test.dart: a double tap sends one request, in en
unhandled element <filter/>; Picture key: Svg loader
03:20 +4829: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:21 +4830: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:21 +4831: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:21 +4832: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:22 +4833: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:22 +4834: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:23 +4835: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:23 +4836: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:23 +4837: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:24 +4838: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:24 +4839: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:25 +4840: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:25 +4841: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:25 +4842: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
03:26 +4843: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step in en
unhandled element <filter/>; Picture key: Svg loader
03:26 +4844: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens at 2.0x in en
03:27 +4845: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens at 2.0x in en
03:27 +4846: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens at 2.0x in en
03:27 +4847: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens at 2.0x in en
03:27 +4848: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens at 2.0x in en
03:27 +4849: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:28 +4850: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:28 +4851: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:29 +4852: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:30 +4853: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:31 +4854: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:32 +4855: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:32 +4856: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:32 +4857: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a school student in en
03:34 +4858: F:/level/level_up/wt_cld/test/journeys/settings_support_journey_test.dart: settings and support in en
03:34 +4858: F:/level/level_up/wt_cld/test/journeys/signed_out_journey_test.dart: signed-out journey, starting in en
unhandled element <filter/>; Picture key: Svg loader
03:34 +4859: F:/level/level_up/wt_cld/test/journeys/settings_support_journey_test.dart: settings and support in en
03:35 +4860: F:/level/level_up/wt_cld/test/journeys/settings_support_journey_test.dart: settings and support in en
03:35 +4861: F:/level/level_up/wt_cld/test/journeys/settings_support_journey_test.dart: settings and support in en
03:35 +4862: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:36 +4863: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:37 +4864: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:37 +4865: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:38 +4866: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:38 +4866: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 360x800 1.0x en
unhandled element <filter/>; Picture key: Svg loader
03:38 +4867: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:38 +4868: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:38 +4869: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:38 +4870: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:39 +4871: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
03:39 +4872: F:/level/level_up/wt_cld/test/journeys/sign_out_guard_journey_test.dart: sign out and the guards in en
unhandled element <filter/>; Picture key: Svg loader
03:39 +4873: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step, dark, in ar
03:39 +4874: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step, dark, in ar
03:41 +4875: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step, dark, in ar
03:41 +4876: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step, dark, in ar
03:42 +4877: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step, dark, in ar
03:42 +4878: F:/level/level_up/wt_cld/test/journeys/offline_journey_test.dart: offline at every kind of step, dark, in ar
03:43 +4879: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:43 +4880: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:43 +4881: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:43 +4882: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:44 +4883: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:44 +4884: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:46 +4885: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:46 +4886: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:47 +4887: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:47 +4888: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x en
03:47 +4889: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:47 +4890: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:48 +4891: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:49 +4892: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:49 +4893: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:50 +4894: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:50 +4895: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:50 +4896: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:51 +4897: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
03:53 +4898: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in en
unhandled element <filter/>; Picture key: Svg loader
03:53 +4899: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain in en
03:53 +4900: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain in en
03:53 +4901: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x800 1.0x en
03:55 +4902: F:/level/level_up/wt_cld/test/journeys/registration_journey_test.dart: register a university student, dark, in ar
03:55 +4903: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in ar
03:55 +4904: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in ar
03:57 +4905: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in ar
03:57 +4906: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in ar
03:57 +4907: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in ar
03:57 +4908: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in ar
03:58 +4909: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain at 2.0x in en
03:59 +4910: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain at 2.0x in en
03:59 +4911: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain at 2.0x in en
04:00 +4912: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x800 1.0x en
04:00 +4912: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: OS Back on the OTP success view in en
unhandled element <filter/>; Picture key: Svg loader
04:00 +4913: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x800 1.0x en
04:01 +4914: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x800 1.0x en
04:01 +4915: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in the dark canvas in en
04:01 +4916: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in the dark canvas in en
04:03 +4917: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens in ar
04:03 +4918: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x800 1.0x en
04:03 +4919: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x800 1.0x en
04:04 +4920: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in the dark canvas in ar
04:04 +4921: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in the dark canvas in ar
04:05 +4922: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in the dark canvas in ar
04:06 +4923: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop in the dark canvas in ar
04:06 +4924: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x800 1.0x en
04:07 +4925: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: back from the Account hub's screens at 2.0x in ar
04:08 +4926: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in en
04:08 +4927: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in en
04:08 +4928: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in en
04:09 +4929: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in en
04:10 +4930: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x800 1.0x en
04:10 +4931: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x800 1.0x en
04:10 +4932: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in ar
04:11 +4933: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in ar
04:11 +4934: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in ar
04:12 +4935: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in ar
04:12 +4936: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in ar
04:12 +4937: F:/level/level_up/wt_cld/test/journeys/university_journey_test.dart: university learning loop at 2.0x text in ar
04:13 +4938: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: leaving a quiz in progress in ar
04:13 +4939: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: leaving a quiz in progress in ar
04:13 +4940: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x800 1.0x en
04:13 +4941: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: OS Back from the result and the review in ar
04:14 +4942: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: OS Back from the result and the review in ar
04:15 +4943: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 2.0x en
04:16 +4944: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 2.0x en
04:17 +4945: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: Home bell, Leaderboard chip and Mistakes, dark, in ar
04:17 +4946: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x800 2.0x en
04:17 +4947: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x800 2.0x en
04:18 +4948: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain in ar
04:19 +4949: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x800 2.0x en
04:20 +4950: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain, dark, in ar
04:21 +4951: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain, dark, in ar
04:22 +4952: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x800 2.0x en
04:23 +4953: F:/level/level_up/wt_cld/test/journeys/back_navigation_journey_test.dart: signed-out back chain at 2.0x in ar
04:23 +4954: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x800 2.0x en
04:24 +4955: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x800 2.0x en
04:24 +4956: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x800 2.0x en
04:25 +4957: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 360x800 2.0x en
04:25 +4958: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 360x800 2.0x en
04:25 +4959: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x800 2.0x en
04:27 +4960: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 360x800 2.0x en
04:28 +4961: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 360x800 2.0x en
04:28 +4962: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x800 2.0x en
04:29 +4963: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 360x800 2.0x en
04:30 +4964: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 360x800 2.0x en
04:31 +4965: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 360x800 2.0x en
04:31 +4966: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x800 2.0x en
04:32 +4967: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 360x800 1.0x ar
04:32 +4968: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 1.0x ar
04:34 +4969: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x800 1.0x ar
04:35 +4970: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x800 1.0x ar
04:37 +4971: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 360x800 1.0x ar
04:38 +4972: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x800 1.0x ar
04:39 +4973: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x800 1.0x ar
04:41 +4974: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 360x800 1.0x ar
04:41 +4975: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 360x800 1.0x ar
04:42 +4976: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x800 1.0x ar
04:43 +4977: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 360x800 1.0x ar
04:44 +4978: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 360x800 1.0x ar
04:44 +4979: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x800 1.0x ar
04:45 +4980: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 360x800 1.0x ar
04:46 +4981: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 360x800 1.0x ar
04:47 +4982: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 360x800 1.0x ar
04:47 +4983: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x800 1.0x ar
04:48 +4984: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 360x800 2.0x ar
04:48 +4985: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x800 2.0x ar
04:50 +4986: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x800 2.0x ar
04:51 +4987: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x800 2.0x ar
04:53 +4988: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 360x800 2.0x ar
04:54 +4989: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x800 2.0x ar
04:55 +4990: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x800 2.0x ar
04:57 +4991: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 360x800 2.0x ar
04:57 +4992: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 360x800 2.0x ar
04:57 +4993: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x800 2.0x ar
04:59 +4994: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 360x800 2.0x ar
05:00 +4995: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 360x800 2.0x ar
05:00 +4996: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x800 2.0x ar
05:01 +4997: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 360x800 2.0x ar
05:02 +4998: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 360x800 2.0x ar
05:03 +4999: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 360x800 2.0x ar
05:03 +5000: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x800 2.0x ar
05:03 +5001: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 360x640 1.0x en
05:04 +5002: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x640 1.0x en
05:06 +5003: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x640 1.0x en
05:07 +5004: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x640 1.0x en
05:08 +5005: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 360x640 1.0x en
05:09 +5006: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x640 1.0x en
05:10 +5007: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x640 1.0x en
05:12 +5008: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 360x640 1.0x en
05:12 +5009: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 360x640 1.0x en
05:12 +5010: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x640 1.0x en
05:14 +5011: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 360x640 1.0x en
05:14 +5012: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 360x640 1.0x en
05:15 +5013: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x640 1.0x en
05:16 +5014: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 360x640 1.0x en
05:16 +5015: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 360x640 1.0x en
05:17 +5016: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 360x640 1.0x en
05:18 +5017: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x640 1.0x en
05:18 +5018: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 360x640 2.0x en
05:18 +5019: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x640 2.0x en
05:20 +5020: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x640 2.0x en
05:21 +5021: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x640 2.0x en
05:23 +5022: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 360x640 2.0x en
05:24 +5023: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x640 2.0x en
05:25 +5024: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x640 2.0x en
05:27 +5025: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 360x640 2.0x en
05:27 +5026: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 360x640 2.0x en
05:27 +5027: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x640 2.0x en
05:29 +5028: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 360x640 2.0x en
05:30 +5029: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 360x640 2.0x en
05:30 +5030: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x640 2.0x en
05:31 +5031: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 360x640 2.0x en
05:31 +5032: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 360x640 2.0x en
05:32 +5033: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 360x640 2.0x en
05:33 +5034: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x640 2.0x en
05:33 +5035: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 360x640 1.0x ar
05:33 +5036: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x640 1.0x ar
05:35 +5037: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x640 1.0x ar
05:36 +5038: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x640 1.0x ar
05:38 +5039: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 360x640 1.0x ar
05:39 +5040: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x640 1.0x ar
05:40 +5041: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x640 1.0x ar
05:42 +5042: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 360x640 1.0x ar
05:42 +5043: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 360x640 1.0x ar
05:42 +5044: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x640 1.0x ar
05:43 +5045: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 360x640 1.0x ar
05:44 +5046: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 360x640 1.0x ar
05:44 +5047: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x640 1.0x ar
05:45 +5048: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 360x640 1.0x ar
05:46 +5049: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 360x640 1.0x ar
05:47 +5050: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 360x640 1.0x ar
05:47 +5051: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x640 1.0x ar
05:47 +5052: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 360x640 2.0x ar
05:48 +5053: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 360x640 2.0x ar
05:50 +5054: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 360x640 2.0x ar
05:51 +5055: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 360x640 2.0x ar
05:52 +5056: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 360x640 2.0x ar
05:53 +5057: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 360x640 2.0x ar
05:55 +5058: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 360x640 2.0x ar
05:56 +5059: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 360x640 2.0x ar
05:57 +5060: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 360x640 2.0x ar
05:57 +5061: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 360x640 2.0x ar
05:58 +5062: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 360x640 2.0x ar
05:59 +5063: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 360x640 2.0x ar
05:59 +5064: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 360x640 2.0x ar
06:00 +5065: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 360x640 2.0x ar
06:01 +5066: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 360x640 2.0x ar
06:02 +5067: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 360x640 2.0x ar
06:02 +5068: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 360x640 2.0x ar
06:02 +5069: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 320x568 1.0x en
06:03 +5070: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 320x568 1.0x en
06:05 +5071: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 320x568 1.0x en
06:06 +5072: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 320x568 1.0x en
06:07 +5073: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 320x568 1.0x en
06:08 +5074: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 320x568 1.0x en
06:09 +5075: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 320x568 1.0x en
06:11 +5076: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 320x568 1.0x en
06:11 +5077: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 320x568 1.0x en
06:11 +5078: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 320x568 1.0x en
06:13 +5079: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 320x568 1.0x en
06:13 +5080: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 320x568 1.0x en
06:14 +5081: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 320x568 1.0x en
06:15 +5082: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 320x568 1.0x en
06:15 +5083: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 320x568 1.0x en
06:17 +5084: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 320x568 1.0x en
06:17 +5085: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 320x568 1.0x en
06:17 +5086: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 320x568 2.0x en
06:17 +5087: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 320x568 2.0x en
06:20 +5088: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 320x568 2.0x en
06:21 +5089: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 320x568 2.0x en
06:22 +5090: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 320x568 2.0x en
06:23 +5091: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 320x568 2.0x en
06:24 +5092: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 320x568 2.0x en
06:26 +5093: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 320x568 2.0x en
06:26 +5094: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 320x568 2.0x en
06:26 +5095: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 320x568 2.0x en
06:28 +5096: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 320x568 2.0x en
06:28 +5097: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 320x568 2.0x en
06:28 +5098: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 320x568 2.0x en
06:29 +5099: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 320x568 2.0x en
06:30 +5100: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 320x568 2.0x en
06:31 +5101: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 320x568 2.0x en
06:31 +5102: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 320x568 2.0x en
06:31 +5103: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 320x568 1.0x ar
06:32 +5104: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 320x568 1.0x ar
06:34 +5105: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 320x568 1.0x ar
06:35 +5106: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 320x568 1.0x ar
06:36 +5107: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 320x568 1.0x ar
06:37 +5108: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 320x568 1.0x ar
06:39 +5109: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 320x568 1.0x ar
06:40 +5110: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 320x568 1.0x ar
06:41 +5111: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 320x568 1.0x ar
06:41 +5112: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 320x568 1.0x ar
06:42 +5113: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 320x568 1.0x ar
06:43 +5114: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 320x568 1.0x ar
06:43 +5115: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 320x568 1.0x ar
06:44 +5116: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 320x568 1.0x ar
06:45 +5117: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 320x568 1.0x ar
06:46 +5118: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 320x568 1.0x ar
06:46 +5119: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 320x568 1.0x ar
06:46 +5120: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, 320x568 2.0x ar
06:46 +5121: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, 320x568 2.0x ar
06:48 +5122: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, 320x568 2.0x ar
06:50 +5123: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, 320x568 2.0x ar
06:51 +5124: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, 320x568 2.0x ar
06:52 +5125: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, 320x568 2.0x ar
06:54 +5126: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, 320x568 2.0x ar
06:55 +5127: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, 320x568 2.0x ar
06:55 +5128: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, 320x568 2.0x ar
06:56 +5129: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, 320x568 2.0x ar
06:57 +5130: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, 320x568 2.0x ar
06:58 +5131: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, 320x568 2.0x ar
06:58 +5132: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, 320x568 2.0x ar
06:59 +5133: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, 320x568 2.0x ar
06:59 +5134: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, 320x568 2.0x ar
07:00 +5135: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, 320x568 2.0x ar
07:01 +5136: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, 320x568 2.0x ar
07:01 +5137: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, landscape 915x412 1.0x en
07:01 +5138: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, landscape 915x412 1.0x en
07:03 +5139: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, landscape 915x412 1.0x en
07:04 +5140: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, landscape 915x412 1.0x en
07:05 +5141: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, landscape 915x412 1.0x en
07:06 +5142: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, landscape 915x412 1.0x en
07:08 +5143: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, landscape 915x412 1.0x en
07:10 +5144: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, landscape 915x412 1.0x en
07:10 +5145: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, landscape 915x412 1.0x en
07:10 +5146: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, landscape 915x412 1.0x en
07:11 +5147: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, landscape 915x412 1.0x en
07:12 +5148: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, landscape 915x412 1.0x en
07:12 +5149: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, landscape 915x412 1.0x en
07:13 +5150: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, landscape 915x412 1.0x en
07:14 +5151: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, landscape 915x412 1.0x en
07:15 +5152: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, landscape 915x412 1.0x en
07:15 +5153: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, landscape 915x412 1.0x en
07:16 +5154: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, landscape 915x412 1.0x ar
07:16 +5155: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, landscape 915x412 1.0x ar
07:18 +5156: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, landscape 915x412 1.0x ar
07:19 +5157: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, landscape 915x412 1.0x ar
07:20 +5158: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, landscape 915x412 1.0x ar
07:21 +5159: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, landscape 915x412 1.0x ar
07:22 +5160: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, landscape 915x412 1.0x ar
07:24 +5161: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, landscape 915x412 1.0x ar
07:24 +5162: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, landscape 915x412 1.0x ar
07:24 +5163: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, landscape 915x412 1.0x ar
07:26 +5164: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, landscape 915x412 1.0x ar
07:26 +5165: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, landscape 915x412 1.0x ar
07:27 +5166: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, landscape 915x412 1.0x ar
07:28 +5167: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, landscape 915x412 1.0x ar
07:29 +5168: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, landscape 915x412 1.0x ar
07:30 +5169: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, landscape 915x412 1.0x ar
07:30 +5170: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, landscape 915x412 1.0x ar
07:30 +5171: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, landscape 640x360 1.0x en
07:31 +5172: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, landscape 640x360 1.0x en
07:33 +5173: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, landscape 640x360 1.0x en
07:34 +5174: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, landscape 640x360 1.0x en
07:35 +5175: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, landscape 640x360 1.0x en
07:36 +5176: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, landscape 640x360 1.0x en
07:37 +5177: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, landscape 640x360 1.0x en
07:39 +5178: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, landscape 640x360 1.0x en
07:39 +5179: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, landscape 640x360 1.0x en
07:39 +5180: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, landscape 640x360 1.0x en
07:41 +5181: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, landscape 640x360 1.0x en
07:41 +5182: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, landscape 640x360 1.0x en
07:41 +5183: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, landscape 640x360 1.0x en
07:42 +5184: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, landscape 640x360 1.0x en
07:43 +5185: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, landscape 640x360 1.0x en
07:44 +5186: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, landscape 640x360 1.0x en
07:44 +5187: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, landscape 640x360 1.0x en
07:44 +5188: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out journey, landscape 640x360 1.0x ar
07:45 +5189: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: university learning loop, landscape 640x360 1.0x ar
07:47 +5190: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: sign out and the guards, landscape 640x360 1.0x ar
07:48 +5191: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a school student, landscape 640x360 1.0x ar
07:49 +5192: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: register a university student, landscape 640x360 1.0x ar
07:50 +5193: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: offline at every kind of step, landscape 640x360 1.0x ar
07:52 +5194: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: a double tap sends one request, landscape 640x360 1.0x ar
07:54 +5195: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: OS Back on the OTP success view, landscape 640x360 1.0x ar
07:54 +5196: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: two taps in one frame send one OTP request, landscape 640x360 1.0x ar
07:54 +5197: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: signed-out back chain, landscape 640x360 1.0x ar
07:55 +5198: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: banned account, landscape 640x360 1.0x ar
07:56 +5199: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed out, landscape 640x360 1.0x ar
07:56 +5200: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: learning loop, landscape 640x360 1.0x ar
07:57 +5201: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: profile edit, landscape 640x360 1.0x ar
07:58 +5202: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: settings and support, landscape 640x360 1.0x ar
07:59 +5203: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: notifications, landscape 640x360 1.0x ar
07:59 +5204: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: legal documents signed in, landscape 640x360 1.0x ar
07:59 +5205: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back from the Account hub screens, 360x640 2.0x en
08:00 +5206: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back through the Learn drill-down, 360x640 2.0x en
08:01 +5207: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: leaving a quiz in progress, 360x640 2.0x en
08:02 +5208: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: roots, cold links and unknown routes, 360x640 2.0x en
08:03 +5209: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back from the Account hub screens, 360x640 2.0x ar
08:04 +5210: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back through the Learn drill-down, 360x640 2.0x ar
08:05 +5211: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: leaving a quiz in progress, 360x640 2.0x ar
08:06 +5212: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: roots, cold links and unknown routes, 360x640 2.0x ar
08:06 +5213: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back from the Account hub screens, 320x568 1.0x en
08:08 +5214: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back through the Learn drill-down, 320x568 1.0x en
08:08 +5215: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: leaving a quiz in progress, 320x568 1.0x en
08:09 +5216: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: roots, cold links and unknown routes, 320x568 1.0x en
08:10 +5217: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back from the Account hub screens, 320x568 1.0x ar
08:11 +5218: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back through the Learn drill-down, 320x568 1.0x ar
08:12 +5219: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: leaving a quiz in progress, 320x568 1.0x ar
08:12 +5220: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: roots, cold links and unknown routes, 320x568 1.0x ar
08:13 +5221: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back from the Account hub screens, landscape 915x412 1.0x en
08:15 +5222: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back through the Learn drill-down, landscape 915x412 1.0x en
08:16 +5223: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: leaving a quiz in progress, landscape 915x412 1.0x en
08:16 +5224: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: roots, cold links and unknown routes, landscape 915x412 1.0x en
08:17 +5225: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back from the Account hub screens, landscape 915x412 1.0x ar
08:18 +5226: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: back through the Learn drill-down, landscape 915x412 1.0x ar
08:19 +5227: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: leaving a quiz in progress, landscape 915x412 1.0x ar
08:20 +5228: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: roots, cold links and unknown routes, landscape 915x412 1.0x ar
08:21 +5229: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: 320x568 2.0x en: Get Started reaches Login
08:21 +5230: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: 320x568 2.0x en: Log In reaches Login
08:21 +5231: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: 320x568 2.0x ar: Get Started reaches Login
08:21 +5232: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: 320x568 2.0x ar: Log In reaches Login
08:21 +5233: F:/level/level_up/wt_cld/test/journeys/small_phone_journey_test.dart: (tearDownAll)
08:21 +5233: All tests passed!
```

