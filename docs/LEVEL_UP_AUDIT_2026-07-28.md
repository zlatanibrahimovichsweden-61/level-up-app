# Level Up — Independent Audit Report

_Audited 2026-07-28. Method: the 2026-07-28 status report was treated as a hypothesis, not a
source — every claim in it was re-checked directly against the Figma file (`P6044i0giD9TmdQ7C2AmLq`,
node-by-node via the Figma MCP), the `level-up-app` working tree (`git log`, `git status`, direct file
reads of `lib/`, `test/`, `docs/`), and the vendored contract (`contract/openapi.yaml`,
`error-codes.md`, `contract-changelog.md`, `realtime.md`, `SOURCE.md` — pinned commit `23f0535`).
Where the status report and the artifacts agreed, that is noted briefly. Where they diverged, or
where the status report couldn't verify something it should have, that is flagged explicitly.
No claim below is asserted without a file path, node id, or line citation._

**Headline finding on the prior report's reliability:** every specific Figma node id and file
citation in its Implementation Map that was spot-checked here (`82:819`, `82:1171`, `337:15875`,
`337:5269`, `337:10373`, `337:5303`, `337:5702`) resolved to exactly the screen it claimed, with
matching content (e.g. `82:1171` really does say "Enter the 4-digit verification code," confirming
the OTP-length deviation). The prior report's Figma-access tooling has a real limitation — the
Figma MCP's top-level page listing returns only one page ("Assets / component") for this file, even
though individual node ids from three different screens resolve fine — so a full ~90-frame
enumeration was not possible here either. That caveat is inherited, not invented; on the sampled
node ids, the prior report's citations are accurate and can be trusted as ground truth for the
Implementation Map. The rest of this audit adds new findings the prior report either didn't reach
(a critical Android networking defect, the university-track dead end, unused security dependencies)
or under-stated (build-order, dependency risk).

---

## 1. Design vs. Implementation Gap Analysis

### 1.1 Figma screens with no corresponding implementation

Confirmed against the router (`lib/core/router/app_router.dart`) and the file tree — every one of
these resolves to either a bare `_Placeholder`/`TabPlaceholder` widget or no route at all:

- **Leaderboard** (both `system/governorate/cohort/global` scopes) — `GET /leaderboard`,
  `/leaderboard/me` are `x-stability: draft`. Route `/leaderboard` → `LeaderboardPlaceholderScreen`
  (`tab_placeholder.dart`). Correctly deferred (draft endpoint), but zero screen exists.
- **Message tab** — route `/message` → `MessagePlaceholderScreen`. Worse than "not built yet": there
  is **no REST endpoint for it anywhere in `openapi.yaml`**, and `realtime.md` lists the `chat` hub
  as "not drafted." This tab has no contract surface at all, draft or stable — a product-definition
  gap, not just a build gap.
- **Account / Profile edit** — `/account` and `/profile` are both bare placeholders, despite `GET
  /me` + `PATCH /me` being `x-stability: stable` since the M1 drop (2026-07-19). This is the most
  consequential missing screen: the only stable, already-partially-consumed (`GET /me` powers Home)
  profile-edit surface in the whole contract has no UI at all.
- **Settings** — `/settings` → `_Placeholder('Settings')`. No corresponding endpoint exists in the
  contract for settings as such (it would consume `PATCH /me`'s privacy toggles); not built.
- **Subscription / Paymob checkout + return** — `/subscription`, `/subscription/return` are
  placeholders. `POST /checkout/sessions` and `/subscription-codes/redemptions` are both `draft`.
  Correctly deferred.
- **Quiz build/take/review** — Setup (`/quiz/setup`) has a placeholder screen wired to real args;
  `/quiz/:quizId` is a bare `_Placeholder`. `POST /quizzes`, `/quizzes/{id}/answers`,
  `/quizzes/{id}/finish`, `GET /questions/{id}/explanation` are ALL `stable` and **none are
  consumed** — this is the single largest block of unbuilt stable surface in the contract.
- **"My Fault" / Mistakes** (Figma: 4 frames referenced in the prior report, not independently
  re-verified here) — `lib/features/catalog/screens/subjects_screen.dart`'s companion header
  (`404:7413`, confirmed live in Figma) draws a "Mistakes" tab; in code this is wired to a
  "Coming soon" snackbar, not a screen.
- **Account recovery** (4 steps: start → verify-parent → new-phone → confirm) — all four endpoints
  are `draft`; no screen, no route. Correctly deferred, though note (§3) this leaves phone-loss
  account recovery with literally zero client-side path today.
- **Custom avatar upload, FCM token registration, favorites, quiz history/review** — all backed by
  `draft` endpoints; none built. Correctly deferred.
- **University Home / Learn / Quiz** — confirmed via `catalog_repository.dart:53` (`if
  (json['track'] != 'school') throw UnknownException(...)`) and `subject_tree.dart:15`
  (`TODO(university): model UniversitySubjectTree...`) that **no University-track screen exists past
  registration** — see §1.3, this is the most serious build-order finding in the audit.

### 1.2 Implemented screens that deviate from the Figma design

All of the following were cross-checked against the live Figma nodes (not just `docs/DESIGN_ISSUES.md`,
though that document — 33 entries, code-marker-linked — independently corroborates every one of them):

| Screen | Deviation | Verified |
|---|---|---|
| OTP (`82:1171`) | Design literally reads "Enter the 4-digit verification code" (confirmed in raw Figma text node `82:1137`); contract requires exactly 6 (`otp/verify.code`, `minLength: 6, maxLength: 6`). Built as 6. | Figma text + `openapi.yaml:135` |
| Login (`82:819`) | Design shows phone prefix `+02`; Egypt's real code is `+20` (confirmed in Figma text node `82:899`). Built as `+20`. | Figma text |
| Sign Up_1 (`337:15875`) | "Referral Code (Optional)" field (Figma node `337:15935`) is drawn and collected but has no field in either `SchoolRegistration` or `UniversityRegistration` schema — never submitted. | Figma + `openapi.yaml` schemas |
| School detail (`337:5269`, labeled "Sign Up_2" in Figma — see note below) | `dateOfBirth` added client-side; contract requires it (`required: [... dateOfBirth ...]`) and it is absent from the design frame. | `registration_controller.dart:60-63`, `openapi.yaml:1239,1250` |
| University detail (`337:10373`) | `governorateId` added client-side (contract-required, `openapi.yaml:1262,1267`, absent from the frame's City-only field); field order changed from the drawn Faculty→Year→City→University to University→Faculty→Year→Governorate→City to respect the data cascade (faculties belong to a university; the drawn order would show two disabled fields before the one that unlocks them). | Figma metadata (fields present: Faculty, Academic Year, City, University name only — no Governorate) |
| Home (`337:5303`) | Daily Tasks / Continue Learning / Top Student sections are fully populated with sample data in Figma (verified: "Complete 2 Quizzes," "Physics — motion in one Dimension," "Sara Mohamed 18,200" etc. all present as real text nodes) but render as inert `ComingSoonSection` placeholders in code — no endpoint exists for any of the three. | Figma text nodes `337:5366`, `337:5435-36`, `337:5466` |
| Home level card | Design caption reads "2,450 / 5,000"; this is internally inconsistent with the contract's own prose ("thresholds every 500 points" would make 2,450 mid-level-5, not level 8 as the same frame states) and 5,000 is actually the badge cadence, not a level threshold. Code renders `level`/`points` verbatim from the server and derives only the bar's fill from a client constant `kPointsPerLevel = 500` (`level_card.dart:20`) — a documented workaround, not a real fix, because `GET /me` supplies no next-level threshold at all. | Figma text `337:5348` vs `openapi.yaml` prose (line 1324) |
| Learn — Units/Chapters (`337:5894`, `337:6047`) | Design draws a progress bar + "80%" on every row; `SchoolSubjectTree` only carries `questionCounter` on **lessons**, not units/chapters (`openapi.yaml:1370-1387`). Code renders name+chevron only at those two levels — correctly refuses to fabricate a rolled-up percentage. | `tree_list_row.dart`, schema |
| Learn — Lessons (`337:6143`) | Design shows a rounded "80%"; code shows the server's own "{answered} / {total} questions" instead — more information, but a visible copy deviation from the frame. | `docs/DESIGN_ISSUES.md#16` |
| Learn — Units/Chapters/Lessons search field | All three drill-down frames carry a copy-pasted "Search Subjects" placeholder (confirmed odd — wrong copy at every level below Subjects); code omits search entirely below Subjects. | Figma + `docs/DESIGN_ISSUES.md#17` |
| Subject card caption (`337:5748`) | Design text node is literally 8.558px on a 402dp frame (i.e., true 8.56dp, not a scaling artifact) — below any readable minimum. Built at 10dp. | `docs/DESIGN_ISSUES.md#15` |
| Login "Create New Account" | Design implies a direct-registration entry point; the contract is phone-verify-first (no registration without an OTP), so the button was rewired to funnel into the same `requestOtp`→`/otp` flow as "Send OTP." | `docs/DESIGN_ISSUES.md#8`, `login_screen.dart` |
| Bird logo, OTP success badge, notification bell, back-glyph, level medallion, banner art, footer nav glyphs | All substituted with Material icon placeholders (`Icons.flutter_dash`, `Icons.check_circle`, etc.) because the Figma file has export disabled and the connected seat is View-only — `download_assets` cannot pull brand art. This is a currently-live blocker, independently confirmed: the file's only page-level asset library (`0:1 "Assets / component"`) contains generic avatar/icon symbols, not the specific brand marks referenced (bird logo, success badge). | `docs/DESIGN_ISSUES.md#1`, 7 `TODO(design-asset)` sites in code |
| Dark theme | Fully implemented and wired (color tokens exist for both), but no screen has a toggle to switch to it — app defaults to light and stays there. | `docs/DESIGN_ISSUES.md#10` |

**Figma file-hygiene note (new finding, not in the prior report):** the frame name "Sign Up_2" is
reused for at least **three different screens** in the file — the track-selection screen
(`337:15947`, per the prior report), the School detail screen (`337:5269`), and the University
detail screen (`337:10373`, whose own child frame is also internally named "Sign Up_2" at
`349:16790`+). This is a source-file hygiene problem on the design side: anyone navigating the Figma
outline by name alone cannot distinguish these three screens, which likely contributed to the
node-id-only cross-referencing style adopted in `docs/DESIGN_ISSUES.md`.

### 1.3 Build-order issues

- **University track: registration works, everything downstream doesn't (critical).** `POST
  /auth/register` with `track: university` is fully implemented and issues real tokens
  (`university_detail_screen.dart`, `registration_repository.dart`). But `CatalogRepository
  .getSubjectTree` explicitly throws `UnknownException` for any non-`school` track
  (`catalog_repository.dart:53`), and `SubjectTree` has no `UniversitySubjectTree` model at all yet
  (`TODO(university)` in `subject_tree.dart:15`). A university student can therefore complete
  registration, land in a School-shaped Home screen, and get an unhandled-looking generic error the
  first time they open any subject in Learn. There is no university-specific "coming soon" messaging
  — the failure surfaces through the same generic error state as a real backend fault, which is
  actively misleading (a retry button implies retrying will help; it won't). This is a downstream
  flow (catalog/quiz) being consumed by a track whose entry screen (university registration) shipped
  without its dependency being ready — the clearest violation of "don't ship the entry point ahead of
  what it leads to" in the whole codebase.
- **A fully-built, heavily-tested 4-level navigation tree terminates at a 0%-built feature.**
  Subjects → Units → Chapters → Lessons (30 files, dedicated `catalog_navigation_test.dart` asserting
  fetch-once semantics) all exist solely to end at "Start learning" → `/quiz/setup`, and Day 6 (the
  quiz engine itself) has not started at all — `quiz_setup_placeholder.dart` is 46 lines, and none of
  the 4 stable quiz endpoints are consumed anywhere. This ordering is defensible (you must be able to
  browse to a lesson before you can quiz on it) but represents a large amount of finished, tested
  engineering effort whose entire payoff is gated on a feature that doesn't exist yet — a
  concentration-of-risk observation worth flagging for planning, not a defect.
- **A simpler, stable, dependency-free endpoint (`PATCH /me` / Account) sits completely unbuilt while
  a deeper, harder feature (4-level catalog drill-down) shipped first.** Both are `stable`; Account
  has no cascading dependencies (it is a single profile form), while Learn required building an
  entire tree-caching model. Building the harder, deeper feature ahead of the simpler stable one is
  an inversion of complexity-vs-payoff prioritization, not a hard dependency violation, but worth
  flagging since Account/Settings are the only screens standing between "signed in" and "usable app"
  for privacy-toggle and profile-editing needs the contract already supports today.
- **Router carries a dead route.** `/` → `_Placeholder('Onboarding')` is defined in
  `app_router.dart:71` but `initialLocation` is hardcoded to `/login` (`app_router.dart:66`), so `/`
  is unreachable by any normal navigation. No onboarding flow has been scheduled into any Day-brief.
  This isn't harmful, but it's dead code that should either be wired in or removed rather than left
  as a permanent stub.

### 1.4 Implemented screens with no corresponding Figma frame (ad-hoc additions)

- **`RegistrationExpiredView`** (`lib/features/registration/screens/registration_expired_view.dart`)
  — a screen shown when the registration token (10-minute TTL per the contract) expires mid-wizard.
  No node id for this state is cited anywhere in `docs/DESIGN_ISSUES.md` or the prior report, and
  none was found in the Figma nodes sampled here. This looks like a necessary, reasonable, purely
  defensive addition (the contract mandates the token can expire; some UI has to handle it) rather
  than scope creep — flagged for completeness, not as a criticism.
- No other undocumented screens were found; every other screen in the file tree traces to a cited
  Figma node in either the prior report or `DESIGN_ISSUES.md`.

---

## 2. Code Analysis & Rating

Ratings are 1 (not usable) – 5 (production-ready), scored on what exists, not on completeness of
scope (an unbuilt module is rated on the quality of its stub, separately from the completeness gap
already covered in §1).

**Core network/storage/router infrastructure — 5/5.** `AuthInterceptor`
(`lib/core/network/interceptors/auth_interceptor.dart`) implements single-flight refresh
correctly (`_refreshing ??= ...` assigns synchronously before any `await`, so a burst of concurrent
401s shares exactly one refresh call), retries the original request exactly once via a `__retried`
flag, and uses a *separate bare Dio* (`DioClient.createBare`) for the refresh call itself so refresh
can never re-enter its own retry path — a real and easy-to-get-wrong correctness property, done
right. `SecureStorage.clearTokens()` vs `.clear()` is a deliberate, well-commented distinction
(logout preserves `device_id`; only true resets wipe it) that directly protects against a real
device-eviction bug class. `authRedirect()` in `app_router.dart` is a pure function, unit-tested in
isolation (`test/core/router/app_router_test.dart`). This is the strongest part of the codebase.

**Auth (login/OTP/session) — 5/5.** Matches the contract's documented state machine exactly:
`authenticated` vs `registrationRequired` discriminated union consumed correctly
(`auth_result.dart`), `session_superseded` and `authentication_required` handled per the contract's
"Global auth behavior" prose (`openapi.yaml` lines 26-33) verbatim in `AuthInterceptor.onError`.
BUG-001 (a real crash — illegal Riverpod state mutation inside `initState` during a router-driven
rebuild) was caught, root-caused precisely, fixed, and given a regression test that was verified to
actually fail on the un-fixed code (`docs/KNOWN_BUGS.md` — this is unusually rigorous bug
documentation; most teams don't verify their regression test actually reproduces the bug before the
fix).

**Registration — 4.5/5.** The geography cascade (`RegistrationController`, lines 65-127) correctly
clears every downstream field when an upstream one changes (country → governorate/city/school;
university → faculty/year), which is exactly what prevents the contract's "forbidden field" 400s.
`RegistrationRepository.register()` refuses to silently coerce a `RegistrationRequiredResult` if the
server ever (incorrectly) returns one from `/auth/register` — it throws instead of guessing
(`registration_repository.dart:44-51`), which is the correct posture for "the contract documents 201
as X only." Minus 0.5 for the referral-code dead field (§1.2) sitting in the UI collecting input that
is silently discarded — this should either be removed from the UI or surfaced to the user as
"not yet supported," since right now a student who fills it in gets no feedback that it did nothing.

**Home/Profile — 3/5.** `HomeScreen` (`home_screen.dart`) has genuinely good state modeling — a
shaped skeleton loader (not a bare spinner), a distinct offline state, a retry-capable error state
that discriminates offline-vs-generic by exception type. But three of the screen's four content
sections are permanently inert (§1.2), the level-progress bar is built on an admittedly-provisional
client constant with no server confirmation (`level_card.dart:8-20`), and the entire Account/Profile
edit surface — the only stable, no-dependency endpoint left unbuilt — doesn't exist (§1.3). The
quality of what's built is high; the module is materially incomplete relative to what the contract
already supports.

**Shell/Navigation — 4/5.** Clean `StatefulShellRoute.indexedStack` usage; the nested
`subject/:subjectId/unit/:unitId/chapter/:chapterId` routes correctly preserve one Navigator per tab
branch (verified in `app_router.dart:130-164`), so switching tabs mid-drill-down doesn't lose place.
Minus 1 for three of five tabs being dead placeholders, one of which (Message) has no corresponding
endpoint anywhere in the contract, draft or stable — meaning a fifth of the primary navigation
surface currently points at a feature that isn't even scoped yet, not just unbuilt.

**Catalog (Learn) — 4/5 for what's built, but see §1.3 for the university gap.** The
fetch-once-per-subject-tree guarantee is explicitly tested (`catalog_navigation_test.dart`), and the
decision to refuse a university payload with a typed exception rather than let a generated
`fromJson` throw a raw `TypeError` (`catalog_repository.dart:50-57`) is the right defensive instinct
— but that same refusal is what turns into an unhandled-for-users dead end for university accounts,
since no screen catches `UnknownException` and shows "university Learn isn't ready yet" instead of a
generic retry-styled error.

**Quiz — 1/5 (by completeness; the little that exists is fine).** `quiz_setup_placeholder.dart`
(46 lines) and `quiz_setup_args.dart` are trivial and correct for what they do. Zero of the five
`stable` quiz operations (`createQuiz`, `submitAnswer`, `finishQuiz`, `getExplanation`, plus
`GET /catalog/subjects/{id}/tree`'s consumer) are implemented. This is explicitly "Day 6, not
started" and is rated on completeness, not on any defect in the placeholder itself.

**Subscription / Track / Leaderboard — N/A (empty scaffolds, correctly deferred; Track folder is
fully empty — only `.gitkeep` files — and has no corresponding Figma-cited screen at all in either
report, meaning its purpose is presently undocumented).**

### Architecture consistency vs. the prior report's §2 claims

All independently re-verified and confirmed accurate:

- **Riverpod-only, no real Bloc usage** — confirmed by direct grep for `extends Bloc|extends
  Cubit|BlocProvider|BlocBuilder` across `lib/`: zero matches. `flutter_bloc` and `bloc_test` are
  declared dependencies with **no consuming code** — dead weight, reserved for the unbuilt quiz
  engine.
- **`hive_ce`/`hive_ce_flutter`/`hive_ce_generator` unused** — confirmed by grep for `Hive` /
  `hive_ce` in `lib/`: zero matches outside `pubspec.yaml`/`pubspec.lock`.
- **No CI** — confirmed: no `.github/workflows/` directory and no other CI config anywhere in the
  repo.
- **325 `test()`/`testWidgets()` calls** — recounted independently via grep: **325**, exact match.
- **Feature-first structure, consistent `{models,repository,notifier,screens,widgets}` layout** —
  confirmed across `auth`, `registration`, `home`, `profile`, `catalog`, and the empty `quiz`/
  `subscription`/`track` scaffolds.

### Adherence to the API contract (ADR-026 conventions)

Strong, with two caveats:

- **camelCase, UUIDv7-opaque ids, cursor pagination** — all correctly followed.
  `ReferenceRepository.searchSchools()` is the one genuinely cursor-paginated stable endpoint the
  app consumes, and it's implemented correctly (`cursor`/`limit` passed through, `CursorPage<T>`
  generic wrapper parses `items`/`nextCursor`/`hasMore` per the schema) — `reference_repository.dart:73-98`.
- **`oneOf` discriminators handled correctly, not coerced** — both `AuthResult` (authenticated vs.
  registrationRequired) and the school/university registration bodies are modeled as real Dart sealed
  unions (freezed), and `RegistrationRepository.register()` explicitly refuses to silently accept an
  unexpected shape (§2 above) — this is better contract discipline than most client codebases show.
- **Gap: `ErrorInterceptor` doesn't yet map most of the 19 codes in `error-codes.md` into distinct
  types** — it has an explicit `TODO(contract): full mapping ... lands per-feature`
  (`error_interceptor.dart:9`) and currently only special-cases `401` and `400 validation_failed`
  generically; everything else (`otp_throttled`, `weekly_question_limit_reached`,
  `insufficient_scope`, `code_already_redeemed`, etc.) falls through to a generic `ApiException(status,
  code)` that callers must switch on themselves. This is workable (the `code` string is preserved) but
  means error-copy mapping is duplicated per-feature (`auth_error_copy.dart`,
  `registration_error_copy.dart` exist; no equivalent exists yet for catalog/quiz, which will need one
  the moment Day 6 starts, since `weekly_question_limit_reached` and `not_enough_questions` are
  quiz-specific and currently unhandled anywhere).
- **Base URL is a placeholder that cannot resolve** — `app_config.dart:41-43` hardcodes
  `https://staging.TBD.example/api/v1` for **all three flavors**, explicitly marked "Do NOT ship."
  This isn't a contract-adherence defect (the contract's own `servers:` block is equally a
  placeholder — `openapi.yaml:57`), but it means the app has never actually been run against a real
  network — only against `lib/dev/mock_backend.dart` (641 lines). No amount of code quality
  substitutes for the total absence of an integration test against a real or even a full-fidelity
  mocked HTTP server.

### Consolidated gap list (code-level)

- **Dead code / unused dependencies:** `flutter_bloc`, `bloc_test`, `hive_ce`, `hive_ce_flutter`,
  `hive_ce_generator` — all declared, none referenced (5 dependencies of dead weight in
  `pubspec.yaml`).
- **`screen_protector` declared but never wired up (new finding).** This dependency
  (`pubspec.yaml`) exists specifically to block screenshots/screen recording — directly relevant
  given the contract's own framing that "the bank is the product" (quiz content is the commercial
  asset, `openapi.yaml:756`). A grep for `screen_protector`/`ScreenProtector` across `lib/` returns
  zero matches. Once the quiz screens exist, shipping without this wired up leaves the entire
  question bank trivially screenshottable/recordable — worth flagging now, before Day 6, since it's
  cheaper to build in from the start than retrofit.
- **Missing per-code error mapping** for 15+ of the 19 registered error codes (above).
- **TODO/FIXME markers** — 19 non-generated occurrences (`grep -rn "TODO\|FIXME" lib/`, excluding
  `.freezed.dart`/`.g.dart`), all legitimately tracked against `DESIGN_ISSUES.md`/contract gaps
  rather than abandoned work — better hygiene than typical, but still 19 open items worth a burn-down
  pass before Day 6.
- **Level-threshold logic is a guess, not a fact** (`kPointsPerLevel = 500`,
  `level_card.dart:8-20`) — explicitly self-documented as provisional; a real risk if the server's
  actual thresholds differ, since the bar (not the level/points numbers themselves) would silently
  misrepresent progress to students.
- **No coverage measurement is committed** — 325 tests exist and are substantial, but there is no
  `coverage/` artifact or CI to produce one, so "well tested" is a qualitative impression, not a
  measured percentage.
- **Untested critical path: university track end-to-end.** There is no test anywhere in `test/`
  that drives a university registration through to a Learn/catalog screen (because that screen
  doesn't exist) — meaning the crash-shaped dead end in §1.3 has no regression test guarding
  against it being made worse, and no test currently documents the expected (degraded) behavior
  either.
- **Outdated/pre-release dependencies:** `freezed: ^3.2.6-dev.1` is a dev-channel prerelease pinned
  in a project with zero CI — any transitive resolution drift on `flutter pub get` is not caught
  until someone runs it locally in a container without a cached lockfile match.

---

## 3. System-Wide Flaws & Vulnerabilities

### Security

- **CRITICAL — Android release builds are almost certainly unable to make any network call at
  all.** `android/app/src/main/AndroidManifest.xml` declares no `<uses-permission
  android:name="android.permission.INTERNET"/>`. The permission is present in
  `android/app/src/debug/AndroidManifest.xml` and `android/app/src/profile/AndroidManifest.xml`
  (both confirmed by direct read) but **not** in `main` (confirmed: `grep -n "permission"` against
  `main/AndroidManifest.xml` returns nothing), and there is no `android/app/src/release/` manifest to
  supply it either. Android's manifest merger only pulls the debug/profile INTERNET grant into
  debug/profile builds; a `flutter build apk --release` (or App Bundle) compiled from this tree today
  would ship without network permission — every Dio call would fail at the OS level before any of the
  (otherwise well-built) interceptor/retry logic ever ran. This is the single most concrete,
  verifiable, ship-blocking defect found in this audit, and it is invisible in `flutter run` (which
  defaults to debug) and in `flutter run --profile`, which is likely why it hasn't been caught yet.
- **HIGH — no screen/recording protection despite content being the commercial asset.**
  `screen_protector` is declared, unused (above). Not exploitable today (no quiz content is served
  yet), but this is the kind of gap that's easy to forget once Day 6 ships under time pressure.
- **MEDIUM — account recovery has zero client-side path.** All four `/auth/recovery/*` endpoints
  are `draft` and unbuilt (correctly deferred per stability rules), but that means a student who
  loses/changes their phone has **no in-app recourse today** — not a code defect, but a real gap in
  what ships if Milestone-1 goes out before recovery is promoted to stable.
- **LOW/informational — token handling itself is sound.** Access/refresh tokens live only in
  `flutter_secure_storage` (Keychain/Keystore-backed), never logged (explicit comment discipline in
  `registration_repository.dart:25-26` and `secure_storage.dart`), and `device_id` generation uses
  `Random.secure()` (cryptographically secure RNG) for a 128-bit id — correct choice.
  `SecureStorage.clearTokens()` vs `.clear()` (above) is a well-reasoned, tested distinction. No
  hardcoded secrets, API keys, or credentials were found anywhere in `lib/` (targeted grep for
  `api[_-]?key|secret|password\s*=|token\s*=\s*['"]` returned only a doc-comment, no live secret).
  iOS `Info.plist` has no `NSAppTransportSecurity` exceptions (i.e., no insecure-cleartext carve-outs)
  — a secure default, left alone rather than weakened.
- **LOW — no validated request against a real or high-fidelity server.** The placeholder base URL
  (§2) means every "it works" claim in this codebase is validated only against the team's own
  641-line mock (`lib/dev/mock_backend.dart`), which necessarily encodes the same assumptions as the
  client it's mocking for. This isn't a vulnerability per se, but it caps confidence in every other
  finding in this report: nothing here has been exercised against adversarial or even just
  differently-buggy server behavior.

### Structural / architectural

- **CRITICAL (functional, not security) — the university track is a dead end past registration**
  (detailed in §1.3/§2). Worth restating here because it's the one finding that will visibly break
  for real users the moment university registration ships to anyone, not just a completeness gap.
- **HIGH — zero CI means every one of this report's "tests pass" / "analyze clean" claims is
  self-reported per-commit, not continuously verified.** As the codebase grows toward 90 screens,
  manual `flutter analyze`/`flutter test` discipline is exactly the kind of process that degrades
  under deadline pressure without an automated gate. This compounds every other finding: BUG-001
  (§2) was caught by a human walking the app on a physical device, not by any automated check — the
  team got lucky that a human tester exists; there is no guarantee the next router-mutation-during-build
  class of bug will be walked before it ships.
- **MEDIUM — doc drift is already happening at Day 5 of what will be a much longer project.**
  `docs/PROGRESS.md` is stale (last updated Day 2, mid-project) and was explicitly excluded from this
  audit's evidence base for that reason — meaning there is already one canonical-looking document in
  the repo that actively misleads about project state. At 90 screens' worth of eventual scope, an
  unmaintained "source of truth" document is a standing trap for the next engineer or session that
  reads it first.
- **MEDIUM — three of five bottom-nav tabs are placeholders, and one of them (Message) has no
  contract surface at all**, meaning the shell's own navigation structure currently advertises a
  destination the backend team hasn't even scoped yet. This isn't a Flutter-side architecture flaw
  (the `TabPlaceholder` pattern is a reasonable stopgap, cleanly swappable per the class doc), but
  it is a scope-coordination gap between the Flutter and API-contract teams worth surfacing to
  product.
- **LOW — feature-first modularity is genuinely good and should scale fine to 90 screens.** The
  repeated `{models,repository,notifier,screens,widgets}` shape per feature, the single
  `dioProvider`/`AuthController` as sources of truth, and the nested-branch router structure are all
  sound choices that don't need to change as more features land — this is a strength, not a flaw, and
  worth stating plainly so it isn't lost among the gaps above.

---

## 4. Recommendations

Ordered by what would hurt most if left unfixed, not by effort.

1. **Fix the Android INTERNET permission today, and add a release-build smoke test to prevent
   recurrence.** Add `<uses-permission android:name="android.permission.INTERNET"/>` to
   `android/app/src/main/AndroidManifest.xml` (not just debug/profile). Then add a minimal CI job
   (even a single GitHub Actions workflow running `flutter build apk --release` and a scripted
   `adb shell am start` + a real HTTP call against a throwaway echo server) so a release-mode
   regression like this is caught by a machine, not by a submission to an app store review team.
   This is the highest-priority item in the whole audit: everything else in this codebase is
   moot if the shipped binary can't reach the network.
2. **Stand up minimal CI now, before the codebase triples in size.** A single GitHub Actions
   workflow running `flutter analyze`, `flutter test --coverage`, and uploading the coverage report
   (e.g. via `codecov` or even just an artifact) converts every "tests pass" claim in every future
   status report from self-reported to machine-verified, and would have caught BUG-001-class issues
   automatically once a router-driven integration test exists (one already does —
   `registration_router_flow_test.dart` — it just isn't run automatically).
3. **Give the university track an explicit "not ready" state instead of letting it throw.** In
   `CatalogRepository.getSubjectTree`, catch the `track != 'school'` case and surface a typed
   `UniversityNotSupportedException` (or similar) that `UnitsScreen`/`SubjectsScreen` render as a
   dedicated "University Learn is coming soon" view — not the generic retry-styled error state. This
   is a small, contained change (one new exception type + one new UI branch) that removes the worst
   user-facing consequence of the build-order gap in §1.3 without waiting for the full
   `UniversitySubjectTree` model to be built. Longer-term, either gate university registration behind
   a feature flag until Learn/Quiz support it, or prioritize the `UniversitySubjectTree` model next.
4. **Wire up `screen_protector` before Day 6, not after.** Add the `FlutterWindowManager`
   `FLAG_SECURE` (Android) / `ScreenProtector` equivalent (iOS) at the quiz screen level as part of
   the Day 6 kickoff, rather than as a retrofit once quiz content already exists in the wild. Given
   the dependency is already declared, this is a same-day integration, not new procurement.
5. **Finish the per-code `ErrorInterceptor` mapping before Day 6.** Extend the `switch (status)` in
   `error_interceptor.dart` (or, better, switch on `code` directly rather than `status`) to produce
   distinct typed exceptions for at least `otp_throttled`, `weekly_question_limit_reached`,
   `not_enough_questions`, `insufficient_scope`, and `quiz_already_finished` — all of which the quiz
   engine will need on day one and none of which currently have a distinguishable type. Doing this
   ahead of Day 6 avoids writing per-feature error copy under time pressure later.
6. **Remove `flutter_bloc`, `bloc_test`, `hive_ce`, `hive_ce_flutter`, `hive_ce_generator` from
   `pubspec.yaml` until there is a concrete, scheduled use.** If the quiz engine genuinely needs Bloc
   (per `docs/PROGRESS.md`'s "Bloc(quiz only)" note), re-add it in the same PR that starts consuming
   it — carrying five unused dependencies for an indeterminate number of Days is unnecessary build-size
   and audit surface for no present benefit. If Riverpod's `AsyncNotifier` can model the quiz state
   machine (it modeled every other async flow in this codebase without issue), consider dropping Bloc
   entirely rather than introducing a second state-management paradigm for one feature.
7. **Replace the referral-code dead field with either a real backend field or an explicit
   "coming soon" affordance.** Right now a student can fill in a referral code that is silently
   discarded — either escalate to Seif for a contract addition (if this is in scope for M1) or grey
   out the field with a tooltip/label indicating it isn't active yet. Silent data loss from a filled
   form field is a trust-eroding UX pattern regardless of how small the feature is.
8. **Delete or regenerate `docs/PROGRESS.md`.** A stale "source of truth" document is worse than no
   document, especially heading into a 90-screen scope where new contributors (human or agent) will
   default to reading whatever looks canonical first. Either wire it to be regenerated from
   `git log` + the Day-briefs on each merge to `main`, or remove it and rely on the Day-brief series
   (which this audit found to be accurate and well-maintained) as the single source of project status.
9. **Add a real (or high-fidelity, contract-schema-validated) staging target before the next major
   milestone.** Once Seif publishes real staging/prod hosts, replace the `TBD.example` placeholders
   in `app_config.dart` immediately and run at least one full manual pass of every built flow against
   the real backend — the mock backend is well-built but cannot substitute for real network
   conditions, real error responses, or real latency, and no finding in this audit (including the
   Android permission bug) was ever going to be caught by mock-backend testing alone.

---

### Evidence index

Figma (direct MCP queries, this audit): fileKey `P6044i0giD9TmdQ7C2AmLq`, nodes `0:1` (top-level
listing — returns only "Assets / component"), `82:819`, `82:1171`, `337:15875`, `337:5303`,
`337:10373`, `337:5702`, `337:5269`. Contract (read in full): `contract/openapi.yaml` (1514 lines),
`contract/error-codes.md`, `contract/contract-changelog.md`, `contract/realtime.md`,
`contract/SOURCE.md`. Repo (read/grepped directly): `lib/core/**` (router, network, storage,
providers), `lib/features/{auth,registration,home,catalog,shell,quiz}/**`, `lib/dev/mock_backend.dart`,
`pubspec.yaml`, `android/app/src/{main,debug,profile}/AndroidManifest.xml`, `ios/Runner/Info.plist`,
`docs/DESIGN_ISSUES.md`, `docs/KNOWN_BUGS.md`, `test/**` (file listing + counts), `git log
--oneline --all`, `git status`.
