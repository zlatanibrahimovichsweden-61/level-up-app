# Day 6 Brief — University parity: Home + Learn stack

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Prereq: Day 5 (school Learn) committed and `dev` clean.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq`.
> **This is a parity round — REUSE the school widgets/providers; diverge only where the contract does.**

## What Day 6 builds
1. **University Home** — Figma `125:2373` (mirrors school Home `337:5303`). Almost certainly the
   *existing* `HomeScreen` already renders it (it reads `GET /me`, which is track-agnostic).
2. **University Learn stack** — the tree diverges from school: instead of Units→Chapters→Lessons,
   university is **Subjects → Lectures** (one level). New screen: **Lectures** (Figma `180:5208`),
   with a **quiz-type selector**. Subjects screen (`308:4521`) is REUSED from Day 5.

## Explicitly OUT (do NOT build)
Quiz setup + quiz taking (still the Day-7 placeholder). University Leaderboard, My Fault/Mistakes,
Friends, Messages, Notifications, Customer Support, Edit Profile, Settings, "your progress",
Refer-a-Friend (all exist as university frames but are later / draft / no endpoint). Flashcards
(no endpoint — see gap below). `POST /quizzes`.

## Carried over from the Day-5 implementation (apply verbatim — the screens are twins)
These were learned the hard way building school Learn; do NOT rediscover them:
- **Row anatomy is settled — reuse `tree_list_row` exactly.** Leading 40dp numbered circle with
  **locale-aware digits** (١،٢ in AR), name Inter **SemiBold** 16 `ext.textPrimary`, progress bar
  `ext.progressTrack` + `cs.primary`, **28dp RTL-mirrored** chevron. The Lecture frame `180:5208`
  uses exactly this numbered row (1–4 + name + bar + %). Do not re-derive it.
- **No new tokens expected.** Reuse `ext.catalogCardFill` (opaque `#27282C`) and `ext.catalogTrack`.
  Day 4's `cardFill` is a 20% wash that composites to invisible on these cards — do NOT use it.
- **Title needs the subject name, which is NOT in the tree payload.** School's Units title pulls the
  subject name from the cached **subjects list**, with a **bare-title fallback on a cold deep link**.
  The Lectures header `"{subject} Lectures"` has the identical dependency — source it the same way.
- **Reuse the test infra:** extend `test/features/catalog/catalog_fixtures.dart` and
  `catalog_harness.dart` (add university fixtures) — do not build parallel scaffolding.
- **RTL audit:** the only `TextDirection` references should remain the two chevron-mirroring helpers.
- **`_noRetry` is now a project rule** (Riverpod-3 auto-retry defeats error/offline states) — every
  async provider, new or touched, keeps it.

## Skills
`level-up-domain` · `build-screen` · `seif-api-contract` · `figma-frame` · `river` · `screen-states`
(+ declarative-routing skill, + widget-test skill).

Figma frames to pull (file `P6044i0giD9TmdQ7C2AmLq`) and DIFF against their school counterparts:
- University Home **`125:2373`** vs school Home `337:5303`.
- University Learn(Subject) **`308:4521`** vs school Subjects `337:5702`.
- University Learn(Lecture) **`180:5208`** — the one genuinely new screen (structure below).

---

## Endpoints (all STABLE; all already reachable in code)

### `GET /me` → `StudentProfile` (track: "university")
The `university` block is populated (school block null): `university.{ university: NamedRef,
faculty: NamedRef, yearNumber: int }`. The Day-4 `StudentProfile` model **already** models this
block — no model change expected. Home consumes `name`, `avatar`, `points`, `level`, `badges` —
all track-agnostic. `GET /me/entitlements` as before.

### `GET /catalog/subjects` → subjects (UNCHANGED)
Same endpoint, same shape `[{id, name, questionCounter}]`; the server scopes by the caller's
university/faculty/year (adr-013). The **existing SubjectsScreen is reused as-is.**

### `GET /catalog/subjects/{subjectId}/tree` → `UniversitySubjectTree`  ← the divergence
```
{ track: "university",
  quizTypes: [ "normal" | "midTermRevision" | "finalRevision" | "practicalRevision" ],
  lectures:  [ { id, name, questionCounter: { answered, total } } ] }
```
The endpoint is a `oneOf` discriminated on `track` (school = units/chapters/lessons, university =
this). **Day 5 currently REFUSES the university branch** (the repository throws a typed error with
`TODO(university)`). Day 6 must parse BOTH branches.

**Note vs school:** university `lectures[]` DO carry `questionCounter` — so unlike school units/chapters
(DESIGN_ISSUES #16), the per-lecture progress bar HAS a real data source. Same rule: **display-only**,
answered/total, never gates.

---

## Screen: University Lectures — `180:5208`

Verified structure (top→bottom):
1. **Header** (`180:5295`): back chevron + title **"{subject} Lectures"** (e.g. "Biology Lectures").
   Share icon present but hidden. **Source the subject name from the cached subjects list (it is NOT
   in the tree payload), with a bare-title fallback on a cold deep link** — same as school's Units title.
2. **Search field** (`180:5232`) — placeholder reads **"Search Chapters"** (copy-paste bug; it's a
   lecture list). **Do NOT build search here** (same call as school drill-down, DESIGN_ISSUES #17) —
   flag the field + wrong placeholder for the designer.
3. **Quiz-type tab row** (`180:5337`): tabs **Normal · Flashcard · Midterm · Final · Practice**.
   - Build the tabs from `tree.quizTypes` (localized labels), NOT hardcoded. Map: Normal→`normal`,
     Midterm→`midTermRevision`, Final→`finalRevision`, Practice→`practicalRevision`. Default `normal`.
   - **GAP (file as DESIGN_ISSUES #18, 🟠):** the design draws a **"Flashcard"** tab, but the
     contract's `quizTypes` enum has **no flashcard** (flashcards are a separate `flashcardSubscription`
     entitlement with **no content endpoint** in M1). So Flashcard is not tree-driven. **Build only the
     tabs present in `tree.quizTypes`; omit Flashcard** (or render it disabled with a `TODO(contract)`).
     Ask Seif/designer: is Flashcard in M1, and if so via which endpoint?
   - The selected quiz type is carried into the lesson→quiz handoff; it does NOT re-fetch the tree.
4. **Lecture rows** (`309:5713`): each row = a leading **numbered circle** (1,2,3…), the lecture
   `name`, a **progress bar + "%"** from `questionCounter` (display-only, clamped), and a trailing
   icon. Reuse the Day-5 `tree_list_row` numbered-row anatomy.
   - **Label format:** the frame shows a rounded "80%"; Day 5 chose "{answered} / {total} questions"
     for consistency. Pick ONE and be consistent with school; flag for the designer (relates to the
     open school label question). No extra math either way.
   - Tap a lecture → **`/quiz/setup` placeholder** (Day 7), passing `lectureId`, the lecture name,
     AND the selected `quizType`. (Contrast school, which passes `lessonId`.)
5. **nav bar** (`180:5303`) — shared shell bar, Learn active.

States (screen-states): loading / error / offline / empty on the tree, AR-RTL + EN, light + dark.

---

## Routing — branch on the tree discriminator
Keep the single subject route `/learn/subject/:subjectId`. Its screen loads
`subjectTreeProvider(subjectId)` and **switches on the sealed tree type**:
- `SchoolSubjectTree` → the existing Units view (→ unit/chapter/lesson nested routes, unchanged).
- `UniversitySubjectTree` → the new **Lectures** view (flat; lecture tap → `/quiz/setup`).

Make `SubjectTree` a **sealed/freezed union** discriminated on `track` so the switch is exhaustive.
No new top-level routes; the university path is intentionally shorter (no unit/chapter nesting).

## University Home
Pull `125:2373`, diff against school Home. Expectation: **reuse `HomeScreen` unchanged.** If the
frame is identical (same header + level card + stubbed sections), do NOT fork it — one screen serves
both tracks. Only add a branch if a real visual difference exists; if so, keep it minimal and flag.

## Files
```
lib/features/catalog/
  models/      subject_tree.dart  → refactor to a sealed SubjectTree union:
                                     SchoolSubjectTree (existing) + UniversitySubjectTree (new: quizTypes, lectures)
  repository/  catalog_repository.dart → parse BOTH branches (remove the university refusal / TODO)
  screens/     lectures_screen.dart (new)         ; subject_tree_screen branches school vs university
  widgets/     quiz_type_tabs.dart (new)          ; reuse tree_list_row for lecture rows
lib/features/quiz/models/quiz_setup_args.dart → add optional lectureId + quizType (keep lessonId for school)
```
Reuse unchanged: `SubjectsScreen`, `subject_card`, `subjects_notifier`, `subject_tree_notifier`
(family), `HomeScreen`, profile models/notifiers. Extend the **mock backend**: a university `GET /me`
(university block) + a `GET /catalog/subjects/{id}/tree` that returns a `UniversitySubjectTree`
(quizTypes + ≥3 lectures with counters), selectable so the harness can walk the university flow.

## l10n (add, both .arb)
`lecturesTitle` ("{subject} Lectures"), quiz-type labels `quizTypeNormal`, `quizTypeMidterm`,
`quizTypeFinal`, `quizTypePractice` (localized), `noLectures`. Arabic provisional — flag for review.

## Acceptance / DoD
- [ ] `SubjectTree` is a sealed union; `UniversitySubjectTree` (quizTypes + lectures) parses; a test
      covers both `fromJson` branches and the discriminator.
- [ ] Repository parses both trees (no university refusal); 403 `insufficient_scope` still mapped.
- [ ] Subject route branches: school→Units, university→Lectures (test both paths from one route).
- [ ] Lectures: numbered rows, per-lecture counter (display-only — test asserts it never gates),
      quiz-type tabs built from `tree.quizTypes` (Flashcard omitted), lecture tap → `/quiz/setup`
      with `lectureId` + `quizType`.
- [ ] University Home renders from a university `GET /me` (reuse `HomeScreen`; only fork if the frame
      truly differs — justify if so).
- [ ] loading / error / offline / empty on the university tree; AR-RTL + EN; light + dark.
- [ ] Lectures title resolves the subject name from the cached subjects list; a test covers the
      cold-deep-link fallback (bare title when the name isn't cached).
- [ ] University fixtures added to the existing `catalog_fixtures.dart`/`catalog_harness.dart` (no new scaffolding).
- [ ] No new `AppColors` tokens added (reuse `catalogCardFill`/`catalogTrack`); rows use `tree_list_row`.
- [ ] Both existing + new notifiers keep `retry: _noRetry` (user-tapped retry only).
- [ ] `flutter analyze` clean · `build_runner` ok · full suite green.
- [ ] Mock harness walks: university Home → Subjects → Lectures → (quiz-setup placeholder) on device.
- [ ] **Color self-audit:** zero `Color(0x`/`Colors.*`/hex in new widgets; all via `colorScheme`/`AppColors`.
- [ ] File **DESIGN_ISSUES #18** (Flashcard tab vs contract `quizTypes`) and note the lecture
      label-format + the "Search Chapters" placeholder for the designer.

## Scope / do NOT
- No quiz setup/taking, no leaderboard/mistakes/friends/messages/settings, no flashcard content, no `POST /quizzes`.
- Do NOT commit — leave for review.
