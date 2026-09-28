# Vendored API contract — pinned copy

Source: https://github.com/seifhamdii-collab/level-up-contract
Pinned commit: ea83099 ("Mirror contract from level-up-backend@03dd474ac89d4198892898d30faa024d965062b9")
Vendored: 2026-09-24
Previous pin: 768e67d ("Mirror contract from level-up-backend@ac7ecd80d62bf731a50a0a0f03fe6b37ec86ef03", v3.22.0-m1), vendored 2026-09-20

info.version at this pin: 3.23.0-m1

Operation census at this pin, counted by parsing `paths` with a YAML parser (never
`grep -c "x-stability: …"` — header and description prose inflate both counts):
**33 stable · 16 draft · 49 total**. Of the 33 stable, 3 are `x-consumers: [web]` and are
forbidden to the app, leaving **30 stable operations the app may build against**.
The previous pin (768e67d) was **33 stable · 14 draft · 47 total**.

## Delta from 3.22.0-m1 — one mobile-visible commit (2026-09-24 re-vendor)

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
most recent probe is 2026-09-04 against backend `78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1` (built
2026-09-03T15:38:17Z), recorded in `.ai/audits/current/smoke-staging-2026-09-04.md`: 13 of the
then-21 stable operations decode, `PATCH /me` answers 405 and `GET /me/entitlements` 404. Those are
facts about a backend build that has since been replaced at least nine times, so they should not be
quoted as current. **Every operation this delta unblocks is UNOBSERVED**, and the smoke harness
itself (`tool/smoke/real_api_smoke_test.dart`) still walks the 21-operation set as it stood on
2026-08-23 — it is stale against the *previous* pin, never mind this one.

For the Mistakes pair, re-probing cannot help: `seif_fight.md` **S44** — the only staging test
account (`+2010000000001`, school-track) has an empty catalog, so it can never hold a graded wrong
answer and both operations will answer empty regardless of whether they are deployed.

## Rules

The source repo also carries `openapi-admin.yaml`, `error-codes-admin.md` and
`contract-changelog-admin.md` — the admin SPA's contract (adr-050). They are deliberately NOT
vendored: the app has never consumed them and they are not the mobile partner's surface.
`openapi-admin.yaml` and `contract-changelog-admin.md` did move in this delta; that is Badawy's
document, not ours.

Do NOT edit these files here — they are Seif's owned artifact. When Seif publishes a
new version, re-copy from the source repo and bump the commit above. Build ONLY against
paths marked `x-stability: stable` **and not marked `x-consumers: [web]`**.
