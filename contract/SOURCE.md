# Vendored API contract — pinned copy

Source: https://github.com/seifhamdii-collab/level-up-contract
Pinned commit: 2dca3c5 ("Mirror contract from level-up-backend@1274492577864943e53ed39c93e95c1f4beccd23")
Vendored: 2026-09-12
Previous pin: 184d6ec ("Mirror contract from level-up-backend@4a8e7cfe63696bbfc2125b158e7ffdbcd149ed27", v3.0.0-m1), vendored 2026-09-04

info.version at this pin: 3.13.0-m1

Operation census at this pin, counted from source (operation blocks at indent 6 — NOT
`grep -c "x-stability: stable"`, which returns 31 because line 3 is header prose and line 1361
sits inside a `description`): **29 stable · 13 draft · 42 total**. The previous pin was
**21 stable · 15 draft · 36 total**.

Eight operations became `stable` across this delta: `getMyMistakes`, `getMyMistakesForSubject`,
`getLeaderboard`, `getMyRank`, `requestAccountDeletion`, `cancelAccountDeletion`,
`getFlashcardsForLecture`, `setFlashcardSelfGrade`.

## Why this pin moved, and what it unblocked

Re-vendored to unblock the Mistakes / "My Fault" flow (`docs/day10_mistakes_brief.md` STEP 0).
The previous pin was **thirteen minor versions behind** and did not contain that surface at all.
The same move ends the holding action on the leaderboard: `DECISIONS.md` **D-008** gated a
finished board *only* because `getLeaderboard` / `getMyRank` were draft at `184d6ec`, and they
are stable here. That gate now needs an explicit re-decision — it is not lifted by this file.
`seif_fight.md` **S38** ("account deletion has no endpoint") is likewise answered.

## Delta from 3.0.0-m1 — seventeen version bumps, newest first

Full text in `contract-changelog.md`. Nothing was adopted between these two pins; every
intermediate version listed here is superseded by this one.

| Version | Change | Breaking |
| --- | --- | --- |
| 3.13.0-m1 | Both flashcard operations → `x-stability: stable` | no |
| 3.12.0-m1 | Anatomy Flashcards surface added (`draft`); `hasFlashcards` added additively to `UniversitySubjectTree`'s lectures — deliberately NOT on `SchoolSubjectTree` | no |
| 3.11.1-m1 | Question `imageUrl` becomes live-composable; `thumbnailUrl` is deliberately null in every environment | no |
| 3.11.0-m1 | 🔴 `POST /quizzes` `mode: retakeWrong` takes an optional leaf id and NARROWS the pool to it — the terminal "replay" step of the Mistakes flow. `createQuiz` re-stamped `x-behaviour-changed: 3.11.0-m1` (adr-136 on adr-135) | **BEHAVIOURAL** |
| 3.10.0-m1 | **The Mistakes surface ships** — `GET /me/mistakes`, `GET /me/mistakes/subjects/{subjectId}`, both `stable` on arrival (adr-133) | no |
| 3.9.2-m1 | 🔴 `getExplanation` has **NO BACKEND ROUTE** and never has had one, despite being published `stable` | no |
| 3.9.1-m1 | `getMyRank` publishes lower bounds it already enforced | no |
| 3.9.0-m1 | 🔴 `getMyRank` answers `404 not_ranked` for a student with no points, instead of inventing a rank | **BEHAVIOURAL** |
| 3.8.0-m1 | Both account-deletion operations → `stable` | no |
| 3.7.0-m1 | `GET /leaderboard` may return a SHORT page while `hasMore` is true — page until `hasMore` is false (3.6.0-m1 never existed) | **BEHAVIOURAL** |
| 3.5.2-m1 | Leaderboard rendering clarification | no |
| 3.5.1-m1 | Leaderboard operations declare the `403 account_pending_deletion` they could already return | no |
| 3.5.0-m1 | Both leaderboard operations → `stable` | no |
| 3.4.0-m1 | `GET /leaderboard` bounded to the top 200 visible students, ever (adr-116) | **BEHAVIOURAL** |
| 3.3.0-m1 | Account deletion enters: `POST`/`DELETE /me/deletion-request`, a 30-day grace window, and `403 account_pending_deletion` on every authenticated endpoint **except an exact four** — `GET /me`, `POST`/`DELETE /me/deletion-request`, `POST /auth/logout` (adr-114). `StudentProfile.pendingDeletion` added, optional | no |
| 3.2.0-m1 | `getMyRank` answers over the VISIBLE population; `403` for a `scoreHidden` caller (adr-113) | **BEHAVIOURAL** |
| 3.1.0-m1 | `GET /leaderboard`'s cursor becomes a signed, expiring token — do not decode, build or persist one | no |

⚠️ **Five of these are BEHAVIOURAL and none of them moves a schema.** A regenerated client is
byte-identical for every one; the build cannot catch them. `3.11.0-m1` is the one that touches
already-shipped code — `lib/features/quiz/repository/quiz_repository.dart`'s `createQuiz` sends a
body whose *legal combinations* changed underneath it, even though the request shape did not.

The version string 1.4.0-m1 is PERMANENTLY INVALID — briefly published 2026-08-14, reverted
~15 minutes later without a changelog entry. Discard any document labelled 1.4.0-m1 on sight.

## Staging

**Not re-probed at this pin.** The last observation is 2026-09-04 against backend
`78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1` (built 2026-09-03T15:38:17Z), recorded in
`.ai/audits/current/smoke-staging-2026-09-04.md`: 13 of the then-21 stable operations decode,
`PATCH /me` answers 405 and `GET /me/entitlements` 404. **Whether staging serves any of the eight
newly-stable operations is UNOBSERVED.** For the Mistakes pair specifically it is worse than
unobserved — see `seif_fight.md` **S44**: the only staging test account (`+2010000000001`,
school-track) has an empty catalog, so it can never hold a graded wrong answer and both operations
will answer empty regardless of whether they are deployed.

## Rules

The source repo also carries `openapi-admin.yaml`, `error-codes-admin.md` and
`contract-changelog-admin.md` — the admin SPA's contract (adr-050). They are deliberately NOT
vendored: the app has never consumed them and they are not the mobile partner's surface.

Do NOT edit these files here — they are Seif's owned artifact. When Seif publishes a
new version, re-copy from the source repo and bump the commit above. Build ONLY against
paths marked `x-stability: stable`.
