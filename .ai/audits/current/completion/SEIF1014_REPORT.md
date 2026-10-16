# SEIF1014 — report (School "Soon" stages, module picker, account-deletion path)

**Wave:** SEIF1014 · **Date:** 2026-10-14 · **Owner prompt:** "Prompt for the Seif-messages session" (2026-10-14) ·
**Branch:** `merged`, HEAD `b227f61` (unchanged) · **Plan:** `SEIF1014_PLAN.md` · **Pre-copies:**
`seif1014_prewave/` (`SHA_LIST.txt` = blob id, path, tracked/untracked and status of every file before this wave
touched it; `TAKEN_AT.txt`).
**Models:** lead (plan, Job 1 analysis, triage, docs, device walk) = Opus 5.5, `claude-opus-5-5`; builders and
checkers = Sonnet subagents (D-024 roles; requested as `sonnet`, recorded in their transcripts as
`claude-sonnet-5-5`); the Job 1 delta analysts = Opus subagents.
**Nothing was staged, committed, pushed, stashed or sent.** Inputs used: every default (`MODULE_PICKER_FIGMA_URL:
NONE`, `ALL_SUBJECTS_AR: كل المواد`, `SEIF_MODULES_HANDOFF: NONE`, `STAGING_LAUNCH_RULES_WINDOW: NONE`).

**Status: PASS WITH WARNINGS** (§10). Final gate 3432 / 0 / 0 (BUILD); Jobs 2 and 3 seen on the AVD; nothing committed or sent.
**Follow-up 2026-10-15 (§11): NOT CORRECT** by the prompt's Part D test (§11.8) — owner decisions applied, the
updated Figma checked against the contract, fixable mismatches fixed, the rest logged; gate green; nothing sent.
**Second follow-up 2026-10-15 (§12): NOT CORRECT** (same rule) — the owner's four §11.7 decisions done (University
year mark, Rank help lines dropped, "points" kept, the B9 icon exported but not wired); gate 3486 / 0 / 0; what remains
is the designer's dark and Arabic frames; nothing sent.

---

## 1. Job 0 — preflight

| Check | Result | Level |
| --- | --- | --- |
| Tree | `merged`, HEAD `b227f61`, **156** porcelain entries (98 `M`, 58 `??`); the prompt expected about 155. Fingerprint (blob id of all 141 dirty files) kept in the session scratchpad | SOURCE |
| Concurrent sessions | `ListAgents`: none running | SOURCE |
| `validate.ps1` (12:09:41–12:14:18Z, `LEVELUP_VALIDATE_OUT` in scratch) | exit 0 · format PASS · analyze 0 issues · **3193 passed / 0 failed / 0 skipped** · OVERALL PASS — equal to the last recorded gate (2026-10-11) | BUILD |
| Untracked Dart, format **check** only (85 files) | 0 changed | BUILD |
| `test/guards` alone · contract guards | 124 passed · 16 passed (14 + 2) | BUILD |
| `flutter gen-l10n` | no drift: `app_en.arb` `ae66b44c`, `app_ar.arb` `8c6f3f89`, `app_localizations.dart` `9795a74d`, `_en` `84085641`, `_ar` `5e18a63e` before and after | BUILD |
| ARB parity / duplicate keys | 291 = 291 message keys; no duplicates | SOURCE |
| `pubspec.lock` | differs from HEAD by +16 lines (CW04a's two packages; known, unchanged by this wave) | SOURCE |
| `git diff --check` · `debugPrint` / `dart:developer` / `LogInterceptor` in `lib/` | clean · 0 | SOURCE |
| Tree after the gate | porcelain list and fingerprint byte-identical to before | SOURCE |

**Seif's messages archived** (written with the Write tool; UTF-8, LF, no BOM, one trailing newline):

| File | Bytes / lines | sha256 (= the prompt's) |
| --- | --- | --- |
| `docs/SEIF_MESSAGE_2026-10-12_school-launch-stages.md` | 1,427 / 20 | `567b6c51a1de4c1e2c0874d5c7a1c0a8d092b0e673615cd679aea181eec564e9` |
| `docs/SEIF_MESSAGE_2026-10-13_sample-modules.md` | 879 / 15 | `be03e4477218c9b37c934cd97c491d7f05d1426eaa3f5b281e22aeda0c8cb897` |
| `docs/SEIF_MESSAGE_2026-10-13_school-stages-stable.md` | 1,110 / 14 | `7f4ca6949cda4649a6a3c93486b500a6d3151c5e4c9ed3e69b110bf1357762c9` |

All three hashes matched on the first write. `docs/BACKEND_HANDOFF.md`: three Provenance rows (transcribed from the
prompt, line endings may differ from the original attachments) and one Change log row.

## 2. Job 1 — re-vendor to 3.52.0-m1 (change set CV352)

**Commit.** `git fetch origin` in the clone (remote-tracking refs only; working tree never read): `origin/main` moved
`cc2a29d` → **`ded6213`**. Sixteen commits since the pin; nine carry `info.version: 3.52.0-m1`:

| Commit | Mirrored (UTC) | Mobile files changed |
| --- | --- | --- |
| `8ef3306` | 2026-10-13 13:17:57 | `openapi.yaml`, `contract-changelog.md` (the stable flip) |
| `7f6844c`, `cbf9df5` | 14:33:40, 15:16:12 | none (admin only) |
| `1b4b0d5` | 15:57:48 | `contract-changelog.md` (OpenRouter note) |
| `6f0f3d7`, `f2cc04e`, `ee8b902`, `418b097` | 23:32:31 … 2026-10-14 01:34:20 | none (admin only) |
| **`ded6213`** | **2026-10-14 02:08:35** | none (admin only) — **newest: pinned** |

The four mobile blobs are identical from `1b4b0d5` to `ded6213`. **Nothing newer than 3.52.0-m1 exists upstream**
(`ls-remote`: `HEAD` = `main` = `ded6213`), so there are no later versions to list.

**Stop checks (step 2), all passed in `ded6213`:** `listSchoolStages` exists, `x-stability: stable`,
`x-consumers: [mobile, web]`; `listEducationSystems` items carry a required `status`; `error-codes.md` has both
registration codes.

**Copy (step 3).** `.gitattributes` = `* text=auto eol=lf`; `git ls-files --eol contract/` = `i/lf w/lf` for all
five. Dry run into a scratch folder outside the repo with `git -C <clone> show ded6213:<file> > …` (Git Bash), then
the same into `contract/`; both times `git hash-object` (with and without filters) = `git rev-parse ded6213:<file>`
and 0 CR bytes:

| File | Blob |
| --- | --- |
| `openapi.yaml` | `1f067289cd73da97f9bbf9491bdd6017f4d8c43d` |
| `contract-changelog.md` | `57dc8a4a37ceb6abcbbe76ae5e82743eeddffa71` |
| `error-codes.md` | `ab767838047042af51b970cf6a2e7aca77792a9b` |
| `realtime.md` | `171e9ee361aa34db9cd7676dbfa182e8f11dcbd1` |

`git diff --stat -- contract/` = 520 insertions, 63 deletions — the same as the upstream diff of those four files.

**`contract/SOURCE.md`** (existing format; `contract_pin_test.dart` passes unmodified): pinned commit, version line,
vendored date, previous pin, blob ids, census (PyYAML: **89 stable · 0 draft · 89**, 4 web-only → **85
app-buildable**, 21 public; was 86 / 82 / 19), and a new **"Delta from 3.46.0-m1"** section: one row per version
3.47–3.52, the wire-shape audit and eleven follow-ups. The delta's app-impact column comes from a read-only
workflow (7 Opus analysts by topic, 3 adversarial verifiers on the items flagged as breaking, 1 completeness
critic; 11 agents, 0 errors; results kept in the scratchpad).

**Wire-shape audit (summary).** 3 operations and 5 schemas added; none removed; no route moved. Wire changes to
existing operations: `completeRegistration` (+422), `listEducationSystems` (+ required `status`), `updateMyProfile`
(+422), `registerFcmToken` (+403); 17 others changed prose only. **All 13 schemas bound in
`contract_models_test.dart` are wire-identical.** `error-codes.md` 62 → 65 codes.

**Behavioural changes 3.47–3.52.** 3.47's four (push-token cleanup, `leveledUp` ladder, `name_not_allowed`,
recovery lock — already in BACKEND_HANDOFF BH-B4) and **3.51's two** (`completeRegistration`,
`listEducationSystems`, now `x-behaviour-changed: 3.51.0-m1`). 3.48–3.50 and 3.52 stamp nothing new; 3.47
re-stamps `getLeaderboard`/`getMyRank` with 3.36.0-m1 (an old change relabelled). 3.50's 2026-10-12 entry changes
server behaviour without a stamp (admin name corrections, opening a `soon` year, removing an empty subject or
lecture). **None breaks shipped code that a SEIF1014 job depends on**, so no STOP: `name_not_allowed` was already
built (NNA); the shipped School screen answered the 3.51 codes with "Something went wrong" but stayed on the screen
with the draft and token (verified by trace) — Job 2 replaces that.

**Flagged, not fixed** (all in `SOURCE.md`, follow-ups 3–9): the `account_banned` copy and client rule ("the
channel is email"); Daily Tasks (stable since 3.49, unbuilt); the prod flavor's placeholder base URL; the
process-lifetime `universitiesProvider` vs admin corrections (low); a removed subject or lecture ending on a futile
Retry (low); Home's Level-12 "6,000" target (pre-existing, BH-E10); stale "3.46.0-m1 / eddb6ac" wording in
comments only (`registration_error_copy.dart:79`, `profile_error_copy.dart:49`, `app_localizations.dart:431`,
`:1745-1751`, two NNA test headers). **No test or guard hard-codes `3.46.0-m1` or `eddb6ac`**, so step 5 changed no
test string.

**Records.** D-025 (and the "Superseded by D-025" line under D-022); BACKEND_HANDOFF PIN row, U347/U348 "now
vendored", U351 (`1de51b5`) and U352 (`ded6213`) rows, a Change log row.

**Gate after the re-vendor** (`validate.ps1`, 12:44:56–12:50:55Z): exit 0 · format PASS · analyze 0 · **3193 / 0 /
0** · OVERALL PASS; contract guards 16 / 16 (BUILD).

### 2.1 The contract text Jobs 2–4 rest on (quoted from the vendored `contract/`)

- **`listSchoolStages`** — `GET /reference/school-stages`, `operationId: listSchoolStages`, `security: []`, stable,
  `x-consumers: [mobile, web]`: "Always all six stages, in the fixed order `prep1`, `prep2`, `prep3`,
  `secondary1`, `secondary2`, `secondary3`. `status: active` = the stage is open for School registration; `soon` =
  show it as "Soon", visible but not selectable — `completeRegistration` refuses it with
  `422 school_stage_not_available`. No names on the wire: the app localises stage labels itself, as before. The
  open set is a server setting, so read this list rather than hard-coding it. Bare array (closed set);
  unauthenticated, under the `/reference` per-address limit." `200`: items `{stage: Stage, status: active|soon}`,
  both required; `429 rate_limited`. No examples. Ordering promise: the fixed order.
- **`status` on `listEducationSystems`** — `type: string`, `enum: [active, soon]`, "New in 3.51.0-m1. `soon` =
  shown but not selectable", **required** (`required: [code, nameAr, nameEn, status]`); the contract gives absence
  no meaning, so a missing `status` is drift and the decode throws.
- **The two `422`s** — `completeRegistration` only, School body only; "All three are checked after every `400`, in
  that order [stage, system, name], and the registration token is not used … Nothing was written";
  `school_stage_not_available` also when both are closed. Suggested copy (`error-codes.md:74-75`): EN "Level Up
  isn't open for this grade yet. Coming soon!" / AR «ليفل أب غير متاح لهذا الصف بعد. قريباً!»; EN "This education
  system isn't available yet. Coming soon!" / AR «هذا النظام التعليمي غير متاح بعد. قريباً!».
- **`requestAccountDeletion`** — the old must-show sentences are removed; new suggested copy "pending the client's
  approval", and "Do not mention payments, refunds or subscriptions on this screen".
- **`listModules`, `listSubjects`, `getSubjectTree`** — unchanged since the old pin (operation-level diff).
- **Contract vs Seif:** Seif calls 3.51.0-m1 the version; `listSchoolStages` is stable only at 3.52.0-m1. His "send
  the student back to the picker" = the contract's "let the student fix the choice and resubmit with the same token"
  (the picker is on the same screen). His deletion-path example describes a row that does not exist (Job 4).

## 3. Job 2 — School registration "Soon" (change set SSG)

**Built by** one Sonnet builder from `spec_ssg.md` (scratchpad), **audited by** one read-only Sonnet checker against
every spec step (18 / 18 done; 5 low issues, triaged in §3.4).

### 3.1 What it does
- **Data.** `EducationSystemRef.status` (required String, no default); new `SchoolStageRef {stage, status}`;
  `ReferenceRepository.getSchoolStages()` (public GET, the siblings' error wrapping); `schoolStagesProvider` and
  `educationSystemsProvider` are `FutureProvider.autoDispose` with the retry opt-out — read on every visit (D-026).
  The `Stage` enum and the app's own labels stay; status is matched by `wireValue`; unknown stage codes are ignored.
- **Pickers.** A row is selectable iff its status is exactly `active`. `soon` → dimmed (`disabledControlOpacity`),
  not selectable, with a trailing "Soon" / «قريباً» mark (`AppType.labelMedium`, `ext.hint`) and the accessible name
  "<label>, <mark>". Unknown status or an omitted stage → dimmed, no mark. Rows keep their order. `PickerOption` is
  unchanged: `ReferenceDropdown` gained one optional `rowMarks` map, so University, country, governorate and city
  rows build the identical widget tree (a test proves no mark reaches University rows).
- **States.** While a status list loads **or refreshes** (Riverpod 3 keeps old rows during a refresh — those are
  never shown as selectable), the field shows its loading state; on failure, the error/offline state with a
  user-tapped Retry (Grade now has one). **Start learning** is disabled until both lists are loaded without error.
- **No stale choice.** A drafted stage or system that is not `active` in fresh statuses (including a restored draft)
  is cleared after the frame, quietly. `school_pick_survives_return_test.dart` still passes (16 / 16).
- **The two `422`s.** Stay on the School screen with the draft and token; the refused selection is cleared; both
  lists are refetched; the banner shows the contract copy; the field shows the approved "Please check this field"
  (`fieldRejected`, as NNA does for the name) and is scrolled into view; nothing resubmits; not added to
  `restartsRegistration` (the contract says the token is not consumed — no S46 needed for Job 2).
- **Copy.** Three new keys in both ARBs: `registrationSoonMark`, `registrationSchoolStageNotAvailable`,
  `registrationEducationSystemNotAvailable` (EN `app_en.arb:197-208`, AR `app_ar.arb:113-115`), byte-checked against
  the contract and Seif (straight apostrophes; قريباً = U+0627 U+064B). `comingSoon` untouched.
- **Mock.** `kMockSchoolRegistrationAllOpen = false` (`mock_backend.dart:53`) = the LAUNCH rule (secondary2/3; the
  two National systems); `true` opens everything. `GET /reference/school-stages`; `status` on education systems; the
  register handler answers both `422`s after the `400` check and writes nothing. Deviation (accepted): an optional
  `schoolRegistrationAllOpen` argument on `buildMockDio`/`MockBackendInterceptor`, defaulting to the constant, so
  tests reach the all-open case without editing it; `main_mock.dart` unchanged.
- **Guard.** `test/guards/rules.dart` gained `contractOperationItemRequiredFields` (an operation's inline `200`
  array item; the existing helper untouched; 9 unit tests); `contract_models_test.dart` gained a separate
  `inlineBindings` list (`listSchoolStages` → `SchoolStageRef`, `listEducationSystems` → `EducationSystemRef`) with a
  **permanent mutation probe** per binding (the class body with `status` removed in memory → reported missing; the
  real body → nothing missing).

### 3.2 Tests
97 new tests in 4 new files — `school_stage_status_test.dart` (20), `school_soon_pickers_test.dart` (39, EN + AR at
1.3×), `school_choice_unavailable_test.dart` (19), `test/dev/mock_backend_school_stages_test.dart` (19) — plus 9 in
`rules_test.dart` and 4 in `contract_models_test.dart` (18 total there). **Fail-first** was shown for every
behaviour on throwaway mutated copies outside the repo (the builder's report, kept in the scratchpad; e.g. the
pre-edit screen fails 40 of 54 widget tests; each screen mutation is caught by a named test). **Existing test
bodies unchanged**; fixture data changed only as the plan declared: `registration_harness.dart` (`status: 'active'`
on both systems; an all-active `schoolStages` constant and its stub), `reference_repository_test.dart`
(`'status': 'active'` in two JSON maps), `mock_backend_v11_test.dart` (`secondary1`/`ig` → `secondary2`/
`nationalArabic`, because the mock now defaults to the launch rule). The foreign hunks of those files (harness line
17, v11 line 46) are untouched.

| Run (checker, independent) | Result |
| --- | --- |
| the 4 new files, each alone | 20 · 39 · 19 · 19 passed |
| `contract_models_test` · `rules_test` · `reference_repository_test` · `mock_backend_v11_test` | 18 · 70 · 12 · 17 passed |
| `school_pick_survives_return_test` · `school_detail_screen_test` (existing, unchanged) | 16 · 37 passed |
| `flutter test test/features/registration test/dev test/guards test/core` | **1182 passed, 0 failed** |
| `flutter analyze --no-pub` | No issues found |
| `dart format` check on the 18 hand-written Dart files · line endings | 0 changed · CRLF kept on `school_detail_screen.dart` and `registration_error_copy.dart`, all else LF, none mixed |
| generated files | only `reference_models.freezed.dart` / `.g.dart` and the three `app_localizations*.dart` changed (blob ids vs `SHA_LIST.txt`) |

### 3.3 Verification

**Gate (GS), on the final code of Jobs 2 + 3 together** (counts against the Job 0 baseline 3193):

| Step | Result | Level |
| --- | --- | --- |
| `validate.ps1` (15:34:54–15:38:13Z, `LEVELUP_VALIDATE_OUT` in scratch) | exit 0 · format PASS · analyze 0 · **3428 passed / 0 failed / 0 skipped** · OVERALL PASS. 3428 = 3193 + 110 (SSG: 97 + 9 + 4) + 125 (CW16b-M: 123 + 2) | BUILD |
| Untracked Dart, format check only (102 files: 85 foreign + this wave's 17) | 0 changed | BUILD |
| `test/guards` alone · contract guards (`contract_models_test` 20 + `contract_pin_test` 2) | 139 (was 124) · 22 (was 16) | BUILD |
| `flutter gen-l10n` | no drift (`app_en.arb` `7121db21`, `app_ar.arb` `fbe05ded`, `app_localizations.dart` `2ca0bd29`, `_en` `08f0e3db`, `_ar` `dc75b9ac`) | BUILD |
| ARB parity / duplicates | 295 = 295 message keys (+4: three SSG, one CW16b-M); no duplicates | SOURCE |
| `pubspec.yaml` / `pubspec.lock` | unchanged by this wave (the CW04a +8 / +16 against HEAD are foreign and untouched) | SOURCE |
| `git diff --check` · debug logging in `lib/` · purchase words in this wave's 12 `lib/` files | clean · 0 · 0 | SOURCE |
| Foreign files | every file dirty at the start that this wave did not own is byte-identical to its start fingerprint; the 17 start-dirty files it changed are all on its allowed list; no entry disappeared | SOURCE |

**AVD walk** (Pixel_8 AVD, API 36, 1080×2400 @ 420 dpi; screenshots by `screencap` + `adb pull`; taps from
`uiautomator` bounds). Screenshots: `.ai/audits/current/completion/seif1014_shots/ssg_mock/`.
- **Mock build, launch rule** (`flutter build apk --debug --flavor staging -t lib/main_mock.dart`, fresh install):
  Education System and Grade pickers open in **EN + AR × light + dark** (`01`–`04`, `06`–`09`). The uiautomator
  tree confirms: IG / American / IB and Prep 1–3 / Secondary 1 are `clickable=false` with the names "IG, Soon" /
  «آي جي, قريباً»; the two National systems and Secondary 2–3 are clickable. Tapping a Soon row leaves the menu open
  and selects nothing. **AVD**.
- **The two `422`s and the Grade error state** need a server that disagrees with the pickers, which the real mock
  never does (the UI fails closed). They were forced with a **test-only variant built in a throwaway copy of the
  tree** (scratchpad `variant422/`; the repo was not changed): statuses served all-open, registration still refusing
  by the launch rule, and the first `school-stages` read failing with a `500`. At **text scale 1.3**:
  - Grade error state in Arabic (`20`): «حدث خطأ ما» + «إعادة المحاولة», **no overflow** on the 412 dp screen with
    the real fonts (so the builder's ~3 px figure is a widget-test font artifact); **Start learning disabled** while
    the read is failed; Retry recovers.
  - `school_stage_not_available` (`21` AR, `24` EN) and `education_system_not_available` (`22` AR, `23` EN): the
    student stays on the screen, the refused field is cleared, marked "Please check this field" / «من فضلك تحقق من هذا
    الحقل» and scrolled into view, the other choice is kept, and the banner shows the contract copy verbatim. **AVD
    (variant mock)**.
- **Real staging "Soon" — NOT EXERCISED.** Staging is all-open for test accounts and
  `STAGING_LAUNCH_RULES_WINDOW` was `NONE`; Seif's live test (changelog run `9d868758`) is his claim, not ours.
- **Not verified:** a physical device, TalkBack, iOS, and the Grade *offline* state on a device (the mock ignores
  connectivity; the offline state is widget-tested only).

### 3.4 Triage of the checker's findings
1. *Low — shared `_PickerFailure` row:* the builder reports a ~3 px horizontal overflow in Arabic at 1.3× on a
   412 dp surface in the widget-test font, and widened the Arabic failure tests to 460 dp. The widget is unchanged
   by this wave, but Grade can now reach it. The test font is about 1.5× wider than the real fonts, so this may not
   happen on a device — **checked on the AVD in §3.3.**
2. *Low — `session_scope_discipline_test.dart:56-57`* still calls `educationSystemsProvider` "Global reference data";
   it passes only because the provider is now autoDispose. Outside this wave's files: follow-up for the owner.
3. *Low — Start learning and the post-frame clear:* both lists settled + a stale choice = enabled for one frame
   before the clear; not reachable by a tap. Accepted.
4. *Low — mock API wider than specified* (the optional argument; `status` added at serve time). Accepted, disclosed.
5. *Low — loading wins over a retried error* (Retry shows a spinner). Accepted.

## 4. Job 3 — module picker (CW16b, modules half; change set CW16b-M)

`MODULE_PICKER_FIGMA_URL: NONE` → the **provisional** picker; `SEIF_MODULES_HANDOFF: NONE` → "both views" = a module
view and All subjects. **Built by** one Sonnet builder from `spec_cw16bm.md`, **audited by** one read-only Sonnet
checker (10 / 11 steps done, 1 partial with a sound reason, 4 low issues; every builder count reproduced).

### 4.1 What it does
- **Data.** freezed `CatalogModule {id, name, displayOrder, termId?, termNumber?, subjectIds}`
  (`lib/features/catalog/models/catalog_module.dart`); `CatalogRepository.getModules()`; in
  `lib/features/catalog/notifier/modules_notifier.dart`: `modulesProvider` (non-autoDispose, `noCatalogRetry`),
  `selectedModuleProvider` (`null` = All subjects), pure `subjectsForModule` (walks `subjectIds` in served order,
  skips unknown ids, never re-sorts or duplicates), `resolveSelectedModule` (a selection no longer served → All), and
  `pickableModules` (null while loading, refreshing or failed, and for `[]` — a refresh never shows the old list).
  Both providers are invalidated in `invalidateSessionScope` (`lib/core/session/session_scope.dart`, Catalogue block;
  its foreign lines 51–67 untouched); the discipline guard passes unedited.
- **UI.** `SubjectsScreen`: only when modules are settled and non-empty, a pill row between the search field and
  the grid — **All subjects first and selected by default**, then the modules in server order, names verbatim. School
  student / `[]` / loading / failed / offline modules: the screen exactly as before; the subjects list never waits
  for or fails with modules. Search filters within the view; a module with no loaded subject shows the existing "No
  subjects yet" state. The pill row (`lib/features/catalog/widgets/module_picker.dart`) re-creates the notification
  chip look from the same tokens (no notifications file touched), starts at the start edge, 48 dp targets, a width cap
  that wraps a long name; each pill is a button with `selected` semantics. `// PROVISIONAL(design): DG-26` on every
  provisional decision; listed in DESIGN_ISSUES #134.
- **Copy.** `allSubjects`: EN "All subjects", AR «كل المواد» — the AR is **your provisional string, for confirmation**
  (the ARB description says so).
- **Mock.** `GET /catalog/modules`: `[]` for a school student; for a University student, Foundation Module and
  Cardiovascular Module (term 1), both holding Physiology — a U1 mirror, test data.
- **Guard.** A separate `moduleBindings` list in `contract_models_test.dart` (`listModules` → `CatalogModule`) with its
  own mutation probe (`subjectIds` removed in memory → reported missing). It could not join `inlineBindings`, whose
  probe is written around `status`; accepted (two copies of one check — a later refactor could give each row its own
  probe field).

### 4.2 Tests
123 new tests in 8 new files (`catalog_module_test` 10, `modules_repository_test` 7, `modules_notifier_test` 29,
`module_picker_test` 16, `module_picker_layout_test` 24 with the real fonts, `subjects_screen_modules_test` 31,
`test/dev/mock_backend_modules_test` 6, plus `module_fixtures.dart`) and 2 in `contract_models_test.dart`.
Fail-first shown on throwaway mutated copies for every behaviour (25 mutations; the checker re-ran 12 and reproduced
them). The existing `subjects_screen_test.dart` (23) and `session_scope_discipline_test.dart` (6) pass unedited. Two
navigation tests run at text scale 1.0 because the Lectures screen's `TreeListRow` already overflows at 1.3 in the
widget-test font (existing; the memory notes that test-font widths are ~1.5× the real fonts).

### 4.3 The U1 staging check (AVD against staging)
Staging debug build (`--flavor staging -t lib/main_staging.dart`), fresh install, **one** sign-in as U1 with the
published staging code (read from the contract into a shell variable, never written down or printed). Screenshots
(`adb pull`): `.ai/audits/current/completion/seif1014_shots/u1_{ar,en}_{all_subjects,foundation_module,cardiovascular_module}.png`.

| Expected (Seif, 2026-10-13) | Seen 2026-10-14 | Level |
| --- | --- | --- |
| All subjects shows Physiology, Histology, Biochemistry | All subjects shows **Anatomy (Level Up demo)**, Biochemistry, Physiology, Histology — Anatomy is U1's original seeded subject, not named in the message | AVD |
| Foundation Module and Cardiovascular Module each show Physiology, not Histology or Biochemistry | Each shows **Physiology only** | AVD |
| Biochemistry (term 2) under All subjects | Yes (no term headers are built) | AVD |
| Physiology → Lecture 1 - The cardiac cycle starts a quiz | Quiz Setup → 10 questions → the quiz opened at "1/10" (so one quiz was created on staging for U1); left with "Leave" without answering — no answer was sent | AVD |
| The question with a CDN image renders | Question 1 carries the image node "Question image", 975 px tall — that label exists only in the loaded branch (`mcq_renderer.dart:89-93`); the placeholder and error boxes are 189 dp and unlabelled. The quiz screen sets FLAG_SECURE, so the image cannot be screenshotted | AVD (semantics) |
| Image loading and failure states | Loading box: widget-tested (`quiz_screen_test.dart:990-1022`). Failure box (`mcq_renderer.dart:77-84`): **not tested and not exercised** | BUILD / not verified |

Also seen: the pill row starts at the right edge in Arabic; the chosen module survived leaving Learn for Account →
Settings (a language switch) and coming back.

### 4.4 Triage of the checker's findings
1. *Low — separate `moduleBindings` list:* accepted (see 4.1).
2. *Low — a failed modules read is never retried within a session:* `modulesProvider` keeps its error; the
   Subjects Retry refreshes only the subjects list; a University student whose first modules read fails sees no picker
   until sign-out or restart, while All subjects keeps working. This follows the spec ("exactly as today") and the
   project's no-silent-retry rule, so it is **an owner question** (e.g. also invalidate modules on the Subjects Retry
   or on reconnect), not a fix made here.
3. *Low — a stale selection stays in the provider while the row is hidden:* the read-time fallback to All subjects is
   correct and tested. Accepted.
4. *Low — the builder's report said "additions only":* two of its own doc lines and three of its own lines in
   `subjects_screen.dart` were modified; no foreign line. Wording only.

## 5. Job 4 — the in-app account-deletion path (answer only; nothing built)

### 5.1 What exists today (SOURCE, 2026-10-14)

**The path as rendered** (labels from the ARBs; the screens render these keys):

| Step | Widget | Key | EN | AR |
| --- | --- | --- | --- | --- |
| Bottom tab | `lib/features/shell/main_shell.dart:61` | `navAccount` (`app_en.arb:262`, `app_ar.arb:134`) | Account | حسابي |
| Screen title | `lib/features/profile/screens/profile_screen.dart:141` | `profileTitle` (`:535`, `:216`) | Profile | الملف الشخصي |
| Row | `profile_screen.dart:236-237` → `context.push('/settings')` | `profileSettings` (`:541`, `:219`) | Settings | الإعدادات |
| Screen | `lib/features/settings/screens/settings_screen.dart:59` (title), route `app_router.dart:549` | `profileSettings` | Settings | الإعدادات |

**Every Profile row** (`profile_screen.dart:236-321`, in order): Settings · Favorite questions (`profileFavoriteQuestions`,
«الأسئلة المفضّلة») · Your progress («تقدّمك») · Refer a Friend («دعوة صديق») · Customer Support («دعم العملاء») ·
Privacy & policy («سياسة الخصوصية») · Terms & Conditions («الشروط والأحكام») · Go to University («التحويل إلى الجامعة»)
· Logout («تسجيل الخروج»). **No deletion row.**

**Every Settings block** (`settings_screen.dart`): Languages «اللغة» (`:151`) · Mode «الأوضاع» (`:231`: Light /
Dark) · Rank «الترتيب» (`:288-330`: "Show me on the leaderboard", "Hide my points") · Notification Preferences
«تفضيلات الإشعارات» (`:390-414`: Announcements, Promotions, Support, System). **No Delete account row.**

**Absent** (grep of `lib/`): no deletion route in `app_router.dart` (0 matches for "delet"), no deletion screen, no
repository method, no ARB key except the `403` message `accountPendingDeletion` (`app_en.arb:696`, `app_ar.arb:298`),
and no caller of `requestAccountDeletion` or `cancelAccountDeletion` (the only mentions are doc comments in
`lib/core/network/exceptions.dart:95-135`). The path that exists ends at Settings: **Account / «حسابي» → Profile /
«الملف الشخصي» → Settings / «الإعدادات» → no deletion row.**

**AVD (mock build, signed in as the mock School student):** the same path walked in English and Arabic; the
uiautomator tree lists exactly the rows above (Favorite questions and Your progress are disabled, "Not available
yet"), and the Settings screen scrolled to its end shows the four blocks and no deletion row. Screenshots:
`.ai/audits/current/completion/seif1014_shots/job4_path/` (`10`–`15`: Account/Profile EN and AR, the end of the
Profile rows, Settings EN, AR light and AR dark).

### 5.2 Draft reply to Seif — NOT SENT

> Hi Seif,
>
> About the Account Deletion page: the current build has **no in-app way to delete an account yet**, so please
> don't put a path on the page for now, and please don't use the example in your message. In the current build the
> tab is called "Account" («حسابي»), not Profile, and the Settings screen has no "Delete account" row.
>
> The in-app flow is planned (our wave CW05). It is waiting for the designer's screens (the request, confirm and
> success screens, and the Settings row), for Ahmed's final approval of the confirm-screen text you sent on
> 9 October, and for my go-ahead, so I can't give you a date yet. When it is built, I'll send you the exact labels in
> English and Arabic from the finished build, with screenshots.
>
> Two questions in the meantime:
> 1. What may the page say until then? Both stores expect a working in-app path and a public URL when we submit.
> 2. Can the page's wording stay consistent with the confirm-screen text? That text says deletion is "permanent",
>    but the account can still be restored by logging in within the 30-day grace period.
>
> Thanks,
> Mostafa

**Filed:** `docs/seif_fight.md` **S46** (neither S38 nor BH-C5 asks these two questions). Nothing built for
deletion: no row, route, repository method, ARB key or copy.

## 6. Files, by ownership

**Written by this wave, new:** `docs/SEIF_MESSAGE_2026-10-12_school-launch-stages.md`,
`docs/SEIF_MESSAGE_2026-10-13_sample-modules.md`, `docs/SEIF_MESSAGE_2026-10-13_school-stages-stable.md`;
`lib/features/catalog/models/catalog_module.dart` (+ `.freezed.dart`, `.g.dart`), `.../notifier/modules_notifier.dart`,
`.../widgets/module_picker.dart`; 12 test files (4 SSG, 8 CW16b-M); `SEIF1014_PLAN.md`, this report,
`seif1014_prewave/` (82 entries), `seif1014_shots/` (6 staging + 13 SSG + 6 Job 4 PNGs).

**Edited, clean before this wave** (whole diff is this wave's): the four `contract/` files and `contract/SOURCE.md`;
`reference_models.dart` (+ generated), `reference_repository.dart`, `reference_providers.dart`,
`reference_dropdown.dart`; `catalog_repository.dart`, `subjects_screen.dart`; `test/guards/rules.dart`,
`rules_test.dart`, `contract_models_test.dart`; `test/features/registration/reference_repository_test.dart`
(fixture data only).

**Edited, already dirty with other waves' hunks — this wave's hunks sit beside foreign ones, untouched:**
`school_detail_screen.dart` (CRLF), `registration_error_copy.dart` (CRLF), `registration_controller.dart`,
`lib/dev/mock_backend.dart`, `lib/core/session/session_scope.dart`, both ARBs and the three generated
`app_localizations*.dart`, `test/features/registration/registration_harness.dart` (fixture; foreign line 17),
`test/dev/mock_backend_v11_test.dart` (fixture; foreign line 46), `docs/DECISIONS.md` (D-025, D-026, the line under
D-022), `docs/DESIGN_ISSUES.md` (#133, #134), `docs/seif_fight.md` (S46, S47 rows and sections),
`04_COMPLETION_ROADMAP.md` (CW16b row note), `COMPLETION_STATE.md`. `docs/BACKEND_HANDOFF.md` is untracked (Seif's live
record; three Provenance rows, PIN/U347/U348/U351/U352 rows, the U1 row, four Change log rows).

The pre-wave copy of each of these, with its blob id, is in `seif1014_prewave/` — the baseline for separating this
wave's hunks at commit time.

## 7. Independent review (read-only, one subagent)

**Reviewer:** one Sonnet subagent, model id **`claude-sonnet-5-5`** (as recorded in its transcript), 97 tool uses,
about 1 h 56 min. **Given:** the 6,311-line diff of every edited file against its pre-wave copy plus every new
hand-written Dart file, the owner's Jobs 1–3 requirements and rules, and the quoted contract text — **not** the
builders' or checkers' reports or my conclusions (brief and packet: scratchpad `review/`).

**It independently verified:** the four contract blobs = upstream `ded6213`, 0 CR, version 3.52.0-m1, the nine
3.52 commits and the 16-since-pin count; the census (89 / 85 / 21) and the wire audit, by its own YAML parse; no test
or guard hard-codes the old pin; pre-wave copies faithful and no foreign file changed; CRLF kept; the 422 copy and
the Soon mark byte-identical to the contract and to Seif; the fail-closed logic and Riverpod-3 refresh handling (by
reading and by its own mutations in a throwaway copy); `flutter analyze` clean; the full non-golden suite **3385
passed** (`--exclude-tags=golden`); and that the ~3 px picker-failure overflow is a widget-test font artifact (it
does not occur with the bundled fonts at 412 dp, Arabic, 1.3×) — matching the AVD.
**It could not check:** a live `ls-remote` (no network), device / TalkBack / iOS, `build_runner` regeneration,
`validate.ps1` itself, and this report and Job 4 (still being written).

**Findings (6, all low) and triage:**

| # | Finding | Triage |
| --- | --- | --- |
| R1 | The Riverpod-3 "reload keeps the old value" rule for the module row is tested only on the pure helper; a screen mutation that bypasses `pickableModules` passes the suite | **Fixed** — two screen-level tests (§7.1) |
| R2 | A failed modules read is sticky for the session (no recovery until sign-out or restart) | **Owner question** (§8.3); behaviour as specified |
| R3 | A `422` cleared whatever the draft held when it landed; the pickers stay enabled during a submit, so a choice made while the request was in flight could be wiped | **Fixed** — the refused field is cleared only if it still holds the value that was sent (§7.1) |
| R4 | The Soon mark inside the 0.6 dimming is about 2.45:1 on light | **To the designer** (DESIGN_ISSUES #133, with the ratio; WCAG exempts inactive controls) |
| R5 | The selected pill is not scrolled into view when the screen is rebuilt | **Recorded** (DESIGN_ISSUES #134 item 9; provisional, waits for the frame) |
| R6 | Stale citations: `SOURCE.md` follow-up 9 line numbers; the `registration_error_copy.dart:106` "past the vendored pin (3.46.0-m1)" comment; `COMPLETION_STATE.md`'s header; the discipline test's exemption wording | `SOURCE.md` and `COMPLETION_STATE.md` **fixed**; the `:106` comment is an NNA (foreign) hunk and the discipline test is outside this wave's files — **left, listed in §8.6** |

### 7.1 The fix round (Sonnet builder + read-only Sonnet checker: PASS)

- **R3** (`school_detail_screen.dart`, CRLF kept, 675 → 701 lines): the stage and system are recorded when Start
  learning is tapped; a `422` clears the refused field only if the draft still holds the value that was sent;
  refetch, scroll and no-resubmit unchanged; the pickers are not disabled. Two new tests in
  `school_choice_unavailable_test.dart` (a different open value picked while the request is in flight survives the
  `422`); they **failed first** on the unfixed screen (`Expected: 'secondary3' Actual: <null>`, and the system twin).
  *Residual, accepted (low):* in that rare case the banner and field mark for the old value stay until the next edit.
- **R1** (`subjects_screen_modules_test.dart`): a reload in flight and a reload that throws both hide the row while
  the old value is still held, and the grid lists every subject; the row and the selection come back when the reload
  lands. Both **failed** under the reviewer's own screen mutation in a throwaway copy (`Found 1 widget with type
  "ModulePicker"`), while the other 31 tests passed under it — the gap the review named.
- Checker: no file outside the three allowed ones changed; foreign hunks intact; 21 · 33 · 811 (registration +
  catalog + guards) passed; analyze clean.

**Final gate, after the fix round** (`validate.ps1`, 18:41:30–18:46:00Z): exit 0 · format PASS · analyze 0 ·
**3432 passed / 0 failed / 0 skipped** (= 3428 + 4) · OVERALL PASS; `test/guards` 139; contract guards 22;
untracked Dart format check 102 files, 0 changed; `flutter gen-l10n` no drift; `git diff --check` clean; the same 17
start-dirty files changed (all on the allowed list), every other start-dirty file byte-identical. **BUILD.**

## 8. Questions for you
1. **«قريباً» vs «قريبًا» — DECIDED (owner, 2026-10-15):** the new mark and both new `422` strings use the app's
   existing spelling **قريبًا** (U+064B U+0627), the same as `comingSoon`. Applied in the follow-up (§11).
2. **«كل المواد»** for "All subjects" — **DECIDED (owner, 2026-10-15): confirmed.** The PROVISIONAL(copy) flag is
   removed from the ARB description and DESIGN_ISSUES #134; the PROVISIONAL(design) markers stay (§11).
3. **Modules retry — DECIDED (owner, 2026-10-15):** a failed modules read is fetched again on the Subjects Retry and
   when the connection comes back; the subjects list still never waits for or fails with it. Built in the follow-up
   (§11).
4. **Send the Job 4 reply** (§5.2) with the six `job4_path` screenshots, and the six `u1_*` screenshots for Seif's
   "both views" — your call; nothing was sent.
5. **The four 3.47 behavioural acknowledgments** to Seif (BH-B4) are still owed; they are now in the pin.
6. **Follow-ups from the delta** (`contract/SOURCE.md`): the `account_banned` copy and rule (email channel); Daily
   Tasks (stable since 3.49); the prod base URL; the stale `[3.47] … not in the pin` wording in `CLAUDE.md` and in
   BACKEND_HANDOFF's tag legend (recorded in its Change log, not rewritten); the stale exemption wording for
   `educationSystemsProvider` in `test/core/session/session_scope_discipline_test.dart:56-57`; the "past the vendored
   pin (3.46.0-m1)" comments in NNA's hunks (`registration_error_copy.dart:106`, `profile_error_copy.dart:49`) and the
   "pin eddb6ac" ARB descriptions — all in other waves' uncommitted hunks, so not edited here.

## 9. Proposed commit split (nothing staged or committed)

Order matters: every commit below needs the contract commit first (the new guard bindings read the vendored
`openapi.yaml`), and the SSG commit sits on top of uncommitted foreign layers (its School-screen and error-copy hunks
neighbour the NNA layer's `name_not_allowed` code, which they call) — so it lands after the planned
N-26 → CW02 → CW07a → CW12a → O-15 → NNA (→ CW04a) layers. Split shared files by hunk from the `seif1014_prewave/`
copies; **regenerate** the l10n Dart files and the freezed output from the committed ARB/model state rather than
splicing them (they mix keys of several uncommitted waves).

| # | Message | Paths | Foreign hunks in the same files |
| --- | --- | --- | --- |
| 1 | `chore(contract): re-vendor the API contract to ded6213 (3.52.0-m1)` | the four `contract/` files, `contract/SOURCE.md`; `docs/DECISIONS.md` D-025 + the "Superseded by D-025" line | DECISIONS.md: yes |
| 2 | `docs(seif): archive Seif's messages of 2026-10-12 and 2026-10-13` | the three `docs/SEIF_MESSAGE_*` files | none |
| 3 | `feat(registration): show the School stages and education systems the server has not opened as "Soon"` | `reference_models.dart` (+ generated), `reference_repository.dart`, `reference_providers.dart`, `reference_dropdown.dart`, `school_detail_screen.dart`, `registration_controller.dart`, `registration_error_copy.dart`, `lib/dev/mock_backend.dart` (SSG hunks), the three SSG ARB keys (+ regenerated l10n), `test/guards/rules.dart`, `rules_test.dart`, `contract_models_test.dart` (inlineBindings hunk), the four SSG test files, the three fixture edits; `docs/DECISIONS.md` D-026 | yes: screen, error copy, controller, mock, ARBs/l10n, harness, v11 test, DECISIONS |
| 4 | `feat(catalog): add the provisional University module picker to Subjects` | `catalog_module.dart` (+ generated), `modules_notifier.dart`, `module_picker.dart`, `catalog_repository.dart`, `subjects_screen.dart`, `session_scope.dart` (two lines + import), `mock_backend.dart` (modules hunk), `allSubjects` (+ regenerated l10n), `contract_models_test.dart` (moduleBindings hunk — contiguous with commit 3's, split by hand), the eight CW16b-M test files | yes: session_scope, mock, ARBs/l10n |
| 5 | `docs: record wave SEIF1014 (design issues #133 #134, questions S46 S47, roadmap, state)` | `docs/DESIGN_ISSUES.md` (#133, #134), `docs/seif_fight.md` (S46, S47), `04_COMPLETION_ROADMAP.md` (CW16b note), `COMPLETION_STATE.md` (SEIF1014 lines), `SEIF1014_PLAN.md`, this report, `seif1014_shots/`, `seif1014_prewave/` (record, if you keep pre-copies in history as earlier waves did) | yes: DESIGN_ISSUES, seif_fight, COMPLETION_STATE |

`docs/BACKEND_HANDOFF.md` stays untracked, as the prompt says.

## 10. Status and next action

**Status: PASS WITH WARNINGS.**

| Job | Result | Highest level reached |
| --- | --- | --- |
| 0 — preflight | baseline green (3193 / 0 / 0); messages archived, hashes match | BUILD / SOURCE |
| 1 — re-vendor (CV352) | `contract/` = upstream `ded6213` (3.52.0-m1), blob-proven; `SOURCE.md` delta; D-025; gate 3193 / 0 / 0 | BUILD |
| 2 — School "Soon" (SSG) | built; fail-closed; both `422`s; 99 tests (97 + 2) + guard; gate green | **AVD** (mock and a test-only variant mock) |
| 3 — module picker (CW16b-M) | built (provisional); 125 tests (123 + 2) + guard; gate green | **AVD against staging (U1)** |
| 4 — deletion path | answered: no in-app path exists; reply drafted, not sent; S46 | SOURCE + AVD (mock) |

**The warnings:**
1. Real-server "Soon" behaviour is **not exercised** (staging all-open; no launch-rules window was given).
2. The module picker and the Soon mark have **no Figma frame** (DESIGN_ISSUES #133, #134); «كل المواد» is
   provisional.
3. Not verified: a physical device, TalkBack, iOS, the quiz image's failure state, the Grade offline state on a
   device.
4. Owner questions in §8 (spelling, the Arabic string, the modules retry policy, sending the drafts, the 3.47
   acknowledgments).
5. Commit order: the SSG commit depends on the uncommitted NNA layer (§9).

**Your next action:** read §8 and answer what you want to (each is independent); then, if you are happy, give the
commit word for the split in §9 (after the earlier layers), and send Seif the Job 4 reply (§5.2) and the
"both views" screenshots (`seif1014_shots/u1_*.png`) when you choose. Nothing else from this wave is waiting.

---

## 11. Follow-up — the owner's decisions and the Figma check (owner prompt 2026-10-15)

**Status: NOT CORRECT** (by the prompt's Part D test — reasons in §11.8). Gate green; nothing staged, committed,
pushed or sent. **Pre-copies:** `seif1014_fu_prewave/` (`SHA_LIST.txt`: blob id, path, tracked/untracked, status of
every file before the follow-up touched it; `TAKEN_AT.txt`). **Models:** lead Opus 5.5 (`claude-opus-5-5`); the four
Figma analysts inherited the session model (Opus 5.5); builders and the reviewer Sonnet (`claude-sonnet-5-5`).
**Input:** `FIGMA_URL` was the placeholder, so the file came from `docs/DESIGN_ISSUES.md` line 8
(`P6044i0giD9TmdQ7C2AmLq`); `03_DESIGNER_HANDOFF.md` has no link.

### 11.1 Part A — the owner's decisions (built)

| # | Decision | What changed | Proof | Level |
| --- | --- | --- | --- | --- |
| A1 | «قريبًا» in the new keys | `registrationSoonMark`, `registrationSchoolStageNotAvailable`, `registrationEducationSystemNotAvailable` (AR) now end in U+0628 U+064B U+0627, copied from `comingSoon`; English and `comingSoon` unchanged; the tests that checked the old spelling now assert equality with `comingSoon` and that no value holds alef + fathatan | tests changed first and shown failing (3 failures quoting the old spelling), then green | BUILD; **AVD** (mock and the variant mock: `followup/a01`, `a02`, `a05`, `a08`) |
| A2 | «كل المواد» confirmed | the `@allSubjects` description and the `module_picker.dart` comment say "confirmed by the owner on 2026-10-15"; DESIGN_ISSUES #134 updated; `PROVISIONAL(design)` markers kept except where the new frames settle them (§11.2) | analyze clean | SOURCE |
| A3 | Refetch failed modules on Retry and on reconnect | `SubjectsScreen`: `_refetchFailedModules()` invalidates `modulesProvider` only when it **failed and is not already reloading**; called from the Subjects Retry (after the unchanged subjects refresh, never awaited) and from a `ref.listen` on `isOnlineProvider` that fires only on offline → online. The row is still drawn only from settled, non-empty modules, so the subjects never wait for or fail with modules | 8 tests (T1–T8): T1, T4, T5 failed first on the old screen (`Expected: <2> Actual: <1>`); T2, T6, T7 and T8 caught by mutations in throwaway copies (unconditional Retry, every-`true` listener, unconditional reconnect, the `!isLoading` half removed) | BUILD; **AVD against staging as U1** (EN `d02`→`d03`→`d04`, AR `d05`→`d06`→`d07`): offline → no row; connection back → the row returns with no tap while the subjects still show their offline view; Retry → subjects load |

Note on A3: the refetch runs while the Subjects screen is mounted (the shell keeps the Learn branch built). A student
whose subjects loaded but whose modules failed while online has no Retry control on screen; only a reconnect or
sign-out refetches modules then. This follows the decision as worded.

### 11.2 Part B — the updated Figma design against the contract

**How it was read.** The official Figma MCP (read only: `get_metadata`, `get_design_context` after loading the
figma-design-to-code guidance, `get_screenshot`; no write tool was called). Its page list shows only "Assets /
component", and the "design" page and its three sections answer with more than 1 MB, which the connector cannot
carry. Claude in Chrome first showed Figma's own "You've been logged out" dialog, so I stopped there and told you;
after you signed in, the Layers panel gave the section ids (light `310:10280`, dark `337:5267`, RTL `549:18617`, each
with Common / University / School subsections), and each flow's frame list came over the MCP. The credential-shaped
node `1240:9847` was never read (0 hits in every dump). Four read-only analysts compared the frames; I checked the key
frames myself (renders in the scratchpad).
**Completeness re-check (2026-10-15, after the owner reconnected the `figma` connector):** the same account; it
also lists only the assets page. It did return the three "Common sign in/up" subsections (light `125:2277` had failed
before; dark `337:15145`, RTL `549:28909`: login, OTP, recovery and a name-not-allowed sign-up frame — nothing for
this follow-up) and the whole **prototype page `404:21556`** (id read in the app's built-in browser as a viewer;
192 frames, all ids ≤ 440, i.e. older copies). The assets page `0:1` has no new screens. Figma variables on the new
frames are a handful of plain local colours (none for the Soon pill, the Term chip or the refusal card, no dark
mode), and no library is attached. So **no dark or Arabic version of any new frame exists anywhere in the file**,
and no variable supplies dark values.

**What the updated file has.** New frames are **light, English only**; dark and Arabic copies exist only for the older
Settings, Profile and sign-up frames. School "Soon": `1409:26374` (grade sheet), `1409:26436` (system sheet),
`1409:26495` (refusal); University year "Soon" `1409:26536`; school search `1409:26646` / `1409:26838`. Module picker:
`1411:16920`, `1411:17138`; empty-before-term `1411:10150`. Settings: `1409:8642` (School light, new; `176:1840` is
gone), `309:8452`, `337:8141`, `349:12113`, `549:21759`, `565:14612`. Profile: `1409:25524` (new), `309:7940`,
`337:7433`, `349:12919`, `549:21052`, `549:26384`. Deletion (B1): `1409:8774` (Settings row), `1409:8786`, `1409:8945`,
`1409:9047`, `1409:9157`, `1409:9259`.

**The mismatches** (one table; "Fixed" = changed in the app now, with tests):

| # | Frame | What the design shows | What the contract provides | Who wins | Action |
| --- | --- | --- | --- | --- | --- |
| **School registration** | | | | | |
| R1 | `1409:26374`, `1409:26436` | "Soon" mark at the row's end, full strength, SemiBold 12, while the row greys | `listSchoolStages` / `listEducationSystems.status`: show `soon` as "Soon", visible, not selectable | design (contract allows) | **Fixed:** mark outside the dimming, `AppType.buttonSmall` (12/w600), `hint` colour |
| R2 | same | Bottom sheet: title, hint line, radio cards, lavender selected card, grey Soon card, lavender Soon pill | Presentation not specified | design, but not buildable now | **Logged #133:** title/hint English only; 17 Medium off the type scale; 6 colours not tokens, no dark; the shared dropdown serves every registration picker (owner's call) |
| R3 | `1409:26374` | Grade names "Preparatory 1…"; the form frames say "Grade 12"; Arabic base «الاول الاعدادى» | No names on the wire; the app localises them | app's approved copy | **Logged #133** (frames disagree; one language each) |
| R4 | `1409:26374` | Grades in the fixed order prep1…secondary3 | Fixed order | match | none |
| R5 | `1409:26436` | Systems: National (Arabic), National (Languages), American, IGCSE, IB | Names are the server's `nameEn`/`nameAr`; no display order promised | contract (server data) | **Reported** to the designer; no app change |
| R6 | `1409:26495` | Refusal as a floating pink card with shadow, above the button | Copy only (`error-codes.md` suggested copy) | design, not buildable now | **Logged #133:** colours not tokens, 15/21 off the scale, no dark; shared banner |
| R7 | `1409:26495` | Refusal copy "Level Up isn’t open for this grade yet. Coming soon!" | Same (EN suggested copy) | match | none (AR uses «قريبًا», owner decision) |
| R8 | `1409:26495` | Refused grade stays selected; no field marked | `422` has no field map; a refused choice is `soon` = not selectable; fix and resubmit with the same token | contract (D-026) | **Kept the app's behaviour** (clear + mark + scroll); **logged #133** |
| R9 | (none) | No frame for `education_system_not_available`, no loading / error / offline / disabled-button states, no dark, no Arabic | Both 422s; `429` on the reads | needs designer | **Logged #133** (the app has all of these states) |
| R10 | `1409:26536` | University years 2–5 marked "Soon" | `listUniversities` `years[].status` | contract allows; copy approved | **Not built — owner call** (outside the screens this follow-up names, and the SEIF1014 prompt kept the University picker unchanged); a one-line `rowMarks` change would do it |
| **Module picker (Subjects, University)** | | | | | |
| M1 | `1411:16920`, `1411:17138` | Pill row between search and grid, 25 above and below | `listModules`: no placement rule; "All subjects" must be permanent | design | **Fixed:** gaps 25 / 25 at text scale 1.0 (were 31.5 / 18.5; about 23 / 23 at 1.3); AVD-measured 25.1 / 25.1 dp |
| M2 | same | Selected `#384F47` + white; idle white + 1 px `#DEDEDE`, no shadow; 14/w600; 14/8 padding; 35 tall | — | design (light) | **Fixed (light):** five `modulePill*` token names (no new colour values), `AppType.labelLarge` in both states, 35 drawn / 48 target (the frame draws selected 33, idle 35; equalised); dark keeps the earlier look (no dark frame). AVD-measured `#384F47`, `#FFFFFF`, `#DEDEDE`, 35 dp |
| M3 | same | "All subjects" first, selected by default; modules in server order | Same | match | none (AR «كل المواد» confirmed) |
| M4 | `1411:17138` | A module view is a subset of the cards, no header or count | Navigation only | match | none (S47 still open on `subjectIds` order) |
| M5 | `1411:16920` etc. | "Term 1 / Term 2" chip on every card | `termNumber`; "render the term label client-side (localized AR/EN)" | contract allows, copy missing | **Logged #135:** no Arabic label, colour not a token, no dark |
| M6 | `1411:16920` | Term 1 in the start column, Term 2 in the end column | "Group and order on `termNumber`"; app keeps server order | needs designer | **Logged #135** (rule or sample?) |
| M7 | `1411:10150` | Empty card "No subjects yet" + "…when your term opens. We'll let you know.", book icon, no search | `[]` is normal; an unreleased term is absent, not flagged; no term notification kind | contract | **Logged #135 + S49;** the app keeps "No subjects yet" (the line is English-only and promises an unbacked notice; the icon is not in assets) |
| M8 | (none) | No dark / Arabic picker, no long name, no picker loading / error | — | needs designer | **Logged #134** |
| **Settings / Profile (DG-33, DG-57, DG-58)** | | | | | |
| P1 | all six Settings | No Notification Preferences block | No preference storage (`updateMyProfile` fields; BH-E12); categories `system`, `announcements`, `support` only | both | **Fixed:** block, its 3 keys and 2 back-light tokens removed (also the last Promotions toggle, DG-57) |
| P2 | `1409:8705` / `1409:24821` | "Show me on leaderboards" / «أظهرني في لوحة المتصدرين» | `leaderboardVisible` | design (both languages given) | **Fixed:** EN label; AR already matched |
| P3 | `1409:8769` / `1409:24826` | "Hide my score" (EN) vs «إخفاء نقاطي» ("points", AR) | `scoreHidden`; glossary "points" | app's approved copy | **Logged #136** (the frame's languages disagree) |
| P4 | `1409:8770`, `1409:24806` | OFF switch: track `#D1D1D1` light / `#5C5C5C` dark | — | design | **Fixed:** `settingsToggleOffTrack` (#107); AVD pixels `#D1D1D1` light, `#5C5C5C` dark |
| P5 | `549:21759`, `565:14612` | Arabic Rank block drawn | `leaderboardVisible`, `scoreHidden` | match | **Closed #111** |
| P6 | University Profile `309:7940`, `349:12919`, `549:26384` | No "Go to University" row | `transferToUniversity` → `409 track_transfer_not_allowed` for University; "never offer the transfer again" | both | **Fixed:** row shown to School students only |
| P7 | every Profile frame | "Upgrade to premium" row | Purchase-silent (adr-049) | contract | app already omits it; **logged #136** (DG-58 P0 not done) |
| P8 | Profile frames | "Level 7 · Hero"; Solved Questions / Badges / Level stat cards; Subscription card | `level` is an integer, no tier; stats owner-ruled (#101); entitlements held (H-04) | contract / owner | **Logged #136**, reported |
| P9 | Settings frames | "Save Change" button; three unlabelled Mode swatches; dark orphan back-light; no Rank help lines | Saves are immediate; theme is client-only | needs designer / owner | **Logged #136** (#48, #45; help lines = owner) |
| P10 | Arabic Profile frames | Arabic copy differs from the approved copy and is misspelt; University Arabic title in English | — | app's approved copy | **Logged #136** |
| **Account deletion (DG-01/02, CW05 — report only)** | | | | | |
| D1 | `1409:8774` | "Account → Delete account" row in Settings | `requestAccountDeletion` stable | both | nothing built (CW05) |
| D2 | `1409:8786` | Confirm paragraph | = the contract's suggested English, word for word | match | nothing built; Arabic only in the contract (awaiting Ahmed) |
| D3 | `1409:8786` | "permanent" + "You have 30 days to change your mind" | Both stated | needs answer | **S46** (already open) |
| D4 | `1409:8945`, `1409:9047` | "will be deleted on 13 Nov 2026" / "before 13 Nov 2026" | `effectiveAt` is "no earlier than", up to ~24 h later; `404` only once erasure begins | needs backend | **S48 (1)**, #137 ("on or after") |
| D5 | `1409:9157` | "Everything is just as you left it." | Not promised; push token deleted at request | needs backend | **S48 (2)** |
| D6 | `1409:9259` | "This account can't be restored" | `404 no_pending_deletion` also means "nothing pending" | needs backend | **S48 (3)** |
| D7 | all B1 | English and light only; no submitting / offline / error / `409` / unchecked states; type sizes off the scale; 4 colours not tokens | — | needs designer | **Logged #137** |

**Built in Part B** (two Sonnet builders, tests first and shown failing — e.g. the selected pill `Actual: … 0.6824 …`
(purple) for `Expected: … 0.2196 …`, the drawn pill `Actual: <40.0>` for 35, "Found 1 widget with text 'Notification
Preferences'", 9 Profile rows for a University student where 8 were expected):
- **School "Soon" mark** (`reference_dropdown.dart`): only the label and leading glyph keep the row's dimming; the
  mark is outside it, in `AppType.buttonSmall` (12/w600), `hint` colour; the spoken name is unchanged.
- **Module picker** (`module_picker.dart`, `subjects_screen.dart`, `app_colors.dart`): five `modulePill*` tokens (light
  from the frames, every value already in the palette; dark = the earlier look), `AppType.labelLarge` in both states,
  padding 14/8, 35 drawn in a 48 tap box, the frame's 25 / 25 gaps; settled `PROVISIONAL(design)` markers replaced by
  frame citations; still provisional: dark, long names, an empty module, search inside a module, the row over the
  subjects' loading/error view.
- **Settings** (`settings_screen.dart`, both ARBs): Notification Preferences removed (and with it the last Promotions
  toggle, DG-57) with its three keys; "Show me on leaderboards"; the OFF track `#D1D1D1` / `#5C5C5C`
  (`app_colors.dart`). The two back-light tokens of the removed block stay in `app_elevation.dart` because a golden
  test that belongs to another wave still uses one (follow-up below).
- **Profile** (`profile_screen.dart`): "Go to University" for School students only.
- **Logged, not built:** DESIGN_ISSUES #133 and #134 updated, new **#135** (Term chip, B9 empty card), **#136**
  (Settings / Profile), **#137** (deletion); #107 (OFF drawn) and #111 (Arabic Rank) closed; #46 and S27 answered;
  `seif_fight.md` **S48** (deletion edges) and **S49** (term-release notice) filed, **S28** parked; D-026 note;
  `03_DESIGNER_HANDOFF.md` dated appendix. **Deletion (CW05) — nothing built.**

### 11.3 Part C — verification

| Check | Result | Level |
| --- | --- | --- |
| `validate.ps1`, after Parts A and B (23:08:09–23:12:37Z) | exit 0 · format PASS · analyze 0 · **3468 passed / 0 failed / 0 skipped** (3432 + 36) · OVERALL PASS | BUILD |
| `validate.ps1`, final, after the review fixes | exit 0 · format PASS · analyze 0 · **3469 passed / 0 failed / 0 skipped** (+1, T8) · OVERALL PASS (23:38:19–23:41:35Z); the untracked Dart files edited here, format check: 0 changed | BUILD |
| ARB parity | 292 = 292 message keys (295 − 3 removed), no duplicates | SOURCE |
| Pre-copies, foreign hunks, line endings | every edited file is in `SHA_LIST.txt`; the reviewer found all other start-dirty files byte-identical and no line-ending change (both CRLF files untouched) | SOURCE |
| Screens, EN + AR, Pixel_8 AVD (API 36), text scale 1.0 — `seif1014_shots/followup/` (27 PNGs) | `a01`–`a04` School pickers (mock, launch rule): marks at full strength outside the dimmed label, «قريبًا»; `a05`–`a08` both refusals (a test-only variant mock built in a throwaway copy; the repo was not changed): «… قريبًا!», field cleared and marked; `b01`, `b05` School Profile with "Go to University"; `b06`, `b08` University Profile without it; `b02`, `b03`, `b07` Settings without Notification Preferences, "Show me on leaderboards", OFF pixels `#D1D1D1`; `b04` dark OFF pixels `#5C5C5C`; `c01`–`c04` module picker (mock University): pixels `#384F47` / `#FFFFFF` / `#DEDEDE`, 35 dp pill, 25.1 / 25.1 dp gaps; `d01`–`d07` staging as U1 (one sign-in; the number and the published code were typed by a script and never printed or written): the reconnect refetch in both languages | **AVD** (mock, variant mock, staging) |
| Not verified | a physical device, TalkBack, iOS, the dark and Arabic module picker against a frame (none exists), the Retry-only modules refetch on a device (an online modules failure cannot be arranged on staging; widget-tested) | — |

### 11.4 Independent review (one read-only Sonnet subagent, `claude-sonnet-5-5`)

Given the 30-file diff against the pre-copies, the owner's rules and the frame ids — not the analysts' or builders'
reports. It re-read the key frames itself, ran the suite in a throwaway copy (3451 passed; 9 guard failures were
missing `android/` / `.github/` paths in its copy, not regressions) and found 13 items, none high:

| # | Finding | Triage |
| --- | --- | --- |
| F1 | The `!isLoading` half of the refetch guard was untested | **Fixed** — T8 (fails `Expected: <2> Actual: <3>` without it) |
| F2 | University year "Soon" mark (`1409:26536`) is app-fixable | **Owner call** (§11.7, question 1) |
| F3 | References to a §11 that did not exist yet | **Fixed** — this section |
| F4 | The two Rank help lines are not drawn | **Owner call** (question 2; BUG-017) |
| F5 | "Hide my score" (EN frame) vs «إخفاء نقاطي» (AR frame) | **Owner call** (question 3); app keeps "points" |
| F6 | In dark the full-strength mark is brighter than the dimmed label | **Recorded** (#133) |
| F7 | "35 tall in both states" was attributed to the frames (selected is 33) | **Fixed** — docs say the app equalises |
| F8 | The 25 gaps are about 23 at text scale 1.3 | **Fixed** — documented |
| F9 | Dead tokens / golden for the removed block; stale `176:1840` citations | **Follow-up** (below) |
| F10 | Stale statements (#46, S27, #134 item 8, D-026 body) | **Fixed** (notes added) |
| F11 | A Profile comment said track switching has no endpoint | **Fixed** (comment) |
| F12 | Arabic absence list missed three labels | **Fixed** (test) |
| F13 | OFF-track contrast 1.48:1 / 2.32:1 (below 3:1, as before) | **Recorded** (#107) |

**Follow-ups left (no owner decision needed, outside this follow-up's files):** retire
`notificationPreferencesBacklightSchool/University` together with the `edit5_surfaces_golden_test.dart` case that
still draws a Notification section; the `_showGoToUni` doc in `profile_screen.dart` still cites S31 "no track-switch
endpoint" (`transferToUniversity` is stable — CW14); stale `176:1840` citations in Settings comments.

### 11.5 Still open / could not check

- The designer's new frames are English and light only — confirmed across the whole file (all three pages) on
  2026-10-15: there are no dark or Arabic versions of the Soon sheets, the module picker, the Term chip, the empty card
  or any deletion frame to compare.
- The B12 sheet presentation, the Soon pill and card colours, the refusal card, the Term chip and the B9 card are not
  built: no tokens, no dark values, English-only copy, or (B9) an icon export that needs your OK.
- Real-server "Soon" behaviour is still not exercised (staging is all-open).
- Deletion: CW05 not authorised; S46 and S48 wait on Seif.

### 11.6 Drafts — NOT SENT

**To the designer:**

> Hi! Thanks for the new frames. We've built what we could and need a few things from you:
> 1. **Dark and Arabic frames** for everything new: the grade and education-system sheets, the module picker, the
>    Term chip, the "before your term opens" card, and all the account-deletion screens.
> 2. **School registration:** the refusal frame keeps "Grade 12" selected, but a refused grade is "Soon" and can't
>    stay selected — please draw the field cleared and marked. Please also draw the education-system refusal, the
>    loading, error and offline states of the pickers, and decide the grade names ("Preparatory 1" in the sheet,
>    "Grade 12" on the form). The sheet title and hint need Arabic text.
> 3. **Subjects:** the Arabic for "Term 1 / Term 2". Is the "Term 1 left, Term 2 right" order a rule? On the empty
>    card, the app can't tell that a term hasn't opened, and there is no "we'll let you know" message yet — please
>    word it for any empty list.
> 4. **Settings / Profile:** "Hide my score" in English but «إخفاء نقاطي» (points) in Arabic — we use "points". The
>    "Upgrade to premium" row is still on every Profile frame and must go. "Hero" next to the level doesn't exist.
>    There's an extra back-light shape under Rank on the dark frames.
> 5. **Deletion:** say "on or after" for dates (deletion can run up to a day later); please also draw the unchecked
>    checkbox and the submitting, offline and error states.

**To Seif:**

> Hi Seif, three questions from the new deletion designs (S48) and one about Subjects (S49):
> 1. Between `effectiveAt` and the moment the daily job starts erasure, does `DELETE /me/deletion-request` still
>    return `204`?
> 2. When a student cancels a deletion, is everything restored? The design says "Everything is just as you left it."
> 3. Once erasure has started, what do `GET /me` and sign-in return, so the app can tell "can't be restored" from
>    "nothing pending" after a `404`?
> 4. Is a notice planned when a University term opens (inbox item or push)? The empty Subjects design says "We'll
>    let you know."
> Thanks!

### 11.7 Questions for you

1. **DECIDED 2026-10-15 — built (§12.1):** University years get the School pickers' mark. ~~**University year "Soon"
   mark** (`1409:26536`): build it now (one `rowMarks` change on the University picker plus tests), or keep the
   University picker unchanged as SEIF1014 did?~~
2. **DECIDED 2026-10-15 — done (§12.1):** both dropped, with their keys; BUG-017 fixed by removal. ~~**Rank help
   lines:** the frames draw none. Drop both (and retire BUG-017's wrong line), or keep them with corrected copy?~~
3. **DECIDED 2026-10-15:** "points" kept; nothing changed in the app. ~~**"Hide my score" or "Hide my points"?** The
   frame's two languages disagree; the app keeps "points".~~
4. **DECIDED 2026-10-15 — done (§12.1):** exported to `assets/icons/subjects_empty_book.svg`, not wired (the card is
   not built). ~~**B9 empty card:** may the book icon be exported from Figma into `assets/`? (The card's body text
   still waits for the designer and S49.)~~
5. Still open from §8: sending the Job 4 reply and the U1 screenshots; the four 3.47 acknowledgments.

**Commit split addendum** (to §9; nothing staged): the Arabic spelling and the Soon-mark change join commit 3 (SSG);
the modules retry, the restyle and the five `modulePill*` tokens join commit 4 (CW16b-M); a new commit 4b
`feat(settings,profile): match the 2026-10-15 Settings and Profile frames` (Notification Preferences removed with its
three keys, the Rank label, the OFF track colour, "Go to University" for School only, the Settings comments); the
docs join commit 5. Split shared files by hunk from `seif1014_fu_prewave/`; regenerate the l10n files.

### 11.8 Status

**NOT CORRECT.** The gate is green and every mismatch the app could fix under your rules without inventing was
fixed, but: (1) several compared screens still differ from the design where the contract would allow it — the School
picker sheets, the Soon pill colours, the refusal card, the Term chip and the B9 card — because the design has no
tokens, no dark values or no Arabic copy for them, or (B9) needs your OK to export an asset; (2) three items the app
could change wait for your call (the University year mark, the Rank help lines, score vs points); (3) dark and
Arabic could not be checked for any new frame because none exists.

---

## 12. Second follow-up — the owner's decisions on §11.7 (owner prompt 2026-10-15)

**Status: NOT CORRECT** (same rule as §11.8 — reason in §12.5). Gate green; nothing staged, committed, pushed or sent;
CW05 not started. **Pre-copies:** `seif1014_fu_prewave/followup2/` (`SHA_LIST.txt`: blob id, path, tracked/untracked,
status of every file before this follow-up touched it; `TAKEN_AT.txt`); the first follow-up's copies one level up are
unchanged. **Model:** Opus 5.5 (`claude-opus-5-5`), no subagents.

### 12.1 The four decisions

| # | Decision | What changed | Proof | Level |
| --- | --- | --- | --- | --- |
| 1 | University years get the "Soon" mark (`1409:26536`) | `university_detail_screen.dart`: the year picker passes `rowMarks` — `registrationSoonMark` on every year whose status is exactly `soon`. The same key («قريبًا»), `AppType.buttonSmall` in `hint`, the same row treatment (label dimmed, mark at full strength at the end edge, spoken "<year>, Soon"). `enabled` is unchanged: only `active` is selectable; an unknown or empty status is disabled with no mark; a year with no status does not parse. No new string. Comments in `reference_dropdown.dart` cite the frame | New `university_year_soon_test.dart`, 13 tests, English and Arabic (RTL) at text scale 1.3: the 3 mark tests × 2 languages **failed first** on the old screen (`Found 0 widgets with text "Soon"` / `"قريبًا"`; `Found 0 widgets with a semantics label matching`); the selection pins passed before and after. Mutations in a throwaway copy: marking every non-`active` year fails "an unknown or empty status is disabled with NO mark" (en, ar); making `soon` selectable fails 6 (in both languages: "only `active` can be chosen", the dimmed-and-marked test, and "tapping a soon year changes nothing"). The existing University tests pass unchanged (`university_detail_screen_test.dart`); one School-file test that asserted "the Soon mark is the School form's alone" now expects the mark (it encoded the old rule). DESIGN_ISSUES #133: "the two pickers now agree" | BUILD; **AVD** (`followup2/` `u01`–`u04`) |
| 2 | Drop the two Rank help lines | `settings_screen.dart`: no `help:` on either switch; `settings_rows.dart`: the help slot is removed from `SettingsSwitchRow` (no other caller); `settingsLeaderboardVisibleHelp` and `settingsScoreHiddenHelp` (and the one `@` block) removed from both ARBs, l10n regenerated. The switches are unchanged. BUG-017 marked fixed by removal; #136, S27 note, roadmap line updated | 4 new tests failed first on the old code: "no help line under either switch" EN/AR (`Found 1 widget with text "Turn this off and you won't be listed at…"` / the Arabic line) and the Rank row test EN/AR (first form: `Actual: <72.0>` for 52; final form in a throwaway copy with the old Settings files: `Found 2 widgets with type "Text"` in the row). Now each Rank row is its label + 14 + 14, and the frame's 52 in English (Arabic is 53 in the test fonts: its label line is 1 dp taller, so 52 is held in English only). No test checked the help lines' text, so none had to be removed | BUILD; **AVD** (`s01`–`s04`) |
| 3 | Keep "points", not "score" | Nothing in the app. Recorded as decided: #136, `03_DESIGNER_HANDOFF.md`, the `_RankSection` doc; one test line pins it (`find.text('Hide my score')` finds nothing) | — | SOURCE |
| 4 | Export the B9 book icon | Node found for certain: `1411:10344` `icon/book`, the only icon in card `1411:10343` of frame `1411:10150` (§11.2). Read-only `download_assets` (official `figma` MCP; the whole-node export was unusable — it carried the parent sections' backgrounds — so the `svgAssets` vector was used). Saved byte-for-byte with `cp` as `assets/icons/subjects_empty_book.svg` (64 x 64 viewBox, 838 bytes, three stroked paths, stroke `#AE87E7` = `Brand.purplePrimary`; sha256 `7dc1cec5…af01`; git blob `e774184b…`). Manifest row in `docs/ASSET_MANIFEST.md` (format, size, the licence note: the file names no icon set, origin unknown beyond the designer's file — ask before release). **The empty card was not built** (it was blocked on this icon and on English-only copy, #135), so **the card was not built now and the asset is not wired**: the Subjects empty state is still the shared "No subjects yet" message | In a throwaway copy: the file is in the asset bundle and `SvgPicture.asset` draws it at 64 x 64 with no exception; `assets/icons/` is already declared in `pubspec.yaml`; no guard requires an asset to be used | BUILD (throwaway copy); **ARTEFACT** (inside the mock APK as `assets/flutter_assets/assets/icons/subjects_empty_book.svg`, same sha256) |

### 12.2 Verification

| Check | Result | Level |
| --- | --- | --- |
| `validate.ps1` (07:39:08–07:45:46Z) | exit 0 · format PASS · analyze 0 issues · **3486 passed / 0 failed / 0 skipped** (3469 + 17: the 13 University tests and the 4 Rank tests; no test was removed — none checked the help lines' text) · OVERALL PASS | BUILD |
| ARB parity | 290 = 290 message keys (292 − 2), no duplicate keys in either file | SOURCE |
| Untracked Dart files (the format step reads `git ls-files`) | all 103 checked with `dart format --set-exit-if-changed`: 0 changed (includes the new test file) | BUILD |
| Line endings | `university_detail_screen.dart` stays all-CRLF (407 lines, patched by a CRLF-aware script); every other edited file stays LF | SOURCE |
| Pre-copies; phone numbers, tokens, bodies | all 22 files changed since the first pre-copy (07:21:23Z) are in `followup2/SHA_LIST.txt`, and every listed file did change; a scan of every added line finds no phone number except the new test's `parentPhone` argument, which reuses the registration tests' existing fake fixture (the N-26 replacement, an impossible 11-digit number, already used 29 times there); no token, response body or staging code anywhere | SOURCE |
| Screens, Pixel_8 AVD (API 36, 420 dpi), mock build, text scale 1.0 — `seif1014_shots/followup2/` (4 PNGs) | `u01` Arabic and `u02` English: the Academic Year picker (Cairo University → Faculty of Human Medicine; the mock serves years 1–3 `active`, 4–5 `soon`): years 4 and 5 dimmed and marked «قريبًا» / "Soon" at the end edge (left in Arabic, right in English), their nodes not clickable and spoken "Year 4, Soon" / «السنة 4, قريبًا»; pixels: the mark `#696969` (the `hint` colour at full strength), a Soon year's label `#6D6D6D` (dimmed), an open year's label `#0E0E0E`; tapping year 4 left the menu open with nothing selected. `s01` English and `s02` Arabic: Settings with no help line under either Rank switch, "Hide my points" / «إخفاء نقاطي»; the rows are 136–137 px (≈ 52 dp) in English and 147 px (≈ 56 dp) in Arabic, where the real Arabic font's line is taller. The installed APK was first hash-checked against the mock build (see the incident below) | **AVD** |
| Not verified | a physical device, TalkBack, iOS; the University mark against a real server's `soon` year (the mock serves them; staging is all-open); the icon on a screen (not wired) | — |

**Incident — a few requests reached staging (reported to you).** On the freshly booted emulator `adb install -r` of
the new mock APK failed without an error, so the app still installed there was the **staging** build from §11's U1
check, still signed in as U1. Opening it showed Home and then Profile (two read-only screens; Profile showed its
error state). I cleared the app's data on the emulator (`pm clear`, which also removed that stored U1 session) and,
believing it was the mock, started a sign-in with a made-up 10-digit number: that sent **one OTP request** and **two
verify attempts with a made-up code** to staging, which answered "wrong code" (`otp_invalid`). The number is a
normal-length Egyptian mobile number, **not** one of staging's reserved test numbers (for which the contract says no
SMS is ever sent); nothing in the contract or `BACKEND_HANDOFF.md` says whether staging sends an SMS to any other
number, so I cannot rule out that a code was texted to whoever holds it. The number is not written here. I then
uninstalled the staging build, installed the mock, and proved the installed APK identical to the mock build by sha256
before typing anything again; every screenshot above is from the mock. Lesson recorded: check the install (and the
installed APK's hash) before typing on a device.

### 12.3 Files (this follow-up)

`lib/features/registration/screens/university_detail_screen.dart`, `lib/features/registration/widgets/reference_dropdown.dart`
(comments), `lib/features/settings/screens/settings_screen.dart`, `lib/features/settings/widgets/settings_rows.dart`,
`lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb` and the three generated `app_localizations*.dart`;
`test/features/registration/university_year_soon_test.dart` (new), `test/features/registration/school_soon_pickers_test.dart`,
`test/features/settings/settings_frame_test.dart`, `test/features/settings/settings_screen_test.dart`;
`assets/icons/subjects_empty_book.svg` (new); `docs/ASSET_MANIFEST.md`, `docs/DESIGN_ISSUES.md` (#133, #135, #136 and
the S27-era note), `docs/KNOWN_BUGS.md` (BUG-017), `docs/seif_fight.md` (S27 note), `03_DESIGNER_HANDOFF.md`,
`04_COMPLETION_ROADMAP.md`, this report, `COMPLETION_STATE.md`.

**Small follow-up, no owner decision needed:** the Rank loading placeholder `_SectionLoading` is 128 tall and its
comment says "the height of the two rows it stands in for". It was already not (about 144 with the help lines, since
Wave 21); now the rows are 52 + 52, so arriving data moves the sections below up by about 24 instead of down. Left
as it was: it is outside the four decisions.

### 12.4 Commit split addendum (to §9 and §11.7; nothing staged)

- The University year mark (`university_detail_screen.dart`, the `reference_dropdown.dart` comments, the new test file,
  the School test's flipped assertion) joins **commit 3** (SSG) — it is the same mark.
- The Rank help lines (both ARBs and the regenerated l10n, `settings_screen.dart`, `settings_rows.dart`, the two
  Settings test files) join **commit 4b** (`feat(settings,profile): …`).
- `assets/icons/subjects_empty_book.svg` and its `ASSET_MANIFEST.md` row: a new **commit 4c**
  `chore(assets): add the B9 empty-card book icon (not wired)`, or with 4 (CW16b-M) if you prefer one Subjects commit.
- `DESIGN_ISSUES.md`, `KNOWN_BUGS.md`, `seif_fight.md`, `03_DESIGNER_HANDOFF.md`, `04_COMPLETION_ROADMAP.md`, this
  report and `COMPLETION_STATE.md` join **commit 5** (docs).
- Split shared files by hunk from `seif1014_fu_prewave/followup2/` (this follow-up) and `seif1014_fu_prewave/` (the
  first); regenerate the l10n files rather than splicing them.

### 12.5 Status

**NOT CORRECT.** The four decisions are done and the gate is green, but the §11.8 test still fails on what only the
designer can supply: the new frames exist in light English only, so the School picker sheets, the Soon pill colours,
the refusal card, the Term chip, the B9 card (now with its icon in the repo) and every new frame's dark and Arabic
versions still cannot be matched. Nothing else is waiting on you from §11.7 except item 5 (sending the drafts, the
Job 4 reply and the 3.47 acknowledgments), which this prompt did not change.
