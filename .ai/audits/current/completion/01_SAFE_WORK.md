# Completion program — Deliverable B: safe prerequisite-light work (CW00)

**Date:** 2026-10-09. **Status:** executed items are in the working tree, **uncommitted** (no commit or push without the
owner's request). **Evaluation:** a read-only Sonnet agent (workflow `wf_6986d53d-04f`, `safe:evaluate`); the lead
reviewed it and chose the items. **Code implementation:** a Sonnet implementer with a fixed 4-file scope. **Doc/tooling
edits:** the lead, via exact-match scripts (count asserted = 1, byte-preserving).

A candidate qualified only if it was directly supported by settled owner decisions, was local to the repo, did not
depend on Firebase, production infrastructure, legal or Seif, was small, and could be validated.

## 1. Decision table

| ID | Candidate | Verdict | Why safe now / prerequisite it does not need | Files | Verification | User-visible? |
| --- | --- | --- | --- | --- | --- | --- |
| C1 | `Accept: application/json` on every API request (contract 3.32.0-m1: `openapi.yaml@eddb6ac:3883-3890`, `contract-changelog.md:194-196`) | **DONE** | One default header, which a per-request header can override. Needs no re-vendor (the rule exists at 3.38 and 3.46), no Seif, no Firebase. Mock and images use their own clients. | `lib/core/network/dio_client.dart`; new `test/core/network/dio_client_test.dart` (+4) | Red-first: 3 Accept assertions failed with `Actual: <null>` on the unedited client and pass after. Network suite 48/48. | No (wire only) |
| C2 | False doc comment "Every non-2xx body is RFC 9457 ProblemDetails" | **DONE** | Comment only, made true against contract 3.32+. No behaviour change. | `lib/core/network/interceptors/error_interceptor.dart`; `test/core/network/error_interceptor_test.dart` (+8 characterisation tests) | The 8 tests pass on the **unchanged** behaviour (bodyless/non-JSON → code `unknown`; 401 stays Unauthorized) | No |
| C3 | Live build/run commands missing `--flavor` (Gradle refuses them since `2dfd969`) | **DONE** | Text only; dated records untouched (the guard excludes them) | `.ai/audits/current/implementation_waves.md:20`, `assets/fonts/README.md:36`, `docs/RELEASE_SIGNING.md:23`, `docs/KNOWN_BUGS.md:21` | Exact match count 1 each; `workflow_test` guard green | No |
| C4 | Record the owner's 2026-10-09 rulings | **DONE** | Transcribes the owner's brief; no test reads these files | `docs/DECISIONS.md` (+D-022 contract target, D-023 release-1 scope, D-024 protocol); `.ai/audits/current/wave_state.md` (append-only CRLF amendment: pointer + stale-line corrections) | Read-back; 0 deleted lines in `wave_state.md` | No |
| C5 | Provably stale risk lines | **DONE** (R-3, R-8, R-9, "Last reviewed") | Each replaced line is disproved by evidence: `gh run list` (15 runs, 14 ok / 1 fixed failure), `app_config.dart:54`, `grep isDev`, the pbxproj, the AAB manifest | `docs/RISKS.md` | Read-back. **Not done:** the agent's R-5/R-7/R-10 touch-ups (minor; left for a docs pass) | No |
| C10 | Port the uncommitted `xargs -s 7000` batching (cmd.exe 8191-char limit) from the idle worktree `angry-antonelli-cf9094` | **DONE** | Tooling only; its diff is a superset of `jovial-bhaskara`'s. The diff is byte-identical to the worktree's (sha256 match). Worktrees left in place; removing them is the owner's call. | `tool/validate.sh`, `.githooks/pre-commit` | `workflow_test` guard + a `validate.sh` run with `LEVELUP_VALIDATE_OUT` redirected (§2) | No |
| C6 | `CLAUDE.md` stale counts (849 tests, 63 commits, pin `184d6ec`, 48 issues) | **HELD — owner OK required** | Standing context loaded by every session; facts-only edits are specified in the evaluation | `CLAUDE.md` | — | No |
| C7 | iOS identity guard | **DEFER → CW03** | Would fail until the Xcode change lands; the suite must stay green | new `test/guards/ios_identity_test.dart` | spec in the evaluation | No |
| C8 | Hand-edit `project.pbxproj` ids + 15.0 on Windows | **DEFER → CW03** | Owner text: "in the appropriate environment wave after checking the actual Xcode/project structure". Without flavors, a single id would give staging the prod id (reverses D-021 Q2). No BUILD is possible here. | `ios/**` | needs a Mac | — |
| C9 | iOS readiness script | **DEFER → CW03** | Author where it can run; file-level checks belong in the C7 guard | — | — | — |
| C11 | `contract/SOURCE.md:17` false "CRLF" sentence | **DEFER → CW01** | `contract/` is edited only by the isolated re-vendor (D-022) | — | — | — |

Not a candidate but done in CW00: the **contract re-vendor dry run at `eddb6ac`** (BUILD, throwaway worktree, nothing
changed in the main tree): see `00_BASELINE.md` §9.

## 2. Validation of the final working tree (BUILD, 2026-10-09T12:44–12:47Z)

The tree is HEAD `8e641e9` + the untouched 3.38 contract files + every CW00 change above. I re-confirmed that the contract
files are blob-identical to `65245be` after the work.

| Gate | Command | Result |
| --- | --- | --- |
| Format, filesystem (catches the new untracked test file) | `dart format --set-exit-if-changed --output=none lib test tool` | 370 files, 0 changed, rc 0 |
| Release-command / tooling guard | `flutter test test/guards/workflow_test.dart` | +15, all passed |
| **`tool/validate.sh`** (Git Bash; with `LEVELUP_VALIDATE_OUT` pointing at the scratchpad so the tracked `test-results.md` is **not** rewritten) | `LEVELUP_VALIDATE_OUT=<scratch> sh tool/validate.sh` | **OVERALL: PASS**, rc 0. Format: 324 hand-written files in 3 batches (148/142/34), 0 changed, with **no "command line is too long"**, so C10 is proven on this machine. Analyze: 0 issues. Tests: **2079 passed / 0 failed / 0 skipped** (= 2067 baseline + 12 new). |
| Implementer's targeted runs | `flutter test test/core/network`; `flutter test test/guards` | 48/48; 122/122 |
| Tracked report untouched | `git status --short -- .ai/audits/current/test-results.md` | clean |

**Verification level:** BUILD only. C1's wire effect is backed only by the evaluation agent's unauthenticated staging probes (200 JSON / 400 and 401 `application/problem+json` with `Accept: application/json`). Nothing in CW00 reached DEVICE; the Pixel 8 was not attached.

**New floor for CW01:** 2079 tests / 0 failed; guards 122.

## 3. Not done, and why

- C6 (`CLAUDE.md`), owner OK pending.
- C7, C8 and C9 belong to CW03 (needs a Mac and the owner's "in the environment wave").
- C11 belongs to CW01.
- R-5, R-7 and R-10 touch-ups in `RISKS.md` are minor and left for a docs pass.
