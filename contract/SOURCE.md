# Vendored API contract — pinned copy

Source: https://github.com/seifhamdii-collab/level-up-contract
Pinned commit: 0df5cf4 ("Mirror contract from level-up-backend@9e273b80aa7f31d41a46b78bb03341d06c2aaec2")
Vendored: 2026-10-04
Previous pin: f462968 ("Mirror contract from level-up-backend@f5014e6d675c047aad04364a7064661c009d6949", v3.27.0-m1), vendored 2026-09-29

info.version at this pin: 3.28.0-m1

Operation census at this pin, counted by parsing `paths` with a YAML parser (never
`grep -c "x-stability: …"` — header and description prose inflate both counts):
**38 stable · 16 draft · 54 total**. Of the 38 stable, 3 are `x-consumers: [web]` and are
forbidden to the app, leaving **35 stable operations the app may build against**.
The previous pin (f462968) was **35 stable · 19 draft · 54 total**.

All four vendored files are blob-identical to upstream `0df5cf4` (`git hash-object` on each equals
`git rev-parse 0df5cf4:<file>`). `error-codes.md` and `realtime.md` did not change.

## Delta from 3.27.0-m1 — one mobile-visible version (2026-10-04 re-vendor)

Re-vendored on the owner's request (2026-10-04), as a contract update only: nothing is built
against it yet. Upstream moved one commit past f462968 (`0df5cf4`, 2026-10-01). It touches
`openapi.yaml` (+18 / −7) and `contract-changelog.md` (+6) only; the admin files did not move.

| Version | Change | Breaking | App impact |
| --- | --- | --- | --- |
| 3.28.0-m1 | The notification inbox goes **`draft` → `stable`**: `listMyNotifications` (`GET /me/notifications`), `getUnreadNotificationCount` (`GET /me/notifications/unread-count`), `markNotificationRead` (`POST /me/notifications/{notificationId}/read`), all mobile-only (no `x-consumers`). Each inbox item gains a **required** `category` (`system` / `announcements` / `support`, derived server-side from `kind`; today `enrolment_opened` → `system`, so the other two stay empty until a kind maps to them). `listMyNotifications` gains an optional `?category=` filter; an unknown value is the existing `400 validation_failed`. The unread count stays the total across all categories (changelog, 2026-09-26) | no | none yet: the app calls none of the three (the Home bell is inert and its unread dot is off, DESIGN_ISSUES #41; `/message` is a placeholder). An inbox needs owner and design rulings and a new FORMULATE first |

Clients MUST ignore an item whose `kind` they do not recognise and an unknown `category` value. The
3.19.0-m1 entry's push guidance still stands: this is an inbox, not push, so no push-permission
prompt or "notifications enabled" indicator is to be built from it. No `x-behaviour-changed` stamp and no
breaking entry. `getUnreadNotificationCount` and `markNotificationRead` keep their shapes. No schema
the app decodes changed, and no schema bound in `test/guards/contract_models_test.dart` changed (the
inbox item is an inline schema no Dart class decodes), so no model, mock or fixture change came with
this re-vendor.

⚠️ **Line-number drift.** Lines 1–988 keep their numbers (only line 28, `info.version`, and line 983,
the first of the three `x-stability` flips, change in place). The inbox block grows by 11 lines: old lines 989–1008 move
by +7 or +10, and every `openapi.yaml:NNN` citation past old line 1008 is now off by **+11**. The
`flashcardCount` cite `openapi.yaml:2878-2891` (in `subject_tree.dart` and its generated
`subject_tree.freezed.dart`) is now `:2889-2902`, and the single-line cite `openapi.yaml:2891` (the
lecture's `required` list, in those two files, `mock_backend.dart` and `catalog_models_test.dart`)
is now `:2902`.
Citations written against earlier pins were already approximate.

## Delta from 3.23.0-m1 — four mobile-visible versions (2026-09-29 re-vendor, kept for history)

Re-vendored on the owner's Wave 22 ruling (2026-09-29): the Flash Card Setup screen needs
`flashcardCount`, which only 3.27.0-m1 carries. Upstream moved seven commits past ea83099
(`96888a1`, `38a6550`, `6597313`, `d6d182b`, `0c44071`, `df955cc`, `f462968`); some touch only the
admin files, which are deliberately not vendored.

| Version | Change | Breaking | App impact |
| --- | --- | --- | --- |
| 3.24.0-m1 | `getQuizReview` (`GET /quizzes/{quizId}`) and `listFavorites` corrected — both still **`draft`**; `error-codes.md` + `quiz_not_finished` (403) | no | none: the app calls neither (the review is built from the in-memory session) |
| 3.25.0-m1 | `getTermsAcceptance` / `acceptTerms` **`draft` → `stable`** | no | stable but inert in every environment (`currentVersion: null`) and no design exists; not built |
| 3.26.0-m1 | five **`draft`** `/support/tickets` operations, new tag `support`; `error-codes.md` + `ticket_closed` (409) | no | none (draft) |
| 3.27.0-m1 | `UniversitySubjectTree.lectures[]` gains a **required** `flashcardCount` (`openapi.yaml:2878-2891`); `hasFlashcards` is exactly `flashcardCount > 0`; "one `pageSize=10` page per round" (changelog, 2026-09-25) | no | `Lecture.flashcardCount` added in the same change, with the mock and test fixtures — without it `test/guards/contract_models_test.dart` goes red |

No `x-behaviour-changed` stamp and no breaking entry. Both flashcards operations, their schemas,
`EntitlementType` / `EntitlementState`, `CursorPage` and `ProblemDetails` are unchanged.

⚠️ **Line-number drift.** New text lands at several places, so `openapi.yaml:NNN` citations in
`lib/` / `test/` comments written against earlier pins are approximate.

## Delta from 3.22.0-m1 — one mobile-visible commit (2026-09-24 re-vendor, kept for history)

Upstream moved three commits past 768e67d (`bc27953`, `200073c`, `ea83099`). The first two touch
**only** the admin files (`openapi-admin.yaml`, `error-codes-admin.md`,
`contract-changelog-admin.md`), which are deliberately not vendored. Only `ea83099` touches the
mobile contract:

| Version | Commit | Change | Breaking |
| --- | --- | --- | --- |
| 3.23.0-m1 | ea83099 | `GET /me/terms-acceptance` (`getTermsAcceptance`) and `POST /me/terms-acceptance` (`acceptTerms`) added — **both `draft`**, mobile-only (no `x-consumers`). Inert in every environment until the server configures a Terms version: `currentVersion: null`, every accept is `400 validation_failed`. Records the student's own acceptance — **not** parent consent | no |

Files changed: `openapi.yaml` (+62/−1: one new path, two operations, version line) and
`contract-changelog.md` (+9). `error-codes.md` and `realtime.md` are byte-identical to the previous
pin. No existing operation, schema, field, response, error code, `x-stability` value or
`x-behaviour-changed` stamp changed. **No new operation is buildable** — the delta adds two drafts.

⚠️ **Line-number drift.** The new path is inserted after old line 913, so every `openapi.yaml:NNN`
citation in `lib/`/`test/` comments that points past ~913 is now off by **+61**. The citations
were already a mix of pins (`184d6ec`, 3.13.0-m1, 768e67d); treat them as approximate.

The notes below are the 3.13.0-m1 → 3.22.0-m1 delta, kept for history; they were written at the
768e67d pin and its counts are that pin's.

Four operations became `stable` across this delta, and **only one of them is the app's to build**:
`registerFcmToken` (mobile). The other three are `x-consumers: [web]` — `redeemSubscriptionCode`,
`requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`.

## Why this pin moved, and what it unblocked

Re-vendored because the previous pin was **nine minor versions behind** and, more seriously, was
**actively misleading about `getExplanation`**. At 2dca3c5 that operation is published `stable`
while carrying a note saying there is no backend route and that `AnswerResult.explanationAvailable`
is "a hard `false`". Version 3.14.0-m1 discharges that note: the route is live, the surface is
gated on `baseSubscription`, it gains a `429`, and `explanationAvailable` becomes a real
per-question signal. **No `x-behaviour-changed` stamp was added** — Seif's reasoning is that an
operation with no route has no shipped behaviour to change. That reasoning does not hold for this
client, which shipped `lib/features/quiz/widgets/ai_explanation_panel.dart` anyway, so a
stamp-based scan for the dangerous class misses the single most consequential change in this delta.

⚠️ **The re-vendor this pin performs is the one `docs/DECISIONS.md` D-008 was waiting on.** The
leaderboard gate's comment at `lib/core/router/app_router.dart:152-158` claims `GET /leaderboard`
is "`x-stability: draft` AT OUR PIN". That was already false at 2dca3c5 (it is `stable` there) and
is false here. The remaining step is D-008's middle one — audit the board against the behavioural
changes it predates — not another re-vendor.

## Delta from 3.13.0-m1 — nine version bumps, one commit each, newest first

Full text in `contract-changelog.md`. Nothing was adopted between these two pins.

| Version | Commit | Change | Breaking |
| --- | --- | --- | --- |
| 3.22.0-m1 | 768e67d | `StudentProfile.school.parentReportStatus` added — optional, `active`/`inactive`, **School track only**. Reads `inactive` for every student and nothing is delivered to any parent. No `pending` value, ever | no |
| 3.21.0-m1 | bfa6cdd | Both redemption-session operations → `stable`; 🔴 `redeemSubscriptionCode` gains `redemption_in_progress`, splitting "still running" out of `redemption_scope_only` | **BEHAVIOURAL** (web) |
| 3.20.0-m1 | 9f4aacc | Redemption-scoped web session arrives (2 `draft` ops); `redeemSubscriptionCode` replays the original success for the same student instead of `409` | **BEHAVIOURAL** (web) |
| 3.19.0-m1 | 083183d | In-app notification **inbox** arrives: `listMyNotifications`, `getUnreadNotificationCount`, `markNotificationRead` — all three `draft` | no |
| 3.18.0-m1 | c0b63a1 | `registerFcmToken` → `stable`. **The only mobile stability unlock in this delta** | no |
| 3.17.0-m1 | 03adccc | `registerFcmToken` route goes live and declares `400 validation_failed` (absent/empty/whitespace token, >4096 chars, non-JSON body — no `415`, ever) | no |
| 3.16.0-m1 | fe4dab2 | `redeemSubscriptionCode` → `stable` (web) | no |
| 3.15.0-m1 | 62fa6ba | `redeemSubscriptionCode` route goes live; declares `400` and `429` (web) | no |
| 3.14.0-m1 | a42b84d | 🔴 **`getExplanation` IS NOW IMPLEMENTED** — the "DELIBERATELY UNIMPLEMENTED" note is gone, the surface is **subscription-gated** on `baseSubscription`, a `429 rate_limited` is added, and `explanationAvailable` stops being a hard `false` | no (but see above) |

Codegen surface of the whole delta, for a client that hand-writes its models: one added optional
property (`parentReportStatus`), one added `429` (`getExplanation`), one added `400`
(`registerFcmToken`), one added `500` (`redeemSubscriptionCode`, web). `error-codes.md` gains two
rows — `redemption_in_progress`, and narrowed wording on `redemption_scope_only` — both web-only.
**`realtime.md` has not changed since the initial contract commit (`23f0535`)** and is byte-identical
here; no realtime work is implied by this delta.

🔴 **Two of the four newly-stable operations are the first `stable` paths the app is FORBIDDEN to
call.** Every previously-forbidden operation was also `draft`, so "build only against
`x-stability: stable`" was sufficient protection on its own. At this pin it is not: `stable` must
now be read together with `x-consumers`. The three web-only stable operations are
`redeemSubscriptionCode`, `requestRedemptionSessionOtp` and `verifyRedemptionSessionOtp`; the app
is purchase-silent (adr-049 §3/§4) and must never build any of them.

The version string 1.4.0-m1 is PERMANENTLY INVALID — briefly published 2026-08-14, reverted
~15 minutes later without a changelog entry. Discard any document labelled 1.4.0-m1 on sight.

## Staging

**Not re-probed at this pin, and the last observation is now stale by more than the delta.** The
most recent probe is 2026-09-22 against backend `0f97f289852b76a2762865169fb5efba909e7c1e` (built
2026-09-22T07:54:38Z), recorded in `.ai/audits/current/smoke-staging-2026-09-22.md`: exit 0, every
arm decoded, including `GET /leaderboard`, `PATCH /me` (200) and `GET /me/entitlements` (200). The
probe before it, 2026-09-04 against backend `78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1`
(`smoke-staging-2026-09-04.md`: 13 of the then-21 stable operations decode, `PATCH /me` 405,
`GET /me/entitlements` 404), is superseded and should not be quoted as current. **Every operation
this delta unblocks is UNOBSERVED**, and the smoke harness itself
(`tool/smoke/real_api_smoke_test.dart`) still walks the 2026-08-23 operation set plus the leaderboard
arm added 2026-09-22 — it is stale against the *previous* pin, never mind this one. The three inbox
operations made stable at 3.28.0-m1 have never been probed on staging.

For the Mistakes pair, re-probing cannot help: `seif_fight.md` **S44** — the only staging test
account (`+2010000000001`, school-track) has an empty catalog, so it can never hold a graded wrong
answer and both operations will answer empty regardless of whether they are deployed.

## Rules

The source repo also carries `openapi-admin.yaml`, `error-codes-admin.md` and
`contract-changelog-admin.md` — the admin SPA's contract (adr-050). They are deliberately NOT
vendored: the app has never consumed them and they are not the mobile partner's surface.
All three moved in the 2026-09-29 delta (ea83099 → f462968); none moved in the 2026-10-04 delta
(f462968 → 0df5cf4). That is Badawy's document, not ours.

Do NOT edit these files here — they are Seif's owned artifact. When Seif publishes a
new version, re-copy from the source repo and bump the commit above. Build ONLY against
paths marked `x-stability: stable` **and not marked `x-consumers: [web]`**.
