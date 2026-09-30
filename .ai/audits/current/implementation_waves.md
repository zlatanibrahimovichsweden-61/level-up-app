# Implementation waves — one wave per screen (FORMULATE, 2026-09-24)

**Input:** `figma_ui_comparison.md` (22 UI-assisted screens), `api_ui_endpoint_inventory.md`,
`endpoint_ui_mapping.md`, `screen_api_gaps.md`. Contract `ea83099` / 3.23.0-m1.
**Rule:** waves = screens = **22**. A screen that COMPARE found READY still gets a wave: it is a
**verify-and-walk wave** (no code unless the walk finds a defect), so every screen ends with an
acceptance percentage.

## Standing workflow for every wave

1. `git status --short` + `ListAgents`; announce the file list to peers; never touch
   `project_files_*` (another session's) or `contract/` (only re-vendored, never edited).
2. Skills: `build-screen` (the loop), `figma-frame` (re-read the frame with `get_design_context`
   at build time — COMPARE values are leads, not specs), `screen-states`, `river` (or `bloc` for
   quiz), `seif-api-contract`, `level-up-domain`.
3. Build small; `dart format` + `flutter analyze` after each edit; `tool/validate.ps1` must end
   **OVERALL: PASS** with a test count ≥ the previous wave's (baseline **1429**).
4. Every ruled divergence goes into `docs/DESIGN_ISSUES.md` in the same wave; product/contract
   questions go to the owner or `docs/seif_fight.md`. Never invent a value.
5. WALK only on the user's `WALK`: `flutter build apk --debug -t lib/main_mock.dart`, `adb install -r`,
   OTP `000000` = school, `111111` = university; tap coordinates from a `uiautomator` dump; no
   hardware BACK (kills the app). Quiz and Review set FLAG_SECURE (screencap is black by design):
   the walk may override `screenProtectionProvider` **in `lib/main_mock.dart` only, locally, reverted
   after, never committed**.
6. Acceptance % = passed criteria / total criteria listed in the wave (F = functional,
   V = visual, I = interaction/a11y). Criteria that cannot be exercised on the mock are scored
   **N/A** and excluded from the denominator, and the walk report names them.
7. Nothing is committed unless the owner asks. When asked: one concern per commit; the contract
   re-vendor (`contract/*`) is its own commit.

## Order and why

| Wave | Screen | Kind | Dependency reason for this position |
| --- | --- | --- | --- |
| 01 | Login | build | every walk starts at `/login` (mock clears tokens on launch); lands the shared LTR fix for the `+` dial code |
| 02 | OTP | verify | follows Login in the flow |
| 03 | School registration | verify | school OTP `000000` path |
| 04 | University registration | verify | university OTP `111111` path |
| 05 | Home | build | first shell screen; Top Student reuses the leaderboard data path |
| 06 | Leaderboard | verify | walked right after Home so the Top Student rows and the board can be compared; D-008's owed device pass |
| 07 | Subjects | build | **lands the shared chevron helper** used by waves 08–09 and 15–18 |
| 08 | Subject tree root (Units / Lectures) | build | **lands `TreeListRow` button semantics** used by 09–10 and 16–18 |
| 09 | Chapters | verify | inherits 07 + 08 |
| 10 | Lessons | verify | inherits 07 + 08; entry to the quiz |
| 11 | Quiz setup | build | reached from Lessons; the subject caption needs catalog args from 10 |
| 12 | Quiz question | build | follows setup; the popup item is gated on an owner ruling |
| 13 | Quiz result | build | follows the quiz; shares the subject-caption decision with 11 |
| 14 | Quiz review | verify | follows the result |
| 15 | Mistakes overview | build | needs graded answers (a quiz) to be meaningful; inherits 07 |
| 16 | Mistakes subject | build | inherits 08's row semantics; measures BUG-002 on rows |
| 17 | Mistakes chapters | verify | inherits 07 + 08 |
| 18 | Mistakes lessons | verify | inherits 07 + 08 |
| 19 | Profile | build | logout → re-login fix is verified on Home and Profile together |
| 20 | Edit Profile | build | **lands mock `PATCH /me`** needed by 21 |
| 21 | Settings | build (gated) | needs 20's mock; account deletion is gated on a design |
| 22 | Flashcards | build (gated) | new screen; gated on five design answers; entry lives on 08's Lectures view |

This is sequencing, not a ranking.

---

## WAVE 01 — Login

- **SCREEN:** Login · **ROUTE:** `/login` · **FIGMA:** `82:819` (dark `337:15652`), consent text `82:1086`
- **PRIMARY FLOW:** enter phone → Send OTP → `/otp`
- **ENDPOINTS:** `POST /auth/otp/request` (requestOtp)
- **DEPENDENCIES:** none. Shared fix also touches `signup_identity_screen.dart:267-270` (same bug,
  smallest change, both sites tested).
- **CURRENT:** complete flow, 9/9 functional, visual matches.
- **MISSING:** (1) `+20` dial-code `Text` has no LTR isolate (`login_screen.dart:298-301`) → renders
  `20+` in Arabic. (2) Legal line wording differs from `82:1086` — **design/legal question**, fold into
  DESIGN_ISSUES #9; do not change copy without a ruling.
- **FIGMA REQUIREMENTS:** re-read `82:1086` text verbatim; language pill `82:1093` height (36.1 dp —
  record the touch-target fact).
- **TESTS:** widget test — dial code renders `+20` (LTR run) under `ar` locale at both sites.
- **DEVICE WALK:** launch → AR + EN → dial chip reads `+20` → valid/invalid phone → offline banner →
  Send OTP → `/otp`; light + dark.
- **ACCEPTANCE (10):** F1 requestOtp sent with `{phone}` · F2 loading state · F3 inline error ·
  F4 offline banner + disabled CTA · F5 navigates to `/otp` · V1 layout vs `82:819` · V2 dark vs
  `337:15652` · V3 `+20` correct in AR · I1 keyboard submit · I2 language toggle switches AR/EN.

## WAVE 02 — OTP (verify)

- **SCREEN:** OTP · **ROUTE:** `/otp` · **FIGMA:** `82:1171`, error `82:1170`, success `155:786`, dark `337:19271`
- **PRIMARY FLOW:** 6 digits → Verify → success → `/home`, or `registrationRequired` → `/register`
- **ENDPOINTS:** `POST /auth/otp/verify`, `POST /auth/otp/request` (resend)
- **DEPENDENCIES:** wave 01.
- **CURRENT:** 9/9 functional; ⚠ #5 #25 #49 ruled.
- **MISSING:** none in scope. Cross-cutting (not this wave): width cap on tablets, 35 dp back chip (#80 / D-013).
- **TESTS:** existing suite; no new code.
- **UPDATE 2026-09-24 (at `NEXT`):** the build-time frame re-read found frame-proven defects, so this
  wave became a build wave — W02-1 error state (`82:1439` / `337:19284`), W02-2 timer content colour,
  W02-3 language pill on the input view, W02-4 success gap 75. Recorded in `wave_state.md`; the
  acceptance criteria below are unchanged.
- **DEVICE WALK:** wrong code (`otp_invalid` red boxes) → resend timer → correct code both tracks →
  success view → Home; AR + EN; offline.
- **ACCEPTANCE (9):** F1 verify request shape · F2 invalid-code state · F3 resend countdown · F4 success
  view · F5 fork to `/register` for a new number · F6 offline disables verify/resend · V1 vs `82:1171` ·
  V2 error vs `82:1170` · I1 auto-advance + auto-submit.

## WAVE 03 — School registration (verify)

- **SCREEN:** School registration detail · **ROUTE:** `/register/school` · **FIGMA:** dark `337:5269`, light `125:511` (read it this wave)
- **PRIMARY FLOW:** country → governorate → city → education system → grade → school search → Start Learning → `/home`
- **ENDPOINTS:** `GET /reference/{countries, countries/{c}/governorates, cities, education-systems, schools}`, `POST /auth/register`
- **DEPENDENCIES:** 01–02 (new number reaches `/register`).
- **CURRENT:** 10/10 functional; ⚠ #2 #44.
- **MISSING:** none in scope; read the light frame `125:511` (COMPARE only read dark).
- **DEVICE WALK:** full school registration on the mock; school search paging; per-picker retry; AR + EN; light + dark.
- **NOTE (2026-09-24):** the light-frame read found two frame-proven defects (W03-1 rhythm 25,
  W03-2 subtitle grey), so this verify wave carried a small build, like Wave 02. Shared-widget
  differences went to DESIGN_ISSUES #90 unbuilt (they would move Wave 04's screen).
- **ACCEPTANCE (10):** F1 each picker loads · F2 cascade resets children · F3 school search pages
  (load-more) · F4 validation errors inline · F5 submit → `/home` · F6 expired token view · V1 light vs
  `125:511` · V2 dark vs `337:5269` · I1 scroll with keyboard · I2 AR layout.

## WAVE 04 — University registration (verify)

- **SCREEN:** University registration detail · **ROUTE:** `/register/university` · **FIGMA:** dark `337:10373`, light `125:2336` (read it)
- **PRIMARY FLOW:** university → faculty → study year (`active` only) → governorate → city → Start Learning
- **ENDPOINTS:** `GET /reference/universities`, governorates, cities; `POST /auth/register`
- **DEPENDENCIES:** 01–02.
- **CURRENT:** 10/10; ⚠ #3 (governorate missing from frame), #4 (field order — designer sign-off pending; nothing to build either way).
- **DEVICE WALK:** full university registration; `soon` study year not selectable; AR + EN.
- **NOTE (2026-09-24):** light `125:2336` draws the cascade order (University first) — #4 is now a
  dark-frame fix for the designer. Small build like Waves 02–03: W04-1 rhythm 25, W04-2 subtitle grey.
- **ACCEPTANCE (9):** F1 universities load · F2 faculty cascade · F3 `soon` years disabled · F4 city
  escape (adr-028) · F5 submit → `/home` (university catalog) · V1 light vs `125:2336` · V2 dark vs
  `337:10373` · I1 disabled-option treatment · I2 AR layout.

## WAVE 05 — Home

- **SCREEN:** Home · **ROUTE:** `/home` · **FIGMA:** school `59:1439`, university `125:2373`; Top Student block `337:5460` (per #72 table)
- **PRIMARY FLOW:** land after login → level card + points → sections
- **ENDPOINTS:** `GET /me`; **`GET /leaderboard` (new consumer)**
- **DEPENDENCIES:** none in code; walked after 01–04.
- **CURRENT:** header + level card real; Top Student is a `ComingSoonSection` with a stale "no endpoint yet" comment (`home_screen.dart:27`).
- **MISSING:** (1) **Top Student ← `GET /leaderboard`** — read the frame for the row count, avatar/name/points layout and which
  `scope` it implies; if the frame does not settle `scope`, **stop and ask** (never guess). Four states for the block
  (loading, empty board, error, offline) and `429`/`403` handling consistent with the Leaderboard tab. (2) Update the stale
  comment. Out of scope: Daily Tasks (no operation), Continue Learning (`GET /quizzes` draft), bell (draft).
- **FIGMA REQUIREMENTS:** `get_design_context` on the Top Student block, both tracks; light + dark (dark elevation via the Glass records, #72).
- **TESTS:** widget tests for the block's four states; notifier test that Home and the board don't double-fetch needlessly
  (share or scope the provider deliberately); purchase-silent guard stays green.
- **DEVICE WALK:** school + university Home; Top Student shows mock peers; points refresh after a quiz; offline; AR + EN; light + dark.
- **ACCEPTANCE (11):** F1 `/me` level + points · F2 Top Student renders board rows · F3 block empty state · F4 block error/retry ·
  F5 offline · F6 points refresh after a quiz · V1 school vs `59:1439` · V2 university vs `125:2373` · V3 Top Student vs frame ·
  V4 dark · I1 tap behaviour of Top Student matches the frame (or is inert if the frame draws no action).

## WAVE 06 — Leaderboard (verify)

- **SCREEN:** Leaderboard · **ROUTE:** `/leaderboard` · **FIGMA:** `133:3117` / `134:3626` (read the university frame this wave)
- **PRIMARY FLOW:** tab → System/Governorate toggle → scroll → pagination
- **ENDPOINTS:** `GET /leaderboard` (scope, cursor, limit), `GET /me`. `GET /leaderboard/me` stays unused (D-008).
- **DEPENDENCIES:** 05 (compare Top Student with the board).
- **CURRENT:** 8/9 functional, 7/9 visual; ⚠ #86, toggle AA.
- **MISSING:** log the "NOW / Last Month" (frame) vs `System | Governorate` (contract) divergence as a numbered DESIGN_ISSUES entry.
- **DEVICE WALK:** this is the device pass D-008 still owes: both scopes, both pages of the 22-peer fixture, "You" row, empty
  state (if reachable on the mock), AR + EN, light + dark.
- **ACCEPTANCE (10):** F1 scope switch refetches · F2 pagination on `hasMore` · F3 load-more error keeps rows · F4 "You" row
  marked · F5 offline · V1 podium vs `133:3117` · V2 rows vs frame · V3 dark · I1 scroll-triggered paging · I2 AR mirroring.
- **Done 2026-09-25 (`NEXT`):** university frame read (its toggle is `Global · Cohort`); #92 logged; podium badges fixed
  per place (W06-1); #93 dark numerals logged, built as drawn.
- **Walked 2026-09-25 (`WALK`): 78%** (F 4/4, F3 N/A · V 1/3 · I 2/2). Open: W06-2 row text colours, W06-3 "You" row
  `#DBB0FF`, W06-4 row gap / avatar — see `device_walk_results.md`.
- **Fixed + re-walked 2026-09-25: 100%** (F 4/4, F3 N/A · V 3/3 · I 2/2) — KNOWN_BUGS BUG-008; validate 1489/0/0.

## WAVE 07 — Subjects

- **SCREEN:** Subjects · **ROUTE:** `/learn` · **FIGMA:** school `134:3837`, university `308:4521`; component dark `337:5732`, `337:5724`
- **PRIMARY FLOW:** Learn tab → search → subject card → subject tree; Mistakes pill → `/learn/mistakes`
- **ENDPOINTS:** `GET /catalog/subjects`
- **DEPENDENCIES:** none. **Lands the shared chevron fix** consumed by 08–10 and 15–18.
- **CURRENT:** 7/9 functional; light matches.
- **MISSING:** (1) **RTL chevrons**: `forwardChevron()` / `backChevron()` (`catalog_scaffold.dart:100-108`) swap icons that the
  SDK already mirrors (`matchTextDirection: true`) → net no mirror. Return the LTR glyph unconditionally and let the SDK mirror.
  Sites: `subject_card.dart:66`, `tree_list_row.dart:198`, `mistakes_subject_card.dart:95`. (2) Ask the designer for a dark
  Subjects frame (none exists) — record in DESIGN_ISSUES.
- **Done 2026-09-25 (`NEXT`):** (1) landed, plus a source guard; KNOWN_BUGS BUG-009. (2) **withdrawn**: `337:5702` IS the dark
  Subjects frame. Also fixed, frame-proven: the light card's title, chevron, bar fill and track (W07-2…5).
- **Walked 2026-09-25: 100%** (F 3/3, F2 + F4 N/A · V 2/2 · I 2/2). For Wave 08: W07-6, the dead root back chip, now
  reproduces every time via Account → Settings → Back → Learn (both tracks).
- **TESTS:** **guard-style** widget test: in `ar`, the drill-in chevron points left; in `en`, right (mechanise it — prose rules decay).
- **DEVICE WALK:** AR + EN chevron direction; search; card tap; Mistakes pill; offline; school + university.
- **ACCEPTANCE (9):** F1 subjects load · F2 empty `[]` message · F3 search filters client-side · F4 error/retry · F5 offline ·
  V1 grid vs `134:3837` · V2 university vs `308:4521` · I1 chevron points forward in AR and EN · I2 card tap → tree.

## WAVE 08 — Subject tree root (Units / Lectures)

- **SCREEN:** Subject tree · **ROUTE:** `/learn/subject/:subjectId` · **FIGMA:** Units `135:815` (dark `337:5894`); Lectures `180:5354`, `180:5208`
- **PRIMARY FLOW:** school: unit → chapters; university: quiz-type tab → lecture → quiz setup
- **ENDPOINTS:** `GET /catalog/subjects/{id}/tree`
- **DEPENDENCIES:** 07 (chevron). **Lands `TreeListRow` button semantics** consumed by 09–10, 16–18.
- **CURRENT:** 8/9 functional; ⚠ #17 #18 #77 #81.
- **MISSING:** (1) `TreeListRow` tappable branch has no button semantics (`tree_list_row.dart:120-124`) — add
  `Semantics(button: true)` / merge, like `_MistakesButton`. (2) **Dead back chip on the Subjects root, university only**
  (device-proven 2026-09-20) — reproduce, find the extra route entry, fix at the source. (3) Design questions: trailing circle
  (`180:5208`, Midterm) vs chevron (`180:5354`, Normal); no dark Lectures frame. (4) Add `TreeListRow` progress-row overflow
  (7/20 px at 1.3×) to `docs/RESPONSIVE.md`'s queue.
- **Done 2026-09-25 (`NEXT`):** (1) landed. (2) root cause found: `GoRouter.canPop()` is app-wide and never rebuilds the
  header, and there is no extra route entry; fixed with `ModalRoute.canPopOf`, KNOWN_BUGS BUG-010. (3) the circle is
  DESIGN_ISSUES #94; "no dark Lectures frame" is **withdrawn** (`349:15962`, `337:11059`). (4) added as RESPONSIVE item
  12 with corrected numbers: 7/20 px was the test font. Also fixed, frame-proven: the light row chevron, the row bar +
  caption, and the list rhythm (W08-3…5).
- **Walked 2026-09-25: 89%** (F 3/3, F3 N/A · V 3/3 · I 2/3). I1 fails on **W08-6**: the Lectures rows are exposed to
  Android as `ProgressBar` (the bar's role merges into the row); the Units rows are `Button`.
- **W08-6 fixed + re-walked 2026-09-25: 100%.** The bar's semantics are excluded when a caption states the progress;
  every row is a `Button` on device (KNOWN_BUGS BUG-011). The Subjects cards (Wave 07) still have the same mechanism.
- **TESTS:** semantics test (button flag on tappable rows, none on leaf rows); regression test for the back chip on the root.
- **DEVICE WALK:** both tracks; quiz-type tabs; TalkBack announces "button"; back chip absent on the Subjects root (university).
- **ACCEPTANCE (10):** F1 tree loads (both tracks) · F2 track-specific empty copy · F3 403 scope copy · F4 offline · V1 Units vs
  `135:815` · V2 dark vs `337:5894` · V3 Lectures vs `180:5354` · I1 rows announce as buttons · I2 no dead back chip on root ·
  I3 tab switch does not refetch.

## WAVE 09 — Chapters (verify)

- **SCREEN:** Chapters · **ROUTE:** `/learn/subject/:id/unit/:unitId` · **FIGMA:** `135:1270` (dark `337:6047`)
- **ENDPOINTS:** cached tree (no call) · **DEPENDENCIES:** 07, 08
- **CURRENT:** 5/6; ⚠ #16 (no chapter progress in the contract — API gap, not buildable).
- **DEVICE WALK:** drill in/out; stale deep link → empty not crash; AR chevrons.
- **ACCEPTANCE (7):** F1 rows from cached tree (no refetch) · F2 unknown unit → empty · F3 navigate to lessons · V1 vs `135:1270` ·
  V2 dark vs `337:6047` · I1 AR chevron · I2 row semantics.
- **Done 2026-09-25 (`NEXT`):** both frames re-read. The row paint is the Wave 08 tokens on both canvases, with no change.
  **W09-1** (frame-proven): the row gap is 16, not 12; fixed. Unknown unit → empty is now under test.
- **Walked 2026-09-25: 100%** (F 2/2, F2 N/A · V 2/2 · I 2/2). Rows are 16.0 dp apart and match both frames; no refetch;
  AR chevrons; rows are `Button`.

## WAVE 10 — Lessons (verify)

- **SCREEN:** Lessons · **ROUTE:** `…/chapter/:chapterId` · **FIGMA:** `135:1485` (dark `337:6143`)
- **ENDPOINTS:** cached tree → hands off to `POST /quizzes` via `/quiz/setup` · **DEPENDENCIES:** 07, 08
- **CURRENT:** 6/6; lesson `questionCounter` is real; trailing "{a} / {t} questions" vs frame "80%" (#16 confirm-only).
- **DEVICE WALK:** lesson → quiz setup with the right scope; AR chevrons.
- **ACCEPTANCE (7):** F1 counters from server · F2 always tappable · F3 hand-off args to setup · V1 vs `135:1485` · V2 dark vs
  `337:6143` · I1 AR chevron · I2 row semantics.
- **Done 2026-09-25 (`NEXT`):** both frames re-read. The row paint, bar included, is the Wave 08 tokens, with no change.
  **W10-1** (frame-proven): the row gap is 16, not 12; fixed. A screen-level "button, not a progress bar" test was added.
- **Walked 2026-09-26: 100%** (F 3/3 · V 2/2 · I 2/2). Rows are 16.0 dp apart; the bar, caption and paint match both frames;
  the finished and 0/0 lessons open setup; AR is mirrored; rows are `Button`.

## WAVE 11 — Quiz setup

- **SCREEN:** Quiz setup (+ limit sheet) · **ROUTE:** `/quiz/setup` · **FIGMA:** `135:1622` (= `309:5771`); limit sheet `199:2335` (+ `225:6634`, `225:7001`)
- **PRIMARY FLOW:** pick length → Start → quiz; paywall 403 → limit sheet
- **ENDPOINTS:** `POST /quizzes`
- **DEPENDENCIES:** 10 (args).
- **CURRENT:** functional full; ⚠ #31 #35 #51 #74 #82.
- **MISSING:** (1) Limit sheet ✕ close the frame draws — add as a dismiss (purchase-silent: no upgrade CTA, #51 stands).
  (2) **Subject caption** above the scope ("Biology" / "Cell Membrane"): the code comment claims a DESIGN_ISSUES entry that
  does not exist. Either carry the subject name in `QuizSetupArgs` from the catalog (small, no endpoint) **or** log the omission —
  **ask the owner** which; shared with wave 13. (3) Re-read idle-chip border on the Properties panel (`146:2315`) — a screenshot is
  not a value.
- **TESTS:** limit-sheet dismiss via ✕; caption renders when args carry a subject (if built).
- **DEVICE WALK:** 10/30/50 selection; Start; force a paywall 403 on the mock → sheet → ✕ and "Not now"; offline; AR + EN.
- **ACCEPTANCE (10):** F1 createQuiz body (`normal`, length) · F2 422 inline · F3 403 → sheet · F4 insufficient_scope inline ·
  F5 offline disables Start · V1 vs `135:1622` · V2 sheet vs `199:2335` · V3 dark · I1 chip selected state + semantics ·
  I2 sheet ✕ dismisses.
- **Done 2026-09-26 (`NEXT`):** frames re-read (`135:1622`, dark `337:6239`, limit `199:2335` / `207:5904`). Owner rulings:
  build the subject caption; build the limit sheet as the frame's centred card. **W11-1** subject over scope (from
  `cachedSubjectName`, via `QuizSetupArgs.subjectName`). **W11-2** dark scope `#FCFBF9`, not lavender. **W11-3** dark header
  rule 20% `#CCD5D2` at 0.5. **W11-4** centred card with a ✕. The idle chip has no hairline (build already right).
- **Walked 2026-09-26: 78%** (F 3/4, F4 N/A · V 2/3 · I 2/2). W11-1…4 verified. Open: **W11-5** card ✕ 7.6 dp inboard and 2 dp
  small (48 dp tap target; `Icons.close` vs the frame's cross); **W11-6** a repeat 403 stacks two cards (listener fires on the
  loading state that carries the previous error).
- **Fixed 2026-09-26 (owner):** W11-5 frame cross SVG + 48 dp target on the frame's box; W11-6 listener skips loading
  (BUG-012).
- **Re-walked 2026-09-26: 100%** (F 4/4, F4 N/A · V 3/3 · I 2/2). W11-5 and W11-6 verified. New **W11-7**: the ✕ is an
  `ImageView` to TalkBack (the SVG's image semantics merge into the button), a regression from the W11-5 fix.
- **W11-7 fixed 2026-09-26 (owner):** `excludeFromSemantics: true` on the glyph, +1 semantics test (red first).
  Device: the ✕ is a `Button` in EN and AR. Wave 11 at 100%, nothing open.

## WAVE 12 — Quiz question

- **SCREEN:** Quiz · **ROUTE:** `/quiz/:quizId` · **FIGMA:** `159:845`, AI `159:1695`, photo `216:2973` (= `309:*`)
- **PRIMARY FLOW:** select → confirm → graded → explanation → next → finish
- **ENDPOINTS:** `POST /quizzes/{id}/answers`, `GET /questions/{id}/explanation`, `POST /quizzes/{id}/finish`
- **DEPENDENCIES:** 11. **Gated item:** the `subscription_required` explanation popup needs an owner ruling.
- **CURRENT:** functional full except the popup; ⚠ #33 #83 #87 #88.
- **MISSING:** (1) ✕ close: tooltip + semantics label (`quiz_screen.dart:130-137`). (2) `409 quiz_already_finished` must not offer
  Retry. (3) AI panel header glyph → the shipped `assets/icons/ai_education.svg` (frame's sparkle + mortarboard).
  (4) App-bar AI "sparkle-cap" icon in the frame: **what it does is not specified** → ask the designer; do not build an inert
  mystery icon without a ruling. (5) **Owner ruling:** contract `openapi.yaml:1688-1703` mandates a verbatim popup on
  `403 subscription_required`; the app shows the generic line. Build verbatim (EN from the contract, AR via localisation) **only
  if** the owner rules it compatible with purchase-silent; otherwise log a deliberate divergence like #51.
- **TESTS:** bloc test (409 → no retry); widget tests (✕ semantics, panel glyph, popup behind the ruling).
- **DEVICE WALK:** answer right/wrong; explanation 202 → 200; 403 on the mock; finish; exit guard; AR + EN; light + dark
  (FLAG_SECURE local override for screenshots only).
- **ACCEPTANCE (12):** F1 answer submit + grade · F2 idempotent retry · F3 409 no retry · F4 explanation poll → text ·
  F5 explanation 403 per ruling · F6 finish → result · V1 vs `159:845` · V2 AI panel vs `159:1695` · V3 photo vs `216:2973` ·
  V4 dark tiles (⚠ #87 excluded — designer-owed) · I1 ✕ announced · I2 exit guard.
- **Done 2026-09-26 (`NEXT`):** frames re-read (`159:845`, `159:1695`, dark `337:9182`, photo `216:2973`, `159:1431`,
  `159:1852`). Owner rulings: build the explanation popup verbatim (D-015); leave the header AI icon out (DESIGN_ISSUES
  #95); show the whole photo (#96). **W12-1** ✕ = the frame's cross, a named 48 dp button (header rebuilt as the frame's
  container); **W12-2** 409 without Retry; **W12-3/4** panel glyph `ai_education.svg`, dark glyph + title `#FCFBF9`;
  **W12-5** the popup; **W12-6** photo above the card; **W12-7…11** header rule, lavender bar, `#7070A0` counter,
  `#384F47` question text, gaps 25/10/22. +20 tests; validate 1558/0/0. F3 and F5 have no mock trigger (N/A unless
  the owner asks for one).

## WAVE 13 — Quiz result

- **SCREEN:** Quiz result · **ROUTE:** `/quiz/:quizId/result` · **FIGMA:** `159:1964` (= `309:6375`; `309:6488` is a Review duplicate)
- **PRIMARY FLOW:** finish → score ring + buckets + rewards → Review Questions / back to Learn
- **ENDPOINTS:** `finishQuiz` result (in-memory `QuizSummary`)
- **DEPENDENCIES:** 12; subject-caption decision from 11.
- **MISSING:** (1) `+{points} نقطة` renders `3+` — LTR-isolate the signed number (`app_ar.arb:189` / `quiz_result_screen.dart`).
  (2) Rewards line as two runs ("+N" accent, "Points" plain) — read both colours off the panel. (3) "Review Questions" CTA leading
  sparkle-cap icon (`ai_education.svg` family). (4) Subtitle "Subject — Scope" per wave 11's decision.
- **TESTS:** AR widget test for `+3`; rewards runs; CTA icon.
- **DEVICE WALK:** finish a quiz both tracks; AR `+3 نقطة`; Review Questions; back → `/learn`.
- **ACCEPTANCE (9):** F1 buckets from `QuizSummary` · F2 back → `/learn` · F3 Review opens with session args · V1 ring vs frame ·
  V2 rewards runs · V3 CTA icon · V4 dark · I1 `+N` correct in AR · I2 back button labelled.
- **Baseline walk 2026-09-26 (owner "WALK 12 & 13", before the build): 44%** (F 3/3 · V 0/4 · I 1/2).
- **Done 2026-09-26 (`NEXT`):** frames re-read (`159:1964`, `309:6375`, dark `337:6628`, `349:14522`; the university
  frames equal the school ones). Owner rulings: remove "Back to Learn"; the ring anticlockwise in both languages
  (D-016); fix the shared back chip (BUG-013); keep the figure at 28 (DESIGN_ISSUES #97). **W13-1** "Subject —
  Scope" carried setup → quiz → result, display only; **W13-2** the frame's header block + rule; **W13-3** gaps
  18.18 / 25 / 25 / 25; **W13-4** the painted ring (the export's gradient, stroke 9.846, round caps); **W13-5** bucket
  padding, badge, label; **W13-6** rewards title, the frame's star, two runs with "+N" LTR (BUG-003 fixed);
  **W13-7** CTA icon; **W13-8** "Back to Learn" removed; **W13-9** the chip is a `Button`. +18 tests; validate
  1576/0/0; review 0 findings.
- **Re-walk 2026-09-26 (owner "WALK 13"): 100%** (F 3/3 · V 4/4 · I 2/2); BUG-003 quiz half and BUG-013
  device-verified.

## WAVE 14 — Quiz review (verify)

- **SCREEN:** Quiz review · **ROUTE:** `/quiz/:quizId/result/review` · **FIGMA:** `162:2377`, dark `337:6705`, RTL `549:20324`
- **ENDPOINTS:** in-memory session; explanation per wrong row · **DEPENDENCIES:** 13
- **CURRENT:** matches; ⚠ #52–#58 ruled.
- **MISSING:** a test pinning the row at text scale 1.30 (and documenting 1.35) so the self-documented 13 px slack cannot silently tip over.
- **ACCEPTANCE (8):** F1 All/Correct/Wrong filters · F2 skipped rows neutral · F3 FLAG_SECURE on/off · V1 vs `162:2377` · V2 dark vs
  `337:6705` · V3 RTL vs `549:20324` · I1 filter chips 48 dp · I2 back labelled.
- **Done 2026-09-27 (`NEXT`):** frames re-read (`162:2377`, `337:6705`, `549:20324`). Owner rulings: one shared
  question-text widget on both screens (D-017; #88 closed; BUG-014), dark "QUESTION n" stays cream (#54). **W14-1**
  `QuestionStemText` (`<u>` underline, the stem's own direction); **W14-2** own 63 header + rule; **W14-3** chips 8
  apart, 25 / 14.18, pills really 32; **W14-4** chip discs + idle label; **W14-5** row gap 19, paddings 9 / 3.5 /
  5.82, badge ring; **W14-6** label and question colours and lines; **W14-7** AI glyph top-end, 24.41 tall;
  **W14-8** text scale 1.30 / 1.35 tests; **W14-9** #98 logged. +33 tests; validate 1609/0/0.
- **Walk 2026-09-27 (owner "WALK 14"): 100%** (F 2/2, F2 N/A · V 3/3 · I 2/2); BUG-014 device-verified. New
  **W14-10**: the underline does not show on Arabic stems (Tajawal Medium / Bold underline metrics), owner's call.

## WAVE 15 — Mistakes overview

- **SCREEN:** Mistakes overview · **ROUTE:** `/learn/mistakes` · **FIGMA:** `404:6292` (dark `404:7428`)
- **ENDPOINTS:** `GET /me/mistakes` · **DEPENDENCIES:** 07 (chevron), a finished quiz for live counts
- **CURRENT:** 8/10; ⚠ #59 #68 #71; known gap: overview not refreshed after an ordinary quiz (`mistakes_notifiers.dart:39-56`).
- **MISSING:** (1) `MistakesSubjectCard` button semantics (mirror `_MistakesButton`). (2) BUG-002: Arabic overflow at 1.3× / 2.0×.
  (3) The refresh-after-quiz gap stays documented unless the owner asks for it (the Day 10 brief calls it a design question).
- **TESTS:** semantics; text-scale test AR 1.3 / 2.0 with no overflow.
- **ACCEPTANCE (9):** F1 list in server order · F2 empty = happy path copy · F3 error/retry · F4 offline · V1 vs `404:6292` ·
  V2 dark vs `404:7428` · I1 card announced as button · I2 no overflow AR 1.3× · I3 AR chevron.
- **Done 2026-09-27 (`NEXT`):** frames re-read (`404:6292`, `404:7428`), no ruling needed. **W15-1** card button
  semantics; **W15-2** 25 under the header (was 16); **W15-3** the frame's 13 × 27 chevron on the card's middle,
  `#517066`; **W15-4** lines at the frame's centres (title was 3.7 high); **W15-5** BUG-002: the card grows, rows take
  the taller card (D-018). #99 logged (shared header title). +11 tests; validate 1620/0/0.
- **Walk 2026-09-27 (owner "WALK15"): 100%** (F 2/2, F2 + F3 N/A · V 2/2 · I 2/2, I2 N/A). New **W15-6**: a two-word Arabic
  name makes its row about 4 dp taller (mixed Inter / Tajawal line metrics), owner's call.
- **Second walk 2026-09-27 (owner `WALK`, same build): 100%** on the university track and light AR; W15-6 reproduced
  with "الكيمياء الحيوية".

## WAVE 16 — Mistakes subject

- **SCREEN:** Mistakes subject · **ROUTE:** `/learn/mistakes/subject/:subjectId` · **FIGMA:** `404:6539`; university `404:7181`, `404:7110`
- **ENDPOINTS:** `GET /me/mistakes/subjects/{id}` · **DEPENDENCIES:** 08 (row semantics), 15
- **MISSING:** measure BUG-002 on tree rows (AR 1.3× / 2.0×); fix if it overflows.
- **ACCEPTANCE (8):** F1 track-discriminated tree · F2 unknown id → empty · F3 decay (one fetch per visit) · V1 vs `404:6539` ·
  V2 university vs `404:7181` · V3 dark · I1 row semantics · I2 lecture leaf inert (owner ruling).
- **Done 2026-09-27 (`NEXT`):** frames re-read (`404:6539`, `404:7181`, `404:8686`, rows `404:6642` / `404:7765`), no
  ruling needed. **W16-1** 25 under the header, rows 16 apart (were 20, 12); **W16-2** the row's frame geometry (78
  tall, lines at 28.0 / 46.5, badge and chevron at 37); **W16-3** chevron 12 from the edge (Mistakes only; catalog →
  #100); **W16-4** row chevron `#4B675E`; **W16-5** light disc `#F4E6FF`. BUG-002 measured on the rows: not affected.
  +11 tests; validate 1631/0/0.
- **Walk 2026-09-27 (owner `WALK`): 100%** (F 3/3 · V 3/3 · I 2/2). W16-1, W16-3…5 verified on device. New **W16-6**: the
  rows are 82 dp, not 78, because every mock name is two Arabic words (W15-6's mechanism), owner's call with W15-6.

## WAVE 17 — Mistakes chapters (verify)

- **ROUTE:** `/learn/mistakes/subject/:id/unit/:unitId` · **FIGMA:** `404:6677` · **DEPENDENCIES:** 07, 08, 16
- **ACCEPTANCE (6):** F1 cached view · F2 unknown unit → empty · V1 vs `404:6677` · V2 dark · I1 AR chevron · I2 row semantics.
- **Done 2026-09-27 (`NEXT`):** frames re-read (`404:6677`, dark `404:7894` located), no ruling needed. **W17-1** 25
  under the header, rows 16 apart (were 20, 12); **W17-2** F2 now tested on this screen (the test named for it opened
  an empty Units tree; renamed), plus the rows' geometry, Arabic mirroring, button semantics, Retry and offline on
  Chapters. Rows unchanged (Wave 16's shared row). +8 tests; validate 1639/0/0.
- **Walk 2026-09-27 (owner `WALK`): 100%** (F 1/1, F2 N/A · V 2/2 · I 2/2). W17-1 verified on device (25.14 / 16.00 in
  light, dark, EN and AR); rows 82 dp from the mock's two-word Arabic names (W16-6).

## WAVE 18 — Mistakes lessons (verify)

- **ROUTE:** `…/chapter/:chapterId` · **FIGMA:** `404:6762`, `404:6853` · **DEPENDENCIES:** 07, 08, 16
- **ACCEPTANCE (6):** F1 cached view · F2 leaf rows inert (no chevron, not clickable) · F3 ICU plural ("1 mistake") · V1 vs
  `404:6762` · V2 dark · I1 AR layout.
- **Done 2026-09-27 (`NEXT`):** frames re-read (`404:6762`, RTL `549:19390`; no dark frame draws Lessons, `404:7990` in
  its slot draws Chapters; `404:6853` is the replay quiz), no ruling needed. **W18-1** 25 under the header, rows 16
  apart (were 20, 12); **W18-2** tests on this screen (spacing, geometry, inert rows EN / AR, semantics, plurals EN /
  AR, mirroring, cached view, skeleton, unknown chapter, Retry, offline) on a four-lesson fixture. DESIGN_ISSUES #64
  mapped. W18-3 (the inert row's 282 text column) open for the owner. +14 tests; validate format PASS · analyze 0 · **1668 / 0 / 0** · OVERALL PASS (`validate.ps1`).
- **Walk 2026-09-27 (owner `WALK`): 100%** (F 3/3 · V 2/2 · I 1/1). W18-1 verified on device (25.14 / 16.00 in light,
  dark, EN and AR); the rows inert (no chevron, `View`, taps change nothing); "1 mistake" / "خطأ واحد"; rows 82 dp from
  the mock's two-word Arabic names (W16-6).

## WAVE 19 — Profile

- **SCREEN:** Profile · **ROUTE:** `/profile` (+ Account tab) · **FIGMA:** `166:4416` / `309:7940`; Logout `180:4598`→`180:4704`; Go-to-Uni `180:4301`→`180:4445`
- **PRIMARY FLOW:** open Profile → Log out → No / Yes → `/login` → log in as another student → Home + Profile show the new student
- **ENDPOINTS:** `GET /me`, `POST /auth/logout`
- **DEPENDENCIES:** 05 (Home shows the stale data too).
- **MISSING:** (1) **Logout dialog**: frame draws "No" + "Yes" (155×60 each) plus ✕; code has ✕ + one confirm. Add a two-button
  variant for Logout only; Go-to-Uni keeps its single button (its frame has one). Log the divergence that existed.
  (2) **Stale profile after logout → re-login** (device-proven 2026-09-20; `invalidateSessionScope` already invalidates
  `meProvider`, so the cause is a rebuild race — reproduce on the mock, then retest on staging before sizing, per the walk note).
- **TESTS:** dialog variant; router-driven test (BUG-001 rule: only router tests catch it) proving a second login shows the second profile.
- **DEVICE WALK:** school login → logout (No, then Yes) → university login → Home + Profile names/points are the university student's.
- **ACCEPTANCE (10):** F1 profile from `/me` · F2 logout revokes then clears · F3 re-login shows the new student on Home ·
  F4 … and on Profile · F5 Go-to-Uni disabled with reason · V1 vs `166:4416` · V2 Logout vs `180:4704` · V3 dark · I1 No dismisses,
  Yes logs out · I2 edit chip 48 dp.
- **Done 2026-09-27/28 (`NEXT`):** frames re-read (Profile, Logout and Go to Uni in light, dark and RTL, both tracks);
  owner rulings: meProvider autoDispose (D-020), Points only (#101), the pair mirrored in Arabic (#102), the dark scrim
  60% on both tracks (#103). **W19-1** the stale profile after log-out → log-in (BUG-015); **W19-2** the Logout No /
  Yes pair; **W19-3** the dialog ✕; **W19-4** the dialog cards; **W19-5** the frame's title bar and the 25 under it;
  **W19-6** tests. +25 tests (23, plus the 2 new goldens); validate format PASS · analyze 0 · **1693 / 0 / 0** · OVERALL PASS
  (`validate.ps1`, 2026-09-28).
- **Walk 2026-09-28 (owner `WALK`): 100%** (F 5/5 · V 3/3 · I 2/2). W19-1 verified on device: the university student on
  Home and Profile after the school student's log-out, never the old name in 81 recorded frames; the Logout pair, the ✕,
  the cards and the title bar measured against the frames in light, dark and Arabic (mirrored); Go to Uni disabled with
  its reason.

## WAVE 20 — Edit Profile

- **SCREEN:** Edit Profile · **ROUTE:** `/profile/edit` · **FIGMA:** `176:1201`; action sheet `216:3158`→`216:3341`; picker `180:3989`→`180:4153`; `309:8268` (a school copy — no real university frame)
- **PRIMARY FLOW:** edit name/email → Save → Profile refreshes; avatar → Use Avatar → pick → save
- **ENDPOINTS:** `GET /me`, `PATCH /me`, `GET /reference/avatars`
- **DEPENDENCIES:** 19. **Lands mock `PATCH /me`** (in `lib/dev/mock_backend.dart`, contract-shaped, including the email
  tri-state and a `400 validation_failed` arm) — needed by 21.
- **MISSING:** (1) mock `PATCH /me`. (2) `AvatarActionSheet` chrome → frame `216:3341` (drag handle, two plain rows, hairline;
  no title, no ✕, no icons, no row borders). (3) Ask the designer for a real university Edit Profile frame; log it.
- **TESTS:** mock backend test for `PATCH /me` (200 + 400 + explicit-null email); sheet widget test.
- **DEVICE WALK:** change name → Save → Profile shows it; clear email; invalid email → inline error; unsaved-changes guard; avatar
  pick; AR + EN; light + dark.
- **ACCEPTANCE (11):** F1 diff-only PATCH body · F2 explicit null clears email · F3 400 field error inline · F4 `/me` refresh after
  save · F5 avatar round-trip · V1 vs `176:1201` · V2 action sheet vs `216:3341` · V3 picker vs `180:4153` · I1 unsaved guard ·
  I2 read-only rows announced · I3 Upload Photo disabled with hint (S29).
- **Done 2026-09-28 (`NEXT`):** frames re-read (Edit Profile light, dark and RTL on both tracks: the university frame is `180:6349`, so MISSING (3) needs no designer ask; the action sheet and the picker in light, dark and RTL); owner rulings: the locked rows follow the frames (#105), Upload photo dimmed with its caption (#106). **W20-1** the mock `PATCH /me` (contract-shaped, per track; the 400 on a malformed e-mail); **W20-2** the action sheet to `216:3341`; **W20-3** the picker's ✕ (the frame's cross, 48 dp target); **W20-4** the avatar block (25 under the bar, the badge 14 below, the first label 1 under it); **W20-5** the frame's pencil; **W20-6** the gradient disc; **W20-7** the locked rows; **W20-8** one announcement per locked row (BUG-016); **W20-9** tests; the review's 3 findings fixed. +30 tests; validate format PASS · analyze 0 · **1723 / 0 / 0** · OVERALL PASS (`validate.ps1`, 2026-09-28; +30 over Wave 19's 1693).
- **Walk 2026-09-28 (owner `WALK`): 100%** (F 4/4, F1 N/A · V 3/3 · I 3/3). On device: the name, an e-mail set then cleared (the explicit null), and the avatar round-trip through the mock's `PATCH /me` and `GET /me`; the malformed e-mail's 400 marks the field; the sheet, the picker's ✕, the avatar block and the pencil measured against the frames in light, dark and Arabic; the locked rows on both tracks, one node each; the unsaved guard by the chip and by system Back. F1 is test-level (bodies are never logged); the gradient cannot show on the mock's opaque avatars.

## WAVE 21 — Settings (partly gated)

- **SCREEN:** Settings · **ROUTE:** `/settings` · **FIGMA:** `176:1840` (= `309:8452`)
- **PRIMARY FLOW:** language, mode, Rank privacy toggles; account deletion (when designed)
- **ENDPOINTS:** `GET /me`, `PATCH /me`; gated: `POST` + `DELETE /me/deletion-request`; gated: `PUT /me/fcm-token`
- **DEPENDENCIES:** 20 (mock `PATCH /me`).
- **CURRENT:** visual per ruled #45 #46 #48; Rank toggles round-trip both booleans.
- **MISSING:** (1) **Account deletion + cancel** — stable, store-mandatory, **no design**. Build only after a design/copy
  (adr-114 D3) arrives: request row + confirm, `pendingDeletion` banner/cancel screen, and the contract's mandated route on
  `403 account_pending_deletion` from every screen that shows it today. Without a design this wave is verify-only for the rest.
  (2) **Push token** — needs a Firebase project and a product call on prompt timing and on the four toggles (no contract storage);
  stays out unless the owner opens it. (3) Correct `docs/STORE_READINESS.md:59` (deletion endpoint now exists).
- **TESTS:** (if built) repository + notifier tests for both deletion ops, router test for the pending-deletion redirect.
- **DEVICE WALK:** language/mode switch live; Rank toggles persist via mock; (if built) request → pending → cancel.
- **ACCEPTANCE (8 base, +6 if deletion is built):** F1 Rank toggles PATCH each boolean · F2 no optimistic flip · F3 error keeps
  prior value · V1 vs `176:1840` · V2 dark · I1 language switch live · I2 mode switch live · I3 notification toggles disabled
  with hint. (+ F4 request 202 · F5 pending shown from `/me` · F6 cancel 204 · F7 403 routes to cancel · V3 vs new frame ·
  I4 confirm dialog.)

## WAVE 22 — Flashcards (gated, new screen)

- **SCREEN:** Flashcards (university) · **ROUTE:** new — proposed under the Lectures view; decide with the owner
- **FIGMA:** `225:5582` (+ component `247:3260`); entry point: **none drawn**
- **PRIMARY FLOW:** lecture with `hasFlashcards` → cards (front → back) → self-grade `gotIt` / `again` → next → end
- **ENDPOINTS:** `GET /flashcards/lectures/{lectureId}/cards` (cursor + `pageSize`), `PUT /flashcards/cards/{id}/self-grade`
- **DEPENDENCIES:** 08 (Lectures view); **five design answers** first: (1) Confirm / "<" → `gotIt` / `again`? flip or previous?
  (2) front → back reveal; (3) bookmark / share — omit or ask for a field; (4) per-lecture entry vs the #18 tab; (5) rewrite S6.
- **CURRENT:** data layer built + tested (`FlashcardsRepository`, `LectureFlashcardsNotifier`, `FlashcardCard`, closed enum
  `{gotIt, again}`); `Lecture.hasFlashcards` parsed, unread.
- **MISSING:** screen, route, entry point, mock routes (both ops + `403 flashcard_subscription_required` arm),
  `flashcard_subscription_required` copy (purchase-silent: no upgrade CTA), stale comments in `quiz_type_tabs.dart` / `quiz_type.dart`.
- **TESTS:** screen four states; paging on `hasMore`; non-optimistic grade; 403 preview-used-up state; AR + EN.
- **DEVICE WALK:** university lecture with cards → full deck → grade both ways → reopen shows echoed `selfGrade`; 403 on the mock.
- **ACCEPTANCE (12, provisional until the design answers land):** F1 cards load · F2 paging · F3 grade recorded · F4 grade echoed on
  reload · F5 403 preview state · F6 offline · V1 card vs `225:5582` · V2 back side per answer · V3 dark · I1 reveal gesture ·
  I2 grade controls · I3 entry point.
- **Done 2026-09-29 (`NEXT` + owner rulings `1A 2A 3B 4A–10A`):** the five design answers came as ten rulings (the Lectures tab is the entry, cards-less lectures and tab hidden, the contract re-vendored first for `flashcardCount`, Got it → `gotIt` / restart → `again` / "<" previous, tap flips, pop back after the last card, the preview-used-up line, dark + Arabic from the light layout, the Arabic words, no screenshot blocking). **W22-1** contract → `f462968` (3.27.0-m1) + `Lecture.flashcardCount`; **W22-2** the mock's two operations; **W22-3** the 10-card round and its position; **W22-4** the Lectures Flashcard tab; **W22-5** the quiz's header / progress / "<" shared; **W22-6** Flash Card Setup; **W22-7** the study screen; **W22-8** records (DESIGN_ISSUES #18, #20, #113–#119; S6 resolved + four asks; BUG-019); **W22-9** tests. MISSING all done (screen, route, entry, mock routes + the 403 arm, the preview copy, stale comments; S6 rewritten). Review: 15 confirmed, all fixed. format PASS · analyze 0 · **2017 / 0 / 0** · OVERALL PASS (+273 over Wave 21's 1744) (`validate.ps1`, 2026-09-29). **Walked 2026-09-29: 92%** (F 5/5, F4 N/A · V 3/4 · I 3/3); V3 fails on BUG-020 (a card's text takes the app's direction), open for the owner. **BUG-020 fixed and re-walked 2026-09-30 (owner request):** the four language / content combinations 4/4 PASS; acceptance **100%** (V 4/4); +19 tests; validate **2036 / 0 / 0**.

---

## Not in any wave (cross-cutting — owner decisions)

| Item | Why it is not a wave | Ask |
| --- | --- | --- |
| Tablet width cap (`docs/RESPONSIVE.md`, 0/11 applied) | app-wide policy | apply the queue, or accept "must not crash" |
| `CircleBackButton` 35 dp hit area | D-013 assigned #80 to the header owner | may these waves widen the hit area outside the catalog header? |
| Text-scale policy (clamp at 1.3?) | RESPONSIVE item 4 is the owner's call | decide before 07/15 fix overflows |
| Latin digits in Arabic (#19) | designer ruling | — |
| Commit the contract re-vendor | owner asks for commits | commit `contract/*` alone |
| Stale `.git/index.lock` (2026-09-22) | index hygiene | remove before any commit (no git process alive) |
| Stale docs: `seif_fight.md` S6/S37, `STORE_READINESS.md:59`, pin comments in `mock_backend.dart:17` / `quiz_fixtures.dart:1` | fixed in the wave that owns the screen (21, 22) or a docs pass | — |

## Owner inputs that unblock waves

1. Explanation `subscription_required` popup — adopt verbatim or diverge (wave 12).
2. Subject caption on Setup/Result — carry the subject name or log the omission (waves 11, 13).
3. Top Student `scope` if the frame does not show it (wave 05).
4. Account-deletion design + copy (wave 21).
5. Flashcards: five design answers (wave 22).
6. Push/Firebase — open or keep closed (wave 21).
