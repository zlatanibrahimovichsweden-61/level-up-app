# SEIF1014 — plan (School "Soon" stages, module picker, account-deletion path)

**Opened:** 2026-10-14 · **Owner prompt:** "Prompt for the Seif-messages session" (2026-10-14) · **Branch:** `merged`,
HEAD `b227f61` · **Planner/triage:** Opus 5.5 (`claude-opus-5-5`); **builders and reviewers:** Sonnet subagents
(D-024 roles) · **State:** written after Job 0 and Job 1 ran, before any code outside them.

Inputs (from the prompt, all defaults): `MODULE_PICKER_FIGMA_URL: NONE` · `ALL_SUBJECTS_AR: كل المواد` ·
`SEIF_MODULES_HANDOFF: NONE` · `STAGING_LAUNCH_RULES_WINDOW: NONE` · device = the Pixel_8 AVD (API 36).

## 0. Where Job 0 and Job 1 left things (verified, levels as stated)

| Item | Result | Level |
| --- | --- | --- |
| Tree at start | `merged`, HEAD `b227f61`, 156 porcelain entries (98 `M`, 58 `??`); fingerprint of all 141 dirty files kept in the session scratchpad | SOURCE |
| Baseline `validate.ps1` (12:09:41–12:14:18Z, `LEVELUP_VALIDATE_OUT` in scratch) | exit 0 · format PASS · analyze 0 · **3193 passed / 0 failed / 0 skipped** · OVERALL PASS | BUILD |
| Untracked Dart format check (85 files, check only) | 0 changed | BUILD |
| `test/guards` alone · contract guards | 124 · 16 (14 + 2) | BUILD |
| `flutter gen-l10n` | no drift (five l10n blobs unchanged: `ae66b44c`, `8c6f3f89`, `9795a74d`, `84085641`, `5e18a63e`) | BUILD |
| ARB parity / duplicates | 291 = 291 message keys, no duplicates | SOURCE |
| `pubspec.lock` | differs from HEAD by +16 (CW04a's two packages, known) | SOURCE |
| `git diff --check` · debug-logging scan | clean · 0 hits | SOURCE |
| Tree after the gate | porcelain and fingerprint byte-identical to the start | SOURCE |
| Seif's three messages | archived under `docs/SEIF_MESSAGE_*`; each sha256 equals the prompt's; LF, no BOM | SOURCE |
| Contract | re-vendored to **`ded6213` (3.52.0-m1)**; four files blob-identical to upstream, 0 CR; D-025 recorded | SOURCE |

## 1. The contract text the jobs rest on (vendored `contract/`, 3.52.0-m1)

**`listSchoolStages`** — `GET /reference/school-stages` (`openapi.yaml:822`), `x-stability: stable`,
`x-consumers: [mobile, web]`, `security: []` (public). "Always all six stages, in the fixed order `prep1`, `prep2`,
`prep3`, `secondary1`, `secondary2`, `secondary3`. `status: active` = the stage is open for School registration;
`soon` = show it as "Soon", visible but not selectable — `completeRegistration` refuses it with
`422 school_stage_not_available`. No names on the wire: the app localises stage labels itself … read this list rather
than hard-coding it. Bare array (closed set); unauthenticated, under the `/reference` per-address limit."
`200`: array of `{stage: Stage, status: string enum [active, soon]}`, **both required**. `429 rate_limited`. No
`example` is given; ordering promise = the fixed order above.

**`listEducationSystems`** — `GET /reference/education-systems` (`:854`), stable, `x-behaviour-changed: 3.51.0-m1`.
Items `{code: EducationSystem, nameAr, nameEn, status}`; `status`: `type: string`, `enum: [active, soon]`,
"New in 3.51.0-m1. `soon` = shown but not selectable." **Required** (`required: [code, nameAr, nameEn, status]`).
Absence is therefore contract drift (decode must throw); the contract defines no meaning for absence.
`EducationSystem` stays extensible ("clients must tolerate unknown values").

**The two `422` codes** (`error-codes.md:74-75`; `completeRegistration` `422` response, `openapi.yaml` op at
`POST /auth/register`, `x-behaviour-changed: 3.51.0-m1`):

| Code | Returned by | Token | Suggested copy (verbatim) |
| --- | --- | --- | --- |
| `school_stage_not_available` | `completeRegistration`, School body only; also when stage AND system are closed | "not consumed, so resubmit the same token with an open stage while it is valid. Nothing was written." | EN "Level Up isn't open for this grade yet. Coming soon!" / AR «ليفل أب غير متاح لهذا الصف بعد. قريباً!» |
| `education_system_not_available` | same, School body only | "the registration token is not consumed. Nothing was written." | EN "This education system isn't available yet. Coming soon!" / AR «هذا النظام التعليمي غير متاح بعد. قريباً!» |

Order: "All three are checked after every `400`, in that order [stage, system, name], and the registration token is
not used". The `«»` are the document's Arabic quote marks (EN uses `""`); the strings are what is inside them. Both
EN strings use a straight apostrophe (U+0027). Both AR strings spell قريباً alef + fathatan (U+0627 U+064B).

**`requestAccountDeletion`** (`POST /me/deletion-request`, stable): the old must-show sentences ("An active paid
subscription is forfeited — there is no partial refund …") are gone. New text: "Confirm screen — show it BEFORE
calling this. Suggested copy (amends adr-114 D3, Seif 2026-10-09; the final wording is pending the client's
approval)", EN "Deleting your account is permanent. You will lose access to Level Up, and your points, level, badges
and quiz history will be removed. A new account registered later with the same number starts from zero." + the AR,
and "Do not mention payments, refunds or subscriptions on this screen". 3.47.0-m1 relaxed it, as the prompt said.

**`listModules`, `listSubjects`, `getSubjectTree`:** byte-identical between the pin and 3.52.0-m1 (op-level diff).
`listModules` (`openapi.yaml:1954`): University only, school students get `[]`; groups subjects for navigation and
nothing else; "There is no "All subjects" entry in this response — `GET /catalog/subjects` IS that view … the
picker MUST offer the "All subjects" view permanently"; `200` bare array "Order by `displayOrder`, then `name`";
item `{id, name, displayOrder, termId?, termNumber?, subjectIds}` with `required: [id, name, displayOrder,
subjectIds]`; `subjectIds` "Subjects in this module that pass the release gate. May be empty." No order is stated
for `subjectIds`. `401` only.

**Where the contract and Seif's messages differ** — the contract wins:
1. Message 1 says registration "send the student back to the picker"; the contract says let the student fix the
   choice and resubmit with the same token. Same thing on the School screen (the picker IS that screen).
2. Message 1 calls 3.51.0-m1 the version; `listSchoolStages` was `draft` at 3.51 and is `stable` only at 3.52.0-m1.
3. Message 3's example deletion path (Profile → Settings → Delete account) describes a row that does not exist (Job 4).

## 2. Job 2 — School registration "Soon" (change set SSG)

### Slices

**SSG-1 data.**
- `EducationSystemRef` + `required String status` (no default; kept `String` like `StudyYearRef.status`, so an
  unknown value fails closed in the UI instead of throwing the whole list away).
- New freezed `SchoolStageRef {required String stage, required String status}` in `reference_models.dart` (stage is a
  wire `String`; the UI matches it to `Stage` by `wireValue` and ignores codes the enum does not know).
- `ReferenceRepository.getSchoolStages()` — public `GET /reference/school-stages`, the siblings' error wrapping.
- `schoolStagesProvider` = `FutureProvider.autoDispose`, `retry: _noRetry`; `educationSystemsProvider` becomes
  `FutureProvider.autoDispose` (its only consumer is `school_detail_screen.dart`, verified by grep). The file note in
  `reference_providers.dart` records the one exception to session-cached reference data (D-026).
- Mock (`lib/dev/mock_backend.dart`): `status` on `_educationSystems`; `GET /reference/school-stages`; the register
  handler answers the two `422`s after the `400` check (stage first, both-closed = stage). One named constant
  (`_kSchoolRegistrationAllOpen = false`) selects the LAUNCH rule (secondary2/3, nationalArabic/nationalLanguages);
  `true` opens everything, as staging does.
- Contract guard: a sibling of `contractRequiredFields` in `test/guards/rules.dart` that reads an operation's inline
  `200` array item (`paths:` → path → method → responses → '200' → content → application/json → schema → items), with
  its own `rules_test.dart` cases; `contract_models_test.dart` gains a second, separate binding list for inline items:
  `listSchoolStages` → `SchoolStageRef`, `listEducationSystems` → `EducationSystemRef`. Existing bindings untouched.

**SSG-2 UI and behaviour.**
- `ReferenceDropdown` gains ONE optional constructor parameter, `rowMarks` (`Map<String, String>?`, id → mark text),
  default `null`. `PickerOption` (a record typedef) is untouched, so University, city and geography call sites do not
  change and render identically. A marked row draws the mark after its label with existing tokens and an `AppType`
  style; the row stays dimmed by `disabledControlOpacity`; its semantics label includes the mark.
- `school_detail_screen.dart`:
  - Grade options come from `schoolStagesProvider` (AsyncValue), in `Stage.values` order; a row is enabled iff its
    status is exactly `active`; `soon` → disabled + mark; unknown status or a stage the response omits → disabled,
    no mark. Education System rows likewise (`status == 'active'`; `soon` → mark; unknown → disabled, no mark).
  - Both pickers get `AsyncLoading` while their provider is loading OR refreshing (a refresh after a `422` must never
    show the stale rows as selectable) and `AsyncError` whenever it has an error; Grade gains the same user-tapped
    Retry (`ref.invalidate(schoolStagesProvider)`).
  - **Start learning** is disabled until both status lists are loaded without error (registration cannot proceed
    on a slow or failed status read, even with a restored draft).
  - No stale choice: when statuses are present and the draft's stage/system is not `active`, it is cleared after the
    frame (the `_seedDefaultCountry` pattern; never during build), quietly.
  - On either `422`: stay on the screen, draft and token kept; clear the refused selection; invalidate both
    providers; the banner shows the contract copy; the refused field is marked with the existing approved
    "Please check this field" (`fieldRejected`, the NNA precedent) and scrolled into view after the frame. Never
    resubmits. Not added to `restartsRegistration` (the contract says the token is not consumed).
- `registration_controller.dart`: `clearStage()` and `clearEducationSystem()`; `setStage`/`setEducationSystem`
  unchanged; `validateDraft` unchanged.
- `registration_error_copy.dart`: the two codes → two new ARB keys; `fieldIssuesFrom` maps them to
  `stage`/`educationSystem` → `rejected`; a predicate `isSchoolChoiceUnavailable`.
- ARB (both files, gen-l10n): `registrationSoonMark` "Soon" / "قريباً"; `schoolStageNotAvailable`,
  `educationSystemNotAvailable` with the contract copy verbatim. `comingSoon` is NOT reused or changed.

**SSG-3 docs.** DESIGN_ISSUES #133; DECISIONS D-026 (freshness exception + fail-closed rule); BACKEND_HANDOFF Change
log row. No S46 for Job 2: the contract states both the token rule and the copy.

### Tests (each shown failing for the right reason before it passes)
Models + repository from the contract's shapes (no examples exist: fixtures follow the schema); guard bindings + the
two helper cases + a mutation probe each (drop the field from a throwaway copy → the guard fails); providers (retry
opt-out; autoDispose refetch on a second visit); mock (school-stages served, launch rule default, both `422`s, both
closed → stage code, all-open constant); pickers EN + AR (RTL) at text scale 1.3: Soon rows do not select, active
rows do, mark and semantics label show, unknown status fails closed, omitted stage fails closed; loading/error/
offline on Grade + Retry; Start learning disabled while statuses load or fail; stale choice cleared (fresh statuses
and restored draft); one test per `422` (banner copy, selection cleared, both lists refetched, token kept, field
marked, no resubmit); University year rows unchanged.

### Declared deviation — existing test FIXTURES (not test bodies) must change
`status` is contract-required, so the shared fixtures that build education systems must carry it, exactly as the
3.27.0-m1 re-vendor added `flashcardCount` "with the mock and test fixtures":
- `test/features/registration/registration_harness.dart` (foreign-dirty; its only foreign hunk is line 17): add
  `status: 'active'` to the two `educationSystems` rows and stub `getSchoolStages` (all six `active`) in
  `stubReferenceHappyPath`. Without the stub every School test fails closed, by design.
- `test/features/registration/reference_repository_test.dart` (clean): `'status'` in the education-systems JSON.
- `test/dev/mock_backend_v11_test.dart` (foreign-dirty, foreign hunk at line 46): its `_schoolBody` registers
  `secondary1` + `ig`, which the launch-rule mock now refuses; switch to `secondary2` + `nationalArabic`. Adjacent
  to, not overlapping, the foreign line.
No assertion, test name or expectation changes. Every changed fixture line is listed in the report.

### SSG verification
Gate (GS) green; AVD (`--flavor staging -t lib/main_mock.dart`, launch rule): Grade and Education System pickers
open, EN + AR × light + dark; each `422` forced through the mock. Staging is all-open, so real-server "Soon" is
**not exercised** (`STAGING_LAUNCH_RULES_WINDOW: NONE`).

## 3. Job 3 — module picker (CW16b, modules half; change set CW16b-M)

**CW16b-M-1 data.** freezed `CatalogModule {id, name, displayOrder, termId?, termNumber?, subjectIds}` in
`lib/features/catalog/models/`; `CatalogRepository.getModules()` (`GET /catalog/modules`); `modulesProvider`
(non-autoDispose, `noCatalogRetry`, invalidated in `invalidateSessionScope`); `selectedModuleProvider`
(`Notifier<String?>`, null = All subjects; invalidated in `invalidateSessionScope`); pure
`subjectsForModule(module, subjects)` (null module = all; match by id; unknown ids ignored; order = the module's
`subjectIds` order as served, never re-sorted); mock `GET /catalog/modules` mirroring U1 (Foundation Module and
Cardiovascular Module, term 1, both holding Physiology; Histology and the rest in none), `[]` for a school student;
guard binding for the inline item.

**CW16b-M-2 UI.** On `SubjectsScreen`, between the search field and the grid, only when modules is `AsyncData` and
non-empty: "All subjects" first, then modules in server order. Loading, failure, `[]`, school: the screen exactly as
today, and the subjects list never waits for or fails with modules. A selected id that is no longer served falls
back to All subjects. Search filters within the view. A module with no loaded subjects → the screen's existing empty
state. Provisional pill row in `lib/features/catalog/widgets/` re-creating the notification chip look from existing
tokens (no notifications file touched); `// PROVISIONAL(design): DG-26` on each provisional decision; each pill
`button` + `selected` semantics with its label. ARB `allSubjects` "All subjects" / "كل المواد" (AR flagged for the
owner). No term headers, no "Other subjects".

**CW16b-M-3 verification.** Gate; AVD as U1 against staging (one sign-in, session reused, OTP limits respected):
All subjects / Foundation / Cardiovascular, EN + AR, screenshots by `adb pull` into
`.ai/audits/current/completion/seif1014_shots/`; Physiology → Lecture 1 quiz start and the CDN image (and its
loading/failure states). If the AVD or staging is unreachable: BUILD only, with a manual checklist.

**Docs.** DESIGN_ISSUES #134; BACKEND_HANDOFF U1 row (dated, source message 2) + Change log; CW16b notes in
`04_COMPLETION_ROADMAP.md` and `COMPLETION_STATE.md`.

## 4. Job 4 — answer only
Source proof (labels file:line, every Profile row and Settings block, absence of any deletion row/route/screen/
repository method/ARB key/caller); AVD screenshots of Account → Profile → Settings if the AVD is up; the reply draft
in the report; S46 only if S38/BH-C5 do not already cover the open points. Nothing built.

## 5. Open questions (for the owner unless marked)
1. The Soon mark has no Figma frame, and University `soon` years still show no label (#133, designer).
2. «قريباً» (Seif, alef + fathatan) vs the existing `comingSoon` «قريبًا» (fathatan on the beh): the new key uses
   Seif's spelling; both are shown side by side in the report.
3. "كل المواد" is provisional (#134).
4. The order of `subjectIds` inside a module is not promised by the contract; the build keeps it as served.

## 6. Commit plan (proposal only — nothing is committed)
CV352 (contract + SOURCE.md + DECISIONS D-025 hunk + BACKEND_HANDOFF version rows) · archive (three
`SEIF_MESSAGE_*` + BACKEND_HANDOFF Provenance/Change-log hunks) · SSG · CW16b-M · docs. Final split in the report.
