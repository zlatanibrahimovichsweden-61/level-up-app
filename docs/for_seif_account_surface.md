# The Account surface is designed but almost entirely unbuildable

**From:** Flutter partner · **Date:** 2026-08-06 · **Affects:** milestone-1 scope, contract v1.2
**Contract read against:** `ee2ed8f` (v1.1.0-m1)

We're starting the Account tab. Before we do, you should know what we found, because the shape of it
changes what milestone 1 can honestly ship.

**The Account cluster has eight designed screens and one usable endpoint.**

`PATCH /me` is the last unconsumed stable path in the whole contract — after this day we're at
**21/21 stable, 100%**. Everything else the Account screens ask for is either `draft` or absent.
Of the eight menu rows on the Profile screen, **one** leads somewhere we can fully build.

We are shipping the rest as visibly disabled controls rather than hiding them, so the gap is
visible on a device instead of buried in a backlog. This document is the list.

Sections are ordered by how much they block. Each names the Figma frame so you can see what the
student is being promised.

---

## 1. Edit Profile lets the student edit six fields you don't accept

**Frame:** `Edit Profile` (`180:3989`) and its two variants, School Student Flow.

The screen renders, in order: avatar · Full Name · E-Mail · **Phone Number** · **Parent's Number** ·
**City** · **School Name** · **Education System** · **Grade**.

`PATCH /me` accepts five things: `name`, `email`, `avatarId`, `leaderboardVisible`, `scoreHidden`.

So six of the drawn fields are immutable after registration. We're rendering them read-only.

**What we need to know:**

- Is post-registration editing of geography and academic data intended at all? If yes, does
  `PATCH /me` grow, or does a separate endpoint appear?
- **Phone specifically.** It's the identity anchor under adr-019 phone-verify-first. If a student
  can change it, that's an OTP flow, not a form field — closer to the `/auth/recovery/*` shape than
  to `PATCH /me`. We assume it stays immutable; confirm.
- Same question for a **free-text city** (adr-028 §1). A student who typed their city because it
  wasn't coded has no way to upgrade to a coded one later, even if you add the row next month.

## 2. Two numbers on the Profile screen have no source at all

**Frame:** `Profile` (`166:4416`).

**"Solved Questions — 300."** There is no lifetime answered-questions counter anywhere in the
contract. `SubjectTree` has per-node `answered`/`total`, but that is per subject and summing it
client-side would be both wrong and expensive. We're omitting the counter.

**"Rank — HERO."** A rank *tier name*. The contract has `level` (1–12) and `badges` (an integer
counter of post-level-12 milestones). Neither is a tier string. `GET /leaderboard/me` might
plausibly carry one, but it's `draft` and its schema doesn't have it either. We're omitting the card.

**What we need:** are these two real product concepts, or design placeholders? If real, both belong
on `GET /me` — they're profile facts, not leaderboard facts, and a student should see them offline
from cache.

Related, and worth settling at the same time: **`level` still has no threshold table** (our S3). We
render level 8 with no way to say what reaches level 9. `kMaxLevel = 12` is hardcoded on our side
from a Figma component's variant list, which is not a source of truth.

## 3. Notification Preferences — four toggles, no storage

**Frame:** `Setting` (`176:1840`).

Announcements · Promotions · Support · System. Nothing in the contract persists these. `PUT
/me/fcm-token` is a device token and is `draft` besides.

We're rendering all four disabled. If notification preferences are milestone-1, they need somewhere
to live — most naturally as an object on `PATCH /me` alongside the privacy toggles, since they're
the same kind of per-student setting.

This connects to something already open: the Home bell's unread dot has been gated behind a
permanently-false flag since Day 7b, pending any notifications endpoint. There is also a
`Notifications` frame in this cluster we haven't built.

## 4. "Go to Uni" — track switching, which the contract's shape forbids

**Frame:** `Go to Uni` (`180:4301`) — a dialog reading *"Are you sure you want to convert to Uni
Track?"* with a Confirm button.

Track is fixed at registration by a discriminated body, and adr-010 gives the two tracks different
*shapes* — university registration has no country field. There's no endpoint, and `PATCH /me`
can't express it.

The harder question is **adr-003 dual pools**. Points are per-track. If a student converts:

- Does the school pool survive, transfer, or reset?
- `points.total` is your sum — does it keep counting the abandoned pool?
- Does their level recompute?

This is a data-model decision, not a UI one, which is why we're raising it rather than guessing.
Confirm renders disabled until you answer.

## 5. One switch is drawn where the contract has two booleans

**Frame:** `Setting` (`176:1840`) — a single **"Show Rank"** toggle.

`PATCH /me` has `leaderboardVisible` (am I listed at all) and `scoreHidden` (listed, score
suppressed). Under adr-023 they default differently — `true` and `false`. They're independent
questions and one switch can't express both.

We're rendering **both** toggles rather than silently choosing a policy. Flagging it because the
designer should know the frame is one control short.

## 6. Rows we're building disabled, and why

| Profile row | Blocker |
|---|---|
| Favorite questions | all three favourite endpoints `draft` (our S11) |
| your progress | no endpoint, and a `your progress` frame exists |
| Refer a Friend | no endpoint — see below |
| Customer Support | no endpoint |
| Subscription | `/checkout/sessions` `draft`; Paymob return deep link still undefined (our S8) |
| Privacy & policy | no endpoint needed — **but nobody has supplied the text** |
| Terms & Conditions | same |

The last two aren't your problem technically, but they're a milestone-1 blocker and nobody owns
them yet.

## 7. Referral is a feature, not the stray field we thought

We flagged months ago that Sign Up_1 collects a referral/invitation code and has nowhere to send it.
We assumed it was a leftover. It isn't — there's a **`Refer a Friend`** screen in the Account
cluster, so referral is a designed product surface with an entry point, a sharing flow and an
implied reward.

Right now the code a student types at signup is discarded client-side. Either it becomes real —
which needs a field on `/auth/register`, an attribution model and presumably a reward — or the
field comes out of Sign Up_1 and the screen comes out of the design. Both are fine; the current
state isn't, because we're asking students for something we throw away.

## 8. Two whole tabs are designed with nothing behind them

Not Day 8's problem, but it changes what milestone 1 looks like on a device, so you should have it
in one place.

**Message tab** — `Messages` ×2, `Customer support chat`, `Create Ticket`, `Customer Support` ×3.
A complete support-ticketing product. **No endpoint exists in the contract. Not draft — absent.**

**Leaderboard tab** — a finished frame with podium, rank rows and NOW/Last Month tabs. Both
`GET /leaderboard` and `GET /leaderboard/me` are `draft`.

After Day 8 we'll have a five-tab nav bar with two tabs that are still empty placeholders, and we
can't fix either from our side. Leaderboard looks like the cheaper of the two to promote — the
schema is already written; it just needs to leave `draft`. Is that plausible for milestone 1? If
not, we should talk about whether five tabs is the right shape to ship.

---

## What would help most, in order

1. **Confirm the immutables** — phone, parent phone, city, school, education system, grade stay
   fixed after registration. That's the single answer that unblocks Edit Profile.
2. **Decide Solved Questions and Rank** — real fields on `GET /me`, or removed from the design.
3. **Promote `/leaderboard` out of draft**, or tell us it isn't milestone 1.
4. **Answer the Go to Uni points question** — even "not milestone 1" is an answer we can build to.
5. **Referral: in or out.**

Happy to go through it live if that's faster. Everything above is recorded on our side in
`seif_fight.md` (S5, S20, S24–S31) with the frame references, so nothing here depends on this
document surviving.
