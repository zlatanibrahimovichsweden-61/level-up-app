# Level Up — decision log

> In-repo record of product/scope calls made mid-build, so the reasoning survives the ticket.
> Sits alongside `DESIGN_ISSUES.md` (design ↔ build gaps) and `seif_fight.md` (contract questions
> for Seif). The difference: this file records **what we decided and why**, not what we're waiting on.
>
> One entry per decision. Never delete an entry — supersede it and link forward.

## Format

**D-nnn · <title>** — Feature · Date · Status
**Context** what forced the call · **Options** what was on the table · **Decision** what we chose
· **Consequences** what it costs / unblocks · **Revisit when** the condition that reopens it.

---

## Quiz feature

### D-001 · Quiz screens render `scopeName` only, no subject name
**Feature:** Quiz (Day 7) · **Date:** 2026-07-30 · **Status:** Superseded in part (2026-09-26, see the update at the end) · **Raised by:** Claude Code during Day 7 planning

**Context.** `docs/day7_quiz_brief.md` specified the setup and results screens as
"**subject** — scope name", matching the Figma frames (`135:1622`, `159:1964`), which read
*"Biology / Cell Membrane"*. But subject name is not reachable from the quiz data path: it is not
on `Quiz`, not on `QuizSummary`, not on `QuizSetupArgs`, and not on the `SubjectTree` payload the
Learn stack already holds.

**Verified against the contract.** `subjectName` exists in exactly three places in
`openapi.yaml`, and **all three are on `draft` endpoints**:
- `:986` — `/me/favorites` items (draft)
- `:1473` / `:1479` — `QuizHistoryItem`, from `GET /quizzes` (draft)
- `:1485` / `:1502` — the full review schema, from `GET /quizzes/{quizId}` (draft)

So it is not merely inconvenient to obtain — **no stable endpoint exposes it in this flow at all.**

**Options.**
1. Render `scopeName` only. *(chosen)*
2. Add a `GET /catalog/subjects` fetch and plumb `subjectName` through four Learn-stack screens.
3. Block Day 7 until the contract carries it.

**Decision.** Render **`scopeName` only**. `scopeName` is server copy, already localized
(adr-018), and already arrives in `QuizSetupArgs` from Day 6 — so the screens title themselves with
no extra call.

**Consequences.** Setup and results diverge from the frames by one line of text. Option 2 would
have meant a new fetch plus prop-drilling through Subjects → Tree → Chapters → Lessons/Lectures —
out of scope for this ticket, and it duplicates data the server could simply include.

**Revisit when.** Either `Quiz` / `QuizSummary` gain a `subjectName` field (the clean fix — raise
with Seif; it already exists on two sibling schemas), **or** a separate follow-up ticket takes on
the Learn-stack plumbing. Do not fold that work into a quiz ticket.

**Tracked as** `seif_fight.md` **S19** · **Implemented** — verified in
`quiz_setup_screen.dart` / `quiz_result_screen.dart`: both title from `scopeName` alone, and the
result screen receives it forwarded from the `Quiz` in the route's `extra`.

**Update 2026-09-26 (API→UI Waves 11 and 13, owner rulings).** The "separate follow-up" happened. The Learn stack
reads the subject from the subjects list it already holds (`cachedSubjectName`) and hands it to setup in
`QuizSetupArgs.subjectName` (Wave 11: "Biology" over "Cell Membrane"). Setup passes it on in `QuizScreenArgs`, and
the quiz passes it to `QuizResultArgs` (Wave 13: "Biology — Cell Structure"). Display only: `POST /quizzes` never
sees it, and `Quiz` / `QuizSummary` gain no field the contract lacks. On a cold deep link to setup there is no
subject and both screens show the scope alone. S19's ask (the field on the schemas) still stands.

---

### D-002 · `newBadge` and `leveledUp` are parsed flag-only — no celebration UI
**Feature:** Quiz (Day 7) · **Date:** 2026-07-30 · **Status:** Accepted · **Raised by:** Claude Code during Day 7 planning

**Context.** The brief listed `QuizSummary` as having 8 required fields. The contract requires
**10**. The brief's author (this assistant) read the schema truncated at `leveledUp` and missed the
final two. Claude Code caught the mismatch during planning.

**The actual required set** (`openapi.yaml`, `QuizSummary`):
```
[quizId, score, totalQuestions, answeredCount, pointsAwarded, totalPoints,
 level, leveledUp, newBadge, questions]
```

**Decision.** Parse **`newBadge`** and hold it as a flag, exactly like the existing `leveledUp`.
**No celebration UI in this ticket** for either.

**Consequences.** The model is contract-complete, so adding a celebration later is a widget change
with no model, JSON or test churn. Two server signals currently go unrendered — acceptable, and
tracked below.

**Revisit when.** The design provides level-up / new-badge celebration states. If the frames have
none, that is a design gap worth raising: the contract goes to the trouble of telling us on every
single quiz finish, so something should acknowledge it.

**Second finding, from the same miss — worth more than the decision itself.**
The tenth field, **`questions[]`**, is also required: recap rows of
`{ questionId, answered, correct? }` (`correct: null` when unanswered), described in the contract
as *"Recap rows (full review at `GET /quizzes/{id}`)"*. This partly **reverses** the brief's
CONFLICT 3, which claimed review was wholly blocked by a draft endpoint:

- **Available now, on the stable `finish` call:** which questions were right, wrong or skipped.
- **Still needs draft `GET /quizzes/{quizId}`:** question *text* and the *correct answer*.

**As built:** `questions[]` is parsed onto `QuizSummary` and available, but the result screen
derives its counts from the scalars (`wrong = answeredCount − score`,
`skipped = totalQuestions − answeredCount`) — simpler, and equivalent. `questions[]` is the raw
material for a per-question recap strip whenever the design wants one. The full "Review Questions"
button stays **disabled**, since it implies the text-level review we still cannot serve.

**Implemented** — verified in `quiz_summary.dart` (all ten required fields) and
`quiz_result_screen.dart` (Review `onPressed: null`, Skipped rendered when non-zero).

**Process note.** Both D-001 and D-002 came from Claude Code checking the brief against the
contract rather than trusting it. That check should stay in the Day-N prompt: *"read the relevant
contract section directly — do not work from the brief's summary of it."*

---

## Registration — contract v1.1 (adr-028)

### D-003 · Built two registration states ahead of the design
**Feature:** Registration (Day 7c) · **Date:** 2026-08-05 · **Status:** Accepted · **Raised by:** owner, at the start of Day 7c

**Context.** Contract v1.1.0-m1 (`ee2ed8f`, vendored 2026-08-03) makes two configurations valid and
expected that the approved Figma has no path for: a student whose city is not in the coded list
(adr-028 §1), and a school-track student with no school (adr-028 §2). Seif's partner notice of
2026-07-30 flags both to the UI/UX partner. No revised frames exist, and none is promised for a
date we could wait for. Day 7b's standing rule was the opposite of this: *do not invent a state the
design does not draw.*

**Options.**
- **Wait for the frames.** Keeps the design as the single source of truth, but leaves the app
  unable to complete a registration the server accepts, for an unknown number of days.
- **Build the escape as a separate step** so it reads as obviously provisional. Costs a wizard step
  the design will almost certainly not have, making the eventual reconciliation *harder*, not
  easier.
- **Build in place, from the notice, using existing tokens.** Chosen.

**Decision.** Day 7b's rule is suspended for Day 7c by owner decision. The backend is the
restricting authority this day; where the contract is silent on what a state must *do*, Seif's
notice governs. Both states are built in place — an escape link under the city field, a skip link
under the school field — using the components, tokens and copy conventions already on those screens.

**Invent behaviour, not styling.** Nothing new visually: no new colour, no new spacing scale, no new
component. The escape links are `TextButton`s using `textSecondary`, and both affordances are
literally the same widget so they cannot drift apart.

**Consequences.** Registration works against v1.1 now. The cost is that the design revision, when it
lands, is a **comparison** rather than a discovery — and it might disagree, in which case restyling
two links is cheap. `DESIGN_ISSUES.md` #44 records exactly what was built and from what source so
that comparison is possible without archaeology.

**Revisit when.** The design revision lands. The states are then **re-verified against the frames,
not rebuilt** — the behaviour is contract-driven and does not change; only the presentation is up
for revision.

---

### D-004 · `ProfileCity` is a sealed union, not a flat class with optional fields
**Feature:** Profile models (Day 7c) · **Date:** 2026-08-05 · **Status:** Accepted

**Context.** v1.1 turned `StudentProfile.geography.city` into a union: a `NamedRef` when the student
picked a coded city, `{ name }` when they used the adr-028 §1 fallback. Under v1.0 our model had it
as a bare `NamedRef` with a non-null `id`, so a free-text city would have **thrown on a well-formed
`GET /me`** — the only drift in this contract bump that was a runtime crash rather than a wrong
message. It was free to fix on Day 7c because `ProfileGeography.city` had zero call sites anywhere
in `lib/`; Day 8 is the day that stops being true.

**Options.**
- **Flat class with optional fields** (`String? id, String? nameAr, String? nameEn, String? name`).
  Smallest diff. Compiles everywhere, and reintroduces exactly the failure being fixed: a call site
  can read `.id!` and crash on the arm it forgot.
- **Relax `NamedRef.id` to nullable.** Smaller still, and pushes nullability into the six reference
  pickers that legitimately always have an id, to serve one union that does not.
- **Sealed freezed union.** Chosen.

**Decision.** `ProfileCity.coded(NamedRef)` / `ProfileCity.freeText(String)`, discriminated on the
**presence of `id`** per the contract's own wording at `openapi.yaml:1340` — there is no
discriminator field on the wire. `NamedRef` is left alone.

The point is compiler-enforced exhaustiveness **at call sites that do not exist yet**. Every Day 8
screen that renders a city will be forced by a `switch` to answer "and what if there is no id?"
before it can compile. That is the whole value; a runtime failure on a student's phone is the
alternative.

**Two consequences worth stating.**
- **No display-name getter on the union**, deliberately. Choosing `nameAr` vs `nameEn` needs the
  current locale, which is presentation, not model. Adding `.displayName` would let a call site skip
  the decision the union exists to force.
- **`toJson` is hand-written** (`@Freezed(toJson: false)`). freezed's generated union serializer
  emits its own envelope — `{ref: {...}, runtimeType: 'coded'}` — a shape this API never sends and
  would never accept. Left generated, the union would have had a parser that could not round-trip
  its own input.

**Revisit when.** The contract adds a third city arm, or a discriminator field appears on the wire
(at which point `fromJson` should key off it rather than off `id`).

---

### D-005 · "لم أجد مدرستي" over "تخطي" for the school skip
**Feature:** Registration (Day 7c) · **Date:** 2026-08-05 · **Status:** Accepted

**Context.** Seif's notice asks whether the skip affordance should read *"تخطي"* (Skip) or
*"لم أجد مدرستي"* (I can't find my school) and does not answer. His own guidance is that it must read
as blameless rather than as a failure.

**Decision.** *"لم أجد مدرستي"* / *"I can't find my school"*, for two reasons. It states the
student's situation rather than labelling their action as skipping something they were supposed to
do — a student whose school is genuinely absent from our list has not skipped anything. And it
mirrors the city escape one field above (*"مدينتي غير موجودة"*), so the student meets the same
affordance twice in the same shape, in the same place, in the same weight.

**Consequences.** One extra ARB pair beyond the four Seif's notice specifies — `schoolSkipped` /
*"لم يتم اختيار مدرسة"* — because a skipped field has to read as **resolved**, not blank. An optional
step that still looks empty is one students go back and worry at. That copy is ours and is a
candidate for the designer to overrule.

**Revisit when.** The design revision lands, or the wording is user-tested.

---

## Contract v3.0.0-m1 — adr-049 (purchase-silent app), adr-102 (events vs state)

### D-006 · The result screen stops rendering the student's level and points total
**Feature:** Quiz · **Date:** 2026-09-04 · **Status:** Accepted · **Raised by:** contract 3.0.0-m1
(adr-102); ruled by the owner

**Context.** adr-102 removed `totalPoints` and `level` from `QuizSummary`: they are **state**, not
events of the attempt, and a half-frozen summary could not keep `finish`'s "repeat calls return the
same summary" promise. The changelog entry records as design evidence that the live result frames
`159:1964` (LTR) and `549:20247` (RTL) *"render no absolute level number and no points total anywhere"*
— the level element is a partial-fill meter. Since Day 7 the app had drawn *"Level 3 · 1255 points"*
in the rewards card, from the summary, on the reasoning (S3) that no threshold existed to draw a bar
against — a reasoning the contract's own `StudentProfile.level` description had already answered.
We could not open the frames ourselves (the Figma connector is view-only on Seif's account), so the
contradiction could not be settled from the repo.

**Options.** (a) Remove the element — matches the changelog's reading of the frames. (b) Keep it and
feed it from `GET /me`, which the app already refetches after a finish. (c) Build the meter from
`GET /me` on the 500-point rule Home already uses.

**Decision.** **(a)** — owner's ruling, 2026-09-04. The rewards card shows `pointsAwarded` only.
`leveledUp` and `newBadge` stay parsed and uncelebrated; D-002 stands, with the two flags now
documented as frozen events that must never be recomputed from two `GET /me` reads.

**Consequences.** Two model fields gone (`b7d0dfb`); ARB keys `resultLevelProgress` and `levelAndPoints`
deleted from both locales; one result-screen test rewritten to assert absence; one model test added
proving a 2.x body that still carries the keys parses unchanged (json_serializable ignores unknown
keys), so an un-upgraded staging cannot break the client in either direction. The meter is a design
question and is filed as DESIGN_ISSUES #50. Home's level card is untouched — it always read `GET /me`.

**Revisit when.** The designer confirms the meter on `159:1964` / `549:20247` (then option (c) is a
widget change with no model churn), or supplies a level-up / badge celebration state (D-002).

---

### D-007 · The purchase surface is removed, and the limit-sheet bodies stop telling the student to upgrade
**Feature:** Quiz / Profile / Router / l10n · **Date:** 2026-09-04 · **Status:** Accepted — surface
final, wording provisional · **Raised by:** contract 2.2.0-m1 (adr-049 §3); ruled by the owner

**Context.** adr-049 §3: the mobile app is **purchase-silent** — never a paywall, a price, an upgrade
link, or where to buy; purchases happen on the website only, and voucher redemption is web-only
(`x-consumers: [web]`). The app carried an "Upgrade" button pushing the `/subscription` placeholder,
a four-row benefits card, a disabled Profile "Subscription" row, a `/subscription/return` Paymob route,
and two sheet bodies that read *"Upgrade for unlimited practice"* and *"part of the paid plan.
Subscribe to start practising."* All of it now contradicted the contract the app is built against.

**Options for the copy.** **A (minimal)** — *"You've used all your questions for this week."* /
*"This lesson isn't available on your current plan."* **B (warmer)** — adds *"You can still review your
past quizzes and favourites"* and *"Try another lesson from your subjects"*, which promises screens
that do not exist (Day 9 review unbuilt, `/me/favorites` draft). **Keep the current strings** until the
designer rules — which would ship an instruction the product forbids.

**Decision.** Owner, 2026-09-04: comply with the contract now. The surface is removed (`5c4b855`). The
copy (`ce7da9a`): `weeklyLimitBody` takes **A verbatim** — EN *"You've used all your questions for this
week."*, AR *"استخدمت كل أسئلتك لهذا الأسبوع."* `subscriptionRequiredBody` does **not** take A verbatim:
A says *"on your current plan"*, and DESIGN_ISSUES #30 records that the glossary never calls
`base_subscription` "plan" (nor "premium", nor "pro"). It ships with the glossary term instead — EN
*"This lesson needs an active subscription."*, AR *"هذا الدرس يحتاج إلى اشتراك فعّال."* — which names
the entitlement state the 403 reports without a price, a link or a destination.
`subscriptionRequiredTitle` (*"Subscription Required"* / *"الاشتراك مطلوب"*) is unchanged. Both bodies
and the title are **engineering copy pending the designer**, on the same footing as D-005's.

**Consequences.** Six ARB keys deleted from both locales (`upgradeCta`, `benefitUnlimitedQuestions`,
`benefitAiExplanations`, `benefitPrioritySupport`, `benefitNoAds`, `profileSubscription`); routes
`/subscription` and `/subscription/return` gone; the sheet keeps title + body + "Not now" so the two
403s still get a dismissible explanation; R-6 closed; S8 withdrawn; DESIGN_ISSUES #51 filed for the
three frames that still draw the CTA. Nothing in the app tells the student where to buy — that is the
product decision, not an omission to fix later.

**Revisit when.** The designer supplies approved copy for the two bodies and the title, or product
rules on whether "subscription" may appear at all in student-facing copy.

---

## Leaderboard — built ahead of the contract

### D-008 · The leaderboard is finished but held behind its placeholder, because `GET /leaderboard` is draft
**Feature:** Leaderboard / Router / Shell · **Date:** 2026-09-10 · **Status:** Accepted — the gate
stands, but it is **temporary and its trigger has already fired upstream**; the attribution in
*How it got there* is **CORRECTED — see the Correction of 2026-09-10 at the end of this entry**
· **Raised by:** session audit; ruled by the owner

**Context.** A complete leaderboard shipped into the working tree on 2026-09-08 (13 files —
models, freezed/json parts, notifier, repository, screen, four widgets, 25 tests) and was wired
live: `app_router.dart` served `LeaderboardScreen` on the shell's second branch, reachable from
the nav bar. The work is good — typed exception boundary, `runtimeType`-only error details so
minors' names and scores cannot leak into a log, contract-faithful `limit` bounds validated
rather than clamped, `/leaderboard/me` deliberately not called because the contract forbids a
synthetic self-rank row.

It is nevertheless built against a **draft** path. `openapi.yaml:1221` marks `GET /leaderboard`
`x-stability: draft`, and `:1263` marks `GET /leaderboard/me` the same. Both have been draft since
1.0.0-m1 (`seif_fight.md:124`) and neither moved at the 3.0.0-m1 pin. The project's first
non-negotiable is that the app builds only against `x-stability: stable`.

**How it got there.** ⚠️ **The reading in this paragraph is WRONG. It is kept verbatim because the
commit body of `26591fd` repeats it and the record should show what was believed; read the
Correction at the end of this entry instead.** `tab_placeholder.dart` carried a comment stating
the placeholder was removed "when `GET /leaderboard` and `GET /leaderboard/me` reached
`x-stability: stable`". They never did. The comment is right that the *old* placeholder doc had
also been wrong (it claimed stable plus SignalR live updates, and `realtime.md:9` lists the
`leaderboard` hub as "not drafted") — so a correct observation about one stale claim was turned
into a second, opposite stale claim. No ruling authorising the build exists in this log or in
`seif_fight.md`.

**Options.** **A** — leave it live and accept a draft dependency. **B** — delete the feature.
**C** — keep the code, restore the placeholder on the route.

**Decision.** Owner, 2026-09-10: **C**. `LeaderboardPlaceholderScreen` is restored in
`tab_placeholder.dart` and `/leaderboard` serves it again; the feature stays on disk, analysed and
tested. Nothing about the board is deleted, because nothing about it is known to be wrong — only
its readiness to face a server. Deleting would throw away correct work and re-open a question the
contract will answer on its own schedule.

**Consequences.** Endpoint coverage returns to **0 draft paths consumed**. `main_shell_test.dart`
goes back to asserting two coming-soon placeholders. `leaderboard_screen_test.dart` mounts
`LeaderboardScreen` directly instead of tapping the nav tab, so its 13 behavioural tests still run;
the one test that was genuinely about the shell branch (`back goes to the Home tab, not off the
shell`) is **skipped, not deleted** — it asserts on `MainShell`, which the board no longer sits
inside. Restoring the route is a one-line change in `app_router.dart` plus un-skipping that test
and re-pointing the screen test's mount at the nav tab; all three sites say so in source.

**Revisit when.** ⚠️ **Already met — see the Correction below.** Seif promotes `GET /leaderboard`
(and `/leaderboard/me`, if self-rank is ever wanted) to `x-stability: stable` and the contract is
re-vendored. That ask is not yet filed with him — see `seif_fight.md`.

---

#### Correction, 2026-09-10 (same day) — the pin was stale, not the engineer

Checking upstream for contract updates, hours after the gate was committed in `26591fd`, produced
facts that **invert this entry's attribution**. The decision stands; the reason given for it does
not.

**1. The promotion had already happened, five days before the gate.** `seifhamdii-collab/level-up-contract`
is at `f860408`, **13 commits and ten minor versions** past our pin: `3.0.0-m1` → **`3.10.0-m1`**.
`GET /leaderboard` and `GET /leaderboard/me` became `x-stability: stable` in **`3.5.0-m1` on
2026-09-05**. This entry's "Revisit when" trigger was met before the entry was written.

**2. The engineer was reading the live contract; the vendored copy was the stale artefact.** The
board's repository quotes the contract verbatim — *"Do not add a synthetic self-rank row to the
board"* — and states the rule that `limit` is *validated, not clamped*. **Neither exists at our
pin.** The word `synthetic` appears **zero** times in `184d6ec`'s `openapi.yaml` and once at
`origin/main` (`:1492`); "validated, not clamped" is a **`3.7.0-m1`** clarification, and the "top
200" bound the repository comment relies on arrived in **`3.4.0-m1`**. The board was therefore
built against **`3.7.0-m1` or later**. It was not built on a misread marker — it was built on a
contract this repository had not vendored. *How it got there* blames the wrong party and is
withdrawn.

**3. The gate is still correct, for a narrower reason.** The rule is that the app builds against
the **pinned** contract, and at `184d6ec` the path is draft. Restoring the placeholder keeps the
tree honest about what it is entitled to call. But this is now explicitly a **holding action until
the contract is re-vendored**, not a judgement that the board was built wrongly.

**4. Un-gating is not a revert, and must not be treated as one.** Nine of the fourteen new
changelog entries are leaderboard changes, and the board predates at least six behavioural ones:
the **top-200 bound** (`3.4.0-m1`); a **signed, expiring cursor** that must not be decoded, built
or retained (`3.1.0-m1`); **`scoreHidden` exclusion** so a page can be short (`3.1.0-m1`); a
**`403 score_hidden_leaderboard_unavailable`** on self-rank (`3.2.0-m1`); **short pages while
`hasMore` is `true`** — keep paging until it is false (`3.7.0-m1`); and **`404 not_ranked`** for a
student who has never scored (`3.9.0-m1`). Whether the built code honours these is **UNAUDITED**.
There is also a new cross-cutting **`403 account_pending_deletion`** returned by every
authenticated endpoint but four (`3.3.0-m1`).

**Revised order of work.** Re-vendor the contract and write the impact analysis → audit the board
against the six behavioural changes above → un-gate (route, the skipped shell test, and the screen
test's mount). Un-gating before the re-vendor would put the app back on a path the pinned contract
still calls draft, which is the same fault in the opposite direction.

**What this does not change.** The code stays on disk; nothing was deleted, and point 2 is a
reason to trust it more, not less. `26591fd` is left as committed — its body carries the withdrawn
reasoning and is corrected here rather than rewritten, so the record shows the sequence.

#### Re-decision of 2026-09-12 — the trigger fired; the gate stays anyway

The condition this entry was waiting on has been met. `contract/` is re-vendored to
`2dca3c5` (3.13.0-m1) in `f836213`, and `getLeaderboard` / `getMyRank` are
**`x-stability: stable`** there — 3.5.0-m1 promoted both. **The gate's original stated
reason has therefore expired.** It is no longer true that the board is built against a
draft path.

**Owner ruling, 2026-09-12: the placeholder stays up.** Not because the contract still
forbids the board, but because the *Revised order of work* above has only had its first
step done. That order was: re-vendor → **audit the board against the behavioural
changes** → un-gate. The middle step has not been performed, and two of those changes
are the kind that fail quietly in front of a student rather than loudly in a build:

  * **`3.7.0-m1`** — `GET /leaderboard` may return a **short page while `hasMore` is
    still `true``. A client that stops when a page arrives short shows a truncated board
    and an "end of board" footer that is a lie. The board predates this and is UNAUDITED
    against it.
  * **`3.9.0-m1`** — `getMyRank` answers **`404 not_ranked`** for a student with no
    points, instead of inventing a rank. Every new student is in exactly that state. If
    the board treats 404 as a generic failure, the first thing a new student sees is an
    error.

Neither moves a schema, so a regenerated client is byte-identical and **the build cannot
tell you about either**. Un-gating now would ship a board that mis-paginates for everyone
and breaks for every student who has not yet scored — while looking perfectly green.

**What stays true meanwhile.** The board's 13 files and 25 tests remain on disk and
compile; nothing is deleted. `test/features/leaderboard/leaderboard_screen_test.dart:230`
stays `skip: true` and remains the suite's single skipped test — it is the marker for
this decision, and un-skipping it is part of un-gating, not a tidy-up.

**What would close this.** The audit named above, against the six behavioural changes, with
`3.7.0-m1` and `3.9.0-m1` handled explicitly and covered by tests. Then the route, the
skipped test and the screen test's mount go back together, and the board gets a device pass
before it is called done.

#### CLOSED, 2026-09-22 — the audit ran, the route is back

**Status: D-008 is closed.** The condition set out directly above was met in full.

**The audit** is `docs/D008_LEADERBOARD_AUDIT.md`. Verdict: the board **passes** all six
behavioural changes — four actively (top-200 bound, signed/expiring cursor, `scoreHidden`
exclusion, short pages), two N/A because `getMyRank` is deliberately not called (`403
score_hidden`, `404 not_ranked`). The two this entry singled out as the quiet-failure risks
are both already correct: `3.7.0-m1`'s short page is handled by `isEmpty => items.isEmpty &&
!hasMore` with a short-page walk in `build()`, and `3.9.0-m1`'s `404 not_ranked` cannot be
reached because the operation is never called. **Nothing in `lib/features/leaderboard/` was
changed to pass this audit** — it was already right, which is what the Correction of
2026-09-10 predicted when it established the board had been built against 3.7.0-m1 or later.

**The server.** The board has now met one. `GET /leaderboard` decoded through the real
repository against staging `0f97f289` on 2026-09-22 —
`.ai/audits/current/smoke-staging-2026-09-22.md`. Both leaderboard routes answer `401`
unauthenticated rather than the `404` an absent route gives, so both are deployed. The
sentence "the board has never met a real server" is withdrawn. **It remains a one-account,
one-scope, one-row board**: pagination, the 200-row bound and the privacy filtering are still
BUILD-level only.

**What went back, together, as this entry required.** The route
(`app_router.dart` — `LeaderboardScreen`, one builder line plus its import); the skipped
shell-branch test (un-skipped — the suite now reports **0 skipped**); and the screen test's
mount (re-pointed at the real router). `LeaderboardPlaceholderScreen` was deleted and replaced
with a note, which is what Learn (Day 5) and Account (Day 8) each did on their way out of
`tab_placeholder.dart`.

**One thing this entry asked for that is deliberately NOT claimed: the device pass.** It is
still owed. Un-gating makes it possible on a committed tree for the first time — every previous
device sighting of this board ran on a local edit that was reverted the same session
(`DEVICE_VERIFICATION_2026-09-20.md:31`).

**One finding, not fixed.** `LeaderboardNotifier`'s comment at the short-page give-up claims
the UI shows an empty state; it does not, and the test at `leaderboard_notifier_test.dart:69`
proves the opposite is intended. The *behaviour* is right and deliberate — inventing
`hasMore: false` would be inventing an answer the server withheld — but the state has no UI,
so a pathological server (ten consecutive empty pages claiming more) renders a blank scroll
area with no message and no recovery. Left alone because fixing it needs an ARB key pair in
both languages, which is a copy decision. Recorded as F-1 in the audit.

**Endpoint coverage: 21/21 → 22/22 stable.** `getLeaderboard` joins the consumed set.
`getMyRank` stays unconsumed **by decision, not by gate** — it is `stable` and deployed, and
the contract's "do not add a synthetic self-rank row" is why the app does not call it.

---

## Elevation — the design system's third layer

### D-009 · Elevation becomes tokens and primitives; the dark canvas elevates with Glass, and its shadows are black
**Feature:** Design system (elevation foundation) · **Date:** 2026-09-17 · **Status:** Accepted ·
**Raised by:** the owner, after the 2026-09-16 Figma elevation audit and the 2026-09-17 Glass reading

**Context.** Elevation was the last design dimension still decided at call sites. Colour has had a
palette and a guard since Day 7b; typography got both on 2026-08-21. Shadows had neither, and the
audit found what that costs:

- **Eleven raw sites** across seven files — `BoxShadow`, `elevation:`, `shadowColor:`, a
  `MaskFilter.blur` — each with its own numbers.
- **The wrong unit, everywhere.** Figma's "Blur" is a CSS blur radius; Flutter's `blurRadius` is
  not. `BoxShadow` converts it with σ = 0.57735·B + 0.5, so the file's commonest shadow, blur 1.3,
  rendered at σ 1.25 against the correct 0.65 — nearly twice as soft, on every back chip and every
  profile chip. Nothing in the pipeline could have reported that.
- **A dark colour derived from a false premise.** `AppColors.elevationShadow` flipped to cream in
  dark because "no dark frame exists for any of the five components" (DESIGN_ISSUES #47). Thirteen
  dark frames do exist and every one of them is **black** at the light alpha.
- **A whole mechanism that was invisible.** The dark canvas raises surfaces with Figma's **Glass**
  effect plus a lavender back-light, and the view-only seat hides Glass in every surface Figma
  offers — Design panel, Dev Mode, every export, Copy as SVG. A glass surface inspects as a plain
  translucent rectangle, which is exactly how it was built (→ DESIGN_ISSUES #72).

**Options.**

1. **Fix the eleven sites in place.** Cheapest. Rejected: it leaves the twelfth to be written next
   week, and it cannot express Glass or a back-light at all.
2. **A `BoxShadow`-based token set.** Familiar, and works with `BoxDecoration`. Rejected on two
   counts: the blur unit is wrong by construction, and `BoxShadow` cannot knock itself out from
   under a translucent fill — which is most of this design's dark surfaces.
3. **A `BackdropFilter` on every glass surface.** The literal reading of Glass. Rejected as the
   default: one backdrop pass per surface, including per leaderboard row, to blur a flat page
   colour — a blurred uniform colour is that colour. Kept for the one surface with real content
   behind it.
4. **A third-party glass package** (e.g. `liquid_glass_renderer`). Rejected: a new dependency, and
   Impeller-only, on a build with no Impeller flags in either platform manifest.
5. **Tokens + primitives, with a modelled tier-1 Glass.** Chosen.

**Decision.**

- **`AppElevation`**, a `ThemeExtension` beside `AppColors`, carries every measured shadow, inner
  shadow, Glass setting, back-light, scrim and theme-dependent border width, per canvas, with the
  Figma node cited on each. 84 tokens.
- **`lib/core/widgets/elevation/`** is the only code allowed to paint a shadow, a blur or a
  backdrop: `paintFigmaShadows`, `GlassSurface`'s rim and back-light painters, `ElevatedSurface`,
  `SegmentedTrack`, `PrimaryCta`.
- **The conversion happens once**, in `glass_mapping.dart`: Figma Blur `B` → σ = B/2, which is the
  CSS definition and is **not** a tunable.
- **Knockout is the default.** Every drop shadow in the file carries `showShadowBehindNode: false`,
  so an outer shadow is clipped to *outside* the surface's own outline before it is drawn. This is
  what makes a 20%-alpha card composite over the page rather than over its own shadow.
- **Dark shadows are the measured black.** The cream derivation is withdrawn (DESIGN_ISSUES #47,
  superseded).
- **Glass is rendered as tier 1**: tint + a normal-based rim light + the back-light frosted with the
  surface's own σ, with a real `BackdropFilter` only where there is content behind the surface.
  `refraction`, `dispersion` and `depth` are stored but not drawn, because over a uniform backdrop
  they have nothing to distort.
- **Back-lights belong to the covering surface**, not to the page: below its tint, clipped to its
  shape, blurred with its frost, scrolling with it. On canvas there is no hard ellipse edge
  anywhere, which is the evidence for that reading.
- **A ratchet guard** (`rawElevationEffects`, baseline **11**, frozen 2026-09-17) stops the twelfth
  raw site, and each of edits 2–5 lowers it in the same change that removes one.

**Consequences.**

- **This change moves zero pixels, deliberately.** It adds tokens, primitives, a guard, tests and
  docs; it changes no existing token value. `elevationShadow` and `navShadow` keep their current
  values and are replaced component by component, because flipping `elevationShadow` to black on
  its own would darken the 20%-alpha cards that still paint an unclipped shadow under their fill.
  The token is deleted by whoever removes its last reference. (**edit2, 2026-09-18:** that has now
  happened to `navShadow` and to `backChipFill` — both had exactly one consumer left and both are
  deleted. `elevationShadow` still has nine, in edits 3–5, and is untouched.)
- Every later component change gets its elevation for free and cannot invent one.
- The cost is a large token surface (84 fields, with `copyWith`, `lerp` and equality over all of
  them) and a rim light that walks a path in 2px steps per surface. Both are paid once.
- **Calibration is outstanding.** The five tier-1 model constants ship at documented starting
  values and have not been compared against Figma's render — desktop access was declined on
  2026-09-17. They are marked PENDING in DESIGN_ISSUES #72 with the seven comparisons still owed,
  and **nothing in the build reports them as calibrated.**
- **Tier 2** — an Impeller `ImageFilter.shader` for real refraction and dispersion — is not built
  and needs the owner's approval, because it adds a `flutter: shaders:` entry and a
  rendering-engine-dependent path (`ImageFilter.shader` throws `UnsupportedError` without Impeller
  in the pinned SDK 3.44.7).

**Revisit when:** the calibration runs (C1–C7), or the designer supplies a dark RTL frame — the only
thing that can settle whether back-light offsets really mirror — or the onboarding sheet's tier-1
frost is judged insufficient on a device, which is the one place tier 2 could show a difference.

### D-010 · The dark review answer rows take the approved Glass treatment; DESIGN_ISSUES #53 is closed
**Feature:** Quiz review (elevation pass, edit4 item #48) · **Date:** 2026-09-17 · **Status:** Accepted ·
**Raised by:** the designer/owner, unprompted, after the edit1 elevation foundation landed

**Context.** The dark quiz-review frame (`337:6705`, rows `337:6731`) draws the answer rows as the
semantic fills at **20% alpha** with a 0.5 semantic stroke and **G5** Glass. The build did the
opposite — opaque fills in both themes — under an owner ruling of 2026-09-08 recorded as
DESIGN_ISSUES #53, on the grounds that a correctness signal must not change with the canvas and that
honouring the frame would leave the review screen and the quiz page disagreeing one tap apart. That
left `edit4.md` item #48 marked **BLOCKED — USER DECISION REQUIRED**, with three options and a
default of "no change".

**Options** (as written in `edit4.md` §"#48"):

1. **(a)** keep #53 — opaque, no Glass, no change. The standing default.
2. **(b)** keep the opaque fills and add the G5 rim light only — a hybrid.
3. **(c)** follow the dark frame: the frame's alpha + the 0.5 stroke + G5 Glass.

**Decision — (c), with consistency ranked above the literal number.** In the designer's words: do
not keep the old opaque treatment; use the approved Glass treatment; the current Figma Glass design
is the source of truth; the previous 20% opacity discussion is not a reason to create a *different*
treatment; **the corresponding Review answer rows must use the same Glass treatment consistently**,
i.e. be equal in treatment rather than preserving an opaque-vs-Glass difference inherited from the
old 20% value; and the exact 20% value is **not** a separate product requirement where it would
conflict with that consistency. #53 is resolved/withdrawn for this issue and must not block
implementation.

**Consequences.**

- **#53 is closed** and carries the ruling; **edit4 item #48 is unblocked** and implements (c)
  through edit1's `ElevatedSurface` + the `AppElevation` Glass token — not a second glass
  implementation, and not a hardcoded fill.
- **A shipped test is now wrong on purpose.** `test/features/quiz/quiz_review_screen_test.dart`
  asserts that the dark rows render the same opaque marks as light. The edit that implements this
  rewrites that assertion; it does not delete it.
- **The palette rule is unchanged.** *"A correctness signal must never flip colour with the canvas"*
  governs **hue**; this ruling changes **treatment** (alpha + Glass), which is how the dark canvas
  elevates every other surface in the design (D-009, DESIGN_ISSUES #72). A wrong answer stays red.
- **One thing this ruling deliberately does not settle.** Option (c) as written noted that following
  the dark frame "must also change the quiz page's graded tiles". The ruling is scoped to the
  **Review answer rows** and gives no instruction about the quiz page. If the two screens visibly
  disagree once this lands, that is a **new** question for the designer, raised with both renders
  side by side — not a reason to hold the review rows. The related wrong-row hex/opacity divergence
  between the two screens stays open as DESIGN_ISSUES #52.

**Revisit when:** the quiz page's graded tiles are compared against the reviewed rows on a device and
the pair is judged inconsistent, or the designer re-draws `337:6705`.
### D-011 · The Glass rim ships at 70% of Figma's measured brightness, because tier 1 renders no depth

**Date:** 2026-09-19
**Raised by:** the owner, on the question `DESIGN_ISSUES` #72 escalated the same day

**Context.** The 2026-09-19 re-calibration (#72) measured Figma's Glass rim end to end: it is a
two-lobe directional highlight, lit on the side facing the light and carrying a second lobe at
**0.65** on the side facing away, absent entirely across the two corners square to the light axis,
**0.63 dp** wide, **linear** in `lightIntensity`, and **independent of `splay`**. Its alpha reaches
**0.79** per unit intensity at the apex and **0.50 lit / 0.33 dim** on a straight edge.

The shipped model had been taking `.abs()` of an un-negated dot product, so no surface had a lit
side at all, and its falloff drew that 0.50 edge as **0.06**. Correcting the geometry is not in
question — it was a provable fault.

What the measurement cannot settle is the **strength**. Figma's rim sits inside a surface that the
`depth` and `refraction` terms darken with a gradient; that is what makes Glass read *recessed*
there. The tier-1 model deliberately renders neither (D-009) — a backdrop pass per surface,
including per list row, for something that over a flat page has nothing to distort. So the build
would be pairing Figma's rim with a flat interior, and the rim reads stronger than the design
intends.

**Options.**

1. **(a)** Ship Figma's measured alpha. Faithful to the number, brighter than the design's look.
2. **(b)** Build the `depth`/`refraction` shading so the measured alpha is right in context.
3. **(c)** Keep every measured term and scale the strength down by one explicit constant.

**Decision — (c).** In the owner's words: do not use Figma's literal rim intensity; keep all the
calibrated geometry — direction, two-lobe behaviour, threshold, width, falloff — and reduce the
intensity intentionally so the Flutter result *looks like* the design; put that reduction behind a
single explicit constant; do **not** implement refraction now merely to justify the brighter rim;
and do **not** record this as a measurement error or a deviation — it is intentional visual
compensation. **A visual match is the goal, not matching Figma's alpha number literally.**

`kGlassRimMaxAlpha` ships at **0.55** against a measured **0.79** — 70%. The fraction was chosen so
the two most prominent Glass surfaces keep the brightness the app has already shipped and been
reviewed at: the level card (`splay` 1.00) and the form field (0.97) rendered **0.354** per unit
intensity at a straight edge under the old model and render **0.350** under this one. The small
chrome, which the old model drew at 0.06 where Figma draws 0.50, comes up to **0.35** rather than
all the way.

**Consequences.**

- **One dial.** `kGlassRimMaxAlpha` in `lib/core/theme/glass_mapping.dart` is the only number to
  change if the rim should be stronger or weaker. `kGlassRimMeasuredMaxAlpha` sits beside it
  carrying Figma's 0.79 so the measurement survives the ruling.
- **The geometry stays pinned to Figma.**
  `test/core/widgets/elevation/glass_rim_calibration_test.dart` asserts the sidedness, the 0.65
  back lobe, the bare corners and the straight-edge *profile* against Figma's own numbers scaled by
  the dial — so moving the dial does not invalidate the calibration, and quietly dimming the rim by
  bending the geometry instead still fails. One assertion pins the 70% itself.
- **`depth`/`refraction` is not scheduled by this.** It stays recorded in #72 and D-009 as a term
  tier 1 does not render. If it is ever built, this ruling is the thing to revisit.
- **Five dark goldens moved** — `elevation_level_card_dark`, `elevation_translucent_row_dark`,
  `elevation_two_shadow_card_dark`, `language_pill_dark`, `track_screen_dark`. No light golden
  changed: the light canvas has no Glass.

**Revisit when:** the `depth`/`refraction` shading is built, or the rim is judged on a device
against the dark frames and reads wrong at either end of the splay range.

---

## Catalog — the Home / Learn / Mistakes elevation wave (edit3)

### D-012 · The segmented track keeps its labels at full size and lets the groove scroll

**Feature:** Catalog / Lectures (edit3.md #9) · **Date:** 2026-09-19 · **Status:** Accepted
**Raised by:** the owner, on the question `DESIGN_ISSUES` #81 escalated the same day

**Context.** edit3 #9 replaced a horizontally **scrolling** row of content-sized chips with Figma's
segmented track: one fixed 362 x 44 groove, `Expanded` segments of equal width, and a
`FittedBox(BoxFit.scaleDown)` on each label. The scroll used to absorb a long label; equal segments
cannot, so the label shrank instead — and because the segment width was fixed, the shrink handed
back exactly what the student's text-scale setting had added.

Measured 2026-09-19 at a 375 dp phone with the four quiz types the contract's enum allows (the
fixture ships three, which is why the first version of those tests could not see any of this): the
Arabic منتصف الترم painted at **10.2 dp** inside a 16.0 dp layout box, and raising the system text
size from 1.0x to 1.3x moved it from 10.2 to **10.2** while عادي beside it went 16 → 21.

Two defects, not one. A **legibility** defect — 10.2 dp is below the floor this project had already
named, when `subject_card.dart` raised the frame's 8.56 dp caption to 10 because "8.5 dp is below
any readable minimum on a real phone" — and an **accessibility** defect, where the setting is
discarded for precisely the label that needed it. Arabic is the worst case because its labels are
longest, which makes it an Arabic-first defect on an Arabic-first product.

**Options.**

1. **(a)** Keep the shrink. Faithful to the groove's fixed width; illegible in Arabic at four tabs.
2. **(b)** Shrink only down to a minimum font size. Needs a number nobody has supplied, and still
   discards the text scale below it.
3. **(c)** Wrap the label to two lines. Makes the 44 dp height variable — trading one Figma value
   for another, and inventing the line metrics.
4. **(d)** Shorten the Arabic labels. A copy change, and it only moves the threshold.
5. **(e)** Keep the design, give up the fixed **width**: full-size labels, groove scrolls when they
   do not fit.

**Decision — (e).** In the owner's words: **Arabic readability and text scaling are more important
than strict Figma segmented-track geometry.** Do not accept `FittedBox(scaleDown)` shrinking Arabic
labels to ~10 dp, and do not silently discard the text-scale setting. Keep the segmented track as
the default design and adapt the implementation. Do **not** invent a minimum font size, and do not
change or abbreviate labels without documenting the decision.

Scrolling was chosen over the other four because it is the only one that needs **no invented
number** and is not new behaviour in the product: the chip row this control replaced scrolled, on
this same screen, until this wave.

**Consequences.**

- **The `FittedBox` is gone.** Every label lays out at `labelStyle` times the student's text scale,
  always. Segments stay equal, the groove stays 44 dp.
- **The common case did not move.** `LayoutBuilder` → `SingleChildScrollView(horizontal)` →
  `ConstrainedBox(minWidth: available)` → `IntrinsicWidth` puts the groove back to the full width
  whenever the labels fit, so it lays out as before. **`quiz_type_tabs_dark.png` moved by exactly
  one pixel** — `(368, 40)`, one unit of blend on the groove's right edge, because the width now
  arrives through `IntrinsicWidth` rather than off the parent's constraint. Diffed channel by
  channel; nothing else in the frame differs. A `Row` of flex-1 children reports
  `n x widest child` as its intrinsic width — the same "Fill" rule the Figma frame uses — so nothing
  measures a `TextPainter` by hand.
- **One new value, and it was READ, not chosen.** `SegmentedTrackStyle.segmentPadding` defaults to
  Figma's own `Padding 10`, off both segment frames — idle `180:5338`, selected `180:5340`, each
  `Fill (72.4px) x Fixed (44px)` inside the `Fixed 362 x 44` groove `180:5337`. Horizontal only: the
  frame's height is fixed and its label is 17 tall, so the vertical 10 drives nothing there either,
  and modelling it here would only eat text-scale headroom. That headroom measures ~**3x**.
- **No copy was touched.** Whether منتصف الترم should be shortened stays an open designer question
  in #81, recorded rather than acted on.
- **Where the fallback engages was settled on a device, and it is kinder than the tests.** On a
  physical **Pixel 8** (411.4 dp wide) the four Arabic labels **fit at the default text scale** — the
  groove measures 933 px / 355.4 dp off the device's own pixels, entirely on screen, four equal
  segments. At **1.3x** they do not fit: the last label clips, the track scrolls, and **every** label
  grows, the longest included. The tests scroll at 375 dp where the device does not, because the test
  binding's font is ~1.5x wider than Inter (Figma reads "Normal" at 49 px; the test lays it out at
  72). The tests prove the fallback engages and behaves; the device says when.
- **One thing only the device showed:** when the track does scroll, the dark groove `#232429` sits
  within a shade of the dark page, so the overflow reads as a clipped word rather than as something
  swipeable. Recorded as #81's open question 4 — a fade or a peeking next segment is not in the
  frame, so it is the designer's call, not an invention to make here.
- **Guarded, not left as prose.** `segmented_track_test.dart` and `lectures_screen_test.dart` assert
  painted == laid on every label, every label growing by the same factor under text scale, and the
  groove never narrower than the space it is given. A `FittedBox` coming back fails all three. The
  #81 ratchet that used to hold the 10.2 dp defect in place now asserts its absence.
- **A second, unrelated defect was fixed in the same file, with the owner's go-ahead.**
  `_Segment` wrapped its `GestureDetector` in `Semantics(..., excludeSemantics: true)`, which took
  the tap **action** out with the subtree: the node announced itself a button, announced which
  segment was selected, and offered no way to select another one. `onTap` is now declared on the
  `Semantics` itself, keeping the exclusion so the label is not announced twice.

**Revisit when:** the designer answers #81's remaining questions — wrap versus scroll, or shorter
Arabic copy — or a device pass shows the groove scrolling on a configuration the design expects to
tile.

---

### D-013 · `DESIGN_ISSUES` #80 (the 35 dp catalog header) returns to the edit2 owner, unfixed

**Feature:** Catalog chrome (edit2's `CatalogHeader`) · **Date:** 2026-09-19 · **Status:** Accepted
**Raised by:** the owner, on the question `DESIGN_ISSUES` #80 escalated the same day

**Context.** `CatalogHeader` is a `SizedBox(height: 35)` around a `Stack`
(`catalog_scaffold.dart:64`). A `RenderBox` refuses a pointer outside its own size —
`RenderBox.hitTest` returns false before it ever reaches `hitTestChildren` — so a 48 dp child of a
35 dp box is tappable over 35 dp and the remainder goes to whatever is behind it. Every occupant of
that header is therefore capped at **35 dp** whatever it asks for: the back chip, and the Subjects
screen's Mistakes pill.

It surfaced while rebuilding that pill (edit3 #7), whose guide asks for the usual ">= 48 dp target
under the drawn 35 dp pill". The pill **never had one**: the `OutlinedButton` it replaced carried
Material's `tapTargetSize: padded`, which draws a 35 dp button inside a 48 dp hit box, and this
header had been clipping that box away silently for as long as the button existed. Wrapping the new
pill in an explicit `SizedBox(height: 48)` behaves identically. This is a **layout** bound, not a
clipping one — `Clip.none` changes nothing, verified with a throwaway probe at both heights.

**Options.**

1. **(a)** Grow the header from edit3. A layout change to every catalog screen, in a file edit3's
   scope does not include.
2. **(b)** Give the pill a 48 dp box anyway.
3. **(c)** Return the finding to whoever owns `CatalogHeader`.

**Decision — (c).** The owner's instruction: return it to the **Edit 2 / `CatalogHeader` owner**;
do not fix it in Edit 3, since the root cause is the shared 35 dp header height.

**(b) was rejected on its merits, not just its scope:** a 48 dp box that the parent silently clips
reads as compliance in review and is false at runtime. Shipping the pill at exact parity with the
button it replaced is the honest state.

**Consequences.**

- The Mistakes pill ships with a **35 dp** tap target, unchanged from the button it replaced. That
  is below WCAG 2.5.5 and below both the Material and HIG minimums. It is a real accessibility
  defect on a live control, and it is **not new** — it is newly *measured*.
- The back chip has the same cap, and neither control can be fixed from its own file.
- `test/features/catalog/subjects_screen_test.dart` pins the measurement: the pill's centre +/-
  15.5 dp lands on its ink box and +/- 24 dp does not. When edit2 grows the header, that test is
  the thing to re-run, and it should start failing.
- The remedy is one number: `SizedBox(height: 35)` at `catalog_scaffold.dart:64` becomes at least
  48, with the 35 dp pill and the back chip centred inside it.

**Revisit when:** edit2 next touches `catalog_scaffold.dart`.

---

### D-014 · Home's Top Student block shows the board the Leaderboard tab opens on, and "See All" opens that tab

**Feature:** Home (API→UI Wave 05) · **Date:** 2026-09-24 · **Status:** Accepted
**Raised by:** the build, which the wave plan told to stop and ask; **decided by** the owner

**Context.** Figma draws a "Top Student" block on Home: three rows (medal, avatar, name, points)
and a "See All" link (`59:2086` school, `125:2373` university, `337:5456` dark). It had rendered as
"Coming soon" since Day 4 with the comment "no endpoint yet". That stopped being true when D-008
closed on 2026-09-22: `GET /leaderboard` is stable, deployed and decoded. But the operation's
`scope` is **required**, depends on the track (school `system` | `governorate`, university `cohort`
| `global`) and has no server default. The frame draws no scope, and it gives "See All" no
destination.

**Options (scope).** (1) The tab's default, `LeaderboardScope.scopesFor(me).first`: school
`system`, university `global`. (2) The narrowest board: school `governorate` (Egypt only), university
`cohort`. (3) Keep the block "Coming soon" until the designer says.
**Options (See All).** Open the Leaderboard tab, or leave it inert like the other "See All" links.

**Decision.** Scope (1) and "See All" opens the tab, both the owner's choice. The block shows the
first three rows of `leaderboardProvider(LeaderboardScope.defaultFor(me))`, the SAME provider
instance the tab opens on.

**Consequences.**

- One request serves Home and the tab, and the tab opens already loaded. Pinned by
  `top_student_section_test.dart` ("ONE request serves Home and the Leaderboard tab").
- `LeaderboardScope.defaultFor` is the single definition, and both surfaces call it.
- The block's error rules are the tab's: `board_failure.dart` holds the copy and retry rules both
  use, so a `429` or `account_pending_deletion` withholds Retry in both places.
- Rows are not tappable (there is no student profile screen) and the caller's own row gets no "You"
  treatment (the frame draws none).
- When `/me` reports new points (after a quiz), the block refetches the board, so it never shows a
  total the level card above it has already replaced.

**Revisit when:** the designer specifies which board the block shows, or draws a destination for
its rows.

### D-015 · The explanation `subscription_required` popup is built, with the contract's copy verbatim

**Feature:** Quiz (API→UI Wave 12) · **Date:** 2026-09-26 · **Status:** Accepted
**Raised by:** COMPARE §19 and the wave plan, which said to stop and ask; **decided by** the owner

**Context.** `GET /questions/{questionId}/explanation` answers `403 subscription_required` to a student
without a base subscription for the question's track. The contract: *"Show this popup, using this approved copy
verbatim: 'AI explanations are available with a Level Up subscription. Subscribe to get step-by-step
explanations and more learning features.'"* Arabic comes from the app's own localisation of the code. The app
showed the generic *"No explanation is available for this question."* The copy says "subscribe", and the app is
purchase-silent (adr-049 §3). DESIGN_ISSUES #51 had asked that no limit-card body mention subscribing.

**Options.** (1) Build the popup verbatim. (2) Keep the generic line and log a divergence from the contract.

**Decision.** (1), the owner's choice, with the Arabic draft approved as shown: *"شروحات الذكاء الاصطناعي متاحة
مع اشتراك Level Up. اشترك لتحصل على شروحات خطوة بخطوة ومزايا تعليمية أخرى."*

**Consequences.**

- The popup is the limit card (`LimitSheet.showExplanation`): title "Subscription Required", the contract copy,
  the ✕ and "Not now". No price, link or buy button.
- The Bloc keeps the result as its own `ExplanationSubscriptionRequired` state. The screen opens the popup on the
  transition into it, once per tap, and not again when the student pages back to the question.
- The panel keeps its "Show explanation" button, which the contract renders from `explanationAvailable` alone,
  and a further tap asks the server again: the student may have subscribed on the website since.
- Every other explanation 403 is unchanged: `insufficient_scope` and `account_pending_deletion` still read
  "not available", with no retry.

**Revisit when:** product or Seif changes the approved copy, or the designer draws the popup.

### D-016 · The result screen: the ring fills anticlockwise in both languages, and "Back to Learn" is gone

**Feature:** Quiz result (API→UI Wave 13) · **Date:** 2026-09-26 · **Status:** Accepted
**Raised by:** the Wave 13 frame re-read and baseline walk; **decided by** the owner

**Context.** The result frames (`159:1964`, dark `337:6628`, and the two university copies) draw the score ring
filling **anticlockwise** from 12 o'clock: at 50% the left half is lit. The app used Material's clockwise
`CircularProgressIndicator`. There is no Arabic result frame, and the app's linear progress bars do mirror in RTL.
Separately, the app drew a "Back to Learn" text link under "Review Questions"; none of the four frames has it, and
the back chip and system Back already leave for Learn.

**Options.** Ring: (1) as drawn, anticlockwise in both languages; (2) anticlockwise in English, mirrored in Arabic.
Link: (1) remove it; (2) keep it and log the divergence.

**Decision.** Ring (1): a dial is not text, and this invents nothing beyond the frame. Link (1). Also ruled with
these: the ring's figure keeps the scale's 28 (DESIGN_ISSUES #97), and the shared back chip's semantics are fixed
for every screen now (KNOWN_BUGS BUG-013).

**Consequences.**
- The ring is a painter (`ResultRingPainter`) drawing the frame's SVG export: track, stroke 9.846, round caps, and
  the export's radial gradient `#AE87E7` → `#7070A0`. Its sweep is negative (anticlockwise) under both
  directionalities; a test pins the Arabic case.
- The result has one CTA. Leaving is the back chip or system Back, both to `/learn`.

**Revisit when:** the designer draws an Arabic result frame, or asks for a second exit.

### D-017 · Question text: `<u>…</u>` is drawn as an underline, and each stem takes its own text direction

**Feature:** Quiz page and quiz review (API→UI Wave 14) · **Date:** 2026-09-27 · **Status:** Accepted
**Raised by:** the Wave 13 re-walk and Wave 14's compare; **decided by** the owner ("both screens")

**Context.** `QuizQuestion.text` is "Plain text; only <u>…</u> markup allowed." (`openapi.yaml:2703`). Both screens
that show a stem drew the tags as text, and TalkBack read them out (DESIGN_ISSUES #88 had asked whether markup was
allowed at all). The content language need not be the UI's (adr-018): on the Wave 13 re-walk an Arabic stem,
truncated in the English app, put the ellipsis before "السؤال" and cut its end mid-word, because it was laid out as
an LTR paragraph.

**Options.** (1) One shared widget, used by the quiz page and review. (2) Review only, the quiz page later. (3)
Leave #88 open.

**Decision.** (1). `QuestionStemText` parses exactly `<u>` and `</u>`; anything else that looks like a tag is text,
because the contract says nothing else is sent. Malformed input degrades as a browser would (an unclosed `<u>`
underlines to the end; a stray `</u>` is dropped; `<u>` does not nest). The paragraph takes the direction of the
stem's first strong character, falling back to the app's; **alignment stays the app's start**, so a stem that fits
sits where the plain `Text` put it.

**Consequences.**
- The quiz page (Wave 12's screen) changed by one widget; its layout is otherwise untouched.
- An Arabic stem in the English app is an RTL paragraph set from the left; an English stem in the Arabic app is LTR
  set from the right. Only truncation and edge punctuation look different.
- Any future rich-text field (options, explanations) is NOT covered: the contract allows markup on the stem only.

**Revisit when:** the contract widens the markup subset or allows it on another field.

**Update 2026-09-27 (W14-10, owner ruling):** an underlined run holding Arabic letters is underlined by hand, at
Tajawal Regular's declared position and thickness, because Tajawal Medium and Bold declare a line the letters hide
(KNOWN_BUGS BUG-014). A run without Arabic keeps the engine's underline.

### D-018 · The Mistakes overview card grows with its text; the frame's 89 is a floor

**Feature:** Mistakes overview (API→UI Wave 15) · **Date:** 2026-09-27 · **Status:** Accepted
**Raised by:** KNOWN_BUGS BUG-002 and the Wave 15 plan ("no overflow AR 1.3 / 2.0"); **decided in** Wave 15, open to
the owner at the walk

**Context.** The frame draws a 173 × 89 card (`404:6322`). At a raised system text scale its two lines outgrow it:
an Arabic card overflowed from 1.3 on the device, and every card at 2.0 (BUG-002). KNOWN_BUGS left "what gives way"
open: the title truncating, the card growing, or the caption moving.

**Options.** (1) The card grows, and a row takes its taller card. (2) Clamp the text scale (`docs/RESPONSIVE.md`
Rule 4): app-wide, unapplied, and its bound, 1.3, is where Arabic already broke. (3) Truncate or move the caption:
truncating cannot save height (one line at 2.0 is 48 tall), and moving it is a layout no frame draws.

**Decision.** (1), the only in-screen option that invents nothing. The grid is a list of two-card rows
(`IntrinsicHeight`), because a `GridView` cell gives every card one height. The frame's paddings stay fixed, and 89
is the card's minimum height.

**Consequences.**
- English at the default scale is the frame's 89. On a real-font render Arabic cards measure 90–91 at 1.0: the
  Tajawal fallback lays a line out taller than the scale's (the Wave 14 walk's observation).
- At 1.3 the cards measure 101–103, at 2.0 131–132, with no overflow.
- The Subjects grid (`subject_card.dart`) is not changed, and it still overflows (BUG-002's other half).

**Revisit when:** the designer draws an Arabic or text-scaled Mistakes frame, or the RESPONSIVE clamp is applied.

### D-019 · Arabic lines that mix fonts are fixed app-wide, in their own wave, not screen by screen

**Feature:** app-wide type (found on the Mistakes screens, API→UI Waves 14–17) · **Date:** 2026-09-27 · **Status:**
Accepted, not built · **Raised by:** the Wave 14, 15 and 16 walks (W15-6, W16-6); **decided by** the owner (option c)

**Context.** A two-word Arabic name makes its line taller than the scale's: the Mistakes overview card is 93 dp
instead of 89 in English (96 in Arabic), and the Mistakes tree rows 82 instead of 78 (85 in Arabic), with the text
up to 4 dp below the frame's. A throwaway real-font probe on the Wave 16 walk isolated the trigger: one-word Arabic and
English names give the frame's 78, a two-word Arabic name does not. The likely mechanism (inferred) is the space
between the words drawn in Inter, the primary font, inside a Tajawal line. The Wave 14 walk saw taller Arabic lines
on the quiz review rows too. Nothing overflows. The frames draw English names only.

**Options.** (a) Accept it. (b) Pin the lines to the scale's line height on the Mistakes screens only. (c) Fix the
mixed-font line height across the app, in its own wave.

**Decision.** (c). It is one app-wide font-metrics behaviour, so a per-screen pin would hide it on some screens and
not others.

**Consequences.**
- W15-6 and W16-6 stay as they are until that wave; the Mistakes screens are not pinned.
- The wave does not exist yet: its place in the list is set only by the owner's `FORMULATE`.
- D-018's "Arabic cards measure 90–91" is this behaviour; that wave re-measures it.
- W14-10 (the Arabic underline) is a separate ruling: the app draws the underline itself (KNOWN_BUGS BUG-014).

**Revisit when:** the wave is formulated, or the designer supplies an Arabic frame with its own line heights.

### D-020 · The profile's session boundary is the provider's lifetime (autoDispose), not an invalidation

**Feature:** Profile / session (API→UI Wave 19) · **Date:** 2026-09-27 · **Status:** Accepted, built · **Raised by:**
Wave 19's reproduction of the stale profile (KNOWN_BUGS BUG-015); **decided by** the owner

**Context.** Logging out invalidates `meProvider` while Home and Profile still watch it, so Riverpod rebuilds it with
no token and carries the result into the next session. Riverpod 3 keeps a provider's previous value through every
rebuild; only disposing the element drops it.

**Options.** (a) Make `meProvider` autoDispose: the shell unmounting at sign-out drops it. Costs: every test harness
that passes through Home holds it (`holdProfile`), and the notifier tracks its own disposal. (b) Re-invalidate the
session scope at sign-in (`markAuthenticated`): a smaller change, but a probe showed the second student's Home
painting the first student's name while the new `/me` loaded, and the first profile stays readable in memory while
signed out.

**Decision.** (a).

**Consequences.**
- `meProvider` lives while a screen watches it. Home is always mounted in the shell, so tab switches stay free.
- Harnesses call `holdProfile(container)`; a test that proves the drop must not.
- The sign-out invalidation stays: one token-less rebuild in the frame before the shell unmounts.
- The other session providers were not changed in this wave (BUG-015, "Not changed").

**Revisit when:** another session provider shows the same stale state, or the app gains a session id to key
providers by.

---

## Environment & platform identity

### D-021 · Production platform identifiers, environment count and display names

**Feature:** Environment & Architecture chapter (Wave 0) · **Date:** proposed 2026-10-04, **ratified 2026-10-06** ·
**Status:** **RATIFIED — Android implemented (Wave 1, 2026-10-06); iOS pending Wave 3** · **Raised by:** the identity audit
(`.ai/audits/current/app_identity_environment_audit_2026-10-04.md`) and `docs/ENVIRONMENTS.md` §2

**Context.** Both platform identifiers are `flutter create` template output from the first commit (`5e4a512`,
2026-07-22): Android `applicationId` `com.levelup.level_up_app` (`android/app/build.gradle.kts:43`, the template's
"Specify your own unique Application ID" TODO still above it), iOS `PRODUCT_BUNDLE_IDENTIFIER` `com.levelup.levelUpApp`
(`ios/Runner.xcodeproj/project.pbxproj:371,550,572`). Neither was ever ratified; `RELEASE_SIGNING.md:80-85` says to
confirm the value before the production keystore, the store audit (BS-D-09, BS-C-13, IOS-17) asks for the decision to
be recorded here. The Day-0 spec planned three flavors with a bundle-id suffix each (prom.md Prompt 9,
`Platform_Specifics.md:21-22`); only the Dart half exists. The identifier becomes permanent at the first Play upload /
Apple App ID registration and keys every future Firebase registration. The stores are the client's accounts.

**Options.**
- **Q1 production ids** — (A) ratify the template ids as they are, two spellings forever; (B) one shared lowercase
  alphanumeric token under `com.levelup` on both platforms — the token must come from the owner, nothing in the repo
  names one; (C) a different organisation prefix if the client does not accept `com.levelup`.
- **Q2 installable identities** — three (`<prod>`, `<prod>.staging`, `<prod>.dev`, matching the Dart enum and the
  Day-0 spec) or two (dev shares staging's id).
- **Q3 display names** — proposed `Level Up` / `Level Up STG` / `Level Up DEV`.
- **Q4 supported versions** — confirm Android min 24 / target 36 / compile 36 and iOS 13.0 (`ENVIRONMENTS.md` §3);
  min 24 excludes Android 5.x–6.x devices.

**Engineering recommendation (not a decision).** Q1: B if a token can be named, else A. Q2: three. Q3: as proposed.
Q4: confirm — the dependency set allows nothing lower and the stores require nothing higher.

**Decision (2026-10-06).** Ratified by the owner by forwarding Seif's written reply (which answered Q1–Q3 and added
Q5–Q7) and closing Q4 with the frontend decision. Recorded as answered, not paraphrased:

| | Answer |
| --- | --- |
| **Q1** | **C — a different organisation prefix.** Production Android `applicationId` **`com.levelupworld.app`**; production iOS bundle id **`com.levelupworld.app`**; non-production Android **`com.levelupworld.app.stg`**; non-production iOS **`com.levelupworld.app.stg`**. Same string on both platforms; suffix `.stg` (not `.staging`/`.dev`). Based on the product name and the owned domain `level-upworld.com`, deliberately independent of any person's name and of the still-unknown legal company name. The template ids are dropped. Store registrations and account ownership are *not* decided here. |
| **Q2** | **Two identities** — production + one non-production. No DEV identity; `Flavor.dev` and the mock harness run under the staging identity. |
| **Q3** | Production **`Level Up`**; non-production **`Level Up STG`**; no DEV name. |
| **Q4** | **`Flutter 3.44.7 · Android 24/36/36 · iOS 15.0`.** Android min 24 / target 36 / compile 36 as proposed. iOS: Seif's rule was "the lowest version supported by the pinned Flutter" (13.0 for 3.44.7); the frontend decision chose **15.0** as a more appropriate production baseline that still covers the iPhone generations iOS 15 supports, with the instruction to verify the dependency set against 15.0 before implementation — done, all floors ≤ 13.0 (`ENVIRONMENTS.md` §3.2). |
| **Q5 (Seif, input)** | Production API base URL **not ready**: planned `https://api.level-upworld.com/api/v1`, not deployed, DNS unverified, **not in the contract's `servers:`** (still exactly one entry, staging). The contract stays the announcement channel; the app keeps a production base URL that cannot ship by accident until then. |
| **Q6 (Seif, input)** | Non-production app → staging backend; production app → production backend; **no development backend**. Staging is shared with the web team and may be reset. |
| **Q7 (Seif, input)** | No id checks on API requests; no CORS/OAuth concerns; Firebase: the four ids above must be registered before push, nothing registered, ownership and project sharing unsettled, backend has no Firebase credential and sends no push; no deep links in release 1; website host `level-upworld.com` with `/redeem` opened in the browser (per-flavor config, not hard-coded); one device per account server-side. |

**Engineering choices made under the decision (not identifiers, reversible):** Gradle flavor / future Xcode scheme names are
`prod` and `staging`, mirroring the Dart enum and entrypoint file names; the Android `namespace` / Kotlin package stays
`com.levelup.level_up_app` (never shipped). Rationale in `ENVIRONMENTS.md` §2.0.

**Consequences.** Wave 1 (2026-10-06) implemented the Android half: `productFlavors` `prod`/`staging`, the ids, the
per-flavor names, explicit SDK literals, a Gradle check that refuses a flavor compiled from the wrong entrypoint, the
evolved release-command guard, `ci.yml`/`tool/`/`pre-push` updates and the `RELEASE_SIGNING.md` correction. Every build
command now carries `--flavor` (`ENVIRONMENTS.md` §4). Wave 3 applies the iOS half (schemes, bundle ids, 13.0 → 15.0)
on a Mac. The old `com.levelup.level_up_app` install on test devices is an orphan and can be uninstalled. Firebase and
the keystore remain gated on their own prerequisites (`ENVIRONMENTS.md` §7, §10).

**Revisit when:** never for Q1 after the first store upload (irreversible); Q2–Q3 when an environment is added. **Update (forward link, 2026-10-10):** Seif's reply of 2026-10-09 extends Q5–Q7 (two Firebase projects, production host, APNs path); the text above stays as the record — see `docs/BACKEND_HANDOFF.md` §A, §G.

---

## Completion program — release 1 (2026-10-09)

The owner's 2026-10-09 brief answered the three blocking questions of the pre-execution discovery
(`.ai/audits/current/PRE_EXECUTION_DISCOVERY.md` §14: B-1 pin, B-2 scope, B-3 protocol). Live program state:
`.ai/audits/current/completion/COMPLETION_STATE.md`.

### D-022 · The completion program builds against contract `eddb6ac` (3.46.0-m1)

**Feature:** Completion program (CW01) · **Date:** 2026-10-09 · **Status:** **Accepted — applied (CW01, 2026-10-09)** ·
**Raised by:** discovery B-1; **decided by** the owner

**Context.** Three contract states coexist: committed pin `0df5cf4` (3.28.0-m1, `03fd7cf`); an uncommitted working-tree
re-vendor to `65245be` (3.38.0-m1, blob-identical to upstream); upstream HEAD `eddb6ac` (3.46.0-m1, mirrored
2026-10-08T14:56Z from backend `a158daa`, which staging's `/health/version` also reports). At `eddb6ac`: 86 operations,
all stable, 4 web-only → **82 app-buildable** (PyYAML census, 2026-10-09). An operation is app-buildable when it is
stable and **not** `x-consumers: [web]`; an absent `x-consumers` means mobile (`contract-changelog.md@eddb6ac` ~:586).
A BUILD dry run of HEAD `8e641e9` + the `eddb6ac` files passed: analyze 0, contract guard 14/14, 2067/0, guards 122
(`.ai/audits/current/completion/00_BASELINE.md` §9).

**Options.** (a) stay on `0df5cf4`; (b) commit `65245be`; (c) re-vendor to upstream HEAD.

**Decision.** (c) — `eddb6ac`. `git ls-remote` is re-run immediately before CW01; if upstream has moved, the new commit
and version are reported to the owner and the target does **not** move silently. The re-vendor is its own isolated
change set (contract files + `SOURCE.md` + guard alignment only); `contract/` is edited by nothing else. During it the
false sentence "CRLF exactly as upstream stores them" is corrected — upstream blobs are LF. That sentence stood at line 17
of the 2026-10-07 working-tree edition of `contract/SOURCE.md` (the `65245be` re-vendor), which was never committed;
no committed `SOURCE.md` ever carried it.

**Consequences.** Opens chat, push registration, inbox, friends, support (+photos), custom avatars, recovery, track
transfer, referral, quiz history/favourites. `verifyOtp` gains `403 account_banned` (3.42, behavioural — CW02). The
3.11.0-m1 `retakeWrong` behavioural change stays dormant while the app sends `normal` only.

**Revisit when:** upstream moves before CW01 starts, or Seif announces a release-1 contract freeze.

**Superseded by D-025** (2026-10-14): the completion program now builds against `ded6213` (3.52.0-m1).

### D-023 · Release 1 includes push, chat, the notifications inbox and the Message tab; deletion and banned handling are required

**Feature:** Completion program (CW04–CW13) · **Date:** 2026-10-09 · **Status:** **Accepted — not built** ·
**Raised by:** discovery B-2; **decided by** the owner

**Decision.** Release 1 includes **push notifications, text chat, the notifications inbox and the Message tab**. None of
the four is hidden or dropped to shrink scope. **Account deletion** (request, confirm, cancel, the pending-deletion
state) and **banned-account handling** are required, not deferred; their missing designs and details are requested,
not guessed.

**Rulings that travel with the scope.** Purchase silence stands (D-015, adr-049 §3) — the only exception is the
contract-verbatim "Subscribe to get step-by-step explanations". Chat is text-only under the current contract. No camera
permission and no camera flow. Support attachments follow the contract (JPEG/PNG/WebP and its limits), not Figma's
PDF/10 MB. The student's own leaderboard rank is not shown. Presigned storage uploads use an isolated plain HTTP client,
never the signed-in Dio client (its auth interceptor would send the bearer token to the storage host).

**Still open (not decided here).** Referral reward copy (contract: +10 to the inviter only; Figma: 500 to both) — owner
ruling. Deletion confirm copy — awaits a Seif-approved variant without "paid"/"refund". The Message tab's content
(inbox, chat, or both) — owner + designer. Firebase project ownership and the R-9 registration gate — owner; nothing is
registered in any console without explicit authorisation.

**Revisit when:** the owner changes the release-1 scope, or a store review forces it.

### D-024 · The completion program runs as owner-gated waves with fixed roles and stable IDs

**Feature:** Completion program (all waves) · **Date:** 2026-10-09 · **Status:** **Accepted — in force** ·
**Raised by:** discovery B-3; **decided by** the owner

**Decision.**
- **Roles.** Opus plans and formulates; Sonnet implements and runs subagents (fallback order Opus 4.8 → 4.7 → 4.6 only
  when Sonnet is unavailable or demonstrably unsuitable, reported); Fable audits at agreed checkpoints only.
- **Cycle.** `START WAVE <ID>` → IMPLEMENT → VALIDATE → REVIEW → owner decision → `NEXT WAVE`. Nothing auto-advances.
  Owner verbs: `FORMULATE`, `START WAVE <ID>`, `REVIEW`, `NEXT WAVE`, `WALK`, `STOP`.
- **Wave kinds.** A wave may be a multi-screen flow (when splitting would leave an unusable app), a non-screen
  engineering wave, an environment/iOS/release wave, or an integration/store wave.
- **IDs.** Completion waves `CW00`–`CW20` are stable and never renumbered; splits/reorders are recorded with a reason.
  Historical "Wave 01–22", "Env Wave 1–4" and discovery tracks `T01`–`T21` keep their names and are cross-referenced.
- **Git.** No commit or push without an explicit owner request; never force-push; `dev` frozen; `main` only by
  `--ff-only` on the owner's word; `backup/2026-08-22-dirty-tree` preserved; never `git add -A` while `contract/` is dirty.
- **State.** `.ai/audits/current/completion/COMPLETION_STATE.md` is the live record; `wave_state.md` is closed history
  of the 22-wave API→UI workflow. Checkpoint the state file before context reaches ~40–45%.

**Consequences.** The `NEXT`/`WALK`/`FORMULATE` control rules in `wave_state.md` govern the closed 22-wave list only.

**Revisit when:** the owner changes the protocol.

### D-025 · The completion program builds against contract `ded6213` (3.52.0-m1)

**Feature:** Completion program (wave SEIF1014, change set CV352) · **Date:** 2026-10-14 · **Status:** **Accepted —
applied (SEIF1014 Job 1, 2026-10-14)** · **Raised by:** Seif's messages of 2026-10-12 and 2026-10-13
(`docs/SEIF_MESSAGE_2026-10-12_school-launch-stages.md`, `docs/SEIF_MESSAGE_2026-10-13_school-stages-stable.md`);
**decided by** the owner (the SEIF1014 prompt, 2026-10-14, which authorises this re-vendor and no other version)

**Context.** The pin `eddb6ac` (3.46.0-m1, D-022) predates `listSchoolStages`, the `status` field on
`listEducationSystems` and the registration codes `school_stage_not_available` / `education_system_not_available`.
All three are `stable` from 3.52.0-m1. `git fetch` on 2026-10-14: upstream `origin/main` is `ded6213`; nine mirror
commits carry 3.52.0-m1 (`8ef3306` … `ded6213`). Of the eight after `8ef3306`, only `1b4b0d5` touches a mobile file
(one `contract-changelog.md` entry, the OpenRouter note); the other seven change admin files only, so the four mobile
files are blob-identical from `1b4b0d5` onward. Census at `ded6213` (PyYAML): 89
operations, all `stable`, 4 `x-consumers: [web]` → **85 app-buildable** (82 at `eddb6ac`).

**Decision.** Pin `ded6213` (3.52.0-m1), the newest commit carrying exactly that version. Nothing later exists upstream
today, and a later version would not be authorised. The re-vendor is its own change set (CV352): the four contract
files and `contract/SOURCE.md`, plus the PIN and version rows of `docs/BACKEND_HANDOFF.md`. The files were proven
blob-identical to upstream (`git hash-object` = `git rev-parse ded6213:<file>`, 0 CR bytes) before and after the copy.

**Consequences.** Unblocks the School "Soon" stages and systems (SEIF1014 Job 2). Brings into the pin the four
3.47.0-m1 behavioural changes (their acknowledgment to Seif is still owed, `docs/BACKEND_HANDOFF.md` BH-B4),
`getAppVersionPolicy`, `listMyDailyTasks` (stable since 3.49.0-m1) and the production server in `servers:`. The
follow-ups are listed in `contract/SOURCE.md` ("Delta from 3.46.0-m1"). No bound schema changed shape.

**Supersedes:** D-022.

**Revisit when:** Seif announces a later version the app needs, or a release-1 contract freeze.

### D-026 · School registration reads stage and system status fresh on every visit, and anything not `active` is refused

**Feature:** School registration (wave SEIF1014, change set SSG) · **Date:** 2026-10-14 · **Status:** **Accepted —
applied (SEIF1014 Job 2)** · **Raised by:** Seif's messages of 2026-10-12 and 2026-10-13 and contract 3.52.0-m1
(`listSchoolStages`, `listEducationSystems.status`); **decided by** the owner (the SEIF1014 prompt, 2026-10-14)

**Context.** Which School stages and education systems may register is a server setting that can change with a
redeploy and no app release (`contract-changelog.md`, 3.51.0-m1: "Never hard-code the open set; read it").
Production applies the launch rule (secondary2/3, the two National systems) from its next deploy; staging stays
all-open for test accounts. The app's reference providers were deliberately process-lifetime caches
(`reference_providers.dart`; `session_scope.dart` keeps them across sign-outs), which would keep a stage "Soon" after
the server opens it, or open after it closes.

**Decision.**
1. **Freshness — the one exception to session-cached reference data.** `schoolStagesProvider` and
   `educationSystemsProvider` are `autoDispose`: the statuses are read from the server on every visit to the School
   screen, and again after either `422` (`school_stage_not_available`, `education_system_not_available`). They are
   never hard-coded, defaulted or cached across visits. Every other reference provider keeps its process-lifetime
   cache.
2. **Fail closed.** A row is selectable if and only if its status is exactly `active`. `soon`, an unknown value and a
   stage the response omits are all refused; only `soon` carries the "Soon" / «قريباً» mark. A slow or failed status
   read enables nothing: the field shows its loading, error or offline state with a user-tapped Retry, and **Start
   learning** stays disabled until both lists are loaded. A choice in the draft that is no longer `active` is cleared
   quietly (fresh statuses, a restored draft, or after a `422`).

**Rejected.** Fail-open on a failed status read (would let a closed choice reach a `422` the student cannot
explain); a session cache (would keep stale statuses for a whole session); a hard-coded launch set, even as a
fallback (the contract forbids it). The mock's launch-rule default is test data, not app logic.

**Consequences.** Two extra public GETs per School-screen visit (both under the `/reference` per-address limit). The
University year picker is unchanged in this wave and still reads `universitiesProvider`'s process-lifetime cache
(`contract/SOURCE.md`, 3.47–3.52 follow-up 6).

**Revisit when:** the designer specifies the "Soon" treatment (`docs/DESIGN_ISSUES.md` #133), or Seif changes the
open-set rule.

**2026-10-15 (SEIF1014 follow-up).** The owner set the Arabic mark (and the two refusal messages) to the app's
spelling «قريبًا», the same as `comingSoon`. The designer's light English frames (`1409:26374`, `1409:26436`,
`1409:26495`) now draw the treatment: the mark moved outside the row's dimming (built); the sheet presentation, the
colours and the refusal card wait for tokens, dark and Arabic frames (#133). The refusal frame keeps the refused value
selected; this decision still clears it, because a refused choice is `soon` and cannot stay selected (rule 2).
