# Screens with API gaps — screen-first view (contract 3.23.0-m1)

**Date:** 2026-09-24 · **Stage:** Phase 1 · **Level:** SOURCE (read, not run)
Method: every `GoRoute` in `lib/core/router/app_router.dart` walked in reverse — what the screen
shows, where each datum comes from, which affordances are unwired. Companion to
`api_ui_endpoint_inventory.md` (endpoint-first).

Contract tags are only `auth, catalog, commerce, entitlements, flashcards, leaderboard, profile,
quiz, reference`. There is **no** friends, referral, support-ticket, chat or streak operation in any
contract version, so screens needing those have gaps that no endpoint can close today.

## Route census

| Route | Screen | Data sources | 4 states (load/empty/err/offline) | API gap? |
| --- | --- | --- | --- | --- |
| `/` | Onboarding | static copy | n/a | no |
| `/login`, `/otp` | Login, OTP | requestOtp, verifyOtp | yes / n/a / yes / yes | no |
| `/register`, `/register/track`, `/register/school`, `/register/university` | Sign-up wizard | 7 reference ops, completeRegistration | yes / partial / yes / yes | no |
| `/track-select` | `_Placeholder` (router `:136`) | none — "coming soon", no entry point | no | dev stub |
| `/home` | Home | `GET /me` (level, `points.total`) | yes / n/a / yes / yes | **yes** — see below |
| `/leaderboard` | Leaderboard | `GET /leaderboard`, `GET /me` | all four | **yes** — own-rank, share |
| `/learn` + `subject/:id/…` | Subjects, subject tree | listSubjects, getSubjectTree | all four | lecture flashcards entry missing |
| `/learn/mistakes/…` | Mistakes overview + tree | getMyMistakes, getMyMistakesForSubject | all four | replay quiz (owner-ruled out) |
| `/message` | `MessagePlaceholderScreen` | none | no | **yes** — inbox (draft ops) |
| `/account`, `/profile` | Profile | `GET /me` | yes / n/a / yes / yes | **yes** |
| `/profile/edit` | Edit Profile | `GET /me`, `PATCH /me`, `GET /reference/avatars` | yes / n/a / yes / yes | photo upload (draft), parent phone |
| `/settings` | Settings | local prefs, `GET`/`PATCH /me` | partial | **yes** — push, delete account |
| `/refer`, `/support`, `/friends` | shells | none | no | **yes** — no contract surface at all |
| `/legal/privacy`, `/legal/terms` | Legal document | none (text not supplied, S30) | no | copy gap, not API |
| `/quiz/setup` | Quiz setup | subject tree cache, createQuiz | yes / n/a / yes / yes | no |
| `/quiz/:id`, `result`, `review` | Quiz, Result, Review | submitAnswer, getExplanation, finishQuiz; review in-memory | n/a (session) | cold deep-link / history (draft) |

## SCREENS WITH API GAPS

| Screen | Required capability | Endpoint | Contract status | Implementation | Gap |
| --- | --- | --- | --- | --- | --- |
| Settings | Register the device for push | `PUT /me/fcm-token` | **stable** | none; no push package | **Buildable now** — needs Firebase setup + permission flow; toggles themselves have no contract storage |
| Settings (or Profile) | Delete my account | `POST /me/deletion-request` | **stable** | none | **Buildable now** — needs design (DESIGN_ISSUES #62) |
| Any screen hit by `403 account_pending_deletion` | Cancel pending deletion | `DELETE /me/deletion-request` + `GET /me.pendingDeletion` | **stable** | model only | **Buildable now** — the contract mandates this destination; none exists |
| Subject tree (university lectures) | Open a lecture's flashcards | `GET /flashcards/lectures/{id}/cards`, `PUT …/self-grade` | **stable** | repo + notifier, no screen, no mock | **Buildable now** — needs a screen, an entry point from `Lecture.hasFlashcards`, a mock route |
| Leaderboard | "My rank" when outside the visible page | `GET /leaderboard/me` | **stable** | not called — **by decision** D-008 | Decision, not a gap: reopening it is the owner's call |
| Home | Unread badge on bell | `GET /me/notifications/unread-count` | draft | inert bell | wait for stable |
| Message tab | Inbox list + mark read | `GET /me/notifications`, `POST …/read` | draft | placeholder | wait for stable |
| Home | Continue Learning | `GET /quizzes` | draft | coming-soon section | wait for stable |
| Home | Top Student | `GET /leaderboard` (stable) | stable | coming-soon section, not wired | **Product/design decision** — the data exists; whether Home should show it is not settled |
| Home | Daily Tasks | — | **none in contract** | coming-soon section | needs contract (seif_fight) |
| Profile | Favorite questions | `GET /me/favorites` | draft | disabled row (S11) | wait for stable |
| Profile | Your Progress | — | none identified | disabled row | needs contract / product |
| Profile | Rank tier ("HERO") | — | no tier field on `StudentProfile` | omitted | needs contract |
| Edit Profile | Upload custom photo | `PUT /me/avatar` | draft | disabled button (S29) | wait for stable |
| Edit Profile | Parent's number | — | not on `GET /me` | row not built | needs contract |
| Quiz | Bookmark a question | `PUT`/`DELETE /questions/{id}/favorite` | draft | icon omitted | wait for stable |
| Quiz result / review | Reopen a past quiz | `GET /quizzes/{id}` | draft | in-memory only (S14) | wait for stable |
| Leaderboard | Share | — | none | disabled icon | not an API matter |
| Friends / Refer / Support | social, referral, tickets | — | **none in contract** | inert shells (S5, S33, S36) | needs contract + product |
| (none today) | Terms acceptance | `GET`/`POST /me/terms-acceptance` | draft (new) | none | wait for stable; also needs a design and a Terms text (S30) |
| (none today) | Account recovery (lost phone) | 4 × `/auth/recovery/*` | draft | none | wait for stable |

## What is buildable today (stable + unbuilt + has a screen to live on)

1. **Flashcards (university lecture)** — two stable ops, data layer done, no screen.
2. **Account deletion + cancel** — two stable ops, nothing built, contract-mandated cancel route.
3. **Push registration** — one stable op, needs platform setup (Firebase), no design needed for the
   token call itself; the Settings toggles still have nothing to persist to.

Everything else in the gap table either waits for `draft → stable`, needs a contract that does not
exist, or is a recorded owner decision (`getMyRank`, retake-wrong replay).
