# Day 7 Brief — Quiz: setup → take → results

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq`. Contract: `contract/openapi.yaml` (pinned 23f0535).
> Prereq: Day 00 + Day 6 committed, `dev` clean.
> **This is the biggest day so far and the first to use Bloc.** It is also the day real question
> content appears on screen, so `screen_protector` finally gets wired.

## What Day 7 builds

1. **Quiz setup** — length picker + `POST /quizzes`. Replaces `QuizSetupPlaceholderScreen`.
2. **Quiz taking** — one question at a time, per-question submit with immediate correct/incorrect
   feedback, AI explanation on demand.
3. **Quiz results** — `POST /quizzes/{quizId}/finish` summary.
4. **Free-plan limit sheet** — the `weekly_question_limit_reached` paywall.
5. **`screen_protector`** on the quiz screens only.
6. **Mock backend** coverage for all four endpoints, so the flow can be walked on a device.

## Explicitly OUT of Day 7 (do NOT build)

- **`retakeWrong` and `favorites` modes.** Day 7 ships **`mode: normal` only** (owner decision).
- **The `Learn(My Fault)` screens** (school `404:6292/6539/6677/6762`, university `404:7110/7181`).
  Their own day.
- **Flash cards (`225:5582`)** — a fully designed *second question renderer* with no contract
  support whatsoever. See CONFLICT 8. Day 7 builds the MCQ renderer only, but the engine must be
  shaped so flashcards slot in later without a rewrite (see Architecture → swappable renderer).
- **The favourite/bookmark control** — drawn in the design, all three endpoints are `draft`. See
  CONFLICT 4. Parse `isFavorite`, render nothing.
- **"Review Questions"** as a working flow — the button renders **disabled**. See CONFLICT 3.
- **The Pass/Fail verdict** on the result screen — no contract source. See CONFLICT 2.
- **Quiz history** (`GET /quizzes`) and **resume** (`GET /quizzes/{quizId}`) — both `draft`.
- Subscription/Paymob purchase. The limit sheet's "Upgrade" CTA routes to the existing
  `/subscription` placeholder and stops there.

## Skills (invoke from `.claude/skills/`, in this order)

1. `level-up-domain` — glossary + operating rules
2. `build-screen` — the gather → plan → build loop
3. `seif-api-contract` — models/repo/Dio against the pinned contract
4. **`bloc`** — **this is the day `flutter_bloc` finally gets used.** The repo rule has always been
   Riverpod everywhere *except* the quiz. `flutter_bloc ^9.1.1` has been a declared-but-unused
   dependency since Day 0; `lib/features/quiz/bloc/` exists with a `.gitkeep` waiting for this.
   **Do NOT reach for `river` out of habit.**
5. `figma-frame` — tokens from Figma, never eyeballed
6. `screen-states` — full matrix this time: loading / error / offline × AR + EN × light + dark
7. `flutter-add-widget-test` · `dart-run-static-analysis`

`river` is still correct for anything *outside* the quiz feature you happen to touch (e.g. refreshing
`/me` after a level-up). Bloc owns the quiz session state machine only.

---

## Figma frame map

**The university flow is a copy-paste of the school flow.** Every frame in the University Student
Flow group is still *named* "for school student". Verified identical renders: setup
`135:1622` vs `309:5771`, and results `159:1964` vs `309:6375` — pixel-for-pixel, same heights
throughout (setup 1052 · quiz 1052/1109 · photo variant 971 · result 966).

**Build ONE engine.** Do not branch by track inside the quiz screens.

| Screen | School (group `125:2276`) | University (group `125:2335`) |
|---|---|---|
| Setup | `135:1622` | `309:5771` |
| Quiz page (MCQ) | `159:845` · `159:1431` | `309:5878` · `309:5994` |
| Quiz page + AI explanation | `159:1695` (h 1109) | `309:6113` (h 1109) |
| Quiz page with photo | `159:1852` · `216:2973` | `309:6256` · `309:7648` |
| Result | `159:1964` · `162:2377` | `309:6375` · `309:6488` |
| Limit notification | `199:2335` | `225:6634` · `225:7001` |

**Three frames in that group are NOT quiz states — do not build them as such:**

| Node | What it actually is |
|---|---|
| `225:5582` | **Flash cards** — a different question renderer. Frame is *named* "Quiz page", but its title text reads "Flash cards". **OUT of Day 7**, see below. |
| `222:5252` | **Empty frame.** Renders blank (1×1), stacked underneath `225:5582` at the same x/y. Leftover. Ignore. |
| `404:6853` / `404:7234` | Sit a row **below** the quiz row (y 1452 / 1331), adjacent to the `Learn(My Fault)` frames. They belong to the My Fault flow, not this one. |

Pull each with `get_design_context` for pixel detail — the IDs above are the map, not the spec.
Dark-mode and RTL variants live in the sibling `Dark mode` / `RTL` top-level groups on the same
page; the theme carries the colours, so build once and verify in all four combinations.

### The Day 6 seam is intact — no missing screen

School: `Learn(lessons)` `135:1485` → `Learn(Setup quiz)` `135:1622`.
University: `Learn(Lecture)` `180:5208` → `Learn(Setup quiz)` `309:5771`.

Both already wired in code: `LessonsScreen` and `LecturesScreen` build a `QuizSetupArgs` and push
`/quiz/setup`. **Day 7 does not change the Learn stack.** The only track difference is which
constructor is used, and that already exists.

### The one real track difference

Setup shows **no quiz-type selector** in either track — because for university it was already
chosen on the Lectures tab row (Day 6) and rides in `QuizSetupArgs.quizType`. School has no
equivalent and passes `lessonId`. `QuizSetupArgs` already models exactly this with two named
constructors. **That is the entire school/university divergence in Day 7.**

---

## ⚠️ CONFLICTS — resolve before coding

### 1. 🔴 Points are off by roughly 20× — render the SERVER value
Setup previews **"Questions: 10 · Points: +30"**. The result screen shows **"+200 Points"**.
The contract is unambiguous: `AnswerResult.pointsDelta` is *"0 or 1"* and `submitAnswer` says
*"+1 per correct"*. A 10-question quiz can award **at most 10 points**, not 30 and not 200.

**Do:** never compute or predict points client-side. Render `QuizSummary.pointsAwarded` and
`totalPoints` verbatim from `finish`. On the **setup** screen, **omit the points preview entirely** —
we cannot predict the award without inventing the rule. Logged as `seif_fight.md` **S12**.

### 2. 🟠 The "Pass" verdict is deferred (owner decision)
The result frame renders **"50% — Pass"**. There is no pass threshold anywhere in the contract.

**Do:** render the **percentage ring only** (`score / totalQuestions`, both from `QuizSummary`) and
**omit the Pass/Fail word**. Do not invent a 50% threshold. This is deferred until Seif completes
the contract, and is picked up as its own small change then — not blocked, not guessed.
Logged as `seif_fight.md` **S13**.

### 3. 🟠 "Review Questions" renders disabled — but a recap IS possible
> **Corrected 2026-07-30.** My original read of `QuizSummary` was truncated at `leveledUp` and
> missed the last two required fields. See DECISIONS D-002.

`QuizSummary` **requires `questions[]`** — recap rows of `{ questionId, answered, correct? }`,
with `correct: null` when unanswered. The contract's own description: *"Recap rows (full review at
`GET /quizzes/{id}`)."*

So the split is:
- **Available now, on the stable `finish` call:** which questions were right, wrong, or skipped.
- **Needs the draft `GET /quizzes/{quizId}`:** the question *text* and the *correct answer* — the
  only endpoint that returns correct answers for a finished quiz (`openapi.yaml:822`).

**Do:** still render the full "Review Questions" button **disabled** (it implies the text-level
review we cannot serve). But **parse `questions[]` and use it** — it is required, so you must parse
it anyway, and it is the authoritative source for the Correct/Wrong/Skipped counts (CONFLICT 5).
A per-question recap strip on the results screen is buildable now if the frame has room; if it
does not, parse and hold. `seif_fight.md` **S14**.

### 4. 🟠 The favourite control is hidden
The quiz header draws a bookmark icon — `solar:folder-favourite-bookmark-linear`, node `295:3139`,
sitting between an AI icon and a share icon. All three favourite endpoints
(`POST`/`DELETE /questions/{questionId}/favorite`, `GET /me/favorites`) are `draft`.

**Do:** **parse `isFavorite` into `QuizQuestion` — it is a required field, so you must anyway — and
render no control.** Do not draw a dead star. The model, the JSON and the tests then do not move
when the endpoints are promoted; the work becomes a widget plus two repository methods.
`seif_fight.md` **S11**.

Same treatment for the **share icon** (`ic:baseline-share`) — no endpoint, no sharing story. Omit.

### 5. 🟠 Correct + Wrong does not account for skipped questions
The result screen has exactly two buckets. The contract distinguishes `answeredCount` from
`totalQuestions` precisely because *"unanswered questions are recorded unanswered (not counted
wrong)"*. A student who finishes early gets `5 correct + 3 wrong` out of 10 and the design has
nowhere to put the other 2.

**Do:** derive `wrong = answeredCount − score` (**never** `totalQuestions − score`) and
`skipped = totalQuestions − answeredCount`, rendering Skipped whenever non-zero.
`QuizSummary.questions[]` is parsed and carries the same information per question — it is the
authoritative cross-check and the raw material for a future recap strip, but the scalar derivation
is what the result screen uses. *(As built — see `quiz_result_screen.dart`.)*
Flag the missing bucket to the designer in `DESIGN_ISSUES.md`.

### 6. 🟠 "QUESTION POOL PROGRESS — 45 out of 100 questions, 55 remaining in pool"
The setup frame draws a pool-progress card. Nothing in the contract exposes a per-scope pool size
or how much of it a student has consumed. `POST /quizzes` only tells you *after the fact* (422
`not_enough_questions`) that the pool was too small.

**Do:** **do not build the pool card.** Hide it. Do not fabricate a denominator.
`seif_fight.md` **S15**.

### 7. 🟡 "Daily Limit Reached" vs a WEEKLY contract limit
The limit sheet reads **"Daily Limit Reached / FREE USAGE REACHED"**. The contract says
*"Free plan: 50 questions/WEEK"* and the error code is `weekly_question_limit_reached`.

**Do:** ship **weekly** copy. The server owns the rule and the code name says weekly.
Flag the design wording. `seif_fight.md` **S16**.

### 8. 🔴 Flash cards are a whole second renderer with zero contract support
**Where:** `225:5582` — frame *named* "Quiz page", title text **"Flash cards"**. It never turns up
in a name search, which is why it was missed until the owner pointed at it.

**How it differs from the MCQ page — this is not a state, it is a different screen:**
- **No options list.** MCQ has a four-button container (`308:5152`). Flashcards have a single
  component instance, `247:3260` "Component 17" (358×454). Being a *component* means the
  flip/reveal states live in its variants — which is why there is only one flashcard frame.
- **The AI icon is explicitly `hidden="true"`** (`503:6802`) and there is no AI EXPLANATION panel.
  Flashcards get no explanations.
- Close (X) instead of back.
- **Shared chrome:** same progress bar, same `1/10` counter, same Confirm button, same nav bar.

**What the contract has for this: nothing.** No flashcard content endpoint, no `flashcard` value in
`quizTypes`, no flashcard question shape. Only `EntitlementType.flashcardSubscription` — an
entitlement a student can *buy* and then use on nothing. The Lectures tab row (Day 6) draws a
**Flashcard** tab that `quiz_type_tabs.dart` deliberately does not build (`DESIGN_ISSUES.md` #18).

**Do (Day 7):** build the **MCQ renderer only**. But structure the engine so the flashcard renderer
is an addition, not a rewrite — see Architecture below. Do **not** invent a flashcard question
shape. `seif_fight.md` **S6** (upgraded with this evidence).

---

## Endpoints — all four STABLE

### `POST /quizzes` → `201 Quiz`
```
Request:  { mode: "normal", lessonId?: uuid, lectureId?: uuid, quizType?: enum, length: 10|30|50 }
          required: [mode, length]
201:      Quiz { id, mode, quizType?, scopeName, questions[], createdAt }
          QuizQuestion { id, order, text, imageUrl?, thumbnailUrl?, options[], isFavorite }
          required: [id, order, text, options, isFavorite]   ← NO correct answer
400: validation_failed (mode/track/scope mismatch)
401: authentication_required · session_superseded
403: weekly_question_limit_reached · subscription_required · insufficient_scope
422: not_enough_questions   (normal mode: scope pool < length)
```
**Questions arrive in serving order and correct answers never ship with them.** This is the whole
reason the taking screen is per-question submit rather than a client-graded form.

### `POST /quizzes/{quizId}/answers` → `200 AnswerResult`
```
Request:  { questionId, optionId }
200:      AnswerResult { correct, correctOptionId, pointsDelta, explanationAvailable }
403: weekly_question_limit_reached · insufficient_scope
409: quiz_already_finished
```
**Idempotency key is `(quizId, questionId)`** — a retry returns the ORIGINAL grade and never
double-awards. So a network retry is safe and must NOT be suppressed client-side.
`correctOptionId` is revealed only here, after the student commits.

### `POST /quizzes/{quizId}/finish` → `200 QuizSummary`
```
200: QuizSummary { quizId, score, totalQuestions, answeredCount, pointsAwarded, totalPoints,
                   level, leveledUp, newBadge, questions[] }
     questions[]: { questionId, answered, correct? }   correct is null when unanswered
     required: ALL TEN — [quizId, score, totalQuestions, answeredCount, pointsAwarded,
                          totalPoints, level, leveledUp, newBadge, questions]
403: insufficient_scope
```
Idempotent — repeat calls return the same summary. Unfinished quizzes auto-finish server-side
after 24h.

### `GET /questions/{questionId}/explanation` → `200` or **`202`**
```
200: { status: "ready", text }
202: { status: "generating" }     ← poll, suggested 2s backoff
403: insufficient_scope           ← question not yet answered by the caller
```
GPT-4o-mini, generated once then cached. **Only callable after the student has answered that
question** — a 403 here is expected if called early, not a bug.

---

## SCREEN 1 — Quiz setup (`135:1622` / `309:5771`)

- Title "Quiz Setup"; subtitle is **`scopeName` ONLY — no subject name** (DECISIONS D-001).
  `scopeName` is server copy, already localized (adr-018) — it arrives in `QuizSetupArgs` from
  Day 6, so the screen titles itself with no extra call. The frame shows "Biology / Cell Membrane";
  we render only the second line. `subjectName` is not reachable from any stable endpoint.
- **Length picker**: 10 / 30 / 50, single-select, default 30 per the frame. These are the
  contract's enum — do not offer other values.
- **Omit** the pool-progress card (CONFLICT 6) and the points preview (CONFLICT 1).
- Primary CTA "Start learning" → `POST /quizzes` → push the quiz screen with the returned `Quiz`.

**Error states — these are the interesting ones:**
- `403 weekly_question_limit_reached` → the **limit sheet** (`199:2335` / `225:6634`), not an inline error.
- `403 subscription_required` → same sheet, different copy.
- `422 not_enough_questions` → inline: the chosen length exceeds the pool. Suggest a smaller length;
  do not silently retry with a smaller number.
- Offline → the standard `StateWidget` offline state; the button is disabled.

## SCREEN 2 — Quiz taking (`159:845` base · `159:1695` with AI explanation)

Structure confirmed from `159:1695` metadata:

- Header: back · "Quiz" · AI icon · ~~bookmark~~ (hidden, CONFLICT 4) · ~~share~~ (omitted)
- Thin progress bar + **`1/10`** counter
- `QUESTION 1` label + question text
- **`imageUrl`** when present → the "Quiz page with photo" variant (`159:1852` / `216:2973`).
  Same screen, image block between the question text and the options. Use `cached_network_image`.
- Four option buttons, letter badge A/B/C/D, single-select
- **Confirm** button + a forward arrow

**Interaction model — read this twice:**
1. Student selects an option. Nothing is sent yet. Confirm enables.
2. Confirm → `POST .../answers`. The response reveals `correct` and `correctOptionId`.
3. The screen now shows the graded state: chosen option marked, and if wrong, the correct one
   revealed. The A/B/C/D letter badge is replaced by a state icon — that is what the `Icon` nodes
   at `308:5160` / `308:5168` are, versus the letter `text` nodes at `308:5155` / `308:5176`.
4. If `explanationAvailable`, the **AI EXPLANATION** panel becomes available — two sections,
   *"WHY IS THIS WRONG?"* and *"WHY IS THE CORRECT ANSWER RIGHT?"* (`159:1824`–`159:1838`).
   Fetch on demand, **handle `202` by polling with 2s backoff**, and show a generating state.
   Do not block the Next button on it.
5. Forward → next question. After the last, → `finish` → results.

**A question already answered can never be re-answered.** Grading is committed server-side. If the
student navigates back, show the graded state read-only.

**Interrupted quiz:** state is **in-memory only** (owner decision). If the app is killed the quiz
is lost — answers already submitted are safe server-side, but the screen cannot be rebuilt because
`GET /quizzes/{quizId}` is draft. **Do not cache questions to Hive** — the contract frames the
question bank as the product. Add a confirm-on-exit dialog so progress is never lost silently.
`seif_fight.md` **S2** already tracks this.

## SCREEN 3 — Results (`159:1964` / `309:6375`)

- "Quiz Complete!" + **`scopeName` only, no subject name** (DECISIONS D-001)
- **Percentage ring** = `score / totalQuestions`. **No Pass/Fail word** (CONFLICT 2).
- **Correct / Wrong / Skipped** counted from `QuizSummary.questions[]` (CONFLICT 5)
- "REWARDS EARNED — +N Points" = `pointsAwarded` verbatim (CONFLICT 1)
- Level progress bar — `level` and `totalPoints` are available but **the threshold is not**
  (`seif_fight.md` S3, `DESIGN_ISSUES.md` #13). Render the numbers, not a proportion, until the
  threshold lands.
- **`leveledUp`** and **`newBadge`** — **parse both, flag-only, no celebration UI this ticket**
  (DECISIONS D-002). Check whether the frames carry a level-up or new-badge state; if they do not,
  flag it — the contract goes to the trouble of telling us, so the design should say something.
- "Review Questions" — **disabled** (CONFLICT 3)
- Finishing must **invalidate the `/me` provider** so Home shows the new points/level.

## SCREEN 4 — Free-plan limit sheet (`199:2335` / `225:6634` / `225:7001`)

Triggered by `403 weekly_question_limit_reached` (setup, and possibly mid-quiz from `answers`).
Frame content: "FREE USAGE REACHED", a questions-used bar, a benefits list (unlimited quiz
questions · AI-powered explanations · priority support · remove all ads), and **Upgrade To Pro**.

Ship **weekly** copy (CONFLICT 7). Upgrade → the existing `/subscription` placeholder. Dismissible.

---

## Architecture

### Bloc — the quiz session state machine

`lib/features/quiz/bloc/` is where this lives. A single `QuizBloc` owns one quiz session:
loaded questions, current index, per-question grade, explanation state, finished summary. The
per-question submit/reveal cycle is a genuine state machine with ordering constraints, which is
exactly why the project reserved Bloc for it.

Setup is a **different** concern (one request, then navigate) — a small `AsyncNotifier` or even a
`FutureProvider` is fine there. Do not force setup into the Bloc.

### `QuizMode` — build for three, ship with one

```dart
enum QuizMode { normal, retakeWrong, favorites }   // mirrors the contract exactly
```
The enum carries **all three** contract values, exactly as `QuizType` carries all four. Serialization
is then correct forever. But:
```dart
const _offeredModes = [QuizMode.normal];           // Day 7 ships one
```
Keep "what exists" separate from "what we offer" — enabling a mode later is one line here, not a
hunt through the UI. Every `switch` on `QuizMode` is **exhaustive with no `default:`**, so the day a
mode is enabled the compiler lists every site that needs a decision.

**Anti-pattern to avoid:** a `bool isRetake`, or hardcoding `"mode": "normal"` in the repository.
Either one means adding a mode later touches the args, the repository, the setup screen and every
call site.

### Swappable question renderer — the flashcard seam

The flashcard screen (`225:5582`) shares the **entire session shell** with the MCQ screen: header,
progress bar, `n/total` counter, Confirm button, nav bar. Only the middle changes — four option
buttons versus one flip card.

**So split the quiz screen at that seam now:**

```
QuizScreen            ← owns the shell: chrome, progress, Confirm, Bloc wiring
  └─ QuestionRenderer ← the ONLY part that varies
       └─ McqRenderer       (Day 7 — the only one that exists)
       └─ FlashcardRenderer (later — drops in, changes nothing above it)
```

`QuizBloc` drives the session (index, grade, finish) and stays renderer-agnostic. The renderer
decides how a question is presented and what "answered" means.

This costs almost nothing today — one widget boundary — and is the difference between adding
flashcards later as a new file versus reopening the screen, the Bloc and the tests. Same principle
as `QuizMode`: make the extension point now, leave the extension for when the contract exists.

**Do NOT** build a `FlashcardRenderer` stub, an `isFlashcard` bool, or a `flashcard` member on any
enum. The seam is the deliverable; the contract has no flashcard shape to build against.

### `isFavorite` — parsed, not rendered
Required field, so it must be on the model. No control on screen. See CONFLICT 4.

### Empty / short pool
`POST /quizzes` may legitimately return **fewer questions than requested**, and 422
`not_enough_questions` is a normal outcome, not an error state to hide. Build a graceful
short-quiz and empty-pool state now — the later modes reuse it verbatim.

### `screen_protector` — quiz screens only
`screen_protector ^1.5.3` has been declared and unused since Day 0. The contract's own words:
*"Correct answers never ship with questions (content protection — the bank is the product)."*
Enable on the taking screen (and the results screen if it shows question content); **disable on
dispose** so the rest of the app is unaffected. Closes the HIGH finding in
`LEVEL_UP_AUDIT_2026-07-28.md` §3.

### Mock backend
Extend `lib/dev/mock_backend.dart` with all four endpoints, contract-faithful, including the
error paths: `weekly_question_limit_reached`, `not_enough_questions`, `quiz_already_finished`, and
a `202`-then-`200` explanation so the polling path is walkable. **Without this the quiz cannot be
demoed on a device** — `AppConfig.baseUrl` is still `TBD.example`.

## Files

```
lib/features/quiz/
  models/       quiz.dart, quiz_question.dart, quiz_option.dart, answer_result.dart,
                quiz_summary.dart, quiz_mode.dart   (freezed + json_serializable, camelCase)
                quiz_setup_args.dart, quiz_type.dart   ← EXIST, extend don't replace
  repository/   quiz_repository.dart   (createQuiz / submitAnswer / finishQuiz / getExplanation)
  bloc/         quiz_bloc.dart, quiz_event.dart, quiz_state.dart
  screens/      quiz_setup_screen.dart, quiz_screen.dart, quiz_result_screen.dart
  widgets/      question_option_tile.dart, ai_explanation_panel.dart, limit_sheet.dart
```
Delete `quiz_setup_placeholder.dart` once `/quiz/setup` points at the real screen.

## Router — `lib/core/router/app_router.dart`

`/quiz/setup` and `/quiz/:quizId` already exist **outside** the shell (deliberately — taking a quiz
is a full-screen task, not a tab). Point them at the real screens and add a results route.
Results must not be back-navigable into a finished quiz.

## l10n (both `.arb`)

Quiz title//counter, `QUESTION {n}`, quiz sizes, "Start learning", "Confirm", correct/wrong labels,
AI explanation headings, "Quiz Complete!", Correct/Wrong/Skipped, "Rewards Earned", "Review
Questions" + its coming-soon note, limit-sheet copy (**weekly**), and every error code:
`not_enough_questions`, `weekly_question_limit_reached`, `subscription_required`,
`quiz_already_finished`, `insufficient_scope`.

## Acceptance checks

- [ ] Setup / taking / results / limit sheet each render **loading · error · offline**, in
      **AR (RTL) + EN (LTR)** × **light + dark**
- [ ] `EdgeInsetsDirectional` throughout; no hardcoded Left/Right; option letters and the progress
      counter read correctly in RTL
- [ ] **One engine, both tracks:** school (`lessonId`) and university (`lectureId` + `quizType`)
      both drive the same screens; no `if (track ==)` inside the quiz feature
- [ ] `POST /quizzes` body is built from `QuizSetupArgs` — never both `lessonId` and `lectureId`
- [ ] Per-question submit: nothing sent on selection, only on Confirm; `correctOptionId` revealed
      only after the response
- [ ] An answered question cannot be re-answered; retry returns the original grade (idempotency)
- [ ] Explanation handles **202 → poll → 200**, and 403-before-answering is treated as expected
- [ ] Points come from the server; **no client-side points arithmetic anywhere**
      (`grep -rn "points" lib/features/quiz` shows display only)
- [ ] Results: no Pass/Fail word · no subject name · Review disabled · Skipped shown when non-zero
- [ ] `QuizSummary` parses **all ten** required fields, including `newBadge` and `questions[]`
- [ ] `leveledUp` and `newBadge` are parsed flag-only — **no celebration UI** (DECISIONS D-002)
- [ ] `wrong = answeredCount − score`; `totalQuestions − score` is never used — asserted in a test
      with a partially-answered quiz
- [ ] Finish invalidates `/me` so Home reflects new points/level
- [ ] 403 `weekly_question_limit_reached` opens the limit sheet, **weekly** copy
- [ ] 422 `not_enough_questions` handled without a silent retry
- [ ] `QuizMode` has all three values; only `normal` is offered; every switch is exhaustive with
      no `default:`
- [ ] `isFavorite` parses; no favourite control rendered
- [ ] `screen_protector` on entering the quiz screen, **off on dispose** — verified, not assumed
- [ ] Mock backend covers all four endpoints + every error path; the flow is walkable on a device
      via `main_mock.dart`
- [ ] `flutter analyze` clean · `build_runner` ok · full suite green

## Docs to update

- `seif_fight.md` — add **S11** (isFavorite read/write stability split), **S12** (points 20× off),
  **S13** (no pass threshold), **S14** (review needs a draft endpoint), **S15** (pool progress has
  no source), **S16** (daily vs weekly).
- `DESIGN_ISSUES.md` — missing Skipped bucket; "Daily" wording; missing level-up celebration state
  (if absent); university frames all named "for school student".
- `PROGRESS.md` — quiz endpoints move to done; add this brief to the index.

## Scope / do NOT

- No `retakeWrong`, no `favorites`, no My Fault screens, no history, no resume.
- No Paymob, no purchase flow.
- No changes to the Learn stack — the Day 6 seam already works.
- Do **not** commit — leave for review.
