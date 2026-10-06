# Wave Status — the single source of project truth

**Last updated:** 2026-09-22 (Leaderboard UN-GATED — D-008 closed: audit ran, `GET /leaderboard` verified against real staging, `/leaderboard` serves the real board; `validate.ps1` 1429 passed / 0 failed / **0 skipped** — the suite has no skipped test for the first time since 2026-09-10; previous: 2026-09-12 — Day 10 Mistakes SHIPPED — re-vendor to 3.13.0-m1, models/repository/notifiers, overview + tree screens, entry point live; `validate.ps1` 943 passed / 0 failed / 1 skipped; previous: 2026-09-12 — Day 10 brief written, flow blocked on the re-vendor; 2026-09-10 — leaderboard gated behind its placeholder, D-008; earlier:
2026-09-08 — Day 8-9, quiz review shipped, zero endpoints; 2026-09-05 — documentation
reconciliation to contract v3.0.0-m1, Phase 3B)
**Branch:** `merged` — `dev` + `main` joined on 2026-08-22 (`99b5cba`); both are kept
untouched as history and all work continues on `merged`.
**Unpushed:** the 2026-08-23 commits (style-fitting pass, OTP glyph landing, F-7-01,
smoke harness ×2) and the 2026-09-04 commits (contract 3.0.0-m1, model adoption,
purchase-surface removal, limit-sheet copy, records) — pushing is the owner's call (R-3). This file no longer
records a HEAD; `git log` is the source for that.

If any other document disagrees with this file about wave state, **this file
wins** and the other document is stale. Fix the other document.

---

## Environment & Architecture chapter — opened 2026-10-04

A dedicated chapter (identity / flavors / store-ready environment workflow) runs alongside the
API→UI waves. Its source of truth for *architecture* is `docs/ENVIRONMENTS.md`; its wave state is
`.ai/audits/current/env_chapter_state.md`; its fixed readiness scale is `docs/STORE_READINESS_RUBRIC.md`.
**Wave 0 (architecture & identity decision) done 2026-10-04. D-021 ratified 2026-10-06:** production
`com.levelupworld.app`, non-production `com.levelupworld.app.stg` (two identities, no DEV app), names
`Level Up` / `Level Up STG`, `Flutter 3.44.7 · Android 24/36/36 · iOS 15.0`. **Wave 1 (Android) done
2026-10-06:** Gradle flavors `prod`/`staging`, build-time flavor ⇄ entrypoint check, SDK literals, evolved
guards, CI/tool/hook updates — every Android command is now `--flavor <prod|staging> -t lib/main_<x>.dart`
(`ENVIRONMENTS.md` §4). Wave 2 (Flutter contract) next; Wave 3 (iOS) blocked on a Mac with Xcode 26.
Risk R-9 is mitigating. Rubric after Wave 1: see `docs/STORE_READINESS_RUBRIC.md` score log.

---

## Fable-eye full audit — 2026-10-06

A blind device traversal (Pixel 8 + the `Pixel_8` AVD, the mock build, every route, EN + AR, light + dark,
font scale 1.3) by an independent eye, then a cross-check of every historical issue, then fixes. Record:
`.ai/audits/current/fable_eye_audit_2026-10-06.md`. **Before:** the dirty Wave 21 tree committed and pushed
as `af0eadb` + `3913f86` (checkpoint), validate 2046 / 0 / 0. **Found:** 21 (none P0 / P1); **fixed and
DEVICE-verified:** 9 — the nav tabs, Profile rows, Subjects cards, the language pill and the dead controls
were images / progress bars / doubled nodes to TalkBack (BUG-021, BUG-024); the Leaderboard tab kept a stale
board after a quiz on its other scope (BUG-022); the Arabic Home headline was cut to "المستوى…" (BUG-023);
the Subjects cards overflowed at text scale 1.3 (BUG-002's second half, closed by the D-018 rule). **Recorded
for the owner:** DESIGN_ISSUES #120–#126. **After:** validate **2059 / 0 / 0** (+13 tests), analyze 0,
goldens unchanged. **Owed:** the Pixel half of the re-walk (the phone locked); the Phase 0 objections about
what the checkpoint push published (Wave 20, the forensic files) are the owner's call.

---

## Release-readiness reconciliation — 2026-10-06

The consolidation after the Fable pass, answering "what still prevents a release, and whose is it". Record:
`.ai/audits/current/release_readiness_reconciliation_2026-10-06.md`. **Verdict: NOT READY** — the eight store
blockers of the 2026-10-04 re-check all stand (production host, legal copy, account deletion, the iOS
required-reason API, the Message placeholder, reviewer login, retention facts, the web deletion URL); none is a
Flutter defect at HEAD. **Verified today:** no upstream contract drift (`0df5cf4` == `origin/main`); the Fable
fixes on the physical Pixel 8 (8 of 9 owed checks; 1.3 text scale stays emulator-only); a **release build of
HEAD on a device against staging** — login, catalogue, the whole quiz loop (+2 points), the board, offline,
sign-out — closing most of R-4 and narrowing R-8. **Fixed (red-first):** R-2 (`OtpNotifier.verify` captures
before its first await) and BUG-025 (`deviceInfoProvider` retry), with the retry rule mechanised as a guard.
**New risks:** R-10 (the planned "/redeem" hand-off vs the purchase-silence rule), R-11 (E-4's root cause is
the plugin's empty privacy manifest). **For the owner:** O-1…O-15 in the record (hide the Message tab for
release 1; the E-4 fix shape; UGC Option 0; the deletion-copy ruling; inert surfaces; minors' purpose text;
BUG-017 wording; the Phase 0 objection). **For Seif:** Q-B1…Q-B10 (retention facts first). **Validation:**
`validate.ps1` **2067 / 0 / 0** (2059 + 8, exactly as predicted), analyze 0; its first run also caught a test file the Fable pass committed unformatted (`disabled_action_button_test.dart`, never seen by the earlier validate because it was untracked then) — formatted in its own commit.

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
| **Docs 09-05** | Documentation reconciliation to contract 3.0.0-m1 (Phase 3B) | ✅ COMPLETE (2026-09-05) | uncommitted — see the dated section below | documentation only; `validate.ps1` 862 passed / 0 failed | review-only pass — see the dated section below |
| **Day 8-9** | Quiz Review screen (`162:2377`) — session-scoped, **zero endpoints** | ✅ COMPLETE (2026-09-08) | uncommitted — see the dated section below | BUILD VERIFIED; `validate.ps1` 911 passed / 0 failed | not yet reviewed |
| **Leaderboard** | Board live on `/leaderboard` — D-008 CLOSED (`docs/D008_LEADERBOARD_AUDIT.md`) | ✅ **SHIPPED** (2026-09-08 built · 2026-09-10 gated · 2026-09-22 audited + un-gated) | `GET /leaderboard` (`stable`, `openapi.yaml:2007`); `getMyRank` stays unconsumed by decision | **API VERIFIED** — decoded against staging `0f97f289` 2026-09-22; `validate.ps1` 1429 passed / 0 failed / 0 skipped. **Device pass still owed** | not yet reviewed |
| **Day 10** | Mistakes / "My Fault" — overview + both tree shapes, `docs/day10_mistakes_brief.md` | ✅ **COMPLETE (2026-09-12)** — the gate passed: `contract/` re-vendored to `2dca3c5` (3.13.0-m1), so both operations now exist at our own pin. Read-only; the replay quiz is deliberately NOT built | uncommitted — see the dated section below | BUILD VERIFIED; `validate.ps1` 943 passed / 0 failed (1 skipped) | not yet reviewed |
| **Final** | Whole-project Fable review | ⏳ NOT STARTED | — | — | — |

---

## Day 10 — the Mistakes / "My Fault" flow, 2026-09-12

**What shipped.** `GET /me/mistakes` and `GET /me/mistakes/subjects/{subjectId}`, as five screens:
the overview (`404:6292` / `404:7110` — **one screen, both tracks, no branch**, because the two
frames are pixel-identical and the endpoint takes no track parameter), the subject route that
switches on the payload's `track` discriminator, and the school drill-down's two deeper levels.
University stops at a flat lecture list with **no quizType tabs** — `UniversityMistakesTree`
carries no `quizTypes`, and frame `404:7181` draws no tab row, so contract and design agree.

The entry point is live: `_MistakesButton` on the Subjects header pushed a coming-soon snackbar
from Day 6 until today, deferred four times for one reason — no endpoint. That reason expired at
contract `3.10.0-m1`.

**Endpoint coverage: 21/29 → 23/29 stable · 0/13 draft.** The denominator was **recounted from
the vendored file**, not copied from the brief: 42 operation blocks carry `x-stability` at indent
6, of which **29 stable / 13 draft**. It moved from 21/21 because the re-vendor made eight
operations stable, not because this day consumed six of them — the numerator rose by exactly two.

**One fetch per subject, four screens.** The tree arrives whole and the levels below are VIEWS
over the cached object, as the catalog drill-down already is. A test asserts `called(1)` across a
three-screen walk.

**What was reused rather than rebuilt.** `CatalogScaffold` (it *is* the frame's header component
`404:7413`), `CatalogMessage`, `CatalogBlock`, `CatalogListSkeleton`, the Subjects grid delegate,
and `TreeListRow` — whose geometry already matched `404:6642` exactly (363 × 78, radius 16, 0.5px
border). The row gained an optional `countLabel` slot and a `TreeRowPalette`; it was not cloned.

**Three decisions were the owner's, and were asked before any code was written:**

1. **Dark values.** All four new tokens are identical in both palettes. The dark frames exist but
   their hexes were never captured, and every alternative measured worse — see DESIGN_ISSUES #70,
   which also **corrects its own premise** with the numbers.
2. **Empty-state copy.** Neutral (`noMistakes`), matching the register the app already uses. No
   celebratory tone was invented (#60).
3. **Inert leaves.** Lessons and lectures drop their chevron and ripple rather than looking
   tappable and swallowing the tap — the replay quiz is a separate day.

**Two contract subtleties are held apart by tests, not by prose.**
`insufficient_scope` means *"this subject isn't yours"* on the subject route and *"you have no
active enrolment right now"* on the overview — same code string, different meaning, and the
changelog says outright not to collapse them. `CatalogAsyncView` now takes the meaning as a
`ScopeErrorCopy` parameter; the overview's `403` also **keeps its retry button**, because a track
transfer resolves on its own (#61). Separately, **no count is ever computed**: a fixture whose
parents deliberately disagree with their children proves the client renders the server's number
rather than the sum (adr-133).

**`account_pending_deletion` is not handled here and that is deliberate** — it belongs in the
global interceptor, one place for every endpoint. All these screens guarantee is that it is not
swallowed or mistaken for a scope refusal. `TODO(contract)` → `seif_fight.md` S38.

**A first for this codebase:** `mistakeCount` is the project's only ICU `plural`. Arabic carries
all six categories, and they are genuinely different words rather than one stem with a number in
front (#66).

**Ratchets unmoved.** Hardcoded `fontSize` **0**, inline `fontWeight` **0** — the frames' five
type styles (which mix Inter with Cairo) were mapped to the nearest existing `AppType` entries on
the #57 precedent, and **Cairo was not added to the design system** (#68). No colour outside
`lib/core/theme/`. No Bloc outside the quiz. No guard was weakened; two of them caught real bugs
during Step 1 and were right both times.

**Verification level: BUILD.** Widget tests through the real router, not a device. Dark mode in
particular is a widget-test claim only — memory records it as dead on device 2026-08-04 and never
re-confirmed.

**Not done, deliberately:** the replay quiz (`404:6853` / `404:7234`), which is what makes the
leaves inert; the account-deletion cancel screen; flashcards; favourites; quiz history.
(Un-gating the leaderboard was on this list until 2026-09-22, when D-008 closed — it did
get its own decision and its own commit, as written.)

**Still owed by others:** the designer's ruling on the count caption's measured **2.68:1** on its
own card (#71, found by measurement during this build), on the Arabic count wording (#59), and on
whether the Cairo/Inter mix was intentional (#68); a capture pass over the dark frames' hexes
(#70) and the RTL node-ID map (#64).

---

## Leaderboard UN-GATED — D-008 closed, 2026-09-22

**What changed.** `/leaderboard` serves `LeaderboardScreen`. The gate D-008 put up on
2026-09-10 is closed, and the section below is **superseded** — kept because it records the
sequence.

**What actually closed it, and what did not.** Not the stability flip: `getLeaderboard` became
`stable` on 2026-09-05 and the placeholder stayed up for seventeen more days, correctly, because
un-gating was never a revert. What closed it is the audit the Correction of 2026-09-10 asked for
— `docs/D008_LEADERBOARD_AUDIT.md` — against the six behavioural changes the board predates.
**Verdict: the board passes, and no file under `lib/features/leaderboard/` was changed to make it
pass.** Four changes are actively honoured; two are N/A because `getMyRank` is deliberately not
called.

**The board has met a real server.** `GET /leaderboard` decoded through the real repository
against staging `0f97f289` on 2026-09-22 — one row, `hasMore: false`, `isMe` true on it
(`.ai/audits/current/smoke-staging-2026-09-22.md`). Both leaderboard routes answer `401`
unauthenticated, not the `404` an absent route gives, so both are deployed. **Endpoint coverage
21/21 → 22/22 stable.**

**Verification level: API, and that is the ceiling here.** One account, one scope, a one-row
board. Pagination, the 200-row bound, short pages, `governorate`, both university scopes and the
privacy filtering were NOT exercised against a server and remain BUILD-level. **The device pass
D-008 asks for is still owed** — every previous device sighting of this board ran on a local edit
that was reverted the same session (`DEVICE_VERIFICATION_2026-09-20.md:31`).

**The suite has no skipped test for the first time since 2026-09-10.** `validate.ps1` — format
PASS, analyze PASS (0 issues), **1429 passed / 0 failed / 0 skipped**, OVERALL PASS. The count
moved 1427 → 1429 for accounted reasons: the shell's placeholder test splits back into two (one
for Message, one asserting the Leaderboard tab is the real board), and the skipped shell-branch
test rejoins the passed column.

**Carried forward unchanged, so un-gating does not imply they closed:** the share button is
visible and inert (no sharing surface in the contract, and a board carries minors' names and
scores); there is no realtime (`contract/realtime.md:9` — hub "not drafted"); the podium shows no
`level` (the contract carries none on this endpoint and one was not invented); and
`403 account_pending_deletion` still cannot route to a cancel screen that does not exist. One
audit finding (F-1) is recorded and deliberately not fixed — it needs a copy decision.

---

## Leaderboard gated behind its placeholder, 2026-09-10 — SUPERSEDED by the section above

**What this corrects.** A complete leaderboard entered the tree on 2026-09-08 — 13 files under
`lib/features/leaderboard/`, 25 tests — and was wired live on the shell's second branch. This file
never recorded it, and its 25 tests were folded silently into the 911 the Day 8-9 section
attributes to quiz review. Both gaps are closed here.

**Why it was gated.** It is built against a path that is **draft at our pin**. `openapi.yaml:1221`
marks `GET /leaderboard` `x-stability: draft` and `:1263` marks `/leaderboard/me` the same at
`184d6ec`. No ruling authorising the build existed in `DECISIONS.md` or `seif_fight.md`.

⚠️ **Corrected the same day, and it matters.** A comment in `tab_placeholder.dart` had asserted
the two operations "reached `x-stability: stable`", and this section originally called that a
false claim. **It was not.** Upstream is at `f860408` — 13 commits and ten minor versions past our
pin (`3.0.0-m1` → `3.10.0-m1`) — and both operations became `stable` in **`3.5.0-m1` on
2026-09-05**, five days before the gate. The board also quotes contract text that does not exist
at our pin (*"Do not add a synthetic self-rank row to the board"*; `limit` *validated, not
clamped*, a `3.7.0-m1` clarification), so it was built against **`3.7.0-m1` or later**. The
engineer was reading the live contract; **the vendored copy is the stale artefact.** The gate
still stands — the app builds against the *pinned* contract — but it is a holding action pending
re-vendoring, not a verdict on the board. Full account: `DECISIONS.md` D-008, Correction of
2026-09-10.

**What changed** (owner ruling, 2026-09-10 — full reasoning in `DECISIONS.md` D-008):
`LeaderboardPlaceholderScreen` restored in `tab_placeholder.dart` with an accurate doc comment;
`app_router.dart:150` serves it again; `main_shell_test.dart` back to asserting two coming-soon
placeholders; `leaderboard_screen_test.dart` mounts the screen directly instead of tapping the nav
tab, keeping 13 of its 14 tests live. **Nothing under `lib/features/leaderboard/` was deleted** —
the board is finished code waiting on a server, not work in doubt.

**Endpoint coverage: 21/21 stable · 0/15 draft** — the leaderboard would have made it 1/15, and no
longer does.

**One test is skipped, not deleted.** `back goes to the Home tab, not off the shell` asserts on
`MainShell`, which the board no longer sits inside. It carries its reason in source and un-skips in
the same commit that restores the route.

**Verification level: BUILD.** `validate.ps1` 2026-09-10 — format PASS, analyze PASS (0 issues),
**909 passed / 0 failed**, 1 skipped, OVERALL PASS. Not DEVICE, not CI. The board has never met a
real server: `GET /leaderboard` was unreachable in both staging probes, and being draft it is not
in the 21.

**The count moved 911 → 909, and both tests are accounted for.** One: `main_shell_test.dart` had
split its placeholder test in two (`Message is the last coming-soon placeholder` +
`the Leaderboard tab is the real board`); reverting restores the single
`the two unbuilt tabs are coming-soon placeholders`, so `testWidgets` goes 6 → 5. Two: the skipped
shell-branch test leaves the passed column. Nothing else was lost — the board's other 24 tests all
still run.

---

## Day 8-9 — Quiz Review shipped, 2026-09-08

The screen at `162:2377`, reachable from the result screen's **Review Questions** CTA, which had
shipped disabled since Day 7.

**The correction that unblocked it.** `seif_fight.md` S14 said review was blocked on
`GET /quizzes/{quizId}` (`x-stability: draft`). That was true of review from HISTORY and was read as
true of the frame's actual entry point, which it is not: when `POST /quizzes/{quizId}/finish`
returns, `QuizSession` already holds every field the draft `QuizReview.questions[]` schema would
return — the questions, the chosen option, the correct option, correctness, explanation
availability. The only obstacle was that `QuizCompleted` dropped the session. S14 is now **narrowed,
not closed**: history, cold-restart review and quiz resume (S2) still need the promotion.

| Commit | Concern | validate.ps1 |
| --- | --- | --- |
| Step 1 | the screen, its route, its palette tokens, the retained session | PREDICTED 890 → 904 (+14 review-screen tests) · **ACTUAL 904 / 0** |
| Step 2 | the CTA goes live; `reviewQuestionsComingSoon` retired; records corrected | PREDICTED 904 → 905 (+2 CTA tests, −1 obsolete disabled-CTA test) · **ACTUAL 905 / 0** |
| Review fixes | contrast, text scale, tap targets, `explanationAvailable`, semantics | PREDICTED 905 → 911 (+6) · **ACTUAL 911 / 0** |

**Endpoint coverage is UNCHANGED: 21/21 stable · 0/15 draft.** Recounted from the pinned contract
(`184d6ec`) rather than copied — 36 operations carry `x-stability`, 21 stable and 15 draft, none
without. Two other documents disagree and are wrong: the Day 9 brief says `0/16` (it predates the
2.2.0-m1 deletion of `POST /checkout/sessions`), and `PROGRESS.md:257` claims 14 remaining draft
paths.

**Verification level: BUILD.** `validate.ps1`, this machine, this session — not DEVICE, not CI. In
particular **the RTL and dark-mode passes are BUILD-verified only**: they are asserted by widget test
(`quiz_review_screen_test.dart` renders Arabic, dark, and both together), which is stronger than
reading the source and weaker than looking at a phone. The Day 8-9 brief's definition of done asks
for DEVICE verification of both, and memory records dark mode as **dead on device on 2026-08-04**,
never re-confirmed. That gap is open.

**Owner rulings taken, 2026-09-08** (the brief's §3 stop-and-ask, answered in writing before Step 1):
the review frame's wrong-row colours are treated as drift and the shipped tokens reused
(DESIGN_ISSUES #52); dark rows stay **opaque**, following the correctness-signal rule at
`app_colors.dart:236` rather than the frame's 20% alpha (#53); the frame's four text styles map to
the nearest existing `AppType` entries rather than extending the scale (#57). The ratchet stayed at
**0** — no inline `fontSize`, no inline `fontWeight`.

**What the §3.2 ruling turned out to cost, and the fix.** Keeping the dark rows opaque is right, but
it has a consequence neither the brief nor the ruling anticipated: `quizCorrectFill` is opaque
`#BFFFC3` in BOTH canvases, so a row foreground that follows the theme puts cream on mint — measured
**1.11:1**, invisible. The first cut of this screen did exactly that. Fixed by making the foreground
follow the FILL rather than the canvas: the correct row takes a fixed `#384F47`
(`quizReviewRowContent`, now identical in both palettes), while the wrong and skipped rows take
`textPrimary`, because `quizWrongFill` is 30% alpha and `quizOptionFill` does follow the canvas
(6.94:1 dark). The selected filter chip had the same class of fault — `onPrimary` cream on the dark
chip's purple, 2.74:1 — and gained its own token (5.48:1). Both are asserted by test.

**A pre-existing instance of the same fault, NOT fixed here.** `question_option_tile.dart:119-120`
paints the quiz page's option label with `textPrimary` on `quizCorrectFill`. In dark that is the
identical **1.11:1** cream-on-mint. It is shipped UI outside this day's scope and is left alone
deliberately rather than changed without a ruling — recorded here so it is not rediscovered as new.

**Also found and corrected during review:** the AI glyph ignored `AnswerResult.explanationAvailable`
and promised an explanation on every wrong row; `_ReviewRow`'s fixed 73px height overflowed from text
scale 1.35 (Android's largest standard setting is 1.30) and the filter chip clipped its own label
from 1.15, silently, because cross-axis overflow is not reported; the chips were a 32dp tap target
against a 48dp floor; and the row announced itself to screen readers as an image.

**Deliberately not done in this wave** (listed so nobody infers they were): review from history and
after a cold restart (needs the S14 promotion); the AI glyph as a tap target (no destination frame —
DESIGN_ISSUES #56); a skipped-row design (#55); the Mistakes / "My Fault" flow; favouriting from
review (all three endpoints draft); a golden test for the screen.

---

## Documentation reconciliation — 2026-09-05 (Phase 3B, documentation only)

**Scope.** No application code, test, model, route, ARB, `contract/` file or `zna.md` changed
(`zna.md` was explicitly excluded from this phase). Every change is a `.md`/`.json` record or
instruction file. The contract pin is unchanged at `184d6ec` (3.0.0-m1).

**What changed.**
- `docs/seif_fight.md` restructured in place. **Part A** is the contract-change ladder —
  LEVEL 0 (the 2026-06 product briefs, provenance only, no score), LEVEL 1 (1.0.0-m1, `23f0535`),
  LEVEL 2 (1.1.0-m1, `ee2ed8f`), LEVEL 3 (2.1.0-m1, `61905ce`), LEVEL 4 / CURRENT (3.0.0-m1,
  `184d6ec`); each transition is scored on nine anchored 0–5 dimensions (A: 31, B: 18, C: 36)
  with the lead's qualitative reading shown beside the band, every count taken from `git show
  --stat` or a commit body, no hours or days anywhere. **Part B** is the S-register as it was,
  with S6 re-anchored (its `openapi.yaml:1002`/`:1027` citations were deleted with
  `/checkout/sessions`), S37's ask corrected to the school cohort, and S39–S41 filed from the
  Phase 2 audit §9C.
- The auto-loaded instruction set now matches the contract: five `.claude/skills/*/SKILL.md`,
  `river/evals/evals.json`, this repo's `CLAUDE.md` §1.2 and the out-of-repo `F:\level\CLAUDE.md`
  — there is no `pending` entitlement state (`openapi.yaml:754`) and the app is purchase-silent
  (adr-049 §3). Phase 2 FINDING-01 closed.
- Dated records stamped, not rewritten: the Day 7 / 7b / 7c / 8 / 9 briefs carry superseded-pin
  banners and inline callouts (the ten-field `QuizSummary` block stays verbatim as evidence);
  K-3 retired in `known-issues.md`; forward pointers in `api-data.md`, `wave3-implementation.md`,
  `final-summary.md` and `PROGRESS.md`. The 2026-07-28 reports and the rest of the 2026-08-11
  audit package are untouched history.
- School-vs-university correction. The smoke account `+2010000000001` is **school-track**;
  school subjects are never release-gated (adr-073, `openapi.yaml:795-799`), so its empty catalog
  means no subjects are seeded for its (education system, stage) cohort — not an unreleased term.
  Corrected in `smoke-staging-2026-09-04.md` (prose only — the verbatim harness block is
  untouched and footnoted), `RISKS.md` R-8 and `seif_fight.md` S37. The right ask is to seed that
  cohort, or to register a university test account.
- Current-state guides: `PROJECT_GUIDE.md` (`TBD.example` is prod-only; `subscription` is an
  empty scaffold), `AGENT_WORKFLOW.md`, `RELEASE_SIGNING.md`, `ASSET_MANIFEST.md`,
  `for_seif_account_surface.md`, and the untracked `STORE_READINESS.md` and
  `CONTRACT_3_0_0_IMPLEMENTATION_IMPACT.md` (status note only).

**Deliberately not changed:** `zna.md` (excluded — its "seed a released term" ask is still
university-shaped; deferred); the `F:\level\*.md` product briefs (outside the repo — they still
describe a Paymob hand-off and a Fawry `pending` state; flagged in `seif_fight.md` LEVEL 0);
`tool/smoke/real_api_smoke_test.dart`'s `v2.1: pre-term accounts` log string and the stale
in-code comments the Phase 2 audit lists as items 17–24 (Dart — out of scope, recorded in
`seif_fight.md` LEVEL 4); the untracked `skills/` mirror.

**Verification level: BUILD** — `validate.ps1` 2026-09-05T02:27Z: format PASS, analyze PASS,
**862 passed / 0 failed**, OVERALL PASS — unchanged from 2026-09-04, as expected for a change that
touches no Dart. Not DEVICE, not CI. Nothing here changes what the app does; the 3.0.0-m1 `finish`
body remains **not yet observed on the wire**.

**Method.** One lead agent; five read-only investigation agents (documentation inventory, contract
history, client rework evidence, day briefs and fix queue, staging records); three writers on
disjoint file sets; a lead integration and correction pass (the ladder's Day 4/5 timing,
`schoolName` timing and an S21 misattribution were corrected before review); then a review-only
Fable pass — **PASS WITH WARNINGS**: scope clean, staging facts and every sampled contract
citation verified; its findings were arithmetic and citation slips in the ladder (day counts,
two commit stats, "net" vs "deletions", one figure git did not support — `net ≈ −300` — and the
`PATCH /me` 405 wrongly attributed to build `fbab748`) plus two current-state sentences in this
repo's `CLAUDE.md`. All were applied by the lead after the review; Transition B's Tests score
moved 2 → 3 (total 17 → 18, still MEDIUM). Optional follow-up left open: per-file supersession
stamps inside the 2026-08-11 audit package (only `final-summary.md` carries one).

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
`schoolSearchProvider` (they need `retry:` returning null); the W3-1 fix itself; ~~Day 9 quiz
review~~ (**shipped 2026-09-08 — see the Day 8-9 section above**); the account-deletion screen
(S38 — no endpoint); voucher redemption (`x-consumers: [web]`, must not be built).

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
