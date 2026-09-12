# Day 10 Brief — the Mistakes / "My Fault" flow

> Repo `level_up_app`, branch **`merged`**. Self-contained.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq`, page **`design`**.
> Contract: **NOT the vendored copy.** Written against **upstream `2dca3c5` (`3.13.0-m1`)**.
> The vendored pin is `184d6ec` (`3.0.0-m1`) and **this flow does not exist in it.**
>
> **Every `openapi.yaml:<line>` citation in this brief is a line number in the UPSTREAM file at
> `2dca3c5`, not in `contract/openapi.yaml`.** They are labelled *(upstream)* throughout. If you
> read them against the current pin you will conclude they are wrong; they are not, the pin is
> behind. See STEP 0.
>
> **Two endpoints, both `x-stability: stable` upstream.** Coverage goes **21/29 → 23/29** at the
> new pin (it is 21/21 at the old one — the denominator moves because the re-vendor makes eight
> operations stable, not because this day consumes them).
>
> **Three build steps, preceded by a blocking gate.** Do not start Step 1 until the gate passes.

---

# Why this day exists

The `Mistakes` action on the Subjects header has been wired to a coming-soon snackbar since Day 6
(`lib/features/catalog/screens/subjects_screen.dart:89-113`). The flow has been deferred four
times, each time for the same reason — no endpoint:

- `docs/day7_quiz_brief.md:36` — *"The `Learn(My Fault)` screens … Their own day."*
- `lib/features/quiz/models/quiz_mode.dart:27-29` — `retakeWrong` needs *"a My Fault flow that is
  its own day."*
- `docs/WAVE_STATUS.md` — listed under "Deliberately not done in this wave" for both the
  2026-09-04 and 2026-09-08 waves.
- `docs/LEVEL_UP_AUDIT_2026-07-28.md:56` — *"in code this is wired to a 'Coming soon' snackbar,
  not a screen."*

**That reason has expired.** The Mistakes surface shipped upstream on **2026-09-09** at
`3.10.0-m1` (`f860408`) with both operations already `x-stability: stable` — it never spent a day
as draft.

---

# ⛔ STEP 0 — THE GATE. Day 10 cannot start until this passes.

**The vendored contract does not contain this flow.** `contract/openapi.yaml` is pinned at
`184d6ec` (`3.0.0-m1`, vendored 2026-09-04 — `contract/SOURCE.md`). `GET /me/mistakes` and
`GET /me/mistakes/subjects/{subjectId}` are absent from it entirely. Building against this brief
before the pin moves means building against a contract the repo does not have, which is exactly
what `docs/DECISIONS.md` D-008 gated the leaderboard for.

## What has to happen first

**Re-vendor `contract/` to upstream `2dca3c5` (`3.13.0-m1`).** The procedure is already documented
in `contract/SOURCE.md` and is not invented here: re-copy **all four** files
(`openapi.yaml`, `error-codes.md`, `contract-changelog.md`, `realtime.md`) from
`seifhamdii-collab/level-up-contract` and bump the pinned commit + `info.version` in
`SOURCE.md`. The three admin files stay deliberately un-vendored (adr-050).

The repo is public-readable and anonymous `git` works (memory: *contract repo access*). Clone to a
scratchpad — **never into the repo, never over `contract/`**:

```sh
git clone --depth 20 https://github.com/seifhamdii-collab/level-up-contract.git <scratchpad>/luc
```

## ⚠️ Why the target is HEAD and not `3.10.0-m1`

`3.10.0-m1` is where Mistakes shipped, and it is tempting to pin exactly there. **Owner ruling
(2026-09-12): pin to HEAD.** Two reasons:

1. **The Mistakes surface is byte-identical across that span, so nothing is lost.** Verified, not
   assumed: `git diff f860408 HEAD -- openapi.yaml` produces **zero** added or removed lines
   containing `mistake`, and the `/me/mistakes` path block hashes identically at both commits.
   Everything in this brief holds at `3.10.0-m1`, `3.13.0-m1`, and every commit between.
2. **`3.11.0-m1` completes this flow.** It made
   `{mode: retakeWrong, lessonId|lectureId, length}` legal and narrowed the retake pool to that
   leaf. The changelog names it directly: *"This is the terminal `replay` step of the Mistakes
   flow: tapping 'Cell Structure — 8 mistakes' now builds a quiz from that lesson's wrong answers
   instead of the student's whole history."* Pinning at `3.10.0-m1` would ship a tree whose leaves
   have nothing to do, and require a second re-vendor immediately.

## 🔴 The re-vendor is its own commit, with its own verification pass

**It is not part of Day 10 and must not be folded into a Day 10 commit.** `3.11.0-m1` is
**Breaking: BEHAVIOURAL** for `POST /quizzes`, and the changelog is explicit about the danger:

> *"the request and response schemas are untouched and a regenerated client is byte-identical …
> **This is the dangerous kind: your build will not tell you.**"*

`createQuiz` is re-stamped `x-behaviour-changed: 3.11.0-m1` (it was `2.3.0-m1`). Nothing in
`lib/` changes and no test fails — which is precisely why it needs a deliberate read rather than a
green suite.

## What else the re-vendor un-gates — know this before you run it

Eight operations become `stable` that were draft at our pin. Verified by parsing both files, not
copied:

| Newly stable at `2dca3c5` | Consequence |
| --- | --- |
| `getMyMistakes`, `getMyMistakesForSubject` | **this day** |
| `getLeaderboard`, `getMyRank` | **`DECISIONS.md` D-008's gate expires.** The board is finished code (13 files, 25 tests) held behind `LeaderboardPlaceholderScreen` *only* because these were draft at our pin. The re-vendor ends the holding action — that is a separate decision and a separate commit, not a side effect to absorb silently. |
| `requestAccountDeletion`, `cancelAccountDeletion` | **`seif_fight.md` S38 ("Account deletion has no endpoint") is answered.** Directly relevant here — see CONFLICT 4. |
| `getFlashcardsForLecture`, `setFlashcardSelfGrade` | Flashcards (university-track) become buildable. Out of scope. |

Operation census at each pin, recounted from source per `WAVE_STATUS.md` practice (do not copy
this number — recount it at re-vendor time):

| Pin | stable | draft | total |
| --- | --- | --- | --- |
| `184d6ec` (`3.0.0-m1`, current) | 21 | 15 | 36 |
| `2dca3c5` (`3.13.0-m1`, target) | **29** | 13 | 42 |

> Counting note: a raw `grep -c "x-stability: stable"` returns **31** and is wrong. Line 3 is
> header prose and line 1361 sits inside a `description`. Count operation blocks at indent 6.

## Gate checklist

- [ ] `contract/` re-vendored to `2dca3c5`; all four files re-copied; `SOURCE.md` pin and
      `info.version` bumped; the three admin files still absent.
- [ ] The `3.11.0-m1` behavioural change read and understood; `createQuiz`'s new legal
      combinations recorded even though nothing is built on them today.
- [ ] D-008 explicitly re-decided (restore the leaderboard route, or record why it stays gated) —
      **as its own commit**, before or after Day 10, never inside it.
- [ ] `validate.ps1` green after the re-vendor with **no Dart change** — the contract is not
      compiled, so the count must not move.
- [ ] Only then: Step 1.

---

# Assumptions this brief is built on

If any is wrong, **stop and say so** — do not build around it.

1. **Day 10 is read-only.** Overview + tree. The replay quiz is **out of scope** (owner ruling
   2026-09-12) even though its frames exist and its contract support is now stable. See "Out of
   scope".
2. **The contract is authoritative for data and semantics; the frames are authoritative for
   layout.** Where they disagree, the contract wins and the divergence is logged in
   `docs/DESIGN_ISSUES.md` (#59–#70, filed with this brief).
3. **No new packages, no new endpoints beyond the two, no `build_runner` beyond the two new model
   files' generated parts.**
4. **One screen serves both tracks at the overview level.** `404:7110` (university) is
   pixel-identical to `404:6292` (school) — verified by reading both. Only the tree level forks.
5. **The counts are live and decay.** A cached tree is a wrong tree. This drives the provider
   lifecycle decision in Step 1 and is not negotiable.

---

# Rules for this day

- **The contract wins.** Build only against `x-stability: stable`. Never invent a shape — file it
  in `docs/seif_fight.md`. Do not edit anything under `contract/`.
- **Never compute a count.** Every `mistakeCount` is rendered verbatim from the server. Do not sum
  children to check a parent, do not reconcile a count against a retake, do not derive one number
  from another. The contract sums for you and forbids the rest.
- **No colour outside `lib/core/theme/`.** `test/core/theme/palette_discipline_test.dart` fails on
  a raw colour. The mistakes rows are pink/red and will need tokens with **both** light and dark
  values; if the dark value cannot be safely inferred, document the uncertainty rather than
  inventing it (CONFLICT 5).
- **No inline `fontSize:` and no inline `fontWeight:`.** The ratchet is **0**, guard-enforced in
  two places. `.copyWith(fontWeight: …)` is not an escape hatch — if you need a weight, add a
  differently-named `AppType` style.
- **Riverpod, not Bloc.** `test/guards/` fails the suite if a Bloc appears outside
  `lib/features/quiz/`. This is not the quiz engine.
- **No provider mutation in `initState`** (BUG-001) — seed providers in the navigating caller.
- **All copy through `AppLocalizations`**, both ARB files, parity guard-enforced. Counts use ICU
  `plural` (CONFLICT 8).
- **Never log personal data**, tokens, or request/response bodies. Wrap `fromJson` failures as
  `UnknownException(detail: 'parse: ${e.runtimeType}')` — runtimeType only, exactly as
  `catalog_repository.dart:39` does (F-7-01).
- **Every screen handles loading / empty / error / offline, in AR (RTL) and EN (LTR).**
- **Reading is not running.** SOURCE → BUILD → ARTEFACT → DEVICE → CI. Never round up.

---

# The contract — what these two operations actually promise

All citations **upstream `2dca3c5` (`3.13.0-m1`)**.

## `GET /me/mistakes` — the overview

`x-stability: stable` · `operationId: getMyMistakes` · tag `quiz` (upstream `openapi.yaml:870-874`).

Returns a **bare array** — no pagination envelope, no cursor, and the changelog says neither will
ever be added: both sets are closed and bounded by the caller's own enrolment and history. Server
derives scope from the token; **there is no scope parameter in the path, query string or a
header** (`:876-879`). The only client-supplied value on this entire surface is `subjectId`.

Item shape (`:908-921`):

| Field | Type | Required |
| --- | --- | --- |
| `id` | `Uuid` | ✅ |
| `name` | `string` — content language, adr-018, **never translated client-side** | ✅ |
| `termId` | `Uuid`/`null` | ❌ **not in `required`** — see S42 |
| `termNumber` | `integer`/`null` | ❌ **not in `required`** — see S42 |
| `mistakeCount` | `integer`, **`minimum: 1`** | ✅ |

Ordered **`name` ascending, then `id`** — *"a stable order the client can render without
sorting"* (`:901-903`). Do not sort. School subjects carry `termId: null` (`:903`).

## The decay rule — the single most important fact on this surface

> *"A mistake counts only while the student's MOST RECENT graded answer to that question was
> wrong. Answer it correctly in a later quiz and it stops counting here, immediately and with no
> further action. The count is computed on every read and is never cached, so it can differ
> between two requests seconds apart."* — `:882-886` (upstream)

**Two requests seconds apart may legitimately disagree.** That is not a race, not a caching bug,
and not something to smooth over. It drives Step 1's provider lifecycle.

## 🔴 `mistakeCount` is NOT the `retakeWrong` pool — do not reconcile them

> *"The retake pool is *ever wrong* and does not decay; this count is *currently wrong* and does.
> A question you answered wrongly and later got right is **absent from every `mistakeCount` and
> still present in a retake quiz**. That divergence is intentional (adr-133) — do not reconcile
> the two numbers in the client, and do not derive one from the other."* — `:888-893` (upstream)

The changelog goes further: a student can see `mistakeCount: 0` on a lesson **and still be served
that lesson's old question** by `mode: retakeWrong`. **This is not a bug to report.** If a frame
implies the two numbers are the same, that is a CONFLICT — see CONFLICT 9.

## Empty is normal, not an error — and it takes two different shapes

| Case | Response | Rule |
| --- | --- | --- |
| Student with nothing outstanding | `GET /me/mistakes` → `200 []` | *"a NORMAL response — the record of a student who has nothing outstanding. **Clients MUST NOT render empty-as-error**"* (`:895-897`) |
| Subject with zero current mistakes | **absent from the array**, never present with `0` | which is why `mistakeCount` publishes `minimum: 1` (`:917-920`) |
| In-scope subject, no mistakes in it | `GET …/subjects/{id}` → `200`, `mistakeCount: 0`, empty `units`/`lectures` | *"a normal response, not an error and not a `403`"* (`:960-964`) |

**Both need a designed empty state. Neither frame has one** — CONFLICT 2.

## `GET /me/mistakes/subjects/{subjectId}` — the tree

`x-stability: stable` · `operationId: getMyMistakesForSubject` (upstream `:942-947`).
`200` is a `oneOf` discriminated on `track` (`:977-986`):

```yaml
oneOf:
  - $ref: '#/components/schemas/SchoolMistakesTree'       # upstream :2193
  - $ref: '#/components/schemas/UniversityMistakesTree'   # upstream :2236
discriminator: { propertyName: track, mapping: { school: …, university: … } }
```

### Pruned and summed

> *"A lesson (or lecture) appears only when its own `mistakeCount` is greater than zero; a chapter
> appears only when it has such a lesson; a unit only when it has such a chapter. Every parent's
> `mistakeCount` is the SUM of its descendants'. **So there is no dead branch the student can tap
> into and find empty**"* — `:953-957` (upstream)

Every row the server sends is worth tapping. The client needs **no** filtering, no hiding, no
empty-child guard.

`SchoolMistakesTree` (`:2193-2235`): `track` · `mistakeCount` (`minimum: 0`, *"`0` exactly when
`units` is empty"*) · `units[]` → `chapters[]` → `lessons[]`, every level
`{id, name, mistakeCount}` with `minimum: 1`.

`UniversityMistakesTree` (`:2236-2257`): `track` · `mistakeCount` · `lectures[]` of
`{id, name, mistakeCount}`.

> 🔴 **`UniversityMistakesTree` has NO `quizTypes`**, unlike `UniversitySubjectTree`: *"a mistakes
> tree is a history view, not a quiz-build tree"* (`:2239-2241`). The frame agrees — `404:7181`
> draws no tab row. **Do not reuse `QuizTypeTabs` here.**

These are deliberately **not** `SchoolSubjectTree`/`UniversitySubjectTree` and must not be modelled
as them: no `questionCounter` anywhere, and `mistakeCount` on every level including units and
chapters (which the catalog tree has no counter for at all).

## The two 403s — different meanings, and you must not collapse them

**This is the subtlest thing on the surface.** Both routes return `403` with two possible codes.

### `insufficient_scope` means something *different* on each route

| Route | Meaning | How to render |
| --- | --- | --- |
| **overview** (`:925-939`) | *"the caller … currently has **no active enrolment** to scope their history against"*. **Reachable in ordinary use** — a track transfer closes the old enrolment before the new one opens (adr-032). *"This is NOT a refusal about a subject — this operation takes no client-supplied id and refuses no id"* | *"your enrolment is between states"* — **not** an authorization failure, **not** a reason to retry, **not** a reason to log out |
| **subject** (`:990-991`) | the membership answer about the `subjectId` you supplied — identical to what `getSubjectTree` gives for the same id | "this subject isn't part of your course" |

> *"`getMyMistakes` also declares `403 insufficient_scope`, and it means something DIFFERENT from
> the subject route's `403` — **do not collapse the two branches**."* — changelog, `3.10.0-m1`

**Branch on the ROUTE, not on the code** — the code string is identical on both. This breaks the
naive reuse of `CatalogAsyncView`, which maps `insufficient_scope` to one string for everything —
CONFLICT 3.

### A trap inside the subject route's 403

*"A caller with zero mistakes anywhere still gets `403` for an out-of-scope subject — not a `200`
with an empty tree. The two are different states and both are reachable; **branch on the status,
never on emptiness**."* Further, its two causes ("no enrolment at all" / "id out of scope") are
**deliberately indistinguishable and must stay so** (`:991`) — the same property `seif_fight.md`
**S41** already records for `getSubjectTree`. Do not file it again as new.

### `account_pending_deletion` — the other 403

Reachable on **every** authenticated endpoint except an **exact four** (`GET /me`,
`POST /me/deletion-request`, `DELETE /me/deletion-request`, `POST /auth/logout`) since
`3.3.0-m1` (adr-114). *"the allowlist is an **exact four-route match and not a `/me` prefix**, and
neither Mistakes route is on it"* — so the refusal happens **before** either handler runs and
before `subjectId` is resolved at all.

> *"Client rule: on `403` `account_pending_deletion`, do **not** log the user out and do **not**
> retry — route to the cancel screen, drawn from `GET /me`'s `pendingDeletion.effectiveAt`."*
> — upstream `:82-83`

`StudentProfile.pendingDeletion` (`:2052-2059`) is *"Present ONLY while an account-deletion request
is pending … **Absent otherwise — never `null`**, so presence is the flag"*. It is **not** in
`StudentProfile.required` — model it as a nullable object and test for key presence, never for a
null value.

**Read `code` to tell the two 403s apart.** This belongs in the **global interceptor**, not in this
feature — but the cancel screen it is supposed to route to **does not exist**. CONFLICT 4.

## University counts can shrink with no explanation

*"University mistakes counts inherit the same release gate … When an admin un-releases a term for
the caller's cohort, that term's subjects leave the caller's scope and their mistakes stop being
counted — the node simply disappears under pruning, and `getMyMistakesForSubject` for that subject
starts answering `403 insufficient_scope`. **Re-releasing restores both, unchanged; nothing is
lost.**"* (adr-135, `:967-970`). There is no release state on the wire and **no way for the client
to distinguish the cause, by design** (adr-038 §3).

**School content is never release-gated** (adr-073) and school counts never move for this reason.

Do not build an explanation for this. There is nothing to explain it with.

---

# Figma frame map

Page **`design`** → three sibling top-level groups: **`Dark mode`**, **`RTL`**, **`light mode`**.
Each contains **`Common Sign in/ up Pages`**, **`University Student Flow`**, **`School Student
Flow`**. The family is named `Learn(My Fault)`.

Node URLs take **hyphens, not colons**:
`https://www.figma.com/design/P6044i0giD9TmdQ7C2AmLq?node-id=404-6292`

> ⚠️ **Frame names in this file lie, and this family is no exception.** `225:5582` is named
> "Quiz page" and draws Flash cards; every Quiz Review frame is named "quiz Result". **Every frame
> below was identified by what it draws, opened and read on 2026-09-12** — not by its name and not
> by its position.

| Node | Track | What it **actually** draws | Maps to |
| --- | --- | --- | --- |
| **`404:6292`** | School | **Mistakes overview.** Title "Mistakes", back chevron, **2-column grid of pink cards** — `Biology` / "20 questions" / chevron. In-shell nav bar, **Learn** active. | `MistakesOverviewScreen` |
| **`404:6539`** | School | **Units.** Title "Biology Units". Rows: numbered circle badge · name · **red count caption** · chevron. **No progress bar.** | units view |
| **`404:6677`** | School | **Chapters.** Title "Cell Biology Chapter". Same row shape. | chapters view |
| **`404:6762`** | School | **Lessons.** Title "Cell Structure lessons". Same row shape, one row. | lessons view |
| **`404:7110`** | University | **Mistakes overview — identical to `404:6292`.** Same grid, same cards, same copy. | **same screen**, no track branch |
| **`404:7181`** | University | **Lectures.** Title "Biology Lectures". Same row shape. **No quizType tab row** — matches the contract exactly. | lectures view |
| **`404:6853`** | School | ⚠️ **A Quiz page, NOT a mistakes list.** "Quiz", ✕ close, progress `1/1`, "QUESTION 1", 4 options, back + **Confirm**. **Has a bottom nav bar.** | the **replay** quiz — **next day** |
| **`404:7234`** | University | ⚠️ **A Quiz page**, identical to `404:6853`. | the replay quiz — **next day** |
| `337:5702` | School | Subjects (built) — its header's `Mistakes` action is the entry point | `subjects_screen.dart:89` |
| `404:7413` | — | The companion header component | **already built** as `CatalogScaffold` / `CatalogHeader` |

## The two uncertain frames — resolved

`docs/day7_quiz_brief.md:95` assigned `404:6853` / `404:7234` to this flow on **positional
evidence only** (*"Sit a row below the quiz row (y 1452 / 1331), adjacent to the `Learn(My Fault)`
frames"*). Opening them settles it:

**Day 7 was half right.** They *do* belong to the My Fault flow — they are its terminal replay
quiz, which `3.11.0-m1` later made legal and named explicitly. They are **not** mistakes-list
screens, **not** duplicates and **not** leftovers. Recorded here so they are not re-litigated as
either. They are **out of scope for Day 10** and are the next day's target.

## Two structural findings from the frames

1. **Every frame draws the bottom nav bar with `Learn` active.** These screens live **inside** the
   `StatefulShell`, unlike the quiz screens (`app_router.dart` puts `/quiz/*` at top level). This
   decides the routing in Step 2. *(The replay frames draw it too, which contradicts where the
   built quiz screens live — CONFLICT 10, next day's problem.)*
2. **The overview is track-agnostic.** One screen, no branch. Only the tree forks, and it forks on
   the parsed discriminator exactly as `subject_tree_screen.dart` already does.

## Design tokens — read off the Properties panel, 2026-09-12 (signed in)

**Verification level: SOURCE**, read from Figma's Properties panel on a signed-in view seat. These
are measured values, not inferred ones.

### Frames

| Node | Group | Size | Radius | Canvas fill |
| --- | --- | --- | --- | --- |
| `404:6292` / `404:6539` / `404:6762` | light | **402×860** | 30 | `#FCFBF9` |
| `404:7428` | **dark** | **402×841** | 30 | `#232428` |

Dark frames are **19px shorter** than light ones. `#232428` is already the app's dark canvas token.

### The overview card — `404:6322` ("Container")

| Property | Value |
| --- | --- |
| Size | **173×89** |
| Radius | **10.7px** |
| Border | 0.63px |
| Fill | **`#EAD5D5`** |
| Shadow 1 | X 0.53 · Y 0 · blur 1.06 · spread −0.53 · `#000000` @ **25%** |
| Shadow 2 | X 0 · Y 0.53 · blur 1.59 · spread 0 · `#000000` @ **25%** |

🟢 **`89` and `10.7` are already in the codebase**: `subjects_screen.dart:197` draws
`CatalogBlock(height: 89)` and `CatalogBlock`'s default radius is `10.7`
(`catalog_states.dart:129-135`). The mistakes card is the catalog `SubjectCard`'s geometry with a
different fill — which is the strongest possible argument for extending the existing widgets
rather than writing new ones.

### The tree row — `404:6642` (named "Button")

| Property | Value | Already in `TreeListRow`? |
| --- | --- | --- |
| Size | 363×78, Top 124.44, Left 20 | — |
| Radius | **16px** | ✅ `BorderRadius.circular(16)` (`tree_list_row.dart:55`) |
| Border | **0.5px, inner, `#4B675E`** | ✅ width 0.5 (`:61`) — confirm `fieldBorder` == `#4B675E` |
| Fill | **`#EAD5D5`** | ❌ currently `ext.catalogCardFill` |

**The row's geometry already matches the shipped widget exactly.** Only the fill and the caption
treatment differ — confirming build option **(a)** (add a count slot + fill override) over a new
widget.

### Typography — 🔴 and here the frames stop agreeing with each other

| Element | Node | Font | Weight | Size | Line height | Colour |
| --- | --- | --- | --- | --- | --- | --- |
| Card title "Biology" | `404:6329` | **Inter** | 700 Bold | 16 | 14.85 | `#384F47` |
| Card caption "20 questions" | `404:6338` | **Cairo** | 600 SemiBold | 14 | **10.62** | `#EF4444` |
| Row name "Cell Biology" | `404:6648` | **Inter** | **600** Semi Bold | 16 | 21 | **`#000000`** |
| Row caption "5 questions" | — | **Cairo** | 600 SemiBold | 14 | **10.62** | `#EF4444` |
| Row index badge "1" | — | **Cairo** | 700 Bold | 16 | 24 (cap-height trim) | not captured |

Four separate problems live in that table — CONFLICTS 11, 12 and 13.

---

## Dark mode and RTL — ✅ RESOLVED: the variants EXIST

🔴 **This corrects an earlier finding in this same brief.** A first pass (anonymous, cramped
viewport) enumerated `Dark mode → School Student Flow`, found only the four *catalog* `Learn(...)`
frames, and concluded there were **no dark-mode Mistakes frames**. **That was wrong**, and
DESIGN_ISSUES #63 was filed on it before it was disproven.

**The root cause is worth knowing, because it will bite again:** the layer name contains a stray
Arabic **kasratan** — the real string is `Learn(ٍMy Fault) for school student`, not
`Learn(My Fault)`. Any search for the clean spelling silently returns nothing. The same typo
appears in `Learn(ٍSubject)`. **Search for `My Fault`, never `Learn(My Fault)`.**

**What the signed-in session actually found.** Figma's layer search (`ctrl+F`, scope *This page*)
returns **19 results**: **18 frames** named `Learn(ٍMy Fault) for school student` plus one layer
literally named `My Fault`. 18 = **6 per group × 3 groups**, matching the 6 light-mode frames
exactly — so `Dark mode` and `RTL` each carry a complete family.

Confirmed by direct selection: **`404:7428` is a dark Mistakes overview** — 402×841, radius 30,
canvas `#232428`, with the same pink cards and red counts drawn on the dark ground. Two further
dark family members were selected in passing: **`404:7894`** and **`404:7990`**.

⚠️ **What is still open:** the individual node-ID → screen mapping for the dark and RTL
families, beyond the three IDs above. Figma's URL only syncs `node-id` lazily after a selection
settles, so enumerating 12 IDs from the search panel costs one round trip each and the session
stopped after establishing the finding that actually mattered. **This is ~12 minutes of clicking,
not a research problem.**

**How to finish it in one sitting:** `ctrl+F` → type `My Fault` → scope *This page* → click each of
the 19 rows in turn, reading the `node-id` out of the address bar after each selection settles
(`shift+2` forces the sync). Record group membership from the canvas: light = `#FCFBF9` ground,
dark = `#232428` ground, RTL = mirrored/Arabic.

**Do not block the build on this.** The dark values that matter are now measured (the table above,
plus `#232428`), and the build is mirrored for RTL regardless.

---

# ⚠️ CONFLICTS

Filed in `docs/DESIGN_ISSUES.md` as **#59–#70** and `docs/seif_fight.md` as **S42–S44**.

### 1. 🔴 Every frame captions the count "N questions" — the contract's field is `mistakeCount`

**Where:** all six list frames. Overview cards read `20 questions`; rows read `5 questions`,
`15 questions`, `3 questions`, `1 questions`.

**What:** "20 questions" reads to a student as *how many questions this subject has*. The number
is the opposite — how many they currently have **wrong**. On a subject with 400 questions and 20
mistakes, the frame's copy is not merely vague, it is false. This is the single number the entire
flow exists to show.

**Build:** copy says mistakes, not questions. **Do not** transcribe the frame's string.
`DESIGN_ISSUES` #59. Needs the designer to confirm the Arabic wording too — the existing key
`mistakes` is `أخطائي` ("my mistakes"), which is right for the button but not for a count caption.

### 2. 🟠 No empty state exists anywhere in the family, and the contract makes empty NORMAL

**Where:** all six list frames.

**What:** the contract has **two distinct** empty states (`200 []` on the overview; `200` +
`mistakeCount: 0` + empty array on the tree) and explicitly forbids rendering either as an error.
The frames draw neither, and the overview's empty state is the **happy path** — a student with no
outstanding mistakes is a student doing well, and this is the one screen that should say so
warmly rather than showing a grey "nothing here" box.

**Build:** `CatalogMessage` defaults render *something* correct, so this does not block. But the
designed empty state is **design input and must not be invented** — the tone of "you have no
mistakes" is a product decision. `DESIGN_ISSUES` #60. **STOP AND ASK if you find yourself writing
celebratory copy.**

### 3. 🟠 `CatalogAsyncView` collapses the overview's `insufficient_scope` onto the wrong copy

**Where:** `lib/features/catalog/widgets/catalog_states.dart:51-64`, `:74-80`.

**What:** it maps `insufficient_scope` → `l10n.subjectUnavailable` ("isn't part of your course")
and suppresses the retry button. Correct for the **subject** route. **Wrong for the overview**,
where the same code means "you have no active enrolment right now" — a transient track-transfer
state (adr-032) that is not about any subject and that a student *should* be able to retry.

**Build:** reuse `CatalogAsyncView`, but pass the error mapping in rather than letting it decide.
New ARB key for the enrolment-between-states case. `DESIGN_ISSUES` #61. Related to but distinct
from **S41** — do not merge them.

### 4. 🟠 `account_pending_deletion` has a mandated destination that does not exist

**What:** the contract says route to the cancel screen, do not log out, do not retry. There is no
cancel screen, no route, and no `DELETE /me/deletion-request` call anywhere in `lib/`.
`seif_fight.md` **S38** filed this as "Account deletion has no endpoint" on 2026-09-04 — **that is
now out of date**: both `requestAccountDeletion` and `cancelAccountDeletion` are `x-stability:
stable` at the target pin.

**Who owns it:** **not this feature.** The handling belongs in the global error interceptor
(one place, every endpoint — the contract's own framing), and the screen belongs to the account
surface. Day 10 must **not** build either.

**What Day 10 does:** ensure the Mistakes screens do not swallow the code or treat it as a generic
error, and leave a `TODO(contract)` marker pointing at S38. **Update S38** to record that the
endpoints landed. `DESIGN_ISSUES` #62.

### 5. ✅ WITHDRAWN — the dark-mode frames exist after all

**This conflict was filed and then disproven inside the same day.** See "Dark mode and RTL" above:
`Dark mode` carries a complete 6-frame Mistakes family, and `404:7428` is its overview — 402×841,
canvas `#232428`. The original finding rested on a layer-name search that could not match, because
the real name carries a stray Arabic kasratan.

`DESIGN_ISSUES` **#63 is corrected in place, not deleted** — the record of a wrong call is worth
more than a tidy register.

**What survives, and it is the useful half:** the dark **values** still have to be read off
`404:7428` and its siblings before any token is added to `AppColors`. The hazard is unchanged —
`DESIGN_ISSUES` #53/#54 shipped a measured **1.11:1** cream-on-mint on the review screen. Read the
dark frames; do not infer from the light ones.

### 6. 🟡 RTL variants exist; their node IDs are not yet mapped

The 19-result count proves a full 6-frame RTL family (see above). What is missing is only the
ID → screen mapping, which is clicking, not research. `DESIGN_ISSUES` #64.

The build is mirrored regardless — `EdgeInsetsDirectional`, `forwardChevron(context)`, no
hardcoded `TextDirection` — because that is how every other list in this app already works, and
reproducing a half-done RTL frame would ship a bug (precedent: #58, where the RTL review frame
turned out to be half-mirrored and the build was right to ignore it).

### 7. 🟡 The frames' placeholder counts do not reconcile across levels

Unit "Cell Biology" shows **5**; its chapters show **3** and **1** (= 4). The overview shows
**20** for both subjects while the units sum to 20 correctly.

**This is placeholder data, not a specification.** The contract guarantees parents are the exact
sum of descendants. **Do not "fix" the client to reproduce the frame's arithmetic**, and do not
file the discrepancy as a server bug. `DESIGN_ISSUES` #65.

### 8. 🟡 "1 questions" — the frames do not pluralise

ARB entries must use ICU `plural` in both languages. Arabic has **six** plural categories
(`zero`/`one`/`two`/`few`/`many`/`other`) and this is exactly the case where a naive
`"$n مسألة"` is wrong. `DESIGN_ISSUES` #66.

### 9. 🟡 Nothing in the frames implies `mistakeCount` equals the retake pool — confirmed by reading

The brief was asked to treat an implied equivalence as a CONFLICT. **It does not arise:** no frame
in this family draws a retake affordance, a pool size, or any second number to compare against.
The divergence becomes visible only at the replay step, where a leaf badged "8 mistakes" starts a
quiz of 10/30/50 questions drawn from the *ever wrong* pool. Filed forward as **S43**, not as a
Day 10 conflict.

### 10. 🟠 The replay frames draw a nav bar; the built quiz screens live outside the shell

`404:6853` / `404:7234` both draw the bottom nav bar with `Learn` active, but `/quiz/*` routes sit
at top level in `app_router.dart`, deliberately (the Day 9 brief: *"nav bar drawn, but IGNORE"*).
Either the replay quiz is a different, in-shell surface, or the frames inherit a template. **Next
day's problem**, recorded now so it is not discovered late. `DESIGN_ISSUES` #67.

### 11. 🔴 The family mixes two font families, and the design system is Inter-only

Measured: card title **Inter** 700/16, card caption **Cairo** 600/14, row name **Inter** 600/16,
row badge **Cairo** 700/16. Wave 3D's designer handoff (`typography-style-inter.md`, 2026-08-21)
supplied **18 Inter styles** and `lib/core/theme/app_typography.dart` transcribes it verbatim as
`AppType`. **Cairo is not in the scale and appears nowhere else in the app.**

It may be deliberate (Cairo renders Arabic-Indic digits well) or it may be drift. **We will not
guess** — adding a second font family to the design system is exactly the Wave 3D trap: a
reasonable-looking inference that everyone downstream inherits as fact. `DESIGN_ISSUES` #68.

### 12. 🔴 None of the five type styles exists in `AppType`, and the ratchet is 0

Inter 700/16, Inter 600/16, Cairo 600/14, Cairo 700/16 — no inline `fontSize:` or `fontWeight:` may
be written (guard-enforced in two places), so each must map to a named `AppType` entry or the scale
must gain one. This is the same situation `DESIGN_ISSUES` **#57** resolved for the review screen by
owner ruling (map to nearest existing, do not extend the scale). **Ask for the same ruling here —
do not re-derive it.** `DESIGN_ISSUES` #68.

Two further measurement problems in the same table:

- 🔴 **Line height 10.62px on a 14px font** — smaller than the glyph box, which clips descenders.
  Almost certainly a Figma artefact rather than intent, but it must not be transcribed.
- 🟠 **The row name is `#000000` while the card title is `#384F47`** — two different "primary
  text" colours inside one family, and **pure black is not in the palette at all**. `#384F47` *is*
  a shipped token (`quizReviewRowContent`, added Day 9). Use the token; do not add black.

### 13. 🟠 The overview card carries two pure-black drop shadows

`404:6322`: `#000000` at 25%, twice (X 0.53/Y 0/blur 1.06/spread −0.53 and X 0/Y 0.53/blur
1.59/spread 0). `DESIGN_ISSUES` **#47** already records *"Five drop shadows are pure black, which
does not exist on the dark canvas"* — these are instances six and seven, and the dark frame
`404:7428` needs its own shadow values read rather than reusing these. `DESIGN_ISSUES` #69.

---

# STEP 1 — models, repository, notifiers. No UI.

**Feature folder: `lib/features/mistakes/`** — its own feature, **reusing the catalog's widgets**.

Per `AGENT_WORKFLOW.md` §"Component reuse", a new folder needs a reason. Three:

1. **Different models.** Pruned + summed, `mistakeCount` at every level, no `questionCounter`
   anywhere. `SchoolMistakesTree` is deliberately not `SchoolSubjectTree` and the contract says so
   in prose (`:2196-2198`).
2. **Different endpoints.** Neither lives under `/catalog`.
3. **🔴 A different caching rule, and this is the decisive one.** `subjectTreeProvider` is
   deliberately **not** `autoDispose` and stays warm for the session
   (`subject_tree_notifier.dart:13-16`) — correct, because a catalog tree does not change. Mistake
   counts **decay on every read**. A warm cache would show a student "8 mistakes" on a lesson they
   just cleared. Putting a decaying resource behind the catalog's deliberately-warm provider would
   be a real bug.

## Files

```
lib/features/mistakes/
  models/mistakes_subject.dart        # overview item (+ .freezed.dart, .g.dart)
  models/mistakes_tree.dart           # sealed SchoolMistakesTree | UniversityMistakesTree
  repository/mistakes_repository.dart
  notifier/mistakes_overview_notifier.dart
  notifier/mistakes_tree_notifier.dart
```

## Modelling notes

- **Seal the tree**, mirroring `subject_tree.dart:26-29`: a `sealed class MistakesTree` with
  `Track get track`, so every branch is a compiler-checked `switch` and a third track cannot appear
  without this app failing to build.
- **Dispatch on the key before parsing**, exactly as `catalog_repository.dart:64-70` does —
  feeding a university payload to the school model surfaces as a raw `TypeError` out of generated
  code otherwise. A fourth value is contract drift: throw `UnknownException`, do not render empty.
- **`termId`/`termNumber` are not in `required`.** Model them nullable **and** tolerate absence.
  See **S42** — do not assume which.
- **No `QuestionCounter`, no `quizTypes`.** If you are importing either into this feature, you have
  the wrong model.

## Notifiers

```dart
// Both take `retry:` returning null — NOT optional.
// Riverpod 3 auto-retries a failed build and holds the state in AsyncLoading rather than
// AsyncError, so the screen sits on its skeleton forever and hammers a dead network.
// Reuse `noCatalogRetry` (subjects_notifier.dart:88) or define the local twin.
final mistakesOverviewProvider = AsyncNotifierProvider<…>(…, retry: noCatalogRetry);

// 🔴 autoDispose + family — the decay rule. Contrast subjectTreeProvider, which is
// deliberately NOT autoDispose.
final mistakesTreeProvider =
    AsyncNotifierProvider.autoDispose.family<…, MistakesTree, String>(…, retry: noCatalogRetry);
```

⚠️ **`autoDispose` + `await` is the W3-1 hazard.** `ref` is dead after disposal —
`riverpod-3.3.2/lib/src/core/ref.dart:232-240` throws `UnmountedRefException` — so capture every
dependency **before** the first `await`. This is a known-open finding (`WAVE_STATUS.md` W3-1); do
not add a new instance of it.

**Also invalidate the overview when returning from a quiz**, since finishing one changes counts.
Where that invalidation is triggered is a **real design question** — do it in the caller that
navigates back, never in `initState` (BUG-001).

## Tests

Repository decode tests for both tracks · `[]` decodes to an empty list, not an error ·
`mistakeCount: 0` + empty `units` decodes as valid · unknown `track` throws `UnknownException` ·
a 403 with each code surfaces as a typed `ApiException` carrying that code · parse failure becomes
`UnknownException(detail: 'parse: …')` with **no body content**.

---

# STEP 2 — the overview screen, and the entry point goes live

## The screen

`MistakesOverviewScreen` · `404:6292` / `404:7110` · **one screen, both tracks**.

Reuse `CatalogScaffold(title: l10n.mistakesTitle)` — it *is* `404:7413`, and its `CatalogHeader`
already renders the back chevron only when the branch can pop, mirrors it for RTL, and ellipsises a
long title. Body is a 2-column grid, same delegate as `_SubjectsGrid`
(`subjects_screen.dart:162-180`), with a **new** pink count card — `SubjectCard` does not draw one.
**No trailing header action** (we are already in Mistakes).

Four states through `CatalogAsyncView`, with the error mapping passed in (CONFLICT 3):
loading → `CatalogBlock` grid skeleton · empty → `[]` is normal (CONFLICT 2) · error → generic +
retry; `insufficient_scope` → the **enrolment-between-states** copy · offline → `OfflineBanner` +
`CatalogMessage`, chosen by exception type.

## The entry point

**`lib/features/catalog/screens/subjects_screen.dart:89-113`** — `_MistakesButton`. The snackbar is
at **`:99-101`**:

```dart
onPressed: () {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));   // ← :101, delete
},
```

Replace with `context.push('/learn/mistakes')`. Keep the button's styling
(`cs.error` foreground, 0.5 error border, radius 9, `AppType.buttonSmall`) — it already matches.

`push`, not `go`: the overview is a push onto the Learn branch, so `CatalogHeader.canPop()` is
`true` and the back chevron appears, as the frame draws it.

## Routing — inside the shell

Every frame draws the nav bar, so these nest under the existing `/learn` branch
(`app_router.dart:172-208`), **not** at top level beside `/quiz`:

```
/learn/mistakes
/learn/mistakes/subject/:subjectId
/learn/mistakes/subject/:subjectId/unit/:unitId
/learn/mistakes/subject/:subjectId/unit/:unitId/chapter/:chapterId
```

⚠️ **Every routing test asserts on `GoRouter.state.uri`, never `currentConfiguration.uri`** — the
latter silently misses imperative pushes, which is exactly what this flow uses. Tests must be
**router-driven**, not direct-pump (BUG-001 blind spot).

---

# STEP 3 — the tree screens

`MistakesSubjectScreen` at `/learn/mistakes/subject/:subjectId` loads the tree once and switches on
the parsed discriminator — school continues into the nested routes, university stops here with a
flat lecture list. This mirrors `subject_tree_screen.dart` exactly; read it first.

The three school levels are **views over the one cached tree**, as `UnitsView` / `ChaptersScreen` /
`LessonsScreen` are (`units_screen.dart:13-14`: *"No fetch happens here"*). **One fetch per subject,
four screens.**

## The row

`TreeListRow` **cannot be reused as-is.** It renders `caption` **only inside
`if (progress != null)`** (`tree_list_row.dart:81-108`), and these rows have a red count and **no
bar**. Two options — pick in the plan, do not drift into one:

- **(a)** add an optional `countLabel` slot to `TreeListRow`, rendered when `progress == null`;
- **(b)** a sibling `MistakeListRow` in `lib/features/mistakes/widgets/`.

**(a) is preferred** — the badge, name, chevron, RTL mirroring, 2-line ellipsis and locale-aware
digits (`MaterialLocalizations.formatDecimal`, so Arabic renders ١، ٢، ٣) are all already right and
should not be copied. Whichever you choose, the index badge stays presentational — *"a list
ordinal, not a server value"*.

Titles follow the frames: "Biology Units", "Cell Biology Chapter", "Cell Structure lessons",
"Biology Lectures" — i.e. the **parent's** name, from the already-loaded tree, exactly as
`lessons_screen.dart:41-47` does. On a cold deep link the name is unknown; fall back to a bare
title (`cachedSubjectName` returns null and *"inventing a name would be worse than showing none"*).

**Leaves are inert in Day 10.** Tapping a lesson or lecture does nothing — the replay is out of
scope. Do **not** ship a leaf that looks tappable and swallows the tap; that is the exact defect
`_MistakesButton`'s own comment warns about (*"a button that swallows taps reads as a bug to the
student"*). Either render leaves visually non-interactive, or **STOP AND ASK** — this is product
intent, not an engineering call.

---

# Definition of done

- [ ] **STEP 0 gate passed** — `contract/` at `2dca3c5`, `SOURCE.md` bumped, D-008 re-decided in
      its own commit.
- [ ] Both endpoints consumed through the real seam. Coverage **21/29 → 23/29 stable**, recounted
      from the new pin, not copied from this brief.
- [ ] Overview + tree render for **both tracks**; the overview is one screen with no track branch.
- [ ] **Four states on every screen**, and the two empty cases distinguished: `[]` on the overview,
      `mistakeCount: 0` + empty array on the tree. Neither rendered as an error.
- [ ] The **two `insufficient_scope` meanings** render differently. A test asserts the overview's
      403 does **not** show `subjectUnavailable`.
- [ ] `account_pending_deletion` is not swallowed; `TODO(contract)` → S38.
- [ ] **No client arithmetic anywhere.** A test asserts a parent's rendered count is the server's
      value, not a sum of the children.
- [ ] Entry point live; `comingSoon` no longer reachable from the Subjects header; a test asserts
      the snackbar is gone.
- [ ] Routing tests assert on **`GoRouter.state.uri`**, router-driven.
- [ ] Ratchets unmoved: hardcoded `fontSize` **0**, inline `fontWeight` **0**,
      `Text('literal')` **4**. New colours in `AppColors` with **both** values and a **measured**
      dark contrast figure recorded.
- [ ] ARB parity, both files, ICU `plural` on every count.
- [ ] `flutter analyze` clean; full suite green; `test/guards/` green; **predict the test count
      before running** and reconcile any difference explicitly.
- [ ] RTL pass: no `EdgeInsets.only(left:/right:)`, no `Alignment.centerLeft`, no hardcoded
      `TextDirection`; chevrons mirror; verified **in Arabic**.
- [ ] Dark mode: state the verification level honestly. It is **BUILD** (widget test) unless a
      device was actually used — and memory records dark mode as **dead on device 2026-08-04**,
      never re-confirmed.
- [ ] Edge cases **not** handled, listed with reasons.
- [ ] Commits: one per step, re-vendor separate, Conventional Commits, reasoning in the body.

---

# Out of scope — do not build

- 🔴 **The replay quiz** (`404:6853` / `404:7234`) — owner ruling 2026-09-12. Contract support is
  now stable and `createQuiz` is **already 90% wired** (`quiz_repository.dart:46-58` takes `mode`
  and already emits `lessonId`/`lectureId`; `quiz_mode.dart:34` gates it behind the one-line
  `offeredQuizModes`). **That is exactly why it is a separate day** — it is cheap enough to sleep-
  walk into, and it drags in the `3.11.0-m1` behavioural change, the three-outcome branch
  (`201`-with-`[]` vs `403` vs `400`), and an S43 answer. **Next day's work.**
- **Anything that reconciles `mistakeCount` with the retake pool.** Forbidden by adr-133.
- **The account-deletion cancel screen** — belongs to the account surface + global interceptor.
- **The leaderboard un-gating** — its own decision, its own commit (D-008).
- **Flashcards** (`getFlashcardsForLecture`, `setFlashcardSelfGrade`) — newly stable, not this day.
- **Favourites** — still `draft` at the target pin (`addFavorite` is `x-stability: draft`,
  upstream `:1400`). `isFavorite` stays parsed-and-unrendered.
- **Quiz history / resume** — `GET /quizzes`, `GET /quizzes/{quizId}` still draft (S14, S2).
- **Any pagination or search** on this surface — the contract says neither exists nor will.
- **Anything under `contract/`** beyond the STEP 0 re-vendor; any hand-edit of a `.g.dart` or
  `.freezed.dart`; any new dependency.

---

# Skills to load before starting

From `.claude/skills/`, in this order:

`level-up-domain` → `seif-api-contract` → `river` → `build-screen` → `figma-frame` →
`screen-states`

At test time: `flutter-add-widget-test`, `dart-add-unit-test`, `dart-run-static-analysis`.

**Do NOT load `bloc`.** Mistakes is not the quiz engine, and `test/guards/` fails the suite if a
Bloc appears outside `lib/features/quiz/`.

**Also do not load:** `dart-generate-test-mocks` (mockito — this repo uses **mocktail** `^1.0.5`),
`dart-migrate-to-checks-package`, `flutter-setup-declarative-routing`, `flutter-setup-localization`,
`flutter-apply-architecture-best-practices`, `flutter-add-widget-preview`,
`flutter-add-integration-test`.

**Stale claims inside those skills — this brief overrides them.** All were recorded in the Day 9
brief and remain true:

1. `level-up-domain` / `seif-api-contract` say the API is snake_case and to bridge with
   `@JsonKey(name:)`. **Wrong — adr-026 fixed camelCase on the wire.** Zero name bridges exist and
   none may be added.
2. `build-screen` Step 4 and `screen-states` Step 4 reference `04_Screens/`,
   `00_Project/Decisions_Log.md` and `01_Flutter_Specs/`. Those live in the **vault** at
   `F:\level\level_up\level_up\`, not in this repo — and `04_Screens/` contains only a template.
3. `figma-frame` routes through the Figma MCP. **That connector is Seif's account and view-only —
   every `get_design_context` / `download_assets` call fails.** Use the Claude-in-Chrome extension
   against the signed-in owning account instead.

---

# Stop and ask — do not resolve these yourself

1. **The empty-state tone** on the overview (CONFLICT 2) — product intent.
2. **Any dark colour value** this family's frames do not specify (CONFLICT 5) — visual
   interpretation not in Figma, and the review screen already paid for this mistake twice.
3. **Whether a Day 10 leaf is visibly inert or simply non-interactive** (Step 3) — product intent.
4. **`termId`/`termNumber` requiredness** (S42) — contract ambiguity; never guess a shape.
5. **Whether the re-vendor's D-008 consequence** (leaderboard un-gating) happens before, after, or
   independently of Day 10 — project sequencing, owner's call.
