# Day 9 Brief — Quiz Review (session-scoped)

> Repo `level_up_app`, branch `dev`. Self-contained.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq`, page **`design`** · Contract: `contract/openapi.yaml`
> **pinned `61905ce` (v2.1.0-m1)** — see `contract/SOURCE.md`.
> Prereq: contract/model reconciliation committed, `dev` clean, app launching on the Pixel 8.
>
> **This day consumes ZERO endpoints.** Coverage before and after is **21/21 stable · 0/16 draft**.
> If that number moves, something went wrong.
>
> **Two steps**, preceded by a **gate**. Do not start Step 1 until the gate passes.
> Do not start Step 2 until told.

---

# Why this day exists, and why it contradicts S14

`docs/seif_fight.md` **S14** says:

> *"Review Questions" needs `GET /quizzes/{quizId}`, which is draft… promoting it unblocks review
> **and** quiz resume (S2) in one move.*

`quiz_result_screen.dart:120` says the same thing in code:

> *Rendered so the screen matches the frame, disabled because the endpoint behind it is draft.*

**S14 is right about one kind of review and wrong about another.** It assumed review means
*"open any finished quiz and read it back"* — which needs the server, because the client has
thrown the session away by then. That version is still blocked and stays blocked.

But the frame's Review Questions button sits **on the result screen, one tap after finishing**.
At that exact moment the client still holds everything:

```
POST /quizzes              → Quiz.questions          text, options, imageUrl
POST /quizzes/{id}/answers → AnswerResult            correct, correctOptionId
QuizBloc → QuizSession     → chosen{qId → optionId}  what the student picked
                           → grades{qId → AnswerResult}
```

`QuizSession` (`lib/features/quiz/bloc/quiz_state.dart:25`) carries all four. Nothing is fetched,
nothing is invented, nothing is cached. The only reason the button is dead today is that
`QuizResultArgs` (`quiz_screen.dart:405`) carries `{summary, scopeName}` and drops the session on
the floor when the Bloc is disposed.

So Day 9 is small: **stop throwing the session away, and render it.**

**What this does NOT unblock:** reviewing an older quiz, quiz resume (S2), or reaching review from
anywhere except the result screen. Those still need `GET /quizzes/{quizId}` promoted. S14's *ask*
stands; only its scope narrows.

---

# ✅ STEP 0 — THE GATE. Answered 2026-08-20. Day 9 proceeds.

The gate asked: *does the frame reveal the correct answer for questions the student skipped?*

**Answer: NO — and for a reason better than expected.** The frame does not reveal the correct
answer for **any** question. `162:2377` is a **status list**, not an answer breakdown: one row per
question showing a ✓/✕ glyph, "QUESTION n", and the question text. Nothing more.

So the skipped-question hole never arises in this screen, and every field the frame needs is
already in the session:

| Frame element | Source | In hand? |
|---|---|---|
| "QUESTION n" | list index | ✅ |
| question text | `quiz.questions[i].text` | ✅ session |
| ✓ / ✕ status | `grades[qId].correct` | ✅ session (also `QuizSummary.questions[].correct`) |
| AI glyph on wrong rows | `grades[qId].explanationAvailable` | ✅ session |
| `All (10)` · `Correct` · `Wrong` counts | `QuizSummary.totalQuestions` / `score` / `wrong` | ✅ getters already exist |

**Complexity revised from M to S.** This is a filtered list of ~10 rows, not an answer review.

### Why this does not contradict S14, and why S14's ask still stands

`QuizReview` (`contract/openapi.yaml:1675`), behind the draft `GET /quizzes/{quizId}`, requires
`correctOptionId` on every question and makes `selectedOptionId` nullable — the server's designed
review **does** reveal correct answers, including for unanswered questions.

That is a **richer, different screen**: full historical review with answers. This frame is the
lightweight post-quiz status list. Both can exist. So:

- Build **this** frame now, from the session. No endpoint.
- Keep S14 open and keep its promotion ask — `GET /quizzes/{quizId}` still unlocks historical
  review, answer reveal, and quiz resume (S2) in one move.
- Do **not** let this day's success be used as an argument that S14 is closed. Narrow it, don't
  delete it.

---

# Assumptions this brief is built on

If any is wrong, **stop and say so** — do not build around it.

1. **Review is session-scoped.** Reachable only from the result screen of the quiz just finished.
   Killing the app loses it, exactly as the quiz itself is lost (S2). This is a property, not a bug.
2. **Skipped questions get no reveal** (pending Step 0).
3. **The frame is authoritative for layout; the session is authoritative for data.** Where the frame
   draws something the session cannot supply, it is omitted or disabled — never invented, never
   faked from a client-side computation.
4. **No new packages.** No new endpoints. No `build_runner` run for this day unless `QuizReviewArgs`
   is made `freezed`, and it should not be — it is a plain immutable class like `QuizSetupArgs`.
5. **The University track uses the same screen.** One review feature, no branching by track — as
   with the quiz itself (Day 7).
6. **AI explanations are out of scope for Day 9** even though `session.explanations` is in hand.
   The frame does not draw them in the review list; adding them is a separate decision.

---

# Rules for this day

- **Screenshot protection is mandatory.** `QuizScreen` sets `FLAG_SECURE` / the iOS secure layer in
  `initState` and clears it in `dispose`. The review renders the *same question bank with the
  correct answers attached* — it is the most sensitive screen in the app. Wire
  `screenProtectionProvider` identically. iOS is a secure-layer trick, not a hard block; do not
  claim otherwise.
- **In memory only.** No Hive, no `SecureStorage`, no file. The contract frames the question bank as
  the product.
- **Zero arithmetic.** `score`, `answeredCount`, `totalQuestions`, `pointsAwarded` come from
  `QuizSummary` verbatim. No percentage recomputation, no Pass/Fail label — no threshold exists
  anywhere in the contract (S13).
- **Design tokens only.** `AppColors.quizCorrectFill/Border`, `quizWrongFill/Border/Badge`,
  `quizOptionFill/Border`, `quizDivider` are already Figma-verbatim and annotated with their node
  IDs. `test/core/theme/palette_discipline_test.dart` fails on a raw colour.
- **All copy through `AppLocalizations`.** Both ARBs, full key parity — there is a ratchet test.
- **Reuse before inventing — but check the frame first.** `CircleBackButton`, `TitledChrome` and
  `CatalogScaffold` already exist and fit the header. `QuestionOptionTile` does **not** fit: this
  screen renders no options. Search `core/widgets/` before creating, and do not force a component
  that only half applies.
- **The guards must stay green.** `test/guards/` mechanises seven project rules. Do not weaken a
  guard to make new code pass.
- **Riverpod is not the answer here.** The `river` skill scopes itself to *"every screen except the
  quiz engine"*. This is the quiz engine. There is nothing async to fetch — no `AsyncNotifier`, no
  `StateWidget`.

---

# Figma frame map

Page **`design`** → group **`light mode`** (`310:10280`) → **`School Student Flow`** (`125:2276`).
Dark and RTL variants live in the sibling `Dark mode` / `RTL` top-level groups; the theme carries
colour, so build once and verify in all four combinations.

| Screen | Node | Notes |
|---|---|---|
| **quiz Result** (summary) — school | `159:1964` | The 50 % ring screen. Already built. Source of the CTA. |
| **quiz Result** (summary) — university | `309:6375` | Same screen, university flow. |
| **quiz Result** (Quiz Review) — school | **`162:2377`** | ✅ **The target of this day.** 402×966, at x=6453 — directly right of the ring at x=6001. |
| **quiz Result** (Quiz Review) — university | not yet ID'd | Expect a sibling, as with every other quiz frame. Costs one `get_metadata` on the University section when needed. |

**Frame anatomy of `162:2377`, read from `get_metadata` + `get_screenshot` on 2026-08-20:**

```
162:2377  quiz Result              402 × 966
├─ 162:2378  Status_Bars
├─ 162:2376  Frame 1000003031      21,20   275×52   ← header
│  ├─ 162:2372  weui:arrow-filled  back chevron
│  ├─ 162:2411  "Quiz Review"      145×31   title
│  └─ 162:2371  tdesign:service-filled       trailing glyph
├─ (filter chip row)               All (10) · Correct · Wrong
├─ 162:2511  Frame 1000003034      20,178  362×717  ← the list
│  └─ Container × 8+               362×73 each
│     └─ Frame 1000003033          347×51
│        ├─ Container 28×28 → Icon 14×14   ← ✓ / ✕ status glyph
│        └─ Frame 1000003032 → Paragraph
│           ├─ "QUESTION n"
│           └─ question text
│        └─ tdesign:ai-education   ← ONLY on wrong rows (Q2, Q5, Q8)
└─ 162:2397  nav bar               drawn, but IGNORE — quiz screens live
                                    outside the shell (app_router.dart:225)
```

Correct rows are green-tinted with a green ✓ circle; wrong rows are red/pink-tinted with a red ✕
circle. **There are no option layers, no answer text and no correct-answer label anywhere in the
frame.**

Node IDs for the built quiz screens, already recorded in code and useful for locating the review by
proximity: setup `135:1622` · quiz base `159:845` · quiz + AI panel `159:1695` · action bar
`159:1772` · AI panel `159:1811` · ring `159:1975` · score buckets `159:1990` / `159:2005` ·
rewards `159:2020`.

## Figma MCP access — resolved 2026-08-20, but spend calls carefully

The connector was authenticated as **`jooubie@gmail.com`**, which does **not** own this file. It is
now **`zlatanibrahimovichsweden@gmail.com`** (`whoami` → "Zlatan Sweden's team", seat **View**,
tier **starter**) and reads succeed.

Three gates exist; only the first is fixed:

1. ✅ **Right account.** "Connector is on" ≠ "connector can read this file". Signing into the Figma
   *desktop app* does not change the connector's OAuth identity — they are separate. Re-auth via
   `/mcp`, and sign out of Google first or the browser silently reuses the old account.
2. ✅ **Permission.** Reads on `P6044i0giD9TmdQ7C2AmLq` now return data.
3. ⚠️ **Quota — the MCP cap follows the FILE'S TEAM, not your account.** Starter = **6 tool calls
   per month**. Budget them: `get_metadata` on a section, then `get_screenshot` on one node, is two.
   Do not probe. This also explains an apparent regression with no seat change — July and August are
   different quota windows.

**Do NOT read `PROGRESS.md:276` as evidence that design-context access works.** That entry records
`download_assets` returning SVG/PNG — **asset export only**, never `get_metadata` or
`get_design_context`, and no seat was upgraded. An earlier draft of this brief over-read it; this
paragraph is the correction.

**Free alternative that costs zero calls:** open the file in the Figma UI on the owning account,
select the frame, **export PNG @2×**. Export works on a View seat.

Per `figma-frame`: `get_screenshot` before `get_design_context`, and only on a specific node — never
the root, which is 24445 × 6169 and truncates at ~20 top-level nodes. `get_metadata` on
`125:2276` returns ~510 KB; pipe it to a file and grep rather than reading it inline. The MCP's
reference code is a **spec**, not code to port, and it routinely misses shadows.

---

# ⚠️ CONFLICTS

### 1. 🔴 The frame has no "not answered" state — it assumes every question was answered

**Where:** `162:2377`. The chips are **`All (10)` · `Correct` · `Wrong`**, and every row is either
green ✓ or red ✕. There is no third chip and no neutral row.
**What:** a student can finish a quiz having skipped questions — `QuizSummary` separates
`answeredCount` from `totalQuestions` precisely so this is representable, and the result screen
already renders a third **Skipped** figure for it. The review frame cannot show those questions at
all. Either they vanish from a list whose chip claims "All", or they render in a state the design
does not define.
**Fix we need:** the designer adds a third row state (*not answered* — neutral tint, no ✓/✕) and
decides whether the `All` count includes it.
**Meanwhile:** render skipped questions with a neutral row, exclude them from Correct and Wrong,
and include them in `All` so the count matches `totalQuestions`. `TODO(design)` at the site, entry
in `DESIGN_ISSUES.md`. **Do not silently drop them** — a review that hides questions is worse than
one that admits it does not know.

### 2. 🟠 Review is session-scoped and the frame does not say so

**Where:** the frame draws a standalone screen with a back arrow, implying it can be returned to.
**What:** it cannot. Leaving the result screen destroys the session. There is no history entry
point, because `GET /quizzes` (history) and `GET /quizzes/{quizId}` (review) are both draft.
**Fix we need:** confirm the review is reachable only from the result screen for now.
**Meanwhile:** exactly one entry point. `PopScope` on the result screen already sends Back to
`/learn`; do not add a second route in.

### 3. 🟡 The filter row — only `All` carries a count

**Where:** the chips read `All (10)` · `Correct` · `Wrong`.
**What:** `All` shows a count; `Correct` and `Wrong` do not. Confirm that is intentional rather than
a mockup shortcut. All three are derivable — `QuizSummary.totalQuestions`, `score`, and the existing
`wrong` getter — so adding counts to the other two is free if the designer wants them.
**Meanwhile:** build exactly what is drawn. Do not add counts the frame does not show, and do not
invent a number that is not one of those three.

### 4. 🟡 S14 and the code comment both need narrowing after this day

**Where:** `seif_fight.md` S14, and `quiz_result_screen.dart:120`.
**What:** both say review is blocked by a draft endpoint. After Day 9 that is true only of
*historical* review.
**Fix:** Step 2 updates both. Do not delete S14 — narrow it, and keep the promotion ask, because
`GET /quizzes/{quizId}` still unblocks S2 (resume) and history review.

---

# STEP 1 — Carry the session, and render it

**Nothing is user-visible at the end of this step.** The button stays disabled. This is deliberate:
the plumbing lands and is testable before the entry point opens.

**1. Capture before dispose.** `/quiz/:quizId/result` is entered with `pushReplacement`, which
disposes `QuizBloc`. Capture the session at the `QuizCompleted` transition in
`quiz_screen.dart._onStateChanged` — reading it after navigation is too late.

**2. Extend the args.** `QuizResultArgs` currently holds `{summary, scopeName}`. Add the review
payload. Prefer a purpose-built immutable view over passing `QuizSession` whole — given the frame,
the review needs only **`quiz.questions` (for text) and `grades` (for ✓/✕ and
`explanationAvailable`)**. It does **not** need `chosen`, `index` or `explanations`: the frame never
shows which option the student picked. Plain `@immutable` class with `==`/`hashCode`, same shape as
`QuizSetupArgs`; **not** freezed, so no codegen runs.

**3. Route.** Nest `review` under `/quiz/:quizId/result`, matching the existing nesting comment at
`app_router.dart:245`. Handle a missing/malformed `extra` the way `/quiz/:quizId` does — a graceful
unavailable view, **not** `state.extra!`. (The three existing force-unwraps at `/otp`,
`/quiz/setup` and `/quiz/:quizId/result` are a known defect; do not add a fourth.)

**4. The screen.** `lib/features/quiz/screens/quiz_review_screen.dart`.

⚠️ **Do NOT reuse `QuestionOptionTile`.** An earlier draft of this brief said to — that was written
before the frame was read, and it is wrong. `162:2377` renders **no options at all**. The row is a
tinted card: status circle + "QUESTION n" + question text, with an AI glyph on wrong rows. Build a
small private `_ReviewRow`; do not drag the option tile in and then hide four fifths of it.

Three row states:

| State | Condition | Render |
|---|---|---|
| Correct | `grades[qId].correct == true` | green tint, green ✓ circle |
| Wrong | `grades[qId].correct == false` | red/pink tint, red ✕ circle, AI glyph |
| Not answered | no entry in `grades` | neutral tint, no ✓/✕, no AI glyph — **conflict 1**, `TODO(design)` |

Plus the **filter row** (`All (n)` · `Correct` · `Wrong`) — pure client-side partitioning, counts
from `QuizSummary.totalQuestions` / `score` / `wrong`, which already exist as getters. Selection is
ephemeral local UI, so `setState` — not a notifier (`build-screen` Step 2).

Plus **empty** — a quiz finished with zero answers. There is **no loading, error or offline state**;
nothing is fetched. Do not wrap this in `StateWidget` to satisfy a checklist.

**5. Screen protection on.** Same treatment as `QuizScreen`.

**6. Row taps and the AI glyph — decide, do not guess.** The frame draws an AI-explanation glyph on
wrong rows but no destination frame exists for it, and no tap target is specified for the row
itself. `GET /questions/{id}/explanation` is **stable and already consumed**, and
`AiExplanationPanel` already exists — so this is buildable. It is nonetheless **out of scope for
Day 9** (assumption 6): ship the glyph as a non-interactive indicator, flag the missing destination
in `DESIGN_ISSUES.md`, and let the owner decide whether it becomes a tap target in a later step.

---

# STEP 2 — Open the door, and correct the record

**Only after Step 1 is committed and reviewed.**

1. `quiz_result_screen.dart`: replace `onPressed: null` with the push, delete the `Tooltip` wrapper
   and the `reviewQuestionsComingSoon` line beneath it. Leave the `reviewQuestions` key; retire
   `reviewQuestionsComingSoon` from both ARBs if nothing else uses it.
2. New l10n keys, both ARBs — screen title, the three row-state labels, empty-state copy, and the
   filter chips **if** the frame has them. Arabic written by a human, not machine-translated.
3. `seif_fight.md` S14 — narrow it per conflict 4. Keep the promotion ask.
4. `DESIGN_ISSUES.md` — add the skipped-question gap (conflict 1) and the session-scope note
   (conflict 2).
5. `PROGRESS.md` — new section, brief index entry, and **restate coverage as unchanged at 21/21
   stable · 0/16 draft**.
6. Vault (`F:\level\level_up\level_up\`, outside this repo): a screen note from
   `04_Screens/_Screen_Note_Template.md`, and any durable decision as one line in
   `00_Project/Decisions_Log.md`. If the vault is unreachable, say so — do not skip silently.

---

# Definition of done

- [ ] Step 0 gate answered in writing, with the Quiz Review node ID written into the frame map.
- [ ] Review Questions is live and reaches the screen; Tooltip and coming-soon line are gone.
- [ ] Three row states + empty render correctly. Loading / error / offline are **N/A by design** and
      reported as such, not ticked optimistically (`screen-states` requires the explicit statement).
- [ ] Screen protection verified enabled on the review route — by test, not by eye.
- [ ] A test asserts the review path writes nothing to storage.
- [ ] Widget tests for all four render states, built on the existing
      `test/features/quiz/quiz_harness.dart` + `quiz_fixtures.dart`. **mocktail**, never mockito.
- [ ] `flutter analyze` clean; full suite green; `test/guards/` green; goldens untouched.
- [ ] RTL pass: no `EdgeInsets.only(left:/right:)`, no `Alignment.centerLeft`, no hardcoded
      `TextDirection`, chevrons mirror. Verified on the Pixel 8 **in Arabic**.
- [ ] Endpoint coverage unchanged: **21/21 stable · 0/16 draft**.
- [ ] Two commits, one per step.
- [ ] Edge cases NOT handled, listed with reasons (`build-screen` Step 5).

---

# Out of scope — do not build

- **Historical review** — reaching this screen from anywhere but the result screen. Needs
  `GET /quizzes/{quizId}` (draft).
- **Quiz history list** — `GET /quizzes` is draft.
- **Quiz resume** (S2) — same draft endpoint.
- **AI explanations inside the review list** — assumption 6.
- **Favouriting a question from the review** — all three favourites endpoints are draft, and
  `QuizQuestion.isFavorite` stays parsed-and-unrendered.
- **A Pass/Fail verdict, a level-up celebration, a badge celebration** — no threshold in the
  contract (S13); `leveledUp` / `newBadge` have no frame.
- **The question-pool card on Quiz Setup** (S15) — real, unblocked, and the next day's work. Not
  this day.
- **Anything touching `contract/`**, any hand-edit of a `.g.dart` or `.freezed.dart`, any new
  dependency.

---

# Skills to load before starting

From `.claude/skills/` (the repo-root `skills/` folder is a backup mirror), in this order:

`level-up-domain` → `build-screen` → `bloc` → `figma-frame` → `screen-states` → `seif-api-contract`

At test time: `flutter-add-widget-test`, `dart-run-static-analysis`, `dart-add-unit-test`.

**Do not load:** `river` (scopes itself out of the quiz engine), `dart-generate-test-mocks`
(mockito — this repo uses mocktail `^1.0.5`), `dart-migrate-to-checks-package`,
`flutter-setup-declarative-routing`, `flutter-setup-localization`,
`flutter-apply-architecture-best-practices`, `flutter-add-widget-preview`,
`flutter-add-integration-test`, `flutter-build-responsive-layout`.

**Four stale claims inside those skills — this brief overrides them:**

1. `level-up-domain` and `seif-api-contract` say the API is snake_case and to bridge with
   `@JsonKey(name:)`. **Wrong — ADR-026 fixed camelCase on the wire.** Zero name bridges exist in
   the codebase and none may be added. (Recorded in `skills/RESTORE.md`.)
2. `bloc` promises a `QuizTimeExpired` event and a countdown timer. **Neither exists, deliberately**
   — no duration field in the contract (S7). Do not add one, do not look for one.
3. `bloc`'s example state names are illustrative fiction. The real machine is `QuizInitial` /
   `QuizActive` → `QuizInProgress` · `AnswerConfirming` · `AnswerFailed` · `QuizFinishing` ·
   `FinishFailed` · `QuizCompleted`. Read `quiz_state.dart`.
4. `build-screen` Step 4 and `screen-states` Step 4 reference `04_Screens/`,
   `00_Project/Decisions_Log.md` and `01_Flutter_Specs/`. Those live in the **vault** at
   `F:\level\level_up\level_up\`, not in this repo.
