# CW01 — contract re-vendor to `eddb6ac` (3.46.0-m1): result record

**Date:** 2026-10-09 (13:12–13:40Z). **Authorisation:** owner, verbatim in `CW01_AUTHORIZATION.md`. **Executed by:** the Opus
control-plane session (lead), single-threaded. Only the independent diff review was delegated, to one Sonnet subagent (§5).
**Status:** complete, **uncommitted**; no commit, push or promotion; CW02 not started.

## 1. Preflight (all passed; no discrepancy, so nothing was escalated)

| # | Check | Result |
| --- | --- | --- |
| 1 | Branch / HEAD / staged / tree | `merged` @ `8e641e9`; `origin/merged` `c87b90a`; nothing staged. `git status --porcelain \| sha256sum` = `d155bcfe…1bff1`, `git diff \| sha256sum` = `caea4c5f…deb5d7`, **identical to the CW00 close**. |
| 2 | CW00 work preserved | 16 non-contract changed or untracked files sha256-snapshotted before any edit (`scratchpad/cw01_preserve_before.txt`). Re-checked after CW01: **16/16 unchanged**. |
| 3 | Target still approved and current | `git ls-remote …/level-up-contract HEAD refs/heads/main` → `eddb6aca993f…` at 13:12Z and again at 13:15Z, immediately before the copy. Commit by `level-up-backend-ci`, 2026-10-08T14:56:03Z, "Mirror contract from level-up-backend@a158daa…". `65245be` is an ancestor (13 commits; 10 touch mobile files, 3 admin-only). |
| 4 | File set and source revision | Upstream tree has 7 files. The 3 `*-admin*` files were also present at `0df5cf4` and `65245be` and were never vendored, so the vendored set is unchanged: `openapi.yaml`, `contract-changelog.md`, `error-codes.md`, `realtime.md`. `info.version` 3.46.0-m1. Blob ids `5af03f92` / `4f0a1c26` / `08dfaceb` / `ff05c7ac` as planned. 0 CR bytes in each upstream blob. |
| 5 | Line-ending plumbing | `.gitattributes` `* text=auto eol=lf`; `core.autocrlf=true`; `git ls-files --eol contract/` = `i/lf w/lf` for all 5. Pre-CW01 working copies were blob-identical to `65245be`. |

## 2. What changed (complete list, all uncommitted)

| File | Change |
| --- | --- |
| `contract/openapi.yaml` | `git show eddb6ac:openapi.yaml` (vs the 3.38 copy: +819/−72; vs HEAD: +2018/−188; 4,188 → 4,935 lines) |
| `contract/contract-changelog.md` | `git show eddb6ac:…` (+133/−0 vs 3.38: append-only) |
| `contract/error-codes.md` | `git show eddb6ac:…` (+16/−4; 50 → 62 codes, none removed) |
| `contract/realtime.md` | `git show eddb6ac:…` (+52/−5) |
| `contract/SOURCE.md` | New pin header, `info.version` line, census 86/86/0/4 → 82 (19 public), the four blob ids recorded, **LF statement corrected** (verified: upstream is LF at `0df5cf4`, `65245be` and `eddb6ac`; the old "CRLF exactly as upstream stores them" was never true), new "Delta from 3.38.0-m1" section (8-row version table, wire-shape audit, 5 follow-ups, line drift), the 3.38 section retitled as history (never committed), a dated staging `/health/version` paragraph, and the admin-files history sentence. |
| `test/guards/contract_pin_test.dart` | **New guard**, 2 tests: 0 CR bytes in the 4 vendored files; `SOURCE.md`'s `info.version at this pin:` equals `openapi.yaml`'s, and a `Pinned commit: <sha>` line exists. |
| `lib/dev/mock_backend.dart:19-22` | Comment only: "pinned `f462968`" became "written against `f462968` …; the pin has moved since — `contract/SOURCE.md` names the current one". The mock was not re-audited at 3.46, so the comment does not claim it was. |

No adds, deletes or renames under `contract/`. `pubspec.yaml` and `pubspec.lock` are unchanged. No generated file, model, fixture, ARB or other doc was touched.

## 3. Contract review (lead)

- **Census** (PyYAML, `scratchpad/census.py 65245be eddb6ac`): 77 / 53 stable / 24 draft / 4 web-only → 49 became 86 / 86 / 0 / 4 → **82**. 19 public. +9 operations, none removed; 24 draft→stable flips; 33 newly app-buildable.
- **Wire audit** (`scratchpad/wire_audit.py`, descriptions and examples stripped):
  - 10 schemas added, none removed.
  - 8 pre-existing schemas changed: `ChatMessage`, `SupportTicket` and `SupportTicketMessage` got new required fields; `AuthenticatedResult`, the two registrations and the two support requests got new optional fields.
  - 8 pre-existing operations changed responses (+`403` on 4 sign-in operations, among others).
  - **None of the schemas bound in `contract_models_test.dart` (13 bindings over 7 top-level schemas) changed shape.** The app decodes only `AuthenticatedResult`, which gained an optional field that the decoder ignores (no `disallowUnrecognizedKeys` in `lib/`). It sends the registration bodies, which gained an optional `inviteCode` the app does not send.
- **The 72 deleted `openapi.yaml` lines, classified:** 24 `x-stability: draft`, 1 `version`, 17 description or summary keys, 27 prose or other, and 3 `required:` lists (each re-added wider: `SupportTicket`, `SupportTicketMessage`, `ChatMessage`). `StudentProfile.avatar` `id`/`url` changed in description only; type and format are unchanged.
- **Behavioural item for the app as built:** `verifyOtp` `403 account_banned` (3.42.0-m1). There is no handling in `lib/` (grep: 0 matches). Owed by CW02.

## 4. Validation (BUILD, this tree; nothing here is DEVICE or CI)

| Gate | Command | Result | vs pre-change baseline |
| --- | --- | --- | --- |
| Format, filesystem (incl. untracked) | `dart format --set-exit-if-changed --output=none lib test tool` | 371 files, 0 changed, rc 0 | 370 → 371 (+ the new guard) |
| Analyze | `flutter analyze --no-pub` | No issues | = 0 |
| Contract-model guard alone | `flutter test test/guards/contract_models_test.dart` | **+14, all passed** (at the 3.46 files) | = 14/14 (was at the 3.38 files) |
| Pin guard alone | `flutter test test/guards/contract_pin_test.dart` | **+2, all passed** | new |
| All guards | `flutter test test/guards` | **+124, all passed** | 122 → 124 (+2 new) |
| Dependencies | `git diff --quiet -- pubspec.lock pubspec.yaml` | unchanged | = |
| Full gate (13:22:24–13:24:56Z) | `LEVELUP_VALIDATE_OUT=<scratch> sh tool/validate.sh` | **OVERALL: PASS**, rc 0: format 324 tracked files in 3 batches (148/142/34), 0 changed; analyze 0; **2081 passed / 0 failed / 0 skipped**. Tracked `test-results.md` untouched. | 2079 → **2081** (+2 = the new guard; nothing else moved) |

The full-suite log cannot prove that a given file ran (expanded-reporter lines are in-flight names). The pin guard's 2 tests are proven by its own run (+2) and by the count delta. The `validate.sh` format step skips untracked files, so the new guard's format is proven by the filesystem run (371/0).

**Mutation probes for the new guard** (each restored afterwards and hash-verified; the 4 blobs re-verified equal to `eddb6ac` after all probes):

- (A) CRLF injected into `openapi.yaml` (4,935 CR bytes):
  - pin guard **fails**, by name: "contract/openapi.yaml holds 4935 CR bytes. Upstream stores it as LF; re-copy it with `git … show …`";
  - `contract_models_test` fails **13 of 14** with the misleading ``ContractShapeException: no `required:` at indent 6 for StudentProfile``.
  - This proves both the hazard and the new guard's value.
- (B) `SOURCE.md` version line set to 3.45.0-m1: pin guard **fails** ("SOURCE.md and openapi.yaml disagree about the pinned version").

**Not performed:** no full app build (APK/AAB), no device walk, no CI run (nothing pushed). Staging was read once, unauthenticated: `GET /health/version` → backend `a158daa…`, built 2026-10-08T15:16:14Z. No operation was probed.

**Final-tree re-run** (13:30:50–13:33:37Z, after the review fixes in §5):
- filesystem format 371/0, rc 0;
- guards +124;
- `validate.sh` OVERALL PASS, rc 0: analyze 0, **2081 / 0 / 0**;
- `ls-remote` still `eddb6aca993f`;
- 4/4 blobs MATCH with 0 CR;
- the 16 preserved files are unchanged;
- nothing staged; `pubspec.*` and the tracked `test-results.md` are clean.

Fingerprints at close: `git status --porcelain | sha256sum` = `df2d5d1df18782d4…`, `git diff | sha256sum` = `a8671069faeecfa3…`.

## 5. Independent review

**Reviewer:** one read-only `general-purpose` subagent with `model: sonnet`. It reported its own identifier, from its system prompt, as **`claude-sonnet-5-5`** ("Sonnet 5.5"). No fallback model was used. It ran 46 tool calls, read-only: no edits, and no `flutter`/`dart` (the suite was running).

**Checklist (A–H):** all VERIFIED, with no BLOCKER or MAJOR:
- blob identity and 0 CR;
- the upstream target and the 13-commit count;
- the census, the table rows, the wire audit, the 12 codes, line drift and the app claims, all re-derived independently with PyYAML and grep;
- LF at all three pins (12/12 blobs);
- the pin guard's regexes against the real files;
- the mock comment is comment-only and true;
- scope: 16/16 preserved, nothing staged, no strays.

| # | Sev | Finding (reviewer) | Lead verification | Disposition |
| --- | --- | --- | --- | --- |
| 1 | MINOR | `SOURCE.md` and the guard's doc comment cite "the sentence this replaces" (CRLF), but that sentence was never committed; after commit the reference dangles | Confirmed: `git log --all -S"CRLF exactly as upstream" -- contract/SOURCE.md` = 0; HEAD's `SOURCE.md` has 0 "crlf" | **Fixed:** both now say "the uncommitted 2026-10-07 edition" |
| 2 | MINOR | 3.46 row: "presigned PUT must never go through the signed-in Dio client" is unattributed (the contract says only: straight to storage, exactly `upload.headers`) | Correct; it is an owner rule, not contract text | **Fixed:** states the contract fact and attributes the rule to the owner's 2026-10-09 brief, with the reason |
| 3 | MINOR | "No bound schema changed" is true of shape but not of prose: `StudentProfile.school.parentReportStatus` meaning (3.42, spec-071) and `avatar.id`/`url` descriptions | Confirmed; the field is modelled at `student_profile.dart:224`; mock serves `inactive`; no screen reads it | **Fixed:** "changed shape" plus a sentence naming both prose changes |
| 4 | NIT | 3.41/3.42 behavioural changes (incl. `account_banned`) carry no `x-behaviour-changed` stamp; stamps at `eddb6ac` exist only for 3.43 (×5) and 3.45 (×1) among new versions | Confirmed by counting stamps in `openapi.yaml` | **Fixed:** the 3.42 row says so, and adds the `updateMyProfile` default-avatar note |
| 5 | NIT | "`core.autocrlf=true` can write CRLF there": the clone's own config is `input` (system is `true`); its checked-out `realtime.md` is `w/crlf` anyway | Confirmed (`git config --show-origin`, `ls-files --eol`) | **Fixed:** "a clone's checkout … can hold CRLF (the local clone's checked-out `realtime.md` does)" |
| 6 | NIT | Version regex not anchored to `info:`; a quoted version would false-fail; only commit presence is checked. Suggest recording blob ids | The regex matches only line 28; a quoted version fails **loudly**, never silently; no guard in `test/guards` shells out to git (no precedent), and `crypto` is transitive-only | **Partly fixed:** the four blob ids are now recorded in `SOURCE.md` (`git hash-object` re-checks them without a clone). **Declined:** regex hardening and a git-shelling identity test, because they would be beyond the wave and the current failure mode is loud (offered as an option, §6) |
| 7 | NIT | `SOURCE.md` cites untracked `completion/` files, so they must land together; the roadmap's CW02 row still lists the Accept/comment fixes | The roadmap's lead amendment (line 5) already moves those two items to CW00 | **No file change.** It is recorded as a commit-ordering constraint in `COMPLETION_STATE.md` (O-2) |

Lead's own review agreed with the reviewer on every VERIFIED item, and found no defect the reviewer missed.

## 6. Residual risks and open items (none blocks CW01)

1. **Uncommitted.** Every CW01 and CW00 change lives only in the working tree, so a stray `git checkout`/`stash` would lose it. Commit only on the owner's word (O-2). The CW01 commit must not precede the docs commit that adds `.ai/audits/current/completion/`, because `SOURCE.md` cites it.
2. **Upstream can move again.** Re-run `git ls-remote` immediately before any commit. If HEAD is no longer `eddb6ac`, report it and do not re-target (D-022).
3. **Behavioural gap in the app as built:** `verifyOtp` `403 account_banned` (3.42) has no handling in `lib/`, and it has no stamp. A banned student currently gets the generic error path. Verified at SOURCE level only, by reading the path (no test covers it, 2026-10-09):
   - `ErrorInterceptor`'s default arm yields `ApiException(403, 'account_banned')`;
   - `OtpNotifier.verify` catches it `on AppException`, writes no tokens and does not retry;
   - `authErrorMessage` has no `account_banned` case and falls through to `l10n.genericError`.

   This is the first P0 item of CW02.
4. **The guard's reach is unchanged:** 13 bindings over 7 top-level schemas. `00_BASELINE.md` §9 anticipated widening them in CW01; the roadmap's CW01 row and the owner's scope instead place new bindings with their consuming waves, so none was added. Not yet bound: not-yet-decoded schemas (`ChatMessage`, `SupportTicket*` and the 10 new schemas) are unbound until their waves.
5. **The pin guard is not wired into `tool/verify_guards.ps1`.** Its mutation proof was manual (§4). Wiring it there, and optionally a `git hash-object` identity test, is a small follow-up for the owner to authorise.
6. **No DEVICE or CI evidence.** Nothing was built to an APK, walked on a device or pushed. Staging was read only via `/health/version`.
7. **Docs not touched by design** (owner: no unrelated documentation cleanup):
   - `docs/DECISIONS.md` D-022 still says "not yet applied (CW01)". It is a CW00-modified file; flip it with the commit.
   - `docs/WAVE_STATUS.md`, `docs/seif_fight.md` (S11, S24, S36) and `docs/ENFORCEMENT.md` (new guard) are not updated.
   - `openapi.yaml:NNN` citations in `lib/`/`test/` are approximate (drift documented in `SOURCE.md`).
