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
