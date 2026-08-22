# Wave Status — the single source of project truth

**Last updated:** 2026-08-22 (Wave 4 closed; Wave 3D closed)
**Branch:** `merged` — `dev` + `main` joined on 2026-08-22 (`99b5cba`); both are kept
untouched as history and all work continues on `merged`.
**Unpushed:** nothing — the 2026-08-22 dirty tree was split into ten commits and pushed
the same day. This file no longer records a HEAD; `git log` is the source for that.

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
