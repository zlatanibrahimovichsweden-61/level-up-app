# D-008 · Leaderboard un-gating audit

**Date:** 2026-09-22 · **Contract pin:** `768e67d` (3.22.0-m1) · **Tree:** branch `merged`, HEAD `e683e8d`

This is the middle step D-008 has been waiting on since 2026-09-12: *re-vendor → **audit the board
against the behavioural changes** → un-gate.* The first step was done in `f836213` and again in
`aeb22fc`; this file is the second. It exists so that un-gating is a recorded decision rather than
a revert.

**Scope.** `lib/features/leaderboard/` (11 files) against the six behavioural changes D-008 names,
plus the cross-cutting `403 account_pending_deletion`. Nothing was redesigned or rebuilt. The
board was read as written and judged against the contract; where it is already correct, that is
recorded and the code is left alone.

**Verification levels used.** SOURCE = read at HEAD · BUILD = `flutter test` · **API** = a real
request to the staging backend through the app's own repository and decoders · DEVICE = run on
hardware. Nothing below is rounded up.

---

## 1. Why this audit was needed at all

D-008's *original* reason expired on 2026-09-12: `getLeaderboard` and `getMyRank` were `draft` at
the old pin `184d6ec`, and both have been `x-stability: stable` since **3.5.0-m1 (2026-09-05)** —
`openapi.yaml:2007` and `:2112` at the current pin. Stability is not the gate and has not been
since before the gate was written.

What remained is the Correction of 2026-09-10, point 4: **un-gating is not a revert.** The board
entered the tree on 2026-09-08 and at least six behavioural changes bear on it. Two of them fail
*quietly, in front of a student*, rather than loudly in a build — which is precisely the class of
defect a version bump cannot communicate.

---

## 2. The six behavioural changes, audited

| # | Change | Contract | Requirement | Code site | Verdict |
|---|---|---|---|---|---|
| 1 | **Top-200 bound** | 3.4.0-m1 · `openapi.yaml:2028` · changelog:229 | *"DO NOT PAGE LOOKING FOR `isMe`"* — a caller below 200 is on no page, so the loop never terminates | `leaderboard_notifier.dart:75-79` (rule 2), `:44-52` (`me` reads off arrived pages only) | ✅ **PASS** |
| 2 | **Signed, expiring cursor** | 3.1.0-m1 (unversioned amendment) · changelog:263-271 | Echo verbatim · never decode/construct · do not persist · rejection ⇒ page one | `leaderboard_repository.dart:52-56` (echoed unchanged), `leaderboard_notifier.dart:168-173` (`ValidationException` on field `cursor` ⇒ `refresh()`), `:186-189` (cursor dropped on reload) | ✅ **PASS** |
| 3 | **`scoreHidden` exclusion** | 3.1.0-m1 · `openapi.yaml:2016-2021` · changelog:274-280 | Row is **omitted, not blanked**; `points` stays required; ranks close with no gap; **do not build a "score hidden" row state** | `leaderboard_models.dart:56-80` — all six fields required, `points` non-nullable; no hidden-score branch anywhere in `widgets/` | ✅ **PASS** |
| 4 | **`403 score_hidden_leaderboard_unavailable` on self-rank** | 3.2.0-m1 · `openapi.yaml:2175` | Render the board without a self-rank element | N/A — `getMyRank` is never called (`leaderboard_repository.dart:13-16`) | ✅ **N/A by design** |
| 5 | **Short pages while `hasMore` is `true`** | 3.7.0-m1 · `openapi.yaml:2038-2043` · changelog:198 | *"KEEP PAGING UNTIL `hasMore` IS `false`"* — never stop on a short page; never call a short page "empty" | `leaderboard_notifier.dart:20-22` (`hasMore` straight from the server, never inferred), `:34-36` (`isEmpty => items.isEmpty && !hasMore`), `:110-124` (walks short pages), `:152-155` (append tolerates short pages) | ✅ **PASS** — see finding F-1 |
| 6 | **`404 not_ranked`** | 3.9.0-m1 · `openapi.yaml:2178` | Route into the same no-self-rank display as the `403`; do not retry, do not treat as a missing endpoint | N/A — `getMyRank` is never called | ✅ **N/A by design** |

### Cross-cutting, audited with them

| # | Change | Contract | Requirement | Code site | Verdict |
|---|---|---|---|---|---|
| 7 | **`403 account_pending_deletion`** | 3.3.0-m1, declared 3.5.1-m1 · `openapi.yaml:2101` | Do not log out · do not retry · route to the cancel screen | `leaderboard_screen.dart:224` (retry withheld), `:256` (own copy, not `genericError`); predicate is `isAccountPendingDeletion` in the network layer | ⚠️ **PARTIAL — and correctly so.** Two of three rules hold. The third cannot: the cancel screen does not exist. Landed in `07f3ced`; the board was the first surface to handle this code |
| 8 | **`429 rate_limited` + `Retry-After`** | 3.2.0-m1 · `openapi.yaml:2104` | Honour `Retry-After`; do not retry in a tight loop | `leaderboard_screen.dart:222-225` withholds the retry button entirely; `leaderboardProvider` sets `retry: _noRetry` so Riverpod 3 schedules no automatic retry | ✅ **PASS** (stricter than required) |

### Two rules the board follows that are worth naming

- **`limit` is validated, not clamped** (3.7.0-m1, `openapi.yaml:2044-2047`). The repository
  asserts `1…100` rather than clamping (`leaderboard_repository.dart:26-28, 45-49`) — a bad page
  size is a caller bug, and clamping would hide it. `_pageSize = 20` is in range.
- **One board, two visual treatments** (3.5.2-m1, changelog:204). `_BoardList` renders one ordered
  list: `items.take(3)` to the podium, `items.skip(3)` as rows
  (`leaderboard_screen.dart:313-315`). No second ranking, no synthetic self-rank row.

---

## 3. Findings

### F-1 · A doc comment misdescribes the short-page give-up, and that state has no UI

**Severity: low** (reachable only on a server fault) · **Not fixed in this change** — recorded for
the owner, because fixing it changes behaviour the project deliberately chose and tested.

`LeaderboardNotifier.build()` walks short pages up to `_maxShortPageHops = 10`. Its comment at
`leaderboard_notifier.dart:101-103` says stopping *"lets the UI show an empty state instead of
spinning forever."* **It does not.** On exhaustion the walk returns `items: []` with
`hasMore: true`, and `isEmpty` is defined as `items.isEmpty && !hasMore` — so the state is
`ScreenLoaded`, not `ScreenEmpty`.

The behaviour itself is deliberate and covered:
`leaderboard_notifier_test.dart:69` (*"the walk gives up rather than looping on a faulty server"*)
asserts `hasMore` stays `true` and `isEmpty` stays `false`, reasoning that *"the server never said
the board had ended, and claiming it did would be inventing an answer the server withheld."* That
is the right call and consistent with the project's **never invent** rule. **The comment is what
is wrong, not the code.**

The consequence the comment hides: `_BoardList` renders `Podium(top: [])` → `SizedBox.shrink()`
(`podium.dart:41`), no rows, and a footer that is `SizedBox.shrink()` because
`!hasMore && items.isNotEmpty` is false (`leaderboard_screen.dart:346`). The student sees a
**blank scroll area with no message and no recovery** — and `_onScroll` cannot fire, because there
is nothing to scroll. No crash: `take`/`skip` are safe on an empty list and the podium guards
`isEmpty`.

**Minimum fix, when the owner wants it** — a third branch in `_Board`'s state mapping for
`items.isEmpty && hasMore`, rendering the existing `_Message` with a retry, not the empty copy.
That keeps `hasMore` honest and still gives the student a way out. It needs one ARB key pair in
both languages, so it is a copy decision, not only an engineering one.

### F-2 · Known gaps carried forward unchanged

Not defects; recorded so un-gating does not imply they were closed.

| Gap | Status |
|---|---|
| **Share button is visible and inert** | No sharing surface exists in the contract, and a board carries minors' names and scores. Stays disabled with a `Semantics(enabled: false)` label. `leaderboard_screen.dart:143-160` |
| **No realtime** | `contract/realtime.md:9` lists the `leaderboard` hub as "not drafted" |
| **No `level` on the podium** | Figma writes "level 7"; the contract carries no `level` on this endpoint. Deliberately not invented — podium renders `points` only. `leaderboard_models.dart:62-65` |
| **Title is 18pt against Figma's 22pt** | No 22pt token exists and adding one would raise the frozen `fontSize` ratchet. Logged at `leaderboard_screen.dart:125-130` |
| **`403 account_pending_deletion` cannot route to a cancel screen** | That screen does not exist anywhere in the app. Copy + withheld retry are the honest half |

---

## 4. Backend verification — API level, against real staging

Run 2026-09-22 through `tool/smoke/real_api_smoke_test.dart`, which drives the **real** seam:
`AppConfig → DioClient → interceptors → LeaderboardRepository → freezed decoders`. Only
`SecureStorage` is stubbed (it is a platform channel absent under `flutter test`).

```
BASE URL = https://level-up-backend-staging.up.railway.app/api/v1
health/version  status: 200
  commit: 0f97f289852b76a2762865169fb5efba909e7c1e
  environment: Staging   builtAtUtc: 2026-09-22T07:54:38Z

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

**What this proves (API):** the route is deployed, authenticates, answers `200`, and its body
decodes through the app's own `CursorPage<LeaderboardEntry>` with every required field present.
`scopesFor` produced `[system, governorate]` for this EG school account, exactly as the track rule
specifies. **The board has now met a real server** — the sentence `WAVE_STATUS.md:179` has carried
since 2026-09-10 is discharged.

Unauthenticated route probes, same session, distinguishing "deployed" from "absent" the way the
earlier smoke reports did:

| Path | Status | Reading |
| --- | --- | --- |
| `GET /leaderboard?scope=system` | **401** `authentication_required` | route **deployed** |
| `GET /leaderboard/me` | **401** `authentication_required` | route **deployed** (still not consumed, by decision) |
| `GET /health/version` (no auth) | 404 `not_found` | what an absent route looks like |

**What this does NOT prove.** One account, one scope, a **one-row** board. Not exercised against a
real server: pagination (`hasMore` was `false`, so no cursor was ever echoed), the short-page
path, the 200-row bound, `governorate` scope, the university scopes, `scoreHidden`/invisible
filtering, and `403 account_pending_deletion`. Those remain SOURCE + BUILD only. A one-row board
is also the one shape that cannot distinguish a correct `isMe` from a lucky one.

**Incidental, verified in the same session:** re-running the harness back-to-back returned
`429 rate_limited` from staging and decoded into the app's `RateLimitedException` — unplanned, but
it is the only live confirmation the project has of that branch.

**Staging has moved since the 2026-09-04 probe** and several `seif_fight.md` S37 entries look
stale: `PATCH /me` now succeeds (was `405`), `GET /me/entitlements` now returns `200` with `0`
items (was `404`), `GET /catalog/subjects` returns 1 subject, and the full quiz loop now runs. That
is outside this audit's scope and is flagged, not adopted.

---

## 5. Verdict

**The board passes.** All six behavioural changes are honoured — four actively, two by the
standing decision not to call `getMyRank`. The cross-cutting `403` is handled as far as the app
can handle it. The one finding (F-1) is a comment that misdescribes correct, tested code, plus a
missing UI branch on a server-fault-only path; neither blocks un-gating.

The Correction of 2026-09-10's ordered work is therefore complete:

1. ~~Re-vendor the contract~~ — `f836213`, then `aeb22fc` to 3.22.0-m1.
2. ~~Audit the board against the six behavioural changes~~ — **this file.**
3. **Un-gate** — the route, the skipped shell test, and the screen test's mount, together.

D-008's *"What would close this"* also asks for a device pass before the board is called done.
That is **still owed** and is not claimed here: un-gating makes it possible for the first time on
a committed tree.

**Not changed by this audit:** `contract/` (no contract defect was found), `getMyRank` (stays
unconsumed), the `level` field (stays uninvented), sharing and realtime (stay gaps).
