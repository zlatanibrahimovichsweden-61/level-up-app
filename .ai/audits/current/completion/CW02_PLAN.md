# CW02 — Core API conformance: error and routing seam (T02) — plan and owner rulings

**Started:** 2026-10-09T15:39Z on the owner's `START WAVE CW02` · Opus control-plane session "Level Up app store submission
readiness" · roadmap row: `04_COMPLETION_ROADMAP.md` CW02 · contract `eddb6ac` (3.46.0-m1; `ls-remote` re-checked at start).

## Owner rulings at start (2026-10-09, AskUserQuestion, verbatim choices)

| Question | Answer |
| --- | --- |
| Banned UI until the designer's banned frame exists | **Inline on OTP** — the contract's suggested EN/AR copy in the OTP screen's existing error line, code entry and resend locked, the existing "Back to login" action. No new screen. |
| GoRouter `errorBuilder` content | **Existing parts** — the shared error state with the existing `genericError` copy and the existing circle back button (pops, or goes Home). No new copy or visuals. |
| Fable audit at the "CW02 foundation" checkpoint | **Yes, at close** — one read-only Fable audit of the diff and gates before the close-out. |

## Baseline (2026-10-09T15:43:56Z)

- `merged` @ `b227f61` = `origin/merged` (CI run 37950164225 success). Nothing staged.
- The working tree already carries **30 uncommitted files from the peer session "Replace personal phone number"**
  (discovery N-26: `phoneHint` → `01X XXXX XXXX` in both ARBs and the 3 generated l10n files, mock profile phone and 20 test
  fixtures → `+2010000000001`, `phone.dart` doc comments, `day1_login_otp_brief.md:52`, `DESIGN_ISSUES.md` #127, and the
  tracked `test-results.md` its `validate.ps1` run rewrote). Peer-reported: OVERALL PASS, **2082/0/0**. Not committed by the
  peer's own brief. CW02 builds on top and **keeps those hunks intact**; they remain a separable concern for any commit.
  Patch snapshot: scratchpad `cw02_base_peer_n26.patch`, blob list `cw02_base_blobs.txt`.

## Scope as built (roadmap row, after the rulings)

Already delivered in CW00: `Accept: application/json` on every call, and the corrected `ErrorInterceptor` comment.

| Slice | What | Main files |
| --- | --- | --- |
| A — unknown outcome + pending-deletion seam (tests and doc only) | Pin the contract rule (`openapi.yaml` ProblemDetails, `C:o:3883-3890`): a non-2xx with no parsable body or no string `code` maps to code `unknown` and is shown like `internal_error` (generic copy, no logout). Timeouts and connection errors stay `NetworkException` → Offline (the rule covers non-2xx responses, not transport failures). A 5xx or body-less answer to `refreshTokens` does not sign the student out. One "no redirect yet" assertion per local `account_pending_deletion` copy site; the redirect target lands in CW05. | `test/core/network/{error_interceptor,auth_interceptor,account_pending_deletion}_test.dart` |
| B — `account_banned` on `verifyOtp` | `isAccountBanned` predicate beside `isAccountPendingDeletion`. `authErrorMessage` maps it to new key `errorAccountBanned` = contract-suggested copy (`error-codes.md:51`): EN "Account banned — contact Support", AR "تم حظر الحساب — تواصل مع الدعم". The OTP notifier marks the state banned: no token write, no auth flip, `verify` and `resend` become no-ops (the code is consumed; "do not retry"). The OTP screen locks entry and resend, shows the copy in its existing error line and offers the existing "Back to login" (`backToLogin`). Mock backend gains a banned magic code. | `exceptions.dart`, `auth_error_copy.dart`, `otp_notifier.dart`, `otp_screen.dart`, ARB ×2 + gen-l10n ×3, `lib/dev/mock_backend.dart`, auth tests |
| C — router | `errorBuilder` from existing parts. Return-to-target: a signed-out bounce to `/login` from a protected location remembers that location unless the sign-out was user-initiated; the three sign-in landings (`otp_screen.dart:122`, `school_detail_screen.dart:362`, `university_detail_screen.dart:328`) go to the remembered target or `/home`, once. The holder is in memory only (never a URL parameter, never logged) and is not mutated as reactive provider state during routing. | `app_router.dart`, a new router helper, the three landings, `app_router_test`, `login_logout_message_test`, `session_isolation_test` |

**Run order:** A → B → C, one Sonnet implementer at a time in the main tree (B and C both touch `otp_screen.dart`; parallel
`flutter test` runs share `.dart_tool`).

**Out of scope (gated elsewhere):** the banned screen frame (designer), a signed-out Support route for banned students
(Seif, shared with CW06), banned arms on `verifyParentOtp`/`confirmRecovery` (CW06), the pending-deletion redirect target
(CW05), the refresh 4xx set and `Retry-After` format (Seif Q-B batch — *later: never filed; the refresh part is now a
proposed Seif question, SQ-31, not yet in `02_SEIF_HANDOFF.md` — `CW02_REPORT.md` §12*), a staging banned account (not seeded; the mock
covers it).

## Acceptance (from the roadmap row)

Every request carries `Accept`; empty-body and body-without-code non-2xx take the unknown-outcome path; a banned `verifyOtp`
stores no tokens and does not retry the code; an unknown route renders the `errorBuilder`; return-to-target round-trips;
the `invalidateSessionScope` count test changes only on purpose; "no redirect yet" asserted at every pending-deletion copy
site; no personal data in logs; STATES and AR/EN for every new UI state.

## Gate (roadmap §6) and close

Format (tracked + untracked, batched), `flutter analyze` 0, each new/changed test file alone, full suite ≥ 2082/0/0 + new
tests, `test/guards` alone, contract guard 14/14, gen-l10n drift + ARB parity + duplicate-key grep, `pubspec.lock`
unchanged, purchase-silence and logging scans, a read-only staging 4xx probe, device status (walk only on `WALK`).
Then an independent Sonnet review, the Fable audit, `CW02_REPORT.md`, and `COMPLETION_STATE.md`. **No commit or push.**
