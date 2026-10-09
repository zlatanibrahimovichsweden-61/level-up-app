# CW01 — owner authorization (verbatim, 2026-10-09)

Recorded by the control-plane session before the owner-run `/compact`, so the instruction survives compaction intact.
State at recording: `merged` @ `8e641e9`; `git status --porcelain | sha256sum` = `d155bcfe…f1`; `git diff | sha256sum` =
`caea4c5f…d5d7` (identical to the CW00 close fingerprints in `COMPLETION_STATE.md`). CW01 had **not** started.

---

Proceed with CW01 only, the contract re-vendor to `eddb6ac` / `3.46.0-m1`, subject to the preflight checks below.
Before starting, run `/compact` and use `COMPLETION_STATE.md` as the primary checkpoint. Re-read `00_BASELINE.md`, `01_SAFE_WORK.md`, `DECISIONS.md`, and the relevant contract workflow instructions.

**Preflight requirements**

1. Re-check the actual branch, HEAD, working tree, staged changes, untracked files, and relevant diffs. Do not assume the discovery report is still current.
2. Identify and preserve every existing change from the completed safe-work phase. Do not overwrite, discard, or silently combine unrelated changes.
3. Verify that `eddb6ac` is still the approved target and inspect the exact upstream files and metadata before copying anything.
4. Confirm the expected contract file set and source revision. Do not re-vendor from a moving branch or silently select a newer version.
5. If the target, source integrity, working-tree ownership, or expected file set differs materially from the approved plan, stop and report the discrepancy before modifying contract files.

**Execution**

* Perform CW01 only.
* Re-vendor the approved contract snapshot into `contract/`.
* Correct the `SOURCE.md` line-ending statement as part of this authorized re-vendor: verify the actual upstream blob line endings rather than repeating the existing CRLF claim.
* Keep generated artifacts, unrelated documentation cleanup, feature implementation, and other waves out of scope.
* Do not change the approved contract target without explicit authorization.
* Do not commit, push, promote branches, or automatically advance to CW02.

**Validation and review**

* Run the required formatting, analysis, test, contract, and guard checks.
* Report exact command results, passed/failed/skipped counts, and any differences from the verified pre-change baseline.
* Inspect the complete contract diff, including deleted, added, renamed, and unexpectedly changed files.
* Verify that the source revision and the checked-in snapshot agree.
* Distinguish tests actually run from dry-run evidence. Do not claim a full build or device walk unless it was actually performed.
* Ask the available Sonnet subagent to review the completed diff independently, then reconcile its findings with your own review. Report the actual model identifier exposed by the harness; do not invent a model version.
* If any gate fails, diagnose and fix only issues within CW01, rerun the relevant gates, and report any unresolved failures honestly.

**Stop condition**

At completion, update the live state and wave artifacts with verified results, list all changed files, and provide:

1. Implementation summary.
2. Validation evidence and exact counts.
3. Independent review findings and dispositions.
4. Remaining risks or blockers.
5. A clear `PASS`, `PASS WITH WARNINGS`, or `BLOCKED` status.
6. The exact next owner action required.

Then stop. Do not begin another wave until I explicitly authorize it. Keep context usage below 45%, with compaction initiated at 40%.

---

## Lead notes for the post-compaction session (not owner text)

- **Pre-change baseline to compare against** (CW00 close, BUILD, `validate.sh` with redirected output): format 324 tracked
  / 370 filesystem files, 0 changed; analyze 0; **2079 passed / 0 failed / 0 skipped**; guards 122; contract-model guard
  14/14 (at 3.38 files). Dry-run at `eddb6ac` (CW00, before the 12 new tests): guard 14/14, 2067/0, guards 122.
- **Expected source:** `eddb6aca993f1edeef49a03fd1f2454c314b645e`, 3.46.0-m1, mirrored 2026-10-08T14:56:03Z from
  `level-up-backend@a158daa`. Expected blob ids: `openapi.yaml` `5af03f92…`, `contract-changelog.md` `4f0a1c26…`,
  `error-codes.md` `08dfaceb…`, `realtime.md` `ff05c7ac…`. Upstream blobs have 0 CR bytes.
- **Copy method:** `git -C F:/level/level_up/level_up/level-up-contract show eddb6ac:<file> > contract/<file>` (never the
  clone's working tree; never a CRLF checkout). Check `git ls-files --eol contract/` and `.gitattributes` first, so the
  working copy's line endings match what git will store.
- **CW00 changes to preserve, untouched by CW01:** see `COMPLETION_STATE.md` "Changed by CW00".
- **Context:** CW01 can stay lean if the independent diff review goes to one Sonnet subagent and large files are never
  read whole (the openapi diff is ~1.5k lines; review it by section/grep).
