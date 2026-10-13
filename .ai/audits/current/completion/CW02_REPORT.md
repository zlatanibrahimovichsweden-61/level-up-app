# CW02 — Core API conformance: error and routing seam (T02) — close-out

**Wave:** CW02 · **Started** 2026-10-09T15:39Z (`START WAVE CW02`) · **Gate closed** 2026-10-09T17:34Z · plan and rulings:
`CW02_PLAN.md` · contract `eddb6ac` (3.46.0-m1), upstream re-checked at start and at every gate run (close, §11 ×2, §12 ×2).
**Status:** see §12 (latest; §9 is the close-out). **Nothing committed or pushed.** Verification levels used below: SOURCE, BUILD (local), staging API
probe. **No DEVICE evidence** (the Pixel 8 was not attached) and **no CI evidence** (nothing pushed).

## 1. Scope delivered vs planned

| Planned (roadmap row + rulings) | Delivered |
| --- | --- |
| `Accept: application/json` on every call | Already in CW00 (`ef2b780`); unchanged. |
| Unknown-outcome rule (`openapi.yaml` ProblemDetails, ~:3883) | Pinned by tests: a non-2xx with no body, an HTML body, a map without `code` or a non-string `code` maps to code `unknown` and is shown exactly like `internal_error` across the 7 error-copy funnels, 7 retry/decision predicates and the catalog error view, EN + AR (hand-enumerated; `ExplanationFailed.isRetryable` and the quiz-bloc explanation branch are not in that table). Connection errors and the three timeouts stay `NetworkException` → Offline; the other no-response Dio types (`cancel`, `badCertificate`, `unknown`) map to `UnknownException` — pinned since §11 (F4, `error_interceptor_test.dart`: never Offline). A body-less 503/401/400 answering the refresh call signs nobody out. No `lib/` change was needed. |
| `account_banned` on `verifyOtp` (owner: inline on OTP) | `isAccountBanned`; `errorAccountBanned` = the contract's suggested copy, EN and AR byte-exact (`error-codes.md:51`); the OTP notifier enters a terminal banned state (no token write, no auth flip, `verify`/`resend` are no-ops, countdown stopped, a late resend answer cannot undo it); the OTP screen locks entry (Pinput disabled, no auto-submit), hides resend, announces the line as a live region, and the primary CTA becomes the existing "Back to login". Mock magic code `222222` → 403 `account_banned`. |
| `errorBuilder` (owner: existing parts) | `RouteErrorScreen`: `Scaffold` + `CircleBackButton` (pop, else `/home`) + `StateWidget` error with the existing `genericError`; no Retry, no new copy or visuals. Signed-out unknown locations normally go to `/login`; two edges — the `AuthUnknown` first frame of a cold start and an unmatched `/register…` path — are stated in the code (§11, R-2), and no entry point the app ships reaches them. |
| Return-to-target | A signed-out bounce to `/login` remembers the location **only if it lies inside the tab shell** (derived from the router's own configuration, not a path list); otherwise any older target is cleared. A user-initiated sign-out clears it. The OTP sign-in success **Continue** consumes it once (fallback `/home`) — since §11/§12 only for the student whose session ended (O-10). Registration landings clear it and go Home (a new registrant is never the signed-out student). In memory only; never a URL, storage or log; not session-scoped (it must survive `forceLogout`). |
| Pending-deletion "no redirect yet" seam | One named test per copy site (`catalog_states`, `flashcards_error_copy`, `board_failure`, `profile_error_copy`, `quiz_error_copy`): the site keeps its copy and contains no navigation or sign-out call (string-aware, comment-stripped scan); Retry is withheld at the four sites that offer one (catalog, flashcards, board, quiz) — the profile site returns a banner string and has no Retry to withhold. CW05 changes these on purpose. |
| `invalidateSessionScope` count test "updated on purpose" | Not needed: still 2 calls; a new scan pins that `session_scope.dart` never references `returnTargetProvider`. |
| Stale `ErrorInterceptor` comment | Already fixed in CW00. |

**Narrowed during the wave (recorded, not owner-ruled):** return-to-target is shell-only. The top-level screens normally
pushed over the shell (`/profile*`, `/settings`, `/refer`, `/support`, `/friends`, `/legal/*`, `/track-select`,
`/quiz*`) fall back to Home as before CW02, because `go` would leave nothing beneath them: their back chip
(`maybePop`) would do nothing and Android BACK would exit the app.

## 2. Files changed by CW02 (CW02-only **non-blank** lines added/removed; the peer's N-26 hunks excluded — raw `git diff --numstat` figures are 5–21 % higher, e.g. `return_target_test.dart` 921 raw lines)

*Snapshot at the first close (17:34Z). Later rounds changed the counts (14 CW02-only lib files and the final tree): see §11 and §12.4.*

- **lib (12 CW02-only + 6 shared with the N-26 set):** `core/network/exceptions.dart` (+23), `core/router/app_router.dart` (+116/−3),
  `core/router/return_target.dart` (new, 61), `core/router/route_error_screen.dart` (new, 58),
  `core/session/session_scope.dart` (+11, doc only), `features/auth/auth_error_copy.dart` (+4),
  `features/auth/notifier/auth_controller.dart` (+9, `logout()` clears the target),
  `features/auth/notifier/otp_notifier.dart` (+42/−5), `features/auth/screens/otp_screen.dart` (+70/−24),
  `features/registration/screens/{school,university}_detail_screen.dart` (+5 each), `main_mock.dart` (+2/−1, magic-code
  doc). Shared with the peer's N-26 hunks: `dev/mock_backend.dart` (+18/−3), `l10n/app_{en,ar}.arb` (+4, +1),
  `l10n/app_localizations{,_en,_ar}.dart` (+5, +2, +2; `flutter gen-l10n`).
- **tests (6 changed + 4 new; `app_router_test.dart` was run, not changed):** `core/network/{error_interceptor,auth_interceptor,account_pending_deletion}_test.dart`
  (+286, +157, +354/−1); `core/session/{session_isolation,session_scope_discipline}_test.dart` (+55, +25);
  `features/auth/login_logout_message_test.dart` (+41); new `core/router/return_target_test.dart` (775),
  `features/auth/otp_banned_test.dart` (448), `features/registration/registration_return_target_test.dart` (128),
  `dev/mock_backend_banned_test.dart` (58).
- **records:** `completion/CW02_PLAN.md` (new), this file (new), `completion/COMPLETION_STATE.md`,
  `docs/DESIGN_ISSUES.md` #128 (interim banned notice, DG-03 / SQ-12) and #129 (unknown-route page, DG-31) — appended
  after the peer's #127.
- Every CW02 file is LF (as the index stores it). The peer's N-26 hunks in the shared files were verified intact after
  each slice (every peer-added line still present). The tracked `test-results.md` is the peer's `validate.ps1` rewrite;
  CW02's gate never wrote it.

## 3. Gate (roadmap §6) — close-out run 2026-10-09T17:22:52–17:34:40Z, BUILD level (superseded: §11 re-gate 2215/0/0, §12.4 re-gate 2225/0/0)

| Step | Result |
| --- | --- |
| Start | `merged` @ `b227f61`; nothing staged; contract upstream `eddb6aca993f`, pinned blobs `5af03f92 4f0a1c26 08dfaceb ff05c7ac`, `contract/` unchanged |
| Format (tracked + untracked, generated excluded) | 148/143/41 files, **0 changed** |
| gen-l10n | re-run, generated files byte-identical (no drift); ARB 273 = 273 keys, no duplicates |
| `pubspec.yaml` / `.lock` | unchanged |
| `flutter analyze --no-pub` | **No issues found!** |
| Targeted files, each alone | error_interceptor +50 · auth_interceptor +10 · account_pending_deletion +21 · otp_banned +11 · mock_backend_banned +3 · return_target +34 · app_router +11 · registration_return_target +4 · login_logout_message +3 · session_isolation +12 · session_scope_discipline +6 · otp_screen +6 · otp_success_router +2 · verify_fork +5 — all "All tests passed!" |
| Guards | `test/guards` **+124**; contract guard **14/14**; pin guard **2/2** |
| Full suite | `validate.sh` (report redirected) **OVERALL PASS — 2176 passed / 0 failed / 0 skipped** (peer-reported baseline 2082; first CW02 gate 2170) |
| Safety scans | logging (`print`/`debugPrint`/`dart:developer`/`LogInterceptor`/`log(`) over 13 hand-written lib files (the 12 CW02-only + `mock_backend.dart`): **0**. Purchase silence in added lines of the 11 tracked files: **0**; the gate's `git diff` skipped the 2 new untracked lib files, which were scanned directly during REVIEW: **0** |
| Tree fingerprint | `git diff` + porcelain path list identical at gate start and end (it does not hash untracked file contents; the 6 new lib/test files were last written before the gate started, and the REVIEW re-run hashed them identically before and after); tracked `test-results.md` untouched |

`verify_guards.ps1` was not run (no guard changed; its contract-pin wiring is the open R-6 follow-up). Mutation checks were
run by the implementers on their own tests (reported: removing the timer cancel, the late-resend guard, `enabled: !banned`,
the shell check, the user-initiated skip, the `logout()` clear, the stale-target clear and the live region each fails a
test); they were not re-run independently by the control plane.

## 4. Contract operations and backend

- Used: `verifyOtp` (stable, not web-only), `refreshTokens` (stable) — no new operation; no new response schema, so no new
  contract-guard binding.
- **Staging probe (API level, 2026-10-09, read-only, `Accept: application/json`):** `GET /api/v1/me` unauthenticated →
  401 `application/problem+json`, `code` `authentication_required`; `GET /api/v1/<unknown>` → 404
  `application/problem+json`, `code` `not_found`; `/health/version` → commit `a158daa` (the backend `eddb6ac` mirrors).
  No banned staging account is known (asked in the Seif handoff draft, SQ-16, not yet sent), so the banned path is proven
  on the mock only.
- **Backend status:** staging serves `a158daa` and writes ProblemDetails with a `code` for both probed 4xx; no
  `account_banned` account exists on staging; the signed-out Support route for banned students is unanswered (SQ-12).

## 5. Independent review (Sonnet, `claude-sonnet-5-5`) — 0 blocker, 0 major, 5 minor, 8 nits

| # | Finding | Disposition |
| --- | --- | --- |
| 1 | Return target not bound to the student; registration landings consume it | **Fixed in part:** registration landings clear + Home. **Owner decision O-10:** OTP sign-in by a different student after a forced sign-out lands on the first student's last shell location (no data exposure; server-authorised) — bind to identity or add a TTL? |
| 2 | A non-rememberable forced bounce kept an older target | Fixed (`clear()`), with a seeded-target test |
| 3 | Discipline-test entry claimed enforcement it lacks | Fixed wording; new scan: `session_scope.dart` code never references `returnTargetProvider` |
| 4 | Two pending-deletion test names overclaimed; scan porous | Fixed: tests call the funnels; string-aware stripper; `context.replace`, `Navigator.`, `routerProvider` added |
| 5 | Terminal banned line not announced | Fixed: live region (banned only), asserted |
| 6 | Shell-only narrowing, extra files, undesigned states unrecorded | Recorded here (§1, §2) and in DESIGN_ISSUES #128/#129 |
| 7–9 | Vacuous "once"; tautologies; mock-vs-itself assertions | Fixed |
| 10 | Remember step inside the auth redirect could throw | Fixed: silent `try/catch` |
| 11 | `ScreenError.messageKey` receives resolved text | Accepted (only caller using `StateWidget`'s default view); note for DG-31 |
| 12 | Comment attributed the frame to CW02 | Fixed: DG-03 / SQ-12 |
| 13 | Coverage gaps | Fixed: dark-theme banned and error-page tests; body-less 401/400 on refresh |

## 6. Fable audit (CW02 foundation checkpoint)

**Verdict (verbatim): APPROVED WITH WARNINGS** — model `claude-fable-5-1` (as exposed by the harness), read-only, on the
gated tree (diff hash `e9b649c32e2a860e` = the gate's end fingerprint). "Nothing must change before owner REVIEW. No
blocker, no major." The auditor re-ran `return_target_test` (34/34) and `otp_banned_test` (11/11) alone, compared the ARB
strings byte-for-byte with the contract row (EN and AR equal, U+2014 present), and confirmed in go_router 17.3.0 / pinput
6.0.2 sources that the redirect cannot run before `router` is assigned and that the programmatic-completion test really
exercises the `_verify` guard.

| # | Sev | Finding | Action / when |
| --- | --- | --- | --- |
| 1 | minor | Return target not bound to the student (cross-student landing on a shared device; no data exposure) | **Owner decision O-10**; decide before CW06 adds `confirmRecovery` as a second sign-in landing — *later: resolved §11; the late-sign-in race closed §12* |
| 2 | minor | A body-less 401/400 answering the refresh keeps the student signed in with dead tokens; each protected call re-attempts the refresh (conformant with the unknown-outcome rule; depends on the server always writing a `code`) | *Later: downgraded to a nit (§10 F1); the "Q-B batch" was never filed — now a proposed Seif question, SQ-31 — not yet in `02_SEIF_HANDOFF.md` (which ends at SQ-30); adding it is part of O-3 (§12).* If no guarantee, a bounded fallback (N consecutive unknown refresh failures → `forceLogout(sessionExpired)`) in CW05/CW06 |
| 3 | nit | The bounce note fires on `destination != null && Unauthenticated`, not `== '/login'` (equivalent today) | Tighten when `authRedirect` next changes (CW04/CW05) |
| 4 | nit | The "unknown ≡ internal_error" funnel and predicate lists are hand-enumerated | Every later wave adds its new copy funnels/predicates to them (CW05/CW06) |
| 5 | nit | `session_scope_discipline_test`'s comment stripper is URL-porous; a string-aware one now exists in another test | Share a test helper, any wave |
| 6 | nit | The tracked `test-results.md` is the peer's 2082/0/0 run, not CW02's 2176/0/0 | Refresh it (`validate.ps1`) before any CW02 commit, or commit it only with the N-26 set — *later: the tree is 2225/0/0 (§12.4); the order is fixed in §9 as corrected* |
| 7 | nit | The redirect's `catch (_)` also swallows programming errors | Awareness only (tests assert the landings) |
| 8 | info | "Route to Support" is not built — no signed-out Support operation exists | SQ-12 + DG-03 (CW06 / Seif) |

**Hand-over notes (condensed):** CW04 — `/legal/*` is never remembered; a Terms gate in the router branches on
Authenticated only and never writes provider state from the redirect. CW05 — put the pending-deletion redirect at router
level, not in the five copy sites (their `expectNoRedirect` scans fail by design and are updated on purpose); keep the cancel
screen out of `_authRoutes`; if it sits inside the shell it becomes rememberable. CW06 — replicate the OTP banned terminal
pattern (consider extracting it) for `verifyParentOtp`/`confirmRecovery`; decide consume vs clear for the recovery landing
together with O-10. CW08a — a push target survives a bounce only as path + query (`extra` is dropped); non-shell screens land
on Home, so decide "Home then push"; validate a push route before `go`. All waves — the pushed-vs-stored behaviour relies on
go_router 17.3.0 internals: re-run `return_target_test` after any go_router bump; any new shell route must be rebuildable from
its path alone.

## 7. Limitations and deferred items

- No DEVICE walk (phone not attached; a walk runs only on `WALK`); no CI (nothing pushed). F/V/I acceptance scores need the
  walk and are not given.
- Banned arms on `verifyParentOtp` and `confirmRecovery` → CW06; a signed-out Support route → SQ-12 (Seif) + DG-03
  (designer); the banned frame and final copy → DG-03; the generic error-page frame → DG-31.
- Pending-deletion redirect target → CW05 (the seam tests change on purpose then).
- A body-less 401 answering the refresh call is treated as an unknown outcome (no sign-out, per the contract rule); each
  later protected request retries the refresh. The contract declares only 401 `refresh_token_invalid` / `session_superseded` for a dead refresh (`openapi.yaml:448-449`); whether a body-less or gateway answer can occur is a proposed Seif question, SQ-31 — not yet in `02_SEIF_HANDOFF.md` (which ends at SQ-30); adding it is part of O-3.
- Return-to-target does not cover non-shell pushed screens (Home instead) — CW08a push tap routing must decide how to open
  those (e.g. Home then push).
- R-6 follow-up (contract pin guard into `verify_guards.ps1`) still open.

## 8. Rejected options

- Timeouts as "unknown outcome": rejected — the contract rule covers non-2xx responses; folding transport failures in would
  change every screen's Offline view.
- A remembered target as reactive Riverpod state or a URL parameter: rejected — mutation during routing is the BUG-001
  class, and a URL would leak navigation into links/logs.
- A hand-maintained path list for "rememberable": rejected — derived from the route configuration so new routes classify
  themselves.
- Fixing the dead back chip in `TitledChrome` (go Home when nothing to pop) instead of shell-only: deferred — wider blast
  radius across shared chrome; revisit with CW08a.

## 9. Status and owner decisions

**Status: PASS WITH WARNINGS.** Every gate passed (BUILD); the independent review and the Fable audit found no blocker or
major. Warnings: O-10 (return target not bound to the student); refresh 4xx without a body depends on a proposed Seif question (SQ-31, not yet in `02_SEIF_HANDOFF.md`); no DEVICE
or CI evidence; nothing committed; the peer's 30 uncommitted N-26 files share six files with CW02 (`mock_backend.dart`, both
ARBs, the three generated l10n files) and `DESIGN_ISSUES.md`.

**Open owner decisions from this wave:** O-10 (above) — resolved in §11. Carried: O-8 (commit the N-26 set), O-9 (purge the confirmed-real
number from history), O-3 (send the Seif and designer handoffs — DG-03, DG-31 and SQ-12 now gate the banned frame, the
error-page frame and the Support route).

**If commits are requested (proposal only, not done; corrected in §12):** stage by explicit path only — never `git add
-A`/`.`/`-a`; the two root roadmap files stay untracked (R-3, O-9). (1) The N-26 set first, staged from the peer's own
patch so the shared files carry only its hunks, with the tracked `test-results.md` exactly as the peer left it (its
2082/0/0 run was taken on the N-26-only tree); (2) `test(network)` — the three network test files; (3) the banned path and
(4) the router seam with the O-10 binding — `otp_screen.dart` AND `otp_notifier.dart` each carry hunks of both (banned
state; `consume(studentId:)` / `AuthenticatedOutcome(studentId:)` / `markAuthenticated(studentId:)`), so split both by
hunk or, simpler, merge (3) and (4); (5) `docs` — CW02 records, `COMPLETION_STATE.md`, DESIGN_ISSUES #128/#129,
KNOWN_BUGS BUG-026. Refresh the tracked `test-results.md` with `validate.ps1` on the full tree after (1) and commit it
with the last CW02 commit (Fable #6).

**Next owner action (as of the close-out; superseded):** `REVIEW` CW02 — done (§10, then a fresh REVIEW in §12; O-10
resolved in §11). The close-out's WALK plan (removed here) was wrong twice and is replaced by §12: the mock never answers 401 (a
forced sign-out needs staging), and the ordinary mock build cannot show the unknown-route page. Nothing advances on its
own.

## 10. Owner REVIEW pass (2026-10-09, on `REVIEW CW02`)

Run as a read-only 10-agent workflow (Sonnet, pinned; agents wrote no file): 1 evidence re-runner (the only toolchain
user), 1 claims auditor, and 4 dimensions × (finder → adversarial refuter): contract + privacy, router + state,
UI/a11y/RTL/copy, tests + regressions.

- **Evidence re-run (BUILD):** 19/19 commands reproduce the gate exactly — the 14 targeted files with identical counts,
  guards +124, contract 14/14, pin 2/2, analyze 0, `validate.sh` OVERALL PASS **2176/0/0**. lib/test hashes identical
  before and after (`5fb3207dfa638cd5` / untracked `aa600a4b138a495a`); tracked `test-results.md` untouched. Between the
  gate and REVIEW only `COMPLETION_STATE.md` and this file changed.
- **Claims audit:** 26 claims checked; 17 accurate; 9 corrected — §1 (two rows overstated), §2 (file counts and the
  line-count unit), §3 (the purchase scan had skipped the 2 new lib files — scanned directly now: 0 hits; the fingerprint
  does not hash untracked contents), §4 (the banned staging account is SQ-16), and `COMPLETION_STATE.md` (header,
  deliverables row). The control-plane gate script now hashes untracked contents and scans untracked lib files.
- **Adversarial hunt:** 14 candidates, 5 refuted (absolute-URI deep links — go_router normalises app links to paths;
  privacy invariants being prose only — no defect today; an `AuthUnknown` error-screen flash — not reachable as built;
  the stock `StateWidget` look — owner ruling), **9 confirmed: 0 blocker, 0 major, 1 minor, 8 nits.**

| # | Sev | Confirmed finding | Disposition |
| --- | --- | --- | --- |
| UI-1 | minor | The banned notice uses the OTP screen's existing error style — 10 sp at ≈3.2:1 contrast in light, under WCAG AA's 4.5:1 for small text — and it is the only explanation of a terminal state | Kept per the owner ruling (existing error line); size/contrast is a design matter for DG-03 and for every OTP error line; not changed |
| UI-2 | nit | In the banned state the title/subtitle still say "Enter the 6-digit code" | Needs copy → DG-03 |
| F1 | nit | A body-less refresh 4xx leaves Sign Out (Profile hub) as the only exit (= Fable #2, downgraded) | *Was "Seif Q-B batch" (never filed); now a proposed Seif question, SQ-31 — not yet in `02_SEIF_HANDOFF.md` (which ends at SQ-30); adding it is part of O-3 (§12)* |
| F2 | nit | `isAccountBanned` doc says the code is consumed on all four operations; the contract says so for `verifyOtp` (and the web-only redemption verify) only | Follow-up: comment fix — *done §11* |
| F4 | nit | `cancel`/`badCertificate`/`unknown` Dio types → `UnknownException` is unpinned | Report corrected (§1); follow-up test — *done §11* |
| R-2 | nit | Comments say a signed-out student never reaches `errorBuilder`; the `AuthUnknown` first frame is an edge | Follow-up: comment wording — *done §11* |
| TQ-1 | nit | The programmatic-completion check cannot detect removal of the screen-level `_verify` banned guard (the notifier no-ops first) | Defence in depth; follow-up test — *done §11* |
| TQ-2 | nit | The remember-step `try/catch` has no test | Follow-up test (a throwing holder) — *done §11* |
| TQ-5 | nit | The report counted 7 changed test files | Corrected (§2) |

**REVIEW outcome:** CW02 stands at **PASS WITH WARNINGS**; no code changed during REVIEW. The five code follow-ups (F2,
R-2 comments; F4, TQ-1, TQ-2 tests) are small and behaviour-neutral: fold them into CW02 before its commit, or into the next
L-AUTH-ROUTER wave (CW04), on the owner's word. *(Folded into CW02 on the owner's instruction — §11.)*

## 11. Follow-up round — REVIEW follow-ups, O-10, re-gate (2026-10-09T18:31Z–21:08Z)

**Owner instruction (condensed):** fix the five §10 follow-ups narrowly; investigate and resolve O-10 (same student
re-authenticating keeps the target; a different student must not inherit it; never the phone number as the key; no timeout
alone; no broader session refactor; regression tests for both cases; stop and report if identity cannot be told safely);
re-gate everything; update these records; no commit, push, WALK or next wave. Implementer `claude-sonnet-5-5` (one subagent,
three passes); review workflow below; Opus control plane.

**Five follow-ups — done, behaviour-neutral:** F2 (`exceptions.dart`: "consumed" attributed to `verifyOtp` and
`verifyRedemptionSessionOtp` only, per `openapi.yaml:231/:371`; `error-codes.md:51` marks it for `verifyOtp` alone);
R-2 (`app_router.dart` errorBuilder note, `route_error_screen.dart`: the two edges stated, and why no URL or deep-link entry
point the app ships reaches them); F4 (new test: `cancel`/`badCertificate`/`unknown` with no response → `UnknownException`,
never Offline; the timeouts test retitled to what it covers); TQ-1 (`otp_banned_test`: a recording notifier with no guard of
its own pins the SCREEN guard in `_verify`, with a positive control proving the programmatic code reaches `_verify`); TQ-2
(`return_target_test`: a `ReturnTarget` whose `remember`/`clear` throw — a forced sign-out from `/message` and `/settings`
still lands on `/login`, no error page, no exception).

**O-10 — resolved, bound to the student (owner direction, no new owner choice needed).** Identity can be told safely
without a broader change: the contract's `AuthenticatedResult.profile` and `GET /me` both carry the required
`StudentProfile.id` (`openapi.yaml:4081-4094`, `:4317`).
- `ReturnTarget` keeps an owner beside the location. `AuthController.forceLogout` calls `sessionEnding(id)` after its
  idempotency guard and BEFORE the state flip (the flip runs the redirect that remembers); `sessionEnding` also forgets any
  older location. `consume({required String? studentId})` returns the location only when owner and signing-in id are both
  known and equal; otherwise Home, and the target is dropped either way. User sign-out `clear()`s both.
- The ending student's id: the id captured at sign-in (`markAuthenticated(studentId:)`, from verifyOtp's `profile.id`),
  else — for a session restored at cold start or begun by registration, which land on `/home` — a SETTLED `/me`
  (`!isLoading && !hasError`; Riverpod 3 keeps previous values through rebuilds). Unknown → nobody (fail closed). Never the
  phone; in memory only; never logged.
- **Behaviour changes, deliberate:** (1) a signed-out cold start (no session ended in this process) now lands on Home after
  sign-in — no owner to match; unreachable through any entry point the app ships today. (2) A forced sign-out while `/me` is
  refreshing or failed, in a session that did not sign in here, lands the same student on Home.
- **Regression tests (BUILD):** the owner's scenario for both `sessionExpired` and `supersededOtherDevice` — A forced out on a
  nested Learn location, B signs in → `/home`, target gone (A arriving later gets nothing); the same student → back on the
  nested location with its parent stack, target consumed; a sign-in in this process with `/me` never settling → returned,
  and returned again after a SECOND forced sign-out (Home never built — the lazy-branch gap the review found); verify answers
  with no usable id (`{}`, `''`, `7`) → Home; `/me` never read → Home; repeated `forceLogout` keeps the binding; the captured
  id does not leak into the next session or survive `logout()`; notifier plumbing (`otp_student_id_test.dart`, new).
- **Mutation checks (each restored hash-identical, then green):** owner comparison dropped → both owner scenarios fail;
  settled-only check dropped → the refreshing/failed `/me` tests fail; `sessionEnding` moved above the guard → the
  repeat test fails; captured id ignored → the no-`/me` router test and two container tests fail; `markAuthenticated()`
  without the id → plumbing and router tests fail; `logout()` keeping the captured id → its test fails; screen guard
  removed → only the TQ-1 test fails (positive control passes); redirect `try/catch` removed → both TQ-2 tests fail.

**Adversarial review of the round** (workflow, 8 agents `claude-sonnet-5-5`, read-only, no toolchain: 4 finders × 1
refuter — O-10 carryover, claims, test effectiveness, scope/privacy): 32 candidates, 6 refuted, **26 confirmed: 0 blocker,
0 major, 3 minor, 23 nits.** No cross-account path was found (forward, reverse, third student, registration, concurrent
401s, revoke in flight, cold start) — *the fresh REVIEW (§12) found one in an ordering this sweep did not cover: overlapping sign-ins (O10-1), fixed in §12*. Minors, all fixed: the lazy-branch gap (a return into `/learn` or `/message` never
builds Home, so `/me` could not identify the student at a second forced sign-out → captured sign-in id); the same blind spot
in the router harness (`holdProfile` keeps `/me` alive → a no-`/me` router group, asserting Home is not built); repeated
`forceLogout` unpinned → test. Nits fixed: 10 comment/test-name inaccuracies (plus one more in
`session_scope_discipline_test`), the early `/me` flush wording, TQ-1 positive control, `studentId` plumbing, `consume`
resetting the owner, a stale cold-start comment, these records. **Nits accepted:** the defensive `catch` in
`_signedInStudentId` cannot be triggered (an `AsyncNotifier` read reports errors as state); most router tests still hold
`/me` (the new no-`/me` group covers the gap); **O-10 cannot be walked on the mock** — every mock student has one id and the
mock never answers 401, so no forced sign-out happens there; tests and staging only.

**Files changed this round: 18, all CW02-only** (none is in the N-26 set; non-blank lines vs the pre-round state):
lib (10) — `auth_controller.dart` +96/−3, `return_target.dart` +62/−9, `otp_notifier.dart` +20/−3, `otp_screen.dart` +19/−6
(comments + the `consume(studentId:)` call), `app_router.dart` +13/−2 (comment), `route_error_screen.dart` +10/−2 (doc),
`exceptions.dart` +9/−3 (doc), `auth_result.dart` +9/−5 (doc), `session_scope.dart` +8/−2 (doc), `auth_outcome.dart` +5/−1
(`auth_result.dart` and `auth_outcome.dart` are newly in CW02); tests (8) — `return_target_test` +388/−38, `session_isolation_test` +273/−18, `otp_student_id_test` +158
(new), `otp_banned_test` +103/−2, `error_interceptor_test` +28/−1, `login_logout_message_test` +27/−6,
`registration_return_target_test` +13/−3, `session_scope_discipline_test` +4/−2.
Whole uncommitted tree now: 58 files besides the two R-3 roadmap files — **23 N-26 only, 7 shared** (`mock_backend.dart`,
both ARBs, the three generated l10n files, `DESIGN_ISSUES.md`), **28 CW02 only** (14 lib, 11 tests, 3 records). Nothing staged.

**Re-gate (BUILD), 2026-10-09T20:17:02–21:03:31Z (gate script incl. `validate.sh`), then `validate.ps1` 21:03:34–21:08:09Z,
on the final tree (no source or test file changed after 20:17Z):** HEAD `b227f61`, upstream contract `eddb6ac`,
`contract/` untouched; format 0 changed over 333 files (326 tracked + 7 untracked); gen-l10n no drift; ARB 273 = 273, no
duplicates; pubspec unchanged; analyze 0; 18 targeted files alone all green (error_interceptor +51, otp_banned +13,
return_target +53, session_isolation +23, otp_student_id +6, login_logout_message +3, registration_return_target +4,
session_scope_discipline +6, app_router +11, auth_interceptor +10, account_pending_deletion +21, mock_backend_banned +3,
otp_screen +6, otp_success_router +2, verify_fork +5, profile_relogin +4, login_validation +11, registration_screens +11);
guards +124; contract guard 14/14; pin guard 2/2; `validate.sh` OVERALL PASS **2215/0/0**; `validate.ps1` OVERALL PASS
**2215/0/0** (format 326, analyze 0); logging 0 and purchase-silence 0 over the 15 CW02-touched lib files, the 2 untracked
ones included by name; tracked `test-results.md` untouched; tree fingerprint identical at the gate's start and end. 2176 → 2215 = +39,
all from this round's test changes. **No DEVICE, no CI.**

**Status (superseded by §12): PASS WITH WARNINGS — ready for a fresh REVIEW.** Remaining: UI-1 (minor, DG-03); nits UI-2 (DG-03), F1 / Fable
#2 (refresh failure without a body — a new Seif question, proposed as SQ-31: not yet in `02_SEIF_HANDOFF.md`,
which ends at SQ-30; filing it is O-3), Fable #3–#7 as recorded in §6, and the accepted nits above. WALK
(after REVIEW): *corrected in §12* — the ordinary mock build shows the banned state (`222222`) but NOT the unknown-route page; forced sign-out and O-10 need
staging (a whitelisted account; a second registered one for the B case; the substrate is O-4). Commit proposal: §9 as corrected in §12.

## 12. Fresh REVIEW, O10-1 fix, record corrections and re-gate (2026-10-09T21:28Z–22:51Z)

**Owner instructions (condensed).** (a) "Run a fresh formal REVIEW of CW02 after the follow-up changes and O-10
implementation" — verify branch, HEAD, fingerprint and the N-26/CW02 separation; edit no application code unless a
concrete defect needs correction, and then stop for authorization. (b) After the REVIEW hand-back: "I approve option 1: fix
O10-1 now" — the smallest safe change; a deterministic regression test; preserve same-student re-authentication,
different-student switching, registration, simultaneous 401s, cold start and sign-out with a request in flight; record the
late-sign-in root cause separately for CW04; correct the stale records; re-gate; no commit, push, WALK, handoff or next wave.

### 12.1 Fresh REVIEW (21:28–22:05Z, read-only)

- **Tree.** `merged` @ `b227f61` = `origin/merged`; nothing staged; 60 status lines; status fingerprint = the §11 gate's end
  (`4d9ed7e263987317`); since that gate only `COMPLETION_STATE.md` and this file had changed. N-26: every line the peer added
  is present in all 29 of its files (the 30th, the tracked `test-results.md`, is the peer's blob `57716a44`); the old sample
  number is in no lib, test or CW02 file — it survives only in the R-3 roadmap `.html`, dated audit records under
  `.ai/audits/`, and `docs/STORE_READINESS_AUDIT_2026-09-05.md` (missing from O-9's list until now).
- **Re-gate (BUILD), 21:31:28–21:51:04Z — identical to §11:** format 0 changed / 333; gen-l10n no drift; ARB 273 = 273;
  analyze 0; the 18 targeted files with §11's counts; guards +124; contract 14/14; pin 2/2; `validate.sh` **2215/0/0**
  (21:40:42–21:45:33Z); `validate.ps1` **2215/0/0** (21:46:20–21:51:03Z); scans 0 / 0; fingerprint and per-file blob list
  identical at start and end.
- **Workflow:** 9 agents `claude-sonnet-5-5`, read-only, no toolchain — 4 finder → refuter pairs (O-10 isolation; the
  follow-ups and test effectiveness; records; scope, privacy, Fable) and a completeness critic. 23 findings (2 more were the
  agents' own hygiene notes): 2 refuted; **0 blocker, 0 major, 2 minor, 10 nits, 9 info** (some overlap).
  - **O10-1 (minor)** — overlapping sign-ins: Continue on the OTP success view matched the target against the id of its
    OWN outcome, but a verify from an OTP screen the student left still completes in the background (tokens written,
    `markAuthenticated` called — deliberate, R-2 / W3-1). A forced out → B's verify hangs → Back → A signs in → B's late
    answer lands (live session = B) → Continue handed A's location to the B session. Verified by the control plane at
    SOURCE, then **reproduced at BUILD** in a throwaway copy outside the repo (landed on
    `/learn/subject/sub-1/unit/unit-1`, expected `/home`). It broke the owner's O-10 requirement and contradicted §11's
    "resolved", so the REVIEW was **held** and authorization asked.
  - **CC-1 (minor, critic; verified)** — the WALK notes said the mock build shows the unknown-route page. It cannot:
    `lib/main_mock.dart` signs out on every launch (`kResetSessionOnLaunch = true`), a signed-out unmatched location goes
    to `/login`, and no in-app path reaches an unmatched location.
  - Nits: O10-2 (§11's swept-paths list omitted overlapping sign-ins), O10-4 (`forceLogout` doc overclaimed its guard),
    FOLLOWUPS-1 / RECORDS-2 (§1 still said F4 was untested), FOLLOWUPS-3 (`session_isolation_test` header named only
    `/me`), RECORDS-1 (four "Seif Q-B batch" pointers; that batch was never filed), RECORDS-3 (§1/§9 statements superseded
    by O-10), RECORDS-5 (`COMPLETION_STATE` gave the gate window as `validate.sh`'s), RECORDS-6 / SCOPE-2 (the commit
    proposal named only `otp_screen.dart` as mixing concerns; `otp_notifier.dart` does too).
  - Info: O10-3 (Android Back on the success view skips Continue: the same student lands on Home), RECORDS-4, RECORDS-7,
    RECORDS-8 (stamp), SCOPE-1 (`test-results.md` order), SCOPE-3 (explicit-path staging unstated), SCOPE-5 (the purchase
    regex cannot see `redemption`; the only hits are two doc comments naming the contract's web-only
    `verifyRedemptionSessionOtp`), SCOPE-6 (Fable #6 unmet, as expected), SCOPE-7 (three N-26 files are CRLF in the
    working copy).
  - Refuted: FOLLOWUPS-2 (TQ-1's positive control is sound at pinput 6.0.2), SCOPE-4 (§6 is a dated verbatim record).
- **Hygiene, disclosed.** Two review agents broke the no-write rule outside the repo (one stray scratch file, deleted by the
  control plane; one `/tmp` file, deleted by the agent). One agent's tool output displayed the old N-26 number from ARB
  history — local session transcript only, reproduced nowhere. The repo fingerprint was unchanged by the review.

### 12.2 O10-1 fix (owner-approved option 1)

Implementer `claude-sonnet-5-5` (one subagent); Opus control plane verified the diff, the scope and the evidence.

- **lib (2 files).** `ReturnTarget.sessionStarted(String? studentId)` (`lib/core/router/return_target.dart`): a sign-in
  completed — keep the remembered location only when its owner is that student; otherwise forget the location and the owner
  (no owner or a null id fails closed; fields assigned directly). `AuthController.markAuthenticated` calls it before the
  state flips — the one point every completed sign-in passes through (OTP verify, registration), so the target follows the
  LIVE session. The landing still names its own outcome id; it can now only match a target the live session's student owns.
  No change to `otp_notifier.dart`, `otp_screen.dart`, the router or the registration screens. Never the phone; nothing
  logged. Comments: `ReturnTarget` class doc; `markAuthenticated` doc; `forceLogout`'s "Idempotent" paragraph corrected
  (O10-4: the guard precedes the `clearTokens` await, so it stops only calls that arrive after the flip; calls overlapping
  the await run through, bind the same student, and the LAST reason wins).
- **Tests (+10, 3 files).** `return_target_test.dart` +8 (53 → 61): 6 unit tests of `sessionStarted` (owner keeps; another
  student, null id, no owner drop; the late-answer order; a drop forgets the owner) and 2 through the real router in
  "a verify the student walked away from completes late" — the late answer is B's → Continue lands on `/home`, the target is
  gone; **control:** the late answer is A's own → A is returned to the nested location with its stack.
  `registration_return_target_test.dart` +1 (4 → 5): the real `RegistrationSubmitNotifier` completing with no screen
  mounted still drops a target bound to another student. `session_isolation_test.dart` +1 (23 → 24): two OVERLAPPING
  `forceLogout` calls (Completer-gated `clearTokens`) both run, the binding survives, the final reason is pinned AS BUILT
  (the last call's); and its group header now names both id sources (FOLLOWUPS-3).
- **Mutation checks (throwaway copy outside the repo; restored hash-identical):** M1 `markAuthenticated` without the
  `sessionStarted` call → the late-B router test and the late-registration test fail; M2 `sessionStarted` always drops →
  12 tests fail, including the control and every same-student return; M3 keep when both ids are null → survives: an
  equivalent mutant (`consume` already returns the fallback when either id is null), so the null check is defence in depth.
  The implementer's own M1 run agreed.
- **Adversarial check of the fix** (`claude-sonnet-5-5`, read-only, SOURCE): no blocker, major or minor. Both orderings
  of overlapping sign-ins, late registration, overlapping 401s, cold start, `logout()` with the revoke in flight and every
  `markAuthenticated` caller in lib and test checked; no existing test weakened. Info: a residual window — a Continue
  tapped while the late verify is still writing its tokens (before its `markAuthenticated`) is closed only by BUG-026's fix.
- **Root cause recorded separately — `docs/KNOWN_BUGS.md` BUG-026 (open, CW04, owner decision):** a sign-in the student
  backed out of can finish later and silently replace a newer session (the screen says A, the session is B). Fixing it
  narrows the R-2 / W3-1 rule ("the tokens and the flip land regardless") that `verify_fork_test.dart` documents, so it is
  outside CW02 by the owner's "no broader refactor".

### 12.3 Records corrected

§1 (F4 now pinned; the unknown-location edges; Continue only for the same student), §6 (annotations only — O-10 resolved and
the race closed; Fable #2 downgraded and its "Q-B batch" never filed; #6 now 2225), §7 (refresh sentence), §9 (warning;
commit proposal — explicit paths, `otp_screen.dart` AND `otp_notifier.dart`, the `test-results.md` order; next action
marked superseded), §10 (dispositions marked done; the F1 reference), §11 (swept paths, status and WALK note superseded),
this header. Every refresh-question reference in this file and in `COMPLETION_STATE.md` now reads "a proposed Seif
question, SQ-31 — not yet in `02_SEIF_HANDOFF.md`"; it is not filed. `CW02_PLAN.md:39` (a dated plan record) is
annotated the same way; `04_COMPLETION_ROADMAP.md:75` still says "Q-B batch" — left as is, to keep that committed
deliverable out of this change set (it is updated when Seif answers). `COMPLETION_STATE.md`: header, active wave (gate vs `validate.sh` times), the O-10
and O-9 rows, the answers log, the WALK plan and the next action. Code and test comments: `forceLogout` (O10-4),
`session_isolation_test` header (FOLLOWUPS-3).

### 12.4 Re-gate after the fix (BUILD), 22:26:06–22:37:24Z

On the final source and test tree (`cw02_fx_gate.log`): HEAD `b227f61`, upstream contract `eddb6ac`, `contract/` untouched;
format **0 changed / 333** (326 tracked + 7 untracked); gen-l10n no drift; ARB 273 = 273, no duplicates; pubspec unchanged;
analyze **0**; the 18 targeted files alone all green — return_target **+61**, session_isolation **+24**,
registration_return_target **+5**, the other 15 unchanged (error_interceptor +51, auth_interceptor +10,
account_pending_deletion +21, otp_banned +13, mock_backend_banned +3, app_router +11, login_logout_message +3,
session_scope_discipline +6, otp_screen +6, otp_success_router +2, verify_fork +5, profile_relogin +4, otp_student_id +6,
login_validation +11, registration_screens +11); guards **+124**; contract **14/14**; pin **2/2**; `validate.sh` OVERALL
PASS **2225/0/0** (22:30:31–22:33:15Z); `validate.ps1` OVERALL PASS **2225/0/0** (22:33:38–22:37:05Z); logging **0** and
purchase-silence **0** over the 15 CW02 lib files (the 2 untracked included by name); widened store/payment scan:
3 hits, all doc comments (two name the contract's web-only `verifyRedemptionSessionOtp`, one uses the verb "store"); tracked `test-results.md` untouched; record-excluded fingerprint and per-file blob list (58 files) identical at
start and end; N-26 check: every peer-added line present in all 29 files. 2215 → 2225 = +10, all from this round's
tests. After the gate only records changed — `COMPLETION_STATE.md`, this file, one annotation in `CW02_PLAN.md`, and BUG-026's
wording (the residual window, and the claims audit's precision fixes); no source or test file.
**No DEVICE, no CI.**

**Files this round:** lib 2 (`return_target.dart`, `auth_controller.dart`); tests 3; records 3 (this file,
`COMPLETION_STATE.md`, `docs/KNOWN_BUGS.md` — new to the uncommitted set). Whole uncommitted tree: **59 files** besides the
two R-3 roadmap files — **23 N-26 only, 7 shared, 29 CW02 only** (14 lib, 11 tests, 4 records). Nothing staged.

### 12.5 Remaining findings

- **Blockers:** none.
- **Minor:** UI-1 (banned line 10 sp at ≈3.2:1; DG-03).
- **Nits:** UI-2 (banned title/subtitle copy; DG-03); F1 = Fable #2 (a body-less refresh failure keeps dead tokens —
  a proposed Seif question, SQ-31, not yet in `02_SEIF_HANDOFF.md`; filing it is O-3); Fable #3, #4, #5, #7 (hand-over
  notes, §6); Fable #6 (refresh the tracked `test-results.md` at commit time — §9). Accepted, unchanged: O-10 cannot be
  walked on the mock; the defensive `catch` in `_signedInStudentId` is untestable; most router tests hold `/me`; the M3
  equivalent mutant.
- **Outside CW02:** BUG-026 (CW04). **Info:** O10-3 (Android Back on the success view skips Continue: the same student
  lands on Home — within "where safe"); SCOPE-5; SCOPE-7.

### 12.6 WALK plan (corrected; not started — WALK needs an explicit owner word)

- **Ordinary mock build** (`flutter run --flavor staging -t lib/main_mock.dart`; signs out on every launch): the banned
  state with code `222222` in EN/AR × light/dark — code entry locked, Resend hidden, the primary button "Back to login",
  the notice announced by TalkBack; an ordinary sign-in lands on Home; a registration lands on Home. **Not** demonstrable
  there: a forced sign-out (the mock never answers 401), O-10 (every mock student has one id), the unknown-route page.
- **Staging debug build** (`flutter run --flavor staging -t lib/main_staging.dart`, which keeps the session across
  launches), against staging with whitelisted accounts:
  - forced sign-out on a nested Learn screen → the same student signs in and is returned there (supersede it by signing the
    same account in on a second device);
  - O-10: after A's forced sign-out, student B signs in → Home (needs a second registered whitelisted account; O-4);
  - the unknown-route page: sign in, stop the app, relaunch the same debug build with a launch-route override
    (`--route=<an unmatched path>`) so the cold start is signed in at an unmatched location — the override route is not
    yet tried on a device;
  - the banned state on staging needs a banned account (SQ-16, not sent).
- **Tests only:** the O10-1 race and overlapping forced sign-outs.

**Status: PASS WITH WARNINGS — O10-1 fixed and re-gated; awaiting the owner's review of this section.** Then any of: a
commit request (§9 as corrected); an explicitly authorized `WALK` (12.6); `NEXT WAVE` (roadmap order: CW18a). Nothing
committed, pushed, walked, filed or sent.
