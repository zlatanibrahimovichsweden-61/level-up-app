# Branch `cld`: inventory of non-Dart files

Generated from git, not from the run records: `git diff --name-status b227f61..cld` (base = `merged` at `b227f61`, which is also `origin/merged`). Every path the branch adds or modifies that is not a `.dart` file is listed below, with the commit(s) that touch it. Commit ids are the ones used in the commit bodies: **L1-L10** = the prepared layers of the work that was uncommitted on 2026-10-11 (N-26 -> CW02 -> CW07a -> CW12a -> O-15 -> O-14 -> NNA+O-17 -> synthetic test numbers -> CW04a -> records); **S** = the parallel session's adoption of Seif's 2026-10-09 reply; **C01-C15** = the 2026-10-12 implementation run in the order of `IMPL_RUN_2026-10-12.md` s8; **C16** = Claude Code cloud setup; **C17** = this inventory and the refreshed `test-results.md`.

Cloud column: **required to build/test** = a fresh cloud session needs it; **context Claude should read** = instructions or live state; **records (optional)** = history; **local-only** = Windows/owner-machine tooling or records it writes. Every listed file is **committed on `cld`** (tracked); nothing in this table is excluded.

## Summary

- Paths changed by the branch: **427** (256 added, 171 modified, 0 removed).
- Dart: **373** (228 added, 145 modified); of these **29** are generated (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`), 180 under `lib/`, 193 under `test/`. Not itemised here (the request is the non-Dart set); `git diff --stat` lists them.
- Non-Dart: **54** (28 added, 26 modified, 0 removed).

| Category | Files | Added | Modified |
|---|---|---|---|
| Python | 0 | 0 | 0 |
| JavaScript | 0 | 0 | 0 |
| TypeScript | 0 | 0 | 0 |
| Shell | 4 | 3 | 1 |
| Configuration and dependency manifests | 5 | 1 | 4 |
| Documentation and records | 38 | 17 | 21 |
| Assets (images, icons) | 7 | 7 | 0 |
| Other (incl. extensionless) | 0 | 0 | 0 |

| Extension | Files | Added | Modified |
|---|---|---|---|
| `.md` | 38 | 17 | 21 |
| `.svg` | 6 | 6 | 0 |
| `.sh` | 3 | 3 | 0 |
| `.arb` | 2 | 0 | 2 |
| `.json` | 1 | 1 | 0 |
| `.lock` | 1 | 0 | 1 |
| `.png` | 1 | 1 | 0 |
| `.ps1` | 1 | 0 | 1 |
| `.yaml` | 1 | 0 | 1 |

Python, JavaScript and TypeScript: **0** files in the repository, before or after (checked over every tracked file). The repository's tooling is Dart/Flutter, POSIX shell and Windows PowerShell, so no `requirements.txt`, `pyproject.toml` or `package.json` is needed and none was added.

## Every changed non-Dart file

### Shell (4)

| Path | Ext | Status | Commit(s) | Purpose | Cloud | Command / dependency |
|---|---|---|---|---|---|---|
| `tool/verify_guards.ps1` | `.ps1` | modified | C04 | Guard-mutation prover: probes for the CW18a workflow guards (C04). | local-only | powershell -ExecutionPolicy Bypass -File tool/verify_guards.ps1 (Windows only) |
| `tool/cloud/check.sh` | `.sh` | newly created | C16 | Linux gate = CI test job: pub get, lockfile, gen-l10n, format, analyze, tests without goldens. Writes nothing. | required to build/test | bash tool/cloud/check.sh (needs flutter on PATH) |
| `tool/cloud/session_start.sh` | `.sh` | newly created | C16 | SessionStart hook body: installs/locates the SDK, exports PATH via CLAUDE_ENV_FILE, pub get. Cloud only. | required to build/test | run by the hook; bash |
| `tool/cloud/setup.sh` | `.sh` | newly created | C16 | Installs the pinned Flutter SDK (tag from .flutter-version, commit-checked) in a cloud VM; refuses to run locally. | required to build/test | bash; network: github.com, storage.googleapis.com, pub.dev |

### Configuration and dependency manifests (5)

| Path | Ext | Status | Commit(s) | Purpose | Cloud | Command / dependency |
|---|---|---|---|---|---|---|
| `lib/l10n/app_ar.arb` | `.arb` | modified | L1, L2, L3, L4, L6 | Arabic strings: N-26 hint pattern (L1), banned copy (L2), inbox (L3), support (L4), approved O-14 Arabic (L6). | required to build/test | flutter gen-l10n (generated app_localizations*.dart are committed) |
| `lib/l10n/app_en.arb` | `.arb` | modified | L1, L2, L3, L4, L6 | English strings, same commits as app_ar.arb. | required to build/test | flutter gen-l10n |
| `.claude/settings.json` | `.json` | newly created | C16 | Project settings: SessionStart hook running tool/cloud/session_start.sh (no-op unless CLAUDE_CODE_REMOTE=true). No permissions, no secrets. | required to build/test | bash |
| `pubspec.lock` | `.lock` | modified | L9 | Lock gains exactly flutter_markdown_plus 1.0.12 and markdown 7.3.1. | required to build/test | flutter pub get (CI fails if it drifts) |
| `pubspec.yaml` | `.yaml` | modified | L9 | Adds flutter_markdown_plus 1.0.12 for the legal viewer (CW04a, owner decision D1). | required to build/test | flutter pub get |

### Documentation and records (38)

| Path | Ext | Status | Commit(s) | Purpose | Cloud | Command / dependency |
|---|---|---|---|---|---|---|
| `.ai/audits/current/completion/02_SEIF_HANDOFF.md` | `.md` | modified | L10 | Draft questions for Seif (SQ-01..SQ-34, support addendum). Drafts only: nothing was sent. | context Claude should read | - |
| `.ai/audits/current/completion/03_DESIGNER_HANDOFF.md` | `.md` | modified | L10 | Draft designer handoff (DG-nn, H-nn, s11.1 legal-viewer message). Not sent. | context Claude should read | - |
| `.ai/audits/current/completion/CLD_NON_DART_FILE_INVENTORY.md` | `.md` | newly created | C17 | This inventory. | records (optional) | - |
| `.ai/audits/current/completion/COMPLETION_STATE.md` | `.md` | modified | L10, C15 | Live state of the completion program: waves CW00-CW20, owner decisions O-1..O-23, answers log, 2026-10-12 run entry. | context Claude should read | - |
| `.ai/audits/current/completion/CW02_PLAN.md` | `.md` | newly created | L10 | Plan of wave CW02 (error/routing seam, banned notice, return target). | records (optional) | - |
| `.ai/audits/current/completion/CW02_REPORT.md` | `.md` | newly created | L10 | Report of CW02 incl. review passes, O-10 and O10-1 fix. | records (optional) | - |
| `.ai/audits/current/completion/CW04a_BRIEF.md` | `.md` | newly created | L10 | Brief of CW04a, the legal document viewer (D1-D4, C1-C3). | records (optional) | - |
| `.ai/audits/current/completion/CW04a_REPORT.md` | `.md` | newly created | L10 | Report of CW04a (viewer, untrusted-Markdown rules, mutations). | records (optional) | - |
| `.ai/audits/current/completion/CW07a_PLAN.md` | `.md` | newly created | L10 | Plan of CW07a, the notifications inbox. | records (optional) | - |
| `.ai/audits/current/completion/CW07a_REPORT.md` | `.md` | newly created | L10 | Report of CW07a. | records (optional) | - |
| `.ai/audits/current/completion/CW12a_FOLLOWUP_REPORT.md` | `.md` | newly created | L10 | CW12a follow-ups: O-14 copy table and application, O-15 build, staging passes. | records (optional) | - |
| `.ai/audits/current/completion/CW12a_PLAN.md` | `.md` | newly created | L10 | Plan of CW12a, text support tickets. | records (optional) | - |
| `.ai/audits/current/completion/CW12a_REPORT.md` | `.md` | newly created | L10 | Report of CW12a. | records (optional) | - |
| `.ai/audits/current/completion/IMPL_RUN_2026-10-12.md` | `.md` | newly created | C15 | Record of the 2026-10-12 implementation run: waves, operations wired (mock vs live), defects, blockers, s8 commit order this branch follows. | context Claude should read | - |
| `.ai/audits/current/completion/NNA_REPORT.md` | `.md` | newly created | L10 | Report of NNA (name_not_allowed ahead of the pin), BUG-027, O-17. | records (optional) | - |
| `.ai/audits/current/completion/O16_DECISION_NOTE.md` | `.md` | newly created | L10 | The pending O-16 decision (Login consent sentence). Approves nothing. | context Claude should read | - |
| `.ai/audits/current/release_readiness_reconciliation_2026-10-06.md` | `.md` | modified | C15 | Release-readiness reconciliation: NR-26 and NR-29 status rows updated by the run. Pre-existing record; still holds one N-26 occurrence that was already committed at b227f61 (count unchanged; purge is owner decision O-9). | records (optional) | - |
| `.ai/audits/current/smoke-staging-2026-10-10.md` | `.md` | newly created | L10 | Signed-in API-level staging run of the 5 support-ticket ops and name_not_allowed (statuses and codes only; no token, phone or student named). | records (optional) | - |
| `.ai/audits/current/test-results.md` | `.md` | modified | L1, C17 | The tracked validate record. L1 carries the record of its own tree (2082); C17 refreshes it with validate.ps1 on the final tree. | local-only | written by tool/validate.ps1 / validate.sh; in the cloud use tool/cloud/check.sh, which writes nothing |
| `.claude/skills/seif-api-contract/SKILL.md` | `.md` | modified | S | Project skill: points at docs/BACKEND_HANDOFF.md before drafting a change request. | context Claude should read | - |
| `CLAUDE.md` | `.md` | modified | S, C16 | Standing project instructions: pointers to docs/BACKEND_HANDOFF.md (Seif session) and to the cloud gate / docs/CLOUD_SETUP.md (C16). | context Claude should read | - |
| `docs/AGENT_WORKFLOW.md` | `.md` | modified | S | Agent loop doc: pointer to BACKEND_HANDOFF.md. | context Claude should read | - |
| `docs/BACKEND_HANDOFF.md` | `.md` | newly created | S | Digest of Seif's 2026-10-09 reply: confirmed backend facts, conflicts, question ledger. Read before backend work. | context Claude should read | - |
| `docs/CLOUD_SETUP.md` | `.md` | newly created | C16 | How to run this repo in a Claude Code cloud session: setup script, hook, commands, what stays local. | context Claude should read | - |
| `docs/DECISIONS.md` | `.md` | modified | S, C15 | Decision log: D-021 forward link (S); D-025..D-031 from the run (C15). | context Claude should read | - |
| `docs/DESIGN_ISSUES.md` | `.md` | modified | L10, C15 | Design-gap register: #127..#132 (L10), #7/#132 updates and #133 (C15). | context Claude should read | - |
| `docs/ENVIRONMENTS.md` | `.md` | modified | S, C04 | Environments: BACKEND_HANDOFF pointer (S); CW18a boot flavor assertion, main_mock refusal, environment ribbon (C04). | context Claude should read | - |
| `docs/KNOWN_BUGS.md` | `.md` | modified | L10, C15 | Runtime defects: BUG-026/027 (L10); BUG-028..043 fixed and BUG-044..052 open (C15). | context Claude should read | - |
| `docs/PROJECT_GUIDE.md` | `.md` | modified | S | Project index: BACKEND_HANDOFF pointer. | context Claude should read | - |
| `docs/RESPONSIVE.md` | `.md` | modified | L5, C15 | Responsive/text-scale queue: items applied by O-15 (L5) and the run (C15). | context Claude should read | - |
| `docs/RISKS.md` | `.md` | modified | S | Risk register: BACKEND_HANDOFF pointer. | context Claude should read | - |
| `docs/SEIF_REPLY_2026-10-09.md` | `.md` | newly created | S | Seif's 2026-10-09 reply, archived verbatim (role e-mail address only). | records (optional) | - |
| `docs/STORE_READINESS.md` | `.md` | modified | S | Store readiness: BACKEND_HANDOFF pointer. | records (optional) | - |
| `docs/day10_mistakes_brief.md` | `.md` | modified | C15 | Dated brief: banner noting what the run changed (session autoDispose). | records (optional) | - |
| `docs/day1_login_otp_brief.md` | `.md` | modified | L1 | Dated brief: phone-hint line now names the N-26 pattern. | records (optional) | - |
| `docs/seif_fight.md` | `.md` | modified | S | Open questions for Seif: BACKEND_HANDOFF pointer (entries stay as filed). | context Claude should read | - |
| `flutter_code_tree.md` | `.md` | modified | C15 | Code map, refreshed for the run (routes, new data layers). | context Claude should read | - |
| `flutter_frontend_workflow.md` | `.md` | modified | C15 | Frontend workflow map, refreshed (app_router line count, etc.). | records (optional) | - |

### Assets (images, icons) (7)

| Path | Ext | Status | Commit(s) | Purpose | Cloud | Command / dependency |
|---|---|---|---|---|---|---|
| `assets/images/support_staff_avatar.png` | `.png` | newly created | L4 | Support thread staff avatar (Figma export, CW12a). Binary. | required to build/test | declared under assets/images/ in pubspec.yaml |
| `assets/icons/notification_announcement.svg` | `.svg` | newly created | L3 | Notifications inbox category disc (Figma export, CW07a). Bundled asset. | required to build/test | declared under assets/icons/ in pubspec.yaml |
| `assets/icons/notification_support.svg` | `.svg` | newly created | L3 | Notifications inbox category disc (CW07a). | required to build/test | as above |
| `assets/icons/notification_system.svg` | `.svg` | newly created | L3 | Notifications inbox category disc (CW07a). | required to build/test | as above |
| `assets/icons/support_add.svg` | `.svg` | newly created | L4 | Support list create-ticket glyph (CW12a). | required to build/test | as above |
| `assets/icons/support_headset_disc.svg` | `.svg` | newly created | L4 | Support list header disc (CW12a). | required to build/test | as above |
| `assets/icons/support_send.svg` | `.svg` | newly created | L4 | Support thread send glyph (CW12a, mirrored in RTL). | required to build/test | as above |

## Deliberately excluded from the branch

Everything that was uncommitted in the main working tree on 2026-10-13 is on `cld` except these. The main tree still holds them, untouched.

| Path | Files | Types | Why excluded | Disposition |
|---|---|---|---|---|
| `.ai/audits/current/completion/{cw04a,cw07a,cw12a,fu2,nna,nna2,o14,o15,o17}_prewave/` | 117 (17, 10, 19, 7, 12, 14, 20, 4, 14) | 77 `.prewave`, 18 `.txt`, 12 `.dart`, 9 `.md`, 1 `.patch` | Pre-edit backup copies taken before each pass, used to separate one wave's hunks from the next. They are evidence, not records. The 12 `.dart` copies would also become tracked Dart that format and analyze would check. The 2026-10-11 commit layers excluded them for the same reasons. | Untracked in the main tree; not needed in the cloud. |
| `level_up_master_completion_roadmap.html`, `level_up_master_completion_roadmap.json` (repo root) | 2 | `.html`, `.json` | Owner ruling R-3: they stay untracked. The HTML held the N-26 number until it was masked on 2026-10-11 (the original is kept outside the repository). | Untracked; never `git add` them. |
| `test/zz_live_legal_test.dart`, `test/zz_live_legal_midword_test.dart`, `test/zz_live_legal_zoom_test.dart` | 3 | `.dart` | Throwaway tests from readiness task E2. They read the live legal JSON from an absolute local path and were never merged (`IMPL_RUN_2026-10-12.md` s8). | Exist only in the fork `_ws_e2`. |

## Outside the repository: local-only tooling and evidence (never committed)

| Location (owner's machine) | Contents | Dependencies | Needed in the cloud? |
|---|---|---|---|
| `F:\level\level_up\_impl_ws_ledger\tools\` | `ws_fork.py`, `ws_merge.py`, `checklist.py`, `r1_summarize.py`, `patch_final_gate.js` | Python 3 and Node standard library only (`json`, `subprocess`, `fnmatch`, `shutil`; `fs`). They hard-code local paths. | No. They implement the isolated-workspace method (fork, merge with ownership globs, record patches). |
| `F:\level\level_up\_impl_ws_ledger\` (rest) | `LEDGER.md`, `REMAINING_WORK_2026-10-12.md`, 22 `.json` round/reconcile results, 27 `.txt`, 3 `.log`, validate outputs, `*_prewave/` before-images (110 `.dart`), `e3_walk_evidence/` (110 `.png` emulator screenshots) | none | No. This is evidence for the run record. |
| Session scratchpad (temporary) | 183 `.py`, 145 `.js`, 24 `.sh`, 3 `.ps1`: one-off patch, scan and assembly scripts, including the scripts that assembled this branch (hunk assignment, step builder, tree verification, privacy scan) | Standard library only | No. May be cleaned at any time. |
| `F:\level\level_up\_impl_ws`, `_ws_*` (14 wave forks), `_tmp_dbg_staging_l1`, `wt_commitprep` | The run's integrated workspace, its per-wave forks, the phone debug clone, and the prepared commit layers | none | No. `_impl_ws` is byte-identical to `cld` at C15, minus the exclusions above (checked: 1018 files, 0 differences). |
| `F:\level\level_up\private_recovery_2026-10-11\` | The unmasked original of the roadmap HTML | none | No. It must never be committed anywhere. |

## Tooling census: what a fresh environment needs

| Tool | Used by | Cloud session | Local (owner's Windows machine) |
|---|---|---|---|
| Flutter 3.44.7 / Dart 3.12.2 (`.flutter-version`; CI reads the same file) | build, analyze, tests | Installed by `tool/cloud/setup.sh` (setup script or SessionStart hook) | Installed |
| Pub packages (`pubspec.lock`) | everything | `flutter pub get` (pub.dev is on the default allowlist) | same |
| `build_runner` (dev dependency) | only when a freezed/json model changes; generated files are committed | `dart run build_runner build --delete-conflicting-outputs` (FULL build) | same |
| `flutter gen-l10n` | only when an `.arb` changes; generated files are committed | yes | yes |
| bash, git, GNU grep (`-z`), xargs | `tool/validate.sh`, `tool/cloud/*.sh`, `.githooks/*` | present on the Ubuntu image | Git Bash |
| Windows PowerShell 5.1 | `tool/validate.ps1`, `tool/verify_guards.ps1`, `tool/verify_release_manifest.ps1`, `tool/verify_session_regression.ps1` | **not available** (no `pwsh` on the image); `tool/cloud/check.sh` stands in for the gate | yes |
| Golden tests (`--tags golden`) | pixel baselines captured on Windows | **excluded** (they fail on Linux by design; CI runs them on Windows) | yes, inside `validate.ps1` |
| Android SDK, emulator, USB device | APK builds, device walks | **not available** (no SDK; `dl.google.com` is not on the default allowlist; no devices) | yes |
| Xcode / CocoaPods | iOS | no | no (needs a Mac) |
| Python 3, Node 22 | not used by the repository | present on the image, unused | unused by the repo |

## Scan of what the branch adds

A script read every line the branch adds (`git diff b227f61..cld`) and the whole of every changed file. Values were never printed.

- **N-26 number:** removed from all 28 code, test, l10n and brief files that held it at `b227f61`. One record, `release_readiness_reconciliation_2026-10-06.md`, keeps the single occurrence it already had in the committed base (count unchanged). No new file holds it. Purging history and records is owner decision O-9.
- **Phone-shaped numbers in added lines:** 26 are synthetic (five or more zeros in a row). There are 2 occurrences of the API contract's own example number, in `test/dev/mock_backend_quiz_history_test.dart:59` and `test/dev/mock_modules_test.dart:144`. That number is already in 10 tracked files at `b227f61`, including `contract/openapi.yaml`, and the 2026-10-09 N-26 ruling treated it as not personal. It is flagged here for the owner and left unchanged.
- **E-mail addresses:** only the company's support role address (7 occurrences, in Seif's reply, its digest and one report).
- **Secret-shaped strings:** 1, a test sentinel string in `test/audit_e4/e_privacy_logs_storage_test.dart`. It is not a credential.
- **Sensitive file names** (keystores, `key.properties`, `google-services.json`, `.env`, `.p12`, `.pem`): none in the tree.
- **Local machine paths:** only in records: the `test-results.md` record, provenance lines in `BACKEND_HANDOFF.md`, two `KNOWN_BUGS.md` lines, one `DECISIONS.md` line and the run records. No script, config file or code depends on one.

## Files this workflow generated outside the branch, and what to do with them

- `F:\level\level_up\wt_cldchk1` to `wt_cldchk3`: detached validation worktrees. Removed after the per-commit checks.
- `F:\level\level_up\wt_cld`: the worktree that carries the local branch `cld`. Keep it, or remove it with `git worktree remove` once it is no longer needed (owner's call). Removing it does not delete the branch.
- Nothing in the main working tree, `wt_commitprep`, `_impl_ws`, the forks or the ledger was modified or deleted by this workflow.
