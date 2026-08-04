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
