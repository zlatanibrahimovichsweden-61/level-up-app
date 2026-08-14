# Agent 8 — Testing & QA

**Scope:** the whole of `test/` (66 files, 15,069 LOC), read against `lib/` (178 files).
Coverage map by feature × layer, structural blind spots of the BUG-001 class,
brittleness, test *quality*, missing edge cases, the integration-test gap, and a
lift-ready `TESTING.md` section.
**Baseline:** dev @ e3651e6
**Repository areas inspected:** all of `test/`; `lib/core/router/app_router.dart`,
`lib/core/providers/core_providers.dart`, `lib/core/storage/{secure_storage,preferences_store}.dart`,
`lib/core/network/interceptors/*`, `lib/app.dart`, `lib/bootstrap.dart`,
`lib/features/auth/notifier/otp_notifier.dart`, `lib/features/quiz/screens/screen_protection.dart`,
`lib/features/registration/screens/*`, `lib/l10n/app_{en,ar}.arb`,
`docs/KNOWN_BUGS.md`.

## Headline

**This suite is well above average and the brief's priors were mostly wrong.** Before
anything else, four corrections to the assumptions I was given, all evidenced:

- `lib/features/subscription/` and `lib/features/track/` contain **eight `.gitkeep` files
  and zero Dart**. They are not untested — they are unimplemented. No finding.
- `home` has no repository. Home reads `profileRepositoryProvider`
  (`lib/features/home/screens/home_screen.dart`). Nothing is missing.
- `account_shells` is **well covered**: `test/features/settings/shell_screens_test.dart`
  is 14 tests across 6 groups, driven through the real router, including AR and dark.
- Concurrent-401 token refresh **is** tested, precisely:
  `test/core/network/auth_interceptor_test.dart:163` — three parallel requests, one refresh.

Counts I measured: **731** `test(`/`testWidgets(` sites + **29** `blocTest<>` = ~760 cases
in 57 real test files (9 of the 66 are harness/fixture files with no cases).
**43** cases pump or assert in `ar` (5.7%). **24** touch dark, of which only **6** assert a
dark-specific *value*. **18** golden PNGs, **all English**. **0** `integration_test/`.

The real risk is not the number of tests. It is that four specific seams are structurally
invisible to every one of them, and one of those seams is the exact one BUG-001 lived in.

---

## Coverage map

Legend: **●** well covered · **◐** thin · **○** absent · **–** not applicable (no such layer)

| Feature | model | repository | notifier / bloc | screen | navigation (real router) |
|---|---|---|---|---|---|
| auth | ● `auth_result_test`, `phone_test` | **○ no `auth_repository_test.dart`** | ● `auth_controller_test`, `verify_fork_test` | ◐ `otp_screen_test` (3 cases), `login_validation_test` | ● `registration_router_flow_test`, `app_router_test` |
| registration | ● `register_body_test` (43), `registration_controller_test` | ● `registration_repository_test`, `reference_repository_test` | ● `registration_submit_notifier_test`, `school_search_notifier_test` | ● 3 screen files, 68 cases | ◐ front two screens only — see F-8-01 |
| home | – | – (uses profile) | – | ● `home_screen_test` (16) | ● via `main_shell_test` |
| catalog | ● `catalog_models_test` | ● `catalog_repository_test` | ● `catalog_notifier_test` | ● `subjects_/lectures_screen_test` | ● `catalog_navigation_test` (16) |
| quiz | ● `quiz_models_test` (25) | ● `quiz_repository_test` | ● `quiz_bloc_test` (29 blocTests) | ● 3 screen files, 52 cases | ● `quiz_harness` real router; **○ the `/quiz/:id` no-`extra` branch** |
| profile | ● `profile_models_test`, `profile_update_test` | ● `profile_repository_test` | ● `me_notifier_test` | ● `profile_screen_test`, `edit_profile_screen_test` | ● `pumpProfileApp` |
| settings | – | – | ◐ via `preferences_store_test` | ● `settings_screen_test` (28) | ● `pumpAppAt` boots real `LevelUpApp` |
| onboarding | – | – | – | ● `onboarding_screen_test` (13, full ar×theme matrix) | ● reached in `registration_router_flow_test:130` |
| shell | – | – | – | ● `main_shell_test`, `nav_centre_tab_test` | ● |
| account_shells | – | – | – | ● `shell_screens_test` (14) | ● |
| subscription | – | – | – | – | ○ `/subscription`, `/subscription/return` are untested `_Placeholder`s |
| track | – | – | – | – | ○ `/track-select` same |
| core | ● `date_only_converter_test` | ● `auth_/error_interceptor_test` | ● `preferences_store_test` | ◐ `app_colors_test`, `palette_discipline_test` | ● `app_router_test` |

### Named files with no test that imports them (the honest list)

103 of 178 `lib/` files are imported by at least one test. Of the 75 that are not, most
are `.freezed.dart`/`.g.dart` (32) or entrypoints (6) — correctly excluded. The
**substantive** untested files are:

| File | Why it matters |
|---|---|
| `lib/features/auth/notifier/login_notifier.dart` | the only notifier in the app with no test of any kind |
| `lib/features/registration/notifier/reference_providers.dart` | the provider layer over `/reference/*`; caching/keying untested |
| `lib/features/quiz/notifier/quiz_setup_notifier.dart` | exercised only through `quiz_setup_screen_test` |
| `lib/features/profile/notifier/edit_profile_notifier.dart` | exercised only through `edit_profile_screen_test` |
| `lib/features/registration/screens/registration_expired_view.dart` | the expiry *view*; expiry logic is tested, this widget is never named |
| `lib/core/widgets/state_widget.dart`, `form_fields.dart`, `titled_chrome.dart`, `circle_back_button.dart` | four shared core widgets, exercised only incidentally |
| `lib/core/network/dio_client.dart` | interceptor *wiring* order is never asserted |
| `lib/bootstrap.dart`, `lib/app.dart` | `app.dart` is in-tree via `settings_harness`; `bootstrap.dart` is not covered at all |
| `lib/features/{auth,profile,registration}/*_error_copy.dart` | error→copy maps; covered only via the screens that use them |
| `lib/features/quiz/widgets/{ai_explanation_panel,mcq_renderer,question_renderer}.dart` | covered via `quiz_screen_test`, never in isolation |

---

## Findings

### F-8-01 [HIGH] [ARCHITECTURE ISSUE] The two screens that turn a registration into a session never run through the real router

**Evidence:** `test/features/registration/school_detail_screen_test.dart:63-77` and
`test/features/registration/university_detail_screen_test.dart` both build a
**synthetic single-route `GoRouter`** whose `/home` is `marker('HOME')`, not the real
shell. `test/features/registration/registration_router_flow_test.dart` — the one
router-driven wizard test — stops at `/register/track` (line 184).
The production path is `registration_submit_notifier.dart:86`
(`markAuthenticated()`) → `school_detail_screen.dart:345` (`context.go('/home')`), which
crosses `authRedirect` (`lib/core/router/app_router.dart:66`) mid-flight.

**Why it matters:** this is BUG-001's exact shape. The defect class is *"a screen behaves
differently when mounted into an existing tree by the real router than when pumped into a
fresh scope."* The wizard's terminal transition — unauthenticated → `POST /auth/register`
→ tokens → `markAuthenticated()` → `refreshListenable` fires → guard re-runs → `go('/home')`
→ `StatefulShellRoute` builds → `HomeScreen` fetches `/me` — involves a provider mutation
racing a router rebuild, and **nothing tests it**. Concrete plausible bug: `markAuthenticated()`
flips the listenable *before* `context.go('/home')` runs, so the guard sees
`AuthAuthenticated` at `/register/school`, returns `null` (register routes are auth routes
by `_atAuthRoute`), then the explicit `go('/home')` lands — fine today. Change
`_signedInLandingRedirects` to include `/register*` and the student is bounced to `/home`
before the success state renders, losing the confirmation. 68 green registration tests
would not notice.

**Recommended fix:** extend `registration_router_flow_test.dart` with one case per track
that walks identity → track → detail form → submit → asserts `locationOf(container) ==
'/home'` and `find.byType(HomeScreen)`, through `container.read(routerProvider)`. Keep the
file's existing doc comment discipline ("Keep this test router-driven").

**Risk of fixing:** LOW. Additive. Needs `pumpFrames` rather than `pumpAndSettle`
(same Pinput/auto-focus problem `KNOWN_BUGS.md` records).

**Validation required:** none beyond running the suite.

---

### F-8-02 [HIGH] [BUG] The OTP resend path — countdown, resend, rate-limit, expiry — has zero coverage

**Evidence:** `lib/features/auth/notifier/otp_notifier.dart:133-161` — `resend()` and
`_scheduleTicks()`. Grep for `.resend()` across `test/` returns **no call sites**
(only `find.widgetWithText(TextButton, 'Resend OTP')` at
`test/features/auth/otp_screen_test.dart:92,105`). Every OTP test constructs
`OtpArgs(resendAfterSeconds: 0, ...)` — `otp_screen_test.dart:27`,
`verify_fork_test.dart:21`, `registration_router_flow_test.dart:65` — with the comment
*"no countdown timer is left pending at teardown."* The suite deliberately switches the
feature off to keep itself clean.

**Why it matters:** OTP is the only door into the app. Untested behaviour behind that door:
`Timer.periodic` decrementing to 0 and cancelling; `canResend` gating; the double-tap guard
(`isResending`); `resend()` restarting the countdown from a *fresh* `resendAfterSeconds`;
and the two contract codes `otp_rate_limited` / `otp_expired`. `otp_expired` appears in
`test/core/network/error_interceptor_test.dart:113` — mapped, but never surfaced through
`OtpNotifier` to any screen. Plausible concrete bug: a second `resend()` while the first
is in flight is guarded by `isResending`, but a resend that *throws* leaves
`secondsRemaining` at 0 with `canResend == true`, so the student can hammer the button
into a 429 loop; nothing tests it.

**Recommended fix:** three unit tests on `otpProvider` using `fakeAsync` or
`tester.pump(Duration(seconds: n))`: countdown reaches 0 and the timer cancels; `resend()`
at 0 restarts the countdown; `resend()` throwing `ApiException(429, 'otp_rate_limited')`
leaves an error and does **not** re-enable resend until the server's window.

**Risk of fixing:** LOW.

**Validation required:** confirm the contract code string for OTP throttling
(`contract/error-codes.md`) — `exceptions.dart:68` notes `otp_throttled` exists and is
deliberately not reused for generic 429s.

---

### F-8-03 [HIGH] [ARCHITECTURE ISSUE] Connectivity is never real in any test — `isOnlineProvider` is overridden 15 times, always with `Stream.value`

**Evidence:** 15 `isOnlineProvider.overrideWith(...)` sites across `test/`; every one is
`(ref) => Stream.value(true|false)`. The real provider is
`lib/core/providers/core_providers.dart:56` —
`conn.onConnectivityChanged.map(...)`, a *change* stream with **no seeded initial value**.

**Why it matters:** two distinct bug classes hide here.
1. **Cold-start offline.** `Stream.value(false)` emits synchronously on the first frame.
   The real stream emits nothing until connectivity *changes*, so `AsyncLoading.value` is
   `null` and every consumer's `.value == false` (18 call sites, e.g.
   `home_screen.dart:42`) evaluates to `offline == false`. A student launching in airplane
   mode sees the online UI and a generic error, not the offline view — while
   `home_screen_test.dart:153` proves the offline view works. The test proves the *widget*,
   not the *wiring*.
2. **Flapping.** No test emits more than one value. Going offline mid-request, or
   recovering mid-request, is untested everywhere.

**Recommended fix:** one test that overrides `connectivityProvider` (not `isOnlineProvider`)
with a fake `Connectivity` whose `onConnectivityChanged` is a `StreamController`, and
asserts (a) the first frame with nothing emitted does not show the offline banner, and
(b) emitting `none` then `wifi` mid-request flips the banner both ways. That is the honest
seam; overriding `isOnlineProvider` skips the thing under test.

**Risk of fixing:** LOW (test-only).

**Validation required:** whether `connectivity_plus` on this version emits the current
state on subscribe (platform-dependent). **Cannot be confirmed without the toolchain and a
device.** If it does seed, item 1 is a non-issue and only the flapping gap stands.

---

### F-8-04 [MEDIUM] [QUALITY IMPROVEMENT] `AuthRepository` is the only repository with no test

**Evidence:** `lib/features/auth/repository/auth_repository.dart` (114 lines) is imported
by 6 test files, always as `class MockAuthRepository extends Mock implements AuthRepository`.
Every peer has a dedicated file: `catalog_repository_test.dart`, `profile_repository_test.dart`,
`quiz_repository_test.dart`, `registration_repository_test.dart`, `reference_repository_test.dart`.

**Why it matters:** this is the over-mocking case in its purest form — **delete the body of
`AuthRepository` and replace it with `throw UnimplementedError()` and the entire suite
still goes green**, because nothing ever calls the real one. It owns `verifyOtp`'s
discriminated-union parse (`authenticated` vs `registrationRequired`), the `refresh` call
the `AuthInterceptor` depends on, and `DioException → AppException` unwrapping. A JSON
shape change in the auth contract lands as a red screen on device, not a red test.

**Recommended fix:** an `auth_repository_test.dart` in the shape of
`catalog_repository_test.dart` — `_MockDio`, fixture JSON, assert the fork parses, assert
`DioException.error` unwraps to the typed `AppException`.

**Risk of fixing:** LOW.

---

### F-8-05 [MEDIUM] [QUALITY IMPROVEMENT] Zero Arabic goldens, and most "dark theme" tests assert nothing about dark

**Evidence:** all 18 PNGs under `test/goldens/` are English —
`golden_harness.dart:69` defaults `locale: const Locale('en')` and no caller overrides it.
Of the 24 dark-touching cases, 5 are pure `PreferencesStore` reads
(`preferences_store_test.dart:35,45,93,120,139`) and several are content smoke tests
mislabelled: `quiz_screen_test.dart:504` "dark theme" asserts
`findsNWidgets(4)` option tiles and `find.text('Confirm')`;
`quiz_setup_screen_test.dart:334` "dark theme renders the same content" asserts two English
strings. Only **6** cases assert a dark-specific value
(`palette_discipline_test.dart:112`, `home_header_unread_test.dart:72`,
`shell_screens_test.dart:194`, `app_colors_test`, `settings_screen_test.dart:235,242`).

**Why it matters:** "RTL is a first-class requirement, Arabic is the baseline" is stated in
the project context but **pixel-unenforced**. Tajawal/Cairo have different ascent/descent
metrics from Inter; the nav bar notch, the level card's progress fill and the track card's
gradient border are all mirrored under RTL. A layout that overflows only in Arabic, or a
glyph that clips only in Tajawal, is invisible to 43 Arabic widget tests that assert
`find.text('…')` and `Directionality.of(...)` — neither of which measures a pixel.

**Recommended fix:** add `ar` to the golden loops. `design_goldens_test.dart:34` already
iterates `goldenBrightnesses`; nest a locale loop and regenerate → 36 files instead of 18.
Separately, rename the smoke-test cases so they stop claiming to test dark, or make them
assert an `AppColors.dark` token the way `shell_screens_test.dart:203` does.

**Risk of fixing:** MEDIUM — goldens are host-font-rendering sensitive and there is no CI
to pin the renderer. Regenerating on one machine and diffing on another produces noise.
Worth doing only once CI exists (Agent-infrastructure's scope).

**Validation required:** `flutter test --update-goldens test/goldens` on a canonical host.

---

### F-8-06 [MEDIUM] [QUALITY IMPROVEMENT] 397 hardcoded English string assertions couple the suite to copy, and prove nothing about Arabic

**Evidence:** 397 `find.text('<latin>')` / `find.widgetWithText(..., '<latin>')` sites vs
75 Arabic ones. Worst offenders: `quiz_screen_test.dart` (57),
`catalog_navigation_test.dart` (45), `lectures_screen_test.dart` (37),
`school_detail_screen_test.dart` (32), `home_screen_test.dart` (30).

**Why it matters:** two costs. (a) Every copy edit in `app_en.arb` breaks an unrelated test
— the classic pressure to "fix" a test by editing the expected string, which is the
weakening-to-get-green failure mode. (b) An English assertion in an English test says
nothing about whether the *key* is wired; a screen that hardcodes `Text('Continue')`
instead of `l10n.continueLabel` passes every English test and ships an untranslated string.
The project already has two suspected l10n leaks (`app_router.dart:347`,
`state_widget.dart:65`) and the suite cannot see them.

**Recommended fix:** do **not** mass-refactor — the readability of
`find.text('Choose Your Track')` is real value. Instead add the *guard* test in F-8-10
(no raw literal in `Text(` outside an allowlist), which catches the leak class directly and
costs one file.

**Risk of fixing:** LOW.

---

### F-8-07 [MEDIUM] [BUG] The deliberate `/quiz/:quizId` cold-deep-link fallback has no test

**Evidence:** `lib/core/router/app_router.dart:232-238` — `switch (state.extra)` with a
`_QuizUnavailableScreen` default, carrying a 6-line doc comment explaining it is
unrecoverable *by design*. Every quiz test pushes with `extra`
(`quiz_screen_test.dart:28`, `quiz_result_screen_test.dart:21`). Nothing pushes
`/quiz/anything` bare. Same for `/quiz/:id/result`, whose builder is
`state.extra! as QuizResultArgs` — a **non-null bang on `extra`** that will throw on a cold
link.

**Why it matters:** the same bang appears at `app_router.dart:78` (`/otp`) and
`:226` (`/quiz/setup`). Three routes crash with a cast error on a null `extra`; one route
(`/quiz/:quizId`) handles it gracefully. A deep link, a notification tap, or a process
death + restore hits exactly this. The graceful branch being untested means a refactor can
delete it silently.

**Recommended fix:** four small router tests pushing each `extra`-bang route bare and
asserting the intended behaviour (either the fallback screen, or a documented decision that
crashing is acceptable because nothing can produce that link).

**Risk of fixing:** LOW.

**Validation required:** whether deep links can reach these paths at all —
`TODO(deep-link)` at `app_router.dart:84` says the scheme is unregistered, so today they
may be unreachable. That would downgrade this to LOW.

---

### F-8-08 [LOW] [QUALITY IMPROVEMENT] Brittleness is low, but three patterns will bite

**Evidence and honest counts** — this suite is *not* brittle by the usual measures:

| Pattern | Count | Verdict |
|---|---|---|
| `find.byType(Container)` | 3 | 2 are `findsWidgets` (harmless); `palette_discipline_test.dart:100` is `tester.widget<Container>(find.byType(Container))` — **fails the moment `ProfileStatCard` gains a second `Container`** |
| index finders `.at(n)` | 7 | all `find.byType(TextField).at(0..2)` on the identity form — `registration_screens_test.dart:105,106,118,119,120`, `registration_router_flow_test.dart:179,180`. Reordering the three fields silently swaps name↔parent-phone and **the tests still pass**, because both accept any string |
| `pumpAndSettle(Duration)` | 0 | clean |
| bare `pump(const Duration(...))` | 6 | all justified in comments (SnackBar auto-hide, entrance animation, Pinput cursor) |
| `.first` / `.last` | 47 / 14 | ordinary disambiguation, mostly `find.text(x).last` for nav labels |
| order-dependent / shared mutable state | 0 | every fixture is a **function** returning a fresh map (`catalog_fixtures.dart`, `profile_fixtures.dart`, `quiz_fixtures.dart`); `setUpAll` is used only for `registerFallbackValue` and font loading; no top-level `late` in any test |

**Recommended fix:** give the three identity fields `Key`s and switch to `find.byKey` —
the codebase already does this elsewhere (`field-universityId`, `settings_mode_dark`,
`refer_share_button`). Narrow the `palette_discipline_test.dart:100` finder to
`find.descendant(of: find.byType(ProfileStatCard), matching: find.byType(Container)).first`.

**Risk of fixing:** LOW.

---

### F-8-09 [LOW] [QUALITY IMPROVEMENT] The tautology count is low, but the smoke-test genre is creeping in

Being blunt, as asked: I looked hard for `expect(find.byType(X), findsOneWidget)`
immediately after pumping `X` and **found almost none** — 22 regex hits, and on inspection
21 of them follow a `tap` and are legitimate navigation assertions
(`catalog_navigation_test.dart:58,64,70`, etc.). The real instances of the genre are the
matrix smoke tests: `onboarding_screen_test.dart:250` asserts
`OnboardingScreen` + one `FilledButton` + one `OutlinedButton` + `takeException() == null`
across 4 locale×theme combinations. That is a *crash* test wearing a *rendering* test's
label — useful, but it should say so.

Duplicated coverage is layered rather than redundant: `insufficient_scope` appears at
repository (`catalog_repository_test.dart:120`), notifier
(`catalog_notifier_test.dart:132`), screen (`lectures_screen_test.dart:456`) and
navigation (`catalog_navigation_test.dart:300`) level. Four assertions, four different
claims. Leave it.

The over-mocking problem is confined to F-8-04 (`AuthRepository`) plus
`lib/dev/mock_backend.dart`: **879 test LOC (5.8% of the suite) guards dev-only code that
never ships**. That is defensible — `mock_backend_catalog_test.dart:10` states the purpose
(keep the harness parsing into real models) and those tests *do* run mock JSON through
`Subject.fromJson`, so they are contract-shape guards, not mock-testing-mock. But note the
asymmetry: **the app is never driven against `mock_backend`**. No test overrides
`dioProvider` with `buildMockDio()` and pumps a screen. The mock's JSON and the screens'
mocktail stubs are two independent fixture universes, and **neither is validated against
`contract/openapi.yaml`**.

---

### F-8-10 [MEDIUM] [QUALITY IMPROVEMENT] The project should own more guard tests in the `palette_discipline_test` genre

**Evidence:** `test/core/theme/palette_discipline_test.dart` scans `lib/` source for
banned patterns and reports `path:line` on failure (lines 22-35). It exists because
*"the rule failed quietly for two months"* (line 13). It is the single highest-leverage
test in the repo per line of code.

I verified that **five more properties currently hold and are unenforced**, i.e. these
guards would go green today and lock the invariant permanently:

| Guard | Measured today |
|---|---|
| No provider mutation in `initState` (**the literal BUG-001 guard**) | 0 violations across all of `lib/` |
| `flutter_bloc` imported only under `lib/features/quiz/` | 0 violations |
| No `EdgeInsets.only(left:/right:)` or `fromLTRB` (RTL discipline) | 0 occurrences |
| ARB key parity `app_en.arb` ↔ `app_ar.arb` | 246 = 246, no orphans |
| No untranslated ARB values | 7 legitimately identical (`phoneHint`, `emailHint`, `languageArabicName`, …) — allowlist them |

**Why it matters:** each of these is a rule that lives in prose (the vault's
`01_Flutter_Specs/*.md`) and is currently enforced by nobody. With no CI and no git hooks,
a source-scanning test is the *only* enforcement mechanism this project has.

**Recommended fix:** one new file, `test/core/discipline_test.dart`, in the exact idiom of
`palette_discipline_test.dart` — same `hits(RegExp)` helper, same `path:line` failure
messages, same doc comment explaining what defect each rule prevents.

**Risk of fixing:** LOW. These are pure source scans; no runtime behaviour touched.

---

## Structural blind spots — the BUG-001 class, enumerated

**(a) Screens reached only by direct pump or a synthetic router, never by `routerProvider`.**
Only 8 test files touch `routerProvider`. The gaps:
`SchoolDetailScreen` and `UniversityDetailScreen` (synthetic 3-route `GoRouter`, F-8-01);
`OtpScreen` in `otp_screen_test.dart` (bare `MaterialApp(home:)` at line 46 — mitigated,
because `registration_router_flow_test` covers it router-driven);
`ProfileScreen` in `pumpProfileScreen` (explicitly documented as the cheap path, with
`pumpProfileApp` as the router path — this is the *right* pattern, copy it).
*Bug type:* provider mutated during element mount; `ref.listen` registered in a lifecycle
the router rebuilds differently; a `PopScope` that only matters when there is a real back
stack. *Concrete example:* `school_detail_screen.dart:328` and `:348` both use
`addPostFrameCallback` inside a `ref.listen` — under the synthetic router the frame after
`go('/home')` renders `marker('HOME')`, a `Scaffold` with a `Text`; under the real router it
renders `MainShell` + `StatefulShellRoute.indexedStack` + a `/me` fetch. Anything that
depends on the *next* frame having a real Navigator is untested.

**(b) What is only ever exercised against `mock_backend.dart`.** Inverted from the brief:
nothing in the *app* is exercised against it at all. `mock_backend.dart` (1,527 lines) is
reachable only from `lib/main_mock.dart:30`, and its four test files call `buildMockDio()`
directly. So the mock's happy path is well tested *as a mock*, and the app's happy path is
well tested *against mocktail stubs*, and the two fixture universes never meet or get
compared to `contract/openapi.yaml`. *Bug type:* contract drift — a field renamed in the
spec lands in neither fixture set, so 760 tests stay green while the device 500s.

**(c) Tests asserting on a mock rather than the app.** Rare and mostly justified.
`test/dev/*` (44 cases) assert on the mock by design. The genuine instance is F-8-04:
`AuthRepository` is only ever a `Mock`, so the suite asserts the *stub's* fork behaviour,
never the parser's. `RecordingScreenProtection` (`quiz_harness.dart:36`) is the *good*
version of this — a seam that exists precisely so the assertion is possible, with
`PluginScreenProtection` (`screen_protection.dart:27`) honestly acknowledged as untestable.

**(d) What the goldens pin, and cannot see.** They pin: the nav-bar notch path, the centre
tab's fill inversion, five non-square tab glyphs, the level-card progress fill, the language
pill's border presence/absence by canvas, the bell ring with no unread dot, the track card's
gradient border and radius. They **cannot** see: anything in Arabic (F-8-05); anything at a
non-default `textScaler` (0 references to text scaling anywhere in the repo); anything at a
different device width (each golden hardcodes one `setSurfaceSize`); anything animating
(all captured post-`pumpAndSettle`); the real avatar (`CachedNetworkImage` deliberately
falls back to its placeholder, `golden_harness.dart:38`). *Bug type:* an Arabic string that
overflows its chip, or a 200%-scale label that clips the nav bar.

**(e) Real-device-only surfaces.** `flutter_secure_storage` — `secure_storage_test.dart`
mocks `FlutterSecureStorage` entirely (line 6), so Keychain/EncryptedSharedPreferences
policy, and the `device_id` surviving reinstall, are unverified. `connectivity_plus` —
F-8-03. `screen_protector` — `PluginScreenProtection` never invoked; on iOS it is
explicitly *not* a hard block (`screen_protection.dart:31`) and nothing tests app-background
behaviour. `shared_preferences` — `preferencesStoreProvider` defaults to `null` in tests
(`core_providers.dart:27`), so the persist path runs in exactly 3 cases. Fonts — loaded
from `FontManifest.json` in goldens only. Keyboard — 0 tests resize the viewport for an
open keyboard, and `settings_harness.dart` sets an 800×1600 surface specifically to avoid
scrolling, which means the real 600pt-viewport overflow risk on Settings is untested.

---

## Missing edge cases in the highest-risk areas

| Scenario | Status | Where it should live |
|---|---|---|
| Concurrent 401s → one refresh | ✅ **covered** | `auth_interceptor_test.dart:163` |
| Refresh fails offline → no logout | ✅ covered | `auth_interceptor_test.dart:203` |
| Already-retried 401 → no second refresh | ✅ covered | `auth_interceptor_test.dart:186` |
| **Logout mid-request** | ❌ **absent** | a request in flight when `forceLogout` fires: does the response still write to a disposed notifier? |
| **OTP resend / expiry / rate-limit** | ❌ absent | F-8-02 |
| **Registration abandoned midway and resumed** | ◐ partial | expiry is tested (`registration_controller_test.dart:141`, `school_detail_screen_test.dart:349`), but **app-kill-and-relaunch is not** — the draft is in-memory only, so relaunch loses it and lands on `/` via the guard. Never asserted. |
| **Quiz answered after the session expires** | ◐ partial | `quiz_already_finished` is tested only against the *mock* (`mock_backend_quiz_test.dart:203`); the **bloc's** handling of it mid-session is not in `quiz_bloc_test.dart` |
| **Connectivity flapping mid-request** | ❌ absent | F-8-03 |
| **Arabic / RTL** | ◐ 43 / 760 cases (5.7%) | genuinely good where it exists (`school_detail_screen_test.dart:380-415` asserts real Arabic reference names and localized errors) — but **0 goldens**, and `onboarding_screen_test.dart:243` is the only full locale×theme matrix in the repo |
| **Dark theme** | ◐ 24 cases, 6 assert a dark value | F-8-05 |
| **Text scaling** | ❌ absolute zero | 0 `textScaler` references in `lib/` *or* `test/` |

---

## The integration-test gap — the minimum viable set

Zero `integration_test/`. The mission brief warns against adding automation blindly, and it
is right: an integration test costs a device/emulator, has no CI to run it, and duplicates
what the router-driven widget tests already do well. **Three flows, not fifteen.** Each is
chosen because its breakage is catastrophic *and* a widget test structurally cannot cover
it — every one of them crosses a real platform channel.

**IT-1 — Cold start with a persisted session and persisted preferences.**
*Drives:* kill the app, relaunch, `bootstrap()` → real `PreferencesStore.load()` →
`SecureStorage.readAccessToken()` from the real Keychain/EncryptedSharedPreferences →
`authRedirect` → `/home`.
*Asserts:* the first painted frame is already the student's saved canvas and locale (no
flash — this is the exact property `bootstrap.dart:16-22` was written to guarantee and
nothing verifies), and Home renders without passing through `/login`.
*Why not a widget test:* `preferencesStoreProvider` defaults to `null` under test
(`core_providers.dart:27`) and `SecureStorage` is always a mock. The persistence layer is
mocked out of existence in every one of the 760 cases.

**IT-2 — Sign-up end to end on one track, into the signed-in shell.**
*Drives:* onboarding → login → real OTP entry → `registrationRequired` → identity → track →
school detail → `POST /auth/register` → tokens written to real secure storage →
`markAuthenticated()` → `/home` → tab-switch to Learn.
*Asserts:* no `ErrorWidget`; tokens are readable from real storage after the transition;
the nav shell renders; Back from `/home` does not re-enter the wizard.
*Why not a widget test:* F-8-01 covers the *routing* half in-process, but the token write
crosses the secure-storage channel and the whole chain is the app's single most valuable
path. This is BUG-001's flow, one screen further on.

**IT-3 — Take a quiz to completion with screenshot protection on a real device.**
*Drives:* Learn → subject → lesson → quiz setup → answer → confirm → finish → result → back.
*Asserts:* `FLAG_SECURE` is actually set while `QuizScreen` is mounted and actually cleared
after (platform-side check, not the `RecordingScreenProtection` counter), and that
backgrounding the app mid-quiz and returning does not lose the session.
*Why not a widget test:* `PluginScreenProtection` (`screen_protection.dart:27`) is the one
class the seam explicitly cannot test, and NON-NEGOTIABLE 9 says this must be *verified*.
App-lifecycle transitions likewise have no in-process equivalent.

Deliberately **not** proposed: an offline/airplane-mode flow (F-8-03's fake-`Connectivity`
test is cheaper and catches more), a settings/theme flow (`settings_harness` already boots
the real `LevelUpApp`), and anything touching subscription or track (no code exists).

---

## `TESTING.md` — lift-ready section

> ## What we test, and where
>
> **Models.** Every model with a hand-written `fromJson`, an enum discriminator, or a
> derived getter gets a test that feeds it the *contract's* shape — not a shape invented to
> match the parser. Fixtures live in `test/features/<feature>/<feature>_fixtures.dart` and
> are **functions returning fresh maps**, never top-level constants, so no test can mutate
> another's input.
>
> **Repositories.** Each repository is tested against a `_MockDio` with fixture JSON: the
> happy parse, the empty case, and at least one typed failure asserting that
> `DioException.error` unwraps to the right `AppException` subtype with the right contract
> `code`. A repository with no test of its own is a repository that could be deleted and
> replaced with `throw UnimplementedError()` without turning the suite red.
>
> **Notifiers and blocs.** Tested through a `ProviderContainer` / `blocTest`, asserting the
> *state transition*, not the call. Prefer `isA<T>().having((s) => s.field, 'field', value)`
> over reconstructing whole instances — it names the field that matters instead of hiding it
> in a five-field equality. Guard clauses (double-submit, already-graded, not-yet-selected)
> get their own cases; they are the logic most likely to be refactored away.
>
> **Screens.** Two pumps, and pick deliberately.
> *Direct pump* (`MaterialApp(home: X)`) is right for rendering, state matrices,
> locale/theme, dialogs and validation copy. *Router pump*
> (`MaterialApp.router(routerConfig: container.read(routerProvider))`) is **mandatory** for
> anything that navigates, anything that mutates a provider in a lifecycle method, and
> anything that crosses the auth guard. See `test/features/profile/profile_harness.dart` for
> the canonical two-pump harness and `test/features/catalog/catalog_harness.dart` for the
> router-only one.
>
> **Navigation.** Reached the way a student reaches it — tap the nav label, tap the row,
> tap Continue. Assert on the router's own location (`locationOf(container)`), not on the
> presence of a widget, when the claim is "this leads there".
>
> ## What counts as a meaningful test here
>
> A test is meaningful if it **can fail for a reason you care about**. Specifically:
>
> - `expect(find.byType(X), findsOneWidget)` immediately after pumping `X` proves that
>   `pumpWidget` works. It is not a test. The same line *after a tap* is a navigation
>   assertion and is fine.
> - A test that would still pass if the real implementation were replaced by
>   `throw UnimplementedError()` is testing a mock. If every reference to a class in
>   `test/` is `extends Mock implements <That Class>`, that class has no test.
> - A "dark theme" test that asserts English copy is a smoke test. Either assert an
>   `AppColors.dark` token (see `test/features/settings/shell_screens_test.dart:194`) or
>   rename it to say it checks for crashes.
> - An Arabic test that asserts English strings proves nothing about Arabic. Arabic tests
>   assert Arabic copy **and** `Directionality.of(...) == TextDirection.rtl`.
> - Prefer `find.byKey` over `find.byType(TextField).at(2)`. An index finder passes after
>   the fields are reordered, which is the one refactor it existed to catch.
>
> ## The rule against weakening tests
>
> **A failing test is a finding until proven otherwise.** When a test goes red:
>
> 1. Establish whether the *behaviour* changed or the *expectation* was wrong. Write the
>    answer in the commit message.
> 2. If the behaviour changed on purpose, update the assertion **and** the comment that
>    explains what defect it prevents. An assertion with no reason attached is the next
>    thing somebody deletes.
> 3. If the behaviour changed by accident, fix the code.
>
> Never: loosen `findsOneWidget` to `findsWidgets`, swap an exact string for
> `textContaining`, add `skip: true`, widen a `closeTo` tolerance, or replace a router pump
> with a direct pump — that last one is how BUG-001 would have escaped a second time
> (`test/features/registration/registration_router_flow_test.dart:31`: *"Keep this test
> router-driven. If it is ever 'simplified' into a direct pump, it stops testing anything."*).
> Deleting a test is a decision that goes in `docs/DECISIONS.md`, not in a diff.
>
> ## Guard tests this project owns
>
> A guard test scans source or configuration for a banned pattern and fails with
> `path:line`. It costs almost nothing, runs in the normal suite, and is the only
> enforcement this project has in the absence of CI and git hooks. The model is
> `test/core/theme/palette_discipline_test.dart` — read it before writing another one, and
> copy its idiom exactly: a `hits(RegExp)` helper, `path:line — text` failure output, and a
> doc comment naming the defect that made the rule necessary.
>
> We own, or should own:
>
> | Guard | Rule enforced |
> |---|---|
> | `palette_discipline_test.dart` ✅ | no hex, no `Colors.black`/`white`, one `SystemUiOverlayStyle`, shadow token differs per canvas and survives `lerp` |
> | **no provider write in `initState`** | the BUG-001 guard: `ref.read(...notifier)` inside an `initState` body is banned outright |
> | **bloc containment** | `package:flutter_bloc` / `package:bloc` imported only under `lib/features/quiz/` |
> | **RTL discipline** | no `EdgeInsets.only(left:/right:)`, no `EdgeInsets.fromLTRB`, no `Alignment.centerLeft/Right` outside an allowlist |
> | **l10n leaks** | no raw string literal inside `Text(` outside a documented allowlist (the flag glyph, punctuation joiners) |
> | **ARB parity** | `app_en.arb` and `app_ar.arb` have identical key sets; no empty values; no identical values outside an allowlist |
> | **route reachability** | every `GoRoute` path in `app_router.dart` is navigated to by at least one test |
>
> Each of these is currently **true and unenforced**. Writing them locks the invariant in
> at the moment it holds, which is the cheapest moment there will ever be.

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

## Remaining Risks

- **F-8-03 item 1 cannot be settled without a device.** Whether `connectivity_plus` seeds
  an initial value on subscribe is platform- and version-dependent. If it does not, the app
  ships an offline state that never engages on a cold airplane-mode start, and nothing in
  the suite can see it.
- **Goldens have no canonical renderer.** Adding Arabic goldens without CI risks a suite
  that is red on one developer's machine and green on another's. Sequence F-8-05 after CI.
- **No test measures a pixel in Arabic, at any text scale, at any width but one.** The
  responsive weakness the orchestrator already recorded (0 `LayoutBuilder`, 0 `textScaler`)
  has a matching testing weakness, and the two compound.
- Test-file mtimes cluster around Aug 4–7 2026 while `lib/` extends to Aug 7 — no evidence
  of test rot, but with no CI nothing proves the suite is green at `e3651e6`.

## Deferred Improvements

- Extract the four near-identical `MaterialApp.router` bootstraps
  (`catalog_harness.dart:71`, `quiz_harness.dart:98`, `profile_harness.dart`,
  `registration_router_flow_test.dart:99`) into one `test/support/app_harness.dart`. Real
  duplication, but the harnesses are each well-documented and diverge meaningfully; low value.
- Isolation tests for the four untested `lib/core/widgets/` files. They are covered
  incidentally by every screen that uses them; a dedicated test would mostly restate that.
- A `contract/openapi.yaml` ↔ fixture conformance check. High value, but it is a tooling
  project (schema validation in Dart), not a test.

## Recommendations (ranked)

1. **F-8-01** — extend `registration_router_flow_test.dart` through both track-detail
   screens to `/home` via the real router. Highest value per line in this report: it closes
   the last stretch of the exact path BUG-001 lived on.
2. **F-8-10** — write `test/core/discipline_test.dart` with the five guards. One file,
   ~120 lines, locks in five invariants that are true today and enforced by nothing.
3. **F-8-02** — three tests for the OTP countdown / resend / rate-limit. The front door has
   an untested lock.
4. **F-8-04** — `auth_repository_test.dart`, in the shape of its five peers.
5. **F-8-03** — replace one `isOnlineProvider` override with a `connectivityProvider` fake
   driving a real `StreamController`; assert cold-start and flapping.
6. **F-8-07** — four router tests for the `state.extra!` routes.
7. **F-8-08** — `Key`s on the three identity fields; narrow the
   `palette_discipline_test.dart:100` `Container` finder.
8. **F-8-05** — add `ar` to the golden loops. **After** CI exists, not before.
9. **IT-1 / IT-2 / IT-3** — the three integration tests, in that order, once there is a
   place to run them.
