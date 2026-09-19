# Day 8-9 Brief — Quiz Review (session-scoped, Figma-verified)

> Repo `level_up_app`, branch **`merged`**. Self-contained.
> Figma file key `P6044i0giD9TmdQ7C2AmLq`, page **`design`** · Contract `contract/openapi.yaml`
> pinned **`184d6ec` (3.0.0-m1)** — see `contract/SOURCE.md`.
> Written **2026-09-08**. Baseline at time of writing: `tool/validate.ps1` → **OVERALL: PASS,
> 890 passed / 0 failed** (BUILD VERIFIED, this session).
>
> **This brief supersedes `docs/day9_quiz_review_brief.md`** for the screen spec. That brief is
> still correct about *strategy* — session-scoped review, zero endpoints, two steps — and its
> Step 2 checklist and out-of-scope list are still authoritative. What it could not supply was
> the design: it opens with a Step 0 gate that asks whoever picks it up to *find* the Quiz Review
> node ID and write it into the frame map. **That gate is now closed.** Every number below was
> read out of the Figma properties panel in a logged-in browser session on 2026-09-08, not
> eyeballed from a screenshot. Node IDs are recorded.
>
> **This day consumes ZERO endpoints.** Coverage before and after must read
> **21/21 stable · 0/15 draft**. If that number moves, something went wrong.

---

## 0. Why this screen, and why now

`docs/seif_fight.md` **S14** says "Review Questions" is blocked on `GET /quizzes/{quizId}`, which
is `x-stability: draft` (`openapi.yaml:1010`). That is true for **historical** review and stays
true. It is **not** true for the frame's actual entry point.

At the moment `POST /quizzes/{quizId}/finish` returns, the app already holds — in
`QuizSession` — every field the draft `QuizReview.questions[]` schema would return:

| `QuizReview.questions[]` (`openapi.yaml:1692`) | Already in `QuizSession` |
| --- | --- |
| the question + its options | `quiz.questions` |
| `selectedOptionId` | `chosen[questionId]` |
| `correctOptionId` | `grades[questionId].correctOptionId` |
| `correct` | `grades[questionId].correct` |
| `explanationAvailable` | `grades[questionId].explanationAvailable` |

Field for field. The screen is therefore buildable today, from state the app already owns, with
**no new endpoint, no new model and no contract change**.

The only thing standing in the way is self-inflicted: `QuizCompleted`
(`lib/features/quiz/bloc/quiz_state.dart:169`) drops the session and carries only
`{summary, scopeName}`, and `QuizResultArgs` (`lib/features/quiz/screens/quiz_screen.dart:406`)
carries the same two. Carry the review payload through and the screen has its data.

**Honest limits, to be stated in the PR body and not papered over:**

- Reviews **only the quiz just finished**. Not from history.
- Dies with the process. `QuizSession` is in-memory by design — the contract frames the question
  bank as the product ("correct answers never ship with questions — content protection"), so
  nothing here may be cached to Hive. See seif_fight S2.
- Reachable **only** from `/quiz/:quizId/result`.

---

## 1. The frames — verified, with node IDs

**Read on 2026-09-08 via the Chrome extension against the live file, Properties panel, 61% and
100% zoom. File is view-only on this account (`figma` MCP is Seif's — see the memory note), so
Dev Mode inspect is unavailable; every value below came from the read-only Properties panel.**

### 1.1 The naming trap — read this before you search Figma

The Quiz Review frame's **layer name is `quiz Result`**, not "Quiz Review". So is the actual
result screen's. Both flows carry **two adjacent frames both named `quiz Result`** — the second
of each pair is the review. The string "Quiz Review" appears only as the *header text inside*
the frame. Searching the layer tree for "Review" finds nothing. This is why the Day 9 Step 0
gate could not resolve the node ID.

### 1.2 Frame map

| Variant | Section | Frame node | Page fill |
| --- | --- | --- | --- |
| **Light (build against this)** | `light mode` → `School Student Flow` | **`162:2377`** | `#FCFBF9` |
| **Dark** | `Dark mode` → `School Student Flow` | **`337:6705`** | `#232428` |
| **RTL** | `RTL` → `School Student Flow` | **`549:20324`** | `#FCFBF9` |

Frame geometry, all three: **402 × 966, corner radius 30**.

**All three variants exist.** The Day 9 brief did not know this and planned an RTL pass by
mirroring rules alone. There is a drawn RTL frame — use it, and read §4 before you trust it.

### 1.3 Light-mode measurements

Every value below is transcribed from the Properties panel.

**Header title** — node `162:2411`
```
text     "Quiz Review"      145 × 31
font     Inter 700 Bold
size     22px / line-height 30.8px / letter-spacing 0
align    Center
colour   #000000
```

**Filter row** — three sibling `Button` nodes inside `Frame 1000003035`

| | Selected ("All (10)") `162:2780` | Unselected ("Correct") | Unselected ("Wrong") `162:2784` |
| --- | --- | --- | --- |
| flow | Vertical (no icon) | Horizontal, **gap 10** | Horizontal, **gap 10** |
| size | Hug 72 × 32 | Hug 102.01 × 32 | Hug 99.01 × 32 |
| radius | stadium (`39602500px`) | stadium | stadium |
| padding | 6 / 12 / 6 / 12 | 6 / 12 / 6 / 12 | 6 / 12 / 6 / 12 |
| fill | **`#4B675E`** | `#FCFBF9` + drop shadow | `#FCFBF9` + drop shadow |

Label (`162:2781`, "All (10)", 48 × 20): **Inter 600 SemiBold, 14px / 20px, ls 0, Center,
`#FCFBF9`** on the selected pill.

**Only the "All" chip carries a count.** "Correct" and "Wrong" are bare labels with a leading
glyph (green dot / red ✕). Do not invent counts for them.

**Question rows** — 362 × 73, radius 16, border 0.5px all sides, inner alignment

| | Correct `162:2502` | Wrong `162:2563` |
| --- | --- | --- |
| fill | **`#BFFFC3`** | **`#FDE9E8`** |
| border | **`#00D33C`** | **`#921019`** |
| status circle | `#22C55E` | `#EF4444` |
| AI glyph | absent | present |

**Status circle** (`162:2504`): a `Container` **27.99 × 27.99**, stadium radius, border 1.18px,
filled with the colour above. Inside it an `Icon` frame **14 × 14** whose vectors are `#FFFFFF`
at 1.17px stroke — the ✓ / ✕.

**"QUESTION n" label** (`162:2577`): **Inter 400 Regular, 12px / 18px, ls 0**, 73 × 18, offset
4.38px from the block top.

**Question text** (`162:2510`): **Inter 500 Medium, 18px / 25.6px, ls 0**, colour **`#384F47`**,
315.68 × 26.

**AI glyph**: Iconify component **`tdesign:ai-education`**, **26.55 × 26.55**, positioned top
10.83 / left 325 within the row; vector stroke 2.21px, colour **`#384F47`**. **Wrong rows only.**

### 1.4 Dark mode — one clean rule

The dark frame does **not** introduce new row colours. It reuses the light hexes at **20%
opacity** over `#232428`:

| | Dark value |
| --- | --- |
| correct row fill (`337:6731`) | `#BFFFC3` **@ 20%** |
| wrong row fill | `#FDE9E8` **@ 20%** |
| row geometry / radius / border | unchanged (362 × 73, 16, 0.5px) |
| selected filter pill (`337:6825`) | **`#AE87E7`** — the purple accent, geometry unchanged |

This matches the app's documented light-green → dark-purple accent flip
(`app_colors.dart:9`, `:98`). The *rows* keeping their hue in both canvases also matches the
existing rule in `app_colors.dart:236`: **"a correctness signal must never flip colour with the
canvas."**

⚠️ But note the app currently ships the *same opaque* row fills in both themes
(`app_colors.dart:597-601`). The review frame's dark rows are **20% alpha**, the quiz-page rows
are not. That is a genuine divergence — see §3.2.

---

## 2. What the codebase already gives you

Verified this session against the tree at HEAD.

**Already built and reusable:**

- `lib/features/quiz/bloc/quiz_state.dart` — `QuizSession` holds `grades`, `chosen`,
  `explanations`; `QuizCompleted` is the terminal state to extend.
- `lib/features/quiz/screens/quiz_result_screen.dart:118` — the disabled CTA to switch on.
- `lib/features/quiz/screens/screen_protection.dart` — apply to the review route.
- `test/features/quiz/quiz_fixtures.dart` + the quiz harness — build the widget tests on these.
- `lib/features/quiz/widgets/ai_explanation_panel.dart` — exists; **not** wired into review this
  day (Day 9 assumption 6 stands).

**Colours that already exist and match the frame exactly — reuse, do not re-add:**

| Frame value | Existing token | Where |
| --- | --- | --- |
| `#BFFFC3` | `quizCorrectFill` | `app_colors.dart:528` |
| `#00D33C` | `quizCorrectBorder` | `app_colors.dart:529` |
| `#22C55E` | `successBadge` | `app_colors.dart:524` |
| `#EF4444` | `quizWrongBadge` | `app_colors.dart:532` |
| `#384F47` | `greenPrimary` | `app_colors.dart:8` |
| `#AE87E7` | `purplePrimary` | `app_colors.dart:9` |
| `#4B675E` | already in the palette (bell ring, language pill, nav) | `app_colors.dart:147` |
| `#FCFBF9` | cream, already in the palette | throughout |

That is **eight of ten** colours already present. Only two are new, and both are §3 problems.

---

## 3. STOP AND ASK — three items. Do not guess past any of them.

`docs/AGENT_WORKFLOW.md` §"Never invent" names typography scales and design tokens explicitly.
All three below fall inside it.

### 3.1 The wrong-row colours do not match the quiz page's — by 1 hex digit and by opacity

| | Quiz **page** (`308:5158`, shipped) | Quiz **review** (`162:2563`, this frame) |
| --- | --- | --- |
| fill | `Color(0x4DFFC0C0)` — rgba(255,192,192,.3) | **`#FDE9E8`** — opaque |
| border | `Color(0xFF921119)` | **`#921019`** |

The *correct*-row values are byte-identical across the two frames (`#BFFFC3` / `#00D33C`). Only
the wrong-row pair differs, and the border differs by a single digit (`921119` vs `921019`).

**That pattern reads as designer drift, not intent** — but "reads as" is not evidence, and
`app_colors.dart` is guard-enforced with zero exceptions across 36k lines.

**Ask the designer:** are `#FDE9E8` / `#921019` deliberate for the review row, or should the
review reuse the shipped `quizWrongFill` / `quizWrongBorder`? Log the answer in
`docs/DESIGN_ISSUES.md` either way. Do **not** silently reuse the existing tokens because they
are "close enough", and do **not** add near-duplicate tokens on your own judgement.

### 3.2 Dark-mode row opacity contradicts the shipped dark theme

Review frame: rows at 20% alpha in dark. Shipped app: identical opaque values in both themes
(`app_colors.dart:597-601`), justified in a comment at `:236` — *a correctness signal must never
flip colour with the canvas.*

**Ask:** does the review row follow the frame (20% alpha, dark-specific) or the existing rule
(opaque, canvas-independent)? This is a design-system decision, not a screen decision — whatever
is chosen should apply to the quiz page too, or the two screens will disagree in dark mode.

### 3.3 **None of the four text styles in this frame exists in `AppType`** — this is the blocker

| Frame | Nearest `AppType` | Gap |
| --- | --- | --- |
| 22 / 30.8, w700 (title) | `h1` 24/30 w700 · `h2` 20/26 w700 | **no 22px in the scale at all** |
| 14 / 20, w600 (chip) | `labelLarge` 14/18 w600 · `buttonMedium` 14/18 w600 | line-height 20 vs 18 |
| 12 / 18, w400 (QUESTION n) | `captionRegular` 12/16 w400 | line-height 18 vs 16 |
| 18 / 25.6, w500 (question) | `h3` 18/24 w600 | **weight and height both differ** |

This matters more than it looks. `test/core/theme/typography_discipline_test.dart` bans inline
`fontSize` anywhere outside `lib/core/theme/`, and the ratchet in
`test/guards/project_rules_test.dart:176` is **`const baseline = 0`**. There is no room to fudge
a single call site.

Three options, owner's call — **do not pick one yourself**:

1. **Map to nearest** (`h2` title, `labelLarge` chip, `captionRegular` label, `h3` question),
   accept the line-height/weight drift, and log all four in `docs/DESIGN_ISSUES.md`. Cheapest;
   the screen will be ~2px off the frame in four places.
2. **Ask the designer to extend `typography-style-inter.md`** with the missing entries, then
   transcribe into `AppType`. Correct; blocks the day until they answer.
3. **Ask the designer to re-spec the frame onto the existing scale.** Cleanest long-term.

> ⚠️ **`CLAUDE.md` is stale here.** Its one-screen non-negotiables say *"No new hardcoded
> `fontSize`. The ratchet is 153 and Wave 3D is BLOCKED."* The ratchet was **lowered to 0 on
> 2026-08-21** when the designer supplied the scale and all 153 call sites were migrated
> (`project_rules_test.dart:166-168`; R-1 closed). Fix that line while you are in here.

---

## 4. RTL — the drawn frame is only half-done

`549:20324` exists, and it is **not** a clean mirror. Verified:

| Element | State in the RTL frame |
| --- | --- |
| back chevron | ✅ correctly mirrored to the **right** edge |
| filter row | ✅ correctly mirrored — runs right→left: `الكل (10)` · `صحيح` · `خطأ` |
| **header title** | ❌ **still reads "Quiz Review" in English** |
| **question rows** | ❌ **not mirrored** — status circle still left, AI glyph still right |
| **row copy** | ❌ still English placeholder ("What is the powerhouse of the cell?") |

**Build the rows mirrored anyway.** Row content is directional text and the rest of the app
mirrors its list rows; an unmirrored row here is an artefact of the designer filling the frame
with LTR placeholder content, not a decision. Log it in `docs/DESIGN_ISSUES.md` as *"RTL review
rows drawn unmirrored — implemented mirrored; confirm"* rather than reproducing the bug.

**Arabic copy — one divergence to settle.** The app already ships
`reviewQuestions: "مراجعة الأسئلة"` (`app_ar.arb:186`). The RTL result frame's CTA reads
**`مراجعة الاجابات`** ("review the answers"). The app's string is arguably the better match for
the English *"Review Questions"*, and it is already shipped and human-written. **Keep the app's
string**; note the divergence. Do not machine-translate anything new.

New Arabic strings must be **written by a human**, per the Day 9 brief and the project rule.

---

## 5. Skills to load, in this order

From `.claude/skills/` (the repo-root `skills/` folder is a backup mirror):

```
level-up-domain  →  build-screen  →  bloc  →  figma-frame  →  screen-states  →  seif-api-contract
```

- **`level-up-domain`** — glossary terms verbatim (Question, QuizSummary, StreakPair…); the
  purchase-silent rule (adr-049 §3) — this screen must not gain any upgrade affordance.
- **`build-screen`** — the standard loop. Step 5 (list the edge cases you did *not* handle) is a
  deliverable, not advice.
- **`bloc`** — mandatory: this is inside `lib/features/quiz/`, the one Bloc island. The rest of
  the app is Riverpod and `test/guards/project_rules_test.dart:34` enforces the boundary.
- **`figma-frame`** — tokens come from Figma, never eyeballed. §1 is the output of following it;
  re-read the frame if you touch anything §1 does not cover.
- **`screen-states`** — required before calling the screen done. See the N/A note in §7.
- **`seif-api-contract`** — even though zero endpoints are consumed, read it before you touch
  `QuizSession` or anything that looks like a model.

At test time: `flutter-add-widget-test`, `dart-run-static-analysis`, `dart-add-unit-test`.

**Do NOT load:** `river` (it scopes itself out of the quiz engine), `dart-generate-test-mocks`
(this repo uses **mocktail**, never mockito).

---

## 6. Workflow, hooks and CI — checked this session

### 6.1 The loop

`docs/AGENT_WORKFLOW.md` — canonical loop (§"The canonical loop"), **predict before you run**
(§37), verification levels (§43), **planning is mandatory** (§95), **DO-NOT-GUESS** (§207),
**stop and ask** (§269), **never invent** (§283). §3 of this brief is a stop-and-ask; do not
start Step 1 until it is answered in writing.

### 6.2 Hooks — ⚠️ **not installed on this clone**

`.githooks/pre-push` exists and delegates to `tool/validate.sh` (guard-enforced by
`test/guards/workflow_test.dart:282`). But:

```
git config --get core.hooksPath   →  (empty)
ls .git/hooks/                    →  only *.sample
```

**Nothing runs on push here.** Either enable it once —

```bash
git config core.hooksPath .githooks
```

— or accept that `tool/validate.ps1` is a manual step and actually run it. Do not assume a green
push means a green suite. There are also **no Claude Code hooks**: `.claude/settings.json` is
empty and there is no `.claude/hooks/` directory; `.claude/settings.local.json` carries
permissions only.

### 6.3 CI — `.github/workflows/ci.yml`

Triggers on PR **and** push to `dev`, `main`, `merged`; concurrency-cancelled per ref.

| Job | Runner | When | Blocking? |
| --- | --- | --- | --- |
| `analyze-and-test` | ubuntu | every PR + push | ✅ **the gate** |
| `goldens` | windows | every PR + push | ⚠️ advisory (`continue-on-error: true`) |
| `codegen-drift` | ubuntu | **main only** | ✅ |
| `build-release-apk` | ubuntu | **main only** | ✅ |

What the gate will check on this work, in order — anticipate all of it before pushing:

1. **INTERNET permission** in `android/app/src/main/AndroidManifest.xml` (Tier-0 C-1 regression
   guard). Don't touch the manifest.
2. **`pubspec.lock` must not drift** — no new dependency this day, so this is free.
3. **`flutter gen-l10n` must be a no-op** — so after editing either `.arb`, regenerate and
   **commit `lib/l10n/app_localizations*.dart`**. Forgetting this is the single most likely way
   this day fails CI, because the new screen adds strings.
4. **`dart format`** on hand-written Dart only (generated files excluded).
5. **`flutter analyze --no-pub`** — must be 0 issues.
6. **`flutter test --exclude-tags golden`** — the whole tree, no path argument.
   `test/guards/workflow_test.dart:25` fails the build if anyone reintroduces a path.

**Do not add a golden** for this screen unless you also tag it `@Tags(['golden'])` — an untagged
golden runs on the Linux gate and fails for platform reasons that look like a real regression
(`workflow_test.dart:58` guards this).

### 6.4 Guards that will fire on careless work

| Guard | File | What trips it |
| --- | --- | --- |
| palette | `test/core/theme/palette_discipline_test.dart` | any colour literal outside `lib/core/theme/` |
| typography | `test/core/theme/typography_discipline_test.dart` | any inline `fontSize` outside `lib/core/theme/` |
| fontSize ratchet | `test/guards/project_rules_test.dart:176` | count > **0** |
| Bloc boundary | `test/guards/project_rules_test.dart:34` | `flutter_bloc` outside `lib/features/quiz/` |
| BUG-001 | `test/guards/project_rules_test.dart:51` | provider write in `initState` |
| `autoDispose` lifecycle | `test/guards/project_rules_test.dart:69` | an `autoDispose` notifier that `await`s without tracking its own disposal |
| hardcoded copy | `test/guards/project_rules_test.dart:124` | a NEW file with a user-facing string not via `AppLocalizations` |
| l10n parity | `test/guards/project_rules_test.dart:190` | a key in one ARB and not the other |

Note the split: the **detectors** live in `test/guards/rules.dart` and are proven able to fire in
`test/guards/rules_test.dart`; `project_rules_test.dart` is the file that points them at `lib/`
and records the policy. A change to a detector needs both.

Prove a guard can still fail before trusting it:

```powershell
powershell -ExecutionPolicy Bypass -File tool\verify_guards.ps1
```

### 6.5 Baseline to beat

```powershell
powershell -ExecutionPolicy Bypass -File tool\validate.ps1
```

Ran clean this session: **format PASS · analyze PASS (0 issues) · tests PASS (890/0) ·
OVERALL: PASS**. Anything below 890 after this work is a regression — find it before doing
anything else.

---

## 7. The build — two steps, one commit each

### STEP 1 — the screen, dark, unreachable

**Only after §3 is answered in writing.**

1. **Retain the session at finish.** `QuizCompleted` currently carries `{summary, scopeName}`.
2. **Extend the args.** Add a review payload to `QuizResultArgs`. Prefer a purpose-built
   immutable view over passing `QuizSession` whole: the frame needs **`quiz.questions`** (text)
   and **`grades`** (✓/✕). It does **not** need `chosen` — §1.3 confirms the row renders no
   options, so the student's pick is never shown. Plain `@immutable` class with `==`/`hashCode`,
   same shape as `QuizSetupArgs`; **not** freezed, so no codegen runs and `codegen-drift` stays
   quiet.
3. **Route.** Nest `review` under `/quiz/:quizId/result`, matching the nesting comment at
   `app_router.dart:245`. Handle a missing/malformed `extra` the way `/quiz/:quizId` does — a
   graceful unavailable view, **not** `state.extra!`. (The three existing force-unwraps at
   `/otp`, `/quiz/setup` and `/quiz/:quizId/result` are a known defect; do not add a fourth.)
4. **The screen.** `lib/features/quiz/screens/quiz_review_screen.dart`, class `QuizReviewScreen`.

   ⚠️ **Do not reuse `QuestionOptionTile`.** `162:2377` renders no options at all. Build a small
   private `_ReviewRow` to the §1.3 spec; do not drag the option tile in and hide four fifths
   of it.

   Three row states:

   | State | Condition | Render |
   | --- | --- | --- |
   | Correct | `grades[qId].correct == true` | `#BFFFC3` fill, `#00D33C` 0.5px border, `#22C55E` circle, **no** AI glyph |
   | Wrong | `grades[qId].correct == false` | per §3.1 once answered, `#EF4444` circle, AI glyph |
   | Not answered | no entry in `grades` | **conflict — the frame has no state for this.** Neutral tint, no ✓/✕, no glyph; `TODO(design)` + `DESIGN_ISSUES.md` entry |

5. **Filter row** — `All (n)` · `Correct` · `Wrong`, pure client-side partitioning. The count on
   *All* only (§1.3). Selection is ephemeral local UI, so `setState` — **not** a notifier
   (`build-screen` Step 2). Counts come from `QuizSummary.totalQuestions` / `score` / `wrong`,
   which already exist as getters.
6. **Empty state** — a quiz finished with zero answers.
7. **Screen protection on**, same treatment as `QuizScreen`.
8. **AI glyph is a non-interactive indicator this day.** The frame draws it on wrong rows but no
   destination frame exists and no tap target is specified. `GET /questions/{id}/explanation` is
   stable and `AiExplanationPanel` exists, so it *is* buildable — but it is out of scope
   (Day 9 assumption 6). Flag the missing destination in `DESIGN_ISSUES.md` and let the owner
   decide.

### STEP 2 — open the door, correct the record

**Only after Step 1 is committed and reviewed.**

1. `quiz_result_screen.dart` — replace `onPressed: null` with the push; delete the `Tooltip`
   wrapper and the `reviewQuestionsComingSoon` line beneath it. Keep the `reviewQuestions` key;
   retire `reviewQuestionsComingSoon` from **both** ARBs if nothing else uses it. Regenerate
   l10n and commit the generated files (§6.3 item 3).
2. New l10n keys, both ARBs — screen title, the three row-state labels, empty-state copy, filter
   chips. Arabic **written by a human**.
3. `docs/seif_fight.md` **S14** — narrow it: review-from-result is now shipped; the promotion ask
   for `GET /quizzes/{quizId}` stays, for **history** and for **resume** (S2).
4. `docs/DESIGN_ISSUES.md` — the §3.1 colour drift, the §3.2 dark-opacity conflict, the §3.3
   typography gaps, the §4 RTL gaps, the skipped-question row state, and the AI-glyph
   destination.
5. `CLAUDE.md` — fix the stale ratchet line (§3.3).
6. `docs/PROGRESS.md` — new section, brief index entry, coverage restated as **unchanged at
   21/21 stable · 0/15 draft**.
7. `docs/WAVE_STATUS.md` — it wins over every other document; update it or this brief is stale
   the day it lands.

---

## 8. Definition of done

- [ ] §3 answered **in writing** by the owner/designer before Step 1 started.
- [ ] Review Questions is live and reaches the screen; Tooltip and coming-soon line are gone.
- [ ] Three row states + empty render correctly, against the §1.3 numbers.
- [ ] Loading / error / offline are **N/A by design** — nothing is fetched. State this
      explicitly; `screen-states` requires the statement, not a silently ticked box.
- [ ] Screen protection verified enabled on the review route — **by test, not by eye**.
- [ ] A test asserts the review path writes nothing to storage.
- [ ] Widget tests for all four render states, on `test/features/quiz/quiz_fixtures.dart` +
      the existing harness. **mocktail**, never mockito.
- [ ] `tool/validate.ps1` → **OVERALL: PASS**, tests **≥ 890**.
- [ ] `tool/verify_guards.ps1` still proves the guards can fail.
- [ ] RTL pass: no `EdgeInsets.only(left:/right:)`, no `Alignment.centerLeft`, no hardcoded
      `TextDirection`, chevron mirrors, rows mirror. Verified **on device, in Arabic** — DEVICE
      VERIFIED, not SOURCE.
- [ ] Dark mode verified on device. (Memory records dark mode as dead on 2026-08-04 — confirm it
      works at all before claiming this screen is correct in it.)
- [ ] Endpoint coverage unchanged: **21/21 stable · 0/15 draft**.
- [ ] Two commits, one per step, Conventional Commits, bodies carrying reasoning.
- [ ] Edge cases NOT handled, listed with reasons (`build-screen` Step 5).

---

## 9. Out of scope — do not build

- **Historical review** — reaching this screen from anywhere but the result screen. Needs
  `GET /quizzes/{quizId}` (draft).
- **Quiz history list** — `GET /quizzes` is draft.
- **Quiz resume** (S2) — same draft endpoint.
- **AI explanations inside the review list** — §7 item 8.
- **Favouriting from the review** — all three favourites endpoints are draft;
  `QuizQuestion.isFavorite` stays parsed-and-unrendered.
- **A Pass/Fail verdict, a level-up or badge celebration** — no threshold in the contract (S13);
  `leveledUp` / `newBadge` have no frame.
- **The Mistakes / "My Fault" flow** — four frames, separately blocked: nothing in the contract
  exposes a per-scope wrong-question count. (Note `POST /quizzes` **is** stable with
  `mode: retakeWrong`, so a *quiz* from the wrong-answer pool is unblocked — that is its own day,
  and its own change request for the counts.)
- **The question-pool card on Quiz Setup** (S15).
- **Any payment, upgrade or price surface** — adr-049 §3, non-negotiable.
- **Anything under `contract/`**, any hand-edit of a `.g.dart` / `.freezed.dart`, any new
  dependency.

---

## 10. Provenance

| Claim | Level | How |
| --- | --- | --- |
| All §1 design values + node IDs | **SOURCE VERIFIED** (Figma) | Chrome extension, logged-in session, Properties panel, 2026-09-08 |
| RTL and Dark variants exist | **SOURCE VERIFIED** (Figma) | layer tree walked under all three top-level sections |
| §2 palette / typography reconciliation | **SOURCE VERIFIED** | grep of `lib/core/theme/` |
| §6.2 hooks not installed | **SOURCE VERIFIED** | `git config --get core.hooksPath` empty; `.git/hooks` samples only |
| §6.3 CI job shape | **SOURCE VERIFIED** | `.github/workflows/ci.yml` |
| §6.5 baseline 890 green | **BUILD VERIFIED** | `tool/validate.ps1`, this session, exit 0 |
| Ratchet is 0 not 153 | **SOURCE VERIFIED** | `test/guards/project_rules_test.dart:176` |
| Dark mode works on device | **UNVERIFIED** | memory records it dead 2026-08-04; confirm before §8 |
