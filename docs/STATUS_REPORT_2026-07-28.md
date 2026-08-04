# Level Up — Project Status Report

_Generated 2026-07-28. Evidence base: repo `level-up-app` (working tree + `git log`), vendored contract at `level_up_app/contract/`, project docs (`docs/`, vault `00_Project/`), and direct Figma inspection of file `P6044i0giD9TmdQ7C2AmLq`. Every claim cites a commit, file path, or doc section. Where evidence was insufficient, it is flagged._

> **Two caveats up front.** (1) The most recent increment (Day 5 / Learn tab) is **present in the working tree but uncommitted** — 30 changed/new files, `git status`. It is real, tested code but not yet in history. (2) `docs/PROGRESS.md` is **stale** (`_Last updated: 2026-07-23_`, mid-Day-2) and was NOT used as a status source; git history and the file tree were used instead.

---

## 1. Milestones & Status

Two milestone systems coexist: **Seif's contract Milestone-1** (the API surface) and the **app's Day-based delivery increments** (how the Flutter build is sliced). Both are evidenced below.

### Contract Milestone-1 (owner: Seif)
Scope: 33 API paths, split STABLE (build now) vs DRAFT (shapes may change). Evidence: `contract/openapi.yaml` (33 `^  /` path keys; 22 `x-stability: stable` operation markers, 16 `x-stability: draft`), `contract/contract-changelog.md` (2026-07-19 "Milestone-1 contract v1 drafted (33 paths)"), pinned at commit `23f0535` (`contract/SOURCE.md`).
Status: **Contract delivered & vendored (done); client implementation in progress** — 12 of 22 stable operations are consumed in code (see §5), the rest not started. Draft paths are correctly untouched.

### App delivery increments ("Days")
Reconstructed from `git log --oneline --all` (15 commits) and the `docs/day*_brief.md` files.

| Increment | Scope | Status | Evidence |
|---|---|---|---|
| **Day 0 — Foundation** | Feature-first scaffold, core infra (Dio + interceptors, `ScreenState`/`StateWidget`, `SecureStorage`), 2-theme `AppColors`, go_router, AR/EN i18n, flavors, bundled fonts, 22 Claude skills | **Done** | commits `5e4a512`, `9e094d7`, `57cc8f0`, `47d15a2` (fonts), `8b1d568` (skills); files `lib/core/**`, `lib/main_*.dart` |
| **Day 1 — Auth (login + OTP)** | Phone login (E.164 + Arabic-digit fold), 6-digit OTP verify with fork (authenticated vs registrationRequired), offline as distinct state | **Done** | commit `99ef322` ("23 tests"), `28165f9` (offline/`clearTokens` fix); `lib/features/auth/screens/{login,otp}_screen.dart` |
| **Day 1b — Session/forced-logout** | `AuthController`, single-flight loop-safe refresh, `AuthInterceptor` (`session_superseded`→logout, `authentication_required`→refresh+retry once), router redirect guard | **Done** | commit `b3683c6` ("46 tests"); merged to `main` via `f4514c4`; `lib/features/auth/notifier/auth_controller.dart`, `lib/core/network/interceptors/auth_interceptor.dart` |
| **Day 2 — Registration spine + pickers** | Sign Up_1 (identity), Sign Up_2 (track), `RegistrationController`, 7 reference-picker providers | **Done** | commit `08a0b61` ("77 tests"); `lib/features/registration/notifier/reference_providers.dart`, `.../screens/signup_{identity,track}_screen.dart` |
| **Day 3 — Registration detail + submit** | School & University detail forms (geography conditionality adr-010), `POST /auth/register`, "Create New Account" fix | **Done** | commit `57fab32`; merged to `main` via `16fb080`; `lib/features/registration/screens/{school,university}_detail_screen.dart` |
| **BUG-001 fix** | Registration red-screen (illegal provider mutation in `initState`) → seed draft in OtpScreen listener | **Done** | commit `b8ee9f3`; `docs/KNOWN_BUGS.md` |
| **Day 4 — Home + nav shell** | School Home from `GET /me` + `/me/entitlements`, bottom-nav `StatefulShellRoute`, mock harness | **Done (committed, HEAD)** | commit `8d5fc9f`; `lib/features/home/**`, `lib/features/shell/**`, `lib/features/profile/**` |
| **Day 5 — Learn tab (catalog)** | Subjects + tree drill-down (Units→Chapters→Lessons) from `/catalog/subjects` + `/tree`; quiz-setup placeholder | **In progress — code complete, UNCOMMITTED** | `git status` (30 files: `lib/features/catalog/**`, `lib/features/quiz/**`); `docs/day5_learn_brief.md`; not in `git log` |
| **Day 6 — Quiz engine** | `POST /quizzes`, per-question answer, finish, AI explanation | **Not started** | Only placeholders exist: `lib/features/quiz/screens/quiz_setup_placeholder.dart`, router `/quiz/:quizId` → `_Placeholder` (`app_router.dart:190`) |

**Blocked item (not a whole milestone):** Unit/Chapter progress bars in the Learn tab — design requires data the contract lacks (`DESIGN_ISSUES.md` #16, 🔴). Resolvable by Seif or the designer; does not block the rest of Day 5.

**Could not verify:** exact per-commit test *pass* results over time (test counts are taken from commit messages, e.g. `99ef322` "23 tests", and from a current static count of 325 `test()`/`testWidgets()` calls — not from a re-run of historical commits). No CI record exists to corroborate (see §3).

---

## 2. Implementation Techniques & Architecture

Based only on files in the repo.

**State management — Riverpod, not Bloc.** Despite `flutter_bloc`/`bloc_test` being declared deps, there is **zero real Bloc/Cubit usage** in `lib/` (grep for `extends Bloc|extends Cubit|BlocProvider|BlocBuilder` returns nothing; the apparent hits are unrelated widgets named `CatalogBlock`/`_Block` skeleton loaders). State is Riverpod throughout: ~208 `Provider` references, 19 `AsyncNotifier`, 9 `FutureProvider`, 4 `NotifierProvider`. Bloc is evidently reserved for the not-yet-built quiz engine (per `docs/PROGRESS.md` "Bloc(quiz only)"). Async UI is modeled with a sealed `ScreenState<T>` (`lib/core/models/screen_state.dart`) rendered by a shared `StateWidget` (`lib/core/widgets/state_widget.dart`).

**Folder structure — feature-first.** `lib/core/**` (config, models, network, storage, theme, router, widgets, providers) + `lib/features/<feature>/{models,repository,notifier,screens,widgets}`. Features present: `auth`, `registration`, `profile`, `home`, `shell`, `catalog`, `quiz` (placeholder). This is consistent across every feature module.

**Networking → contract mapping.** Dio (`lib/core/network/dio_client.dart`) with a two-interceptor chain. `AuthInterceptor` implements the contract's global 401 behaviors verbatim — `session_superseded`→force-logout, `authentication_required`→refresh-and-retry-once (`lib/core/network/interceptors/auth_interceptor.dart`; matches `contract-changelog.md` "Global behaviors"). `ErrorInterceptor` parses RFC 9457 ProblemDetails and switches on the stable `code` field, mapping to typed exceptions and per-field errors (`error_interceptor.dart:10,29`; matches ADR-026 ProblemDetails+code). Repositories per feature (`*/repository/*_repository.dart`) call contract paths directly; the vendored `contract/openapi.yaml` is the single source of shapes.

**Navigation — go_router, declarative.** One `routerProvider` (`lib/core/router/app_router.dart`), a `StatefulShellRoute.indexedStack` for the 5 bottom-nav branches (`/home`, `/leaderboard`, `/learn`, `/message`, `/account`), with nested drill-down routes under `/learn` (`subject/:subjectId` → `unit/:unitId` → `chapter/:chapterId`). Full-screen routes (`/quiz/setup`, `/quiz/:quizId`, `/subscription`, `/profile`, `/settings`) sit outside the shell. Unbuilt destinations are explicit `_Placeholder` widgets, not missing routes.

**Local storage / caching.** `flutter_secure_storage` for the token pair + a persistent `device_id` (`lib/core/storage/secure_storage.dart`); `clearTokens()` deliberately preserves `device_id` on logout while `clear()` is a full reset. `cached_network_image` caches profile avatars. **`hive_ce` is a declared dependency but not referenced anywhere in `lib/`** — no on-device DB/caching layer is wired yet.

**Code generation / DI.** Code-gen via `build_runner` with `freezed` (immutable models/unions), `json_serializable` (camelCase, no `@JsonKey` name bridges), and `riverpod_generator`. DI is Riverpod provider overrides — notably the mock backend injects via a single `dioProvider` override (`lib/main_mock.dart`, `lib/dev/mock_backend.dart`); no `get_it`/`injectable`. i18n is generated (`flutter: generate: true`, ARB → `AppLocalizations`).

---

## 3. Skills & Stack

**Languages:** Dart (SDK `^3.10.4`, `pubspec.yaml`); ARB (i18n); YAML (contract).

**Framework:** Flutter (per `docs/PROGRESS.md`, Flutter 3.44.7 / Dart 3.10 — not otherwise pinned in-repo).

**Runtime dependencies** (`pubspec.yaml`): `flutter_riverpod ^3.3.2`, `go_router ^17.3.0`, `dio ^5.10.0`, `flutter_secure_storage ^10.3.1`, `connectivity_plus ^7.3.0`, `flutter_bloc ^9.1.1` (declared, unused), `freezed_annotation ^3.1.0`, `json_annotation ^4.12.0`, `shared_preferences ^2.5.5`, `hive_ce ^2.19.3` + `hive_ce_flutter ^2.3.4` (declared, unused in `lib/`), `url_launcher ^6.3.2`, `screen_protector ^1.5.3`, `intl 0.20.2` (pinned), `pinput ^6.0.2`, `device_info_plus ^13.2.0`, `flutter_svg ^2.3.0`, `country_flags ^4.1.2`, `cached_network_image ^3.4.1`.

**Dev / codegen / test:** `flutter_lints ^6.0.0`, `build_runner ^2.15.1`, `freezed ^3.2.6-dev.1`, `json_serializable ^6.14.0`, `riverpod_generator ^4.0.4`, `bloc_test ^10.0.0` (unused), `mocktail ^1.0.5`, `hive_ce_generator ^1.11.2`.

**Backend / API tooling:** OpenAPI 3 contract (`contract/openapi.yaml`) + `error-codes.md`, `realtime.md`, `contract-changelog.md`; conventions per ADR-026. Realtime (SignalR) is referenced (`contract/realtime.md`) but no Dart SignalR client is in `pubspec.yaml` — not yet integrated.

**Build / CI tooling:** **None found.** No `.github/workflows/`, no other CI config. Quality gates are manual (`flutter analyze` / `flutter test`), per the review workflow in `docs/PROGRESS.md`. **This is a gap.**

**Tooling note:** 22 Claude Code skills are vendored under `.claude/skills/` (commit `8b1d568`, "7 custom + 15 dart/flutter") — build-process tooling, not app runtime.

---

## 4. Code Quality Snapshot

_Snapshot only — a full audit is a separate pass._

**Tests — present and substantial.** 39 test files under `test/`, ~325 `test()`/`testWidgets()` calls (static count). Coverage tracks the built features closely: `test/features/{auth,registration,profile,home,shell,catalog}/`, plus core (`auth_interceptor_test`, `error_interceptor_test`, `app_router_test`, `secure_storage_test`) and mock-backend parse tests (`test/dev/`). Notable rigor in `test/features/catalog/catalog_navigation_test.dart` (asserts the subject tree is fetched exactly once across a full drill-down) and display-only-counter guarantees. **No coverage measurement is committed** (no `coverage/`, no CI producing it), so a coverage *percentage* cannot be verified — only that tests exist and are numerous.

**Linting.** `flutter_lints ^6.0.0` via `analysis_options.yaml`, which includes `package:flutter_lints/flutter.yaml` with **no custom rules enabled or disabled** (the `rules:` block is entirely commented out). Per commit messages and the review notes, `flutter analyze` is kept clean, but this is not machine-enforced (no CI).

**Documentation & comments.** Strong doc-comment discipline: most screens/notifiers open with `///` explaining intent and contract linkage (e.g. `otp_screen.dart` header, `main_mock.dart`). Project-level docs are unusually thorough — per-day briefs (`docs/day1..5_*_brief.md`), `docs/DESIGN_ISSUES.md` (33 tracked entries, severity-tagged, with code markers), `docs/KNOWN_BUGS.md`, and the vault decision log. Caveat: `docs/PROGRESS.md` is stale (2026-07-23) and contradicts current state — doc drift risk.

**Naming & structure consistency.** High. Every feature follows the same `{models,repository,notifier,screens,widgets}` layout; models are freezed+camelCase throughout; user-facing strings route through `AppLocalizations` (no hardcoded copy); colors route through `AppColors`/`colorScheme` (Day 4 & Day 5 color audits found zero hardcoded hex in feature widgets).

**Smells / things to watch (not a verdict):**
- **Declared-but-unused deps:** `flutter_bloc`, `bloc_test`, `hive_ce`, `hive_ce_flutter`, `hive_ce_generator` — carried before their features exist. Dead weight until Day 6 / a caching layer lands.
- **No CI** — every gate is manual and unenforced.
- **Uncommitted Day 5** — 30 files of tested work living only in the working tree is a loss risk until committed.
- **Placeholder default route** `/` → `_Placeholder('Onboarding')` (`app_router.dart:71`); onboarding not designed/built.
- **Stale PROGRESS.md** — should be regenerated or deleted to avoid misleading future sessions.

---

## 5. Implementation Map

**Figma access note:** I inspected the Figma file directly and confirmed its top-level structure — three flows (**School Student Flow**, **Common Sign in/up Pages**, **University Student Flow**) each replicated across **light / dark / RTL** sections, which is consistent with a ~90-frame count. However, I **could not enumerate all ~90 individual frames**: the Figma MCP page index truncates well before the screen frames, and no full frame-inventory doc exists in the repo. The map below is therefore built from **confirmed frames (with node ids where captured), the router's route list, the day-briefs, and `DESIGN_ISSUES.md`** — not from a complete frame walk. Screen names are only those I could verify; none are invented. Rows marked _(design-parallel, unverified)_ are inferred from the University flow existing as a mirror of School but were not frame-walked.

Endpoint stability is from `contract/openapi.yaml` (`x-stability`).

| Screen / Feature (Figma) | API endpoint(s) — STABLE/DRAFT | Implemented? | File / module | Notes |
|---|---|---|---|---|
| Login (Common, `82:819`) | `POST /auth/otp/request` — STABLE | Yes | `lib/features/auth/screens/login_screen.dart` | Bird-logo asset blocked (`DESIGN_ISSUES` #1) |
| OTP verify (Common, `82:1171`) | `POST /auth/otp/verify` — STABLE | Yes | `lib/features/auth/screens/otp_screen.dart` | 6-digit (contract) vs 4 in design (#5); success-badge asset blocked |
| Forced-logout / session guard | `POST /auth/refresh`, `/auth/logout` — STABLE | Yes | `auth_controller.dart`, `core/network/interceptors/auth_interceptor.dart` | Global 401 handling |
| Sign Up_1 identity (`337:15875`) | (no network; spine) | Yes | `registration/screens/signup_identity_screen.dart` | Referral field has no backend (#7) |
| Sign Up_2 track (`337:15947`) | — | Yes | `signup_track_screen.dart` | |
| Reference pickers (country/gov/city/school/edu-system/university/avatar) | `GET /reference/*` ×7 — STABLE | Yes | `registration/repository/reference_repository.dart`, `notifier/reference_providers.dart` | All 7 stable reference paths |
| School Registration detail (`337:5269`) | `POST /auth/register` — STABLE | Yes | `registration/screens/school_detail_screen.dart` | `dateOfBirth` missing in design (#2) |
| University Registration detail (`337:10373`) | `POST /auth/register` — STABLE | Yes | `registration/screens/university_detail_screen.dart` | `governorateId` missing / field order (#3,#4) |
| School Home (`337:5303`) | `GET /me`, `GET /me/entitlements` — STABLE | Partial | `features/home/**`, `features/profile/**` | Level card built; Daily Tasks / Continue Learning / Top Student stubbed (no endpoint); level threshold gap (#13) |
| Bottom-nav shell | — | Yes | `features/shell/main_shell.dart` | 5 tabs; Learn + Home real, others placeholder |
| Learn — Subjects (`337:5702`) | `GET /catalog/subjects` — STABLE | Yes (uncommitted) | `catalog/screens/subjects_screen.dart` | Client-side search; card counter from `questionCounter` |
| Learn — Units (`337:5894`) | `GET /catalog/subjects/{id}/tree` — STABLE | Yes (uncommitted) | `catalog/screens/units_screen.dart` | Progress bar dropped — data gap #16 🔴 |
| Learn — Chapters (`337:6047`) | `.../tree` (cached) — STABLE | Yes (uncommitted) | `catalog/screens/chapters_screen.dart` | Same #16 gap |
| Learn — Lessons (`337:6143`) | `.../tree` (cached) — STABLE | Yes (uncommitted) | `catalog/screens/lessons_screen.dart` | Lesson counter shown; taps → quiz-setup placeholder |
| Learn — Setup quiz | `POST /quizzes` — STABLE | Placeholder only | `quiz/screens/quiz_setup_placeholder.dart` | Day 6 |
| Quiz page / Quiz page w/ photo | `POST /quizzes/{id}/answers`, `/finish` — STABLE | No | router `/quiz/:quizId` → `_Placeholder` | Day 6 — the Bloc feature |
| Question explanation | `GET /questions/{id}/explanation` — STABLE | No | — | Day 6 |
| Leaderboard (`Leaderboard for school student`) | `GET /leaderboard`, `/leaderboard/me` — DRAFT | Placeholder only | `shell/screens/tab_placeholder.dart` | Draft endpoint — correctly not built |
| Learn — My Fault / Mistakes (×4 frames) | (retake-wrong via `POST /quizzes` mode) + favorites — mixed | No | — | "Mistakes" button = "Coming soon" snackbar |
| Message tab | — (no endpoint identified) | Placeholder only | `tab_placeholder.dart` | |
| Account / Profile edit | `PATCH /me` — STABLE; avatar `PATCH /me/avatar` — DRAFT | Placeholder only | router `/account`, `/profile` → placeholder | PATCH /me not yet consumed |
| Settings | — | Placeholder only | router `/settings` → `_Placeholder` | Theme-toggle question open (#10) |
| Subscription / Paymob return | `POST /checkout/sessions`, `/subscription-codes/redemptions` — DRAFT | Placeholder only | router `/subscription`, `/subscription/return` | Draft; Paymob return scheme unresolved |
| Account recovery (4 steps) | `/auth/recovery/*` ×4 — DRAFT | No | — | Draft; not in any Figma frame I verified |
| Custom avatar upload / FCM token / favorites / quiz history+review | `/me/avatar`, `/me/fcm-token`, `/me/favorites`, `GET /quizzes`, `GET /quizzes/{id}` — DRAFT | No | — | All draft — out of scope for now |
| University Home / Learn / Quiz (mirror of School) | same stable endpoints, track-scoped | No _(design-parallel, unverified)_ | — | University flow exists in Figma as a School mirror; only registration detail is built |

**Stable-endpoint coverage:** of 22 stable operations, **12 are consumed in code** (otp request, otp verify, register, refresh, logout, 7× reference, GET /me, /me/entitlements, /catalog/subjects, /catalog/subjects/{id}/tree — noting reference counts as 7 of these). **PATCH /me** and the four quiz/explanation stable ops (`POST /quizzes`, `/answers`, `/finish`, `/questions/{id}/explanation`) are the main **unbuilt stable** surface — i.e., the quiz loop (Day 6). All DRAFT paths are correctly unimplemented.

---

### Evidence index
Commits: `git log --oneline --all` (`5e4a512`…`8d5fc9f`, `main`=`16fb080`, `dev`=`8d5fc9f`). Working tree: `git status` (30 uncommitted Day-5 files). Contract: `contract/openapi.yaml` (33 paths; 22 stable/16 draft markers), `contract/contract-changelog.md`, `contract/SOURCE.md` (pinned `23f0535`). Config: `pubspec.yaml`, `analysis_options.yaml`, absent `.github/workflows/`. Docs: `docs/DESIGN_ISSUES.md` (33 entries), `docs/day{1..5}_*_brief.md`, `docs/KNOWN_BUGS.md`, vault `00_Project/Open_Questions.md`. Figma: file `P6044i0giD9TmdQ7C2AmLq`, nodes cited inline.
