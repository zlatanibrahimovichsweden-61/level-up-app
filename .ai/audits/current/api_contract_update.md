# API contract update — 2026-09-24

**Stage:** Phase 1 (contract + endpoint investigation). Investigation-only for `lib/` and `test/`.
**Baseline:** branch `merged` @ `e4d1401` · tree clean except two untracked files owned by another
session (`project_files_forensic_audit.html`, `project_files_inventory.json`, untouched).
A stale 0-byte `.git/index.lock` (dated 2026-09-22 19:17, no git process alive) is present; this
audit did no index work and left it in place.

## Source of truth

| | Value |
| --- | --- |
| Upstream repo | `https://github.com/seifhamdii-collab/level-up-contract` (public, anonymous git) |
| Upstream branch | `main` |
| Upstream HEAD | `ea830990b0c3b7778b31a81ee83a0f011f2de122` (2026-09-23 23:16 UTC, mirrors backend `03dd474a`) |
| Previous pin | `768e67d` — `info.version` **3.22.0-m1**, vendored 2026-09-20 (commit `aeb22fc`) |
| New pin | `ea83099` — `info.version` **3.23.0-m1**, vendored 2026-09-24 |
| Local clone used | `F:\level\level_up\level_up\level-up-contract` (`git fetch origin`, working tree untouched) |

**Integrity:** before re-vendoring, all four vendored files were byte-identical (sha1) to `768e67d`.
After re-vendoring, all four are byte-identical to `ea83099`:

| File | Changed? | sha1 (12) at new pin |
| --- | --- | --- |
| `openapi.yaml` | yes (+62/−1) | `3633985d0731` |
| `contract-changelog.md` | yes (+9) | `340c6b14ef3d` |
| `error-codes.md` | no | `f942da4287ac` |
| `realtime.md` | no | `cc63adb3b41b` |

`contract/SOURCE.md` was updated with the new pin, census and delta. Admin files
(`openapi-admin.yaml`, `error-codes-admin.md`, `contract-changelog-admin.md`) are deliberately not
vendored (adr-050); upstream commits `bc27953` and `200073c` touch only those.

## Delta 768e67d → ea83099

| Class | Operations |
| --- | --- |
| **New** | `GET /me/terms-acceptance` `getTermsAcceptance` (**draft**) · `POST /me/terms-acceptance` `acceptTerms` (**draft**) |
| Modified | none (only `info.version`) |
| Removed | none |
| Stability changed | none |
| Deprecated | none (the contract has no deprecation marker in use) |
| `x-behaviour-changed` added | none |
| Error codes | unchanged (`error-codes.md` byte-identical) |
| Breaking | **no** — purely additive, both drafts |

Terms-acceptance facts to carry forward (from the changelog entry and the operation text):
inert in every environment until the server configures a version (`currentVersion: null`, every
accept → `400 validation_failed`); the app must send back exactly the server's `currentVersion`;
server records the time; idempotent (`204` on repeat); recorded, not enforced; the backend serves
no Terms text or link; it is the student's own acceptance, **not parent consent**. Both flip to
`stable` in a later, separate entry. **Not buildable at this pin.**

## Operation census at the new pin (parsed with PyYAML, not grep)

| | stable | draft | total |
| --- | --- | --- | --- |
| 768e67d (3.22.0-m1) | 33 | 14 | 47 |
| **ea83099 (3.23.0-m1)** | **33** | **16** | **49** |

Of the 33 stable operations, **3 are `x-consumers: [web]`** and forbidden to the app
(`requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `redeemSubscriptionCode`), so **30
stable operations are app-buildable**. Operation-level extension keys in use:
`x-stability`, `x-consumers`, `x-behaviour-changed` only (no entitlement or rate-limit extension —
gating and `429` are expressed in prose and response codes).

`x-behaviour-changed` is stamped on 5 stable operations: `listSubjects`, `getSubjectTree`,
`createQuiz`, `getLeaderboard`, `getMyRank` (plus web-only `redeemSubscriptionCode`). None of these
stamps is new in this delta.

## Flutter impact

- **Build/behaviour impact: none expected.** No operation the app calls changed; no schema changed.
- **Guard impact:** `test/guards/contract_models_test.dart` reads `contract/openapi.yaml`; the
  delta adds no schema it binds. Confirmed by the validation run below.
- **Comment drift:** the new path is inserted after old line 913, so `openapi.yaml:NNN` citations
  in `lib/` and `test/` that point past ~913 are now off by **+61** (e.g.
  `lib/core/router/app_router.dart:154-155` and `lib/dev/mock_backend.dart:224-225` cite
  `openapi.yaml:2007` for `getLeaderboard`). Those citations already mixed several older pins.
  Not fixed here: comment-only, and this stage makes no source edits.
- **Stale header comments noticed (not fixed):** `lib/dev/mock_backend.dart:17-18` and
  `test/features/quiz/quiz_fixtures.dart:1` still say the contract is "pinned `184d6ec`, v3.0.0-m1".

## Validation

`tool/validate.ps1` run on the re-vendored tree, 2026-09-24 (full record in `test-results.md`):

```
format   : PASS
analyze  : PASS (0 issues)
tests    : PASS (1429 passed / 0 failed / 0 skipped)
OVERALL  : PASS
```

1429 equals the last recorded count (`docs/WAVE_STATUS.md`, 2026-09-22), so nothing regressed and
no test was added or dropped. **Level: BUILD VERIFIED.** The contract guard
(`test/guards/contract_models_test.dart`) is inside that run and passed. Nothing is committed.
