# The Account surface is designed but almost entirely unbuildable

**From:** Flutter partner · **Date:** 2026-08-06 · **Affects:** milestone-1 scope, contract v1.2
**Contract read against:** `ee2ed8f` (v1.1.0-m1)

> **Amended 2026-08-07, after implementation.** The original went out before we started building,
> so you would not be waiting on us. Building it turned up two things the first version did not
> know, and made one of its claims too soft. **Sections 9 and 10 are new**, section 11 is a small
> loose end, and **section 1 has been corrected** — Parent's Number is not merely immutable, it is
> write-only, which is a different and worse problem. Everything else is as sent.

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

> **Corrected 2026-08-07.** Five of them. **Parent's Number is not immutable — it is write-only.**
> It's required at registration and absent from `StudentProfile` entirely, so there is no value to
> render read-only and we did not build the row at all. That deserves its own section rather than a
> clause here: **see section 9**, which is now the item we'd most like an answer to.

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

## 9. Parent's Number is write-only — we make students give it and can never show it back

**New, 2026-08-07.** Found while building the Edit Profile form. This is the one we'd most like you
to look at.

`parentPhone` is **required** on both registration bodies — `openapi.yaml:1280` for school,
`:1305` for university. It is **absent from `StudentProfile`**. So we compel a student to hand over
a parent's phone number to create an account, and then there is no endpoint that will ever tell
them what they gave us. Not read-only, not masked, not at all.

Every other locked field on Edit Profile works fine: phone, city, school, stage and education
system all come back on `GET /me`, and we render them with a padlock. Parent's Number is the one
row in the frame we couldn't build, so we didn't — the student has no way to check whether the
number they typed months ago has a digit wrong in it. For a product whose users are minors and
whose recovery path runs through that number, that's the wrong shape.

And you clearly have the value. `POST /auth/recovery/start` returns **`parentPhoneMasked`**
(`openapi.yaml:272`) — recovery reads it back to prove identity. So this is a missing field on a
response, not missing data.

**What we'd like:** the same masked form on `GET /me`. Masked rather than raw is almost certainly
right here — it's enough for "yes, that's my mum's number", and it means a stolen token can't be
used to harvest guardian contact details. If you'd rather it stay invisible, tell us and we'll ask
the designer to take the row off the frame instead of leaving it drawn.

## 10. `GET /me` gives us codes where the frame shows names

**New, 2026-08-07.** Same pass as section 9.

Most of the profile is bilingual already: governorate, city, school, university and faculty are all
`NamedRef`, with `nameAr` and `nameEn`. Two fields aren't. `stage` and `educationSystem` come back
as bare wire codes, so rendered honestly a student sees **`nationalLanguages`** and **`secondary2`**
where the frame draws "American" and "Grade 11".

We render the codes. That looks bad, and it is deliberate — here's why we didn't just translate
them on our side, since that's the obvious fix:

- `EducationSystem` is documented **extensible** — *"clients must tolerate unknown values"*. So
  there's no closed set to map against. Any table we hardcode goes stale the day you add a system,
  and it fails precisely for the students on the newest option, who then see the raw code anyway.
- `stage` does have translated copy in our registration wizard, but translating one row and not the
  row directly beneath it is worse than translating neither.
- Calling `/reference/education-systems` just to label a **read-only** row is a network round-trip
  for cosmetics, on a screen that otherwise makes no requests at all.

**What we'd like:** send the display names you already have — either make `stage` and
`educationSystem` `NamedRef`-shaped like everything else on the object, or add a resolved-names
block to `GET /me`. The first is more consistent with the rest of the schema and needs no new path.

## 11. One loose end: there's a `Friends` screen with no way into it

**New, 2026-08-07.** Small, and more the designer's than yours, but it belongs with the rest.

There's a `Friends` frame in the Account cluster. It has no endpoint — no list, no requests, no
social graph anywhere in the contract. That's expected by now. The odd part is that **nothing in
the app navigates to it**: the Profile hub draws ten rows and none of them is Friends. We've built
it as a disabled shell and given it a route, but no student can reach it, and we didn't invent an
eleventh row to give it a door.

Worth flagging to you rather than only to the designer because the concept is already in your
schema's prose — `scoreHidden`'s description at `:1094` says it "affects profiles/friends". So
somebody has thought about friends existing. If they're milestone 1 we'll need to know it; if
they're not, the frame should come out.

---

## What would help most, in order

**Re-ranked 2026-08-07** — the first item is new, and the old first item is now item 2 because we
built to the assumption and it held.

1. **Put `parentPhoneMasked` on `GET /me`** (section 9). Cheapest thing on this list, and it closes
   the one gap where we take something from a student and can't give it back. You already return
   the field from `/auth/recovery/start`.
2. **Confirm the immutables** — phone, city, school, education system, grade stay fixed after
   registration. We've shipped Edit Profile on that assumption; confirming it just retires the
   question.
3. **Decide Solved Questions and Rank** — real fields on `GET /me`, or removed from the design.
4. **Send display names, not codes** (section 10). Students are currently reading
   `nationalLanguages` off their own profile.
5. **Promote `/leaderboard` out of draft**, or tell us it isn't milestone 1.
6. **Answer the Go to Uni points question** — even "not milestone 1" is an answer we can build to.
7. **Referral: in or out.**

Happy to go through it live if that's faster. Everything above is recorded on our side in
`seif_fight.md` (S5, S20, S24–S36) with the frame references, so nothing here depends on this
document surviving.
