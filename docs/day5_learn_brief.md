# Day 5 Brief — Learn tab (school): Subjects → Units → Chapters → Lessons

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Prereq: Day 4 committed and `dev` clean. Build only school; university tree is deferred.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq`.

## What Day 5 builds
The **Learn tab** — the catalog *browse* stack. Four screens, all fed by two stable endpoints:
1. **Subjects** (Learn-tab landing, Figma `337:5702`) — replaces the Learn placeholder in the shell.
2. **Units** → 3. **Chapters** → 4. **Lessons** — the drill-down, from ONE tree call.
Tapping a lesson is the entry point to *start a quiz* — that navigates to a **Day-6 placeholder**
(`/quiz/setup`), not built here.

## Explicitly OUT (do NOT build)
Quiz setup + quiz taking (Learn(Setup quiz), Quiz page) = Day 6. The **"Mistakes"** header action
(retake-wrong pool) and any "My Fault" screen = Day 6. Favorites. **University** subject tree
(`UniversitySubjectTree`, lectures/quizTypes) — school only this round. Quiz history / "Continue
Learning". No `POST /quizzes`.

## Skills
`level-up-domain` · `build-screen` · `seif-api-contract` · `figma-frame` · `river` ·
`screen-states` (+ declarative-routing skill for the nested Learn routes, + widget-test skill).

Pull frames with the `figma-frame` skill from file `P6044i0giD9TmdQ7C2AmLq`:
- Subjects: node **`337:5702`** ("Learn(Subject) for school student") — anchor node, confirmed.
- Units / Chapters / Lessons: resolve by name — **"Learn(Units) for school student"**,
  **"Learn(Chapter) for school student"**, **"Learn(lessons) for school student"** (siblings of
  `337:5702` in the same School Student Flow group). Verify each against its screenshot before coding.

---

## Endpoints (both `x-stability: stable`)

### `GET /catalog/subjects` → bare array
`[{ id: Uuid, name: string, questionCounter: { answered: int, total: int } }]`
Server-scoped by the authenticated student (school = education-system + stage) — **client sends no
scope params** (adr-013). Closed per-student set. `name` is already in the content language (adr-018).

### `GET /catalog/subjects/{subjectId}/tree` → `SchoolSubjectTree`
```
{ track: "school",
  units: [ { id, name,
    chapters: [ { id, name,
      lessons: [ { id, name, questionCounter: { answered, total } } ] } ] } ] }
```
The response is a `oneOf` discriminated on `track`; for school it's the shape above. (University's
`{track:"university", quizTypes, lectures[]}` exists but is OUT this round — model the school branch,
leave a `TODO` for university.) `403 insufficient_scope` if the subject is outside the caller's scope.

**KEY ARCHITECTURE RULE:** the tree endpoint returns the WHOLE nested structure in ONE call. Fetch it
**once** when the user opens a subject, cache it in a `family` provider keyed by `subjectId`, and
drive Units → Chapters → Lessons navigation **from that cached object** — do NOT re-fetch per level.

**SERVER-AUTHORITATIVE / display-only:** `questionCounter` (answered/total) is DISPLAY ONLY. Per the
contract it "never locks retakes" — it must not gate, disable, or hide anything. Render the number and
a progress fraction (`answered/total`, clamped) and nothing more. No client math beyond the fraction.

---

## Screens

### 1. Subjects — `337:5702` (Learn tab landing)
Layout (top→bottom): header **"Subjects"** (back chevron + centered title + a right-side **"Mistakes"**
text button — STUB: no-op or route to a Day-6 placeholder); a **"Search Subjects"** search field; a
**2-column grid** of subject cards; the shared dark **nav bar** (Learn tab active).
Each **subject card**: subject `name` (Heading), a trailing chevron, a progress bar, and caption
**"{answered} / {total} questions"** — from `questionCounter`. Reuse the Day-4 card tokens
(`ext.cardFill`, `ext.cardLabel`, `ext.mutedText`, `ext.progressTrack`, `cs.primary` for fill).
- **Search** filters the already-loaded list **client-side** (there is no search endpoint; the set is
  closed). Case/diacritic-insensitive contains on `name`.
- Tap a card → push **Units** for that `subjectId` (triggers the one tree fetch).
- The frame shows 8 mock cards (duplicate "Physics", all "216 / 480") — mock; never hardcode. Render
  whatever the array returns; a 2-col grid of N.

### 2. Units — "Learn(Units) for school student"
List of `units[]` → row per unit: `name` + chevron. Tap → Chapters for that unit. (Read from the
cached tree; no fetch.)

### 3. Chapters — "Learn(Chapter) for school student"
List of the selected unit's `chapters[]` → row per chapter: `name` + chevron. Tap → Lessons.

### 4. Lessons — "Learn(lessons) for school student"
List of the selected chapter's `lessons[]` → row per lesson: `name` + **"{answered}/{total} questions"**
+ chevron. Tap a lesson → **`/quiz/setup` placeholder** (Day 6), passing `lessonId` + display name.

State coverage (screen-states): **loading / error / offline** on Subjects and on the tree fetch;
**empty** on Subjects (student with no subjects) and on any empty units/chapters/lessons level. Reuse
`ScreenState<T>` + `StateWidget`. AR-RTL + EN, light + dark.

---

## State / providers (river)
- `subjectsProvider` — `AsyncNotifier<List<Subject>>` → `GET /catalog/subjects`.
- `subjectTreeProvider(subjectId)` — `family` `AsyncNotifier<SchoolSubjectTree>` → the tree; cached,
  fetched once per subject.
- Units/Chapters/Lessons screens read the cached tree + a selected unit/chapter id from the route.

**RETRY RULE (carry over the Riverpod-3 finding, BUG in `me_notifier` sweep):** both new notifiers
MUST pass `retry: _noRetry` so a failed build surfaces error/offline instead of silently auto-retrying
on `AsyncLoading`. Retry is user-tapped only.

## Routing (declarative)
Nest under the shell's **Learn** branch:
`/learn` (Subjects) → `/learn/subject/:subjectId` (Units) → `.../unit/:unitId` (Chapters) →
`.../chapter/:chapterId` (Lessons). Carry `subjectId`/`unitId`/`chapterId` as path params; read the
tree from `subjectTreeProvider(subjectId)`. Lesson tap → `/quiz/setup` (add a placeholder screen).

## Files
```
lib/features/catalog/
  models/      subject.dart, subject_tree.dart (SchoolSubjectTree, Unit, Chapter, Lesson) — freezed+json, camelCase
  repository/  catalog_repository.dart  (GET /catalog/subjects, GET /catalog/subjects/{id}/tree; typed AppException; map 403→insufficientScope)
  notifier/    subjects_notifier.dart, subject_tree_notifier.dart  (retry: _noRetry)
  screens/     subjects_screen.dart, units_screen.dart, chapters_screen.dart, lessons_screen.dart
  widgets/     subject_card.dart, tree_list_row.dart
lib/features/quiz/screens/quiz_setup_placeholder.dart   (Day-6 stub the lesson routes to)
```
Wire the shell's **Learn** tab to `SubjectsScreen`; add the nested routes + `/quiz/setup` placeholder.
Extend `lib/dev/mock_backend.dart` with `/catalog/subjects` and `/catalog/subjects/{id}/tree`
(school tree with ≥2 units, ≥2 chapters, ≥2 lessons, realistic counters).

## l10n (add, both .arb)
`subjectsTitle`, `searchSubjects`, `mistakes`, `questionsCount` ("{answered} / {total} questions"),
`unitsTitle`, `chaptersTitle`, `lessonsTitle`, `noSubjects`, `nothingHere` (empty tree level).
Arabic strings are provisional — flag for native review.

## Acceptance / DoD
- [ ] Subjects renders from a real `GET /catalog/subjects`; 2-col grid; per-card counter + progress.
- [ ] Search filters the loaded list client-side (no endpoint call).
- [ ] Opening a subject fetches the tree ONCE; Units→Chapters→Lessons navigate from the cache (assert no re-fetch).
- [ ] `questionCounter` is display-only — a test asserts it never disables/hides a row.
- [ ] Lesson tap routes to `/quiz/setup` placeholder with `lessonId` + name.
- [ ] loading / error / offline / empty covered on Subjects and the tree; AR-RTL + EN; light + dark.
- [ ] Both notifiers use `retry: _noRetry` (user-tapped retry only).
- [ ] `Subject` + `SchoolSubjectTree` freezed models, camelCase, `fromJson` tests; notifier tests (success/error/offline); a router/navigation test through the drill-down.
- [ ] `flutter analyze` clean · `build_runner` ok · full suite green.
- [ ] Mock harness serves both endpoints so the Learn tab is walkable on device.
- [ ] **Color self-audit:** grep every new widget for `Color(0x`/`Colors.*`/hex — zero literals; all
      color via `colorScheme`/`AppColors`. Only `Colors.transparent`-type structural values allowed.

## Scope / do NOT
- School only. No university tree, no quiz setup/taking, no Mistakes/favorites, no `POST /quizzes`.
- Do NOT commit — leave for review.
