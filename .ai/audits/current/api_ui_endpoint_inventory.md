# API ↔ UI endpoint inventory — contract 3.23.0-m1 (`ea83099`)

**Date:** 2026-09-24 · **Branch:** `merged` @ `e4d1401` · **Stage:** Phase 1 (investigation only)
**Method:** operation list parsed from `contract/openapi.yaml` with PyYAML; each operation traced
through `lib/` by four Sonnet subagents (auth/reference · profile/account/leaderboard ·
catalog/quiz/flashcards/mistakes · screen-first reverse audit); key claims re-checked by the lead
with grep (flashcards has no `screens/`; `Lecture.hasFlashcards` read by no widget; no call site for
`/me/deletion-request`, `/me/fcm-token`, `/leaderboard/me`; no `PATCH /me` in the mock;
`entitlementsProvider` is never watched).
**Verification level of everything below: SOURCE.** Nothing here was run on a device.

Companion files: `api_contract_update.md` (the re-vendor), `endpoint_ui_mapping.md` (where
unconnected endpoints belong), `screen_api_gaps.md` (screen-first view).

## Summary

| Classification | Count | Operations |
| --- | --- | --- |
| **STABLE + READY** (implemented, reachable UI flow) | **23** | 5 auth, 7 reference, `getMyProfile`, `updateMyProfile`, `getLeaderboard`, `listSubjects`, `getSubjectTree`, `createQuiz`, `submitAnswer`, `finishQuiz`, `getExplanation`, `getMyMistakes`, `getMyMistakesForSubject` |
| **STABLE + PARTIALLY IMPLEMENTED** (data layer only, no UI) | **3** | `getMyEntitlements`, `getFlashcardsForLecture`, `setFlashcardSelfGrade` |
| **STABLE + NOT IMPLEMENTED** | **4** | `registerFcmToken`, `requestAccountDeletion`, `cancelAccountDeletion`, `getMyRank` (by decision) |
| STABLE, `x-consumers: [web]` — forbidden to the app | 3 | `requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `redeemSubscriptionCode` — confirmed absent from `lib/` |
| **DRAFT** | **16** | 4 recovery, `uploadCustomAvatar`, 2 terms-acceptance (new), 3 notifications, `listModules`, `listQuizHistory`, `getQuizReview`, 3 favourites |
| DEPRECATED / REMOVED / UNKNOWN | 0 / 0 / 0 | — |
| **Total** | **49** | |

In the A–E scheme: **A 23 · B 3 · C 0 · D 3 · E 20** (E = 16 draft + 3 web-only + `getMyRank`).
The 30 app-buildable stable operations split as 23 A / 3 B / 3 D / 1 E.

## Inventory — stable, app-buildable (30)

Column key — **Repo**: repository method · **State**: provider / notifier / bloc · **Entry**: the
real user action that reaches it · **Mock**: served by `lib/dev/mock_backend.dart` (what a device
walk runs against) · **Cat**: A–E.

| Endpoint | Contract | Repo | State | Screen | Entry | Mock | Design evidence | Cat |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `POST /auth/otp/request` requestOtp | stable | `auth_repository.dart:29` | `loginProvider` `login_notifier.dart:14` | Login, OTP (resend) | `/login` → Send OTP | `:130` | day1 brief frames | **A** |
| `POST /auth/otp/verify` verifyOtp | stable | `auth_repository.dart:52` | `otpProvider` `otp_notifier.dart:69` | OTP | `/otp` → 6 digits → Verify | `:137` | day1 brief | **A** |
| `POST /auth/register` completeRegistration | stable | `registration_repository.dart:37` | `registrationSubmitProvider` `registration_submit_notifier.dart:44` | School / University detail | `/register/school` or `/register/university` → Start Learning | `:160` | day2/3/6 briefs | **A** |
| `POST /auth/refresh` refreshTokens | stable | `auth_repository.dart:81` | `auth_interceptor.dart` | — (silent on 401) | any authenticated call | `:184` | n/a | **A** (UI-less by design) |
| `POST /auth/logout` logout | stable | `auth_repository.dart:107` | `auth_controller.dart:76` | Profile | `/profile` → Log out → confirm | `:188` | day8 account brief | **A** |
| `GET /reference/countries` | stable | `reference_repository.dart:24` | `countriesProvider` `reference_providers.dart:49` | School detail | country dropdown | `:409` | day2 | **A** |
| `GET /reference/countries/{c}/governorates` | stable | `:44` | `governoratesProvider` `:55` | School / Uni detail | governorate dropdown | `:413` | day2/6 | **A** |
| `GET /reference/cities` | stable | `:67` | `citiesProvider` `:62` | School / Uni detail (`city_field.dart`) | city field | `:432` | day2/6 | **A** |
| `GET /reference/schools` (cursor) | stable | `:97` | `schoolSearchProvider` `school_search_notifier.dart:64` | School detail (`school_picker_field.dart`) | search + load-more | `:447` | day2 | **A** |
| `GET /reference/education-systems` | stable | `:133` | `educationSystemsProvider` `:88` | School detail | dropdown | `:467` | day2 | **A** |
| `GET /reference/universities` | stable | `:153` | `universitiesProvider` `:94` | University detail | picker | `:471` | day6 | **A** |
| `GET /reference/avatars` | stable | `:173` | `avatarsProvider` `:118` | Edit Profile → avatar sheets | `/profile/edit` → avatar → use default | `:475` | day8 account brief | **A** (not used at registration — `avatarId` deliberately not collected) |
| `GET /me` getMyProfile | stable | `profile_repository.dart:25` | `meProvider` `me_notifier.dart:17-42` | Home, Profile, Leaderboard, Settings | app launch → `/home` | `:195` | day4/day8 | **A** |
| `PATCH /me` updateMyProfile | stable | `profile_repository.dart:55` | `EditProfileNotifier` | Edit Profile, Settings (Rank privacy toggles `settings_screen.dart:296-313`) | `/profile/edit` → Save; `/settings` → toggles | **NO** | day8 | **A** — ⚠ mock has no `PATCH /me`, so a device walk on the mock cannot exercise it |
| `PUT /me/fcm-token` registerFcmToken | stable (3.18.0-m1) | — | — | — | NONE | no | see mapping | **D** — no push package in `pubspec.yaml`; Settings notification toggles render disabled (`settings_screen.dart:319-397`) |
| `POST /me/deletion-request` requestAccountDeletion | stable | — | — | — | NONE | no | see mapping | **D** — DESIGN_ISSUES #62, seif_fight S38 |
| `DELETE /me/deletion-request` cancelAccountDeletion | stable | — | — | — | NONE | no | see mapping | **D** — `pendingDeletion` is modelled (`student_profile.dart:77-105`) but never read |
| `GET /me/entitlements` getMyEntitlements | stable | `profile_repository.dart:78` | `entitlementsProvider` `me_notifier.dart:55-78` | — never watched | NONE (only invalidated, `session_scope.dart:61`) | `:217` | none found | **B** |
| `GET /me/mistakes` getMyMistakes | stable | `mistakes_repository.dart:50` | `MistakesOverviewNotifier` `mistakes_notifiers.dart:12` | Mistakes overview | `/learn` → Mistakes pill → `/learn/mistakes` | `:306` | day10 brief frame map | **A** |
| `GET /me/mistakes/subjects/{id}` | stable | `:82` | `MistakesTreeNotifier` `:78` | Mistakes subject + tree screens | overview → subject → unit/chapter | `:316` | day10 | **A** (leaf rows inert by owner ruling 2026-09-12 — replay quiz `404:7234` out of scope) |
| `GET /catalog/subjects` listSubjects | stable · BCHG 2.3.0 | `catalog_repository.dart:24` | `subjectsProvider` `subjects_notifier.dart:31` | Subjects | Learn tab `/learn` | `:348` | day5 | **A** |
| `GET /catalog/subjects/{id}/tree` | stable · BCHG 2.3.0 | `:51` | `subjectTreeProvider` `subject_tree_notifier.dart:47` | Subject tree → units/lectures/chapters/lessons | subject card → `/learn/subject/:id` | `:357` | day5/6 | **A** |
| `POST /quizzes` createQuiz | stable · BCHG 3.11.0 (retakeWrong leaf id) | `quiz_repository.dart:46` | `QuizSetupNotifier` `quiz_setup_notifier.dart:29` | Quiz setup | lesson/lecture → `/quiz/setup` → Start | `:387` | day7 | **A** — `normal` mode only (`quiz_mode.dart:34`, owner decision); `retakeWrong`/`review` unused |
| `POST /quizzes/{id}/answers` | stable | `:87` | `QuizBloc` `quiz_bloc.dart:122` | Quiz | Confirm answer | `:391` | day7 | **A** |
| `POST /quizzes/{id}/finish` | stable | `:115` | `QuizBloc` `:313` | Quiz → Result | Finish | `:396` | day7 | **A** |
| `GET /questions/{id}/explanation` getExplanation | stable (live since 3.14.0-m1) | `:149` | `QuizBloc` `:182`, poll `:268` | Quiz (`AiExplanationPanel`, shown iff `explanationAvailable`, `quiz_screen.dart:180-187`) | graded question → Show explanation | `:824` (no 429 arm) | day7 | **A** |
| `GET /flashcards/lectures/{id}/cards` | stable | `flashcards_repository.dart:65` | `LectureFlashcardsNotifier` `lecture_flashcards_notifier.dart:69` | **none** (no `screens/`) | NONE — `Lecture.hasFlashcards` is parsed, never read | **no** | see mapping | **B** |
| `PUT /flashcards/cards/{id}/self-grade` | stable | `:104` | notifier `:164` | **none** | NONE | **no** | see mapping | **B** |
| `GET /leaderboard` getLeaderboard | stable · BCHG | `leaderboard_repository.dart:39` | `LeaderboardNotifier` | Leaderboard | bottom nav `/leaderboard` | `:245` | leaderboard frames | **A** (D-008 closed 2026-09-22) |
| `GET /leaderboard/me` getMyRank | stable · BCHG | — (deliberate) | — | — | NONE | deliberately not served (`mock_backend.dart:232`) | see mapping | **E by decision** — D-008 / `DECISIONS.md:463-464`: no synthetic self-rank row |

## Inventory — web-only stable (3) and draft (16)

| Endpoint | Status | Flutter | Existing UI affordance (disabled / placeholder) | Cat |
| --- | --- | --- | --- | --- |
| `POST /auth/redemption-session/otp/request` · `/verify` | stable `[web]` | absent ✔ | — | E web-only |
| `POST /subscription-codes/redemptions` | stable `[web]` | absent ✔ (`lib/features/subscription/` is empty `.gitkeep` scaffolding; `/subscription` removed, `app_router.dart:427-430`) | — | E web-only, purchase-silent |
| `POST /auth/recovery/{start,verify-parent,new-phone,confirm}` | draft | absent | none | E draft |
| `PUT /me/avatar` uploadCustomAvatar | draft | absent | "Upload Photo" in `AvatarActionSheet`, **disabled** (`avatar_sheets.dart:135-138`, S29) | E draft |
| `GET`/`POST /me/terms-acceptance` (**new**) | draft | absent | none (`/legal/terms` is a static-text shell, different concern) | E draft — no seif_fight / DESIGN_ISSUES entry yet |
| `GET /me/notifications` · `/unread-count` · `POST …/{id}/read` | draft | absent | `/message` tab = `TabPlaceholder` "coming soon", doc names it the inbox (`tab_placeholder.dart:54-61`); Home bell inert, unread dot hard-coded false (`home_header.dart:14-36`, DESIGN_ISSUES #41) | E draft |
| `GET /catalog/modules` | draft | absent | none — contract says build "All subjects" first | E draft |
| `GET /quizzes` listQuizHistory | draft | absent | Home "Continue Learning" coming-soon (`coming_soon_section.dart:24-38`) | E draft |
| `GET /quizzes/{id}` getQuizReview | draft | absent | post-finish review is in-memory (`quiz_review_screen.dart:19-24`, S14); cold deep-link → `_QuizUnavailableScreen` | E draft |
| `PUT`/`DELETE /questions/{id}/favorite`, `GET /me/favorites` | draft | absent | bookmark icon deliberately omitted (`quiz_screen.dart:139-142`); Profile "Favorite questions" row disabled (`profile_screen.dart:197-205`, S11) | E draft |

## Contract-conformance findings (SOURCE level)

| # | Finding | Evidence | Severity |
| --- | --- | --- | --- |
| F1 | `PATCH /me` is not served by the mock backend, so Edit Profile save and the Settings rank toggles cannot be device-walked on `main_mock.dart` | `mock_backend.dart` handles only `GET /me` (`:195`) and `GET /me/entitlements` (`:217`) under `/me` | walk blocker for Profile/Settings |
| F2 | Flashcards pair has no mock route either | no `/flashcards` arm in `mock_backend.dart` | walk blocker for a flashcards wave |
| F3 | `403 account_pending_deletion` renders error copy on 5 screens but has no destination: the contract's "route to cancel" step cannot exist until `cancelAccountDeletion` has a screen | `exceptions.dart:134`, `mistakes_overview_screen.dart:53-56`, DESIGN_ISSUES #62 | product gap (tracked) |
| F4 | `getExplanation` `429` is handled and widget-tested, but the mock cannot produce it | `mock_backend.dart:824-860`; `ai_explanation_panel_test.dart:51` | walk parity only |
| F5 | Leaderboard `429` withholds retry but never surfaces the `Retry-After` value | `leaderboard_screen.dart:213-224` | minor UX; contract says "honour", which withholding satisfies |
| F6 | `otp_throttled` does not flow through `RateLimitedException`. **Not a contract violation**: the contract asks for `Retry-After` only on `rate_limited`, and `error-codes.md:12` promises none for `otp_throttled` | `error_interceptor.dart:34-40` | informational (subagent over-called it; corrected by lead) |
| F7 | `entitlementsProvider` is fetched by nothing (never watched), so `GET /me/entitlements` is dead at runtime | `session_scope.dart:61`, `me_notifier.dart:74` | dead code; the app is purchase-silent, so no UI may show price or upgrade |
| F8 | Dead `schoolsProvider` (non-paginated) beside the used `schoolSearchProvider` | `reference_providers.dart:73` | cleanup |
| F9 | No `auth_repository_test.dart` (siblings have repository-level error-mapping tests) | `test/features/auth/` | test gap |
| F10 | Stale comments: `profile_screen.dart:40-43` calls `/leaderboard/me` draft (it is stable); `home_header.dart` TODO says notifications have no endpoint (3 drafts exist since 3.19.0-m1); `mock_backend.dart:17-18` and `quiz_fixtures.dart:1` say pin `184d6ec` | as cited | doc drift |

## Staging (not re-probed in this stage)

Last smoke run 2026-09-22 against backend `0f97f289` (memory `staging-endpoint-coverage`,
`.ai/audits/current/smoke-staging-2026-09-22.md`): reference ×7, OTP, `GET`/`PATCH /me`,
`GET /me/entitlements`, catalog, the quiz loop, refresh, logout and `GET /leaderboard` decoded.
Unobserved on staging: flashcards pair, mistakes pair (the test account's catalog cannot produce a
mistake, S44), `getExplanation`, `registerFcmToken`, deletion pair, `getMyRank`. This is a
2-day-old observation of a different backend build — treat it as a lead, not a fact.
