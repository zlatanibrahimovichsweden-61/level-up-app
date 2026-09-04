# Contract questions & change requests — for Seif (backend)

> The backend counterpart to `docs/DESIGN_ISSUES.md`. Everything the **contract** can't
> answer, contradicts, or leaves us guessing goes here — one place, so nothing gets lost in
> chat and Seif gets a single list rather than a trickle.
>
> Contract: `contract/openapi.yaml` (vendored, pinned commit 184d6ec — v3.0.0-m1, 2026-09-04) · App repo: `level_up_app`
>
> **Ground rule stays: the contract wins.** Where the contract is silent we build the safe
> thing, ship it, and log it here. Nothing in this file blocks a build — it records what we
> assumed and what we need confirmed so the assumption can be replaced.

## Severity
🔴 Blocks a real user flow · 🟠 Shipped on an assumption that may be wrong · 🟡 Confirm / tidy

## Summary

| # | Question | Sev | Status | Code marker |
|---|---|---|---|---|
| ~~S1~~ | ~~Staging/prod `baseUrl` still `TBD.example` — nothing has ever run against a real server~~ | 🔴 | **Resolved (2026-08-23)** — 12/21 stable ops decoded against staging `0b53cdc` | `app_config.dart:43` |
| S2 | No way to resume an interrupted quiz — `GET /quizzes/{quizId}` is `draft` | 🟠 | Open (Day 7) | — |
| ~~S3~~ | ~~Level thresholds: `GET /me` returns `level` but no target to progress toward~~ | 🔴 | **Resolved by contract prose (2026-09-04)** — `StudentProfile.level`: "thresholds every 500 points; static, not configurable" | `level_card.dart:21` |
| S4 | Units/Chapters rows show a % progress the contract cannot supply | 🔴 | Open | `tree_list_row.dart` |
| S5 | Referral is a designed SCREEN with no contract, not the stray signup field we filed | 🟠 | Open (upgraded Day 8) | `registration_draft.dart:18`, `refer_a_friend_screen.dart` |
| S6 | Flashcards: full screen designed + sellable entitlement, zero contract support | 🔴 | Open | `quiz_type_tabs.dart` |
| S7 | Quiz timer drawn in the design, no field in the contract | 🟠 | Open | — |
| ~~S8~~ | ~~Paymob return deep-link scheme/host not specified~~ | 🟠 | **Withdrawn (2026-09-04)** — adr-049: there is no in-app checkout, so there is no return link to specify | — |
| S9 | University Home "Learning Tools" cards have no endpoint in M1 | 🟠 | Open | `home_screen.dart` |
| S10 | `error-codes.md` mapping is per-feature guesswork | 🟡 | Open | `error_interceptor.dart:9` |
| S11 | Favourites: reading state is stable+required, writing it is draft | 🟡 | Open, built around (Day 7) | `quiz_question.dart:50` |
| S12 | Quiz points in the design are ~20× what the contract can award | 🔴 | Open, built around (Day 7) | `answer_result.dart:36` |
| S13 | Result screen shows a "Pass" verdict; no pass threshold exists | 🟠 | Open, built around (Day 7) | `quiz_summary.dart:97` |
| S14 | "Review Questions" needs `GET /quizzes/{quizId}`, which is draft | 🟠 | Open, built around (Day 7) | `quiz_result_screen.dart:130` |
| S15 | Setup draws a question-pool progress bar with no data source | 🟠 | Open, built around (Day 7) | `quiz_setup_screen.dart:24` |
| S16 | Limit sheet says "Daily"; the contract limit is weekly | 🟡 | Open, built around (Day 7) | `limit_sheet.dart:16` |
| S17 | AI explanation is drawn as TWO sections; the endpoint returns ONE string | 🟠 | Open, built around (Day 7) | `ai_explanation_panel.dart:9` |
| ~~S18~~ | ~~`AnswerResult.pointsDelta` — "original result" vs "0 on retry replay"~~ | 🟢 | **Resolved (2026-09-04)** — adr-102 D2: the field doc governs; a replay returns `pointsDelta: 0`, which the mock already did | `mock_backend.dart:_submitAnswer` |
| S19 | No quiz endpoint returns a subject name; two frames show one | 🟡 | Open, built around (Day 7) | `quiz.dart:32` |
| S20 | `PATCH /me` cannot edit school or geography — one design option you offered is unbuildable | 🟠 | Open (Day 7c) | `openapi.yaml:614-624` |
| S21 | v1.1 internal inconsistencies found by diffing the vendored contract | 🟡 | Open (Day 7c) | `openapi.yaml:483`, `:1281` |
| S24 | Solved Questions — no lifetime answered counter exists anywhere | 🔴 | Open (Day 8) | — (omitted) |
| S25 | Rank "HERO" — no rank tier string; `level` is an int and `badges` is an int | 🔴 | Open (Day 8) | — (omitted) |
| S26 | Settings Mode draws three themes; the app has two palettes | 🟠 | Open (Day 8) | `settings_screen.dart` |
| S27 | Show Rank is one switch; the contract has two independent booleans | 🟠 | Open (Day 8) | `settings_screen.dart` |
| S28 | Notification Preferences — four toggles, nothing persists them | 🟠 | Open (Day 8) | `settings_screen.dart` |
| S29 | Upload photo — `PUT /me/avatar` is draft AND moderated | 🟠 | Open (Day 8) | `avatar_sheets.dart:121` |
| S30 | Privacy & policy / Terms — no endpoint needed, but NO COPY SUPPLIED | 🟠 | Open (Day 8) | `profile_screen.dart` ×2, `legal_document_screen.dart` |
| S31 | Go to Uni — track switching; no endpoint, and adr-003 makes it a data-model question | 🔴 | Open (Day 8) | `profile_screen.dart` |
| S32 | "your progress" — a designed screen with no endpoint of any kind | 🟠 | Open (Day 8) | `profile_screen.dart` |
| S33 | Customer Support — fully designed, zero endpoints | 🟠 | Open (Day 8) | `customer_support_screen.dart` |
| S34 | **`parentPhone` is WRITE-ONLY** — required at registration, absent from `GET /me` | 🔴 | Open (Day 8) | — (row not built) |
| S35 | `GET /me` returns raw wire codes with no display names | 🟠 | Open (Day 8) | `edit_profile_screen.dart` |
| S36 | A `Friends` screen exists, with no endpoint and no entry point | 🟡 | Open (Day 8) | `friends_screen.dart` |
| S37 | **Staging does not serve two stable routes** — `PATCH /me` 405, `/me/entitlements` 404 (`/catalog/subjects` deployed since 2026-09-03) | 🔴 | Open, narrowed (2026-09-04) | `tool/smoke/real_api_smoke_test.dart` |
| S38 | **Account deletion has no endpoint** — required by Google Play and Apple 5.1.1(v); never filed until now | 🔴 | Open (2026-09-04) | `docs/STORE_READINESS.md` §6 |

> **S22 and S23 were never allocated.** Not a gap in the record — the numbers were skipped when
> the Day 8 brief reserved S24 onward. Nothing is missing; do not renumber to close it, because
> every `TODO(contract)` in `lib/` and the partner notice both cite these numbers.

---

## S1. 🔴 We have never made a single real request

**Where:** `contract/openapi.yaml` `servers:` → `https://staging.TBD.example/api/v1`.
**What:** every flavor points at a placeholder host. `.example` is a reserved TLD, so it fails
closed rather than leaking traffic somewhere real — but it means **every "it works" claim in this
repo is validated only against our own 641-line mock** (`lib/dev/mock_backend.dart`), which by
construction encodes the same assumptions as the client it's mocking.
**Ask:** the real staging host, even an unstable one behind a VPN. One afternoon against a real
server is worth more than another week of mock-green.

**Resolved 2026-08-23.** The host is `https://level-up-backend-staging.up.railway.app/api/v1`
(`app_config.dart:43`, verbatim from the contract's `servers:` block). The smoke harness
decoded 12 of the 21 stable operations against backend commit `0b53cdc` through the real
client seam; every answer arrived either as a model or as a typed `AppException`. What the
server does *not* yet serve is S37.

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

**Update 2026-09-04 — answered by the contract itself, and had been for a while.**
`StudentProfile.level` carries the description *"1–12, thresholds every 500 points; static, not
configurable."* (`openapi.yaml:1514` at the 3.0.0-m1 pin, and already present at 2.1.0-m1), and
adr-102's changelog entry restates it as the result-frame meter formula `(points.total mod 500) / 500`.
That is the static thresholds table plus the no-move promise this entry asked for. `level_card.dart`
already builds the Home bar on it (`kPointsPerLevel = 500`, `kMaxLevel = 12`). Closed; nothing further
owed — the entry stayed open only because nobody re-read the field description after Day 4.

## S4. 🔴 Units/Chapters progress % has no source

**Where:** `UniversitySubjectTree` / school tree payloads.
**What:** the Learn drill-down rows are designed with a per-row completion percentage. Nothing in
the tree response carries per-unit or per-chapter completion.
**Ask:** add per-node progress to the tree payload, or confirm the design should drop the bars.
Currently built to render only when a value exists.

## S5. 🟠 Referral is a designed product surface, not a stray signup field

> **Upgraded 2026-08-06 (Day 8).** This was filed as one orphaned input. It is bigger than that.

**Where:** Sign Up_1 (`337:15875`) has an Invitation Code field. `POST /auth/register` has no
matching property in either `SchoolRegistration` or `UniversityRegistration`.
**What:** we render the field (design) but **never submit it** (contract). A student can type a
referral code and it silently evaporates.

**What Day 8 found.** The Account cluster contains a whole **`Refer a Friend`** screen. So referral
is not a leftover field somebody forgot to delete — it is a feature with an entry point on the
Profile hub, a screen, a sharing flow and an implied reward, and **none of it has a contract**.
That changes the question from "should we keep this input" to "is this feature in milestone 1".

There are three parts, and they are separable:

| Part | What it needs |
|---|---|
| Accepting a code at signup | a field on `POST /auth/register` + an error code for an invalid one |
| Handing a student their own code | something on `GET /me`, or an endpoint that mints one |
| Paying the reward | an attribution model — who gets what, when it lands, which point pool (adr-003) |

We are shipping `Refer a Friend` as a **disabled shell** (`lib/features/account_shells/screens/refer_a_friend_screen.dart`)
— the screen renders, the share control is dead. Deliberately **no invented code**: a plausible
string is the one thing on that screen a student would act on, and they would share something
meaningless with their friends.

**Ask (Seif + PM):** in or out. If in, all three rows above need answers and the middle one is the
blocker for us. If out, the field comes off Sign Up_1 and the screen comes out of the design —
either is fine; today's state is not, because we are asking students for something we discard.

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

**Update 2026-09-04 — withdrawn.** Contract 2.2.0-m1 (adr-049) deleted `POST /checkout/sessions`
and made the app **purchase-silent**: every purchase happens on the website, and there is no deep-link
return. The `/subscription/return` placeholder, the `TODO(deep-link)` in `app_router.dart` and the
disabled Profile "Subscription" row went with the rest of the purchase surface. The security stance
above — a return link is a hint to refetch, never proof of payment — survives as the on-resume refetch
of `GET /me/entitlements`, which is the only entitlement signal the app now acts on.

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

**Update 2026-09-04 — resolved by adr-102 D2 (3.0.0-m1 changelog).** The field doc governs:
`pointsDelta` reports what THIS call awarded, and a replay awards nothing, so it returns `0`. The
server had been returning the original award and was corrected; `openapi.yaml` is unchanged and
`submitAnswer` carries no `x-behaviour-changed` stamp because the published text already said so.
The mock backend implemented the field doc from the start (`_submitAnswer`: `'pointsDelta': replay ?
0 : …`), so nothing changed on our side. Verdict, correct option and explanation flag stay
byte-identical on a replay.

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

## S24. 🔴 "Solved Questions — 300" has no source anywhere in the contract

**Where:** Profile (`166:4416`) draws a lifetime solved-questions counter.
**What:** `StudentProfile` carries `points {school, university, total}`, `level` and `badges`. There
is **no answered/solved counter**. `SubjectTree` has per-node `answered`/`total`, but that is per
subject, per track, and summing it client-side would be both wrong (it counts nothing outside the
loaded tree) and expensive (it needs every subject fetched).

**What we built (Day 8 step 1): nothing.** The card is **omitted outright** — the rule since S12
(quiz points off by 20×) is that a displayed number comes from the server verbatim or does not
render. **There is no code marker to grep**, because there is no code: an omission leaves nothing
behind.

**Ask:** is this a real product concept? If yes it belongs on `GET /me` — it is a profile fact, not
a leaderboard fact, and a student should see it from cache while offline. If no, it comes off the
frame.

## S25. 🔴 "Rank — HERO" is a tier name the contract cannot produce

**Where:** Profile (`166:4416`) draws a rank *tier*.
**What:** the contract has `level` (integer 1–12) and `badges` (integer, post-level-12 milestones).
There is no rank string and no tier enum. `GET /leaderboard/me` is the only endpoint that might
plausibly have carried one — it is `draft`, and its schema does not have it either.

**What we built: nothing**, same as S24, and for the same reason. A card rendering "—" was the
alternative and is worse: a visible blank invites the next person to fill it in with a guess. **No
code marker.**

**Ask:** is `HERO` a tier system (a mapping from level or points to a name, which the server must
own so it can be changed without an app release), or is it design flavour text? If it is real it
needs to be on `GET /me` next to `level`. Related and still open: **S3** — `level` has no threshold
table, so we render level 8 with no way to say what reaches level 9.

## S26. 🟠 Settings "Mode" draws three themes; the app has two

**Where:** Setting (`176:1840`) draws three colour circles under **Mode**.
**What:** `AppColors` has exactly two canvases — light `#FCFBF9` / green `#384F47` and dark
`#232428` / purple `#AE87E7` — and the whole Day 7b fidelity pass was measured against those two.
A third would mean inventing roughly fifty token values and calling the result a design.

**What we built:** **two** options, wired to a real theme switch. Also in `DESIGN_ISSUES.md` #45,
because this one is the designer's to answer, not Seif's.

**Ask (designer):** what is the third circle? If it is "follow the system", that is a mode and not
a palette and we will build it as one. If it is a third palette, it needs tokens.

## S27. 🟠 "Show Rank" is one switch where the contract has two booleans

**Where:** Setting (`176:1840`) draws a single **Show Rank** toggle.
**What:** `PATCH /me` accepts **`leaderboardVisible`** (am I listed at all) and **`scoreHidden`**
(listed, but with my score suppressed) — `openapi.yaml:620-621`, defaulted `true`/`false` by
adr-023 at `:1380-1382`. They answer different questions and they default differently. One switch
cannot express two independent booleans, and mapping one control onto both would mean **silently
choosing a privacy policy on behalf of a minor**.

**What we built:** **both** toggles, each labelled with a line explaining what it does, each
sending only its own field. Also in `DESIGN_ISSUES.md` #46.

**Ask (designer):** confirm two rows is right, or tell us which single policy the one switch was
meant to express.

## S28. 🟠 Notification Preferences — four toggles, nothing stores them

**Where:** Setting (`176:1840`) — Announcements · Promotions · Support · System.
**What:** nothing in the contract persists a notification preference. `PUT /me/fcm-token` is a
**device token**, not a preference set, and it is `draft` besides.

**What we built:** all four render **disabled and off**. Off rather than on because any value we
displayed would be a state we invented; a switch that slides and then forgets is worse than one
that visibly cannot move.

**Ask:** if notification preferences are milestone 1, they need somewhere to live. The natural home
is an object on `PATCH /me` beside the privacy toggles — same kind of per-student setting, same
endpoint, no new path. Related: the Home bell's unread dot has been gated behind a permanently
false flag since Day 7b pending any notifications endpoint, and there is a `Notifications` frame in
this cluster we have not built.

## S29. 🟠 "Upload photo" needs an endpoint that is draft *and* moderated

**Where:** Edit Profile's avatar sheet (`180:3989` variants) offers **Upload photo** and **Use
Avatar**. Code: `lib/features/profile/widgets/avatar_sheets.dart:121`.
**What:** `GET /reference/avatars` + `PATCH /me { avatarId }` are both stable, so **Use Avatar
works**. `PUT /me/avatar` is `draft`, and adr-021 makes it *moderated* (SafeSearch) — which means
even once it stabilises, an upload is not synchronously "set". The UI has to express a pending
state that nothing in the contract currently describes.

**What we built:** Use Avatar opens the existing Day 2 picker; Upload photo renders disabled.

**Ask:** two things, and the second is the one that will bite. (1) Is `PUT /me/avatar` milestone 1?
(2) When it lands, **what does the client show between upload and approval** — does `GET /me`
return the old avatar, the new one optimistically, or a status field? A moderated write needs a
readable moderation state or the screen has to guess.

## S30. 🟠 Privacy & policy and Terms & Conditions have no text

**Where:** Profile (`166:4416`) rows 7 and 8. Code: `lib/features/profile/screens/profile_screen.dart`
(both rows) and `lib/features/account_shells/screens/legal_document_screen.dart`.
**What:** **not a contract gap** — neither document needs an endpoint. They need *text*, in Arabic
and English, and nobody has supplied any or owns supplying it.

This is in this file rather than only in `DESIGN_ISSUES.md` because it is a **milestone-1 blocker
with no owner**, which is exactly the kind of item that drifts until it is a launch problem. An app
for minors that ships without a privacy policy is not a design nit.

**What we built:** both rows navigate to a shared screen carrying a `TODO(content)` and one line
saying the document has not been published. **We did not write legal copy** — text that binds a
minor's guardian is not something an implementer invents, and a plausible placeholder is more
dangerous than an empty page because it looks reviewed.

**Ask (PM/legal, not Seif):** who is writing these, and do they ship as bundled asset text or as
something the server serves? If the latter it becomes a contract item and comes back to you.

## S31. 🔴 "Go to Uni" switches track — and adr-003 makes that a data-model question

**Where:** the `Go to Uni` dialog (`180:4301`): *"Are you sure you want to convert to Uni Track?"*
Code: `lib/features/profile/screens/profile_screen.dart`.
**What:** track is fixed at registration by a discriminated body (`SchoolRegistration` |
`UniversityRegistration`) whose two arms have different **shapes** — adr-010 gives university no
country field. There is no endpoint, and `PATCH /me` cannot express it.

The missing route is the easy half. The hard half is **adr-003 dual point pools**:

- Does the school pool survive, transfer, or reset?
- `points.total` is your sum — does it keep counting the abandoned pool?
- Does `level` recompute, and can a student's level go **down** as a result?
- What happens to entitlements bought against the old track?

**What we built:** the dialog, with **Confirm disabled**.

**Ask:** this is a product decision before it is an endpoint. Even "not milestone 1" is an answer we
can build to — we would then take the row off the hub rather than showing a dialog nobody can
complete.

## S32. 🟠 "your progress" — a designed screen with no endpoint of any kind

**Where:** a `your progress` frame in the Account cluster, reached from the Profile hub.
Code: `lib/features/profile/screens/profile_screen.dart`.
**What:** `GET /me` carries points, level and badges — a **snapshot**, with no history. Nothing in
the contract returns a time series, a per-day figure, or a streak record. Per-subject counters on
`SubjectTree` are a position, not a progress timeline, and they are per subject.

**What we built:** the row is **disabled**. Unlike Refer a Friend and Customer Support it gets no
shell, because a progress screen with no data would be an empty chart — and an empty chart reads as
"you have done nothing", which is a lie about the student rather than about the app.

> Renumbered from S30 in Day 8 step 3. S30 is the missing-legal-copy issue alone.

**Ask:** is there a progress/statistics endpoint planned? If yes, what is its grain — daily points,
per-subject accuracy, streaks? The frame will answer it better than we can guess.

## S33. 🟠 Customer Support is fully designed and has zero endpoints

**Where:** `Customer Support` ×3, `Create Ticket`, `Customer support chat`, `Messages` ×2 — plus a
whole Message **tab** in the nav bar. Code:
`lib/features/account_shells/screens/customer_support_screen.dart`.
**What:** there is **no endpoint of any kind** for support. Not draft — absent. This is a complete
ticketing product in the design with nothing behind it.

**What we built:** the Profile row navigates to a shell whose Create Ticket control is disabled.
**No invented data** — no ticket list, no thread, no reference number. A support screen that
accepts a message and drops it is worse than one that says it is not open, because the student
walks away believing they have been heard.

> Renumbered from S30 in Day 8 step 3.

**Ask:** is support milestone 1, and is it in-app at all? A `mailto:` or a WhatsApp hand-off is a
perfectly good milestone-1 answer and needs no contract — but it needs deciding, because the design
promises a ticketing system.

## S34. 🔴 `parentPhone` is WRITE-ONLY — we collect it and can never show it back

> **Found in Day 8 step 2, while building Edit Profile.** This is worse than "another immutable
> field", which is how the partner notice originally framed it.

**Where:** `parentPhone` is **required** on both registration bodies — `openapi.yaml:1280`
(`SchoolRegistration`) and `:1305` (`UniversityRegistration`). It is **absent from
`StudentProfile`**. The Edit Profile frame (`180:3989`) draws the row.
**What:** we compel a student to supply a parent's phone number at registration, and then there is
no endpoint that will ever tell them what they gave us. Not read-only. Not masked. **Not at all.**

The rest of Edit Profile's read-only block works because `GET /me` returns the values — phone, city,
school, stage, education system are all there, and we render them locked. `parentPhone` is the one
row we could not build, so **the frame's row is not rendered**, and a student cannot check whether
the number they typed months ago was a typo.

**The server clearly has it.** `POST /auth/recovery/start` returns **`parentPhoneMasked`**
(`openapi.yaml:272`) — account recovery reads the value back to prove identity. So this is a
missing *field on a response*, not a missing value in the database.

**Ask:** put the same masked form on `GET /me`. Masked rather than raw is almost certainly the right
answer for a minor's parent's number — it is enough for "yes, that is my mum's number" and it does
not turn `GET /me` into a way to harvest guardian contacts from a stolen token. If you would rather
it stay hidden entirely, say so and we will ask the designer to delete the row.

## S35. 🟠 `GET /me` returns raw wire codes; a student sees `nationalLanguages`

> **Found in Day 8 step 2**, same pass as S34.

**Where:** Edit Profile's read-only block. Code:
`lib/features/profile/screens/edit_profile_screen.dart`.
**What:** the geography and academic values on `StudentProfile` arrive as **wire codes with no
display names**. Rendered honestly, a student sees `nationalLanguages` and `secondary2` where the
frame draws "American" and "Grade 11".

Everything else on the profile carries both locales: `NamedRef` has `nameAr`/`nameEn`, so
governorate, city, school, university and faculty all render properly. `stage` and
`educationSystem` are bare strings.

**Why we did not just map them client-side, which is the obvious fix:**

1. `EducationSystem` is documented **extensible** — *"clients must tolerate unknown values"*. There
   is no closed set to translate against, so any map we write goes stale the day you add a system,
   and it fails by showing a raw code to exactly the students on the newest option.
2. `Stage` does have ARB copy from the registration wizard, but translating one and not the other
   would be worse than translating neither — the two rows sit adjacent.
3. Fetching `/reference/education-systems` to label a **read-only** row is a network call for
   cosmetics, on a screen that otherwise makes zero requests.

**Ask:** return the display names you already have. Either `stage` and `educationSystem` become
`NamedRef`-shaped (`{code, nameAr, nameEn}`) like everything else on the object, or `GET /me` gains
a sibling block of resolved names. The first is more consistent with the rest of the schema.

## S36. 🟡 A `Friends` screen exists, with no endpoint and no way in

**Where:** a `Friends` frame in the Account cluster. Code:
`lib/features/account_shells/screens/friends_screen.dart`.
**What:** two separate gaps, and the second is the odd one.

1. **No endpoint.** There is no friends list, no friend requests, no social graph of any kind in the
   contract. Interestingly the *concept* is in the contract's prose — `scoreHidden`'s description
   (`openapi.yaml:1094`) says it "affects profiles/friends" — so somebody has thought about it.
2. **No entry point.** The Profile hub draws ten rows and none of them is Friends. Nothing anywhere
   in the app navigates to this screen. We built it as a shell and routed it at `/friends`, but a
   student cannot reach it, and we did **not** invent an eleventh row to give it a door.

**Ask (designer first, then Seif):** where is this screen entered from? If the answer is "it is not
milestone 1", it comes out of the cluster and we delete the shell. If it is real, it needs both a
door and a contract, and the privacy toggles in S27 are already written as though it exists.

---

## S37. 🔴 Staging does not serve three routes the contract marks `stable`

**Where:** staging backend commit `0b53cdcad20cc0029fea0f18ef2e62a980b48aca` (`/health/version`,
built 2026-08-23T10:53:37Z). Observed by `tool/smoke/real_api_smoke_test.dart` on 2026-08-23
with a registered staging test number; status + `code` only, bodies not logged.
**What:** three `x-stability: stable` operations answer with a route-level error, not a
domain one:

| Operation | Staging answers | Contract says |
| --- | --- | --- |
| `PATCH /me` (same-name no-op body) | **405** with `code: internal_error` | `200` + `StudentProfile`; `internal_error` is the 500 code in error-codes.md, so a 405 carrying it looks like a fallback handler, not a routed endpoint |
| `GET /me/entitlements` (Bearer) | **404** `not_found` | `200` + `EntitlementsResponse` — a deployed route would answer 401/200 like `GET /me` does |
| `GET /catalog/subjects` (Bearer) | **404** `not_found` | `200` + subject list; everything under `/catalog/*`, `/quizzes/*` and `/questions/*` is unreachable from the client until this exists |

The same two 404s were seen by direct curl on 2026-08-21 (build `fbab748`), so this is not a
one-build regression. Everything else stable — all seven `/reference/*` reads, the full OTP
walk, `GET /me`, refresh with rotation, logout — decodes cleanly.

**Ask:** (1) when do `PATCH /me`, `/me/entitlements` and `/catalog/*` land on staging, and is
the 405-as-`internal_error` a routing fallback we should expect elsewhere? (2) Once they are
up, we need a staging account with a seeded term so `POST /quizzes` has questions to draw —
the v2.1 empty-catalog state is contract-legal and the harness already handles it, but it
cannot prove the quiz loop. (3) Still owed from `api-data.md` §4: a ~60 s access token for
checklist step 5 (the 401 → refresh → retry pipeline) and a forced `500` + `429` for step 9.

**Update 2026-09-04 — narrowed to two.** Against backend `78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1`
(built 2026-09-03T15:38:17Z): `GET /catalog/subjects` answers `401 authentication_required`
unauthenticated and **`200 []`** for the test account — **deployed**, and the empty list is the
contract-legal pre-term state. `PATCH /me` still answers **405** `internal_error` and
`GET /me/entitlements` still **404** `not_found`, unchanged across three builds (`fbab748`, `0b53cdc`,
`78c6e5d`). Evidence: `.ai/audits/current/smoke-staging-2026-09-04.md`. Asks (1) and (3) stand for the
two remaining routes. Ask (2) — a seeded, released term for `+2010000000001` so `POST /quizzes` has
questions to draw — is now the only thing between us and proving the quiz loop, and it would also be
the first observation of the 3.0.0-m1 `QuizSummary` on the wire (whether `78c6e5d` includes adr-102
cannot be checked from outside the private backend repo; the client accepts both shapes meanwhile).

---

## S38. 🔴 Account deletion has no endpoint, and it had never been filed

**Where:** the whole contract — 3.0.0-m1 has no `DELETE /me`, no deletion-request operation, and no
mention of deletion anywhere in `contract-changelog.md`. `docs/STORE_READINESS.md` §6 records the
store requirement.
**What:** both stores require an in-app path to delete the account — Google Play's account-deletion
requirement under Data safety, and Apple's App Review Guideline 5.1.1(v). The app can draw the screen;
it cannot do anything when the student confirms. This is a hard store blocker, not a polish item, and
it had never appeared in this file — that is the gap this entry closes.
**Ask:** (1) an operation — `DELETE /me`, or a `POST /me/deletion-requests` that starts a grace
period — marked `stable` before the store-submission wave; (2) the semantics for a minor's data:
immediate hard delete or a grace period, what happens to leaderboard rows, quiz history and the parent
phone number, and whether the same phone may register again afterwards; (3) the `ProblemDetails` codes
it can return (`authentication_required` and `session_superseded` at least). Until it lands the app can
only ship a `TODO(contract)` shell that says deletion is not available in-app yet, which does not satisfy
either policy.

---

## How to use this file

- New question → add a row to the summary table **and** a section, with the `file:line` marker if
  code already carries an assumption.
- Answered → mark **Resolved** in the Status column, strike the row, keep the section (the
  reasoning is worth more than the tidiness) and delete the `TODO(contract)` marker in code.
- Anything here that turns into a contract change needs a new pinned commit in
  `contract/openapi.yaml` and a note in `contract-changelog.md` before we build against it.
