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
**Feature:** Quiz (Day 7) · **Date:** 2026-07-30 · **Status:** Accepted · **Raised by:** Claude Code during Day 7 planning

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
