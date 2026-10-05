# Wave 20 / Wave 21 — state audit (read-only)

**Date:** 2026-09-30 · **Branch:** `merged` · **HEAD:** `e6e6567` (= `origin/merged`, confirmed with `git ls-remote`)
**Scope:** the uncommitted Wave 20 (Edit Profile, `/profile/edit`) and Wave 21 (Settings, `/settings`) work. Wave 22
(`a988a1f`) is closed and was not touched.
**Method:**
- Five read-only Sonnet lenses: Wave 20, Wave 21, hunk attribution, docs consistency, cross-wave dependencies.
- Each lens was re-checked by its own adversarial Sonnet verifier (146 claims re-checked: 106 confirmed, 34 corrected,
  1 refuted, 5 unverifiable; 27 missed items added).
- The main session:
  - reproduced the load-bearing facts;
  - fingerprinted the tree;
  - ran format, analyze and the wave test files in a throwaway copy outside the repo.
- Severities below are the verifier-corrected ones. No Figma access was used.

Levels follow the project's ladder: SOURCE → BUILD → ARTEFACT → DEVICE → CI. "Verified now" means run or read in this
audit.

---

## Executive Summary

- **Both waves are implemented, tested, walked and uncommitted.**
  - Wave 20: W20-1…9 plus the review's 3 fixes.
  - Wave 21: W21-1…8 plus the review's fixes.
  - Every item maps to code (SOURCE).
  - Device walks: 100% for each wave (W20 on 2026-09-28, W21 on 2026-09-29), on pre-Wave-22 trees.
  - No Wave 20/21 symbol exists in any commit on any ref (`git log --all -S`).
- **Verified now (BUILD, throwaway copy of the exact tree):**
  - `dart format` on the 17 Wave 20/21 and shared Dart files: 0 changed.
  - `flutter analyze`: 0 issues.
  - Every Wave 20/21 test file passes when run alone: 7 files, 182 tests in total (breakdown under Validation
    Evidence).
- **Test deltas reconcile exactly:** W20 +30, W21 +21. 1985 (the committed W22 tree) + 51 = 2036, the full-tree run.
- **No rule violations** in the Wave 20/21 diffs:
  - no colour outside `lib/core/theme/`;
  - no inline `fontSize` or `fontWeight`;
  - no hardcoded copy or logging;
  - no purchase surface;
  - no `initState` provider mutation.
- **Attribution:** 183 text hunks and 1 binary PNG. W20 92, W21 62, MIXED 14, 1 W21 line inside the committed W22 test
  group, and 14 in `test-results.md` (a generated full-tree log). No pre-Wave-20 hunk remains.
- **The waves are separable, but not by path or by hunk.**
  - Six files hold a Wave 20 block immediately followed by a Wave 21 block, with no unchanged line between them.
  - Three untracked files must be staged by name with their wave.
  - Wave 21's walked Rank behaviour needs Wave 20's mock `PATCH /me` at runtime.
  - The working `test-results.md` must not be committed as-is.
- **Records:**
  - Wave 21's contract line cites went stale when Wave 22 re-vendored the contract.
  - Four KNOWN_BUGS status lines understate what the walks verified.
  - STORE_READINESS contradicts itself on account deletion.
  - Committed HEAD records already quote uncommitted Wave 20/21 facts; `a988a1f`'s commit body acknowledges this.
- **New latent issues (none probed, none fixed):**
  - a stale Rank value if Settings is left mid-save;
  - an unannounced Rank save-failure note;
  - a 16.5–30.5 dp skeleton jump;
  - an unrecorded change to the picker's selected-avatar ring;
  - weak spots in the tests.

---

## Wave 20 — Edit Profile

**Implementation status: COMPLETE at SOURCE.** Every Done item maps to code:

| Item | Code (working tree) |
| --- | --- |
| W20-1 mock `PATCH /me` | `lib/dev/mock_backend.dart`: `_profileEdits` :139 (per track), registration reset :215, handler :246-259, `_currentProfile` :616-650, `_profilePatchViolations` :660-689, `_patchableProfileKeys` :2218, `_emailShape` :2228; 400 via the existing `_validationFailed` |
| W20-2 action sheet (#106) | `avatar_sheets.dart:148-234` (handle 94×4 at 15; rows 44; 0.5 hairline; 13 gap; Upload photo dimmed + caption) and `_SheetRow` :245-316 |
| W20-3 picker ✕ | `avatar_sheets.dart:52-133` (`close_cross.svg` in `profileDialogClose`, 48×48 target, `PositionedDirectional`), strip inset 21 :346, :409-412 |
| W20-4 avatar block | `edit_profile_screen.dart:115` (17 + chrome 8 = 25), `_badgeOverhang` 14 :563, first label 1 :343, skeleton :753/:769 |
| W20-5 pencil | untracked `assets/icons/edit_pencil.svg` (17×17, `currentColor`), `edit_profile_screen.dart:613-627` in `avatarBadgeGlyph` |
| W20-6 gradient disc | untracked `lib/features/profile/widgets/avatar_disc.dart` (45 lines), used at `edit_profile_screen.dart:584`, `avatar_sheets.dart:498`; centre/radius re-derived by hand from the test's matrix (0.0513/0.0769, 0.7362) |
| W20-7 locked rows (#105) | `edit_profile_screen.dart:437-528`: one exclusive chain on `track`, city built once (:441) |
| W20-8 BUG-016 | `read_only_field.dart:58-66` `excludeSemantics: true` (only consumer: Edit Profile) |
| W20-9 tests | see below |
| Review fixes 1–3 | the both-blocks chain, with a regression test at `edit_profile_screen_test.dart:917-932`; the token copyWith/lerp test; the gradient derived from the frame's transform (:830-867) |

**Partial or unproven:**
- W20-6 is TEST-level only. The mock's avatars are opaque photos, and the loading and error placeholders are opaque too
  (`edit_profile_screen.dart:597-600`, `avatar_sheets.dart:510-514`). So the gradient has never been seen on a device
  (issue 12).
- The picker's selected ring moved from `decoration` to `foregroundDecoration` (`avatar_sheets.dart` ~490-497). That
  change is unrecorded and untested (issue 11).

**Tests:**
- New and changed:
  - `mock_backend_profile_test.dart`: +8, group "mock PATCH /me"; the file has 10.
  - `edit_profile_screen_test.dart`: +20 in the "Wave 20" group (17 declarations; three sit in 2-element loops, so +3);
    3 existing tests moved to the rulings.
  - `app_colors_test.dart`: +2, group "Wave 20 avatar tokens".
- Verified now, each file run alone:

  | File | Result |
  | --- | --- |
  | `edit_profile_screen_test.dart` | 62/62 pass (20 "Wave 20" names) |
  | `mock_backend_profile_test.dart` | 10/10 |
  | `app_colors_test.dart` | 41/41 (both wave token groups) |

- Strong: the mock tests through the real repository; I2 (one node, `childrenCount` 0); the sheet geometry; the picker
  ✕ in light, dark and Arabic; the gradient maths; the both-blocks regression.
- Weak:
  - The lerp check cannot catch an ignore-`other` bug for the 3 tokens that are identical in light and dark
    (issue 15).
  - The scrim test's "nothing changes" clause is vacuous (issue 17).
  - "Offline over a loaded form" finds the banner by type only.
  - The Upload-photo semantics check has no `label:`.
- Gaps:
  - Added by Wave 20 but English-only: the skeleton, offline-over-form, the university rows and the whole action-sheet
    group.
  - There is no Arabic university test.
  - There is no golden for Edit Profile, the sheet or the picker.
  - Loading, error and full-screen offline are English-only, but those tests predate Wave 20.
  - Untested mock arms: an unknown `avatarId`, a non-boolean toggle, and the registration reset.
- Coverage present: EN + AR on the avatar block and the picker ✕; light + dark on the pencil, the sheet and the ✕;
  semantics on I2; offline over the form; 400 errors in the mock.

**Validation:**
- Records: 1723/0/0 (2026-09-28, on the pre-Wave-22 base of 1693) and 2036/0/0 (the full tree, 2026-09-30T11:48Z).
- Verified now: the file runs above, and format and analyze.
- Never run: HEAD + Wave 20 alone (the expected ~2015 is arithmetic only).

**Known bugs:** BUG-016, fixed in the working tree only. Its status line still says "Not yet device-verified", although
the walk's I2 passed (issue 35).

**Design / Figma:**
- Rulings: #105 (the locked rows follow the frames) and #106 (Upload photo dimmed with its caption).
- Unchanged by design: #90 (label/box), #99 (title `h2`), the back chip's 35 dp target, and Profile's header card (still
  `Icons.edit`, no gradient).
- Logged elsewhere: the missing bottom nav (#48) and the sheet labels' `h3` (#106).
- Walk-observed and not logged (issue 18):
  - Save sits 28 under the last row, against the frame's 25;
  - the Arabic sheet rows are 48 tall, against 44;
  - the offline banner sits above the title bar (on Profile it sits under it);
  - the 44 dp sheet rows are under the 48 dp guideline;
  - the label gap is 10 (editable) against 8 (locked).
- The Upload-photo reason is spoken twice (issue 19).

**Backend / contract:**
- `PATCH /me` (`openapi.yaml:834-866` at f462968: name maxLength 100, email nullable, responses 200/400/401 only) and
  `GET /reference/avatars`.
- S45: an unknown avatar gives 400 or 404; open with Seif.
- S29: upload photo is draft.
- S34: parentPhone is absent from `GET /me`.
- S35: raw codes, now moot on this screen.
- The mock serves 6 avatars against the contract's 20.
- The mock has no 403 `account_pending_deletion` arm.

**Git state:**
- Pure Wave 20 files:
  - `lib/dev/mock_backend.dart` (all 7 hunks);
  - `edit_profile_screen.dart`, `avatar_sheets.dart`, `read_only_field.dart`;
  - untracked `avatar_disc.dart` and `edit_pencil.svg`;
  - `mock_backend_profile_test.dart`, `edit_profile_screen_test.dart`, `docs/ASSET_MANIFEST.md`.
- Wave 20 portions of shared files: see the table below.

**Remaining work (owner's call):**
- the choice of commit shape (below);
- the stale records (issues 34–40);
- the unlogged deviations;
- the ring change;
- the test gaps.

---

## Wave 21 — Settings

**Implementation status: COMPLETE at SOURCE.**

| Item | Code (working tree) |
| --- | --- |
| W21-1 the frame's switch | `settings_rows.dart:271-317` (`SettingsToggle` 48×24, knob 16 at 4, physical `Alignment`); no stock `Switch` anywhere in `lib` |
| W21-2 the 25s to ink | `settings_section.dart:25-31`, `settings_screen.dart:90/93` (10.88+8+6.12, 20.22+4.78, 18.88+6.12) |
| W21-3 row labels | `bodyLarge` (16/24 w400) in `settingsRowLabel` |
| W21-4 language order (#108) | `settings_screen.dart:152-154` (`Directionality(ltr)` pin) |
| W21-5 "الأوضاع" (#110) | `app_ar.arb:257`, generated `app_localizations_ar.dart:793` |
| W21-6 headers, BUG-018, stable node | `settings_section.dart:59-63`, `settings_rows.dart:226-250` |
| W21-7 records | STORE_READINESS, S27, S28, #46 (see issues 34, 36) |
| Tokens | `settingsRowLabel`, `settingsToggleOnTrack`, `settingsToggleOffTrack` (stand-in `#B3B3B3`, #107), `settingsToggleKnob` — defined in `app_colors.dart` (7 sites each), used only under `lib/features/settings` |
| Rank toggles | `settings_screen.dart:302-335` → `EditProfileNotifier.save` → `ProfileRepository.updateMe` (`profile_repository.dart:55-58`); one key per body (`profile_update.dart:115-123`); nothing optimistic; both rows disabled in flight |

- Gated, and correctly nothing half-built (grep of lib, pubspec, android, ios: comments only): account deletion
  (`POST`/`DELETE /me/deletion-request`, stable, no design) and `PUT /me/fcm-token` (stable, no Firebase, no product
  call).

**Questionable or approximate:**
- The Rank skeleton is 128 dp against a loaded card of about 145.5 dp in English (about 159 in Arabic), a jump of
  16.5–30.5 dp (issue 26).
- The rows re-enable before the `/me` refetch lands (issue 24).
- A stale value is possible after Back mid-save (issue 23).
- The failure note has no live region (issue 25).
- The dark OFF track `#B3B3B3` is lighter than ON `#AE87E7`. Contrast: 2.03:1 for `#B3B3B3` on `#FCFBF9` and 2.74:1
  for `#AE87E7` on `#FCFBF9`, both under 3:1. This is recorded in #107/#77 as a stand-in.
- The Mode rows were restyled despite #45's "do not polish". That is a judgement call, not a defect.

**Tests:**
- New and changed:
  - `settings_frame_test.dart`: 18, new and untracked.
  - `settings_elevation_test.dart`: +1 net; one test renamed with its assertion flipped (English stays left in
    Arabic), plus "the pin is local".
  - `app_colors_test.dart`: +2, group "Wave 21 Settings tokens".
  - `settings_screen_test.dart`: 3 tests moved to `SettingsToggle`, and the Arabic word.
  - `settings_harness.dart`: `settle: false`.
  - The `edit5_surfaces_golden_test.dart` comment and the re-captured `settings_section_dark.png` (14233 → 14369
    bytes; the heading 4 px left and ~10 px down).
- Verified now, each file run alone:

  | File | Result |
  | --- | --- |
  | `settings_frame_test.dart` | 18/18 |
  | `settings_screen_test.dart` | 31/31 |
  | `settings_elevation_test.dart` | 17/17 |
  | `edit5_surfaces_golden_test.dart` | 3/3 (Windows; includes "settings section · dark, with the school back-light") |
  | `app_colors_test.dart` | 41/41 |

- Strength: the verifier found no Wave 21 test that cannot fail. Every one names a regression it would catch (the 25s
  ±0.05 against measured baselines, knob ends in Arabic, exact semantics, a stable node id, in-flight disabling). Two
  caveats:
  - "a failed save does not move the switch" only catches an optimistic write;
  - the colour assertion reads the target decoration, not the animated paint.
- Weak: the pre-existing "server decides the value" test cannot show the switch moving, because `getMe` is a static
  stub (issue 27).
- Coverage:
  - RTL and LTR: yes, for the heading, the switch, the language pin and geometry.
  - Dark and light: yes, for labels, rows, the hairline and the golden.
  - Semantics: yes, for headers, BUG-018 and the node.
  - Offline: English only.
  - Loading and error: English only; no Retry tap.
  - OFF state: light English only.
  - The golden pins the card chrome and heading only; its stand-in row is stale (issue 28).
  - The measured-font tests have run on Windows only (issue 29).

**Validation:**
- Records: 1744/0/0 (2026-09-29, pre-Wave-22 base) and 2036/0/0 (the full tree).
- Verified now: the file runs above, and format and analyze.
- Never run: HEAD + Wave 21 alone (~2006 is arithmetic).

**Known bugs:**
- BUG-017 (open, owner-held wording, not touched): the "Hide my points" help line says the student stays listed, but
  the contract (adr-111) takes a score-hidden student off every board.
  - Fact for the owner: this build never calls `GET /leaderboard/me` (`leaderboard_repository.dart:11`, D-008). The
    harm a student can observe is removal from the boards, not a refused own-rank.
- BUG-018: fixed in the working tree only. Its status line is stale (issue 35).

**Design / Figma:**
- Rulings: #107 (switch with a stand-in OFF), #108 (English left), #110 (the hamza spelling; the frame writes الاوضاع),
  F3 test-level.
- Recorded: #109 and #111–#112.
- Unchanged by design: #45 (the Mode card), #46/S27 (two Rank switches), #48/S28 (notifications ON and disabled).
- Walk-observed and not logged:
  - taller Arabic lines (Rank rows 79 against 72);
  - the Notification caption is announced five times;
  - the mock's Rank values reset on a restart.

**Backend / contract:**
- `PATCH /me` `leaderboardVisible` / `scoreHidden` (`openapi.yaml:851-852` at f462968).
- adr-111 (`:2093-2100`, `:2198-2200`, `:2253`).
- S27 (two toggles), S28 (no notification-preference storage).
- The deletion and fcm-token endpoints are stable (`:1059-1129`, `:896-899`).
- The Wave 21 walk depended on Wave 20's mock `PATCH /me` (issue 5).

**Git state:**
- Pure Wave 21 files:
  - `settings_screen.dart`, `settings_rows.dart`, `settings_section.dart`;
  - `app_ar.arb` and `app_localizations_ar.dart` (the `settingsMode` word only);
  - `settings_elevation_test.dart`, `settings_harness.dart`, `settings_screen_test.dart`;
  - untracked `settings_frame_test.dart`;
  - `edit5_surfaces_golden_test.dart`, `settings_section_dark.png`, `docs/STORE_READINESS.md`.
- Wave 21 portions of shared files: see the table below.

**Remaining work (owner's call):**
- the BUG-017 wording;
- the commit shape;
- the stale records;
- issues 23–27.

---

## Shared Files

Only the Wave 20 → Wave 21 seam matters for per-wave commits. A combined Wave 20+21 commit can take every row below
wholesale, except `test-results.md`.

| File | Wave 20 | Wave 21 | Other | Staging Risk |
| --- | --- | --- | --- | --- |
| `lib/core/theme/app_colors.dart` | 5 tokens × 7 sites (lines 103-107, 821-844, 1526-1530, 1732-1736, 1937-1941, 2129-2133, 2495-2511) | 4 tokens × 7 sites (108-111, 845-864, 1531-1534, 1737-1740, 1942-1945, 2134-2139, 2512-2531) | W22 tokens committed, after these | 7 pure-addition hunks, each a W20 block then a W21 block with no unchanged line between. `add -p` `s` cannot split them; a partial site does not compile |
| `test/core/theme/app_colors_test.dart` | hunk 1, lines 592-639 (2 tests) | hunk 1, 640-700 (2 tests) + hunk 2, line 839 | line 839 sits inside the committed "Wave 22 Flashcards tokens" group | W20-alone: hunk 2 and the W21 group do not compile. Line 839 duplicates :679 (issue 3) |
| `.ai/audits/current/wave_state.md` | table rows 64-66; sections 1486-1597; clauses in the closing paragraph | rows 61-63; "Current wave" row additions; sections 1598-1685; clauses in the closing paragraph | :90, :108, :1829 (HEAD text) and :1833 (added) say "Waves 20 and 21 are not committed" | 4 hunks, 3 mixed; the closing paragraph (:1832-1833) mixes W20, W21 and W22 text in single lines; CRLF working copy (index LF) |
| `.ai/audits/current/device_walk_results.md` | 1262-1326 (Wave 20 walk) | 1327-1383 (Wave 21 walk) | — | One +122 hunk; the seam is a blank line |
| `.ai/audits/current/implementation_waves.md` | hunk @@ -440 (441-442) | hunk @@ -459 (462-463) | — | Hunk-separable. Both cite pre-W22 counts (1723, 1744) |
| `docs/DESIGN_ISSUES.md` | #105, #106 (4579-4631) | #46 cites (@@ -1268, @@ -1275); #107-#112 (4632-4758) | HEAD jumps #104 → #113 | Hunk 3 (+180) holds W20 then W21 with no seam line |
| `docs/KNOWN_BUGS.md` | BUG-016 (543-559) | BUG-017 (560-580), BUG-018 (581-600) | HEAD jumps BUG-015 → BUG-019 | One +58 hunk; CRLF working copy |
| `docs/seif_fight.md` | S45 row (@@ -646) + section (@@ -1623) | S27 (@@ -1192, -1202), S28 (@@ -1207, -1209, -1211) | — | 7 separate hunks; hunk-separable |
| `lib/dev/mock_backend.dart` | all 7 hunks, including header line 4 ("(read and PATCH)") | none (a runtime consumer only) | — | Wave 20 only. The header is true only with the handler hunks |
| `docs/ASSET_MANIFEST.md` | the pencil row | — | — | Wave 20 only; the row asserts the untracked SVG exists |
| `docs/STORE_READINESS.md` | — | all 6 hunks | — | Wave 21 only |
| `lib/l10n/app_ar.arb` + `app_localizations_ar.dart` | — | `settingsMode` | the second is generated | Wave 21 only. Must ride with `settings_screen_test.dart` (HEAD :504 expects المظهر). Regenerate, never splice |
| `.ai/audits/current/test-results.md` | — | — | Whole-file rewrite: the 11:48:17Z full-tree run (2036, commit `cccd2f1`, tree clean NO) | Do not commit as-is: it is older than HEAD's committed 11:52:49Z record (1985, clean) and matches no single-wave tree (issue 4) |
| Forensic `project_files_*` (untracked) | — | — | another session's, 2026-09-23; not opened | Not ignored; `git add -A` or `add .` sweeps them |

Coupled sets:
- `settings_section.dart` + `settings_section_dark.png` + the edit5 comment;
- `settings_rows.dart` + `settings_screen_test.dart` (HEAD finds `Switch` in 3 places);
- the ARB + generated l10n + that test;
- code comments + the doc IDs they cite (#105-#112, BUG-016..018, S45; issue 7).

---

## Git State

- **Branch:** `merged`.
- **`HEAD` = `origin/merged`:** `e6e6567685ad71de32865aed849d127fa3b6c6cc` (`git ls-remote`, 2026-09-30).
- **`main` = `origin/main`:** `e71e9a1`, untouched.
- **Latest Wave 22 checkpoint:** `a988a1f`, tree `d1698e7`, parent `cccd2f1`; `e6e6567` changes only `wave_state.md`.
- **Dirty entries at audit start: 32.**
  - 27 modified; 5 untracked (3 Wave 20/21 files and 2 forensic files).
  - All 32 are byte-identical at the end (sha1 snapshot).
  - During the audit, the "Flutter app icon integration" session announced it would edit, and did edit, 35 more
    files: 10 `android/app/src/main/res/**` icons, 3 `assets/launcher_icon/*`, 21 iOS `AppIcon.appiconset/*` and
    `pubspec.yaml`. They are not Wave 20/21 and were not touched here; the tree now shows 67 entries.
  - That session also created a worktree at `C:/Users/musta/AppData/Local/Temp/lu_icon_wt`.
- **Files by wave:**
  - Wave 20 only: 9 (7 tracked, 2 untracked).
  - Wave 21 only: 12 (11 tracked, 1 untracked).
  - Mixed: 8 (`app_colors.dart`, `app_colors_test.dart`, `wave_state.md`, `device_walk_results.md`,
    `implementation_waves.md`, `DESIGN_ISSUES.md`, `KNOWN_BUGS.md`, `seif_fight.md`).
  - Generated full-tree log: 1 (`test-results.md`).
  - Unrelated: 2 (forensic).
- **Hunks:** 183 text + 1 binary. W20 92, W21 62, MIXED 14, W21 line in the W22 group 1, `test-results.md` 14. No
  pre-Wave-20 hunk.
- **Commits relevant to Waves 20/21: none.**
  - `git log --all -S` finds none for `avatarDiscInner`, `settingsToggleKnob`, `_profilePatchViolations` or
    `SettingsToggle`.
  - They are referenced only in the text of `a988a1f` (its message) and `e6e6567` (its body and `wave_state.md`
    rows).
  - HEAD's `wave_state.md`:
    - `:60` and `:1562` quote "Wave 21's 1744";
    - `:1520` says "BUG-017 stays open";
    - `:90` and `:108` say Waves 20 and 21 are not committed.
  - The unreachable scratch commit `e86c79b` (Wave 22 verify) is not Wave 20/21.
- **Other worktrees (outside scope):** `.claude/worktrees/angry-antonelli-cf9094` and `jovial-bhaskara-018e57` at
  `e71e9a1` (excluded via `.git/info/exclude`). They hold old Edit Profile code and pollute repo-wide greps.

**Commit-shape facts (for a later decision, not a plan):**
- **Wave 20 + 21 together:** every file except `test-results.md` can be staged wholesale, plus the 3 untracked files by
  name. The only full-tree run (2036) covers exactly this content. This is the simplest shape.
- **Wave 20 alone:** needs a line-level split of the 6 contiguous files. Leave out `app_colors_test.dart:839` and the
  Wave 21 group. The tree has never been built.
- **Wave 21 alone:** compiles and tests green at SOURCE (its tests stub `PATCH /me`). But its mock build answers
  `PATCH /me` with a 404 (HEAD's catch-all `mock_backend.dart:540-548`), so the walked Rank behaviour cannot be
  reproduced. So the order should be Wave 20, then Wave 21.
- **Any shape:** re-validate the committed tree and regenerate `test-results.md` (the `a988a1f` precedent).

---

## Documentation Consistency

Each item is a discrepancy; the file is unchanged.

| # | Record | What is inaccurate | Truth / evidence |
| --- | --- | --- | --- |
| D1 | `KNOWN_BUGS.md:567-568` (BUG-017), `seif_fight.md:1206/:1208/:1217`, `DESIGN_ISSUES.md:1277`, `wave_state.md:1627` | `openapi.yaml` cites (2076-2083, 2181-2183, 2236, 2814-2822, 891-894) are the 3.23.0-m1 lines, unlabelled | At the vendored f462968: 2093-2100, 2198-2200, 2253, 3075-3083, 896-899. `:2076-2083` is now redemption text. Only `seif_fight.md:1193` and `DESIGN_ISSUES.md:1268` carry "at the 3.23.0-m1 pin" |
| D2 | `STORE_READINESS.md:59`, `:147` | `openapi.yaml:1054-1130` | f462968 `:1059-1129`; `:1130` is `/me/entitlements` |
| D3 | `STORE_READINESS.md:110`, `:136-143` | "no deletion endpoint", "never been filed", "BLOCKED BY CONTRACT: the actual DELETE /me" | Both endpoints are stable (adr-114); S38 was filed 2026-09-04. The same file's :33/:59/:145-149 say so. W21-7 claimed "the rest" was fixed |
| D4 | `KNOWN_BUGS.md:546` (BUG-016), `:584` (BUG-018); also committed BUG-015 `:506` and BUG-019 | "Not yet device-verified" | Walks: W20 I2 PASS (`device_walk_results.md:1287`), W21 I3 PASS "BUG-018 fixed on device" (`:1348`), W22 V1 "BUG-019 fixed on device" (`:1406`) |
| D5 | `seif_fight.md` S34 (`:1329`, `:1334`), S35 (`:1347-1353`), S29 (`:631`, `:1233` → `avatar_sheets.dart:121`); `STORE_READINESS.md:89` (`avatar_sheets.dart:126-148`) | Old frame `180:3989`; stage and education system "rendered locked"; raw codes on Edit Profile; stale line cites | After Wave 20 those rows are gone (#105); the upload row is at `avatar_sheets.dart:198-224` |
| D6 | `edit_profile_screen_test.dart:22-31`, `:128`; `edit_profile_screen.dart:60`, test `:431` | Header cites `180:3989` and "six read-only facts"; a loop over nine key names; `openapi.yaml:1277/:1302` for parentPhone | 3 (school) or 5 (university) rows; parentPhone is at `:2617/:2643` at f462968 |
| D7 | HEAD `wave_state.md:60`, `:1562`; HEAD `implementation_waves.md:478` | "+273 over Wave 21's 1744" (committed W22 text) | 1744 exists in no commit; the committed W22 tree is 1985. Acknowledged in `a988a1f`'s body |
| D8 | HEAD `wave_state.md:1520` | "BUG-017 stays open" | HEAD `KNOWN_BUGS.md` has no BUG-017 (it jumps BUG-015 → BUG-019). Acknowledged |
| D9 | HEAD `wave_state.md:82`, `:1608`; `KNOWN_BUGS.md` BUG-020; `implementation_waves.md:478`; `device_walk_results.md:1265` | 2036 / 2017 unqualified | HEAD `test-results.md` records 1985. The qualifier exists only at `wave_state.md:101`/`:1623`. Acknowledged, transient |
| D10 | `wave_state.md:90`, `:108`, `:1829`, `:1833` | "Waves 20 and 21 are not committed" | True today; false the moment either lands. `:1833` was reworded in this session's housekeeping |
| D11 | `wave_state.md:1486` | "Wave 20 — implementation (in progress, 2026-09-28)" | Row 66 says COMPLETE (the W22 heading `:1686` has the same pattern) |
| D12 | `wave_state.md:1607` vs `DESIGN_ISSUES.md:4741` | RTL university `565:14612` listed as "read over the MCP" | `DESIGN_ISSUES.md:4741` (in #111) says it was not read |
| D13 | `wave_state.md:1660` (W21 walk plan) | "reopen Settings (a fresh `GET /me`)" | Reopening does not refetch (meProvider kept alive by Home); persistence was shown by the post-save refetch |
| D14 | `wave_state.md:1646-1649` | "Red proof: 13 mutations" | The enumeration gives 12 distinct items (14 if "25s × 3" counts as 3) |
| D15 | `wave_state.md:1612`, `:1619` | "الأوضاع" called "the frame's word" | #110: the frame `549:21802` writes الاوضاع (no hamza); the hamza is the build's choice |
| D16 | `wave_state.md:1829-1838` | "Open for the owner" ×3, BUG-017 ×2, "not committed" ×2; "the 'Contract updates' session asked to be told when Wave 20 is committed" has no cited source | — |
| D17 | `implementation_waves.md:428`, `:434` | "no real university frame", "ask the designer" | Its own Done line `:441`: `180:6349` exists |
| D18 | `implementation_waves.md:494-496`, `:503-505` | "commit contract alone"; "stale `.git/index.lock`"; S37 and `quiz_fixtures.dart:1` "fixed by waves 21/22"; Owner inputs lists answered flashcard items and omits BUG-017, #114 and the Figma item | Re-vendor went in `a988a1f`; no index.lock; S37 still "PATCH /me 405" (`seif_fight.md:639`) against staging 200; `quiz_fixtures.dart:1` still "pinned 184d6ec" |
| D19 | `avatar_disc.dart:9-11` | "The gradient only shows … while nothing has loaded" | Placeholders and error widgets are opaque, so only a transparent image shows it |
| D20 | W20/W21 "format PASS" (`wave_state.md` rows 63/66; `implementation_waves.md:441`/`:462`) | Implied coverage of the waves' own new Dart files | `validate.ps1:136` formats tracked files only; the new files were checked separately (0 changed) |
| D21 | `test-results.md` (working) | commit `cccd2f1`, tree clean NO | HEAD is `e6e6567`. HEAD's own copy names `e86c79b`, an unreachable scratch commit (gc-prunable) |
| D22 | `docs/WAVE_STATUS.md` (CLAUDE.md: "wins over every other document") | Last updated 2026-09-22, 1429 tests, "unpushed"; never mentions the API→UI waves or `wave_state.md` | `wave_state.md` carries the live state; `CLAUDE.md` still says 849 tests. Two documents claim authority |
| D23 | `docs/RISKS.md` | Last reviewed 2026-09-04 | The Figma credential item is recorded only in `wave_state.md` (4 lines), not in the live risk register |

Out of scope, noted only: the "no `pending` entitlement" cite `openapi.yaml:754` in
`.claude/skills/screen-states/SKILL.md:19`, `docs/WAVE_STATUS.md:318` and `F:\level\CLAUDE.md` now lands on
`listUniversities`. The text is at `:1137` at f462968. The `seif_fight.md:84` cite is correctly labelled "pin 4's".

---

## Validation Evidence

**Verified now** (2026-09-30, BUILD, in a throwaway copy made with `git archive HEAD` plus the 30 non-forensic dirty
files, byte-identical by sha1; the repo was never built in):

| Check | Result |
| --- | --- |
| `dart format --output=none --set-exit-if-changed`, 17 Wave 20/21 and shared Dart files (including both untracked) | 0 changed |
| `flutter analyze` (the whole copy) | No issues found |
| `edit_profile_screen_test.dart` (alone) | 62 passed |
| `mock_backend_profile_test.dart` (alone) | 10 passed |
| `settings_frame_test.dart` (alone) | 18 passed |
| `settings_screen_test.dart` (alone) | 31 passed |
| `settings_elevation_test.dart` (alone) | 17 passed |
| `edit5_surfaces_golden_test.dart` (alone, Windows) | 3 passed |
| `app_colors_test.dart` (alone) | 41 passed |
| `test/features/profile` and `test/features/settings` (directory runs) | 198 and 89 passed, 0 failed |

- Copy fidelity: `pubspec.lock` and all three generated l10n files match the repo.
- Content equals the 2036 run's tree:
  - every Wave 20/21 file is byte-identical to the 14:42 snapshot taken before the 11:48Z run;
  - `find lib test assets contract tool pubspec.yaml -newer test-results.md` returns nothing.

**Verified previously (records; not re-run):**
- The full working tree: 2036/0/0, format PASS (304 tracked files), analyze 0, 2026-09-30T11:48:17Z (working
  `test-results.md`). Its expanded-reporter log cannot prove any specific test ran.
- The committed Wave 22 tree alone: 1985/0/0, clean (HEAD `test-results.md`, 11:52:49Z).
- Wave 20: 1723/0/0 (2026-09-28). Wave 21: 1744/0/0 (2026-09-29). Both on pre-Wave-22 trees that no longer exist.
- Device walks: Wave 20 100% and Wave 21 100% (Pixel 8, mock build, `main_mock.dart` blob `f189786`, unchanged). The
  evidence lives in out-of-repo scratchpads; each was re-measured by two Sonnet verifiers at the time.
- Red proofs: 23 of 27 for Wave 20, and "13 mutations" for Wave 21.

**Not verified:**
- HEAD + Wave 20 alone (~2015) and HEAD + Wave 21 alone (~2006): arithmetic only, never built.
- The combined current tree on a device: the walks predate Wave 22's merge into the same files.
- TalkBack speech: nodes were verified by uiautomator, not by a screen reader.
- The gradient disc on a device.
- The measured-font tests on Linux CI.
- The failure path of a Rank `PATCH` on a device (F3 N/A by ruling).
- The university track on Settings.

**Unknown:**
- Whether Figma-derived numbers still match the frames: no Figma access in this audit.
- Whether `e86c79b` survives `git gc`.

Known failing tests: none.

---

## Open Issues

Severity is audit severity, not a fix priority. Nothing here was fixed, staged or changed.

**Git / staging**

**A-01 · medium · W20+W21 · untracked files required by tracked hunks**
- File: `lib/features/profile/widgets/avatar_disc.dart`, `assets/icons/edit_pencil.svg`,
  `test/features/settings/settings_frame_test.dart`.
- Evidence: all three are `??`. `avatar_disc.dart` is imported by `edit_profile_screen.dart:24`,
  `avatar_sheets.dart:20` and `edit_profile_screen_test.dart:15`; the SVG is loaded at `edit_profile_screen.dart:616`.
- Why it matters: `git add -u` or `commit -a` produces a Wave 20 commit that does not compile. A missing SVG fails only
  at widget-test or device time. A missing `settings_frame_test.dart` silently drops 18 tests (2036 → 2018).
- Next: stage by explicit path with their wave, then check `git status` leaves only the forensic files `??`.

**A-02 · low (medium if split) · W20+W21 · contiguous blocks in six files**
- File: `app_colors.dart` (7 hunks), `app_colors_test.dart` (hunk 1), `wave_state.md`, `device_walk_results.md`,
  `DESIGN_ISSUES.md` (hunk 3), `KNOWN_BUGS.md`.
- Evidence: line ranges in the Shared Files table; no unchanged line at any seam.
- Why it matters: per-wave commits need a line-level split (the HEAD + insert method). A partial `AppColors` site does
  not compile.
- Next: decide the commit shape first; if split, prove each tree in a throwaway worktree.

**A-03 · low · W21 · a Wave 21 line inside the committed Wave 22 test group**
- File: `test/core/theme/app_colors_test.dart:839`.
- Evidence: `expect(one.settingsToggleKnob, …)` in "Wave 22 Flashcards tokens" (group :702). It is absent at HEAD; it
  duplicates `:679`; `a988a1f` dropped it deliberately.
- Why it matters: it is a compile error in any Wave-20-only tree, and it is misplaced.
- Next: decide whether it rides with Wave 21 or is dropped as a duplicate.

**A-04 · medium · shared · the working `test-results.md` would rewind the record**
- File: `.ai/audits/current/test-results.md`.
- Evidence: working copy 11:48:17Z, 2036, `cccd2f1`, tree clean NO. HEAD copy 11:52:49Z, 1985, clean. 14 hunks.
- Why it matters: committing it replaces a newer clean record with an older dirty one, and 2036 matches no single-wave
  tree.
- Next: validate the committed tree and commit that output.

**A-05 · medium · W21 · runtime dependency on the Wave 20 mock**
- File: `lib/dev/mock_backend.dart` (HEAD `:540-548` catch-all 404; WT `:246-259`); `settings_screen.dart:325`,
  `:334`.
- Evidence: HEAD's mock has no PATCH route. The W21 walk ran at validate 1744, which includes Wave 20, and the W21
  tests stub the repository.
- Why it matters: a Wave-21-only commit is green but its mock build cannot save a Rank toggle, so the walk evidence is
  not reproducible.
- Next: order Wave 20 before Wave 21, or note the dependency in the commit.

**A-06 · low · W21 · coupled sets**
- File: ARB + `app_localizations_ar.dart` + `settings_screen_test.dart`; `settings_section.dart` + PNG + edit5 comment;
  `settings_rows.dart` + `settings_screen_test.dart`; mock header line 4 + handler.
- Evidence: HEAD `settings_screen_test.dart:504` expects المظهر and finds `Switch` in 3 places; HEAD's mock has 0
  `PATCH`.
- Why it matters: mis-staging gives loud test or golden failures, or a false header.
- Next: stage as sets.

**A-07 · low · W20+W21 · code comments cite uncommitted doc IDs**
- File: `settings_rows.dart:166/:222/:265`, `settings_screen.dart:119/:262`, `settings_section.dart:46/:159`,
  `app_colors.dart:858`, `edit_profile_screen.dart:55/:473`, `avatar_sheets.dart:144`, `mock_backend.dart:659`,
  `app_colors_test.dart:651`.
- Evidence: the targets #105-#112, BUG-016..018 and S45 exist only in the working-tree docs.
- Why it matters: a code-only commit leaves dangling references.
- Next: keep the doc hunks with their code.

**A-08 · low · W20+W21 · "not committed" lines go stale**
- File: `wave_state.md:90`, `:108`, `:1829`, `:1833`.
- Evidence: D10.
- Why it matters: they are false once either wave lands.
- Next: same-commit edit or a sync commit (the `e6e6567` precedent).

**A-09 · info · W20/W21 · no split tree validated**
- File: —.
- Evidence: only 1985 (Wave 22) and 2036 (full tree) were ever run after Wave 22.
- Why it matters: any per-wave count would be arithmetic, not a result.
- Next: validate each committed tree.

**A-10 · info · other · forensic files not ignored**
- File: `.ai/audits/current/project_files_forensic_audit.html`, `project_files_inventory.json`.
- Evidence: `git check-ignore` rc 1.
- Why it matters: a blanket add sweeps them in.
- Next: stage by explicit path; their fate is a separate owner call.

**Wave 20**

**A-11 · low · W20 · the picker's selected ring changed, unrecorded**
- File: `avatar_sheets.dart` ~490-497.
- Evidence: `decoration:` → `foregroundDecoration:` on `_AvatarChoice`. The image is no longer inset by the 2.5 ring
  (64 → 69 dp under the ring). No record or test mentions it.
- Why it matters: a silent visual change on an owner-visible control, over the new gradient rim.
- Next: read the ring on the next device pass, or record it in #106.

**A-12 · low · W20 · the gradient disc is unproven on device**
- File: `avatar_disc.dart:12-47`, `:9-11`.
- Evidence: mock avatars are opaque; placeholders are opaque; the walk says "cannot show on the mock"; the comment
  claims it shows while loading.
- Why it matters: W20-6 is TEST-level only.
- Next: check with real (staging) avatars; keep it labelled TEST in the records.

**A-13 · info · W20 · possible fringe on opaque photos**
- File: `avatar_disc.dart:36-46`.
- Evidence: a gradient circle and a `ClipOval` at the same radius, both antialiased; no rim pixels were measured.
- Why it matters: a 1 px mint halo could read as a bug.
- Next: read the rim pixels of a mock capture if wanted.

**A-14 · low · W20 · test gaps**
- File: `edit_profile_screen_test.dart`.
- Evidence: EN-only skeleton (:785), offline-over-form (:1162), university rows (:901) and the sheet group
  (:959-1073). No Arabic university test. No golden for Edit Profile, the sheet or the picker. States EN-only
  (pre-existing).
- Why it matters: an Arabic regression on these surfaces would pass the suite.
- Next: owner decides whether to add tests or accept the gaps.

**A-15 · low · W20 · lerp check blind to ignore-`other` for 3 tokens**
- File: `app_colors_test.dart:611-645`.
- Evidence: `avatarDiscInner`, `avatarDiscOuter` and `avatarSheetDivider` are identical in light and dark; the Wave 21
  group lerps towards probes instead.
- Why it matters: the review's fix 2 is only partly effective.
- Next: compare with the Wave 21 pattern.

**A-16 · low · W20 · untested mock arms**
- File: `mock_backend.dart:215`, `:677-687`; `mock_backend_profile_test.dart:117-152`.
- Evidence: the unknown-`avatarId` 400, the non-boolean-toggle 400 and the registration reset are untested. The
  name-400 test does not assert status or that the name is unchanged.
- Why it matters: the mock is the device-walk backend and can drift.
- Next: owner decides.

**A-17 · low · W20 · vacuous test clause**
- File: `edit_profile_screen_test.dart:1060`.
- Evidence: "the scrim dismisses it, and nothing changes": Save on a clean form sends nothing anyway (:107).
- Why it matters: only the dismissal is proven.
- Next: note it.

**A-18 · low · W20 · walk deviations not logged**
- File: `docs/DESIGN_ISSUES.md`.
- Evidence: Save 28 against 25 (`edit_profile_screen.dart:392`); Arabic sheet rows 48 against 44; the offline banner
  above the title bar; the 44 dp rows under the 48 guideline; the label gap 10 against 8 (`read_only_field.dart:71`).
  These appear only in walk prose.
- Why it matters: the register is where the owner tracks design decisions.
- Next: owner decides whether to file them.

**A-19 · info · W20 · Upload-photo reason spoken twice**
- File: `avatar_sheets.dart:204`, `:221`.
- Evidence: the row's `hint` and the visible caption use the same string. It predates Wave 20 and was kept.
- Why it matters: a screen-reader user hears it twice.
- Next: check with a dump or TalkBack.

**A-20 · info · W20 · accessibility is node-level only**
- File: `avatar_sheets.dart:148-234`.
- Evidence: the walk used uiautomator only. The sheet lost its title; `_AvatarChoice` has no label.
- Why it matters: the reading-is-not-running rule applies.
- Next: owner decides on a TalkBack pass.

**A-21 · info · W20 · mock/contract deltas**
- File: `mock_backend.dart:2208-2214`; S45.
- Evidence: 6 avatars against the contract's 20 (a 20-cell scroll is unexercised); unknown avatar 400 or 404 is open
  with Seif; no 403 `account_pending_deletion` arm.
- Why it matters: the mock-walk scope is limited.
- Next: none now.

**A-22 · info · pre-existing · name-length units**
- File: `edit_profile_screen.dart` `_save`.
- Evidence: the client checks `name.length > 100` (UTF-16 units) while the contract and mock count code points. Not
  run.
- Why it matters: a possible false refusal for emoji names.
- Next: a probe if wanted.

**Wave 21**

**A-23 · low · W21 (pre-existing path) · stale Rank value after Back mid-save**
- File: `edit_profile_notifier.dart:68`, `:79` (not in the diff).
- Evidence: `if (_disposed) return …` skips `invalidate(meProvider)`. The provider is autoDispose and watched only by
  `_RankSection` (`settings_screen.dart:279`). No test references `editProfileProvider`.
- Why it matters: a minor's privacy switch can show the old value until the next `/me` refetch. Not probed.
- Next: a throwaway probe (pending Completer, pop, complete, reopen), then an owner decision.

**A-24 · low · W21 · rows re-enable before the refetch lands**
- File: `settings_screen.dart:302-335`.
- Evidence: `edit_profile_notifier.dart:70` then `:79`. The walk measured the rows live at 2.307 s with the value still
  OFF, and the switch sliding from 2.693 s (`device_walk_results.md:1342`).
- Why it matters: a fast double-flip is swallowed. There is no server divergence.
- Next: owner decides whether to keep the rows disabled until the refetch; add a window test.

**A-25 · low · W21 · Rank failure note not announced**
- File: `settings_screen.dart:308-316`.
- Evidence: a plain `Text`, no `liveRegion` (the only `liveRegion` in lib is `flashcard_study_screen.dart:263`).
- Why it matters: TalkBack users may miss that a save failed. Unverified.
- Next: a semantics probe, then an owner decision.

**A-26 · low · W21 · skeleton height mismatch**
- File: `settings_screen.dart:423-434`.
- Evidence: 128 (+1 hairline) against a loaded card of 145.5 dp in English and ~159 in Arabic, a jump of 16.5 / ~30.5
  dp. The comment says the heights are equal; `settings_frame_test.dart:459` measures nothing. The records list it as
  "Not changed".
- Why it matters: layout shift, contrary to the code's own claim.
- Next: measure loaded against skeleton in a test, then record or decide.

**A-27 · low · W21 (pre-existing test) · the "server decides" test cannot move the switch**
- File: `settings_screen_test.dart:147-165`.
- Evidence: `getMe` is a static stub (`profile_harness.dart:265-267`); the test asserts only `called(2)`.
- Why it matters: the comment overstates the test; the only real proof is the device F2.
- Next: owner decides.

**A-28 · info · W21 · golden stand-in stale**
- File: `edit5_surfaces_golden_test.dart:190-198`.
- Evidence: `_Row` is 16.5/14.5 in `titleMedium` against the real row's 16/14 in `bodyLarge`. No golden of
  `SettingsToggle`. Goldens are advisory in Windows CI.
- Why it matters: the golden pins the chrome and heading only.
- Next: none unless wanted.

**A-29 · info · W21 · measured-font tests Windows-only**
- File: `settings_frame_test.dart:28-48`, `:90-143`.
- Evidence: `closeTo(…, 0.01/0.05)` on font metrics. Ubuntu CI has never run them (`ci.yml:13-18`). capHeight is
  hard-coded.
- Why it matters: they could flake on Linux. Unproven.
- Next: watch the first Linux CI run.

**A-30 · info · W21 · walk scope**
- File: `device_walk_results.md:1327-1383`.
- Evidence: school student only. F3 N/A (ruling). F1's body is test-level. Notification caption announced 5×.
  Taller Arabic lines. Mock Rank values reset on restart.
- Why it matters: level-of-proof accuracy.
- Next: none.

**A-31 · info · W21 · BUG-017 (owner-held)**
- File: `app_en.arb:625`, `app_ar.arb:267`.
- Evidence: contradicts adr-111 (`openapi.yaml:2093-2100` at f462968). The app never calls `GET /leaderboard/me`.
- Why it matters: the owner's pending wording decision.
- Next: owner decision only. No wording is proposed here.

**Records** (details in Documentation Consistency)

**A-32 · low · W21 · stale contract line cites.** D1, D2. They matter most for BUG-017's evidence trail.

**A-33 · low · W20+W21 · KNOWN_BUGS understates verification.** D4.

**A-34 · low · W21 · STORE_READINESS self-contradiction on deletion.** D3.

**A-35 · low · W20 · S29/S34/S35 and test-header drift after Wave 20.** D5, D6.

**A-36 · low · W20+W21 · committed HEAD text quotes uncommitted facts; numbering gaps reserved.** D7–D9. The gaps are
#104→#113, BUG-015→BUG-019, and S44 as the last S-item. Acknowledged in `a988a1f`; they heal only if both waves land.

**A-37 · low · W20+W21 · `wave_state.md` internal inconsistencies.** D11–D16.

**A-38 · low · W20+W21 · `implementation_waves.md` stale plan and table rows.** D17, D18.

**A-39 · low (authority conflict) · shared · WAVE_STATUS and RISKS stale.** D22, D23. The Figma credential item is not
in the risk register. Its value was never read here.

**A-40 · info · shared · format and provenance notes.** D20, D21. HEAD's record names the unreachable `e86c79b`.

**A-41 · info · W22 (context) · `a988a1f` was never device-walked as committed.**
- Evidence: the W22 walks ran on mock blob `6047624`, the working-tree mock carrying Wave 20's `PATCH /me`.
- Assessment: no flashcard path touches those hunks, so the risk is low; stated for accuracy.

---

## Audit process notes

- **Repo:** unchanged apart from this file.
  - The 32 original entries are sha1-identical at the end.
  - HEAD, `origin/merged`, `main` and `main_mock.dart` (`f189786`) are unchanged.
  - No stage, commit, push, merge, reset, stash, restore, format write or regeneration.
- **Builds and tests:** ran only in `scratchpad/w2021a/copy` (outside the repo). No `git worktree` was created.
- **Subagent slips (disclosed):**
  - Two agents wrote 11 scratch copies of repo docs and contract snapshots to Git Bash `/tmp`
    (`C:\Users\musta\AppData\Local\Temp`), outside the repo. The main session deleted them.
  - Two verifier `grep -r` walks passed over the forensic files' contents without printing any line. They were never
    opened by name.
  - No agent read or printed the Figma credential; no Figma tool was used.
