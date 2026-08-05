# Contract questions & change requests — for Seif (backend)

> The backend counterpart to `docs/DESIGN_ISSUES.md`. Everything the **contract** can't
> answer, contradicts, or leaves us guessing goes here — one place, so nothing gets lost in
> chat and Seif gets a single list rather than a trickle.
>
> Contract: `contract/openapi.yaml` (vendored, pinned commit 23f0535) · App repo: `level_up_app`
>
> **Ground rule stays: the contract wins.** Where the contract is silent we build the safe
> thing, ship it, and log it here. Nothing in this file blocks a build — it records what we
> assumed and what we need confirmed so the assumption can be replaced.

## Severity
🔴 Blocks a real user flow · 🟠 Shipped on an assumption that may be wrong · 🟡 Confirm / tidy

## Summary

| # | Question | Sev | Status | Code marker |
|---|---|---|---|---|
| S1 | Staging/prod `baseUrl` still `TBD.example` — nothing has ever run against a real server | 🔴 | Open | `app_config.dart:37` |
| S2 | No way to resume an interrupted quiz — `GET /quizzes/{quizId}` is `draft` | 🟠 | Open (Day 7) | — |
| S3 | Level thresholds: `GET /me` returns `level` but no target to progress toward | 🔴 | Open | `level_card.dart:8` |
| S4 | Units/Chapters rows show a % progress the contract cannot supply | 🔴 | Open | `tree_list_row.dart` |
| S5 | Referral / invitation code has no backend field | 🟠 | Open | `registration_draft.dart:18` |
| S6 | Flashcards: full screen designed + sellable entitlement, zero contract support | 🔴 | Open | `quiz_type_tabs.dart` |
| S7 | Quiz timer drawn in the design, no field in the contract | 🟠 | Open | — |
| S8 | Paymob return deep-link scheme/host not specified | 🟠 | Open | `app_router.dart:72` |
| S9 | University Home "Learning Tools" cards have no endpoint in M1 | 🟠 | Open | `home_screen.dart` |
| S10 | `error-codes.md` mapping is per-feature guesswork | 🟡 | Open | `error_interceptor.dart:9` |
| S11 | Favourites: reading state is stable+required, writing it is draft | 🟡 | Open, built around (Day 7) | `quiz_question.dart:50` |
| S12 | Quiz points in the design are ~20× what the contract can award | 🔴 | Open, built around (Day 7) | `answer_result.dart:36` |
| S13 | Result screen shows a "Pass" verdict; no pass threshold exists | 🟠 | Open, built around (Day 7) | `quiz_summary.dart:97` |
| S14 | "Review Questions" needs `GET /quizzes/{quizId}`, which is draft | 🟠 | Open, built around (Day 7) | `quiz_result_screen.dart:130` |
| S15 | Setup draws a question-pool progress bar with no data source | 🟠 | Open, built around (Day 7) | `quiz_setup_screen.dart:24` |
| S16 | Limit sheet says "Daily"; the contract limit is weekly | 🟡 | Open, built around (Day 7) | `limit_sheet.dart:16` |
| S17 | AI explanation is drawn as TWO sections; the endpoint returns ONE string | 🟠 | Open, built around (Day 7) | `ai_explanation_panel.dart:9` |
| S18 | `AnswerResult.pointsDelta` — "original result" vs "0 on retry replay" | 🟢 | Open, no impact | `mock_backend.dart:_submitAnswer` |
| S19 | No quiz endpoint returns a subject name; two frames show one | 🟡 | Open, built around (Day 7) | `quiz.dart:32` |
| S20 | `PATCH /me` cannot edit school or geography — one design option you offered is unbuildable | 🟠 | Open (Day 7c) | `openapi.yaml:614-624` |
| S21 | v1.1 internal inconsistencies found by diffing the vendored contract | 🟡 | Open (Day 7c) | `openapi.yaml:483`, `:1281` |

---

## S1. 🔴 We have never made a single real request

**Where:** `contract/openapi.yaml` `servers:` → `https://staging.TBD.example/api/v1`.
**What:** every flavor points at a placeholder host. `.example` is a reserved TLD, so it fails
closed rather than leaking traffic somewhere real — but it means **every "it works" claim in this
repo is validated only against our own 641-line mock** (`lib/dev/mock_backend.dart`), which by
construction encodes the same assumptions as the client it's mocking.
**Ask:** the real staging host, even an unstable one behind a VPN. One afternoon against a real
server is worth more than another week of mock-green.

## S2. 🟠 An interrupted quiz cannot be resumed

**Where:** `GET /quizzes/{quizId}` — `x-stability: draft`.
**What:** `POST /quizzes` returns the questions once, at creation. If the app is killed mid-quiz
(call comes in, OS reclaims memory, student switches away), there is no stable endpoint to fetch
that quiz back. Answers already submitted via `POST /quizzes/{quizId}/answers` are safely recorded
server-side, but the client cannot rebuild the screen.

**What we built (Day 7):** quiz state is **in-memory only**. An interrupted quiz is lost and the
student starts a new one. We deliberately did **not** cache the `Quiz` payload to Hive, because
`POST /quizzes` explicitly frames the question bank as the product ("correct answers never ship
with questions — content protection"), and writing questions to disk cuts against that.

**Ask Seif:**
1. Is `GET /quizzes/{quizId}` going to be promoted to `stable` in M1? If yes, we wire resume and
   delete the local workaround.
2. If not — is a partially-answered quiz **abandoned** server-side, or does it stay open and keep
   counting against the free plan's 50-questions/week allowance? A student who loses signal twice
   could burn their weekly quota on quizzes they never finished. That is a product problem, not
   just a client one.
3. Related: is there a "abandon/cancel quiz" call we should make on exit, or does the server time
   them out on its own?

## S3. 🔴 `level` has no threshold to progress toward

**Where:** `GET /me` → `StudentProfile.level` (int 1–12), `points` (int).
**What:** Home draws a progress bar toward the next level. The contract gives the current level
and current points, but never the points needed to reach level N+1 — so the bar has a numerator
and no denominator.
**Ask:** either a `nextLevelAt` / `pointsToNextLevel` field on `StudentProfile`, or a static
thresholds table we can hard-code (and a promise it won't move server-side without a contract bump).

## S4. 🔴 Units/Chapters progress % has no source

**Where:** `UniversitySubjectTree` / school tree payloads.
**What:** the Learn drill-down rows are designed with a per-row completion percentage. Nothing in
the tree response carries per-unit or per-chapter completion.
**Ask:** add per-node progress to the tree payload, or confirm the design should drop the bars.
Currently built to render only when a value exists.

## S5. 🟠 Referral / invitation code is collected and thrown away

**Where:** Sign Up_1 (`337:15875`) has an Invitation Code field. `POST /auth/register` has no
matching property in either `SchoolRegistration` or `UniversityRegistration`.
**What:** we render the field (design) but **never submit it** (contract). A student can type a
referral code and it silently evaporates.
**Ask (Seif + PM):** is referral in M1 scope? If yes we need the field on the register body and a
validation error code. If no, the field should come off the design.

## S6. 🔴 Flashcards: fully designed, sellable, and completely unimplementable

> **Upgraded 🟠 → 🔴 after finding the screen.** This is no longer "an entitlement with no
> endpoint" — there is a finished screen and a nav path to it.

**Where:**
- **Screen: `225:5582`.** Frame is *named* "Quiz page"; its title text reads **"Flash cards"**.
  That mismatch is why it survived every name-based search of the file.
- Lectures tab row (Day 6) draws a **Flashcard** tab — `quiz_type_tabs.dart`, `DESIGN_ISSUES.md` #18.
- `EntitlementType.flashcardSubscription` — a thing a student can **buy**.

**What the screen actually is — a second question renderer, not a quiz state:**
- No options list. MCQ uses a four-button container (`308:5152`); flashcards use one component
  instance, `247:3260` "Component 17" (358×454). It being a *component* means the flip/reveal
  states are variants inside it — hence only one flashcard frame in the whole file.
- The AI icon is explicitly `hidden="true"` (`503:6802`); no AI EXPLANATION panel. No explanations.
- Shares the entire session shell with MCQ: progress bar, `1/10` counter, Confirm, nav bar.

**What the contract has: nothing.** Verified across all 33 paths / 36 operations — no flashcard
content endpoint exists. The word "flashcard" appears exactly **three** times in `openapi.yaml`,
and all three are about *selling* it, never about using it:
- `openapi.yaml:1342` — `EntitlementType: [baseSubscription, flashcardSubscription]`
- `openapi.yaml:1002` — `/checkout/sessions`: *"School students requesting flashcardSubscription
  get `insufficient_scope` (**university-only**)"*
- `openapi.yaml:1027` — the matching 403 on that checkout call

**Flashcards are university-only.** That constraint lives only in a checkout description. It is
consistent with the Flashcard tab sitting on the university Lectures screen, but it should be
stated somewhere a client can act on, not buried in a payment endpoint's prose.

**The orphan error code — this is the strongest evidence something was dropped.**
`contract/error-codes.md:13` defines:

| `flashcard_subscription_required` | 403 | Flashcards require `flashcardSubscription` | University-only |

**No endpoint in the contract can ever return this code.** Error codes do not get invented
speculatively — a bespoke 403 for "you tried to use flashcards without the subscription" implies an
endpoint that *would* serve flashcards was specified and then dropped or lost.

So: a student can pay for `flashcardSubscription`, see a Flashcard tab, reach a finished screen,
and there is no call we can make to fill it. (And `/checkout/sessions` is itself `draft`, so in M1
they cannot even complete the purchase that leads nowhere.)

**What we built (Day 7):** MCQ renderer only, behind a `QuestionRenderer` seam so a flashcard
renderer drops in later without touching the screen, the Bloc or the tests. No stub, no
`isFlashcard` flag, no invented enum member.

**Ask Seif — this one needs a decision, not just an answer:**
1. **Lead with the orphan code:** `flashcard_subscription_required` is defined in `error-codes.md`
   but no endpoint can return it. **Where did the flashcard endpoint go?** That is much harder to
   wave away than "are flashcards in M1?", and the answer probably explains everything else here.
2. If flashcards are in M1: we need the question shape (front/back text? image + prompt + answer?
   self-graded or server-graded?) and a build/serve endpoint.
3. If they are not — **`flashcardSubscription` must not be sellable**, and the Flashcard tab plus
   screen should come out of the design until it is. Selling access to a screen that cannot load is
   worse than not offering it at all.
4. Either way: does answering a flashcard award points? `pointsDelta` assumes a graded MCQ.
5. Confirm **university-only** is intended, and move that rule somewhere a client can read it
   rather than leaving it in a checkout endpoint's description.

## S7. 🟠 Quiz timer: designed, not specified

**Where:** quiz-taking frames show a countdown. `Quiz` / `QuizQuestion` carry no duration.
**Ask:** is the timer server-authoritative (a per-quiz or per-question limit we must enforce and
that `finish` validates), or purely cosmetic pacing? These are very different builds, and if the
server ever enforces it, a client-only timer is a cheating vector.

## S8. 🟠 Paymob return deep link is undefined

**Where:** `app_router.dart:72` `TODO(deep-link)`; route `/subscription/return` is a placeholder.
**What:** the contract says checkout "returns via deep link" but never gives the scheme or host.
**Ask:** the exact scheme/host, and confirmation of the security model. **We will treat the return
link as a hint to refetch, never as proof of payment** — on return the client re-queries
`GET /me/entitlements` and trusts only the server. Any app on the device can fire that intent, so
if the intended design is "trust the deep-link payload", say so now and we will push back.

## S9. 🟠 "Learning Tools" cards have nothing behind them

**Where:** University Home (`125:2373`).
**What:** the frame draws a Learning Tools section with no matching M1 endpoint. Built as a
stub/hidden section (DESIGN_ISSUES #20).
**Ask (Seif + PM):** M1 or later? If later, hide it in the design too.

## S10. 🟡 Error-code mapping is being reverse-engineered per feature

**Where:** `error_interceptor.dart:9`.
**What:** every non-2xx is RFC 9457 ProblemDetails with a stable `code`, which is good — but we
are discovering the code set feature by feature from endpoint descriptions rather than working
from `error-codes.md` as a whole.
**Ask:** the current `error-codes.md`, vendored alongside `openapi.yaml` and versioned with it, so
our mapping can be exhaustive instead of incremental.

## S11. 🟡 Favourites: half a feature

**Where:** `QuizQuestion.isFavorite` is in the **required** list on `POST /quizzes` (stable).
`POST`/`DELETE /questions/{questionId}/favorite` and `GET /me/favorites` are all **draft**.
`mode: favorites` is in the stable `POST /quizzes` enum.

**What:** reading favourite state is stable and mandatory; writing it is draft. So every question
we render carries a flag no student can ever set — `isFavorite` will be `false` for everyone, for
all of M1 — and `mode: favorites` is a stable mode whose only pool is filled by draft endpoints.
The design *does* draw the control (bookmark icon, node `295:3139`, in the quiz header).

**What we built (Day 7):** `isFavorite` is parsed into the model (it's required), no control is
rendered, `mode: favorites` is not offered.

**Ask:** is favourites in M1? If yes, promote the three endpoints and we ship the star. If no, make
`isFavorite` optional and drop `favorites` from the mode enum, so the contract stops advertising a
feature that cannot work — and tell the designer to pull the icon.

## S12. 🔴 Quiz points: the design promises ~20× what the contract can award

**Where:** setup frame previews "Questions: 10 · Points: **+30**"; the result frame shows
"**+200** Points". Contract: `AnswerResult.pointsDelta` is *"0 or 1"*, and `submitAnswer` says
*"+1 per correct"*.

**What:** a 10-question quiz can award **at most 10 points**. A student shown "+200" and given 7
will consider it a bug — and it is, on one side or the other.

**What we built (Day 7):** no client-side points arithmetic at all. The setup preview is **omitted**;
the result screen renders `pointsAwarded` verbatim.

**Ask:** is the award rule really 1/correct, or is there a multiplier (quiz length? difficulty?
streak?) that the contract doesn't express? If there is a multiplier, `pointsDelta` needs to carry
it. If there isn't, the design's numbers need to come down.

## S13. 🟠 The result screen declares "Pass" with no threshold to pass

**Where:** result frames `159:1964` / `309:6375` render "50% — **Pass**". Nothing in `QuizSummary`
or anywhere else defines a passing score.

**What we built (Day 7):** the percentage ring only. **No Pass/Fail word** — we will not invent an
academic threshold and show it to a student.

**Ask:** is there a pass mark? Is it global, per-subject, or per-track? If it exists it belongs in
`QuizSummary` (or a static rule we can hard-code with a contract note). Deferred until answered.

## S14. 🟠 "Review Questions" is blocked by a draft endpoint

**Where:** result frames draw a **Review Questions** CTA. Reviewing needs
`GET /quizzes/{quizId}` — the only endpoint that returns correct answers for a finished quiz
(`openapi.yaml:822`) — and it is `draft`.

**What we built (Day 7):** the button renders **disabled** with a "coming soon" affordance, so the
screen matches the frame and there is zero rework on promotion.

**Ask:** promoting `GET /quizzes/{quizId}` unblocks review **and** quiz resume (S2) in one move.
It is the single highest-value promotion for the quiz feature.

## S15. 🟠 Setup draws a question-pool progress bar with no data source

**Where:** setup frames `135:1622` / `309:5771` — *"QUESTION POOL PROGRESS · 45 out of 100
questions · 55 questions remaining in pool"*.

**What:** nothing exposes a per-scope pool size or how much of it a student has consumed.
`POST /quizzes` only reveals the pool was too small *after* the fact, via 422
`not_enough_questions`.

**What we built (Day 7):** the card is **hidden**. We will not fabricate a denominator.

**Ask:** can the lesson/lecture node in the catalog tree carry `questionCount` and
`answeredCount`? (`UniversitySubjectTree.lectures[].questionCounter` already exists — is that the
same idea, and does it extend to school lessons?) Otherwise the card should come out of the design.

## S16. 🟡 "Daily Limit Reached" vs a weekly contract limit

**Where:** limit frames `199:2335` / `225:6634` / `225:7001` say *"Daily Limit Reached"*.
Contract: *"Free plan: 50 questions/WEEK"*, error code `weekly_question_limit_reached`.

**What we built (Day 7):** **weekly** copy — the server owns the rule and the code name agrees.

**Ask:** confirm weekly is correct, then the designer updates the frames. If it is genuinely a
daily cap, the error code is misnamed and needs a contract change.

---

## S17. 🟠 The AI explanation is designed as two sections; the endpoint returns one string

**Where:** quiz frame `159:1695`. The AI EXPLANATION panel renders **two labelled bodies**:
*"WHY IS THIS WRONG?"* (`159:1828`, with its own paragraph at `159:1831`) and *"WHY IS THE CORRECT
ANSWER RIGHT?"* (`159:1835`, paragraph `159:1838`). They are separate cards with different heading
colours and genuinely different content in the mock copy.

**Contract:** `GET /questions/{questionId}/explanation` → `200` is
`{ status: "ready", text: string }`, `required: [status, text]` (`openapi.yaml:914`–`919`).
**One string. No second field, no delimiter, no schema hint that `text` has internal structure.**

**Why this cannot be worked around client-side:** splitting the string on a heuristic (blank line,
first sentence, a "because" clause) would invent a response format GPT-4o-mini never promised. The
generator is an LLM — the first time it phrases an answer as one paragraph, or leads with the
correct answer, the split silently produces nonsense in a labelled box a student will trust.

There is a second problem the design does not address: *"WHY IS THIS WRONG?"* is meaningless when the
student answered **correctly**. The frame only ever shows the wrong-answer case.

**What we built (Day 7):** the panel, its header and its card chrome exactly as drawn, with `text`
rendered verbatim in **one** section and both sub-headings omitted. Owner decision. When the field is
split this becomes two of the same card and nothing above it moves.

**Ask (either is fine, pick one):**
1. Split the response — `{ status, whyWrong?, whyCorrect? }`, both optional so a correct answer can
   omit the first; or
2. Confirm one free-text explanation is the intent, and the designer collapses the two boxes into
   one.

---

## S18. 🟢 `pointsDelta` on a retry: "the ORIGINAL result" or "0"?

**Where:** `openapi.yaml:845`–`850` (operation description) says a retry *"returns the ORIGINAL
result"*. The field doc at `:1443` says `pointsDelta` is *"0 or 1 (server-side award; **0 on retry
replay** or free-plan edge)"*.

If `pointsDelta` becomes 0 on replay, the response is not literally the original result. The two
sentences describe different things and the more specific one is presumably right.

**Impact: none, today.** The app never sums `pointsDelta` — the only points figure it renders is
`QuizSummary.pointsAwarded` from `finish` (see S12). This is logged so it does not get discovered
later by someone who *does* try to use it, e.g. for an in-quiz running total.

**What we built:** the mock backend implements the field doc — the replay returns the original
`correct`/`correctOptionId` with `pointsDelta: 0`.

**Ask:** low priority. Confirm which sentence governs, and reword the other.

---

## S19. 🟡 No quiz endpoint returns a subject name, but two frames show one

**Where:** setup `135:1622` renders *"Biology"* above *"Cell Membrane"* (nodes `146:2289` /
`146:2291`); the result frame `159:1964` renders *"Biology — Cell Structure"*.

**Contract:** `Quiz` carries `scopeName` and nothing else identifying (`openapi.yaml:1432`).
`QuizSummary` carries **neither** a subject nor a scope (`:1446`). `QuizHistoryItem` and `QuizReview`
both *do* have `subjectName` — so the field exists in the contract's vocabulary, just not on the two
schemas these screens have.

Client-side it is reachable only from `GET /catalog/subjects`, four screens up the Learn stack, and
plumbing it would mean changing screens Day 7 is explicitly not allowed to touch.

**What we built (Day 7):** both screens title themselves with `scopeName` alone; the result screen
gets it forwarded from the `Quiz` in the route's `extra`.

**Ask:** add `subjectName` to `Quiz` and to `QuizSummary` (it is already on two sibling schemas), or
confirm scope-only titling and the designer drops the subject line.

---

## S20. 🟠 `PATCH /me` cannot edit school or geography — so one of the three options you offered the designer is unbuildable

**Where:** your partner notice of 2026-07-30 asks the UI/UX partner: *"How does the profile screen
render a student with no school? Blank row, hidden row, or an 'أضف مدرستك' prompt?"*

**Contract:** `PATCH /me` accepts exactly five fields — `name`, `email`, `avatarId`,
`leaderboardVisible`, `scoreHidden` (`openapi.yaml:614-624`). There is no school field, no
geography field, and no other endpoint that writes either. **School and geography are immutable
after registration in v1.1.**

So the third option is not implementable. If the designer picks "أضف مدرستك", we will be asked to
build a prompt with nothing behind it — a button that can only ever open a dead end. The first two
options (blank row / hidden row) are both fine and cost nothing.

This is worth answering **before** the design revision rather than after, because it is cheaper to
remove an option from a question than to remove a screen from a build.

**Ask — two questions:**
1. Is post-registration school selection intended at all in M1? (adr-028 §2 makes the field
   optional at registration, which is exactly the situation that creates students who might want to
   add one later.)
2. If yes: does `PATCH /me` gain `schoolId`, or does a separate endpoint appear? Either way it
   needs a pinned contract commit before we build against it.

The same question applies, more weakly, to the free-text city: a student who used the adr-028 §1
fallback has no way to upgrade to a coded city once their city is added to the list.

---

## S21. 🟡 Three internal inconsistencies in v1.1, found by diffing `23f0535..ee2ed8f`

None of these blocks Day 7c — all three were built around, following the prose over the schema.
Listed so the document and the implementation do not drift apart.

**1. `anyOf` permits what the prose forbids.** `SchoolRegistration` (`:1281-1283`) and
`UniversityRegistration` (`:1306-1308`) express the city union as:

```yaml
anyOf:
  - required: [cityId]
  - required: [cityName]
```

`anyOf` is *at least one* — a body carrying **both** satisfies this schema. The prose on both
fields says both → `validation_failed`. A strict schema validator and the server would disagree.
`oneOf` says what the descriptions say. **We built the prose:** the body factory throws on both,
so it never reaches you.

**2. `/reference/schools` still describes free-text school as the non-Egypt path** (`:483-484`):
*"non-Egypt students use optional free text in registration instead (adr-010, never blocked)"* —
which adr-028 §2 cancelled outright three lines of diff earlier
(`SchoolRegistration`, `:1258`: *"Free-text `schoolName` does not exist on this contract"*). The
path description was not updated. Harmless to us; misleading to the next reader.

**3. `rate_limited` is documented on 3 of the 6 `/reference/*` paths.** The changelog says these
paths carry a per-IP limit because they are unauthenticated by design, and the response
descriptions themselves say *"unauthenticated per-IP limit on /reference/\*"* — but the `429` is
only declared on `/reference/countries`, `.../governorates` and `/reference/cities`.
`/reference/schools`, `/reference/education-systems` and `/reference/universities` have none.
`/reference/schools` is the one that matters: it is the only *paginated* reference endpoint, so it
is the one a client can hammer. **We handle 429 on all of them** (the interceptor is path-agnostic)
and the mock triggers it on schools too.

**Ask:** confirm the limiter covers all six, and declare the `429` on the other three — or say it
is genuinely scoped to three and we will stop expecting it elsewhere.

**Also worth noting, not a defect:** the changelog says *"six corrupted schema descriptions
fixed"*; the diff contains **five** (`TokenPair.accessToken`, `SchoolRegistration.email`,
`StudentProfile.badges`, `PATCH /me`'s `email`, `QuizQuestion.imageUrl`). `StudentProfile.email`
had no description in v1.0 and has none in v1.1, so there was nothing there to repair. No impact —
we hand-write models rather than generating from the document, and none of the five was
transcribed from the corrupted text (verified field-by-field in Day 7c section 0).

---

## How to use this file

- New question → add a row to the summary table **and** a section, with the `file:line` marker if
  code already carries an assumption.
- Answered → mark **Resolved** in the Status column, strike the row, keep the section (the
  reasoning is worth more than the tidiness) and delete the `TODO(contract)` marker in code.
- Anything here that turns into a contract change needs a new pinned commit in
  `contract/openapi.yaml` and a note in `contract-changelog.md` before we build against it.
