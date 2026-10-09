# Commit-readiness review: CW00 + CW01 (2026-10-09T14:11–14:40Z)

**Requested by** the owner before CW02. **Performed by** the Opus control-plane session. **Nothing was staged, committed or
pushed**, and CW02 has not started. Main-tree fingerprints are unchanged from the CW01 close: porcelain `df2d5d1d…`,
diff `a8671069…`. Two records were edited during the review and one was created (§6).

## 1. Every changed or untracked file, accounted for (31 files)

| Group | Files | Origin | Proposed commit |
| --- | --- | --- | --- |
| Network | `lib/core/network/dio_client.dart`, `lib/core/network/interceptors/error_interceptor.dart`, `test/core/network/error_interceptor_test.dart`, **new** `test/core/network/dio_client_test.dart` | CW00 C1/C2 | 1 `fix(network)` |
| Tooling | `tool/validate.sh`, `.githooks/pre-commit` | CW00 C10 | 2 `chore(tooling)` |
| Docs | `docs/DECISIONS.md` (one appended block, +80), `docs/RISKS.md`, `docs/KNOWN_BUGS.md`, `docs/RELEASE_SIGNING.md`, `assets/fonts/README.md`, `.ai/audits/current/implementation_waves.md`, `.ai/audits/current/wave_state.md` (append-only, 0 deleted lines; the working copy is CRLF and git stores LF) | CW00 C3/C4/C5 | 3 `docs` |
| Completion records | **new** `.ai/audits/current/completion/` × 9: `00_BASELINE`, `01_SAFE_WORK`, `02_SEIF_HANDOFF`, `03_DESIGNER_HANDOFF`, `04_COMPLETION_ROADMAP`, `COMPLETION_STATE`, `CW01_AUTHORIZATION`, `CW01_REPORT`, this file | CW00, CW01, this review | 3 `docs` |
| Discovery report | **new** `.ai/audits/current/PRE_EXECUTION_DISCOVERY.md` (929,355 bytes) | earlier discovery session (2026-10-08), **not CW00** | 3 `docs`, **owner decision R-2** |
| Contract | `contract/{openapi.yaml,contract-changelog.md,error-codes.md,realtime.md,SOURCE.md}`, **new** `test/guards/contract_pin_test.dart`, `lib/dev/mock_backend.dart` (comment only) | CW01 | 4 `chore(contract)` |
| **Excluded** | `level_up_master_completion_roadmap.html` (5,186,787 B), `level_up_master_completion_roadmap.json` (443,697 B) at the repo root | generated 2026-10-08T02:59Z by an earlier session; neither wave's work | **none**: left untracked and untouched (**R-3**) |

There are no other changes. Nothing is staged and there is no `index.lock`. `pubspec.*` and the tracked `test-results.md` are clean. The backup branch `backup/2026-08-22-dirty-tree` is intact. The two idle worktrees (`angry-antonelli`, `jovial-bhaskara`) are untouched.

**Sensitive-content scan** of all 31 files. Patterns: JWT, literal `Bearer`, Google, GitHub, OpenAI and Slack keys, private-key blocks, `password`/`secret`/`api_key` values, emails, signed storage URLs, and `+20` phone numbers. Result:
- **No secrets.**
- The three phone numbers found are pre-existing mock fixtures in `lib/dev/mock_backend.dart`, outside this diff and in tracked history since `cccd2f1`.
- Figma node `1240:9847` appears only as an id, never with its content.

## 2. Dependencies between commits

| Edge | Consequence |
| --- | --- |
| `SOURCE.md` (4) cites `completion/04_COMPLETION_ROADMAP.md` and `01_SAFE_WORK.md` (3) | 3 lands **before** 4 |
| `DECISIONS.md` D-022 (3) cites `PRE_EXECUTION_DISCOVERY.md` §14 and `completion/00_BASELINE.md`. Five completion records also cite the discovery report (`D:NNNN`) | the discovery report rides in 3, or those references dangle (R-2) |
| The `fix(network)` comment (1) cites contract 3.32.0-m1, and the support-photo GET (3.42+), while that commit's tree still pins 3.28.0-m1 | Transient and harmless, since the header is valid HTTP at any pin. The commit body says the contract lands in 4. |
| The completion records (3) describe CW01 as done while that tree's contract is still `0df5cf4` | Transient for one commit. |
| `D-022` (3) says "not yet applied" and cites a "false sentence at `contract/SOURCE.md:17`" that was never committed | The proposed 2-line edit is made after 3 and rides in 4 (R-4) |
| The `chore(contract)` commit diff spans `0df5cf4` → `eddb6ac` | `65245be` was never committed; the body says so |

Every intermediate tree builds and passes (§3), so `git bisect` stays usable.

## 3. Each proposed commit, rebuilt and gated (BUILD, throwaway worktree, 14:15:46–14:31:32Z)

Cumulative layers on a detached worktree at `8e641e9` (outside the repo, removed afterwards). Files were copied from the main tree, except `wave_state.md`, which was LF-normalised to model the committed bytes. The hook was emulated exactly: `xargs -0 -r -s 7000` running `dart format` and `flutter analyze` over each commit's hand-written Dart files.

| Layer | Hook (format / analyze) | Format (filesystem) | Analyze | Tests |
| --- | --- | --- | --- | --- |
| 1 `fix(network)` | 4 files: 0 changed / 0 issues | 370, 0 changed | 0 | `flutter test`: **+2079, all passed**. HEAD's own `validate.sh` is unbatched and is fixed by layer 2. |
| 2 `chore(tooling)` | (no Dart files) | — | — | `validate.sh`: **OVERALL PASS, 2079 / 0 / 0** |
| 3 `docs` | (no Dart files) | — | — | `flutter test`: rc 0, all passed (the count was cut off by log truncation; this layer adds no test files) |
| 4 `chore(contract)` | 2 files: 0 changed / 0 issues | 371, 0 changed | 0 | guards rc 0; `validate.sh`: **OVERALL PASS, 2081 / 0 / 0**; 4/4 blobs equal `eddb6ac`; `pubspec` unchanged |

**Final-tree identity:** every file in layer 4 is byte-identical to the main working tree (with `wave_state.md` compared LF-normalised). The proposed split therefore reproduces exactly the tree that CW01 validated.

Not covered by the layer run: this record itself, and the `COMPLETION_STATE.md` and `CW01_REPORT.md` edits made during the review. All three are Markdown under `.ai/`; the guards were re-run after them (§6).

## 4. Upstream

`git ls-remote` at 14:15:54Z returned `eddb6aca993f…` for `HEAD` and `main`, so the target is unchanged. On the app remote: `origin/merged` is `c87b90a` (local `merged` is 1 ahead, at `8e641e9`), `origin/main` is `e71e9a1`, and `origin/dev` is `a5b8228`. None has moved.

## 5. `verify_guards.ps1`: recommendation (not applied)

- **Gap.** The pin guard's two tests were mutation-proven by hand in CW01 (`CW01_REPORT.md` §4) but are not in the repeatable proof harness. Today the harness proves 11 guards: 6 scratch-file probes and 5 edit probes.
- **Smallest safe change.** Two entries appended to `$editProbes`, which reuses the existing backup → replace → restore → SHA-256 machinery unchanged:
  1. **LF:** `contract/realtime.md` (the smallest vendored file), `From = '# Realtime contract'`, ``To = "# Realtime contract`r"``. A single CR fails the "every vendored contract file is LF" test.
  2. **Version:** `contract/SOURCE.md`, `From = 'info.version at this pin: '`, `To = 'info.version at this pin: 0.'`. This works at any pin, so it never goes stale on a re-vendor.
  3. Two comment fixes: the header's "Five probes must edit a real file" becomes "Seven" with the two paths named, and the section comment `7..11` becomes `7..13`. The header's separate "Four probes create a scratch file" is pre-existing drift (there are 6); fix it in the same edit only if the owner wants.
  4. Keep CRLF, since `.gitattributes` sets `*.ps1 eol=crlf`; write it with a byte-exact patch script.
- **Scope.** This is its own fifth commit, `test(guards): …`, landed **after** 4. It is not part of CW01, whose evidence stays as recorded. It is not part of commit 2 either, because there the probe would hit "no test matches" (the guard arrives in 4). Validate it with `powershell -ExecutionPolicy Bypass -File tool/verify_guards.ps1`, which should report **13/13 proved**, followed by an unchanged-fingerprint check.
- **One judgement call for the owner.** Probe 1 transiently edits a vendored file. It is restored byte-exactly and the harness exits non-zero if the restore fails. D-022 says `contract/` is "edited by nothing else". The alternative is probe 2 only, leaving the LF test proven by hand.

## 6. Other review results

- **`account_banned` (item 7).** It is documented as unresolved and owed by CW02 in every place it appears: `SOURCE.md` (3.42 row, follow-up 1), `CW01_REPORT.md` §3 and §6, `COMPLETION_STATE.md`, the roadmap's CW02 row, `DECISIONS.md` D-022 and D-023, the Seif handoff, and designer item DG-03. Nothing claims it is handled. The "generic error" behaviour is now SOURCE-traced in `CW01_REPORT.md` §6.3:
  - the interceptor's default arm yields `ApiException(403, 'account_banned')`;
  - `OtpNotifier` catches `on AppException`, with no tokens written and no retry;
  - `authErrorMessage` falls through to `genericError`.
  - No test covers this path.
- **Edits made during this review** (Markdown records only):
  - `CW01_REPORT.md`: "13 schemas" became "13 bindings over 7 top-level schemas" (§3, §6.4); §6.3 gained the SOURCE trace; §6.4 explains why `00_BASELINE.md` §9's "widen bindings in CW01" did not happen.
  - `COMPLETION_STATE.md`: the active-wave line and the next action.
  - This file (new).
  - Guards re-run afterwards (see `COMPLETION_STATE.md`).
- **Hooks are not active in this clone.** `core.hooksPath` is unset and there is no `.git/hooks/pre-commit`, so a real `git commit` will not run the hook. Its checks were emulated per commit (§3).

## 7. Risks

- **R-a** The commits would make local `merged` 5 ahead of `origin/merged` (or 6 with the probe commit). Pushing is a separate owner decision.
- **R-b** A 0.9 MB report enters history if R-2 is yes. The largest tracked audit file today is 356 KB (`test-results.md`).
- **R-c** The Seif and designer handoff drafts (`02_`, `03_`) are not sent, but they would enter history. The repo is private, and the GitHub connector session (Seif's account) gets 404 on it (from memory, 2026-09; not re-checked).
- **R-d** The live records (`COMPLETION_STATE.md`, `CW01_REPORT.md`) will still say "uncommitted" right after the commits. Refresh them with the hashes in a follow-up (R-5).

## 8. Owner decisions needed before any commit

- **R-1** Authorise commits 1–4 in this order (the exact contents are in §1, with the messages in the session report).
- **R-2** Include `PRE_EXECUTION_DISCOVERY.md` in commit 3? Recommended: **yes**. It is cited by D-022 and five records, and no secrets were found.
- **R-3** `level_up_master_completion_roadmap.{html,json}`: recommended to **exclude** them and leave them untracked. Their later fate (move, ignore or delete) is the owner's.
- **R-4** The 2-line D-022 edit in commit 4: the status becomes "Accepted — applied by CW01 (2026-10-09)", and "`contract/SOURCE.md:17`" becomes "the uncommitted 2026-10-07 edition of `contract/SOURCE.md`".
- **R-5** After the commits, refresh the state records with the hashes, either as a sixth `docs` commit or folded into CW02's first records commit.
- **R-6** The `verify_guards.ps1` probe commit (§5): yes or no, and LF probe included or not.
