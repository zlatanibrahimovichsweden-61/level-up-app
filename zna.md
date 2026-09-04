# zna.md — two messages to send, 2026-09-04

Written after adopting contract **v3.0.0-m1** (pin `184d6ec`) in the app. Copy each block as
is; the details are all sourced from `contract/contract-changelog.md`, `docs/seif_fight.md`,
`docs/DESIGN_ISSUES.md` and `docs/DECISIONS.md` (D-006, D-007).

---

## Message for Seif

**Subject: Contract 3.0.0-m1 adopted in the app — what we changed, and four things we need**

Hi Seif,

We re-pinned the mobile contract to `184d6ec` (3.0.0-m1) today and adopted it fully. Summary of
what changed on our side, then the asks.

**What we did**

1. **`QuizSummary` — `totalPoints` and `level` removed (adr-102).** Our model no longer has the
   two fields, and the result screen no longer draws a level number or a points total after a
   quiz; it shows `pointsAwarded` only. `leveledUp` and `newBadge` are now read as frozen events
   of that attempt and are never recomputed from two `GET /me` reads. We also kept the client
   tolerant: a `finish` body that still carries the two keys parses unchanged, so an
   un-upgraded environment cannot break the app.
2. **Replay `pointsDelta: 0` (adr-102 D2).** No change on our side — our mock has returned `0`
   on a replayed answer since Day 7. Your S18 question is closed.
3. **Purchase-silent (adr-049 §3).** The "Upgrade" button, the benefits list, the
   `/subscription` and `/subscription/return` routes, the Profile "Subscription" row and every
   Paymob reference are gone from the app. The two 403 sheets (`weekly_question_limit_reached`,
   `subscription_required`) now explain the state and offer "Not now", nothing else. S8 (Paymob
   deep link) is withdrawn.
4. **Catalog un-gated (adr-091).** Nothing to change in code; we deleted the "empty catalog ⇒
   probably unsubscribed" assumption from our heads. `[]` still means "no released subjects yet".
5. **S3 is closed** — `StudentProfile.level`'s description ("thresholds every 500 points; static,
   not configurable") was the static threshold we asked for. We had missed it.

**What we need from you**

1. **Which backend build is on staging?** `/health/version` returns `78c6e5dc…` (built
   2026-09-03 15:38Z). The 3.0.0-m1 mirror names `4a8e7cf…`. We cannot see the backend repo, so
   please confirm `78c6e5d` includes adr-102 — i.e. that `POST /quizzes/{id}/finish` on staging
   already returns the new shape.
2. **Two stable routes still missing on staging** (S37, unchanged across `fbab748`, `0b53cdc`,
   `78c6e5d`): `PATCH /me` answers **405** with `code: internal_error`, and
   `GET /me/entitlements` answers **404** `not_found`. `GET /catalog/subjects` is now deployed
   (401 unauthenticated, `200 []` for the test account) — thank you.
3. **Seed a released term for `+2010000000001`** so `POST /quizzes` has questions to draw. That
   is the only thing between us and running the whole quiz loop (create → answers → finish →
   explanation) against staging, and it would be our first look at the 3.0.0-m1 `finish` body on
   the wire. Still owed from the checklist as well: a ~60 s access token (401 → refresh → retry)
   and a forced `500` + `429`.
4. **Account deletion has no endpoint (new — S38).** Google Play's account-deletion requirement
   and Apple's guideline 5.1.1(v) both require an in-app path to delete the account. We can draw
   the screen; there is nothing to call. We need `DELETE /me` (or a deletion-request operation
   with a grace period), marked `stable` before the store-submission wave, plus the semantics for
   a minor's data: immediate or grace period, what happens to leaderboard rows, quiz history and
   the parent phone, and whether the same phone may register again.

One more thing: the contract repo answered 404 for part of today and we had to work from
hand-supplied files until it came back. If it is going to be private, we need read access on
our account; if it was accidental, no action.

Thanks,
Yousef

---

## Message for the Designer

**Subject: Three screens changed by the backend contract — what we removed, and what we need drawn**

Hi,

The API contract moved to 3.0.0-m1 this week and it changes three things on screens you own.
We have already made the code match the contract (the contract wins over the frames by our
working rule), so this is a request to bring the frames back in line and to give us approved
copy where we had to write our own.

**1. Result screen — `159:1964` (LTR) and `549:20247` (RTL)**

The API no longer returns the student's level or points total when a quiz is finished (it only
reports what that quiz did: points awarded, whether it crossed a level, whether it earned a
badge). So the *"Level Progress — Level 3 · 1255 points"* line inside the **Rewards Earned**
card is **removed**. The card now shows the points awarded and nothing else.

Seif's changelog says the live frames draw **no absolute level number and no points total**,
and that the level element is a **partial-fill meter** (`(points.total mod 500) / 500`). We
could not open the frames to confirm. Please:

- confirm the meter exists on `159:1964` / `549:20247`, and if so give us its geometry —
  height, fill and track colours, corner radius, and whether any caption (level number, "next
  level") sits beside it. The data to draw it is available, so it is a small change once
  specified;
- confirm `549:20247` is the Arabic twin of `159:1964` — we had not catalogued it, and if other
  quiz frames now have RTL twins we would like the list;
- (still open from before) there is no level-up or new-badge state on this screen even though
  the API announces both on every finish — see DESIGN_ISSUES #32.

**2. Limit sheet — `199:2335` (school), `225:6634` / `225:7001` (university)**

Product rule from the contract (adr-049 §3): **the mobile app is purchase-silent.** It never
shows a paywall, a price, an upgrade link, or where to buy — every purchase happens on the
website. The three frames draw an **"Upgrade To Premium"** button and a **benefits list**
(unlimited questions, AI explanations, priority support, no ads). Both are now forbidden by
product rule, and both are **removed** from the app. The sheet is now: title, one line of body,
"Not now".

The body copy we shipped is ours and provisional — please replace it with approved copy:

| State | EN (shipped) | AR (shipped) |
| --- | --- | --- |
| `weekly_question_limit_reached` — title "Free Usage Reached" | You've used all your questions for this week. | استخدمت كل أسئلتك لهذا الأسبوع. |
| `subscription_required` — title "Subscription Required" | This lesson needs an active subscription. | هذا الدرس يحتاج إلى اشتراك فعّال. |

Constraints on the replacement, all from the contract or the glossary:

- no "upgrade", "subscribe", a price, or any mention of where to buy;
- not "premium", "plan" or "pro" — the glossary never calls `base_subscription` any of these;
- **weekly**, not daily — the cap is 50 questions per week (the frames say "Daily Limit
  Reached"), and the "QUESTIONS 50/50" bar has no data behind it and is not built;
- the reset may be described as "next week" but **not** as a weekday — the exact reset moment
  is not published;
- a ruling on the title *"Subscription Required" / "الاشتراك مطلوب"*: it names the entitlement
  without pointing anywhere, which we read as allowed, but it is your and product's call.

Please redraw the three frames without the CTA and the benefits list.

**3. Profile hub**

The disabled **"Subscription"** row is **gone**, not dimmed — same rule. The hub now draws nine
rows instead of ten. Please update the frame (and note the "Favourites" and "your progress" rows
are still disabled for API reasons, unchanged).

Everything above is logged as DESIGN_ISSUES #50 and #51, with the decisions in D-006 and D-007
if you want the reasoning.

Thanks,
Yousef
