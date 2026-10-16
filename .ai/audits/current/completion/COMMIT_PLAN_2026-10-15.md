# Commit plan — the 2026-10-15 git handoff (SEIF1014 + follow-ups, CW02, CW07a, CW12a, O-15, O-14, NNA/O-17, CW04a, N-26)

**Status: APPROVED, run after PROV1015 reported.** The owner answered every question on 2026-10-15 (§7) and
chose to wait for the PROV1015 session, then commit this plan from the saved bytes, leaving PROV1015's edits
uncommitted on top (Q4 (i)). Part 1 was done first: `main` was fast-forwarded `e71e9a1` → `b227f61` and pushed
(plain push, no force). `main` does not move again in this handoff.

The plan has **18 commits**. L8 (the test phone-number swap) is held out under the owner's Q1d rule (§5).

## 1. How the commits are built

- **Earlier waves are replayed from the validated layers on `cld`.** On 2026-10-11/13 the dirty tree was split into
  gated layers and pushed as `origin/cld` (`9c2b370` … `8c2cff3`, each `validate.ps1` PASS on its own tree). A
  read-only lineage check on 2026-10-15 proved the working tree was exactly those layers plus SEIF1014:
  - 170 dirty paths equal `8c2cff3`'s blob;
  - 60 differ, and every one is listed in a SEIF1014 `SHA_LIST.txt` whose pre-copy blob equals `8c2cff3`'s
    (0 mismatches);
  - 333 are new untracked paths;
  - 0 unexplained drift.
- **The contract goes first**, as the handoff says. The rebuilt layers differ from their `cld` commits only by:
  - the 3.52 contract;
  - D-025 in `docs/DECISIONS.md`;
  - `.ai/audits/current/test-results.md` held at HEAD;
  - `docs/BACKEND_HANDOFF.md` and `docs/SEIF_REPLY_2026-10-09.md` left out (Q1b);
  - from L9 on, the six test files L8 would have changed (Q1d).

  The dry run checks that, layer by layer.
- **SEIF1014 is split by hunk** against `8c2cff3`. Hunks come from `git diff -U0 8c2cff3 -- <path>`. Five read-only
  classifiers assigned them, and five adversarial verifiers re-checked the assignment (workflow `wf_5f23aa41-e6a`).
  - Shared files are built as base + that commit's hunks.
  - Each file with every hunk applied equals the saved working-tree bytes.
  - The l10n Dart files are **regenerated** with `flutter gen-l10n` in a scratch project for each ARB state, never
    spliced. Regenerating from the final ARBs reproduces the repo's three files exactly.
- **Every commit is built from saved bytes, never from the working tree.** PROV1015 started editing 17 of this
  plan's paths after the plan was frozen. So:
  - the working-tree state of every path was saved byte for byte to the session scratchpad
    (`snapshot_2026-10-15/`, 242 files) before PROV1015's first edit. PROV1015's own pre-copies
    (`prov1015_prewave/`) match it for all 76 paths it may touch;
  - each commit is assembled in a **temporary index** (`GIT_INDEX_FILE`), from blobs already in the object store
    (`cld` layers, HEAD) or written with `git hash-object -w --path` from the saved bytes and checked against the
    dry run's blob id;
  - the temporary index's tree must equal the dry run's tree, path for path, before the commit, and HEAD's tree
    must equal it after;
  - after each commit the repository's own index is set to the new HEAD for the changed paths (committed blobs,
    `update-index --cacheinfo`), so nothing is ever staged from the working tree and `git diff --cached` stays
    empty. No stash, reset, renormalise or `autocrlf` change.
- **Dry run (v2, frozen sources): ALL CHECKS PASS.** 18 commits. The final tree equals the saved bytes for every
  committed path, except the six L8 files (pre-L8 text) and this file. The 322 excluded paths never change. No
  commit is empty. Every rebuilt layer equals its `cld` tree except for the declared deviations. Scripts and
  outputs are in the session scratchpad (`builder2.py`, `plan_manifest.py`, `construct_seif.py`,
  `construct_decisions.py`, `construct_q1d.py`, `execute2.py`).
- **Rehearsal.** The whole series was first run end to end in a scratch clone of the repository, with the same
  executor, hook and messages. Its trees are the ones gated in §3.
- **Hooks.** `core.hooksPath` is unset and `.git/hooks` holds only samples, so no hook runs on its own. Changing the
  config is not authorised; the owner approved running the hook by hand. Before each `git commit`,
  `sh .githooks/pre-commit` runs with `GIT_INDEX_FILE` set to the temporary index and `GIT_WORK_TREE` set to a
  scratch checkout that holds exactly that commit's tree. The hook formats and analyses working-tree files, and the
  repository's working tree holds PROV1015's edits and the final, not the intermediate, state. A failure stops
  the run.

## 2. The commits, in order

"Recorded gate" is the `validate.ps1` result already recorded for the same files. For layers L1–S that run was on
`cld`, with the contract at `eddb6ac`. Rows marked *scratch gate* were run on 2026-10-15 on the exact rebuilt tree,
in a copy outside the repo.

| # | Id | Subject | Files | Source | Recorded gate |
| --- | --- | --- | --- | --- | --- |
| 1 | C1 | `chore(contract): re-vendor the API contract to ded6213 (3.52.0-m1)` | 6 | the four `contract/` files and `SOURCE.md`; `DECISIONS.md` = HEAD + D-025 + the "Superseded by D-025" line | SEIF1014 Job 1: 3193/0/0 on the full tree; *scratch gate: see §3* |
| 2 | L1 | `fix(privacy): replace the real phone-number sample with a pattern (N-26)` | 28 | `9c2b370` minus `test-results.md` | 2082/0/0 |
| 3 | L2a | `test(network): pin the contract's unknown-outcome rules (CW02)` | 3 | the three `test/core/network/*_test.dart` from `cc1ed77` (CW02 §9 split (2)) | part of 2225/0/0 |
| 4 | L2b | `feat(auth): banned notice, route error page, return target (CW02)` | 28 | rest of `cc1ed77` | 2225/0/0 |
| 5 | L3 | `feat(notifications): inbox opened from the Home bell (CW07a)` | 33 | `07199c6` | 2453/0/0 |
| 6 | L4 | `feat(support): ticket list, create and thread, text only (CW12a)` | 48 | `31ee81a` | 2933/0/0 |
| 7 | L5 | `fix(a11y): 48 dp back-chip target, titled bars wrap at large text (O-15)` | 17 | `dcd9605` | 2963/0/0 |
| 8 | L6 | `feat(support): apply the approved O-14 copy, status pills and Send label` | 14 | `1866ac0` (deletes `support_closed_pill.dart`) | 3025/0/0 |
| 9 | L7 | `feat(profile): handle name_not_allowed ahead of the pin (NNA, O-17)` | 14 | `f6dd726` | 3111/0/0 |
| — | ~~L8~~ | `test(privacy): replace the remaining real-looking test phone numbers` | (6) | **held out** (Q1d, §5) | — |
| 10 | L9 | `feat(legal): in-app Terms and Privacy viewer, Login links (CW04a)` | 21 | `eb86ba2` (**O-16 still PENDING**, Q3) | 3193/0/0 |
| 11 | L10 | `docs: record the CW02-CW12a, NNA and CW04a waves and their findings` | 17 | `5536470` | 3193/0/0 |
| 12 | S | `docs: point the read order at the backend handoff digest` | 9 | `8c2cff3` minus `BACKEND_HANDOFF.md` and `SEIF_REPLY_2026-10-09.md`; `DECISIONS.md` = its edit + D-025 | 3193/0/0 |
| 13 | C2 | `docs(seif): archive Seif's messages of 2026-10-12 and 2026-10-13` | 3 | `docs/SEIF_MESSAGE_*` | — |
| 14 | C3 | `feat(registration): show the School stages and education systems the server has not opened as "Soon"` | 28 | see §2.1 | *scratch gate, §3* |
| 15 | C4 | `feat(catalog): add the provisional University module picker to Subjects` | 26 | see §2.1 | *scratch gate, §3* |
| 16 | C4b | `feat(settings,profile): match the 2026-10-15 Settings and Profile frames` | 15 | see §2.1 | *scratch gate, §3* |
| 17 | C4c | `chore(assets): add the B9 empty-card book icon (not wired)` | 2 | `subjects_empty_book.svg`, `ASSET_MANIFEST.md` row | — |
| 18 | C5 | `docs: record wave SEIF1014 and its follow-ups, and this commit plan` | 10 | the docs and records listed below, plus this file | final gate 3486/0/0 expected |

Each body names the wave ids, the recorded counts and the deviations. Bodies of layers taken from `cld` reuse that
commit's text, with one added paragraph: the tree now has the 3.52 contract under it, and that difference was not
re-gated per layer, only the final HEAD. L9's body replaces its "HELD on `merged`" paragraph with the owner's
2026-10-15 word and says that O-16 is still pending.

### 2.1 SEIF1014 split (from SEIF1014 §9, §11.7 addendum and §12.4 addendum)

**Whole files, by commit**

- **C3 (SSG, plus the follow-up 1 spelling and Soon-mark change, plus the follow-up 2 University year mark):**
  - `reference_models.dart` (+ `.freezed.dart`, `.g.dart`), `reference_repository.dart`, `reference_providers.dart`,
    `reference_dropdown.dart`;
  - `school_detail_screen.dart`, `university_detail_screen.dart`, `registration_controller.dart`,
    `registration_error_copy.dart`;
  - `registration_harness.dart` (C3's fixture hunks on its pre-L8 text, Q1d), `reference_repository_test.dart`,
    `school_stage_status_test.dart`, `school_choice_unavailable_test.dart`, `school_soon_pickers_test.dart`,
    `university_year_soon_test.dart`;
  - `mock_backend_school_stages_test.dart`, `mock_backend_v11_test.dart`, `test/guards/rules.dart`, `rules_test.dart`.
- **C4 (CW16b-M, plus the follow-up 1 retry and restyle):**
  - `session_scope.dart`, `catalog_repository.dart`, `subjects_screen.dart`, `modules_notifier.dart`,
    `module_picker.dart`, `catalog_module.dart` (+ generated);
  - `catalog_harness.dart`, the seven module test files, `mock_backend_modules_test.dart`.
- **C4b (follow-ups 1 and 2):** `settings_screen.dart`, `settings_rows.dart`, `settings_section.dart`,
  `profile_screen.dart`, and their four test files.
- **C5:**
  - `DESIGN_ISSUES.md`, `KNOWN_BUGS.md`, `seif_fight.md`, `DECISIONS.md` (the 2026-10-15 paragraph under D-026);
  - `03_DESIGNER_HANDOFF.md`, `04_COMPLETION_ROADMAP.md`, `COMPLETION_STATE.md`;
  - `SEIF1014_PLAN.md`, `SEIF1014_REPORT.md`, this file.

**Split by hunk** (hunk numbers are 0-based in `git diff -U0 8c2cff3`)

| File | C3 | C4 | C4b |
| --- | --- | --- | --- |
| `lib/dev/mock_backend.dart` (11) | 0–5, 7–9 (stages and systems, the launch rule, the 422s) | 6, 10 (the `/catalog/modules` route, the U1 module fixture) | — |
| `test/guards/contract_models_test.dart` (2) | 0; hunk 1, new lines 258–331 (`inlineBindings` loop) | hunk 1, new lines 332–437 (`moduleBindings`) | — |
| `lib/l10n/app_en.arb`, `app_ar.arb` (7 each) | 0 (the three SSG keys, final spelling) | 1 (`allSubjects`) | 2–6 (Notification Preferences keys, the two Rank help keys removed; EN Rank label) |
| `lib/l10n/app_localizations*.dart` | regenerated from the C3 ARBs | regenerated from the C4 ARBs | the saved bytes (= regenerated from the final ARBs) |
| `lib/core/theme/app_colors.dart` (10) | — | 0, 2, 4, 6–9 (five `modulePill*` tokens) | 1, 3, 5 (Settings switch OFF track) |
| `test/core/theme/app_colors_test.dart` (4) | — | 3 | 0–2 |
| `docs/DECISIONS.md` | D-026 (C1 carries D-025 and the "Superseded by D-025" line) | — | — |
| `test/features/registration/registration_harness.dart` | the saved file with L8's one phone line put back to HEAD's text (Q1d) | — | — |

## 3. Scratch gates (2026-10-15, outside the repo)

Each tree was materialised blob for blob into the session scratchpad, together with the repo's `.dart_tool` package
config. Each was then checked with:
- `dart format --set-exit-if-changed` on the hand-written Dart files;
- `flutter analyze --no-pub`;
- `flutter test --no-pub` (the full suite, goldens included, on Windows).

| Tree | Format | Analyze | Tests | Note |
| --- | --- | --- | --- | --- |
| C1 (HEAD + the 3.52 contract) | 0 changed | 0 issues | **2081 / 0 / 0** | Equal to HEAD's own count: the new contract breaks no guard written for `eddb6ac` |
| L2a (C1 + N-26 + the three network tests) | — | 0 issues | the three files: 82 / 0 / 0 | The split CW02 §9 proposed stands on its own |
| C3, C4, C4b (first plan, with L8) | 0 changed | 0 issues | 3325 / 3477 / 3486, all 0 failed / 0 skipped | Superseded by the rehearsal's trees below |
| C3, C4, C4b (this plan, L8 held) | gated again on the rehearsal's commits; the counts are in each commit's body | | | L8 swaps one phone line per file and nothing else, so no count is expected to move |
| Final HEAD (C5) | `validate.sh` on a clone of the rehearsal's HEAD; the result is in C5's body | | | Run again on a copy of the real HEAD before the push |

Not gated on their own: L1, L2b–L10 and S. Each equals its `cld` layer, gated there, plus the C1 contract, which
the C1 row shows is harmless to HEAD-era code (from L9 on, also minus L8's six one-line swaps). C2, C4c and C5
change no Dart. The forward references the verifiers found are comments only: C3 and C4 code cite DESIGN_ISSUES
#133 and #134, and `SOURCE.md` cites `SEIF1014_REPORT.md`. All of those arrive in C5, and the C3 and C4 bodies say
so.

## 4. After the last commit (Part 2.7 / Part 3)

PROV1015's edits stay in the working tree, so the handoff's two tree checks are read against them:

1. `git status --short` must list only: the exclusions (§6); the six L8 files (their swap stays uncommitted);
   PROV1015's edited paths and its new files (§6a). Every other path must equal HEAD.
2. For each PROV1015 path, its pre-copy blob (`prov1015_prewave/SHA_LIST.txt`) must equal HEAD's blob: PROV1015
   builds on exactly what this plan commits.
3. The codegen drift check and the final gate run on **a copy of HEAD in the scratchpad**, not on the working tree:
   - `dart run build_runner build --delete-conflicting-outputs` and `flutter gen-l10n`; `git status` in the copy
     must stay clean;
   - `validate.sh` with `LEVELUP_VALIDATE_OUT` in the scratchpad. Expected: 3486 passed / 0 failed / 0 skipped,
     analyze 0. Anything else stops the run before the push.
4. `git fetch origin`, then check `merge-base --is-ancestor origin/merged merged`, then a plain
   `git push origin merged`. `main` is not pushed or moved. Then read CI with `gh`. Goldens are expected to fail
   on Linux; that is reported, not chased.

## 5. Safety scan (Part 2.4). Every value is masked: no digits, codes or secrets appear here

**Scope:** every line added against HEAD in tracked files, and every line of every untracked file (text files; the 57
PNGs are listed, not read). **Patterns:**
- JWT, Bearer values, private keys, cloud and VCS tokens, password, secret and token assignments, signed URLs,
  emails;
- Egyptian and +20 phone numbers in any digit form, Arabic-Indic digits included;
- six-digit codes near OTP, code, verify or staging words;
- secret file names, and files over 5,000,000 bytes.

| # | Hit | Where | Verdict |
| --- | --- | --- | --- |
| a | **An unfamiliar +20 mobile-format number**: a number typed on a staging walk, "not whitelisted" | `level_up_master_completion_roadmap.html` only | **Excluded** (Q2). |
| a | The staging fixed OTP and the whitelist pattern, about 22 lines | same HTML | same |
| a | File size 5,187,333 bytes (over 5 MB) | same HTML | same |
| b | Staging test-account numbers S1, S2, S3, B1 (Seif's reserved, impossible-length numbers), besides U1 | `docs/SEIF_REPLY_2026-10-09.md` (and in `BACKEND_HANDOFF.md`) | **Excluded** (Q1b): both files stay uncommitted |
| b | U1 | `docs/SEIF_MESSAGE_2026-10-13_sample-modules.md` (C2) | Allowed by the handoff (U1) |
| c | Mock OTP magic codes. One has the same six digits as the staging fixed code; it is already in HEAD's mock and tests 7 times. Plus a new mock banned-account code (CW02) and a new mock "fork" code in one test | `lib/dev/mock_backend.dart`, `test/dev/mock_backend_banned_test.dart`, `test/dev/mock_backend_profile_test.dart`, `test/dev/mock_backend_modules_test.dart`, `test/features/auth/otp_banned_test.dart`, `otp_student_id_test.dart`; prose in `CW07a_REPORT.md:196` ("mock code …"), `CW02_REPORT.md:14,428`, `COMPLETION_STATE.md:99` | **Committed** (Q1c). No code change |
| d | Two new synthetic numbers: Student B, and the registering student | L8 only: `session_isolation_test.dart`, and `register_body_test.dart`, `registration_harness.dart`, `registration_submit_notifier_test.dart`, `school_detail_screen_test.dart`, `university_detail_screen_test.dart` | **Held out** (Q1d). Each is +20 followed by 10 digits, a dialable length, not the impossible-length whitelist form. The six files keep their pre-L8 phone lines, which HEAD already has; L8's swap stays uncommitted |
| d | The contract's own example number | `test/dev/mock_backend_modules_test.dart` (C4) | **Committed.** It is the example in the vendored `openapi.yaml` (C1) and already in HEAD in 10 files, so leaving the test out would not keep the number out |
| e | `support@level-upworld.com` | the vendored contract, `CW12a_FOLLOWUP_REPORT.md` | Company role address, already in the contract: fine |
| e | One gmail address | HEAD's `DESIGN_ISSUES.md` and the pre-wave copies only | Not new |
| f | Bearer value | `mock.access.token` in the roadmap HTML/JSON | False positive |
| f | Ten-digit "numbers" | Figma `Frame` node ids in pre-wave copies of `DESIGN_ISSUES.md` | False positive |

**Q1d check, on every blob this plan commits** (`q1d_profile.py`, digits never printed): every +20 number in the 18
commits is either already in HEAD (pushed before this handoff) or U1. No new number lands.

**Nothing found:**
- no JWT, no real Bearer value, no key or private key, no keystore, `.env`, `key.properties` or
  google-services file;
- no file over 5 MB except the HTML.

## 6. Exclusions (stay uncommitted)

| Path | Why |
| --- | --- |
| `docs/BACKEND_HANDOFF.md` | the owner's standing instruction |
| `docs/SEIF_REPLY_2026-10-09.md` | Q1b: it names Seif's staging test accounts. The nine pointer edits in S name the digest, which is local only |
| `.ai/audits/current/test-results.md` (modified) | the owner's instruction: any change to it stays out |
| `level_up_master_completion_roadmap.html`, `.json` | R-3 (2026-10-09), scan hit (a); Q2 |
| `.ai/audits/current/completion/*_prewave/` (11 folders, 260 files) | No pre-copy folder has ever been tracked, and `cld` left them out; Q2 |
| `.ai/audits/current/completion/seif1014_shots/` (57 PNGs) | Precedent: `git ls-files` holds no wave screenshot; Q2 |
| `seif_2026-10-14_prompt.md` | The SEIF1014 session prompt (holds U1 and Seif's messages). Session prompts are not tracked; Q2 |
| L8's swap in six test files | Q1d (§5) |
| `PROV1015_*`, `prov1015_*` and every PROV1015 edit | the peer hold (§6a) |

## 6a. Peer hold: PROV1015 (received 2026-10-15, after this plan was written)

The owner-started session "PROV1015 screen builds" asked that its paths not be staged or committed until it reports
to the owner. It edits these in the working tree, with pre-copies in `prov1015_prewave/SHA_LIST.txt`:
- `app_colors.dart` and its test;
- both ARBs and the three generated l10n files;
- `school_detail_screen.dart` and three registration tests;
- `subject_card.dart`, `subjects_screen.dart` and `mock_backend.dart`;
- `DESIGN_ISSUES.md`, `DECISIONS.md`, `ASSET_MANIFEST.md`, maybe `seif_fight.md`, and `COMPLETION_STATE.md`;
- new files of its own.

PROV1015 confirmed that its `prov1015_prewave/` holds byte-exact copies of all 76 paths it may touch, taken before
its first edit, and each of them equals this plan's final tree. The owner chose Q4 (i): wait for PROV1015's report,
then commit this plan from the saved bytes and leave PROV1015's edits uncommitted on top, for PROV1015 to land as
its own layer. No PROV1015 byte is staged or committed by this plan.

## 7. Questions and the owner's answers (2026-10-15)

- **Q4: order with PROV1015.** (i): wait until PROV1015 reports ("GO"), then commit this plan from the saved copy
  with a temporary index, check each commit's tree against the plan, and run the final gate on a copy of HEAD in
  the scratchpad. PROV1015's edits stay uncommitted.
- **Q1b: `SEIF_REPLY_2026-10-09.md`.** Excluded, together with `BACKEND_HANDOFF.md`. Both stay uncommitted.
- **Q1c: mock OTP codes.** Committed. No code change now.
- **Q1d: synthetic test numbers.** Committed only if both follow the obviously-fake whitelist form; otherwise the
  file stays out of its commit. Neither does (§5), so L8 is held out and its six files keep their pre-L8 lines.
- **Q2: the roadmap files, the 11 pre-wave folders, `seif1014_shots/`, the SEIF1014 prompt and PROV1015's files.**
  All stay out.
- **Q3: CW04a.** Committed on `merged`; L9's body says O-16 is still pending. Push `merged` only (plain push).
  `main` does not move again.
- **Hooks.** Running `.githooks/pre-commit` by hand before every commit is approved. `core.hooksPath` is not
  changed.
