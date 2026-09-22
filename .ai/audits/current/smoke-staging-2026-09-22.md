# Staging smoke — 2026-09-22

Run to discharge step 2 of the D-008 un-gating: **verify `GET /leaderboard` against a real
server.** Companion to `docs/D008_LEADERBOARD_AUDIT.md` §4. Previous run: `smoke-staging-2026-09-04.md`.

| | |
| --- | --- |
| Harness | `tool/smoke/real_api_smoke_test.dart` — outside `test/`, never run by `validate.ps1` |
| Command | `flutter test tool/smoke/real_api_smoke_test.dart --dart-define=SMOKE_PHONE=+2010000000001` |
| Base URL | `https://level-up-backend-staging.up.railway.app/api/v1` |
| Backend | commit `0f97f289852b76a2762865169fb5efba909e7c1e`, Staging, built **2026-09-22T07:54:38Z** |
| App tree | branch `merged`, HEAD `e683e8d` + the un-gating change |
| Result | **exit 0** — every arm decoded |
| Level | **API** — a real request through `AppConfig → DioClient → interceptors → repository → freezed`. Only `SecureStorage` is stubbed. **Not DEVICE, not CI.** |

## The leaderboard arm (new in this run)

```
--- GET /leaderboard ---
  scopes for this account: [system, governorate]
  decode: OK — CursorPage<LeaderboardEntry>
  scope: system
  rows: 1
  hasMore: false
  nextCursor: null
  ranks ascending: true
  isMe rows: 1
```

The scope was derived by `LeaderboardScope.scopesFor(me)` — the screen's own rule — not hand-picked,
so the EG-school fork (`[system, governorate]`) is exercised rather than assumed. The arm is placed
**before** the catalog block on purpose: every catalog branch can early-return, and behind it the
board would never have run.

`GET /leaderboard/me` is deliberately not called. D-008's product decision stands and
`openapi.yaml:2050` forbids a synthetic self-rank row.

**Route-existence probes**, unauthenticated, distinguishing "deployed" from "absent" the way the
earlier reports did:

| Path | Status | Reading |
| --- | --- | --- |
| `GET /leaderboard?scope=system` | **401** `authentication_required` | deployed |
| `GET /leaderboard/me` | **401** `authentication_required` | deployed |
| `GET /health/version` (unauth) | 404 `not_found` | what an absent route looks like |

**What this does NOT cover.** One account, one scope, a **one-row** board — so pagination, the
short-page path, the 200-row bound, `governorate`, both university scopes, privacy filtering and
`403 account_pending_deletion` were not exercised against a server and stay SOURCE + BUILD only. A
one-row board also cannot distinguish a correct `isMe` from a lucky one.

## Staging has moved since 2026-09-04 — several `seif_fight.md` S37 entries look stale

Not adopted here; flagged for whoever owns S37.

| Operation | 2026-09-04 | 2026-09-22 |
| --- | --- | --- |
| `PATCH /me` | **405** `internal_error` | **200** — roundtrip decoded, name preserved |
| `GET /me/entitlements` | **404** `not_found` | **200** with `0` items |
| `GET /catalog/subjects` | `200` with `[]` | `200` with **1** subject |
| `GET /catalog/subjects/{id}/tree` | not reachable | decoded — `SchoolSubjectTree`, 1 lesson |
| `POST /quizzes` → answers → finish | not reachable | **the full quiz loop now runs** |

## Incidental finding — `429` verified by accident

Running the harness back-to-back inside one rate-limit window returned `429 rate_limited` from
staging across the `/reference/*` arms, and it decoded into the app's `RateLimitedException` with
the code intact. Unplanned, but it is the only live confirmation the project has of that branch —
and the leaderboard's own `429` handling (retry withheld, no auto-retry) is built on the same
exception type.

**Harness note:** the run is not idempotent inside one window. Re-runs inside ~60s hit
`otp_throttled` on `/auth/otp/request` and `429` on the reference arms. Wait out the window.
