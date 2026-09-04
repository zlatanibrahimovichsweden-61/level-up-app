# Wave Status — the single source of project truth

**Last updated:** 2026-09-04 (contract v3.0.0-m1 adopted; purchase surface removed; staging re-probed)
**Branch:** `merged` — `dev` + `main` joined on 2026-08-22 (`99b5cba`); both are kept
untouched as history and all work continues on `merged`.
**Unpushed:** the 2026-08-23 commits (style-fitting pass, OTP glyph landing, F-7-01,
smoke harness ×2) and the 2026-09-04 commits (contract 3.0.0-m1, model adoption,
purchase-surface removal, limit-sheet copy, records) — pushing is the owner's call (R-3). This file no longer
records a HEAD; `git log` is the source for that.

If any other document disagrees with this file about wave state, **this file
wins** and the other document is stale. Fix the other document.

---

## Verification ladder

Every claim in this project carries one of these levels. They are not
interchangeable, and a lower level must never be reported as a higher one.

| Level | Means | How it is obtained |
| --- | --- | --- |
| **SOURCE VERIFIED** | The code says the right thing | reading / grep / static scan |
| **BUILD VERIFIED** | It compiles and the suite is green | `tool/validate.ps1` |
| **ARTEFACT VERIFIED** | The *built output* is correct | `aapt2` on the APK, merged manifest |
| **DEVICE VERIFIED** | It behaves correctly on real hardware | install + drive the flow |
| **CI VERIFIED** | It is green on the runner, not just locally | GitHub Actions run |

This project has been bitten **twice** by treating SOURCE as sufficient:

- **Tier-0 C-1** — the manifest source was correct and the release artefact
  still had no `INTERNET` permission.
- **Wave 2 `verify_guards.ps1`** — the file's content was verified and it still
  failed to parse, because PowerShell 5.1 *decoded* it differently.

**Reading is not running.** That is the most expensive lesson in this
repository's history and it is why the ladder exists.

---

## Waves

| Wave | Scope | Status | Commit | Verification | Fable |
| --- | --- | --- | --- | --- | --- |
| **0** | Ten-agent audit (report only) | ✅ COMPLETE | pre-`e3651e6` | n/a — investigation | — |
| **1** | Security + Release (Tier-0 C-1, C-2) | ✅ COMPLETE | `fffa563`, `4d49c7b` | **ARTEFACT VERIFIED** (aapt2 on 60.2 MB APK) + regression reproduced against old code | **APPROVED** |
| **2** | CI + hooks + enforcement | ✅ COMPLETE | `94e9c9a` … `431a08f` | BUILD VERIFIED; guards proved 6/6 | **APPROVED WITH WARNINGS** |
| **2.1** | Fable's two Wave-2 findings | ✅ COMPLETE | `9fe6098` | BUILD VERIFIED; guard proof rewritten to per-test isolation | — |
| **3A** | Lifecycle (`autoDispose` mid-`await`) | ⚠️ **PARTIALLY VERIFIED** | `e2ec9e8`, `c8688cd` | BUILD VERIFIED — but **W3-1 open**, see below | **APPROVED WITH WARNINGS** |
| **3B** | Localization | ✅ COMPLETE | `6f96cbc` | BUILD VERIFIED | **VERIFIED** |
| **3C** | Architecture / `ScreenState` | ✅ REJECTED (no work needed) | — | conclusion correct; **supporting evidence was wrong — see W3-4** | **PARTIALLY VERIFIED** |
| **3D** | **Typography** | ✅ COMPLETE (2026-08-21) | `6e2df3d`, `da794de`, `7a16307` | BUILD VERIFIED (validate.ps1 2026-08-22, 856 passed); per-commit analyze + guards in a worktree | not yet reviewed |
| **3E** | Cache / storage | ✅ COMPLETE | `ac87455` | BUILD VERIFIED | **VERIFIED** |
| **4** | Documentation + audit protocol | ✅ COMPLETE (2026-08-22) | the docs commit that carries this file | documentation only | — |
| **Final** | Whole-project Fable review | ⏳ NOT STARTED | — | — | — |

---

## Contract v3.0.0-m1 adopted — 2026-09-04

**Pin.** `contract/` re-vendored from `seifhamdii-collab/level-up-contract` at `184d6ec`
(mirror of backend `4a8e7cf`); previous pin `61905ce` (2.1.0-m1). The delta was verified by
diff, not read from the changelog: 2.2.0-m1 (adr-049/057 — checkout path deleted,
`x-consumers`, purchase-silent app), 2.3.0-m1 (adr-091 — catalog no longer
entitlement-gated, BEHAVIOURAL), 3.0.0-m1 (adr-102 — `QuizSummary` loses `totalPoints` and
`level`, BREAKING). The schema proof shows that one hunk and nothing else. Provenance detail,
including the hours the source repo was unreachable, is in `contract/SOURCE.md`.

| Commit | Concern | validate.ps1 |
| --- | --- | --- |
| `3db4f04` | contract + `SOURCE.md`; no Dart | 861 passed (predicted 861) |
| `b7d0dfb` | `QuizSummary` drops the two fields; the result screen stops drawing "Level N · P points" (D-006); mock and fixtures follow; one test added proving a 2.x body still parses | 862 passed (predicted 862) |
| `5c4b855` | purchase surface removed — Upgrade button + benefits card, `/subscription*` routes, the Profile row, six ARB keys (adr-049 §3, D-007); one generated profile test gone with its row, one added asserting absence | 862 passed (predicted 862) |
| `ce7da9a` | limit-sheet bodies stop saying upgrade/subscribe (D-007 — provisional copy) | 862 passed (predicted 862) |
| records | this file, `RISKS.md`, `seif_fight.md` S3/S8/S18/S37/S38, `DECISIONS.md` D-006/D-007, `DESIGN_ISSUES.md` #50/#51, the smoke evidence, `zna.md` | docs only |

**Staging re-probed** (backend `78c6e5d`, built 2026-09-03T15:38Z — later than the mirror
commit; the backend repo is private, so whether it carries adr-102 is unverified):
`GET /catalog/subjects` is now deployed and answers `200 []` for the test account — **13 of
21** stable operations decode (was 12); `PATCH /me` 405 and `GET /me/entitlements` 404 are
unchanged; the quiz loop (6 operations) is still gated on an empty catalog, i.e. on seed
data, not on the client. Full output: `.ai/audits/current/smoke-staging-2026-09-04.md`.

**Verification level: BUILD** (`validate.ps1` per commit, counts above) **plus the same
dev-host live-staging run as 08-23** — not DEVICE, not CI. The 3.0.0-m1 `finish` body has
not been observed on the wire; the client accepts both shapes, so nothing depends on it.

**Settled in passing.** W3-1's blocking question is answered (below). S3 had been answered by
the contract's own prose all along. The `/subscription` product decision (R-6) was made by the
contract — removed, not built.

**Deliberately not done in this wave** (listed so nobody infers they were): the silent
auto-retry on the seven registration `FutureProvider`s, `deviceInfoProvider` and
`schoolSearchProvider` (they need `retry:` returning null); the W3-1 fix itself; Day 9 quiz
review; the account-deletion screen (S38 — no endpoint); voucher redemption (`x-consumers:
[web]`, must not be built).

---

## Live staging — the stable surface exercised, 2026-08-23

**First real requests.** `tool/smoke/real_api_smoke_test.dart` now walks all 21
`x-stability: stable` operations through the real seam (`AppConfig` → `DioClient` →
interceptors → repositories → freezed decoders; only `SecureStorage` is stubbed) against
`https://level-up-backend-staging.up.railway.app/api/v1`. Run 2026-08-23 against backend
commit **`0b53cdcad20cc0029fea0f18ef2e62a980b48aca`** (`/health/version`, built
2026-08-23T10:53:37Z), staging test number `+2010000000001` (already registered, so no
account was created). Full output: `.ai/audits/current/smoke-staging-2026-08-23.md`.

| Verdict | Operations |
| --- | --- |
| **Decoded — 12** | the 7 `/reference/*` reads (incl. the deliberate EG-without-governorate 400 → typed `ValidationException[governorateId]`), `POST /auth/otp/request`, `POST /auth/otp/verify` → `AuthenticatedResult`, `GET /me` → `StudentProfile`, `POST /auth/refresh` (rotation), `POST /auth/logout` |
| **Typed server state — 3** | `PATCH /me` → **405** `internal_error` (route not implemented on staging); `GET /me/entitlements` → 404 `not_found`; `GET /catalog/subjects` → 404 `not_found` — see `seif_fight.md` S37 |
| **Not reachable — 6** | `POST /auth/register` (number already registered; the probe arm was skipped), `/catalog/subjects/{id}/tree`, `POST /quizzes`, `/answers`, `/finish`, `GET /questions/{id}/explanation` — all gated behind the catalog 404 |

Nothing of the F-7-01 class leaked: every operation that answered did so either as a
decoded model or as a typed `AppException`. F-7-01 itself (`068390d`) is closed — 20
parse-bearing catches sealed, three `QuizBloc` terminal arms, four tests.

**Verification level: BUILD** (`validate.ps1` 2026-08-23T11:29Z, 861 passed) **plus a
live-staging run from the dev host under `flutter test`.** That run is not on the ladder:
it is more than BUILD (real TLS, real JSON, real error bodies) and less than DEVICE (no
device, no Keystore, no app shell) — do not report it as either. R-8 is **narrowed, not
closed**: the authenticated suite did not run end to end because staging has not deployed
the catalog, entitlements or `PATCH /me` routes.

---

## Wave 3D — closed 2026-08-21, committed 2026-08-22

The block below is kept as the record of WHY 3D was stopped; it was lifted
exactly the way it said it had to be — by design input, not inference. The
designer's handoff `typography-style-inter.md` (2026-08-21) supplied 18 named
styles on `28 → 24 → 20 → 18 → 16 → 14 → 12 → 10` plus `11` for the bottom
navigation. `lib/core/theme/app_typography.dart` transcribes it verbatim as
`AppType`; `6e2df3d` migrates every call site but OTP (ratchet 153 → 11), `da794de`
migrates OTP with its resend-timer rework (11 → 0), and `7a16307` adds
`test/core/theme/typography_discipline_test.dart`, the palette guard's twin.
Sizes that were not on the supplied scale were remapped by the role the
designer's notes describe and are listed for sign-off (RISKS.md R-1).

### The original blocker, for the record

Nothing was implemented while this held, and the ratchet stayed at **153**.

**Reason:** the Figma file defines no semantic type scale. Confirmed
independently by both Claude and Fable via the Figma MCP:

- `get_variable_defs` on Login `82:819`, Home `337:5303` and Sign Up `337:15875`
  returns **one** text style — `Regular/None/Medium` (Inter Medium 16) — bound
  to the imported country-flag component, not authored for this product.
- `get_metadata` shows every text layer named after **its content**
  (`Welcome back`, `Send OTP`, `OR`), containers auto-named
  (`Frame 427319516`). **No layer encodes a typographic role.**
- The twelve `docs/day*_brief.md` contain two incidental typography mentions
  and no scale.

**What would unblock it** — all design input, none inferable from the repo:

1. The set of semantic roles the product has.
2. Size → role for **18, 14, 22, 16** (~107 of 153 sites).
3. A ruling on the long tail: 44, 36, 32, 28, 24, 19, 15.
4. A decision on `13.145` in `ai_explanation_panel.dart` — not a designed value.
5. Weight pairing: `w600` ×45 vs `bold` ×23, currently interchangeable.

Deriving a scale from size frequency is **explicitly forbidden** — it authors a
design system under the guise of a refactor and freezes it into 49 files.

---

## Open findings

### W3-1 · MEDIUM · **OPEN** — `OtpNotifier.verify` uses `ref` after `await`

**Found by Fable in the Wave-3 review. Not fixed.** Recorded here rather than
patched during Wave 4, because documentation work must not silently change
application code.

`verify()` has three sequential `await`s and calls `ref.read(...)` after two of
them, before the `_disposed` guard. This contradicts Wave 3's own premise:
`edit_profile_notifier.dart` states in source that `ref` is dead after disposal
and would throw. **Both cannot be true.** Either the OTP path throws in exactly
the scenario 3A set out to fix, or `EditProfileNotifier` accepted a staleness
cost for no reason.

The `markAuthenticated()` placement argument is self-defeating if the premise
holds: a dead `ref` means it cannot run at all, producing the
authenticated-but-not-routed outcome the comment claims to prevent.

**Proposed fix (not applied):** capture dependencies before the first `await`
so they survive disposal without going through a dead `ref`.

**Blocking question, cheap to answer:** confirm `Ref.read`-after-dispose
semantics in `flutter_riverpod` 3.3.2 — one lookup in the pub cache, which the
developer has and the audit environment does not. **The fix direction depends
on the answer**, so it should be settled before code changes.

**Answered 2026-09-04.** `riverpod-3.3.2/lib/src/core/ref.dart:232-240` —
`_throwIfInvalidUsage` throws `UnmountedRefException` when `!mounted`, and every
`read`/`watch` goes through it. So `ref` IS dead after disposal: the OTP path throws
if the screen is disposed mid-`verify`, and `EditProfileNotifier`'s premise was right.
The fix direction is now fixed — capture before the first `await` — and the fix
itself is still not applied (out of the 2026-09-04 wave's scope; R-2).

### W3-4 · LOW · **RESOLVED (record corrected, Wave 4)**

The 3C rejection cited an inaccurate scan. Corrected in
`.ai/audits/current/wave3-implementation.md` §3. Conclusion unaffected.

### W3-6 · LOW · **RESOLVED (Wave 4)**

Stale test counts removed from `ci.yml:52`, `ci.yml:127` and
`PROJECT_GUIDE.md:96`. Counts are now referenced as "run `flutter test`" rather
than frozen numbers, so they cannot go stale again.

### W3-2, W3-3 · LOW · **ACCEPTED, not fixed**

The 3A guard proves the mechanism exists, not that each assignment is guarded
(W3-2); no behavioural race test exists (W3-3). Both are documented limitations
with stated reasoning, carried in `docs/RISKS.md`.

---

## Ratchets

Never lower one without genuine remediation. Lowering to make a suite pass is a
false fix.

| Ratchet | Value | Set | Meaning |
| --- | --- | --- | --- |
| Hardcoded `fontSize` | **0** | 153 → 11 (`6e2df3d`) → 0 (`da794de`) on 2026-08-22 | 3D closed; `typography_discipline_test.dart` is the locating guard, this count is the ratchet half |
| `Text('literal')` sites | **4** | 7 → 5 on 2026-08-15; 5 → 4 on 2026-08-22 (legal separator localized) | after real remediation each time; all 4 remaining are untranslatable |
