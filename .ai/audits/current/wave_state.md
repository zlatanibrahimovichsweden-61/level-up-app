# Wave state — API → UI → waves workflow (checkpoint)

**Last updated:** 2026-09-30 · session "Level Up Flutter API audit workflow (fork)"

## Workflow state (reconciled 2026-09-24 on the owner's "STOP BEFORE NEXT")

| Stage | Status |
| --- | --- |
| Contract update (re-vendor `ea83099`, 3.23.0-m1) | **COMPLETE** |
| Endpoint / UI investigation | **COMPLETE** |
| COMPARE | **COMPLETE** — 22 UI-assisted screens |
| FORMULATE | **COMPLETE** — issued by the owner; 22 waves = 22 screens, one screen each; list frozen, not reordered since |
| Wave 01 — Login implementation | **COMPLETE** |
| Wave 01 — Login device walk | **COMPLETE** (walk 70% → fixes → re-walk) |
| Wave 01 — Login acceptance | **100%** (F 5/5 · V 3/3 · I 2/2) |
| Wave 01 | **COMPLETE / RECORDED** |
| Wave 02 — OTP implementation | **COMPLETE** (2026-09-24) — W02-1…4; validate **1445/0/0 PASS** |
| Wave 02 — OTP device walk | **COMPLETE** (2026-09-24, owner's "WALK with mock otp_invalid") |
| Wave 02 — OTP acceptance | first walk **78%** → fixes → re-walk **100%** (F 6/6 · V 2/2 · I 1/1) — `device_walk_results.md` |
| Wave 02 | **COMPLETE / RECORDED** — open, not scored: W02-7 landscape overflow on success (product decision), W02-8 Back from success → Login while signed in (owner's call) |
| Wave 02 — fixes (owner: "fix them in Wave 02 and re-walk") | **DONE** — W02-5: OTP nested at `/login/otp` + Login `go` + route keeps its last `OtpArgs` (go_router drops a non-JSON `extra` on the auth refresh — caught by the new router test as a null-check crash); W02-6: gaps 31 / 3 / 28.8. `validate` **1449/0/0 PASS**; `otp_dark.png` golden regenerated (spacing only) |
| Wave 03 — School registration implementation | **COMPLETE** (owner `NEXT`, 2026-09-24) — frames re-read; W03-1 rhythm 25, W03-2 subtitle `bodyMuted`; validate **1452/0/0 PASS** |
| Wave 03 — School registration device walk | **NOT RUN** — owner advanced with `NEXT` (2026-09-24); acceptance not scored |
| Wave 03 | **CLOSED (implemented, unwalked)** — open: DESIGN_ISSUES #90 label→box gap (owner call) |
| Wave 04 — University registration implementation | **COMPLETE** (owner `NEXT`, 2026-09-24) — frames re-read; W04-1 rhythm 25, W04-2 subtitle `bodyMuted`; validate **1454/0/0 PASS** |
| Wave 04 — University registration device walk | **COMPLETE** (owner `WALK`, 2026-09-24) — Pixel 8 |
| Wave 04 — University registration acceptance | first walk **78%** → fixes W04-3/W04-4 → re-walk **100%** (F 5/5 · V 2/2 · I 2/2) — `device_walk_results.md` |
| Wave 04 | **COMPLETE / RECORDED** — fixes in the shared `ReferenceDropdown` (School registration benefits too); KNOWN_BUGS BUG-006; validate **1457/0/0 PASS**. Open: DESIGN_ISSUES #90 label→box gap (owner call) |
| Wave 05 — Home implementation | **COMPLETE** (owner `NEXT`, 2026-09-24) — Top Student ← `GET /leaderboard` (owner: tab's default board, See All → tab; D-014); validate **1475/0/0 PASS** |
| Wave 06 — Leaderboard implementation | **COMPLETE** (owner `NEXT`, 2026-09-25) — frames re-read (`133:3117`, `134:3626` first time, `337:5528`); W06-1 podium badge colours per place (frame-proven, fixed); DESIGN_ISSUES #92 (school toggle NOW/Last Month) + #93 (dark numerals 1.06:1, built as drawn); validate format PASS · analyze 0 · **1482 / 0 / 0** · OVERALL PASS |
| Wave 06 — Leaderboard device walk | **COMPLETE** (owner `WALK`, 2026-09-25) — Pixel 8; W06-1 verified on device; new W06-2 row text colours, W06-3 "You" row `#DBB0FF`, W06-4 row gap / avatar |
| Wave 06 — Leaderboard acceptance | first walk **78%** → owner: fix W06-2/3/4 → re-walk **100%** (F 4/4, F3 N/A · V 3/3 · I 2/2) — `device_walk_results.md`; KNOWN_BUGS BUG-008; validate **1489/0/0** |
| Wave 07 — Subjects implementation | **COMPLETE** (owner `NEXT`, 2026-09-25) — W07-1 RTL chevron fixed at the shared helper (3 sites) + new source guard; W07-2…5 light card colours (frame-proven); the dark Subjects frame EXISTS (`337:5702`); validate format PASS · analyze 0 · **1503 / 0 / 0** · OVERALL PASS; `verify_guards.ps1`: all 10 guards fire, the new one included |
| Wave 07 — Subjects device walk | **COMPLETE** (owner `WALK`, 2026-09-25) — Pixel 8; W07-1 chevrons verified AR + EN at all 3 sites; W07-2…5 light card values verified on both tracks |
| Wave 07 — Subjects acceptance | **100%** first walk (F 3/3, F2 + F4 N/A · V 2/2 · I 2/2) — `device_walk_results.md`. Observation W07-6: deterministic repro of the dead root back chip (→ Wave 08) |
| Wave 08 — Subject tree root implementation | **COMPLETE** (owner `NEXT`, 2026-09-25) — W08-1 row button semantics; W08-2 dead root back chip, root cause found + fixed (KNOWN_BUGS BUG-010); W08-3 light row chevron `#4B675E`; W08-4 row bar + caption `#AE87E7`; W08-5 row gap 16, tabs→row 25; DESIGN_ISSUES #94; RESPONSIVE item 12; validate format PASS · analyze 0 · **1517 / 0 / 0** · OVERALL PASS |
| Wave 08 — Subject tree root device walk | **COMPLETE** (owner `WALK`, 2026-09-25) — Pixel 8; W08-2 back chip verified (4 repro runs, both tracks); W08-3/4/5 row chevron, bar + caption and rhythm verified; new **W08-6**: Lectures rows exposed as `ProgressBar`, not `Button` |
| Wave 08 — Subject tree root acceptance | first walk **89%** (I1 fails on W08-6) → owner: fix W08-6 → re-walk **100%** (F 3/3, F3 N/A · V 3/3 · I 3/3) — `device_walk_results.md`; KNOWN_BUGS BUG-010, BUG-011; validate format PASS · analyze 0 · **1518 / 0 / 0** · OVERALL PASS |
| Wave 09 — Chapters implementation | **COMPLETE** (owner `NEXT`, 2026-09-25) — frames re-read (`135:1270`, dark `337:6047`); W09-1 row gap 16 (frame-proven, fixed); row paint = the Wave 08 tokens on both canvases (no change); unknown unit → empty now under test; validate format PASS · analyze 0 · **1521 / 0 / 0** · OVERALL PASS |
| Wave 09 — Chapters device walk | **COMPLETE** (owner `WALK`, 2026-09-25) — Pixel 8; W09-1 row gap 16.0 dp verified; row paint matches both frames; no refetch (recording); AR chevrons; rows are `Button` |
| Wave 09 — Chapters acceptance | **100%** first walk (F 2/2, F2 N/A · V 2/2 · I 2/2) — `device_walk_results.md` |
| Wave 10 — Lessons implementation | **COMPLETE** (owner `NEXT`, 2026-09-25) — frames re-read (`135:1485`, dark `337:6143`); W10-1 row gap 16 (frame-proven, fixed); row paint incl. bar + caption = the Wave 08 tokens (no change); screen-level "button, not a progress bar" test; validate format PASS · analyze 0 · **1523 / 0 / 0** · OVERALL PASS |
| Wave 10 — Lessons device walk | **COMPLETE** (owner `WALK`, 2026-09-26) — Pixel 8; W10-1 row gap 16.0 dp verified; bar + caption paint and fractions match; finished and 0/0 lessons open setup; AR mirrored; rows are `Button` |
| Wave 10 — Lessons acceptance | **100%** first walk (F 3/3 · V 2/2 · I 2/2) — `device_walk_results.md` |
| Wave 11 — Quiz setup implementation | **COMPLETE** (owner `NEXT`, 2026-09-26) — frames re-read (`135:1622`, dark `337:6239`, limit `199:2335`); owner rulings: build the subject caption, build the limit card as drawn; W11-1 subject caption; W11-2 dark scope `#FCFBF9`; W11-3 dark header rule; W11-4 limit sheet → centred card with ✕; validate format PASS · analyze 0 · **1534 / 0 / 0** · OVERALL PASS |
| Wave 11 — Quiz setup device walk | **COMPLETE** (owner `WALK`, 2026-09-26) — Pixel 8; W11-1…4 verified on device; new **W11-5** card ✕ 7.6 dp inboard + 2 dp small; new **W11-6** a repeat 403 stacks two cards |
| Wave 11 — Quiz setup acceptance | first walk **78%** (F 3/4, F4 N/A · V 2/3 · I 2/2) — F3 fails on W11-6, V2 on W11-5 — `device_walk_results.md` |
| Wave 11 — fixes (owner: "fix W11-5 and W11-6 in Wave 11 and re-walk") | **DONE** — W11-5 the frame's cross as `assets/icons/close_cross.svg`, 48 dp target centred on the frame's 23 dp box (24 from the card edge); W11-6 the setup listener ignores the loading state (KNOWN_BUGS BUG-012); +3 tests, all red first; validate format PASS · analyze 0 · **1537 / 0 / 0** · OVERALL PASS |
| Wave 11 — re-walk | **COMPLETE** (owner `WALK`, 2026-09-26) — **100%** (F 4/4, F4 N/A · V 3/3 · I 2/2): W11-5 and W11-6 verified on device. New **W11-7** (regression from the W11-5 fix): the ✕ is an `ImageView` to TalkBack, not a `Button` |
| Wave 11 — W11-7 fix + re-walk (owner: "fix W11-7 in Wave 11 and re-walk") | **DONE** — `excludeFromSemantics: true` on the ✕ glyph; +1 semantics test, red first (`unexpected flags: isImage`); validate format PASS · analyze 0 · **1538 / 0 / 0** · OVERALL PASS. Device: the ✕ is `android.widget.Button` in EN and AR; position, one-tap close and card unchanged. Wave 11 stays **100%**, no open items |
| Wave 12 — Quiz question implementation | **COMPLETE** (owner `NEXT`, 2026-09-26) — frames re-read (`159:845`, AI `159:1695`, dark AI `337:9182`, photo `216:2973`, `159:1431`, `159:1852`); owner rulings: build the explanation popup verbatim (D-015), leave the header AI icon out (DESIGN_ISSUES #95), whole photo (#96); W12-1…11; +20 tests; validate format PASS · analyze 0 · **1558 / 0 / 0** · OVERALL PASS; golden `ai_panel_dark.png` regenerated (the W12-3/4 glyph and colour only) |
| Wave 12 — Quiz question device walk | **COMPLETE** (owner "WALK 12 & 13", 2026-09-26) — Pixel 8; W12-1, 3, 4, 6–11 verified on device (light EN + dark AR) |
| Wave 12 — Quiz question acceptance | **100%** first walk (F 3/3, F2 + F3 + F5 N/A: the mock cannot fail a submit or send those codes · V 4/4 · I 2/2) — `device_walk_results.md` |
| Wave 12 | **COMPLETE / RECORDED** |
| Wave 13 — Quiz result implementation | **COMPLETE** (owner `NEXT`, 2026-09-26) — frames: light `159:1964`, light university `309:6375`, dark `337:6628`, dark university `349:14522`; owner rulings: remove "Back to Learn", ring anticlockwise in both languages (D-016), fix the shared back chip (BUG-013), figure stays 28 (DESIGN_ISSUES #97); W13-1…9; +18 tests; validate format PASS · analyze 0 · **1576 / 0 / 0** · OVERALL PASS; read-only Sonnet review: 0 findings |
| Wave 13 — Quiz result baseline walk | **COMPLETE** (owner "WALK 12 & 13", before the build) — **44%** (F 3/3 · V 0/4 · I 1/2): V1 ring, V2 runs, V3 CTA icon, V4 dark, I1 `2+` (BUG-003) fail — `device_walk_results.md` |
| Wave 13 — Quiz result re-walk | **COMPLETE** (owner "WALK 13", 2026-09-26) — Pixel 8, light EN + dark AR; W13-1…9 verified on device; BUG-003 (quiz half) and BUG-013 device-verified |
| Wave 13 — Quiz result acceptance | **100%** (F 3/3 · V 4/4 · I 2/2), up from 44% — `device_walk_results.md` |
| Wave 13 | **COMPLETE / RECORDED** |
| Wave 22 — Flashcards implementation | **COMPLETE** (owner `NEXT` + rulings `1A`–`10A`, 2026-09-29) — contract re-vendored to `f462968` (3.27.0-m1) first (ruling 3B), with `Lecture.flashcardCount`; frames `225:5582` (study, light), `1234:8797` (Setup, light), Lectures `180:5208` / `349:15962`; dark `337:14475` and Arabic `549:28041` are older layouts, built from the light one; W22-1…9 (the re-vendor, the mock's two operations, the 10-card round, the Lectures Flashcard tab, the shared study chrome, Setup, the study screen, the records, tests); review 15 confirmed, all fixed (BUG-019); format PASS · analyze 0 · **2017 / 0 / 0** · OVERALL PASS (+273 over Wave 21's 1744) |
| Wave 19 — Profile device walk | **COMPLETE** (owner `WALK`, 2026-09-28) — Pixel 8 on a plain mock build: school light EN, dark EN, dark AR, light AR; Go to Uni; Logout No / Yes; a cold restart; the university login recorded; the university Profile and Logout; back to the school student; offline. W19-1 verified on device (the university student on Home and Profile; 81 recorded frames go from the skeleton to the new name, never the old one; Top Student loads); W19-2 to W19-5 measured against the frames. Paused once for an incoming phone call (the walk section) |
| Wave 19 — Profile acceptance | **100%** (F 5/5 · V 3/3 · I 2/2) — `device_walk_results.md` |
| Wave 19 — Profile implementation | **COMPLETE** (owner `NEXT`, 2026-09-27/28) — frames: Profile `166:4416` / `309:7940`, dark `337:7433` / `349:12919`, RTL `549:21052` / `549:26384`; Logout `180:4598` (+ 5 variants); Go to Uni `180:4301` (+ dark, RTL); owner rulings: meProvider autoDispose (D-020), Points only (#101), the pair mirrored in Arabic (#102), dark scrim 60% on both tracks (#103); **W19-1** the stale profile after log-out → log-in fixed (BUG-015, W05-3's root); **W19-2** the Logout No / Yes pair; **W19-3** the dialog ✕ (the frame's cross, `#3F3F3F` light, a 48 dp target); **W19-4** the dialog card 345, Go to Uni's button 284 centred, Logout's bottom 15; **W19-5** the frame's 35 dp title bar, the card 25 under it; **W19-6** tests; validate **OVERALL PASS** 2026-09-28 (format PASS; analyze 0 issues; 1693 passed / 0 failed / 0 skipped) |
| Wave 18 — Mistakes lessons device walk | **COMPLETE** (owner `WALK`, 2026-09-27) — Pixel 8 on a plain mock build (no override needed), school student: dark EN, dark AR, light AR, light EN, offline (light EN); a recording from Chapters for F1 and one over the taps for F2. W18-1 verified (25.14 under the header, rows 16.00 apart, in all four); rows inert (no chevron ink, `View` not `Button`, taps change nothing); "1 mistake" / "خطأ واحد"; rows 81.90–82.29 EN / 84.95 AR (W16-6). The owner stood the phone upright first (it had been left in landscape; nothing was changed) |
| Wave 18 — Mistakes lessons acceptance | **100%** (F 3/3 · V 2/2 · I 1/1) — `device_walk_results.md` |
| Wave 18 — Mistakes lessons implementation | **COMPLETE** (owner `NEXT`, 2026-09-27) — frames: light `404:6762`, RTL `549:19390`; no dark frame draws Lessons (`404:7990` in its slot draws Chapters); `404:6853` is the replay quiz (out of scope, owner ruling 2026-09-12); no owner ruling needed; **W18-1** the list starts 25 under the header and the rows are 16 apart (were 20 and 12); **W18-2** tests on THIS screen (spacing, row geometry without the chevron, inert rows in EN and AR, a non-button semantics node, the plural on lesson rows in EN and AR, Arabic mirroring, the cached view, the skeleton, an unknown chapter, Retry, offline) and a four-lesson fixture; DESIGN_ISSUES #64 mapped (all 18 Mistakes frames); +14 tests; validate format PASS · analyze 0 · **1668 / 0 / 0** · OVERALL PASS (`validate.ps1`) |
| Wave 17 — Mistakes chapters device walk | **COMPLETE** (owner `WALK`, 2026-09-27) — Pixel 8 on a plain mock build (no override needed), school student: light EN, dark EN, dark AR, light AR, offline (AR light); a 20 fps recording for F1. W17-1 verified (25.14 under the header, rows 16.00 apart, in all four); rows 81.90–82.29 EN / 84.95 AR (W16-6, the mock's two-word Arabic names); F2 N/A on device (no deep links), covered by the Wave 17 test. One tap on the second row was lost once and never reproduced (four retries, each opened its Lessons) |
| Wave 17 — Mistakes chapters acceptance | **100%** (F 1/1, F2 N/A · V 2/2 · I 2/2) — `device_walk_results.md` |
| Wave 17 — Mistakes chapters implementation | **COMPLETE** (owner `NEXT`, 2026-09-27) — frames: light `404:6677`, dark `404:7894` (located this wave); no owner ruling needed; **W17-1** the list starts 25 under the header and the rows are 16 apart (were 20 and 12); **W17-2** F2 had no test on this screen (the test named for it opened an empty Units tree; renamed) and now does, with the Chapters rows' geometry, Arabic mirroring, button semantics, a failed load's Retry and the offline banner; the rows themselves needed nothing (Wave 16's shared row); #68 update (the dark Chapters frame's rows); +8 tests; validate format PASS · analyze 0 · **1639 / 0 / 0** · OVERALL PASS (`validate.ps1`); read-only Sonnet review, two lenses: correctness 0 findings (its runs: mistakes 49/49, analyze clean; it re-derived the red proof, the finder scoping to the Chapters screen, the F2 single fetch across go(), the Retry call count, the rename and the semantics and view teardown); frame and scope 1 low finding, refuted: it could not trace 404:6708 (the second light row cited in the #68 note) to facts.md, but the id is the second Button (y 218.44) in the MCP metadata of 404:6677; facts.md now names it. Scope confirmed: only the Chapters list changed, the Lessons list keeps 4 / 12 for Wave 18 |
| Wave 16 — Mistakes subject device walk | **COMPLETE** (owner `WALK`, 2026-09-27) — Pixel 8 on a plain mock build (no override needed): school light EN, dark EN, dark AR, light AR; university light EN and dark EN; offline; a 20 fps recording for F3. W16-1 and W16-3…5 verified; W16-2's insets and centres hold, but the rows are 82 dp: new **W16-6**, every mock name is two Arabic words (W15-6's mechanism; a throwaway real-font probe gives 78.00 for a one-word Arabic name), owner's call with W15-6. The row chevron glyph is 1.6 dp shorter than the frame's stroke (recorded, not logged) |
| Wave 16 — Mistakes subject acceptance | **100%** (F 3/3 · V 3/3 · I 2/2) — `device_walk_results.md` |
| Wave 16 — Mistakes subject implementation | **COMPLETE** (owner `NEXT`, 2026-09-27) — frames: school `404:6539`, university `404:7181`, dark `404:8686` / `404:7765` (`404:7110` is the university overview, Wave 15's); no owner ruling needed; W16-1…5 (list 25 under the header and rows 16 apart, the row's frame geometry, the chevron's end inset 12, the row chevron token, the light badge `#F4E6FF`); BUG-002 measured on the tree rows: not affected; #100 logged (catalog rows' chevron inset); +11 tests; validate format PASS · analyze 0 · **1631 / 0 / 0** · OVERALL PASS; read-only Sonnet review, two lenses: correctness 1 low finding, fixed: in dark the new chevron token equals mistakesContent (#FCFBF9), so the dark assertions could not catch a revert; the row test now reads a probe colour and fails on a revert (proved, it fails in dark); its runs: mistakes 87/87, row 15/15, colours 33/33, analyze clean. Frame and scope 0 findings (the paddings, the 2.5 lift and the centres re-derived by hand; scope held to the Mistakes palette and this screen). Validate re-run after the test fix: 1631/0/0 |
| Wave 15 — Mistakes overview device walk | **COMPLETE** (owner "WALK15", 2026-09-27) — Pixel 8, light EN + offline + dark EN + dark AR on a plain mock build (no override needed); W15-1…4 verified, W15-5 at 1.0 only (no overflow); new **W15-6**: a two-word Arabic subject name makes its row about 4 dp taller (the card grows as D-018 allows; likely the Inter space in a Tajawal line, the Wave 14 app-wide metrics), owner's call |
| Wave 15 — Mistakes overview acceptance | **100%** first walk (F 2/2, F2 + F3 N/A · V 2/2 · I 2/2, I2 N/A); second walk (owner `WALK`, same build, university track + light AR) **100%**, W15-6 reproduced — `device_walk_results.md` |
| Wave 15 — Mistakes overview implementation | **COMPLETE** (owner `NEXT`, 2026-09-27) — frames: light `404:6292`, dark `404:7428`; no owner ruling needed; W15-1…5 (card button semantics, 25 under the header, the frame's chevron, the frame's line centres, BUG-002 card growth, D-018); #99 logged (shared header title); +11 tests; validate format PASS · analyze 0 · **1620 / 0 / 0** · OVERALL PASS; read-only Sonnet review, two lenses: correctness 0 findings (its runs: mistakes 30/30, chevron + colours 38/38, analyze clean); frame and scope 1 finding (the chevron glyph 4% narrow), refuted: it took the arrow tip as x 12.70, but `chevron.svg`'s tip is its curve endpoint at x 13.06, which stretches to 11.32, the frame path's own tip (glyph 7.98 × 14.32, as drawn in the frame); guards 105/105 |
| Wave 14 — Quiz review device walk | **COMPLETE** (owner "WALK 14", 2026-09-27) — Pixel 8, light EN + dark AR + F3 on a normal build; W14-2…7 verified; BUG-014 device-verified; new W14-10 (Arabic underline invisible, font metrics) |
| Wave 14 — Quiz review acceptance | **100%** first walk (F 2/2, F2 N/A · V 3/3 · I 2/2) — `device_walk_results.md` |
| Wave 14 — Quiz review implementation | **COMPLETE** (owner `NEXT`, 2026-09-26/27) — frames: light `162:2377`, dark `337:6705`, RTL `549:20324`; owner rulings: one shared question-text widget on both screens (D-017, #88 closed, BUG-014), dark "QUESTION n" stays cream (#54); W14-1…9; +33 tests; validate format PASS · analyze 0 · **1609 / 0 / 0** · OVERALL PASS; read-only Sonnet review: frame-fidelity lens 1 finding (label line 4.36 low), refuted by the frame's own render ("QUESTION 1" ink centred 24.32 below the row top; the build's line centre 24.56; the finding's model 20.2); correctness lens (reported after the walk) 0 findings: parser and Bidi hand-traced against intl 0.20.2, scope and guards (105/105), the three test files green; one coverage note, the chip disc glyph colour is tested in light only |
| Wave 05 — Home device walk | **COMPLETE** — walk **60%** (W05-1 "See All" grey, W05-2 outline top-only, W05-3 stale profile → board 400) → owner: fix W05-1 + W05-2 → re-walk **100%** (F 5/5 · V 4/4 · I 1/1); validate **1479/0/0**. W05-3 open (Wave 19 root) |
| Wave 22 — Flashcards device walk | **COMPLETE** (owner `WALK`, 2026-09-29) — Pixel 8 on a plain mock build, the university student: light EN (the tab, Setup for four lectures, three rounds and the wrap, flip / grade / "<" recorded, ✕, the allowance spent to the 403, offline), dark EN, dark AR, light AR; two read-only Sonnet verifiers re-measured every claim |
| Wave 22 — Flashcards acceptance | **92%** (F 5/5, F4 N/A · V 3/4 · I 3/3) — V3 fails on **BUG-020** (a card's text takes the app's direction) — `device_walk_results.md` |
| Wave 22 — BUG-020 fix + targeted re-walk | **COMPLETE** (owner request, 2026-09-30) — a card's text, its screen-reader label and Setup's subject / lecture lines take their own direction (`contentTextDirection`, the quiz stem's rule); +19 tests, red → green (flashcards 209 / 12 with the fix reversed, 221 / 0 with it); validate format PASS · analyze 0 · **2036 / 0 / 0** · OVERALL PASS; two read-only Sonnet reviewers (0 high / medium); Pixel 8 re-walk of the four language / content combinations **4 / 4 PASS** (the walk's "?" and "." back in place; each card pixel-identical in both apps), two read-only Sonnet verifiers — `device_walk_results.md` |
| Wave 22 — Flashcards acceptance after the re-walk | **100%** (F 5/5, F4 N/A · V 4/4 · I 3/3) — V3 passes; the other criteria carried from the 92% walk (the fix changes only text direction) |
| **Next action** | **WAIT FOR USER COMMAND** — Wave 22 **COMPLETE (100%)**: BUG-020 fixed and re-walked (4/4 PASS); committed as `a988a1f` and pushed to `origin/merged` (2026-09-30). Waves 20 and 21 are not committed |

**Control rules in force:** no wave starts, no screen is touched, no WALK runs, no advance happens
without the owner's explicit command (`NEXT`, `WALK`, `FORMULATE`). Subagents: Sonnet only. Replies:
concise. Context: checkpoint this file at ~40% and ask the owner to run `/compact`.

**Scope note, Wave 01:** besides Login, Wave 01 edited Sign-up identity (`signup_identity_screen.dart`):
the shared `+20` LTR fix planned in FORMULATE, plus the same frozen-error defect (BUG-004). Both are
recorded under Wave 01; no other screen was changed.

**Scope note, Wave 02:** besides the OTP screen, the owner-approved W02-5 fix touched the shared router
(`app_router.dart`: `/otp` → `/login/otp`) and one navigation call in `login_screen.dart`; the owner-requested
mock trigger touched `lib/dev/mock_backend.dart` + a doc line in `lib/main_mock.dart`. Plus 3 colour tokens
in `app_colors.dart` and the regenerated `test/goldens/otp_dark.png`.

| Field | Value |
| --- | --- |
| Current wave | 22 — Flashcards: **COMPLETE (100%)**, committed as `a988a1f` and pushed (2026-09-30); walked 92% (owner `WALK`, 2026-09-29; V3 failed on BUG-020, a card's text took the app's direction), then **BUG-020 fixed and re-walked: 100%** (owner request, 2026-09-30; 4/4 combinations PASS), validate 2036/0/0 (the full working tree; the committed Wave 22 tree alone 1985/0/0). Open for the owner: **the Figma credential** (TEXT `1240:9847`: remove + rotate), **Wave 22's two provisional Arabic strings** (the Setup pill and helper, #114), W18-3 (the inert row's text column), review's AI glyph size, D-019's placement (`FORMULATE`) |
| Branch / HEAD | `merged` = `origin/merged`. Last product checkpoint `a988a1f` (Wave 22 alone, with the BUG-020 fix; committed and pushed on the owner's request, 2026-09-30) on `cccd2f1` (the Waves 01–19 checkpoint, 2026-09-28). Not committed: Waves 20 (Edit Profile) and 21 (Settings), finished and walked, in the working tree |

## Completed investigation

- Contract re-vendored `768e67d` (3.22.0-m1) → `ea83099` (3.23.0-m1): only two new **draft** ops
  (`getTermsAcceptance`, `acceptTerms`). Census 33 stable (30 app-buildable + 3 web-only) · 16 draft · 49.
- Endpoint inventory: 23 STABLE+READY · 3 stable data-layer-only (entitlements, flashcards ×2) ·
  4 stable not implemented (fcm-token, deletion ×2, getMyRank by decision) · 3 web-only absent ✔ ·
  16 draft.
- Screen-first audit of every route; Figma screen index by node id (MCP).

## Files changed (uncommitted on 2026-09-24; committed since, in `cccd2f1`)

- `contract/openapi.yaml`, `contract/contract-changelog.md` — byte-identical to upstream `ea83099`
- `contract/SOURCE.md` — new pin, census, delta
- `.ai/audits/current/test-results.md` — rewritten by `tool/validate.ps1`
- new: `api_contract_update.md`, `api_ui_endpoint_inventory.md`, `endpoint_ui_mapping.md`,
  `screen_api_gaps.md`, `wave_state.md` (this file)
- untouched: `project_files_forensic_audit.html`, `project_files_inventory.json` (another session's)

## Tests run

`tool/validate.ps1` on the re-vendored tree → format PASS · analyze 0 issues · **1429 passed /
0 failed / 0 skipped** · OVERALL PASS (BUILD VERIFIED).

## Figma evidence

UI source = **Figma MCP** (reads work; page listing only returns `0:1`, screens reachable by direct
node id; Glass invisible → Chrome/desktop fallback needed for dark elevation). Index in
`endpoint_ui_mapping.md` §4.

## Known issues carried into COMPARE

1. Mock backend lacks `PATCH /me` and any `/flashcards` route → Profile/Settings save and a
   flashcards screen cannot be device-walked on `main_mock.dart` without mock work.
2. Flashcards design `225:5582` shows no reverse side and no self-grade control.
3. Account deletion: stable ops, store-mandatory, **no design** → product decision.
4. Push: stable op, no Firebase setup, toggles have no contract storage → product decision.
5. Notifications design `180:8386` has Promotions ("Premium Offer — 40% Off!") and "Daily Streak"
   rows → purchase-silent + no-streak rulings needed; draft ops anyway.
6. Notifications vs Messages frames — which surface the inbox is, is unsettled.
7. Stale `openapi.yaml:NNN` citations (+61 after line 913) and stale pin comments — comment-only.
8. Stale 0-byte `.git/index.lock` (2026-09-22 19:17, no git process) — remove before any commit.

## Candidate UI-assisted screens for COMPARE (not yet waves)

Screens where a stable endpoint is connected or connectable to a designed frame: Login, OTP,
Sign-up wizard (identity/track/school/university), Home, Leaderboard, Subjects + subject tree,
Mistakes, Quiz setup, Quiz, Quiz result/review, Profile, Edit Profile, Settings, **Flashcards (unbuilt)**.
COMPARE decides which of these need work; FORMULATE turns each into exactly one wave.

## COMPARE result (2026-09-24)

22 UI-assisted screens: READY 9 · NEEDS IMPLEMENTATION 11 · NEEDS DESIGN CLARIFICATION 2
(Settings, Flashcards) · API work secondary on 5. Unlinked stable endpoints: 5 (entitlements,
fcm-token, deletion ×2, getMyRank). Screens with API gaps: 8.
New endpoint→screen link: Home "Top Student" ← `GET /leaderboard` (comment "no endpoint yet" stale).
Lead refuted two agent claims (stale-profile "fixed"; RTL chevrons "fine") and confirmed three
(Logout No/Yes `180:4704`; explanation popup `openapi.yaml:1688-1703`; `{gotIt, again}`); quiz visuals
spot-checked (subject caption confirmed in code; idle-chip hairline downgraded to unread).
Agent reports persisted in the session scratchpad `agents/CMP*.md`.

Blockers for FORMULATE: owner ruling on the explanation `subscription_required` popup; account
deletion has no design; flashcards design questions (5); mock backend lacks `PATCH /me` and
`/flashcards`; push needs Firebase + product call.

## FORMULATE result (2026-09-24)

22 waves = 22 UI-assisted screens (READY screens get verify-and-walk waves). Build waves: 01, 05,
07, 08, 11, 12, 13, 15, 16, 19, 20, 21 (gated), 22 (gated). Verify waves: 02, 03, 04, 06, 09, 10,
14, 17, 18. Shared fixes land once: `+` LTR (01), chevron helper (07), `TreeListRow` semantics
(08), mock `PATCH /me` (20). Owner inputs listed at the end of `implementation_waves.md`.

## Wave log

| Wave | Screen | Status | Acceptance |
| --- | --- | --- | --- |
| 01 | Login | first walk 70% → fixes W01-1…5 → re-walk | **100%** (F 5/5 · V 3/3 · I 2/2) — `device_walk_results.md` |
| 02 | OTP | frame re-read → W02-1…4 → walk 78% → fixes W02-5 (`/login/otp` + args kept) and W02-6 (31/3/28.8) → re-walk | **100%** (F 6/6 · V 2/2 · I 1/1). Mock: `999999` → `otp_invalid`. Open: W02-7, W02-8 |
| 03 | School registration | frame re-read (`125:511` first time, `337:5269`) → W03-1 rhythm, W03-2 subtitle grey → owner `NEXT` without `WALK` | not scored (unwalked) |
| 04 | University registration | frame re-read (`125:2336` first time, `337:10373`) → W04-1 rhythm, W04-2 subtitle grey → walk 78% → fixes W04-3 (opaque dark menu) + W04-4 (refused rows dimmed) → re-walk | **100%** (F 5/5 · V 2/2 · I 2/2) |
| 05 | Home | Top Student block built on the tab's board (owner-chosen scope + See All) · 2 tokens · board refetch on new points → walk 60% → fixes W05-1 ("See All" in the title colour) + W05-2 (outline all round + frame padding; tokens renamed) → re-walk | **100%** (F 5/5 · V 4/4 · I 1/1). Open: W05-3 |
| 06 | Leaderboard (verify) | frames re-read (university `134:3626` first time: its toggle IS `Global · Cohort`) → W06-1 podium badges per place (fill + stroke, both canvases) · #92 toggle divergence logged · #93 dark numerals logged → walk 78% (W06-2 row text colours, W06-3 "You" row `#DBB0FF`, W06-4 row gap / avatar) → fixes W06-2/3/4 → re-walk | **100%** (F 4/4, F3 N/A · V 3/3 · I 2/2) |
| 07 | Subjects | frames re-read (`134:3837`, `308:4521`, dark `337:5702` = a real dark frame) → W07-1 chevron helper + guard · W07-2…5 light card title / chevron / bar fill / track → walk | **100%** (F 3/3, F2 + F4 N/A · V 2/2 · I 2/2). W07-6 → Wave 08 |
| 08 | Subject tree root | frames re-read (`135:815`, `337:5894`, `180:5354`, `180:5208`, dark `349:15962` + `337:11059` = real dark Lectures frames) → W08-1 semantics · W08-2 back chip (BUG-010) · W08-3…5 row chevron / bar / rhythm → walk 89% → fix W08-6 → re-walk | **100%** (F 3/3, F3 N/A · V 3/3 · I 3/3) |
| 09 | Chapters (verify) | frames re-read (`135:1270`, dark `337:6047`) → W09-1 row gap 16 · unknown-unit tests → walk | **100%** (F 2/2, F2 N/A · V 2/2 · I 2/2) |
| 10 | Lessons (verify) | frames re-read (`135:1485`, dark `337:6143`) → W10-1 row gap 16 · screen-level semantics test → walk | **100%** (F 3/3 · V 2/2 · I 2/2) |
| 11 | Quiz setup (build) | frames re-read (`135:1622`, dark `337:6239`, limit `199:2335`) → owner: caption + card → W11-1 subject · W11-2 dark scope · W11-3 dark rule · W11-4 limit card + ✕ → walk | **78%** (F 3/4, F4 N/A · V 2/3 · I 2/2); W11-5, W11-6 open |

## Wave 01 — implementation record (2026-09-24)

- **Changed (lib):** `lib/features/auth/screens/login_screen.dart`,
  `lib/features/registration/screens/signup_identity_screen.dart` — `textDirection: TextDirection.ltr`
  on the `Phone.egyptDialCode` chip `Text` (bidi ES: leading `+` painted `20+` in AR).
- **Added (test):** `test/core/visual_order.dart` (`glyphLeft()` — painted-order probe);
  one Arabic test each in `test/features/auth/login_validation_test.dart` and
  `test/features/registration/registration_screens_test.dart`. Both FAILED on the old code
  (`+` x=32, `2` x=0) and pass now.
- **Docs:** `docs/KNOWN_BUGS.md` BUG-003 (partly fixed; quiz-result half → Wave 13);
  `docs/DESIGN_ISSUES.md` #9 addendum (legal wording, Figma `82:1086` read verbatim — copy NOT
  changed, legal's call) and new #89 (language pill 36.1 dp tap target, `82:1093` = 78.13×36.10 —
  owner decision, same class as #80/D-013).
- **Validation:** `tool/validate.ps1` → format PASS · analyze 0 · **1431 / 0 / 0** · OVERALL PASS.
- **Device for WALK:** no device attached at 2026-09-24; AVDs available: `Pixel_8`,
  `Medium_Phone_API_36.1`.
- **Not done in this wave (by design):** legal copy change, pill hit-area change, width cap.

## Wave 01 — walk (2026-09-24)

Pixel 8 (physical), mock build. PASS: F1–F5, V3 (`+20` fix DEVICE VERIFIED), I1. FAIL: V1 (logo
size, subtitle style, vertical rhythm vs `82:819`), V2 (bird logo black on dark — frame fills
`#FCFBF9`), I2 (validation error frozen in the old language after a toggle, `login_screen.dart:96`).
New build defects W01-1…W01-5 listed in `device_walk_results.md`. Device restored (airplane off,
Wi-Fi on); debug app data cleared (dark pref gone; app now starts in Arabic).

## Wave 01 — fixes + re-walk (2026-09-24)

User asked to fix W01-1…5 in Wave 01. Done: `brandLogo` token (light `#040404`, dark `#FCFBF9`) +
bird tint; bird at 132.854; subtitle `h2` start-aligned; frame gaps 18·3·68·25·10·25·25·25·20;
errors stored as flags on Login AND Sign-up identity (same bug). +7 tests → `validate.ps1`
**1438/0/0 PASS**. Re-walk on the Pixel 8: **10/10**. Docs: KNOWN_BUGS BUG-003 (device verified),
BUG-004 (new, fixed); DESIGN_ISSUES #21 addendum (the dark Login frame draws Create New Account
cream too — still the owner's call). Device left: dark + Arabic, on Sign-up identity; airplane off,
Wi-Fi on.

**Files touched by Wave 01 (uncommitted):** `lib/core/theme/app_colors.dart`,
`lib/features/auth/screens/login_screen.dart`,
`lib/features/registration/screens/signup_identity_screen.dart`, `test/core/visual_order.dart`
(new), `test/core/theme/app_colors_test.dart`, `test/features/auth/login_validation_test.dart`,
`test/features/registration/registration_screens_test.dart`, `docs/DESIGN_ISSUES.md` (#9, #21, #89),
`docs/KNOWN_BUGS.md` (BUG-003, BUG-004).

## Wave 02 — OTP — pre-walk frame re-read (2026-09-24)

Re-read with `get_design_context`: `82:1171` (input), `82:1170` (light component set — it HAS a
`Type= wrong` variant `82:1439`), `337:19271` (dark set, wrong = `337:19284`), `155:786` (success),
`337:19503` (dark timer). Frame-proven defects, so the verify wave becomes a build wave:
- W02-1 error state: frame keeps the resting cell fill and strokes `#EB001B`@50% at the resting width;
  message Inter Medium 10 `#FF465C`, start-aligned, no icon, 13 below the digits / 20 above Verify.
  Build: 6% red tint, 1.5 `cs.error` (M3 seed red), bodyMedium 14 centred + icon. DESIGN_ISSUES #49
  says "no frame draws an error" — refuted.
- W02-2 timer content: light `#384F47`, dark `#FCFBF9` for glyph AND digits (`337:19503` + its glyph
  export); digits Medium 12 = `AppType.labelMedium`. Build: glyph `cs.primary` (lavender in dark),
  digits `textSecondary` bodyMedium 14.
- W02-3 language pill: `82:1171` draws it top-end on the INPUT view; the build shows it only after
  success. Back chip (the build's recorded addition, DESIGN_ISSUES line ~862) stays at start.
- W02-4 success: text block ends 15 above the 267 group's bottom, then gap 60 → 75 to Continue; build 60.
Left for the WALK to measure: input-view vertical rhythm (the frame's text uses cap/baseline trim).
Type-scale class, not changed: title 25, subtitle 18/400, Resend 18/700, success 22/20, CTA sizes.

**Wave 02 implementation record:** `lib/core/theme/app_colors.dart` (+3 tokens `otpTimerContent`,
`otpErrorText`, `otpDigitErrorBorder`, 6 wiring sites each), `lib/features/auth/screens/otp_screen.dart`
(header row, error line + cells, timer content, success gap; `_InlineMessage` and the icon removed).
Tests +7 (`app_colors_test` ×3, `otp_elevation_test` +3 net, `otp_screen_test` +1); the 6 widget
assertions were run against the HEAD `otp_screen.dart` and FAILED there, pass now. `test/goldens/otp_dark.png`
regenerated (diff = pill added + cream timer, reviewed). Docs: DESIGN_ISSUES #49 (error slot correction,
digit tint answered, type-size list) and the back-chip note (~line 862). `validate.ps1` → format PASS ·
analyze 0 · **1445 / 0 / 0** · OVERALL PASS. Nothing committed.
**Walk plan (on `WALK`):** criteria F1–F6, V1, V2, I1 from `implementation_waves.md` Wave 02; measure
input-view rhythm vs `82:1171`; wrong code on the mock = any 6 digits other than `000000`/`111111`
forks to registration — check `mock_backend.dart` for an `otp_invalid` trigger before the walk.

## Wave 03 — School registration — frame re-read + implementation (2026-09-24)

Re-read with `get_design_context` + `get_metadata`: light `125:511` (COMPARE had not read it) and dark
`337:5269`. The frame's text is NOT trimmed here (title box 29 = 22 × 1.3, subtitle 26, labels 21.6),
so its gaps are box-to-box and need no device translation.
- **W03-1 rhythm** (frame-proven, screen-local): header row bottom 100.98 → title 126; subtitle bottom
  189 → fields 214; field blocks 25 apart (`Component 4` auto-layout); fields bottom 891 → CTA 916.
  All **25**. Build: 8 / 28 / 16 / 28, and outside Egypt Grade → CTA stacked 16 + 28 = 44. Now one
  `_gap = 25`; the school block owns its leading gap, so a non-Egypt form has a single 25.
- **W03-2 subtitle** (frame-proven): `125:536` `#7C7C7C` → `bodyMuted` per DESIGN_ISSUES #24 (was
  `textSecondary` `#2C2C2C`). Dark `#D6D6D6` vs `bodyMuted` dark `#ECECEC` → #24 addendum.
- **Recorded, not changed** (DESIGN_ISSUES **#90**, shared widgets also used by University / Sign-up
  identity / Edit Profile): label → box gap 10 (build 8); label Inter Medium 18 (build `labelLarge`
  14/600, the handoff's "Form labels"); value text 18 (build 16); custom `#2A2A2A` chevron; inset
  10/16 vs 14; dark-frame inconsistencies. Type-scale class, not changed: title 22 Bold (build `h1`
  24), subtitle 20 Regular (build `bodyLarge` 16), CTA text 22 (build `buttonLarge` 16).
- **Files:** `lib/features/registration/screens/school_detail_screen.dart`;
  `test/features/registration/school_detail_screen_test.dart` (+3: rhythm Egypt, rhythm non-Egypt,
  subtitle colour; all three FAILED against HEAD — 8, 44, `#2C2C2C` — and pass now);
  `docs/DESIGN_ISSUES.md` (#24 addendum, new #90). No token, router, mock or golden change.
- **Validation:** `tool/validate.ps1` → format PASS · analyze 0 · **1452 / 0 / 0** · OVERALL PASS.

**Walk plan (on `WALK`):** criteria F1–F6, V1, V2, I1, I2 from `implementation_waves.md` Wave 03.
Mock path: Login → a new number → OTP (any code other than `000000` / `111111` / `999999`) →
identity → track School → this screen. Measure the 25 rhythm on the device; F6 (expired token) needs
the registration token to expire or a mock trigger — check `mock_backend.dart` before the
walk, score N/A if unreachable. Light + dark, AR + EN.

## Wave 04 — University registration — frame re-read + implementation (2026-09-24)

Owner said `NEXT` with Wave 03 unwalked → Wave 03 closed **implemented, not scored**. Wave 04 re-read
light `125:2336` (first read) and dark `337:10373` with `get_design_context` + `get_metadata`.
Untrimmed text again (title 29, subtitle 26, labels 22).
- **W04-1 rhythm** (frame-proven, screen-local): header → title 25, subtitle → fields 25, field
  blocks 25; build 8 / 28 / 16 / 28. The frame parks the CTA near the bottom of a 4-field form
  (fields end 657, CTA 834); the built form has 6 fields and scrolls, so the CTA follows the last
  block at 25, as on School.
- **W04-2 subtitle**: `125:2361` `#7C7C7C` → `bodyMuted` (was `textSecondary`). Dark draws `#DEDEDE`.
- **Finding, doc-only:** DESIGN_ISSUES **#4** — the LIGHT frame already draws University → Faculty →
  Academic Year → City, i.e. the build's cascade order; only the dark frame has the old order. Class
  doc of `university_detail_screen.dart` updated to say so.
- **Recorded, not changed:** #90 addendum — label → box **10** confirmed on both tracks (still the
  owner's call, shared widgets); light University title + labels `#384F47` vs School black/`#1B1B1B`
  (frames disagree → designer); dark field fill/stroke differs from School (Glass). #24 addendum.
  Still absent from both frames: governorate (#3), date of birth (#2).
- **Files:** `lib/features/registration/screens/university_detail_screen.dart`;
  `test/features/registration/university_detail_screen_test.dart` (+2: rhythm, subtitle colour; both
  FAILED against HEAD — 8, `#2C2C2C` — pass now); `docs/DESIGN_ISSUES.md` (#4, #24, #90 addenda).
  No token, router, mock or golden change.
- **Validation:** `tool/validate.ps1` → format PASS · analyze 0 · **1454 / 0 / 0** · OVERALL PASS.

**Walk plan (on `WALK`):** criteria F1–F5, V1, V2, I1, I2 from `implementation_waves.md` Wave 04. Mock
path: Login → new number → OTP (not `000000`/`111111`/`999999`) → identity → track University → this
screen. Check the mock serves a `soon` study year (F3/I1); measure the 25 rhythm; light + dark, AR + EN.

## Wave 04 — fixes (2026-09-24)

**Wave 04 fixes (owner: "fix them in Wave 04 and re-walk"):** `lib/features/registration/widgets/reference_dropdown.dart`
(menu fill `Color.alphaBlend(ext.fieldFill, ext.background)`; refused rows dimmed), `lib/core/widgets/form_fields.dart`
(`disabledControlOpacity = 0.6`, shared with `FieldShell`, no visual change there),
`test/features/registration/reference_dropdown_test.dart` (+3; the two dark cases FAILED on HEAD — alpha 0.2, no
dimming). `docs/KNOWN_BUGS.md` BUG-006. Scope note: the dropdown is shared, so School registration's pickers
got the same two fixes (not walked there).

## Wave 05 — Home — implementation (2026-09-24)

Owner `NEXT`. Frames read: school light `59:1439` (metadata; Top Student `59:2086` design context),
university light `125:2373` (screenshot: the same three-row block), dark `337:5456`. The frame gives
no `scope` and no "See All" target → **stopped and asked** (AskUserQuestion). Owner: the Leaderboard
tab's default board (school `system`, university `global`) and "See All" opens the tab.
Recorded as `docs/DECISIONS.md` **D-014**.
- **Built:** `lib/features/home/widgets/top_student_section.dart`: the top 3 of the tab's board,
  the same provider instance, so one request; medal 🥇🥈🥉 · avatar 40.134 · name · points;
  dividers between rows in the card's hairline; four states (loading, empty, error with the tab's
  retry rules, offline). "See All" → `/leaderboard`. The board refetches when `/me` points change
  (after a quiz), so a top-three student never reads two totals. The stale "no endpoint yet" comments
  on Home were rewritten.
- **Shared, no behaviour change:** `board_failure.dart` (the tab's error copy and retry rules,
  extracted, and the tab now calls it); `LeaderboardScope.defaultFor`; the Top Student surface moved
  out of `coming_soon_section.dart` (enum value removed).
- **Tokens:** `topStudentName` (light `#384F47` `59:2096`, dark `#FCFBF9` `337:5466`) and
  `topStudentPoints` (light `#E67E22` `59:2098`, dark `#AE87E7` `337:5468`), 6 sites each. The
  dividers reuse `topStudentTopBorder` and its width.
- **Type-scale mapping, recorded in the code, not changed:** medals 16.8/20.5 → `h3` 18; name
  Cairo SemiBold 13.3 → `labelLarge`; points Rajdhani Bold 13.3 → `labelLarge`. The card is sized
  to its rows: the frame's fixed 204.785 leaves about 5.9 empty at the bottom. The frame's 1.208 inner
  padding was not built (it is since the W05-2 fix). "See All" is text-sized, the same tap-target class as #89.
- **Tests:** new `test/features/home/top_student_section_test.dart` (20): board per track, one
  request for Home + tab, rows, dividers, tokens, empty/error/429/403/offline, See All, the refetch
  on new points (FAILED with the listener removed), and the surface tests moved from
  `coming_soon_section_test.dart`. `home_screen_test.dart`: the board stubbed; a failed board leaves
  Home standing. The harnesses (catalog/profile/quiz/settings) got a `QuietLeaderboardRepository` and
  `holdBoards(container)`. Without them, a test that passed through Home left a timer pending at
  teardown (10 failures on the first full run): first a real request's, then Riverpod's zero-length
  dispose timer for the `autoDispose` board, which runs once the flutter vsync is gone.
- **Validation:** `tool/validate.ps1` → format PASS · analyze 0 · **1475 / 0 / 0** · OVERALL PASS.
- **Not done (out of Wave 05 scope):** Daily Tasks (no operation), Continue Learning (draft), bell
  (draft).

**Walk plan (on `WALK`):** criteria F1–F6, V1–V4, I1 from `implementation_waves.md` Wave 05. The mock
serves `/leaderboard` (fixture since 2026-09-22). School via OTP `000000`, university via `111111`.
F6: finish a quiz and check that the level card AND the Top Student points move (the quiz screen
sets FLAG_SECURE; the walk only needs Home afterwards). Offline; AR + EN; light + dark.

## Wave 05 — walk (2026-09-25)

Owner `WALK`. Full record in `device_walk_results.md`. **60%**: every functional criterion passes (F3
empty is N/A on the mock; F4 was reached through W05-3; F6 proved the board refetch on device). All
four visual criteria fail on **W05-1**: "See All" is `mutedText` `#B3B3B3`, and the frames draw it
`#000000` light / `#FCFBF9` dark, in all three headers. V3 also fails on **W05-2**: frame `59:2090`
strokes the light outline on all four sides, the build only the top (following `edit3.md`). **W05-3**:
the known stale profile after log-out → log-in (Wave 19) now also sends the old track's `scope`, and
the block shows an error that Retry cannot clear.

## Wave 05 — fixes + re-walk (2026-09-25)

Owner: "fix W05-1 and W05-2 in Wave 05 and re-walk". `docs/KNOWN_BUGS.md` **BUG-007**.
- **W05-1:** "See All" `mutedText` → `textPrimary` in `coming_soon_section.dart` and
  `top_student_section.dart`.
- **W05-2:** `TopStudentSurface` `topSide` → uniform `side` + the frame's `p-[1.208px]`; the dark frame
  `337:5460` says `border-[1.208px]` all round too, so both canvases change. Tokens renamed
  `topStudentTopBorder(Width)` → `topStudentBorder(Width)` in `app_colors.dart` / `app_elevation.dart`
  (+ their tests, `elevated_surface_test.dart`); `elevated_surface.dart` doc; `edit3.md` #3 corrected with a
  date.
- **Tests:** the surface test flipped (it had pinned the top-only line) and pins the padding; +4 "See All
  wears the title colour" cases (Top Student and Daily Tasks, light and dark). All six FAILED with the fix
  reverted. Golden `home_section_daily_tasks_dark.png` regenerated (diff = "See All" glyphs only).
- **Validation:** `tool/validate.ps1` → format PASS · analyze 0 · **1479 / 0 / 0** · OVERALL PASS.
- **Re-walk:** 100%, V1–V4 and I1 on device (`device_walk_results.md`).

## Wave 06 — Leaderboard (verify) — frame re-read + implementation (2026-09-25)

Owner `NEXT`. Frames: school light `133:3117` (metadata + `Ranks` `134:3421` design context), university
light `134:3626` (**first read**), dark `337:5528` (metadata + `Ranks` `337:5577`). Dark frame id from
`edit4.md` #19.
- **University frame:** its toggle reads **`Global · Cohort`**, the contract's university scopes. That
  settles the school frame's `NOW · Last Month` as the outlier. Otherwise it is the same layout as school.
- **#92 (the wave's MISSING item):** logged in `docs/DESIGN_ISSUES.md`. The contract (`openapi.yaml:2123`)
  has `scope` / `cursor` / `limit` and no time dimension. The build stays a scope switcher, and
  `scope_toggle.dart` now cites #92.
- **W06-1 — podium badges (frame-proven, fixed):** the frames give each place its own badge (`#FFCA28`
  + black/`#FCFBF9` · `#F4F4F4` + `#DC4A22` · `#FCFBF9` + `#DEDEDE`, the same in both canvases). The
  build had given every badge a `textPrimary` stroke, and place 3 used place 2's fill; the code doc even
  said "1px black hairline; only the fill changes". Fixed in `podium.dart` with 2 new tokens
  (`podiumSecondBadgeBorder`, `podiumThirdBadgeFill`, 6 sites each). Place 3's stroke reuses
  `podiumThirdRing`, and the stale dark note "337:5528 not measured" is corrected.
- **#93 (logged, not changed):** in the dark frame the numerals are `#FCFBF9` on the pale badges:
  1.48 / 1.06 / 1.00:1. Built as drawn (the #86 precedent); designer ruling. Also recorded: numerals are
  NATS 20 in the frame, `captionSmall` 10 in the build (not in the scale, not changed).
- **Tests:** new `test/features/leaderboard/podium_test.dart` (3: per-place colours light + dark, a tie
  keeps place colours). All 3 FAILED on the old `podium.dart`. `app_colors_test.dart` pins that the
  two new tokens don't flip with the canvas.
- **Validation:** format PASS · analyze 0 · **1482 / 0 / 0** · OVERALL PASS.
- **Not changed, still recorded:** the crown (asset not exported; trophy glyph stands in), "level …Pts"
  (no `level` on `LeaderboardEntry`), #86 ("You" row 1.75:1), the toggle's selected label (#77 family).

**Walk plan (on `WALK`):** criteria F1–F5, V1–V3, I1, I2 from `implementation_waves.md` Wave 06. Both scopes,
both pages of the 22-peer fixture (scroll paging), the "You" row, offline, AR + EN, light + dark, both
tracks. Compare the Home Top Student rows with the podium. Check the badges on the phone against the frame
values above. F3 (load-more error keeps rows) and empty are likely unreachable on the mock → say so.

## Wave 06 — walk (2026-09-25)

Owner `WALK`. Pixel 8, fresh mock build. School dark + EN, light + EN, light + AR; university light + EN
and dark + EN (fresh process); offline. Full table in `device_walk_results.md`.
- **Score:** F 4/4 (F3 N/A: the in-process mock can't fail an append) · V 1/3 · I 2/2 → **7/9 = 78%**.
- **W06-1 verified on device**, both canvases and both tracks: badge fills and strokes are the frame's to
  the hex.
- **W06-2 (V2, V3):** row text was never read. The frame has `#4F4F4F` light / `#FCFBF9` dark for rank,
  name AND points. The build has `#0E0E0E` / `#0E0E0E` / `#2C2C2C` light, and `#DCDCDC` points in dark.
- **W06-3 (V2, V3):** the "You" row reads `#DBB0FF` (`134:3554`, `337:5638`); `podiumAccent` is
  `#D8B0FF`. This closes `edit4.md` §19's open read.
- **W06-4 (V2):** gap 8 (build 10), avatar 32 (build 36), avatar start 40.1 (build 48).
- **Recorded, not scored:** #93 on device (the dark "3" is invisible); the stale `leaderboardProvider` doc
  ("keeps each board warm"; it refetches); type-scale deltas.
- Nothing fixed during the walk.

## Wave 06 — fixes + re-walk (2026-09-25)

Owner: "fix W06-2, W06-3 and W06-4 in Wave 06 and re-walk".
- **W06-2:** a new token `leaderboardRowText` (`#4F4F4F` light / `#FCFBF9` dark, 6 sites) colours rank, name
  and points; `leaderboard_row.dart` drops `textPrimary` / `textSecondary`.
- **W06-3:** `podiumAccent` `#D8B0FF` → **`#DBB0FF`** on both canvases (its only consumer is the caller's
  row). The `app_colors.dart` docs and `app_colors_test.dart` are updated; DESIGN_ISSUES #72 and `edit4.md`
  carry dated resolution notes.
- **W06-4:** avatar 36 → 32. The rank column stays 28 (it must hold "200"); leading pad 12 → 8 and rank →
  avatar 8 → 4, so the digit sits about 22 in and the avatar at 40. The list separator is 10 → 8.
- **Tests:** new `test/features/leaderboard/leaderboard_row_test.dart` (6) and one screen test (row gap). The
  6 that pin a changed value all failed on the old code (written first, run first). The three-digit case
  loads the real fonts (`loadAppFonts`), because the test face would wrap "200" in any 28 column.
- **Validation:** format PASS · analyze 0 · **1489 / 0 / 0** · OVERALL PASS. No golden changed.
- **Re-walk:** **100%**. Every fixed value is measured on the phone, both canvases, both tracks, AR. See
  `device_walk_results.md` and KNOWN_BUGS BUG-008.
- **Still recorded, not changed:** #93, #86, crown, "level …Pts", type-scale deltas, the stale
  `leaderboardProvider` doc comment.

## Wave 07 — Subjects — frame re-read + implementation (2026-09-25)

Owner `NEXT` (typed "MEXT"). Frames: school light `134:3837`, university light `308:4521`, and dark `337:5702`
(metadata); `get_design_context` on the cards `135:618`, `404:6978`, `337:5732`; chevron SVG fills pulled.
- **The planned DESIGN_ISSUES item is withdrawn.** `337:5702` is a complete dark Subjects frame: search,
  grid, header with the Mistakes pill and the dark nav bar. `337:5732` / `337:5724` are its card and search
  field, not loose components. COMPARE §10 said no dark frame exists, and it now carries a dated
  correction. The palette note said the opposite ("only a DARK Learn frame exists"), which is how the light
  values below were never read. School and university are identical in light, so one dark frame covers
  both tracks.
- **W07-1 — RTL chevron (planned, device-proven 2026-09-20):** `forwardChevron` / `backChevron` are now
  constants holding the LTR glyph, and `Icon`'s `matchTextDirection` mirrors it. 3 call sites. KNOWN_BUGS
  BUG-009.
- **W07-2…5 — light card colours (frame-proven, both light frames agree; dark already matched):** title
  `#384F47` (was `textPrimary` `#0E0E0E`), chevron `#517066` (the SVG fill; was `#0E0E0E`), bar fill
  `#AE87E7` on both canvases (was `cs.primary`, green in light), track `#ECECEC` (was `#D1D1D1`). There are 3
  new tokens (`subjectCardTitle`, `subjectCardChevron`, `subjectCardProgress`, 6 sites each), and
  `catalogTrack` light is corrected. `catalogTrack` has one consumer, this card.
- **Tests:**
  - `drill_in_chevron_test.dart` (6): the DRAWN direction for all 3 widgets × `en` / `ar`; the 3 Arabic
    cases failed on the old helper.
  - `subject_card_test.dart` (2): light failed on the old code.
  - New guard `no glyph is swapped for its mirror image`, with 5 fixtures and a `verify_guards.ps1` probe;
    it fired on the unfixed tree.
  - `mistakes_screens_test.dart` "chevrons mirror in RTL" had asserted the bug (the `chevron_left` glyph)
    and was rewritten to check the drawn direction. The rewrite fails with the old glyph put back.
- **Validation:** format PASS · analyze 0 · **1503 / 0 / 0** · OVERALL PASS; `verify_guards.ps1`: all 10 guards fire, the new one included.
- **Not changed:** the chevron's shape (Material `chevron_right` 16 vs the frame's `weui:arrow-filled`); #15
  caption 8.56 → 10; the dead back chip on the university Subjects root, which the plan gives to Wave 08.

**Walk plan (on `WALK`):** criteria F1–F5, V1, V2, I1, I2 from `implementation_waves.md` Wave 07. Chevron
direction on the phone in AR and EN (grid + a tree row + Mistakes), search, card tap, the Mistakes pill,
offline, school + university, light + dark against `337:5702`. Measure the light card title, chevron, bar
and track. F2 (empty `[]`) and F4 (error) are probably unreachable on the mock; the walk will say so.

## Wave 07 — walk (2026-09-25)

Owner `WALK`. Pixel 8, fresh mock build. School dark + EN, light + EN, light + AR; university light + EN
(fresh process); offline; search. Full table in `device_walk_results.md`.
- **Score: 100%** on the first walk. F 3/3 (F2 empty and F4 error N/A: the mock has neither path) · V 2/2 ·
  I 2/2.
- **W07-1 verified:** in Arabic the grid card, a Units row and a Mistakes card all draw the chevron pointing
  LEFT, and in English right. KNOWN_BUGS BUG-009 is now DEVICE VERIFIED.
- **W07-2…5 verified** on both tracks: title `#384F47`, chevron `#517066`, bar `#AE87E7` on `#ECECEC`.
- **W07-6 (observation → Wave 08):** Account → Settings → Back → Learn makes the Subjects root draw a dead
  back chip, on both tracks; a fresh entry doesn't. This is the first deterministic repro of the 2026-09-20
  finding.
- Nothing was changed during the walk.

## Wave 08 — Subject tree root — frame re-read + implementation (2026-09-25)

Owner `NEXT`. Frames: Units light `135:815` (row `135:1064`) and dark `337:5894` (row `337:5926`, list pitch
measured off the render); Lectures `180:5354` (Normal), `180:5208` (Midterm), and the dark pair `349:15962`
(Normal) and `337:11059` (Midterm). Chevron and circle SVGs pulled for their strokes.
- **W08-1 — row button semantics (planned):** `TreeListRow` is `MergeSemantics` + `Semantics(button:)` when it
  has an `onTap`; an inert row is merged but gets no flag. Consumed by Waves 09–10 and 16–18 (same row).
- **W08-2 — the dead root back chip (planned; W07-6 repro):** found at SOURCE, and a test now reproduces it.
  `GoRouter.canPop()` is app-wide (root navigator first) and read once in build (`InheritedGoRouter` never
  notifies). A theme change in Settings rebuilds the offstage Learn branch while Settings sits on the root
  navigator, so the chip gets built in and stays. There is NO extra route entry. Fix: `ModalRoute.canPopOf`
  (this route, reactive). KNOWN_BUGS BUG-010.
- **W08-3…5 — frame-proven, the light row did not match:** the chevron is the frame's stroke `#4B675E` (was
  `textPrimary` `#0E0E0E`; dark `#FCFBF9` already matched). The bar and caption are `#AE87E7` on both canvases
  (light was the green theme primary; dark matched). New tokens `treeRowChevron` and `treeRowProgress`, 6 sites
  each. Row gap 16 (was 12) on Units and Lectures, and 25 from the tabs to the first row (was 20). All four
  Lectures frames and both Units frames agree. The bar colour also reaches the school Lessons rows (Wave 10),
  through the same widget.
- **Design questions:** the plan's "no dark Lectures frame" is **withdrawn**: `349:15962` / `337:11059` exist.
  The trailing circle on the Midterm frames is a radio, and the contract takes one `lectureId`. That is
  DESIGN_ISSUES **#94**; built as the Normal frame.
- **RESPONSIVE item 12** (the plan's (4)): added, with **corrected** numbers. With the app's fonts the progress
  row holds at 375 and 411 dp up to 2.0× (`en` + `ar`) and overflows only at 320 dp 2.0× or 250 dp from 1.3×.
  The "7 / 20 px at 1.3×" reproduces exactly with the test font; it was an artefact. The probe was temporary and
  has been deleted.
- **Tests:**
  - `catalog_header_test.dart` (5): the W07-6 repro on both tracks, a fresh root on both tracks, and the chip one
    level down going back. The two repro cases failed on the old header.
  - `tree_list_row_test.dart` (+7): chevron light/dark and bar + caption light/dark (the two light cases failed),
    the Mistakes chevron unchanged, button node / inert node (both failed on the old row; the button case fails
    with the flag removed).
  - `subject_tree_layout_test.dart` (2): Units and Lectures rhythm (both failed).
  - `app_colors_test`: `treeRowProgress` is the same on both canvases.
- **Validation:** format PASS · analyze 0 · **1517 / 0 / 0** · OVERALL PASS.
- **Not changed:** the chevron's shape (Material glyph vs the frame's stroke path); the caption's type (frame
  Cairo 600/11, build `captionSmall` 10/400); the name/digit black `#000` → `textPrimary` (#57 ruling);
  `Lecture.hasFlashcards` unused (#18); search not built (#17); #16; #77.

**Walk plan (on `WALK`):** F1 tree loads on both tracks · F2 track-specific empty copy (the mock may not have an
empty path) · F3 403 scope copy (the same) · F4 offline · V1 Units vs `135:815` · V2 dark vs `337:5894` (plus
dark Lectures vs `349:15962`) · V3 Lectures vs `180:5354` · I1 TalkBack says "button" on a row · I2 no dead chip on
the root after Account → Settings → theme → Back → Learn, on both tracks · I3 tab switch doesn't refetch.
Measure the light row chevron, bar, caption and the row gap.

## Wave 08 — walk (2026-09-25)

Owner `WALK`. Pixel 8, fresh mock build. School dark → light → dark and university dark → light → dark, all
in English; offline; both empty states; a tab-switch recording. Full table in `device_walk_results.md`.
- **Score: 89%** on the first walk. F 3/3 (F3 403 N/A: no deep links on Android, and the mock 403s only for an
  unknown id) · V 3/3 · I 2/3.
- **Verified:** W08-2 / BUG-010 (four repro runs, never a chip); W08-3 light chevron `#4B675E`; W08-4 bar and
  caption `#AE87E7` on `#ECECEC` / `#2E2D32`; W08-5 rows 16.0 apart, tabs → first row 25.1; I3 no reload across
  46 frames.
- **W08-6 (fails I1):** Units rows are `Button` nodes, but Lectures rows are `ProgressBar` nodes. The bar's
  `SemanticsRole.progressBar` merges into the row and decides the Android class. The widget test checked the
  flag, not the role. Candidate fix: exclude the bar's semantics (the caption says it in words) and assert no
  progress-bar role on the merged node. **Not applied**; owner's call.
- Observations: the Subjects cards (Wave 07) are `ProgressBar` nodes too; a one-line Lectures row is 81.9 dp
  vs 78; the dark "crescents" under the tabs did not reproduce.
- Nothing was changed during the walk.

## Wave 08 — W08-6 fix + re-walk (2026-09-25)

Owner: "fix W08-6 in Wave 08 and re-walk".
- **Fix:** `TreeListRow` wraps its bar in `ExcludeSemantics(excluding: caption != null)`, so the merged row keeps
  the button flag and drops the bar's `progressBar` role and range. The caption says the progress in words.
  KNOWN_BUGS BUG-011.
- **Test first:** "a row with a bar is still a button, not a progress bar" failed on the walked build
  (`role: progressBar`) and passes now. Validate format PASS · analyze 0 · **1518 / 0 / 0** · OVERALL PASS.
- **Re-walk: 100%.** Lectures rows are `Button` in dark and light; school Units, Chapters and Lessons rows are
  `Button`; the bar paint is unchanged (re-measured); I2 re-run once more. F2, F4, V1, V2 and I3 carry over, since
  the change is semantics-only.
- **Not changed:** the Subjects grid cards (Wave 07) are still `ProgressBar` nodes, by the same mechanism.

## Wave 09 — Chapters (verify) — frame re-read + implementation (2026-09-25)

Owner `NEXT`. Frames re-read over the Figma MCP: light `135:1270` and dark `337:6047` (`get_metadata`, then
`get_design_context` on one row of each, `135:1302` and `348:7457`; chevron SVGs downloaded to `w09/`).
- **Row paint: no change.** Both frames' rows carry exactly the Wave 08 `TreeListRow` values. Light: fill
  `#FCFBF9`, hairline `#4B675E` 0.5, disc `#F4E6FF`, chevron stroke `#4B675E`. Dark: fill `#27282C`, hairline
  `#FCFBF9`, disc `#27282C` at 20%, name and digit `#FCFBF9`, chevron stroke `#FCFBF9`. Radius 16, padding 16.5, gap
  12, 40 dp disc, 28 dp chevron. The bar (`#AE87E7` on `#ECECEC` / `#2E2D32`) stays undrawn: chapters have no
  counter in the contract (#16).
- **W09-1 (frame-proven, fixed):** the rows sit on a 94 dp pitch in both frames (y 0 / 94 / 188 / 282, height 78),
  so they are 16 apart. The build had 12, as Units did before Wave 08. `chapters_screen.dart` separator → 16.
- **Unknown unit → empty:** the screen already treats an id missing from the cached tree, or a university tree,
  as EMPTY. No test covered it (the navigation tests reach an empty Lessons level only); two now do.
- **Tests (new `chapters_screen_test.dart`, 3):** "the rows sit 16 apart" (failed first: 12.0); "an unknown unit
  id is empty, not an error" (also checks the bare "Chapters" title fallback); "a university tree (no units at
  all) is empty too". The last two pass on the old code, so they document the behaviour and do not fix anything.
- **Validation:** format PASS · analyze 0 · **1521 / 0 / 0** · OVERALL PASS.
- **Not changed, already logged:** title "Cell Biology Chapter" (singular) vs the built "{unit} Chapters" (#14);
  the per-chapter "80%" (#16); search not built (#17). New for #17: the LIGHT frame's placeholder reads "Search
  Chapters", while the dark one still reads "Search Subjects".
- **First-row offset:** the frame's first row sits 25 below the search field, and the search is not built (#17).
  The list's top padding stays 4, as on Units.

**Walk plan (on `WALK`):** F1 rows from the cached tree, no refetch · F2 unknown unit → empty (no deep links on
Android, so likely N/A on device; covered by the widget test) · F3 row → Lessons · V1 vs `135:1270` · V2 dark vs
`337:6047` · I1 AR chevron · I2 row semantics (`Button`). Measure the row gap and the row paint with `treem.py`.

## Wave 09 — walk (2026-09-25)

Owner `WALK`. Pixel 8, fresh mock build, school student. Light EN → dark EN → dark AR, restored to light EN. Full
table in `device_walk_results.md`.
- **Score: 100%** on the first walk. F 2/2 (F2 N/A: no deep links on Android, and every mock unit has chapters) ·
  V 2/2 · I 2/2.
- **Verified:** W09-1 rows 16.0 dp apart; light and dark row paint equal to both frames (fill, hairline, chevron,
  disc, digit, name, dark Glass rim); no skeleton on Chapters in a 20 fps recording (Units shows one for ~200 ms);
  row → Lessons; AR chevrons point left; rows are `Button` in EN and AR.
- A WhatsApp heads-up covered one screenshot. It was deleted and re-shot, and the raw recording was deleted after
  checking.
- Nothing was changed during the walk.

## Wave 10 — Lessons (verify) — frame re-read + implementation (2026-09-25)

Owner `NEXT`. Frames re-read over the Figma MCP: light `135:1485` and dark `337:6143` (`get_metadata`, then
`get_design_context` on one row of each, `308:4769` and `348:7527`; chevron SVGs downloaded to `w10/`).
- **Row paint: no change.** Both frames' rows carry the Wave 08 `TreeListRow` values, bar included. Light: fill
  `#FCFBF9`, hairline `#4B675E`, disc `#F4E6FF`, chevron stroke `#4B675E`, bar `#AE87E7` on `#ECECEC`, caption
  `#AE87E7`. Dark: fill `#27282C`, hairline `#FCFBF9`, disc `#27282C` at 20%, chevron stroke `#FCFBF9`, bar
  `#AE87E7` on `#2E2D32`, caption `#AE87E7`.
- **W10-1 (frame-proven, fixed):** the rows sit on a 94 dp pitch in both frames, so they are 16 apart. The build
  had 12. `lessons_screen.dart` separator → 16. This was the last of the three school levels still at 12.
- **Tests (new `lessons_screen_test.dart`, 2):** "the rows sit 16 apart" failed first (12.0). "every lesson row is
  a button, not a progress bar" puts W08-6 under test on the screen that carries the bar. It passes on this code,
  and it failed with `ExcludeSemantics(excluding: false)` swapped in, a sabotage run that was restored
  byte-identical.
- **Already covered, unchanged:** F1 bar and caption from `questionCounter` ("lessons DO draw a bar…"); F2
  "questionCounter never disables or hides a lesson row" (0/25 and 40/40, the finished one opens setup); F3 "a
  lesson opens /quiz/setup with its id and name".
- **Validation:** format PASS · analyze 0 · **1523 / 0 / 0** · OVERALL PASS.
- **Not changed, already logged:** caption "{a} / {t} questions" vs the frame's "80%" (#16, confirm-only);
  caption type Cairo 600/11 vs `captionSmall` (Wave 08 note); title "Cell Structure lessons" (lower-case) vs
  "{chapter} Lessons" (#14); search not built (#17). New for #17: the light Lessons frame ALSO reads "Search
  Chapters", so the light placeholder is a copy-paste too, not per-level copy.

**Walk plan (on `WALK`):** F1 counters from the server (mock 12/40, 40/40, 0/25; a 0/0 lesson) · F2 every row
tappable, the finished one included · F3 lesson → quiz setup with that lesson's name · V1 vs `135:1485` · V2 dark
vs `337:6143` · I1 AR chevron · I2 rows are `Button`. Measure the row gap, bar, caption and chevron with
`treem.py`.

## Wave 10 — walk (2026-09-26)

Owner `WALK`. Pixel 8, fresh mock build (HEAD `634cc34`, a peer's icon-only commit), school student. Light EN →
dark EN → dark AR, restored to light EN. Full table in `device_walk_results.md`.
- **Score: 100%** on the first walk. F 3/3 · V 2/2 · I 2/2.
- **Verified:** W10-1 rows 16.0 dp apart; light and dark row paint, bar and caption equal to both frames; the bars
  are the server fractions (0.30 / full / empty); the finished 40/40 and the 0/0 lesson both open Quiz Setup under
  their own name; in AR the chevrons point left and the bars fill from the right; rows are `Button` in EN and AR.
- Observation: lesson rows are 81.9 dp (EN) / 83.8 dp (AR) vs the frame's 78, the same as the Wave 08 Lectures
  note. Not investigated.
- Nothing was changed during the walk.

## Wave 11 — Quiz setup (build) — frame re-read + implementation (2026-09-26)

Owner `NEXT`. Frames re-read over the Figma MCP: light `135:1622`, dark `337:6239` (header `146:2287` / `337:6268`,
sizes `146:2322` / `337:6286`), limit `199:2335` and its card `207:5904` (✕ SVG in `w11/`).
- **Owner rulings (asked this wave):** (a) build the subject caption, from the cached subjects list, no endpoint;
  (b) build the limit sheet as the frame draws it, a centred card.
- **W11-1 (owner, built):** "Biology" over "Cell Membrane". `QuizSetupArgs.subjectName` (optional, display only,
  never sent) is filled by Lessons and Lectures from `cachedSubjectName`; null on a cold deep link, and the scope
  then stands alone. Inter 12 → `captionRegular`, `#4B675E` / dark `#FCFBF9` (`quizSetupSubject`). The code comment
  that cited a non-existent DESIGN_ISSUES entry is gone.
- **W11-2 (frame-proven, fixed):** the dark scope is `#FCFBF9` (`337:6272`); the build drew `colorScheme.primary`,
  lavender in dark. New `quizSetupScope` (light `#384F47`, unchanged).
- **W11-3 (frame-proven, fixed):** the dark header rule is `rgba(204,213,210,0.2)` at 0.5 (`337:6268`); the build
  had `#2E2D32` at 1.18, from before the dark frame was read. `quizDivider` dark + new
  `AppElevation.quizSetupDividerWidth` (1.18 / 0.5); props count 86 → 87.
- **W11-4 (owner, built):** `LimitSheet` is now a centred `Dialog` via `showAppDialog` (same scrim; dark still
  null, #74): 345 on 402, radius 22, page fill, 35 dp title row with a 23 dp ✕ at the start edge (tooltip
  "Close"), title `#EF4444` (`limitSheetTitle`; was `#921119`), ✕ `#3F3F3F` / dark `#FCFBF9`
  (`limitSheetClose`), body and "Not now" kept. No CTA, no benefits, no bar (#51, #30). Mid-quiz 403 (Wave 12's
  screen) opens the same card; its caller is unchanged.
- **Closed, no change:** the idle chip carries no stroke in either frame (`146:2315`, `337:6289`), so the build is
  right; the chip fills and labels match both frames.
- **Tests (+11):** header ×5 (subject above scope + light colours; dark `#FCFBF9` ×2; light rule; dark rule; AR
  order), limit card ×6 (centred card not sheet; title + ✕ paint and order; ✕ labelled and dismisses; "Not now";
  AR ✕ on the right; dark fill and ✕). 11 failed first; the card tests were re-proven against the old sheet (5 of
  6 fail, "Not now" passes) and the file restored byte-identical. Hand-off tests now assert `subjectName`
  "Biology" for a lesson and a lecture.
- **Validation:** format PASS · analyze 0 · **1534 / 0 / 0** · OVERALL PASS.
- **Not changed, recorded:** the second chip is 176 wide in all three frames (the others 171), so the first row
  spans the full 363; the build keeps 171 (owner/designer call). Subject line-height 18 in the frame vs 16 in
  `captionRegular`; the dark header's bottom padding is 12.5 vs 13.18 light. Limit title Inter 600/22 → h2, and the
  card's 59/16 vertical padding → the dialog rhythm (#51). Still open: pool card + points preview (#31), nav bar
  (#35), dark scrim (#74), copy (#51).

**Walk plan (on `WALK`):** F1 createQuiz body (lesson + length, via the mock) · F2 422 inline (a `0 / 0` lesson) ·
F3 403 → card (two 30s, or الكيمياء for `subscription_required`) · F4 `insufficient_scope` inline · F5 offline
disables Start · V1 vs `135:1622` (subject caption, scope, rule, chips) · V2 card vs `199:2335` · V3 dark vs
`337:6239` · I1 chip selected state + semantics · I2 ✕ dismisses (and "Not now"). AR + EN; both tracks for the
caption.

## Wave 11 — walk (2026-09-26)

Owner `WALK`. Pixel 8, fresh mock build, school student (university for the caption). Light EN → dark EN → dark
AR, restored to light EN on Home. Full table in `device_walk_results.md`.
- **Score: 78%** on the first walk. F 3/4 (F4 N/A: no mock trigger) · V 2/3 · I 2/2.
- **Verified:** W11-1 subject over scope on both tracks and in AR; W11-2 dark scope `#FCFBF9`; W11-3 dark rule;
  W11-4 centred card (354.3 dp, radius 22, `#EF4444` title, `#3F3F3F` ✕, 50% scrim) with both codes; 422 inline;
  offline; chip `selected` state moves; ✕ and "Not now" dismiss; AR ✕ on the right.
- **W11-5 (V2 fails):** the ✕ glyph sits 35.4 dp in from the card edge (frame 27.8) and spans 13.3 dp (frame
  15.3). Cause: `IconButton`'s 48 dp padded tap target, and `Icons.close` drawn smaller than `akar-icons:cross`.
  The Profile dialog's ✕ likely shares it.
- **W11-6 (F3 fails):** a second 403 from the error state stacks two cards (scrim `#636363` vs `#969695`; two taps
  to dismiss). Cause (inferred from source): the listener opens the card on the loading state, which carries the
  previous error. Pre-existing; untested because the tests trip once.
- Nothing was changed during the walk.

## Wave 11 — fixes (2026-09-26)

Owner: "fix W11-5 and W11-6 in Wave 11 and re-walk".
- **W11-5:** the ✕ is the frame's own `akar-icons:cross` (new `assets/icons/close_cross.svg`, `currentColor`
  stroke 2.08, round caps, tinted by `limitSheetClose`) at 23 dp. Its button is a real 48 × 48 target centred on
  the frame's box: the title row is inset 11.5 and 48 tall, so the glyph box sits 24 from the card's start edge
  with the same centre line (top padding 13.5 = 20 − 6.5; gap below 5.5 = 12 − 6.5). The body and "Not now" keep
  the 18 inset.
- **W11-6:** `_onCreationChanged` returns on `next.isLoading`. KNOWN_BUGS BUG-012.
- **Tests (+3):** ✕ box 23 × 23 at 24 from the card edge, target 48 × 48 on the same centre, centre 37.5 below the
  top; AR mirror (24 from the right); a second 403 opens ONE card. The glyph tests moved from `Icon` to the SVG
  asset + colour filter. All red first (the second-403 test found 2 cards).
- **Validation:** format PASS · analyze 0 · **1537 / 0 / 0** · OVERALL PASS.
- **Not changed:** the Profile dialog's ✕ has the same 48 dp-target offset (seen on the Logout confirm); that is
  the Profile screen's wave.

## Wave 11 — re-walk (2026-09-26)

Owner `WALK` (after reconnecting the phone). Fresh build with the fixes. Dark EN → light EN → light AR, restored to
light EN on Home. Table in `device_walk_results.md`.
- **Score: 100%** (F 4/4, F4 N/A · V 3/3 · I 2/2). F3 and V2 now pass; the other eight stand from the first walk.
- **W11-6 verified:** a second 403 opens one card (dark captures byte-identical; light scrim `#969695` both times).
- **W11-5 verified:** the frame's cross, 17.5 dp of ink at 26.7 dp from the card edge (frame 17.4 / 26.8), 48 dp
  target, mirrored in AR.
- **W11-7 (new, regression from the W11-5 fix):** the ✕ reads as `ImageView`, not `Button`: `SvgPicture` adds
  `Semantics(image: true)` and it merges into the button. The likely fix is one line, `excludeFromSemantics: true`
  on the glyph (the tooltip already labels the button), plus a semantics test. Not fixed: the walk changes nothing.
- Nothing was changed during the re-walk.

## Wave 11 — W11-7 fix and re-walk (2026-09-26)

Owner: "fix W11-7 in Wave 11 and re-walk".
- **Fix:** `excludeFromSemantics: true` on the ✕'s `SvgPicture` in `limit_sheet.dart`. The IconButton's tooltip
  already names it, so nothing is lost. Same pattern as the quiz screen's chevron.
- **Test (+1):** "TalkBack reads the ✕ as a button, not an image" (`isButton`, `isImage: false`, tooltip "Close",
  tap). Red first on the old code with `unexpected flags: isImage`.
- **Validation:** format PASS · analyze 0 · **1538 / 0 / 0** · OVERALL PASS.
- **Device:** the ✕ is `android.widget.Button` ("Close" / "إغلاق"), 48 dp, glyph 17.5 dp at 26.7 dp from the edge,
  one tap closes. Light EN and dark AR. Restored to light EN on Home. `device_walk_results.md`.
- **Not changed:** the back chip and nav tabs read as `ImageView` for the same reason; they belong to their own
  screens' waves.

## Wave 12 — implementation (2026-09-26)

Owner `NEXT`. Frames re-read with `get_design_context`: header `159:1224` / dark `337:9202`, question card `159:1254` /
dark `348:7662`, AI panel `159:1811` / dark `337:9271`, photo column `216:3012`.

**Owner rulings (AskUserQuestion, 2026-09-26):**
1. **Explanation `403 subscription_required` → build the contract's popup, verbatim** (`openapi.yaml` getExplanation
   403): EN "AI explanations are available with a Level Up subscription. Subscribe to get step-by-step explanations
   and more learning features." AR (owner-approved draft): "شروحات الذكاء الاصطناعي متاحة مع اشتراك Level Up. اشترك
   لتحصل على شروحات خطوة بخطوة ومزايا تعليمية أخرى." On the limit card (title "Subscription Required", ✕, "Not now");
   no price, link or buy button.
2. **Header AI "sparkle-cap" icon → leave it out, log it** (DESIGN_ISSUES #95): the frame shows it before grading,
   which the contract forbids; after grading it duplicates "Show explanation".
3. **Question photo → whole image, no crop**; moved above the question card with the frame's 22 gaps, radius 17 and
   hairline.

**Done:**
- **W12-1** the ✕ is the frame's own cross (new `assets/icons/quiz_close.svg`, 30 dp, stroke 1.67, round caps,
  `quizHeaderGlyph` `#384F47` / `#FCFBF9`), a button named "Close" / "إغلاق" (framework `closeButtonTooltip`), with
  a 48 dp target centred on the frame's box 16 in and 16 down; `excludeFromSemantics` on the glyph (the W11-7
  lesson). It was a bare `Icons.close` with no name, `#0E0E0E` in light.
- The header is now the frame's container (`_Header`), not an `AppBar`: 89.18 tall, title on the centre line.
- **W12-2** `409 quiz_already_finished` shows its copy without Retry (`suppressesRetry`).
- **W12-3** the panel glyph is `assets/icons/ai_education.svg` (was `Icons.school_outlined`); **W12-4** dark panel
  glyph + title `#FCFBF9` (`aiPanelTitle`; they took the lavender primary).
- **W12-5** explanation `403 subscription_required` → the contract's popup on the limit card
  (`LimitSheet.showExplanation`), EN verbatim + owner-approved AR; new `ExplanationSubscriptionRequired` state; the
  popup opens on the Pending → subscription-required transition only; the button stays and a re-tap asks the
  server again.
- **W12-6** the photo is above the question card, 22 apart, radius 17 with the card's hairline, whole image
  (`BoxFit.fitWidth`); loading and error hold 189.
- **W12-7** header rule `rgba(124,58,237,0.1)` at 1.18; **W12-8** progress fill `#AE87E7` on both canvases (light
  was the green primary); **W12-9** counter `#7070A0` (was `#B3B3B3`); **W12-10** light question text `#384F47`
  (was `#0E0E0E`); **W12-11** gaps header→content 25 (was 20), label→question 10 (was 8), card→options 22 (was 25).
- **Tokens (6):** `quizHeaderGlyph`, `quizHeaderRule`, `quizProgressFill`, `quizProgressCounter`,
  `quizQuestionText`, `aiPanelTitle`. **ARB:** `explanationSubscriptionRequired` (EN + AR).
- **Tests (+20):** 15 screen, 2 panel, 2 bloc, 1 predicate. Red first on behaviour; the bloc and panel tests that
  name the new state were red by compile, then the mapping test and both panel glyph tests red on behaviour.
  Guards (green from the start, by design): no header AI icon, dark question text, the 409 is sent once.
  Consequential: the exit tests open the ✕ by key; six pill tests find the chevron by asset (the ✕ is an SVG
  now).
- **Validation:** format PASS · analyze 0 · **1558 / 0 / 0** · OVERALL PASS. Golden `ai_panel_dark.png` regenerated: the diff was the glyph and the
  lavender → cream title, exactly W12-3/4.
- **Docs:** DESIGN_ISSUES #95 (header AI icon), #96 (whole photo), #51 update; DECISIONS D-015.
- **Walk notes:** the mock has no trigger for a mid-quiz `409` (F3) or an explanation `403 subscription_required`
  (F5). Unless the owner wants mock triggers (as Wave 02's `999999`), both score N/A on the walk. Every fourth
  mock question has a `picsum.photos` image, so V3 needs the network. Screenshots need the local-only
  FLAG_SECURE override in `lib/main_mock.dart`, reverted after.

## Wave 12 — walk (2026-09-26)

Owner "WALK 12 & 13". Pixel 8, fresh mock build with Wave 12 (walk-only FLAG_SECURE override applied for the build,
source restored byte-identical before install). School student; light EN, then a second quiz in dark AR.
- **Score: 100%** (F 3/3 · V 4/4 · I 2/2). N/A: F2 (the in-process mock cannot fail a submit), F3 and F5 (no mock
  trigger).
- **Verified:** W12-1 ✕ (`#384F47` / `#FCFBF9`, 48 dp `Button`, mirrored), W12-3/4 panel glyph and title, W12-6
  photo above the card (24.8 / 21.7 dp), W12-7 rule, W12-8 bar, W12-9 counter, W12-10 text, W12-11 gaps; exit guard;
  explanation 202 → text. Nothing new found.

## Wave 13 — baseline walk (2026-09-26)

Same walk, before Wave 13's build. **44%** (F 3/3 · V 0/4 · I 1/2). Fails: V1 ring (`#384F47`, frame lavender),
V2 one-run points line + `#7070A0` "REWARDS EARNED", V3 no CTA icon, V4 the same in dark, I1 "+2 نقطة" paints
"2+" (device-proven by glyph position). Also seen: no subtitle subject, no header rule, title `#0E0E0E`, a "Back to
Learn" link the frames lack, and the back chip reads as `ImageView` (shared `CircleBackButton`).

## Wave 13 — implementation (2026-09-26)

Owner `NEXT`. Frames: light `159:1964`, light university `309:6375`, dark `337:6628`, dark university `349:14522`
(the two university frames equal the school ones value for value). Read with `get_design_context` plus the ring,
star and CTA-icon SVG exports; a read-only Sonnet workflow compared all four to the code (64 divergences survived
its skeptic pass; `scratchpad/w13/compare_result.json`).

**Owner rulings (AskUserQuestion, 2026-09-26):**
1. **"Back to Learn" link → remove it.** No frame draws it; the back chip and system Back already go to Learn.
2. **Ring direction → as drawn, both languages:** anticlockwise from 12 o'clock in EN and AR.
3. **Back chip semantics → fix now** in the shared `CircleBackButton` (every screen with the chip).
4. **Ring figure 64 ExtraBold → keep the scale's 28, log it** for the designer.

**Planned (frame-proven unless marked):** W13-1 subtitle "Subject — Scope" (Wave 11's ruling carried through
setup → quiz → result, display only), `#4B675E` / dark `#EEEEEE`; W13-2 the frame's header block (title + subtitle,
chip centred on it, rule rgba(124,58,237,0.1) 1.18, 92 tall), title `#384F47` / `#FCFBF9`; W13-3 gaps 18.18 / 25 /
25 / 25; W13-4 ring 192, stroke 9.85, round caps, anticlockwise (ruling 2), radial gradient `#AE87E7` → `#7070A0`
on both canvases, figure `#3D3D3D` light; W13-5 buckets: padding 12, gaps 8 / 8, badge 28 + glyph 14, label `h3`
`#384F47`; W13-6 rewards: title `bodyMedium` `#AE87E7`, the frame's star `#7070A0` 19.44, gap 10, two runs ("+N"
bold `#AE87E7` LTR-isolated = BUG-003; "Points" regular `#010101` / `#FCFBF9`); W13-7 CTA leading `ai_education`
26.55, gap 10; W13-8 "Back to Learn" removed (ruling 1); W13-9 back chip → `Button` (ruling 3).
**Not changed (recorded):** type sizes outside the scale (figure 64, number 22 Cairo, "+N"/"Points" 19.45, CTA 22),
the shadows' drop-shadow export (blur halves in CSS; tokens stand), "Pass" (S13), the level meter (D-006), the
Skipped bucket (#29), the nav bar (#35).

**Done:**
- **W13-1** subtitle "Subject — Scope" (`quizResultSubtitle`, EN + AR): setup pushes `QuizScreenArgs(quiz,
  subjectName)`, the router takes it (a bare `Quiz` still opens the screen), the quiz hands `subjectName` to
  `QuizResultArgs`. Display only; `Quiz` / `QuizSummary` unchanged. Null subject → the scope alone.
- **W13-2** the result's own `_Header` (not `TitledChrome`): title `h2` `#384F47` / `#FCFBF9`, subtitle `bodyMedium`
  `#4B675E` / `#EEEEEE`, chip 21 in and centred on a 52 floor, rule `quizHeaderRule` 1.18, 92 tall at scale 1.
- **W13-3** gaps: rule → ring 18.18, then 25 / 25 / 25 (were 8 + scope + 24s).
- **W13-4** `ResultRingPainter`: 192 outer, stroke 9.846, round caps, the export's radial gradient (its own
  transform, scaled), anticlockwise in both languages; figure `#3D3D3D` / `#FCFBF9`, size unchanged (#97). Was a
  clockwise `CircularProgressIndicator` in `colorScheme.primary`.
- **W13-5** buckets: padding 12, badge 28 + glyph 14, gaps 8 / 8, label `h3` `#384F47` / `#FCFBF9`.
- **W13-6** rewards: inset 13 / 15, title `bodyMedium` `#AE87E7`, title → row 16, the frame's star
  (`assets/icons/result_star.svg`, path identical to the export) `#7070A0` 19.44, disc → text 10, two runs 10
  apart: "+N" `h2` `#AE87E7` painted LTR (BUG-003 fixed) and "Points" `bodyLarge` `#010101` / `#FCFBF9`; one
  merged TalkBack label "+N Points".
- **W13-7** CTA leads with `ai_education.svg` 26.55 in `onPrimary` (`#FCFBF9` both), gap 10.
- **W13-8** "Back to Learn" removed (the key stays: the unavailable-quiz screen uses it).
- **W13-9** `CircleBackButton` chevron `excludeFromSemantics` (KNOWN_BUGS BUG-013; every screen with the chip).
- **Tokens (10):** `quizResultTitle`, `quizResultSubtitle`, `resultRingFillFrom`, `resultRingFillTo`,
  `resultPercentText`, `resultBucketLabel`, `resultRewardsTitle`, `resultStarGlyph`, `resultPointsValue`,
  `resultPointsUnit`. **ARB (3):** `pointsAwardedValue`, `pointsAwardedUnit`, `quizResultSubtitle`.
- **Tests (+18):** 16 result (17 in the Wave 13 group; "with no subject, the scope stands alone" replaced the old
  "subject line is absent"), 1 quiz (subject reaches the result), 1 setup (subject handed on); the shared-chrome
  chip test now asserts `isImage: false`. **Red proof:** the new result tests run against the OLD screen (with a
  compile stub): 16 of 17 fail on behaviour (the dark bucket label was already cream: a guard), plus the three
  existing tests changed for the runs and the star. Mutations: removing the LTR line fails the AR "+3" test (`+` at
  x 19.8); dropping the subject at setup or at finish fails each hand-off test. The chip test failed first with
  `unexpected flags: isImage`.
- **Caught in validation:** the first run failed 11 tests + 2 goldens on Home / Top Student / Profile: the new key
  was first named `pointsValue`, which already existed; JSON keeps the last duplicate, so Home drew "+990". Renamed;
  both ARBs checked for duplicates (none). Memory saved. The failure goldens were deleted.
- **Validation:** format PASS · analyze 0 · **1576 / 0 / 0** · OVERALL PASS. Ring render checked at 20 / 50 / 90% against the frame's 50% (scratchpad
  `w13/ring_compare.png`).
- **Review:** read-only Sonnet workflow, three lenses (correctness / RTL / a11y; frame fidelity; scope, safety, test
  quality) + skeptic stage: **0 findings**.
- **Docs:** DESIGN_ISSUES #97; KNOWN_BUGS BUG-003 (quiz half fixed, device owed), BUG-013; DECISIONS D-016 and a
  D-001 update; seif_fight S19 dated note.
- **Re-walk notes:** V1–V4 and I1 should now pass; I2 also checks the chip is a `Button`. Check the 3-bucket row at
  text scale 1.3 on the phone (the `h3` labels are larger now; they wrap, they cannot overflow).

## Wave 13 — re-walk (2026-09-26)

Owner "WALK 13". Pixel 8, fresh mock build with Wave 13 (walk-only FLAG_SECURE override applied for the build, source
restored byte-identical before install). School student; light EN, then a second quiz in dark AR.
- **Score: 100%** (F 3/3 · V 4/4 · I 2/2), baseline 44%.
- **Verified:** W13-1 subtitle "الأحياء — الدرس الأول"; W13-2 header (title, subtitle, rule, 92.2 dp, chip 21 in);
  W13-3 gaps 17.9 / 24.8 / 24.8 / 24.8 dp; W13-4 ring (192 dp, stroke 9.9, the gradient, anticlockwise in EN and
  AR); W13-5 labels; W13-6 rewards (title, star, two runs, one TalkBack node); W13-7 CTA glyph; W13-8 no "Back to
  Learn"; W13-9 chip is a `Button` (and on OTP, Review, Settings, Setup, the catalog).
- **BUG-003** quiz half and **BUG-013**: device-verified (KNOWN_BUGS updated).
- **Not run:** text scale 1.3 on the phone (needs the system font setting; the screen test covers 1.0–3.0 with three
  buckets).
- **Wave 14 lead:** Review rows' TalkBack labels carry the stem's raw `<u>…</u>` markup; the Arabic stem truncates
  at its start in English.

## Wave 14 — implementation (in progress, 2026-09-26)

Owner `NEXT`. Frames: light `162:2377`, dark `337:6705`, RTL `549:20324`. Leads carried in: the Wave 13 re-walk saw
each review row's TalkBack label carry the stem's raw `<u>…</u>` markup, and the Arabic stem truncate at its start
in English; the plan's MISSING item is a row test at text scale 1.30. Frame read + code compare first; findings,
rulings and the Done list land here.

**Compare (frames via the Figma MCP; the device capture `walk13b/02_review.png`, light EN, from the Wave 13 re-walk;
code `quiz_review_screen.dart`).** Frame-proven, to build:
- **Header** (`162:2405`): 63 tall with a 1.18 rule rgba(124,58,237,0.1) (`quizHeaderRule`), chip 21 in, centred
  32.1 down; title Inter Bold 22 `#000000` / `#FCFBF9`. Build: the shared `TitledChrome` (59 tall, no rule, chip 20
  in, `#0E0E0E`). `TitledChrome` is shared with Settings and the shells, so the review gets its own header.
- **Chips** (`162:2787`): gap 8 (build 10); rule → pills 25 (build 19.8 below the bar); pills → first row 14.18
  (build 24). "Correct" leads with a 16 `#22C55E` disc and a white tick, "Wrong" with a 16 `#EF4444` disc and a white
  ✕ (build: a 10 dot, a bare red ✕). Idle label `#384F47` in light (build `#0E0E0E`); dark `#FCFBF9` matches.
- **Rows** (`162:2511`): gap 19 (build 12). Badge 9 from the edge (build 12), text 3.5 after it (build 12), text
  column to 5.8 from the end. Badge ring = the badge colour (build: the row's border colour, a dark ring).
  "QUESTION n" `#4B675E` light (build `#384F47` correct / `#0E0E0E` wrong), `#AE87E7` dark (build cream). Question
  `#384F47` on BOTH rows in light (build `#0E0E0E` on wrong). Label and question lines sit 4.4 apart with the block
  2.3 below centre (the frame's 18 / 7 / 25.6 lines on the scale's 16 / 24). AI glyph `#384F47` / `#FCFBF9` at the
  TOP-END corner, 10.8 down and 10.5 in, over the text column (build: centred, in the row, taking width, `#0E0E0E`
  on light wrong rows).
- **Contract:** `QuizQuestion.text` is "Plain text; only <u>…</u> markup allowed" (`openapi.yaml:2703`, and :105).
  The app draws the tags (quiz page and review) and TalkBack reads them. DESIGN_ISSUES #88 asked exactly this; the
  contract answers it.
- **Device defect:** an Arabic stem truncated in the English UI puts the ellipsis before "السؤال" and cuts the end
  mid-word (`02`): the stem is laid out as an LTR paragraph.
- **Kept (ruled or designer-owed):** #52 wrong hue, #53 Glass, #54 selected dark chip label `#232428`, #55 skipped
  row, #56 glyph non-interactive, #57 nearest type styles, #58 mirrored rows; the nav bar is outside this route.

**Rulings (2026-09-27, AskUserQuestion):** question markup → **both screens** (one shared widget); dark "QUESTION n"
→ **keep cream, log it**.

**Done:**
- **W14-1** `QuestionStemText` (`lib/features/quiz/widgets/question_stem_text.dart`), on the quiz page
  (`mcq_renderer.dart`) and each review row: `<u>…</u>` drawn as an underline, the tags never drawn or read by
  TalkBack; the paragraph takes the stem's first strong direction (fallback: the app's), alignment stays the app's
  start. DESIGN_ISSUES #88 closed; KNOWN_BUGS BUG-014; DECISIONS D-017.
- **W14-2** the review's own header (not the shared `TitledChrome`): 63 with the 1.18 `quizHeaderRule`, chip 21 in and
  centred 32.09 down, title `quizReviewTitle` (`#000000` / `#FCFBF9`).
- **W14-3** chips 8 apart, pills 25 under the rule and 14.18 over the first row; **pills really 32 tall** (an
  `alignment` on the pill's Container filled the 48 tap target: the device drew 48-dp pills).
- **W14-4** "Correct" / "Wrong" lead with 16 discs (`successBadge` + an 8 tick, `quizWrongBadge` + a 14 ✕, cream);
  idle label `reviewFilterIdleLabel` (`#384F47` / `#FCFBF9`).
- **W14-5** rows 19 apart; badge 9 in, text 3.5 after it, text column to 5.82 from the end; the badge ring is its own
  fill (was the row's stroke, a dark ring).
- **W14-6** "QUESTION n" `reviewRowLabel` (`#4B675E`; dark cream by ruling); the question `quizReviewRowContent` on
  every row (the wrong row was `#0E0E0E`); lines at 16.56 and 37.0 from the row top (4.44 apart).
- **W14-7** AI glyph over the text's top-end corner, 10.83 down and 10.64 in, drawn 26.36 × 24.41 in the question's
  colour (was centred beside the text, taking width, 28.67 × 26.55, `#0E0E0E` on light wrong rows).
- **W14-8** text scale 1.30 and 1.35: the row grows to 81 / 83 around its lines (the plan's MISSING test).
- **W14-9** new DESIGN_ISSUES #98 (not fixed, owner decision): the same glyph on the quiz panel and the result CTA
  draws 28.67 × 26.55 because `vector_graphics` derives width from height.
- **Tokens (3):** `quizReviewTitle`, `reviewFilterIdleLabel`, `reviewRowLabel`.
- **Tests (+33):** `question_stem_text_test.dart` 15 (9 parser, 6 widget), review 16 (the "Wave 14" group), quiz page
  2; 5 existing review tests updated (the chips' own tick in the icon counts; the label and wrong-row tokens).
  **Red proof:** against the old screens with a stub widget, 32 fail; the passes are guards (plain text, no tag,
  empty stem, no-letter stem, the dark label staying cream). Mutations: the pill's `alignment` back → the chip test
  fails (pill 48, 17 under the rule); the direction logic off → four direction tests fail.
- **Validation:** format PASS · analyze 0 · **1609 / 0 / 0** · OVERALL PASS.
- **Review:** read-only Sonnet review: frame-fidelity lens 1 finding (label line 4.36 low), refuted by the frame's own render ("QUESTION 1" ink centred 24.32 below the row top; the build's line centre 24.56; the finding's model 20.2); correctness lens (reported after the walk) 0 findings: parser and Bidi hand-traced against intl 0.20.2, scope and guards (105/105), the three test files green; one coverage note, the chip disc glyph colour is tested in light only.
- **Docs:** DESIGN_ISSUES #54 (update), #88 (resolved), #98 (new); KNOWN_BUGS BUG-014; DECISIONS D-017.
- **Walk notes:** F1 filters; F2 skipped rows neutral (the mock answers every question with qloop; skip one to see
  it); F3 FLAG_SECURE on/off (the walk build overrides it, so F3 is checked by the black-screencap tell on a normal
  build or stays test-covered); V1 light, V2 dark, V3 RTL; I1 chips 48 dp; I2 back labelled. Also: the underline on
  the quiz page and review, and the Arabic stem's truncation in English.

## Wave 14 — walk (2026-09-27)

Owner "WALK 14". Pixel 8; build 1 with the walk-only FLAG_SECURE override (source restored byte-identical), build 2
without it for F3. Light EN, dark AR, and F3 in dark AR.
- **Score: 100%** (F 2/2, F2 N/A: the quiz UI cannot skip · V 3/3 · I 2/2).
- **Verified:** W14-2 header (62.9, rule), W14-3 pills 32 (were 48), 25.1 / 8 / 14.1, W14-4 discs 16, W14-5 rows 19,
  badge 8.8 in, W14-6 colours, W14-7 glyph 24.4 × 23.2 at the top-end, dark tokens, RTL mirroring, chips 48-dp
  Buttons, FLAG_SECURE on for Review only; **BUG-014 device-verified** (the Arabic stem ellipsizes at its own end; no
  tags in any label).
- **New: W14-10**, the underline does not show on Arabic stems: Tajawal Medium / Bold declare a 0.003-em underline at
  the baseline (0.14 px at the stem's size). English and Tajawal Regular underline normally. Needs an owner decision.
- **Observation:** Arabic lines lay out taller than the scale (mixed Inter + Tajawal metrics): light rows keep 73 with
  the text 1.9 dp high; dark AR rows are 76.2. App-wide.
- **Review:** the correctness lens reported after the walk: 0 findings (one coverage note: the chip disc glyph colour is tested in light only).

## Wave 15 — implementation (in progress, 2026-09-27)

Owner `NEXT`. Frames: light `404:6292`, dark `404:7428`. Plan items carried in: `MistakesSubjectCard` button semantics
(mirror `_MistakesButton`); BUG-002, Arabic overflow at 1.3× / 2.0×; the refresh-after-quiz gap stays documented
(`mistakes_notifiers.dart:39-56`) unless the owner asks. Frame read + code compare first; findings, rulings and the
Done list land here.

**Compare (2026-09-27):** frames read over the MCP (metadata, design context, 1× renders in the scratchpad `w15/`),
plus a real-font render of the build (a throwaway probe test, deleted). Three read-only Sonnet lenses (light, dark,
a11y / overflow / states) agreed on the findings below; the dark palette matched in full. One lens claim was refuted:
the Subjects card's frame (`135:626`) puts its small chevron on the title's line, so the Mistakes card's large
card-centred chevron is not a shared defect.

**Rulings:** none needed. The BUG-002 approach (the card grows) is the only in-screen option that invents nothing
(D-018); the owner can override it at the walk.

**Done:**
- **W15-1** the card is ONE button to TalkBack: `MergeSemantics` + `Semantics(button: true)`, the sibling
  `_MistakesButton`'s fix (was two texts with a tap action and no button flag).
- **W15-2** the list starts **25** under the header (`404:6475` ends at 99.44, `404:6312` starts at 124.44; was 16),
  and the skeleton sits where the cards will (89 tall, 18 / 16.5 apart).
- **W15-3** the chevron is the frame's `weui:arrow-filled` (the shared `chevron.svg`) stretched into the frame's
  **13 × 27** box, 12 from the card's end and centred on the CARD 0.44 high; new token `mistakesCardChevron`
  (`#517066` light, `404:6533`; `#FCFBF9` dark, `404:7651`). It was Material's `chevron_right` at 16 (a 4.9 × 8
  glyph) on the title's line in `#384F47`. Flipped in Arabic; excluded from semantics.
- **W15-4** title and count sit at the frame's line centres, **34.16** and **61.78** below the card's top (a centred
  block had the title 3.7 high); the text stops at the chevron's box (25 from the end). Real-font render against
  the frame's: title ink top 27.33 vs 27.56, count 56.0 vs 56.56, chevron 37.0–51.0 vs 37.56–50.56.
- **W15-5 (BUG-002)** the card grows with its text (89 is its floor) and a row takes its taller card: the grid is a
  list of `IntrinsicHeight` two-card rows (D-018). Real fonts: 89 in English at 1.0, 90–91 in Arabic (Tajawal's
  taller lines), 101–103 at 1.3, 131–132 at 2.0, no overflow. The Subjects grid still overflows (its own screen).
- **Logged, not fixed:** DESIGN_ISSUES **#99**, the shared catalog header's title (frame Inter SemiBold 22 `#000000`,
  build `h2` 20/700 `#0E0E0E`); five screens share it. The refresh-after-quiz gap stays documented
  (`mistakes_notifiers.dart:39-56`), per the plan.
- **Token (1):** `mistakesCardChevron`.
- **Tests (+11):** the "Wave 15" group in `mistakes_screens_test.dart` (grid gap and spacing, skeleton, chevron box /
  asset / fill / colour, dark chevron, line centres and text end, Arabic mirror and flip, one button to TalkBack,
  BUG-002 in English and Arabic at 1.3 and 2.0 with an Arabic subject name); `drill_in_chevron_test.dart` now reads
  an SVG chevron's direction from its flips; `app_colors_test.dart` pins the token. **Red proof:** against the old
  screen all 11 new tests fail, each on its defect (gap 16, no chevron box, title line 30.44, no button flag, cards
  88.87, overflow 27 at 2.0); the chevron-direction guard passes on both.
- **Validation:** format PASS · analyze 0 · **1620 / 0 / 0** · OVERALL PASS.
- **Review:** read-only Sonnet review, two lenses: correctness 0 findings (its runs: mistakes 30/30, chevron + colours 38/38, analyze clean); frame and scope 1 finding (the chevron glyph 4% narrow), refuted: it took the arrow tip as x 12.70, but `chevron.svg`'s tip is its curve endpoint at x 13.06, which stretches to 11.32, the frame path's own tip (glyph 7.98 × 14.32, as drawn in the frame); guards 105/105.
- **Docs:** DESIGN_ISSUES #68 (update), #99 (new); DECISIONS D-018; KNOWN_BUGS BUG-002 (Mistakes overview fixed,
  Subjects grid still open).
- **Walk notes:** F1 cards in server order; F2 empty is the happy-path copy (needs an empty mock response); F3
  error / retry; F4 offline (airplane mode); V1 light vs `404:6292`; V2 dark vs `404:7428`; I1 a card is ONE
  `Button` in uiautomator; I2 no overflow in Arabic at 1.3 (needs the system font scale, which is the owner's to
  change; otherwise N/A and test-covered); I3 the Arabic chevron points left from the card's left edge.

## Wave 15 — walk (2026-09-27)

Owner "WALK15". Pixel 8; a plain `flutter build apk --debug -t lib/main_mock.dart` (the Mistakes screens set no
FLAG_SECURE, so no override; `main_mock.dart` untouched, blob `f189786`). School student via OTP `000000`, Learn →
Mistakes. Light EN, offline, dark EN, dark AR; restored to light EN on Home.
- **Score: 100%** on the first walk (F 2/2, F2 + F3 N/A · V 2/2 · I 2/2, I2 N/A). F2 and F3 are N/A: the mock answers in-process and has
  neither an empty overview nor an error trigger for `GET /me/mistakes` (both test-covered). I2 is N/A: 1.3× needs
  the system font scale, which is the owner's to change; Arabic at 1.0 shows no overflow and the log has none.
- **Verified:** W15-1 every card is one `Button` with a merged "name / count" label (EN and AR); W15-2 cards 25.14
  under the header; W15-3 chevron ink 7.6–8.0 × 14.1 at 36.95 from the card's top and 13.71 from its end (frame
  7.98 × 14.32, 37.56, 13.68), `#517066` light, cream dark, pointing left 13.71 from the left edge in Arabic; W15-4
  count ink top 56.00 (frame 56.56), text 9.5 in; fill `#EAD5D5`, title `#384F47`, count `#EF4444`; rows 17.9 apart,
  columns 16.76 (pixel-rounded 16.5), margins 20.2 / 19.8. Dark: page `#232428` (frame same), card `#242529` (frame
  `#252529`), the glass rim's top edge `#616265` (frame `#4F5054`, the known rim-brightness item).
- **New: W15-6.** In English, single-word Arabic names give 89.14-dp rows, but the row with "اللغة العربية" is
  92.95, and its card's text sits about 4 dp lower than its neighbour's. In Arabic the rows are 91.8–92.2 (the count
  lines "خطأ واحد", "7 أخطاء" mix scripts too) and 96.0 for that row. D-018 estimated 90–91 in Arabic; the device
  says 92–96. Likely cause (inferred, not probed): the space between the words is drawn in Inter, the primary font,
  so the line mixes Inter's ascent with Tajawal's descent, as the Wave 14 walk measured. Nothing overflows; the card
  grows as D-018 allows. Needs an owner decision: accept, pin the card's lines to the scale's line height on this
  screen, or fix the mixed-font line height app-wide in its own wave.
- **BUG-002:** device-verified at 1.0 only; 1.3 and 2.0 rest on the tests until the owner raises the font scale.
- Nothing was changed during the walk.

## Wave 15 — second walk (2026-09-27)

Owner `WALK` again, with nothing changed since the first walk (same build, `main_mock.dart` blob `f189786`, the
phone's font scale still 1.0). So this walk covered what the first did not: the university track (OTP `111111`),
light EN and light AR. **Score stands at 100%** (the same six pass, the same three N/A).
- **Verified:** the university list in server order (التشريح 3 · الفسيولوجي 1 · الكيمياء الحيوية 12 · الأنسجة 2),
  every card one `Button`, the same geometry as the school list (25.14 under the header, 89.14 rows, chevron 13.71
  from the end, `#517066`); light AR mirrored with the chevron `#517066` pointing left 13.71 from the left edge; no
  overflow in the log.
- **W15-6 reproduced** with a second two-word name: "الكيمياء الحيوية" gives a 92.95 row in English (text 3.8–4.2
  lower) and 96.00 in Arabic; its one-word neighbour row is 89.14 in English. The same +3.8 as "اللغة العربية".
- Tapping الأنسجة opens an empty tree: the mock's deliberate race fixture (`mock_backend.dart`, "uni-histology absent
  -> empty tree, same purpose as sub-arabic"), Wave 16's empty state, not a defect.
- Nothing was changed during the walk. Restored to light EN on Home, signed in as the university student.

## Wave 16 — implementation (in progress, 2026-09-27)

Owner `NEXT`. Frames: school `404:6539`, university `404:7181` / `404:7110`. Plan items carried in: measure BUG-002 on
the tree rows (AR 1.3× / 2.0×) and fix if they overflow; I2 "lecture leaf inert" per the owner's ruling. Frame read +
code compare first; findings, rulings and the Done list land here.

**Compare (2026-09-27):** frames read over the MCP (metadata and design context of the rows `404:6642`, `404:7765`,
the frames `404:6539`, `404:7181`, `404:8686`, `404:6677`, the catalog row `135:1302`; 1× renders and the row icon SVG
in the scratchpad `w16/`), plus a real-font render of the build at 1.0, 1.3 and 2.0 in English and Arabic (a
throwaway probe, deleted; `probe_before.txt` / `probe_after.txt`). Three read-only Sonnet lenses (light, dark,
states / a11y / text scale) agreed on every finding below (the MCP was unreachable for them; they worked from the
renders and the read facts). Two lens suggestions were not taken: moving the missing 5 dp under the header, and the
end inset, into the shared catalog chrome (both would change walked screens; the list gap is fixed on this screen and
the inset is #100). The states lens's one finding, the shared header title clipped at 2.0 (a fixed 35-dp box), is
`docs/RESPONSIVE.md`'s queued item 3, not this wave's.

**Rulings:** none needed.

**Done:**
- **W16-1** the list starts **25** under the header (was 20) and the rows are **16** apart (was 12), on the Units and
  the Lectures views (`404:6599` ends at 99.44, the rows start at 124.44 and 218.44).
- **W16-2** the Mistakes row takes the frame's geometry: **78** tall (was 80); badge 17 from the start and the top;
  the name's line centred **28.0** and the count's **46.5** (were 29 and 54: a centred 46-dp block plus a 4-dp spacer
  the frame does not draw); badge and chevron centred at **37.0** (were 40). In the scale's lines the count is lifted
  2.5 into the name's trailing space. Real-font render against the frame's: name ink top 21.3 vs 21.0, count 41.0 vs
  42.0, chevron centred on 37.
- **W16-3** the chevron ends **12** from the row's edge (was 17): the frame's content container is 334 wide and ends
  there. Mistakes palette only; the catalog rows have the same drift and are logged as **#100**.
- **W16-4** the row chevron is the frame's stroke colour: new token `mistakesRowChevron` (`#4B675E` light, `404:6654`;
  `#FCFBF9` dark, `404:7778`). It was `mistakesContent`, the name's `#384F47`, in light.
- **W16-5** the light badge disc is **`#F4E6FF`** (`404:6644`, first read now; was `#FDFDFD`, never read).
- **BUG-002 on the tree rows:** measured, not affected: rows grow (Arabic long name 105 at 1.0, 124 at 1.3, 171 at
  2.0) and nothing overflows, before and after. Four tests pin it.
- **Checked and matching:** the one fetch per visit, the track switch, the 200-empty and 403-scope states, the offline
  banner, Units rows as one `Button`, the lecture leaf inert (no chevron, no button; owner ruling), RTL mirroring.
- **Logged, not fixed:** **#100** (the catalog rows' chevron end inset); #68 update (the rows' lines; the badge
  numeral `#000000` → content colour; the dark first-row text-block inconsistency); #70 update (the light disc read).
- **Token (1):** `mistakesRowChevron`; one value changed: `mistakesBadgeFill` light.
- **Tests (+11):** the "Wave 16" group in `mistakes_screens_test.dart` (Units and Lectures rhythm, the row geometry,
  the chevron in light and dark, the light disc, the Arabic insets, BUG-002 in English and Arabic at 1.3 and 2.0);
  `tree_list_row_test.dart` and `app_colors_test.dart` pins updated. **Red proof:** with only the token added, 8 fail
  on the old layout, each on its defect (gap 20, badge top 20, chevron inset 17, the two colours); the four BUG-002
  guards and the dark chevron pin pass on both (the old rows already grew; dark already matched).
- **Validation:** format PASS · analyze 0 · **1631 / 0 / 0** · OVERALL PASS.
- **Review:** read-only Sonnet review, two lenses: correctness 1 low finding, fixed: in dark the new chevron token equals mistakesContent (#FCFBF9), so the dark assertions could not catch a revert; the row test now reads a probe colour and fails on a revert (proved, it fails in dark); its runs: mistakes 87/87, row 15/15, colours 33/33, analyze clean. Frame and scope 0 findings (the paddings, the 2.5 lift and the centres re-derived by hand; scope held to the Mistakes palette and this screen). Validate re-run after the test fix: 1631/0/0.
- **Docs:** DESIGN_ISSUES #68 and #70 (updates), #100 (new); KNOWN_BUGS BUG-002 (tree rows measured).
- **Shared-widget note:** the Mistakes Chapters and Lessons rows (Waves 17–18) use the same row, so they get W16-2…5
  too; their list spacing is theirs.
- **Walk notes:** F1 the tree by track (school Units, university Lectures); F2 an empty tree (the mock's
  `sub-arabic` / `uni-histology`); F3 one fetch per visit (no refetch on Back and re-enter within the visit); V1 light
  vs `404:6539`; V2 university vs `404:7181`; V3 dark vs `404:8686` (first row's text block per #68); I1 Units rows are
  `Button`; I2 lecture rows inert (no chevron, not a button).

## Wave 16 — walk (2026-09-27)

Owner `WALK`. Pixel 8, a plain mock build with Wave 16 (`main_mock.dart` blob `f189786`, untouched), font scale 1.0
(read only). **Score: 100%** (F 3/3 · V 3/3 · I 2/2); details in `device_walk_results.md`, evidence in the scratchpad
`walk16/`.
- **Verified:** W16-1 (25.14 under the header, rows 16.00 apart), W16-3 (chevron ink ends 21.71 from the row's end,
  frame 22.0), W16-4 (`#4B675E`), W16-5 (disc `#F4E6FF`); dark matches `404:8686` (page `#232428`, row `#27282C`,
  cream text and chevron); Arabic mirrored in light and dark; Units rows are one `Button` each; lecture rows are a
  non-clickable `View` with no chevron; the empty tree ("No mistakes yet") on both tracks; offline banner; F3 on a
  20 fps recording (skeleton on entry and on re-entry after leaving, none inside the visit).
- **New W16-6:** the rows are 81.90–82.29 in English and 84.95 in Arabic, not 78, because every mock unit and lecture
  name is two Arabic words. A throwaway real-font probe (deleted) gives 78.00 for "Cell Biology" and for the one-word
  "الأحياء", and a taller name line for "الوحدة الأولى": W15-6's mechanism on the tree rows. The count's ink sits 2.95
  lower than the frame's, the badge and chevron 1.9 lower; nothing overflows. It folds into the owner's W15-6
  decision. Nothing was changed.
- **Recorded:** the row chevron is Material's filled `chevron_right` (ink 8.38 × 13.71); the frame's is a 1.33 stroke
  (8 × 15.3), 1.6 dp taller. Same end and colour; the catalog rows draw the same glyph.
- Restored to light EN on Home, signed in as the university student.

## Wave 17 — implementation (in progress, 2026-09-27)

Owner `NEXT`. Frame: `404:6677` (Chapters); the dark frame is located during the compare. A "verify" wave: Wave 16
already gave this screen's rows the frame geometry (the shared `TreeListRow`, W16-2…5); its list spacing is this
wave's. Frame read + code compare first; findings, rulings and the Done list land here.

**Compare (2026-09-27):** frames read over the MCP: metadata of `404:6677`, the Units header `404:6599` and the dark
family frames `404:7894`, `404:7990`, `404:8623` (named in the repo docs; `404:7894` is the dark Chapters frame,
`404:7990` a four-row dark variant, `404:8623` the dark overview); design context of the rows `404:6697` (light) and
`404:7931` (dark), whose chevron SVGs match Wave 16's (`#4B675E` / `#FCFBF9`, stroke 1.33); 1× renders measured with
`w16m.py` (scratchpad `w17/`, with `facts.md`). Two read-only Sonnet lenses (frame; states / a11y / tests) found the
same two items and nothing new against the frames; the states lens also asked for state tests on this screen (added).

**Rulings:** none needed.

**Done:**
- **W17-1** the Chapters list starts **25** under the header (was 20) and its rows are **16** apart (was 12): the frames
  put the header's end at 99.44 and the rows at 124.44 and 218.44, light `404:6677` and dark `404:7894`. File-level
  `_belowHeader` / `_rowGap` in `mistakes_tree_screens.dart`, used by the Chapters list only.
- **W17-2** tests on THIS screen. F2 had none: the test named "an unknown unitId is EMPTY" opened a subject with no
  units on the Units screen; it is renamed for what it checks ("a subject with no units is EMPTY…"), and a real F2
  test opens the Chapters route for a unit the cached tree does not have (empty, no error, no Retry, bare "Chapters"
  title, still one fetch). Also pinned on Chapters: the row geometry, Arabic mirroring (badge 17 from the right,
  chevron mirrored 12 from the left), one button node per row with the whole label, a failed load's Retry refetching
  the same subject, the offline banner with the rows kept.
- **Rows:** nothing to change. The Chapters rows are the Units row (`404:6697` / `404:7931` = `404:6642` / `404:7765`),
  which Wave 16 built into the shared `TreeListRow`.
- **Checked and matching:** one fetch for the stack (existing test), the server count verbatim (existing test), the
  title logic (the frame's singular "Chapter" is the open copy question in DESIGN_ISSUES #14), the count copy (#59,
  #66), colours and tokens, the loading / empty / error / offline chrome.
- **Logged, not fixed:** #68 update: the dark Chapters frame's first row centres its text block and its second row
  drops the count 2.6 lower; the build keeps one geometry in both palettes.
- **Tests (+8):** the "Wave 17" group in `mistakes_screens_test.dart`. "Cell Structure" wraps in the test font, so the
  one-line checks use the "Mitosis" row. **Red proof:** on the old layout the two spacing tests fail (20 against 25,
  light and dark); with only the gap put back to 12, both fail at 12 against 16 (file restored byte-identical). The
  other six pin behaviour that was already right.
- **Validation:** format PASS · analyze 0 · **1639 / 0 / 0** · OVERALL PASS (`validate.ps1`). `validate.sh` under Git Bash fails its format step on this machine ("The command
  line is too long", `xargs` over 286 files); the format itself is clean (`dart format` 0 changed). Not this wave's.
- **Review:** read-only Sonnet review, two lenses: correctness 0 findings (its runs: mistakes 49/49, analyze clean; it re-derived the red proof, the finder scoping to the Chapters screen, the F2 single fetch across go(), the Retry call count, the rename and the semantics and view teardown); frame and scope 1 low finding, refuted: it could not trace 404:6708 (the second light row cited in the #68 note) to facts.md, but the id is the second Button (y 218.44) in the MCP metadata of 404:6677; facts.md now names it. Scope confirmed: only the Chapters list changed, the Lessons list keeps 4 / 12 for Wave 18.
- **Docs:** DESIGN_ISSUES #68 (update).
- **Walk notes:** F1 cached view (a 20 fps recording: no skeleton on Chapters); F2 N/A on device (the Android app has
  no deep links, so no unit id outside the tree can be asked for; covered by the new test); V1 light vs `404:6677`;
  V2 dark vs `404:7894` (first row per #68); I1 AR chevron; I2 rows are `Button`. The mock's chapter names are two
  Arabic words, so the rows will be ~82 on device (W16-6).

## Wave 17 — walk (2026-09-27)

Owner `WALK`. Pixel 8, a plain mock build with Wave 17 (`main_mock.dart` blob `f189786`, untouched), font scale 1.0
(read only). **Score: 100%** (F 1/1 with F2 N/A · V 2/2 · I 2/2); details in `device_walk_results.md`, evidence in the
scratchpad `walk17/`.
- **Verified:** W17-1: the first row 25.14 under the header, the rows 16.00 apart, margins 20.2 / 19.8, in light EN,
  dark EN, dark AR and light AR. The rows carry Wave 16's values against `404:6677` (disc `#F4E6FF` 17.1 from the
  start, chevron `#4B675E` ending 21.71 from the end, fill `#EAD5D5`, name and count starting 70.1 from the start) and
  against `404:7894` in dark (page `#232428`, row `#27282C`, cream text and chevron). F1 on a 20 fps recording: the
  skeleton only on entering the subject, then Units → Chapters (both units) and back show the rows at once. Arabic
  mirrored (badge 17.1 from the right, chevron 20.95 from the left pointing left, "فصول الوحدة الأولى"); each row is one
  `Button` whose tap opens that chapter's Lessons; offline banner with the rows kept, cleared on reconnect.
- **F2 N/A on device:** the Android app has no deep links, and every mock unit is in its tree; the Wave 17 widget test
  covers it.
- **Rows 81.90–82.29 (EN) and 84.95 (AR), not 78:** W16-6 (the mock's chapter names are two Arabic words), owner's
  call with W15-6. Nothing changed.
- **One lost tap, not reproduced:** the first tap on the second row left the screen unchanged. Four later taps on the
  same point (two after an identical screencap + dump + 5 s wait) each opened "الفصل الثاني Lessons"; logcat clean.
  Recorded, not logged as a defect.
- Restored to light EN on Home, signed in as the school student.

## Owner rulings (2026-09-27, after the Wave 17 walk)

The owner's reply: "15-6 c, 100 a, 14-10 b, 98 a, 99 b". Recorded; #100, W14-10 and #98 applied on the owner's
`fix` (next section).
- **W15-6 + W16-6 → (c):** fix the mixed-font line height app-wide in its own wave (DECISIONS D-019). That wave is
  not in the list; only `FORMULATE` places it.
- **#100 → (a):** the catalog rows' chevron ends 12 from the edge like the Mistakes rows (the catalog palette's end
  inset); re-walk the catalog Units, Chapters, Lessons and Lectures after.
- **W14-10 → (b):** the app draws the Arabic underline itself, in `QuestionStemText` (quiz page and review); KNOWN_BUGS
  BUG-014.
- **#98 → (a):** size the ai-education glyph by the drawing's height on the quiz panel and the result CTA, after
  re-reading `159:1695` and `159:1964`.
- **#99 → (b):** closed; the catalog headers keep `#0E0E0E`.

## Fix batch (2026-09-27, owner `fix`)

#100, W14-10 and #98, one batch. Frames re-read first by two read-only Sonnet agents over the MCP and spot-checked
by the main session (the glyph groups `162:2590`, `159:1840`); the font facts read off the bundled fonts' `post`
tables and a throwaway real-font probe (deleted; output in the scratchpad `fix0927/`).
- **#100:** the catalog row's end inset is the Mistakes row's (`_catalogPadding`, end 11.5 + 0.5): the chevron ends
  12 from the row's end and the text column is the frames' 242 (was 237), confirmed on all eight catalog row frames,
  light and dark. +3 tests (`tree_list_row_test.dart`, "#100"); all three fail on the old padding.
- **W14-10:** `QuestionStemText` paints the underline of a run holding Arabic letters itself, at Tajawal Regular's
  declared line (centred 0.075 em under the line's baseline, 0.05 em thick; the engine's own placement, measured);
  such runs take no `TextDecoration`; Latin runs keep Inter's. +7 tests (`question_stem_text_test.dart`, "W14-10"):
  geometry, scaling, wrapping, truncation, spans, and two real-font pixel tests. Red proof: with the hand-drawn path
  disabled, the span test and the Arabic pixel test fail (file restored byte-identical).
- **#98, premise corrected:** every glyph instance holds a 22.12 × 21.01 group at (2.215, 2.289) in its 26.55 box;
  the asset is that group at 1:1, so the frames draw it at scale 1.0 (the entry's "26.18 × 24.41" was a misreading).
  New `AiEducationGlyph` (26.55 box, the asset 27 × 25 at (0.184, 0.002)) on the panel and the CTA; the title and the
  label move 2.12 in, onto the frames' 8.089 and 10. +5 tests (`ai_education_glyph_test.dart`) and the two sites'
  tests updated; on the old call sites the three site tests fail. Golden `ai_panel_dark.png` regenerated (glyph and
  title only: diff columns 28–197, rows 29–55).
- **Open for the owner:** review (`quiz_review_screen.dart`, Wave 14) sizes the same glyph by a height of 24.41,
  which draws it at 0.976× by the same reading. Not changed (a walked screen).
- **Validation:** format PASS · analyze 0 · **1654 / 0 / 0** · OVERALL PASS (`validate.ps1`).
- **Review:** read-only Sonnet review, two lenses, both 0 findings: correctness (re-ran the five affected test files, 22/22 and 71/71, the golden, analyze and format; traced the TextPainter rebuild against RenderParagraph's own layout branch, the paint offset, the colour resolution and the guards; confirmed review untouched); scope and frames (the diff is the three fixes and their tests only, nothing under contract/; the guard suites pass; re-read six catalog row frames and two glyph groups over the MCP and the fonts' post tables with fontTools, every number in the comments matches; the golden regeneration is justified by the title landing on the frame's 34.64).
- **Docs:** DESIGN_ISSUES #98 and #100 (fixed), KNOWN_BUGS BUG-014 (W14-10 fixed at BUILD), DECISIONS D-017 update.
- **Walk notes (on `WALK`):** the catalog Units, Chapters, Lessons and Lectures rows (chevron ink ending ~12 + the
  glyph's own inset from the row's end, EN and AR); an Arabic underlined stem (the mock's "…يصف <u>التركيب</u>…")
  on the quiz page and in review, light and dark; the AI panel header and the result CTA glyph (FLAG_SECURE: the quiz
  page and review need the local walk override).

## Fix batch — walk (2026-09-27)

Owner `WALK`. Pixel 8, a mock build of the batch WITH the local-only FLAG_SECURE override (`walk_override.py`; the
source restored byte-identical, blob `f189786`, before the install), then a normal build reinstalled at the end.
**Score: 100%** (7/7); details in `device_walk_results.md` ("Fix batch"), evidence in the scratchpad `walkfix/`.
Two read-only Sonnet verifiers re-measured every capture against 1× frame renders (`308:4769`, `159:1812`,
`159:2345`).
- **#100 verified:** on every catalog row (Units, Chapters, Lessons; university Lectures; light and dark) the
  chevron's ink ends 21.71 from the row's end (frame 22.0; before the fix 26.7); Arabic mirrored (20.6–21.0 from
  the left, pointing left); the disc 17.1 in; rows 16.00 apart.
- **W14-10 verified:** the quiz page's Arabic stem shows the underline under the whole of «التركيب» (58.3 dp, 2 px
  thick, a clear pixel row under the letters' baseline stroke); review's one-line stems underline the visible part
  and the ellipsis («ال…»), as the engine does for a truncated underlined run.
- **#98 verified:** the panel and CTA glyphs measure the same ink (25.90 wide) at the frame's scale (1× render 25–27
  with its 1-dp quantisation; the old 1.062× would be ~27.5); the title's ink starts 8.76 after the glyph's (frame
  8–9; old ~10.9); the CTA label 11.43 after it (frame 12), the group centred (0.19 dp).
- **Observed, not logged:** the Lessons / Lectures caption's ink ends 52.6–52.95 from the row's end, the frame's
  54.0 (its caption box ends 52.66; the frame's bar-and-caption group sits 0.66 inside the text column, which the
  build does not draw, and its caption is "80%", #16). Sub-dp; recorded.
- **Device state:** the normal build reinstalled (the reinstall signs the mock out: the app is on its landing
  screen, following the system's dark theme); airplane 0, Wi-Fi 1, font 1.0 (read only). The phone is in
  landscape: it rotated, nothing was changed. `/sdcard/ui.xml` removed.

## Wave 18 — implementation (in progress, 2026-09-27)

Owner `NEXT`. Frame: `404:6762` (Lessons); `404:6853` is the replay Quiz page (DESIGN_ISSUES #67), out of scope by the
owner ruling of 2026-09-12, so the lesson rows stay inert. A "verify" wave: the rows are Wave 16's shared
`TreeListRow`; the list spacing is this wave's.

**Compare (2026-09-27):** frames read over the MCP by the main session: metadata of `404:6762`, `404:6853`, `404:6677`,
`404:7894`, `404:7990`, `549:19390`; design context of the lesson row `404:6782`; 1× renders of `404:6762`, `404:7990`
and `549:19390` measured with `w16m.py` (scratchpad `w18/`, with `facts.md`). A read-only plugin query on the `design`
page (`57:36`) listed all 18 `Learn(My Fault)` frames by what they draw: the node-ID map DESIGN_ISSUES #64 had open
since 2026-09-12. Two read-only Sonnet lenses (frame; states / a11y / tests): the frame lens found the two spacing
values and nothing else against the frames; the states lens found no behaviour defect and eight test gaps on this
screen (skeleton, unknown chapter, Retry, offline, inert-row semantics, inert rows in Arabic, the plural on a lesson
row, the ripple), all now covered except a zero-lesson chapter, which the contract rules out (`openapi.yaml:1233`: "a
chapter appears only when it has such a lesson").

**Frames:**
- **Light `404:6762`:** header ends 99.44, one row at 124.44 (25 under). The row (`404:6782`) is the Units / Chapters
  row exactly (w16m: badge 17 in, centre 37.5; name ink top 21, count 42; chevron ends 22 from the end), with a
  chevron the leaf does not build (owner ruling 2026-09-12).
- **Dark:** no frame draws Lessons. `404:7990`, in the dark Lessons slot, draws a Chapters list ("Cell Biology
  Chapter", four rows numbered 1, 2, 2, 2) with the family's rhythm (25 under the header, rows at 0 / 94 / 188 / 282:
  16 apart) and the dark Chapters rows (#68's first-row centring included). V2 is checked against those.
- **RTL `549:19390`:** header mirrored (chip on the right, "دروس بنية الخلية", the build's "دروس {chapter}"), the row at
  the same 124.44 but not mirrored (badge 17 from the left, chevron right, English copy); the same on all four RTL row
  frames. The build mirrors (#58 / #64).

**Rulings:** none needed.

**Done:**
- **W18-1** the Lessons list starts **25** under the header (was 20) and its rows are **16** apart (was 12):
  `_MistakesLessonList` uses the file's `_belowHeader` / `_rowGap`, as the Chapters list has since Wave 17. The
  comment cites `404:6762`, `549:19390` and `404:7990`.
- **W18-2** tests on THIS screen, the "Wave 18" group in `mistakes_screens_test.dart` (+14), on a new fixture
  `schoolMistakesTreeLessons()` (one chapter, four lessons: "Genetics" 1, the frame's row, then 2, 3 and 11, the
  Arabic `one` / `two` / `few` / `many` forms; every other fixture chapter has one lesson): 25 / 16 and 78-tall rows,
  light and dark; the row geometry of `404:6782` without the chevron (badge 17, centre 37, name 12 after the badge,
  centres 28 / 46.5); every row inert in EN and AR (no `Icon`, `InkWell.onTap` null, a tap leaves the route
  unchanged); one semantics node per row carrying number, name and count, NOT a button and with no tap action; the
  plural on lesson rows ("1 mistake", "2 / 3 / 11 mistakes"; "خطأ واحد", "خطآن", "3 أخطاء", "11 خطأً"); Arabic
  mirroring (badge 17 from the right, the text 12 to its left, the title "دروس Cell Structure"); F1, the rows on the
  first frame from Chapters with no skeleton and one fetch; the skeleton on a cold link until the tree arrives; an
  unknown chapter is empty (no error, no Retry, bare "Lessons" title, one fetch); a failed load's Retry; the offline
  banner with the rows kept.
- **Red proof:** on the old layout the two spacing tests fail (20 against 25, light and dark); with only the gap put
  back to 12 both fail at 12 against 16 (file restored byte-identical). The other twelve pin behaviour that was
  already right.
- **Checked and matching:** the row paint and geometry (Wave 16's shared row), the inert leaf (no chevron, no ripple,
  no button flag), the title logic and copy (#14's open "lessons" case point), the count copy (#59, #66), the one
  fetch for the stack, the loading / empty / error / offline chrome.
- **Not changed:** the shared `CatalogListSkeleton` (4 / 12, 56-tall blocks) serves every catalog and Mistakes list;
  no frame draws a skeleton.
- **W18-3, open for the owner (not a defect):** with no chevron, an inert row's text column is 282 wide; the frame's
  is 242 (it reserves the chevron's 12 + 28). A long lesson name wraps about 40 dp later than the same name on a
  Units or Chapters row. A side effect of the 2026-09-12 ruling; keep, or reserve the gap. Nothing changed.
- **Validation:** format PASS · analyze 0 · **1668 / 0 / 0** · OVERALL PASS (`validate.ps1`).
- **Review:** read-only Sonnet review, two lenses, 0 findings. Correctness (its runs: the file 63/63, analyze clean): every Lessons finder is scoped to the screen, so nothing matches the Chapters screen mid-transition; each test fails on the regression it names (a chevron or tap handler back, the gap at 12, the plural collapsed, the row unmirrored); the fixture parses with the real `fromJson` and keeps the pruned-tree sums; the skeleton test leaves no pending future; the Arabic strings match `app_ar.arb`. Frame and scope (the same runs): 16 + 9 = 25 and 94 − 78 = 16 re-derived by hand; the geometry assertions are Wave 16's documented values; only `_MistakesLessonList` changed in `lib/`; the fixture is a pure addition; the #64 table matches the frame map.
- **Docs:** DESIGN_ISSUES #64 mapped (the 18 frames; no dark Lessons frame; the RTL rows unmirrored).
- **Walk notes (on `WALK`):** school student, Mistakes → الأحياء → الوحدة الأولى → الفصل الأول (two lessons: 2 and 1
  mistakes): V1 light vs `404:6762` (25 under the header, 16 apart, the row paint, no chevron); V2 dark vs the dark
  family rows (`404:7990`); I1 AR (mirrored; `549:19390` is not); F1 a recording from Chapters (no skeleton); F2 a
  tap on each row does nothing and the rows are not `Button` in the dump; F3 "خطأ واحد" / "1 mistake".

## Wave 18 — walk (2026-09-27)

Owner `WALK`. Pixel 8, a plain mock build with Wave 18 (`main_mock.dart` blob `f189786`, untouched), font scale 1.0
(read only). The phone had been left in landscape with auto-rotate on; the owner stood it upright on request (`GO`);
no setting was changed. **Score: 100%** (F 3/3 · V 2/2 · I 1/1); details in `device_walk_results.md`, evidence in the
scratchpad `walk18/`. Two read-only Sonnet verifiers re-measured the captures, the dumps and both recordings.
- **Verified:** W18-1: the first row 25.14 under the header, the rows 16.00 apart, margins 20.2 / 19.8, in dark EN,
  dark AR, light AR and light EN. Against `404:6762` in light: fill `#EAD5D5`, disc `#F4E6FF` 17.0 from the start, name
  and count ink from 70.1 / 69.7 (the frame's 70 / 71), count `#EF4444`; no chevron ink in any row (the frame draws
  one; the leaf drops it by the 2026-09-12 ruling). Dark: `#27282C` rows, cream text, red count, the family's paint.
  Arabic mirrored: disc 17.1–17.4 from the right, the text from ~70–71 from the right, the title "دروس الفصل الأول".
  F1 (a recording from Chapters): the Lessons rows are there from the first transition frame, fading in with the
  page; no frame shows a skeleton. F2: each row is `android.view.View`, clickable=false, in all four dumps; two taps
  and a 600-ms press left the screen unchanged, and the recording over them holds one encoded frame. F3: "2 mistakes"
  / "1 mistake", "خطآن" / "خطأ واحد". Offline: the banner above the rows, both rows kept, cleared on reconnect. Logcat:
  no Flutter line across Chapters → Lessons and both language switches (a clean-log repeat, as the ring buffer had
  rolled over during the airplane toggle); the crash buffer is empty.
- **Rows 81.90–82.29 (EN) and 84.95 (AR), not 78:** W16-6 (the mock's lesson names are two Arabic words), D-019.
- **Verifier notes, not defects:** the tap recording's file carries no duration, so the recording alone cannot show
  it spanned the taps (the dumps after the taps and every later capture still show the inert Lessons rows); the
  device is 411 dp wide, so the row is 371 wide with the frame's margins; in dark the disc (`#27282C` at 20% on
  `#27282C`) shows only its rim, the dark family's paint (#70).
- Restored to light EN on Home, signed in as the school student; airplane 0, Wi-Fi 1; `/sdcard/ui.xml` removed; this
  walk's recordings pulled and removed from the phone.

## Wave 19 — implementation (in progress, 2026-09-27)

Owner `NEXT`. Screen: Profile (`/profile`, the Account tab). Frames: `166:4416` / `309:7940`; Logout `180:4598`→`180:4704`;
Go-to-Uni `180:4301`→`180:4445`. Endpoints `GET /me`, `POST /auth/logout`. The wave's two items: (1) the Logout dialog
draws No + Yes (and ✕) where the build has ✕ + one confirm; Go-to-Uni keeps its single button; (2) the stale profile
after log-out → log-in (device-proven 2026-09-20, W05-3): reproduce on the mock with a router-driven test, then fix.
Frame read + code compare first; findings, rulings and the Done list land here.

**Compare (2026-09-27):** frames read over the MCP by the main session (plugin dumps of `166:4416`, `337:7433`, every
Logout and Go-to-Uni card; 1x renders of `166:4416`, `309:7940`, `337:7433`, `549:21052`, `180:4598`, `337:7677`,
`549:21295`, `180:4301`), all in the scratchpad `w19/` (`facts.md`). Frame map: Profile light `166:4416` / `309:7940`,
dark `337:7433` / `349:12919`, RTL `549:21052` / `549:26384`; Logout light `180:4598` / `309:9366`, dark `337:7677` /
`349:10749`, RTL `549:21295` / `565:13391`; Go to Uni `180:4301`, dark `337:7561`, RTL `549:21179`. Four read-only
Sonnet lenses (frame: screen; frame: dialogs; states / a11y / tests; the stale-profile root cause), `w19/lenses.md`.

**Stale profile, reproduced (a throwaway router test, `test/zz_w19_*`, to be deleted):** log out from the Account tab,
sign student B in: Home keeps student A (the mock shape: the token-less `GET /me` answers A) or shows "Something went
wrong" (the staging shape: staging answers a token-less `GET /me` with 401 `authentication_required`, curl-checked
2026-09-27). Mechanism: `invalidateSessionScope` runs while Home and Profile still watch `meProvider`, so Riverpod
rebuilds it on the next frame with no token, and nothing refetches at the next sign-in. Riverpod 3.3.2 keeps a
provider's previous value through every rebuild (`copyWithPrevious`; invalidate never disposes a non-autoDispose
element), so A's profile stays readable (`.value`) even in the error state. Probes: re-invalidating at sign-in (the
root-cause lens's recommendation) still shows A's name on B's Home while B's `/me` is in flight; making `meProvider`
autoDispose drops A when the shell unmounts (both shapes pass), at the cost of 10 test-teardown timer failures in 7
files (the documented `holdBoards` trap) and the disposal-flag guard. The lens's claim that the staging error carries
no value, and that the Top Student board survives a sign-out, are refuted (the probe prints `AsyncError(value: A)`;
the shell unmounts at sign-out).

**Findings (frame-proven, to fix):** the header is a stock 56-tall AppBar with the card 4 under it (every frame: a
35-tall title bar, Inter Semi Bold 22, the card 25 under it); the dialog ✕ is `#0E0E0E` in light (frames `#3F3F3F`)
and its tap target is 35 x 35; the Logout card ends 20 under its button (frame 15); the Go-to-Uni confirm is full
width at 18 in (frame 284 wide at 31 in); the Logout dialog's No / Yes pair (the wave's item 1). **Notes:** menu labels
render Semi Bold where the frame says Medium 18 (no 18/500 style; the Login precedent keeps the scale).

**Owner rulings (2026-09-27):** (1) the stale profile: `meProvider` becomes autoDispose, so the profile is dropped
when the signed-in shell unmounts at sign-out (not a re-invalidation at sign-in, which the probe showed still paints
A while B loads); (2) keep Points only: no Badges card, the frames' disagreement logged (DESIGN_ISSUES, seif_fight
S25); (3) the Logout No / Yes pair in the frame's colours, MIRRORED in Arabic (No at the reading start, #58 / #64);
(4) the dark Logout scrim stays 60% on both tracks, the university frame's 30% logged as a likely slip.

**Done:**
- **W19-1 the stale profile** (BUG-015, D-020): `meProvider` is autoDispose, so the sign-out, which unmounts the
  shell, drops it; `MeNotifier` re-arms its disposal flag on every build (Riverpod 3 keeps the notifier across
  rebuilds and runs the dispose callbacks on each: without the re-arm a Retry after a quiz or a saved edit sticks on
  the skeleton). Test harnesses hold it like the boards (`holdProfile`). `session_scope.dart` says what drops it now.
- **W19-2 the Logout pair** (#102): No `#EF4444` and Yes `cs.primary` (`#384F47` / `#AE87E7`, both tracks), 155 x 60,
  5 apart, 15 in, both shadow-only (new `CtaTone.shadowOnly`); No and the ✕ dismiss, Yes signs out; copy "No" / "Yes",
  "لا" / "نعم" (`logoutNo`, `logoutYes`; `logoutConfirm` removed); mirrored in Arabic by the ruling.
- **W19-3 the ✕**: the frame's cross (`close_cross.svg`), `#3F3F3F` light / `#FCFBF9` dark (token
  `profileDialogClose`), a 48 x 48 target centred on the frame's 23 dp box, 24 from the card's start (the limit
  card's pattern; it was 35 x 35).
- **W19-4 the dialog cards**: 345 on the 402 frame (was 344); Go to Uni's button 284 wide, centred (was 309 at 18);
  Logout ends 15 under its pair, Go to Uni 20 under its button.
- **W19-5 the header**: the frame's 35 dp title bar 16 under the status bar, the title `h2` / `textPrimary` (#57,
  #99) as a heading to screen readers, the header card 25 under it (the stock 56 dp AppBar put it 4 under); the
  skeleton shares the 25.
- **W19-6 tests**: `profile_relogin_test.dart` (router-driven, 4: the second student on Home and Profile in the mock
  and the staging shapes, the profile gone at sign-out, nothing of the first student while the second's `/me`
  loads); `me_notifier_test.dart` (+1: a Retry lands after a rebuild in use); the "Wave 19" group in
  `profile_screen_test.dart` (+18: the header in light, dark and Arabic, the skeleton, the pair's copy, No, Yes,
  geometry in English and Arabic, paint and tones in light and dark, the ✕ in light, dark and Arabic, clear of the
  title (SF-08), named, Go to Uni's button); `cta_golden_test.dart` (+2 goldens `confirm_dialog_*_pair`; the four
  `confirm_dialog_*` goldens regenerated: the ✕ glyph and colour, the 345 card, Go to Uni's 284 button).
- **Red proof:** the four re-login tests fail on the old provider (B absent in both shapes; A's profile still in the
  container; no reload at sign-in); the re-arm test fails without the re-arm (stuck `AsyncLoading`); 16 of the 18
  Wave 19 screen tests fail on the old layout (the two that pass pin behaviour that already worked: the centred
  heading, Yes signing out). Every file restored byte-identical.
- **Docs:** KNOWN_BUGS BUG-015; DECISIONS D-020; DESIGN_ISSUES #101 (Badges vs Rank), #102 (the pair), #103 (the dark
  university scrim), #104 (menu labels Medium 18, record only); `seif_fight.md` S25 note.
- **Not changed:** the dialog's type follows the scale, so its vertical rhythm is the app's; the ✕ box is centred on
  its row (the frame's is 1 dp higher); the sign-out still rebuilds `meProvider` for one frame with no token; the
  other non-autoDispose session providers (subjects, subject tree, Mistakes overview) are unchanged and unproven.
- **Found, filed separately (not this wave's screen):** other autoDispose notifiers keep a disposal flag set after a
  rebuild (probe: the leaderboard's `refresh()` after an invalidation sticks on `AsyncLoading`; Home invalidates the
  board when a quiz moves the points), a task chip for the owner.
- **Validation:** format PASS · analyze 0 · **1693 / 0 / 0** · OVERALL PASS (`validate.ps1`, 2026-09-28; +25 over Wave
  18's 1668: the 23 above and the 2 new goldens).
- **Walk notes (on `WALK`):** school light EN: Profile vs `166:4416` (the title bar, the card 25 under it); Logout →
  No (stays), Logout → Yes → `/login`; university login (`111111`) → Home and Profile show the university student
  (F3, F4) and Top Student asks the right scope (W05-3); Go to Uni: the button disabled with its reason (F5); the
  dialog pair vs `180:4704` light and dark, Arabic mirrored; the ✕ and the edit chip hit 48 dp (I2).

## Wave 19 — walk (2026-09-28)

Owner `WALK`. Pixel 8, a plain mock build with Wave 19 (`main_mock.dart` blob `f189786`, untouched), font scale 1.0
(read only). **Score: 100%** (F 5/5 · V 3/3 · I 2/2); details in `device_walk_results.md`, evidence in the scratchpad
`walk19/`. Two read-only Sonnet verifiers re-measured the captures, the dumps and both recordings: every claim
confirmed except one they could not re-derive from files (that the log buffer had not rolled over, read live).
- **Verified:** W19-1: after the school student logs out and the university student logs in, Home and Profile show
  "طالب جامعي تجريبي" (the bug showed the school student); the recording from the OTP success screen holds 81 frames,
  the Home skeleton then the university name from 2.583 s, and no frame with the school name; Top Student loads (W05-3's
  400 is gone); the reverse switch shows the school student again. W19-5: the title centred 16 under the status bar,
  the header card 25.2 under the 35 dp bar, the Points card and the menu 20 apart, in light, dark and Arabic. W19-2 to
  W19-4: the pair `#EF4444` / `#384F47` (`#AE87E7` dark, and `#384F47` on the university track), 15.24 in, 5.33 apart,
  the card ending 15.24 under it; the ✕ `#3F3F3F` / `#FCFBF9` with a 48 dp target; Arabic mirrored (لا on the right);
  Go to Uni's button inset 30.5, disabled with its reason. No and the ✕ dismiss; Yes signs out, and a cold restart
  stays signed out. Offline: the banner under the title bar, the profile kept. No Flutter log line, no crash.
- **Incident: an incoming phone call.** During the walk a call reached the phone; the tap meant for the Account tab
  probably answered it (the call screen's timer read 00:07 about seven seconds after the tap), and one swipe went to
  the call screen. Input stopped at once and the owner handled the call; the capture and two dumps of the call screen
  were deleted from the scratchpad and the phone's dump removed. The walk resumed on the owner's `CONTINUE`, with the
  call state read idle first.
- **Observed, not logged:** the Points card is ~90 dp tall (frame 82; the scale's line heights, the card predates this
  wave); the Logout card is 212 tall (frame 239; #102's "not changed"); the RTL frames put the ✕ 18 from the card's
  right, the build mirrors the LTR 24; the Arabic pair sits 1.9 dp lower than the English one (the taller Arabic body
  line, W16-6 / D-019). The university student also gets Go to University, as the University frame draws it.
- Restored to light EN on Home, signed in as the school student; airplane 0, Wi-Fi 1; portrait. Auto-rotate read 0 at
  the start and 1 at the end (the Wave 18 walk had left it on); nothing in this walk touches it, so it was left for the
  owner. This walk's recordings and dumps removed from the phone.

## Wave 22 — implementation (in progress, 2026-09-29)

Owner `NEXT`. Screen: Flashcards (university; a new screen). Endpoints `GET /flashcards/lectures/{lectureId}/cards`
(cursor + `pageSize`), `PUT /flashcards/cards/{id}/self-grade`. The plan (`implementation_waves.md`): gated on five
design answers (the controls → `gotIt` / `again`; the front → back reveal; bookmark / share; the entry point; S6). First:
the frames (`225:5582`, component `247:3260`, any dark / RTL variant), the contract at the pin and upstream, the data
layer, the Lectures view and the mock; then the owner's questions. Nothing is built before the answers.

**Read (2026-09-29; four read-only Sonnet readers + a critic, key frames re-checked by the lead over the MCP; reports in
the scratchpad `w22/read_*.md`):**
- **Frames.** Session light `225:5582` is the UPDATED layout: "Got it", the "<" button, a restart button above the card
  (`1229:8739`, no reaction), the card `247:3260` of set `247:3257` (page `0:1`): the image + "What is A ?" front, the
  "Sclera" back, ON_CLICK flip both ways (SMART_ANIMATE, ease-out 0.3 s) — the only drawn gesture. Dark `337:14475` and
  Arabic `549:28041` are the OLDER layout ("Confirm" / "التالى", no restart). Hidden leftovers `222:5252`, `337:14430`,
  `549:27996`. Setup `1234:8797` "Flash Card Setup" (light only: subject, lecture, the "10 Flash Cards" pill, "Start
  learning"). The Lectures "Flashcard" tab is drawn on `180:5354` / `180:5208` / `349:15962` / `337:11059` (never active
  on the design page); the older prototype page wires tab → `426:23888` (the tab active, 2nd) → Setup → cards. Home
  tile `546:7199` (+ dark, RTL). All frames draw the nav with Learn selected. Purchase frames `1227:8514`, `225:7001`,
  `431:27530`, component `1234:9634` are out (adr-049). Page `57:36` also holds a credential-like string in TEXT
  `1240:9847` (not reproduced; flagged to the owner).
- **Contract.** Both ops stable at the pin and unchanged up to upstream `f462968` (3.27.0-m1), which adds a required
  `Lecture.flashcardCount` for the Setup screen's count and says "one `pageSize=10` page per round". Preview: one
  50/week allowance shared with quizzes; charged cards re-deliver free; `403 flashcard_subscription_required` = the
  preview is used up (not the quiz weekly limit); `imageUrl` null everywhere today; `back` a multi-line block; grading
  latest-wins, no points. No flashcards copy exists.
- **Code.** The data layer is built (`pageSize` 20); no screen, route or mock routes; `hasFlashcards` unread;
  `LimitSheet` would show the quiz's weekly-limit copy for this 403 (must not be reused); `AppType` has no 22 / 25 / 55
  size; stale comments in `quiz_type_tabs.dart`, `quiz_type.dart`, `home_screen.dart`, `question_renderer.dart` and the
  notifier's cost rationale; S6 and #18 / #20 stale.
- **Questions to the owner (2026-09-29):** (1) the entry; (2) lectures without flashcards in the tab; (3) Setup's
  count vs the pin; (4) the buttons → `gotIt` / `again`; (5) the reveal; (6) after the last card; (7) the used-up
  preview's wording; (8) dark and Arabic from the new layout; (9) the Arabic words; (10) screenshot blocking.
- **Owner rulings (2026-09-29, `1A 2A 3B 4A … 10A`):** (1) the Lectures "Flashcard" tab is the entry; (2) lectures
  without cards hidden, the tab hidden when none has any, no invented progress; (3) **re-vendor the contract first**
  and show `flashcardCount` on Setup — no Setup without the count; (4) "Got it" → `gotIt` + advance, restart →
  `again` + advance, "<" → previous card, no grade; (5) tap flips, the buttons work on either face; (6) after the last
  card return to where the student came from, no completion screen or wording; (7) the preview-used-up line EN "You've
  used this week's free flashcards." / AR "لقد استخدمت البطاقات المجانية لهذا الأسبوع.", purchase-silent; (8) dark +
  Arabic from the light layout, existing theme colours, gaps logged; (9) Arabic: فلاش كارد / فهمت / مرة أخرى /
  إعداد الفلاش كارد / ابدأ التعلّم; (10) no screenshot blocking. Plus: keep the nav, centre the title, no
  bookmark/share/AI icons, a 10-card round, the design's 1/10 style, an image only when the card has one. BUG-017
  stays open. **Security:** the Figma credential in TEXT `1240:9847` is never copied anywhere.
- **Done:** **W22-1** contract re-vendored `ea83099` → **`f462968` (3.27.0-m1)**, the four files blob-identical to
  upstream, `SOURCE.md` (census 35 stable / 19 draft / 54; 32 app-buildable), `Lecture.flashcardCount` + mock + test
  fixtures in the same change (the contract guard needs it). **W22-2** the mock's `GET /flashcards/lectures/{id}/cards`
  and `PUT /flashcards/cards/{id}/self-grade`: 54 cards (anatomy 24/10/4/1, physio 12/3), the one weekly allowance
  shared with quizzes, charged cards re-delivered free, the truncated prefix + `nextCursor`, `403
  flashcard_subscription_required` at zero, `insufficient_scope` for school / unknown / undelivered, latest-wins
  grades; each lecture's count is its deck's length. **W22-3** the round: `flashcardRoundSize` 10, a per-lecture
  round position (`flashcardRoundPositionProvider`) Setup keeps alive, `finishRound()` moves it to `nextCursor` (to the
  start after the last page). **W22-4** the Lectures "Flashcard" tab (second; a `LecturesTab` that is not a
  `QuizType`; only lectures with cards, their own numbers, no bar or caption; hidden without cards; a subject with no
  quiz types opens on it). **W22-5** the quiz's header, progress bar and "<" extracted to
  `lib/core/widgets/study_session_chrome.dart` (a pure move; the quiz tests unchanged) and shared. **W22-6** Flash
  Card Setup (`1234:8797`, the quiz setup's layout and tokens; the `flashcardCount` pill, not tappable; Start disabled
  offline and at 0). **W22-7** the study screen (`225:5582`: the centred title, the flashcard progress fill, the again
  disc, the flip card 300 ms ease-out, image only when present, non-optimistic grading, pop to Setup after the last
  card; the undrawn states). **W22-8** the records: DESIGN_ISSUES #18 built, #20 note, #113–#119; seif_fight S6
  resolved + four asks; KNOWN_BUGS BUG-019; ASSET_MANIFEST (`flashcard_again.svg`); stale comments in the quiz type,
  tabs, renderer, Home, repository, notifier. **W22-9** tests.
- **Tokens:** `flashcardProgressFill`, `flashcardCardFill`, `flashcardCardText`, `flashcardAgainFill`,
  `flashcardAgainGlyph`, `flashcardSetupPillFill` / `Border` / `Text`, `flashcardSetupHelper`,
  `flashcardGradeError` (AppColors, six sites each); `flashcardCardShadows` (AppElevation, the inset shadow). Dark
  stand-ins logged in #113, #114, #119.
- **Strings (8):** `flashcardsTab`, `flashcardsTitle`, `flashcardSetupTitle`, `flashcardSetupCount`,
  `flashcardSetupHelper`, `flashcardGotIt`, `flashcardAgain`, `flashcardPreviewUsedUp`. The Arabic pill and helper are
  PROVISIONAL (#114).
- **Lead's calls (not in any frame or ruling):** round two starts at the previous round's `nextCursor` while the
  student stays on Setup and wraps after the last page (asked of Seif, S6); "after the last card" = pop back to Setup;
  grading disabled offline; a refusal that cannot succeed disables the grade buttons on that card; "<" absent on card
  1 as in the quiz; type mapped to `AppType` (#115); an image-less front centred (#116).
- **Review (four read-only Sonnet lenses, every finding adversarially verified): 15 confirmed, 1 plausible, 2
  refuted.** Fixed: a final grade landing during a pop popped Setup too; Start tapped during that pop re-studied the
  finished round; a refused grade left its buttons live; the "<" arrow drawn at ~53% of the frame, in the quiz too
  (BUG-019); the grade-error line 1.7:1 in dark (new `flashcardGradeError`); "Got it" unnamed while busy; the
  title's centring, the icon absence and the purchase-silent scan (EN + AR, the 403 state) now pinned; stale comments
  in the repository, notifier and error copy; two test names. Plausible, recorded: the English noun spelled as each
  frame spells it (#114).
- **Red proof:** every builder and fixer proved its tests red by mutation and restored the files byte-identical
  (tab 8, Setup 25, study 43, foundation 10, mock 6, the fixes 13).
- **Not changed:** the Home "Learning Tools" placeholder (#20, entry by the tab); `loadMore` (no production caller);
  the quiz's own flow; the Figma file (read-only; the credential is the owner's to remove).
- **Validation:** format PASS · analyze 0 · **2017 / 0 / 0** · OVERALL PASS (+273 over Wave 21's 1744) (`validate.ps1`, 2026-09-29).
- **Walk notes (on `WALK`), the university student (`111111`):** F1 Lectures → Anatomy → Flashcard tab (second; the
  four lectures with cards, their numbers; Biochemistry shows no tab; Physiology lists two of three) → Setup (the count
  24 / 10 / 4 / 1) → Start → cards load, "1/10"; F2 a round of 10 then Start again → the next 10, then the short 4,
  then back to the start; F3 "Got it" / restart each `PUT` and advance, "<" goes back without one; F4 reopen: the grades
  echo (not shown in the UI — test-level unless read from the mock); F5 use the weekly allowance (e.g. a 50-question
  quiz, or 50 cards) → the preview-used-up line, no button; F6 offline: the banner, grading off, Start off; V1 the
  study screen vs `225:5582` (header, disc, card, buttons, the fill `#5A7F73`); V2 the back face (a multi-line answer);
  V3 dark and Arabic (the disc at the left in Arabic, the dark stand-ins); V4 Setup vs `1234:8797`; I1 the flip (tap,
  both ways); I2 the grade controls and the busy state; I3 the entry tab and the pop back to Setup after the last card.
  No screenshot blocking on these screens.

## Wave 22 — walk (2026-09-29)

Owner `WALK`. Pixel 8, a plain mock build with Wave 22 (`main_mock.dart` blob `f189786`, untouched), launched with
`am start`, the university student, font scale 1.0 (read only). **Score: 92%** (F 5/5, F4 N/A · V 3/4 · I 3/3);
details in `device_walk_results.md`, evidence in the scratchpad `walk22/`. Two read-only Sonnet verifiers re-measured the captures, dumps, recording frames and 1x frames: every behaviour and every measurement confirmed, and BUG-020 with its code lines. Their PARTIALs were the record's wording, corrected here: the disc's EDGE, not its centre, is 20 from the screen edge; "exact mirror" compares the Arabic build with the English one (the Arabic frame is the older, unmirrored layout, #113); Arabic Setup's Start is 6.8 lower, not 6.4; the spinner's 24 dp is its box (the arc inks 25.9); the busy button's label is source-level (no dump was taken mid-grade); the flip card's is not the only Arabic test (none mixes directions). The walked mock is `mock_backend.dart` blob `6047624` (unchanged since 15:19; the APK built 17:43).
- **Verified:** W22-1 the count from the contract (24 / 10 / 4 / "1 Flash Card"); W22-2 the mock (the truncated 1/1
  round, the 403, charged cards free at zero); W22-3 rounds of 10 / 10 / 4, then the wrap; W22-4 the tab (second,
  cards-only lectures, no bar, absent on Biochemistry); W22-5 / BUG-019 the "<" arrow 16.4 × 27.8 at the frame's
  place; W22-6 Setup against `1234:8797` (2 dp from #115); W22-7 the study screen against `225:5582` to the dp, the
  flip ~0.30 s, non-optimistic grading, pop to Setup, offline; purchase-silent (EN + AR, the 403 state).
- **New — BUG-020 (open):** a card's text takes the app's direction: in Arabic an English card reads "?into right
  and left parts"; in English an Arabic back's full stop lands at the right. `flashcard_flip_card.dart:201`, `:257`
  set no `textDirection`; the quiz's stem does (`question_stem_text.dart:81`). Fix on the owner's request.
- **Observed, not logged:** five tabs overflow the Lectures row (Arabic ~54 dp, Practice a sliver at rest; English
  ~5 dp; scrolls, D-012 / #81); Arabic Setup's Start 6.8 lower; offline the card shrinks to 419.8 (the buttons move
  3.8); a truncated preview round ("3 Flash Cards", "1/1") is unexplained; the round position ends with Setup.
- **Not walked (test-level):** the skeleton, a load failure with Retry, a failed grade's line, the empty state,
  `insufficient_scope`.
- **Walk-method notes:** an incoming SMS notification covered the screen twice (one capture deleted unviewed, one
  deleted after it showed the message; two taps lost to it); the guard now also refuses input under a notification.
- **Device state:** light EN on Home, the university student signed in; airplane off, Wi-Fi on; auto-rotate 0 at the
  start and the end. The phone's USB link dropped after the walk (during a log re-read).

## Wave 22 — BUG-020 fix and targeted re-walk (2026-09-30)

On the owner's request. The 92% walk above stands as recorded; this adds the fix and a re-walk of BUG-020 only.
- **Fix:** `contentTextDirection` (`lib/core/widgets/content_text_direction.dart`, the quiz stem's rule: the first strong
  character's direction, else the app's) on both faces of `FlashcardFlipCard`, its screen-reader label, and Setup's
  subject and lecture lines (aligned at the app's start). Nothing else changed; the quiz keeps its inline copy (a test
  ties them). Files: that helper, `flashcard_flip_card.dart`, `flashcard_setup_screen.dart`; tests
  `flashcard_flip_card_test.dart`, `flashcard_study_screen_test.dart`, `flashcard_setup_screen_test.dart`,
  `reading_order.dart` (new), `test/core/widgets/content_text_direction_test.dart` (new).
- **Tests:** +19; red → green (flashcards 209 / 12 with the fix reversed, naming "?" after "parts" and "." after
  "الأمام"; 221 / 0 with it); the Setup alignment tests fail without it (0 / 2). validate: format PASS · analyze 0 ·
  **2036 / 0 / 0** · OVERALL PASS. Two read-only Sonnet reviewers: 0 high / medium.
- **Re-walk (Pixel 8, the same build):** the four combinations **4 / 4 PASS** — Arabic app + English card (the "?" at the
  end of "into right and left parts?"), English app + Arabic card (the full stop of "إلى الأمام." at the left), Arabic +
  Arabic and English + English unchanged (each card pixel-identical in the two apps; English card 2 pixel-identical to the
  pre-fix walk). Flip ~0.30 s both ways; the label is the showing face's full text (its direction test-level); Setup's
  lines in place. Two read-only Sonnet verifiers confirmed all four; wording corrected per `claims.md`.
- **Acceptance after the re-walk: 100%** (F 5/5, F4 N/A · V 4/4 · I 3/3); the other criteria carried from the 92% walk.
- **Still open, outside this fix:** the Lectures rows and the other catalog names take the app's direction by the same
  mechanism; the first-strong rule's edge (an Arabic sentence opening on a Latin term reads left to right).
- **Device state:** light EN on Home, the university student signed in; airplane off, Wi-Fi on; auto-rotate 0.

## Next action

**WAIT FOR USER COMMAND.** Wave 22 (Flashcards) walked **92%** (2026-09-29; V3 failed on BUG-020, a card's text took the
app's direction); **BUG-020 fixed and re-walked 2026-09-30: 4/4 combinations PASS, acceptance 100%** (owner request).
**Wave 22 COMPLETE and committed:** `a988a1f`, Wave 22 alone, pushed to `origin/merged` 2026-09-30 (that tree validates 1985/0/0; the 2036 below is the full working tree). Waves 20 and 21 are not committed.
Validate 2036/0/0. Open for the owner: **the Figma credential** in TEXT `1240:9847` (remove it from the file and
rotate it; one local subagent transcript holds it — masking it was refused by the permission classifier); **the two
provisional Arabic strings** (#114). The contract is re-vendored here to `f462968` (3.27.0-m1): tell the
"Contract updates" session when it next runs. Open for the owner: W18-3, review's AI glyph size, D-019's placement;
from the Wave 19 review, a Retry on the profile still loading when the profile is reloaded lands after the fresher
answer and replaces it (pre-existing, probe-proven, not recorded in KNOWN_BUGS); the task chip on other notifiers'
disposal flag. Wave 22 is the last of the 22 formulated waves: what follows is the owner's call; a walk only on `WALK`; the wave list changes only on
`FORMULATE`. Never auto-advance.
