# Day 7 — execution prompt for Claude Code

> Paste the fenced block below into Claude Code, in the `level_up_app` repo, on branch `dev`.
> Kept as a file on purpose: durable truth lives in files, not chat memory.
>
> **State at handoff (2026-07-30):** `dev` is 4 commits ahead of `origin/dev` — Day 6 parity,
> Day 00 onboarding, Android release signing, security hardening. Nothing pushed, tree clean.
> Day 7 is fully specified in `docs/day7_quiz_brief.md` and not started.
>
> **Why this prompt is phased:** Day 7 is the largest day in the project — 4 screens, a new state
> library, 4 endpoints, and the first content-protection work. A flat "read the brief and build it"
> reliably produces screens before models and a mock backend bolted on at the end that nobody can
> demo. The order below is deliberate. The mock lands *before* the screens so every screen is
> exercised against real-shaped data from its first render.

---

```
# ROLE

You are implementing Day 7 of the Level Up Flutter app: the quiz engine
(setup → take → results). This is the largest day in the project so far and the
first to use Bloc. Work methodically and in the order given below.

# SOURCE OF TRUTH — in precedence order

1. contract/openapi.yaml (pinned 23f0535) — the server is authoritative. Where the
   contract and the design disagree, the contract wins.
2. docs/day7_quiz_brief.md — self-contained spec. Every conflict in it is ALREADY
   resolved with an owner decision. Follow those decisions; do not relitigate them.
3. The Figma frames — pull them yourself; the brief gives you the node map, not the
   pixel spec.
4. Existing repo patterns — match the surrounding code.

If any two of these contradict each other in a way the brief has not already settled,
STOP and tell me. Do not guess.

# EXECUTION ORDER

Work the phases in sequence. Do not start a phase until the previous one's exit
criteria are met. Invoke each skill at the phase where it is listed, not all upfront.

## Phase 0 — Ground yourself
  Skill: `level-up-domain`
  - Read docs/day7_quiz_brief.md end to end.
  - Read the quiz section of contract/openapi.yaml (lines ~749–935) directly. Do not
    work from the brief's summary of it.
  - Read what already exists: lib/features/quiz/ (quiz_setup_args.dart, quiz_type.dart),
    lib/features/catalog/screens/lessons_screen.dart and lectures_screen.dart (they
    build the args), lib/core/models/screen_state.dart, lib/core/network/.
  Exit: you can state the 4 endpoints, their error codes, and how QuizSetupArgs
  already encodes the school/university split.

## Phase 1 — Plan, then STOP
  Skill: `build-screen`
  Produce a short plan covering:
  - files you will create/modify, grouped by phase
  - the QuizBloc state shape and its events
  - where the QuestionRenderer seam sits (see NON-NEGOTIABLES #6)
  - anything in the brief you think is wrong
  Exit: I approve the plan. DO NOT WRITE CODE BEFORE THIS.

## Phase 2 — Models + repository (contract-first)
  Skill: `seif-api-contract`
  - freezed + json_serializable models: Quiz, QuizQuestion, QuizOption, AnswerResult,
    QuizSummary, QuizMode. camelCase wire names — no @JsonKey bridges.
  - quiz_repository.dart: createQuiz / submitAnswer / finishQuiz / getExplanation,
    throwing typed AppException like every other repository.
  - Extend, do not replace, the existing quiz_setup_args.dart and quiz_type.dart.
  Exit: `dart run build_runner build --delete-conflicting-outputs` succeeds; model
  toJson/fromJson unit tests pass against contract-shaped fixtures.

## Phase 3 — Mock backend  ← BEFORE the screens, on purpose
  - Extend lib/dev/mock_backend.dart with all four endpoints, contract-faithful.
  - Include every error path: weekly_question_limit_reached, not_enough_questions,
    quiz_already_finished, insufficient_scope, and a 202-then-200 explanation so the
    polling path is walkable.
  - Make both tracks reachable (000000 = school, 111111 = university at the OTP screen).
  Rationale: AppConfig.baseUrl is still TBD.example. Without the mock, no screen you
  build in Phase 5 can be run, and every prior day shipped its mock work.
  Exit: mock tests green; you can describe how to walk setup → quiz → result on device.

## Phase 4 — QuizBloc
  Skill: `bloc`
  - This is the day flutter_bloc finally gets used. lib/features/quiz/bloc/ has held a
    .gitkeep since Day 0. The repo rule is Riverpod everywhere EXCEPT the quiz.
  - QuizBloc owns ONE quiz session: questions, current index, per-question grade,
    explanation state, finished summary. It is renderer-agnostic.
  - Setup is NOT a Bloc concern — one request then navigate. A small AsyncNotifier or
    FutureProvider is correct there. Riverpod is also still correct for invalidating
    /me after finish.
  Exit: bloc_test coverage of the full session — load, answer, regrade-on-retry,
  finish — with a mocked repository.

## Phase 5 — Screens, in this order
  Skills: `figma-frame`, `build-screen`
  Pull each frame with get_design_context before building it. Never eyeball a token.
    5a. Quiz setup       135:1622 / 309:5771
    5b. Quiz taking      159:845, 159:1431, 159:1695 (AI panel), 159:1852 (photo)
    5c. Quiz results     159:1964 / 309:6375
    5d. Limit sheet      199:2335 / 225:6634
  Delete quiz_setup_placeholder.dart once /quiz/setup points at the real screen.
  Exit: each screen runs against the mock in light + dark, AR + EN.

## Phase 6 — Cross-cutting
  - screen_protector ON entering the quiz screen, OFF on dispose (NON-NEGOTIABLES #9).
  - Router: point /quiz/setup and /quiz/:quizId at the real screens; add the results
    route; results must not back-navigate into a finished quiz.
  - l10n: every new key in BOTH .arb files, including all five error codes.
  Exit: no hardcoded user-facing strings; `flutter gen-l10n` clean.

## Phase 7 — Tests
  Skill: `flutter-add-widget-test`
  Widget tests for all four screens. Include the two that catch real bugs:
  - a partially-answered quiz, asserting wrong = answeredCount − score and that
    Skipped renders
  - a submit retry, asserting the original grade is returned and points are not
    double-counted

## Phase 8 — Verify
  Skills: `screen-states`, `dart-run-static-analysis`
  - Work the brief's acceptance checklist item by item.
  - screen-states matrix in full: loading / error / offline × AR + EN × light + dark.
  - flutter analyze clean; full suite green.
  - Run the self-verification greps below.

## Phase 9 — Docs, then report
  - seif_fight.md: S11–S16. DESIGN_ISSUES.md and PROGRESS.md per the brief's
    "Docs to update" section.
  - Report in the format at the bottom of this prompt.
  - DO NOT COMMIT. Leave it for review.

# NON-NEGOTIABLES

1. NO client-side points arithmetic, anywhere. The design promises "+30" and "+200";
   the contract awards 0 or 1 per question. Render pointsAwarded from the server and
   OMIT the setup screen's points preview entirely.
2. wrong = answeredCount − score. NOT totalQuestions − score. Unanswered questions are
   recorded unanswered, not wrong. Render Skipped when answeredCount < totalQuestions.
3. Submit is idempotent on (quizId, questionId): a retry returns the ORIGINAL grade and
   never double-awards. Do not suppress retries client-side.
4. correctOptionId is revealed ONLY in the answer response. Nothing is sent when the
   student selects an option — only on Confirm.
5. The explanation endpoint returns 202 while generating — poll with 2s backoff. A 403
   before the student has answered that question is EXPECTED, not a bug.
6. Build the QuestionRenderer seam (QuizScreen owns the shell; the renderer is the only
   part that varies) but do NOT build a flashcard renderer, an isFlashcard bool, or a
   flashcard enum member. The seam is the deliverable — there is no contract shape to
   build against.
7. QuizMode carries all three contract values; only `normal` is offered, via a single
   _offeredModes list. Every switch on it is exhaustive with NO default:.
8. isFavorite is parsed into the model (it is a required field) and NO control is
   rendered.
9. screen_protector ON entering the quiz screen and OFF on dispose. Verify it; do not
   assume it. This closes a HIGH finding from docs/LEVEL_UP_AUDIT_2026-07-28.md.
10. Quiz state is in-memory only. Do NOT cache questions to Hive — the contract frames
    the question bank as the product. Add a confirm-on-exit dialog instead.

# DO NOT BUILD

These are in the same Figma group but are NOT quiz states:
  225:5582   Flash cards — a second renderer, zero contract support
  222:5252   empty leftover frame, renders blank
  404:6853 / 404:7234   these belong to the My Fault flow, a row below
Also out: retakeWrong and favorites modes, My Fault screens, quiz history, resume,
Review Questions as a working flow (render it DISABLED), the Pass/Fail verdict (omit
it), the question-pool progress card (hide it), Paymob purchase.

# SELF-VERIFICATION — run these before reporting

  grep -rn "default:" lib/features/quiz/          → no switch on QuizMode/QuizType
  grep -rniE "\+ *[0-9]+ *points|points *\*|\* *points" lib/features/quiz/   → empty
  grep -rn "Hive\|hive" lib/features/quiz/        → empty
  grep -rnE "0xFF|Color\(0x" lib/features/quiz/   → empty (tokens only)
  grep -rn "left:\|right:" lib/features/quiz/     → empty (EdgeInsetsDirectional)
  grep -rn "totalQuestions - \|totalQuestions -" lib/features/quiz/  → not used for wrong
Confirm every new l10n key exists in BOTH app_en.arb and app_ar.arb.

# FINAL REPORT FORMAT

  - one line: analyze status, test count (and delta), commit status
  - the acceptance checklist, item by item, with ✅ / ❌ and one line of evidence each
  - "Deviations you should know about" — anything you did differently from the brief,
    and WHY. Be specific; a deviation with a good reason is fine, a silent one is not.
  - "Also worth flagging" — anything you noticed that is out of scope but matters.

# STOP CONDITIONS

Stop and ask me, rather than guessing, if:
  - the contract and the brief disagree in a way the brief has not already settled
  - a Figma frame shows something with no contract field behind it (there are already
    six such cases; a seventh is possible)
  - a decision would be hard to reverse later
  - the brief tells you to do something that turns out to be impossible
```

---

## Open items that are NOT Day 7's job

- **`seif_fight.md` is ready to send to Seif** — 16 entries. Lead with **S6** (the orphan error
  code: `flashcard_subscription_required` is defined in `error-codes.md` but no endpoint can
  return it), then **S14/S2** (promoting `GET /quizzes/{quizId}` unblocks quiz review *and* resume
  in one move), then **S12** (points off by ~20×).
- **Day 8 closes Milestone 1** on endpoint coverage: `PATCH /me` is the only stable endpoint left
  after Day 7 → Profile / Edit Profile / Settings → 21/21.
- **But M1 ≠ the design.** Leaderboard and checkout are `draft`; Messages, Friends, Customer
  Support, Notifications, Refer a Friend and "your progress" have **no contract path at all**. At
  the end of Day 8 the app has 3 of 5 tabs real and no working purchase path.
- **Still open from the security pass:** OTP screen protection + plaintext OTP digits, TLS
  pinning, and the Paymob deep-link rule (treat the return link as a hint to refetch, never as
  proof of payment).
- `PROGRESS.md` is stale beyond the three fields Day 00 corrected — it still reads as though Day 2
  is in progress.
