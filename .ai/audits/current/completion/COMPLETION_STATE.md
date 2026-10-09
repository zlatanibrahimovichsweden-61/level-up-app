# Completion program — live state (single source of truth for CW waves)

**Last updated:** 2026-10-09T14:40Z (commit-readiness review) · Opus control-plane session "Level Up app store submission readiness".
**Protocol:** `docs/DECISIONS.md` D-024 · **contract target:** D-022 (`eddb6ac`, 3.46.0-m1) · **release-1 scope:** D-023.
**Owner verbs:** `FORMULATE` · `START WAVE <ID>` · `REVIEW` · `NEXT WAVE` · `WALK` · `STOP`. Nothing auto-advances.
**Roles:** Opus plans; Sonnet implements (subagents pinned to Sonnet; fallback Opus 4.8 → 4.7 → 4.6 only if unavailable, reported); Fable audits at agreed checkpoints.
**Context rule:** checkpoint this file at ~40% context; compaction before 45%; after compaction re-read this file + the files of the active wave.

## Deliverables of CW00 (this folder)

| File | Deliverable | State |
| --- | --- | --- |
| `00_BASELINE.md` | A — verified baseline + `eddb6ac` BUILD dry run | complete |
| `01_SAFE_WORK.md` | B — safe prerequisite-light work, executed + validated | complete, **uncommitted** |
| `02_SEIF_HANDOFF.md` | C — reply to Seif (A: facts, B: SQ-01…SQ-30, C: question→wave map, D: not-for-Seif) | draft for owner review, **not sent** |
| `03_DESIGNER_HANDOFF.md` | D — designer message (DG-01…, conflicts, HOLD H-01…H-21, return format) | draft for owner review, **not sent** |
| `04_COMPLETION_ROADMAP.md` | E — CW00–CW20 wave table (14 columns), graph, critical path, locks, gates, P0 map | v1 |
| `CW01_AUTHORIZATION.md` | owner's CW01 text, verbatim | record |
| `CW01_REPORT.md` | CW01 result: preflight, changes, contract review, gates, independent review, residual risks | complete |
| `COMMIT_READINESS.md` | CW00 + CW01 commit-readiness review: file accounting, 4-commit split rebuilt and gated per layer, `verify_guards` recommendation, decisions R-1…R-6 | complete |
| this file | live state + F (first-wave recommendation) | live |

## Active wave

**CW01 COMPLETE, UNCOMMITTED. Awaiting owner REVIEW** (2026-10-09T13:12–13:40Z; record: `CW01_REPORT.md`).
Status **PASS WITH WARNINGS**: every gate passed; the warnings are that nothing is committed and that `account_banned` is
unhandled (CW02). CW02 is **not** started and will not start without `START WAVE CW02`.
- **Commit-readiness review done (2026-10-09T14:40Z, `COMMIT_READINESS.md`).** The 4-commit split was rebuilt and gated
  layer by layer: 2079 → 2079 → pass → **2081/0/0**, and the final tree is byte-identical to the working tree. Upstream is
  still `eddb6ac`. Nothing was staged or committed. Awaiting owner decisions R-1…R-6.
- The contract is pinned at `eddb6ac` (3.46.0-m1). The 4 blobs are hash-equal to upstream with 0 CR. `SOURCE.md` is
  rewritten (census 86/86/0/4 → 82, LF corrected, blob ids recorded, 3.38→3.46 delta).
- New guard `test/guards/contract_pin_test.dart` (+2), mutation-proven.
- The `lib/dev/mock_backend.dart` pin comment was corrected (comment only).
- Gates (final tree): format 371/0; analyze 0; contract guard 14/14; guards 124; `validate.sh` **2081/0/0** OVERALL PASS.
- Independent review by `claude-sonnet-5-5`: 0 blocker, 0 major, 3 minor + 4 nits; 5 fixed, 1 partly fixed, 1 recorded.

## Repository state at CW00 close

- Branch `merged` @ `8e641e9` (1 docs-only commit ahead of `origin/merged` `c87b90a`); nothing committed or pushed by CW00
  or CW01.
- **Changed by CW01 (uncommitted):** `contract/{openapi.yaml,contract-changelog.md,error-codes.md,realtime.md,SOURCE.md}`
  (now `eddb6ac`, replacing the earlier uncommitted 3.38 copy), `test/guards/contract_pin_test.dart` (new),
  `lib/dev/mock_backend.dart` (comment only). CW00's 16 files were sha256-verified unchanged by CW01. Fingerprints at
  CW01 close: porcelain `df2d5d1d…`, diff `a8671069…`.
- Pre-existing, **not touched by CW00**: the 5 `contract/*` files (uncommitted 3.38 re-vendor, blob-identical to `65245be`;
  re-checked at CW00 close), `PRE_EXECUTION_DISCOVERY.md`, `level_up_master_completion_roadmap.{html,json}`.
- **Changed by CW00 (uncommitted):**
  - code: `lib/core/network/dio_client.dart`, `lib/core/network/interceptors/error_interceptor.dart`;
  - tests: `test/core/network/dio_client_test.dart` (new, +4), `test/core/network/error_interceptor_test.dart` (+8);
  - tooling: `tool/validate.sh`, `.githooks/pre-commit`;
  - docs: `docs/DECISIONS.md`, `docs/RISKS.md`, `docs/KNOWN_BUGS.md`, `docs/RELEASE_SIGNING.md`, `assets/fonts/README.md`,
    `.ai/audits/current/implementation_waves.md`, `.ai/audits/current/wave_state.md` (append-only);
  - new folder `.ai/audits/current/completion/` (this program's records).
- Suggested commit split **if the owner asks** (one concern each; never `git add -A` while `contract/` is dirty):
  (1) `fix(network)`: dio_client + error_interceptor + the two test files; (2) `chore(tooling)`: validate.sh + pre-commit;
  (3) `docs`: DECISIONS/RISKS/KNOWN_BUGS/RELEASE_SIGNING/fonts README/implementation_waves/wave_state + `completion/`.
  (4) `chore(contract)`, CW01's own commit: the 5 `contract/` files + `test/guards/contract_pin_test.dart` +
  `lib/dev/mock_backend.dart`, after re-running `git ls-remote` (must still be `eddb6ac`). Commit (3) must land with or
  before (4), because `SOURCE.md` cites `completion/` files. D-022's status line flips to "applied" with (4).

## Validation at CW00 close (BUILD, 2026-10-09T12:47Z)

`tool/validate.sh` (output redirected; tracked `test-results.md` untouched): **OVERALL PASS**: format 324 files 0 changed (batched, C10 proven), analyze 0, **2079 passed / 0 failed / 0 skipped**. Filesystem format 370/0 changed. Guards 122. Details: `01_SAFE_WORK.md` §2. Fingerprints at close: `git diff | sha256sum` = `caea4c5f…d5d7`, `git status --porcelain | sha256sum` = `d155bcfe…f1`.

## Owner decisions requested now (in priority order)

| # | Decision | Why now | Default if silent |
| --- | --- | --- | --- |
| O-1 | ~~`START WAVE CW01`~~ **done 2026-10-09**; now `REVIEW` CW01 (`CW01_REPORT.md`) | Root of the critical path | stays uncommitted |
| O-2 | Commit the CW00 changes? (split above) and whether CW01 ends in its own commit | Commits only on request (D-024) | left uncommitted |
| O-3 | Review + send `02_SEIF_HANDOFF.md` (A.1 + A.4 + B) and `03_DESIGNER_HANDOFF.md`; may the SQ list be filed into `docs/seif_fight.md`? | Seif/designer answers are the long lead items for CW04–CW20 | not sent, not filed |
| O-4 | WALK substrate for new surfaces: staging with seeded accounts (SQ-14…SQ-16) vs extending the mock first (discovery B-3(d)) | Decides CW02+ verification plan | mock extended per wave, staging check where seeded |
| O-5 | `CLAUDE.md` facts-only refresh (C6) | Every session reads stale counts | unchanged |
| O-6 | Remove the two idle worktrees now that their patch is ported (C10) | Housekeeping | kept |
| O-7 | Fable checkpoint cadence (roadmap §6 proposes CW01 pin audit, T02, each legal/deletion wave, RC) | D-024 says "agreed checkpoints" | proposal stands |

Longer-lead owner items (Firebase ownership + R-9 gate, a Mac + Apple team, Play account type, keystore custody,
Message-tab composition, referral reward copy, subscription-status screen yes/no, Terms gate shape, support contact
for banned users) are listed with their waves in `04_COMPLETION_ROADMAP.md` §5 and `02_SEIF_HANDOFF.md` §D.2.

## Stable ID maps

- Seif questions **SQ-01…SQ-30** (SQ-19 retired → SQ-24(l)) → waves: `02_SEIF_HANDOFF.md` §B/§C. When Seif answers,
  record the answer against its SQ id here, then update only the affected wave rows in the roadmap.
- Designer items **DG-nn** and holds **H-01…H-21**: `03_DESIGNER_HANDOFF.md`. New frames are recorded against their DG id.
- Discovery cross-refs: tracks T01–T21, I-/N-/DC-/AA- ids in `PRE_EXECUTION_DISCOVERY.md`.

## Answers received log

| Date | From | ID | Answer (verbatim or file) | Waves affected | Recorded in |
| --- | --- | --- | --- | --- | --- |
| 2026-10-09 | Owner | O-1 | CW01 authorized with preflight/validation/stop conditions (`CW01_AUTHORIZATION.md`); `/compact` first; no commit, push or promotion; no auto-advance to CW02. O-2…O-7 not yet answered (O-2 commits: still no). | CW01 | this file |

## F — Initial execution recommendation: **CW01, contract re-vendor to `eddb6ac`**

- **Why first:** every contract-backed wave (CW02–CW16) has a hard ordering edge from it (discovery §17.4); the committed
  pin `0df5cf4` lacks 3.29–3.46, and the dirty 3.38 copy lacks push, `account_banned`, legal documents, referral and
  the photo/avatar flips.
- **What it completes:** the four contract files byte-identical to `eddb6ac` (LF, `git show`), `contract/SOURCE.md`
  rewritten for the new pin with the false CRLF sentence corrected, a re-census recorded (86/86/0/4 → 82), the mock's
  pin comment updated, and the contract-model guard widened where 3.46 adds required fields the app already decodes
  (bindings for not-yet-consumed schemas land with their consuming waves).
- **What it does not depend on:** no Seif answer, no designer frame, no Mac, no Firebase, no keystore, no device.
- **What it unblocks:** CW02 (`account_banned`), CW04 (`getLegalDocument`), CW07–CW16 (all ops stable at 3.46).
- **What could go wrong:** upstream moves again (re-run `ls-remote` at start and before any commit; report, never move
  silently); a CRLF copy breaks 13/14 guard tests with a misleading error (copy only via `git show`); `git add -A`
  sweeps foreign files; the guard stays green while blind to unbound schemas.
- **Evidence it is low-risk:** the CW00 BUILD dry run at `eddb6ac` already passed (analyze 0, guard 14/14, 2067/0,
  guards 122, no drift) — `00_BASELINE.md` §9.
- **How it is reviewed:** blob-hash equality + 0 CR bytes; guard alone; full suite ≥ the CW00 close count; diff confined
  to `contract/` + guard/mock-comment files; Fable pin-integrity audit if the owner keeps that checkpoint; CI read only
  after an authorised push.
- **Owner command to start it:** `START WAVE CW01`

## Next action

**Owner answers `COMMIT_READINESS.md` §8 (R-1…R-6): authorise the 4 commits (and the D-022 edit, discovery-report
inclusion and probe commit), or keep everything uncommitted.** Then `START WAVE CW02` when ready. Nothing advances on its own.
