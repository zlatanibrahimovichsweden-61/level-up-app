# Fable Style-Fitting Register — 2026-08-22

**Pass:** style fitting over the typography migration (Wave 3D), applied on top of `0451284`
(branch `merged`, == `origin/merged` at the time). The read-only audit that preceded it
(`FABLE AUDIT — TYPOGRAPHY / VISUAL RETOUCH`, 2026-08-22, chat) found the splits recorded here.
This register is the durable record of what the pass changed, what it deliberately left alone,
and what each decision rests on — so the Pixel 8 review can be run against it later with
"Review the device result against your previous style-fitting decisions."

**Not claimed:** pixel-perfect, fully visually matched, or final visual approval. Final visual
authority, in order: (1) designer source, (2) existing project design rules, (3) Pixel 8
rendering, (4) the owner's confirmation where evidence is ambiguous.

## Legend

| Tag | Meaning |
| --- | --- |
| **DESIGN-DERIVED** | Directly supported by the designer handoff (`typography-style-inter.md`, 2026-08-21 — in the owner's Downloads, **not vendored**) or a Figma node recorded in a file header. |
| **REPOSITORY-DERIVED** | Inferred from the repository: the pre-migration metrics at `d71a205` (the last commit before the scale), or a repeated implementation pattern (≥ 2 sibling widgets already agreeing). |
| **FABLE-INFERRED** | Fable's professional interpretation where neither source states the rule. Each carries a confidence and a device observation that can refute it. |
| **DEVICE-PENDING** | Intentionally unchanged until the Pixel 8 pass. |
| **USER-DECISION** | Needs the owner's (or designer's) call; not guessed. |

Pre-migration metrics below are from `git show d71a205:<file>` — what each text carried before
the scale landed, most of it transcribed from Figma frames whose node ids sit in the file
headers. Short of the frames themselves, they are the strongest evidence of "what this text
was meant to be".

---

## 1. Applied changes

### SF-01 — Offline banner: one widget, one style
- **Component:** `OfflineBanner` (core) + Login/OTP private `_OfflineBanner` (deleted).
- **Files:** `lib/core/widgets/offline_banner.dart`, `lib/features/auth/screens/login_screen.dart`, `lib/features/auth/screens/otp_screen.dart`.
- **Observed:** the core banner (13 screens) rendered `bodyMediumStrong` 14/20/500; Login and OTP carried a byte-identical private copy rendering `labelLarge` 14/18/600. Same role, two styles.
- **Changed:** core banner → `labelLarge`; Login/OTP use the core widget; private copies deleted.
- **Why:** at `d71a205` all three sites were `fontSize: 14, fontWeight: w600` — `labelLarge` is the exact-metric style; `bodyMediumStrong` had changed both weight and line height. Deleting the copies is what makes the split structurally impossible to recur.
- **Source:** REPOSITORY-DERIVED (HEAD metrics, 3/3 sites). **Confidence: HIGH.**
- **Device check:** Login offline → banner reads semi-bold, identical to Subjects offline.

### SF-02 — Inline error / failure rows: `bodyMedium` everywhere
- **Components:** `InlineFieldError` (core), Login/OTP `_InlineMessage`, Sign Up `_InlineError` (→ core), `SubmitFailureBanner`, `_PickerFailure`, quiz `_RetryRow`, quiz-setup inline error, Settings rank error. Already `bodyMedium` before this pass: Edit Profile `_SaveError`, Settings `_SectionMessage`.
- **Files:** `lib/core/widgets/form_fields.dart`, `login_screen.dart`, `otp_screen.dart`, `signup_identity_screen.dart`, `registration_chrome.dart`, `reference_dropdown.dart`, `quiz_screen.dart`, `quiz_setup_screen.dart`, `settings_screen.dart`.
- **Observed:** the same 18 px-glyph + one-line-of-copy row rendered at 12 px (`captionRegular`) in 7 places and 14 px (`bodyMedium`) in 2; Edit Profile could show both sizes at once (`_SaveError` above `InlineFieldError`).
- **Changed:** every error/failure row → `bodyMedium` 14/20/400.
- **Why:** pre-migration sizes were 14 at 8 of 10 sites (13 and 15 at the other two); the migration's own comment on `_SaveError` says `captionRegular` "would have shrunk a failure message to 12". Error copy is not a "secondary description" (the handoff's Caption usage); it is the one line the student must read.
- **Source:** REPOSITORY-DERIVED (HEAD metrics + the implementer's stated rule). **Confidence: HIGH** for consistency; **MEDIUM** for design intent — the handoff defines no error style (UD-01).
- **Device check:** Edit Profile with a rejected name: both rows the same size; Arabic validation copy legible under a registration field.

### SF-03 — Centred state messages: `bodyLarge`
- **Components:** `ShellBody` (Refer / Support shells), `TabPlaceholder` (Leaderboard / Message).
- **Files:** `lib/features/account_shells/widgets/shell_body.dart`, `lib/features/shell/screens/tab_placeholder.dart`.
- **Observed:** identical shape (48 px icon, 16 gap, centred `textSecondary` line) to `profile_screen._Message`, `edit_profile_screen._Message`, `home_screen._Failure`, `CatalogMessage` — all `bodyLarge` — but these two rendered `captionRegular` 12.
- **Changed:** → `bodyLarge` 16/24/400.
- **Why:** both were 16 px at `d71a205`; four sibling widgets agree.
- **Source:** REPOSITORY-DERIVED. **Confidence: HIGH.**
- **Device check:** Account → Refer: the message is no longer smaller than the disabled button under it.

### SF-04 — Home header name: `labelLarge`
- **File:** `lib/features/home/widgets/home_header.dart` (+ `test/goldens/home_header_bell_{light,dark}.png` regenerated — the only two goldens that changed).
- **Observed:** the migration mapped the greeting name 14/600 → `h3` 18/600 (+29 %), making the name the same style as a section title.
- **Changed:** → `labelLarge` 14/18/600.
- **Why:** exact pre-migration metrics (Figma `59:1439` / `337:5323` per the file header); handoff H3 usage is "card titles, section titles, course names", not a greeting.
- **Source:** REPOSITORY-DERIVED (Figma-transcribed HEAD value). **Confidence: HIGH.**
- **Device check:** Home header: "Welcome back" 12 / name 14 semi-bold; Arabic name on one line.

### SF-05 — MCQ option text: `labelLarge`
- **File:** `lib/features/quiz/widgets/question_option_tile.dart`.
- **Observed:** option text and the question both rendered `h3` 18/600 — the question/answer hierarchy collapsed; every tile grew ~8 px per line.
- **Changed:** → `labelLarge` 14/18/600. The question keeps `h3` (pre-migration 18/26/600).
- **Why:** pre-migration 14/w600 (Figma `308:5155` text node). Line height 21 → 18 is the only deviation — no 14/600 style with 1.5 leading exists in the scale.
- **Source:** REPOSITORY-DERIVED for size/weight; **FABLE-INFERRED** for the 18 px leading. **Confidence: HIGH / MEDIUM.**
- **Device check:** the question is visibly larger than the options; a 3-line Arabic option is readable at 18 px leading; the first line sits acceptably against the 28 px badge (pre-existing `crossAxisAlignment.start`).

### SF-06 — Quiz result "Rewards earned" eyebrow: `captionRegular`
- **File:** `lib/features/quiz/screens/quiz_result_screen.dart`.
- **Observed:** two eyebrow labels in one card — "Rewards earned" `labelLarge` 14/600, "Level progress" `captionRegular` 12/400.
- **Changed:** "Rewards earned" → `captionRegular`.
- **Why:** both were 12/400 at `d71a205`.
- **Source:** REPOSITORY-DERIVED. **Confidence: HIGH** (consistency); the designer may prefer `labelMedium` for eyebrows (UD-07).

### SF-07 — `AlertDialog` title/content follow the app's own dialogs
- **File:** `lib/core/theme/app_theme.dart` (`dialogTheme.titleTextStyle` / `contentTextStyle`); asserted in `test/core/theme/typography_discipline_test.dart`.
- **Observed:** `ProfileConfirmDialog` and `LimitSheet` render title `h2` + body `bodyLarge`; the two framework `AlertDialog`s ("Discard changes?", "Leave quiz?") rendered `headlineSmall→h3` + `bodyMedium` through the TextTheme bridge. The surface fix (`dialogTheme` colours/shape) had unified the box but not the type.
- **Changed:** `titleTextStyle: h2` (colour `onSurface`, M3's existing default for the slot), `contentTextStyle: bodyLarge` (colour `onSurfaceVariant`, likewise). No new colours.
- **Why:** title — 2/2 custom dialogs and 5 title bars (`TitledChrome`, `CatalogHeader`, Edit Profile, avatar sheet, confirm dialog) use `h2`; content — 2/2 custom dialog bodies use `bodyLarge`.
- **Source:** title REPOSITORY-DERIVED **HIGH**; content **FABLE-INFERRED MEDIUM** (the `AlertDialog` copy is two short sentences; `bodyMedium` would also be defensible).
- **Device check:** Edit Profile → back with unsaved changes: dialog title 20/700, body 16; same family as the Logout confirm dialog.

### SF-08 — Fixed-height title bars cannot wrap
- **Files:** `lib/features/catalog/widgets/catalog_scaffold.dart` (`CatalogHeader`), `lib/features/profile/screens/edit_profile_screen.dart` (`EditProfileChrome`), `lib/features/profile/widgets/avatar_sheets.dart`, `lib/features/profile/widgets/profile_confirm_dialog.dart`.
- **Observed:** four 35 px title bars held an `h2` (26 px line) `Text` with no `maxLines`; a long title (server subject names in the catalog; Arabic) would wrap to 52 px, be clipped by the `Stack`, and re-overlap the back/close control — the DV-1 failure class.
- **Changed:** `maxLines: 1, overflow: TextOverflow.ellipsis` — mirrors `TitledChrome` (core), the one bar that already had it.
- **Why:** repository pattern; zero visual change at normal lengths.
- **Source:** REPOSITORY-DERIVED. **Confidence: HIGH.**
- **Device check:** Subjects → a long chapter name in the Units header ellipsizes instead of clipping.

### SF-09 — Skeleton blocks follow the scale's line boxes
- **Files:** `lib/features/home/screens/home_screen.dart` (section-title block 18 → 24), `lib/features/profile/screens/edit_profile_screen.dart` (field-label block 22 → 18).
- **Observed:** after the migration a Home section title is an `h3` line box of 24 px and a form label a `labelLarge` line box of 18 px; the skeleton blocks standing in for them were 18 and 22, so the page shifted 6 px / 4 px per block when data arrived.
- **Changed:** blocks set to the line boxes they replace.
- **Why:** the precedent in `profile_screen.dart`'s skeleton ("90, not 82 … or the row would jump 8px the moment data arrived").
- **Source:** REPOSITORY-DERIVED (arithmetic + stated precedent). **Confidence: HIGH.** Not touched: the Home level-card block 171 and the catalog row block 56 — DP-01 / DP-02.

### SF-10 — Sign Up uses the core form primitives
- **File:** `lib/features/registration/screens/signup_identity_screen.dart`.
- **Observed:** private `_FieldLabel`, `_PlainField`, `_InlineError` duplicated core `FieldLabel`, `PlainTextField`, `InlineFieldError` line for line (same 60 px pill, radius 20, 1.17 border, same styles). Duplicates are how SF-02's split happened.
- **Changed:** the three private classes deleted; the call sites use the core widgets. `_ReadOnlyPhone` and `_DialCodePhoneField` (Sign Up-specific) untouched.
- **Source:** REPOSITORY-DERIVED (the core widgets exist for exactly this). **Confidence: HIGH.** Behaviour-neutral — same widget tree below the shell; the registration widget tests pass unchanged.

### SF-11 — `AppType` doc comment names the right guard
- **File:** `lib/core/theme/app_typography.dart` lines 14-18. It named `test/guards/project_rules_test.dart` as the guard; the locating guard is `test/core/theme/typography_discipline_test.dart` (the ratchet in `project_rules_test.dart` is pinned at 0 beside it). Documentation only.

### SF-12 — Guard extended for SF-07
- **File:** `test/core/theme/typography_discipline_test.dart`. Both themes now assert `dialogTheme.titleTextStyle` carries `h2`'s size and weight and `contentTextStyle` carries `bodyLarge`'s. Nothing weakened; the existing six tests are untouched.

---

## 2. DEVICE-PENDING (deliberately unchanged)

| Id | Item | Why not now | Capture |
| --- | --- | --- | --- |
| DP-01 | Home level-card skeleton `_Block(171)` vs card computed at 161 px (9 + 62 + 16 + 14 + 12 + 10 + 8 + 14 + 16) | Pre-existing (≈162 before the scale); 171 may be the Figma `337:5336` frame height, i.e. the card is short rather than the skeleton tall | Home, loading → loaded, light, LTR: does "Daily tasks" jump? |
| DP-02 | Catalog list skeleton `CatalogBlock(56)` vs row computed at 73 (no progress) / 77 (with) | Pre-existing (≈76 before); depends on whether rows carry a progress line | Units list loading → loaded: row shift |
| DP-03 | Settings `_SectionLoading` 128 vs the loaded Rank section | Not a type metric; needs the real row count | Settings, Rank loading → loaded |
| DP-04 | Level-card stat value "LEVEL 8" at `displayLarge` 28 ≈ 109 dp in ≈ 103 dp at 360 dp | Pixel 8 is 412 dp; the risk is on 360 dp devices | Home on a 360 dp device, or Pixel 8 with display size "Largest": ellipsis? |
| DP-05 | `SubjectCard` content ≈ 80 dp vs a 78.1 dp cell at 360 dp (`h3` name) | SOURCE arithmetic only | Subjects grid on a 360 dp device: bottom-edge overflow stripe? |
| DP-06 | Arabic multi-line at `h2` 1.3 / `h3` 1.33 leading (registration-expired title, MCQ question, tree rows) and `labelLarge` 1.29 (option text after SF-05) | Tajawal's natural leading is 1.20; no Arabic golden exists | Any 2-line Arabic `h2`/`h3`/option: line collision? |
| DP-07 | Option-tile first text line vs the 28 px badge (`crossAxisAlignment.start`) | Pre-existing geometry; SF-05 moves the line centre by 3 px | Quiz, LTR + RTL: badge/text alignment |
| DP-08 | Date-picker header `headlineLarge→h1` 24/700 via the bridge | Untested framework surface | Registration → date of birth picker, light + dark |
| DP-09 | `FieldLabel` 18/500 → `labelLarge` 14/600 on 13 label sites | DESIGN-DERIVED ("Form labels") but the largest label shrink in the migration | Sign Up / Edit Profile: label weight vs field text |
| DP-10 | Dial code `+20` / read-only phone `h4` vs input `bodyLarge` (TY-1) | KEEP verdict — hierarchy preserved; baselines coincide under M3 even leading | Login, Sign Up: `+20` vs typed digits |
| DP-11 | OTP back chip (`CircleBackButton` + `context.pop()`) replacing the AppBar | Untested navigation path | OTP → back → Login, both directions |
| DP-12 | Disabled `FilledButton` tint (primary @ 0.45) on OTP Verify / Sign Up Continue | Theme addition with no test | OTP with an empty pin, light + dark |

## 3. USER-DECISION

| Id | Decision needed | Options | Fable's default |
| --- | --- | --- | --- |
| UD-01 | Error-row size — the handoff has no error style | `bodyMedium` 14 (pre-migration) vs `captionRegular` 12 | Applied 14 (SF-02); reverting is one style name at 10 sites |
| UD-02 | List-row labels (Settings / Profile / avatar-sheet rows) at `h3` — identical to their section titles; pre-migration 18/500 has no scale equivalent | keep `h3`; `h4` 16/600; `bodyLarge` 16/400 | Left at `h3` |
| UD-03 | `TextButton` typography — the bridge gives every text button `buttonLarge` 16/600 (= the CTA) | keep (M3 convention: one label style, hierarchy by container); `textButtonTheme` → `buttonMedium` 14/600 | Left |
| UD-04 | Login subtitle 20 bold → `bodyLarge` 16/400 (title 36 → 24) | `bodyLarge`; `h2` 20/700 (exact, but ≈ the title) | Left |
| UD-05 | Onboarding tagline w500 → `h1` 700 (two bold lines; contrast by colour only) | `h1`; `h2`; `bodyLarge` | Left |
| UD-06 | Language pill 14/400 → `labelLarge` 600; quiz-type tabs 14/600 → `labelMedium` 12/500; home banner 20 → `displayLarge` 28 | as implemented vs exact-metric styles | Left (handoff usage supports tabs and banner) |
| UD-07 | Card eyebrow labels (SF-06): `captionRegular` 12/400 vs `labelMedium` 12/500 | — | Applied `captionRegular` (pre-migration) |
| UD-08 | Handoff gaps: OTP digits `h2`; flag emoji `h2`; legal links `buttonSmall`; index badge `h4` | designer to name styles | Left |
| UD-09 | Vendor `typography-style-inter.md` into the repo (e.g. `docs/design/`) so "transcribed verbatim" stays verifiable | yes / no | Not done — it is the designer's document |

## 4. NO ACTION (intentional / already justified)

| Id | Item | Justification |
| --- | --- | --- |
| NA-01 | Page titles: `h1` on hero screens (Login, Sign Up, OTP, registration) vs `h2` in chrome bars (`TitledChrome`, `CatalogHeader`, AppBar bridge) | Two roles — handoff H1 "main page titles", H2 "screen titles"; consistent within each |
| NA-02 | Section titles `h3` (`SettingsSection`, `ComingSoonSection`) | Handoff H3 "section titles" |
| NA-03 | Stat labels: `LevelCard` `labelLarge` vs `ProfileStatCard` `h3` | Different Figma frames, different pre-migration values (14 vs 18); not a migration split |
| NA-04 | Quiz-size chip `h3` | Pre-migration 18/600 exact |
| NA-05 | Catalog names `h3` (`TreeListRow`, `SubjectCard`) | Handoff H3 "course names" (layout risk tracked as DP-05) |
| NA-06 | Bottom sheets: avatar sheet + limit sheet titles both `h2` | Consistent |
| NA-07 | AppBar titles `h2` via the bridge | Matches every custom chrome |
| NA-08 | Navigation labels `navActive` / `navDefault` | DESIGN-DERIVED |
| NA-09 | Dial code / read-only phone `h4` (TY-1) | KEEP; see DP-10 |

---

## 5. Device verification checklist (Pixel 8)

Capture order is by sensitivity. "Both" = light and dark; "L/R" = LTR (en) and RTL (ar).

| # | Screen | State | Theme | Dir | Look for | Validates |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Login | idle + offline | both | L/R | banner weight; `+20` vs digits baseline; legal line 12 px with semi-bold links | SF-01, DP-10, UD-08 |
| 2 | Login | invalid phone + server error | light | L/R | error row 14 px, icon aligned | SF-02 |
| 3 | OTP | empty pin / wrong code / success | both | L/R | back chip; disabled Verify tint; digits `h2`; error row | DP-11, DP-12, SF-02, UD-08 |
| 4 | Sign Up | name + parent-phone validation errors | light | L/R | labels 14/600 vs field text 16; two error rows; read-only phone | SF-02, SF-10, DP-09, DP-10 |
| 5 | Registration (school + university) | pickers loaded; one picker failed; DOB picker open; expired view | both | L/R | `_PickerFailure` 14 px + Retry; date-picker header; 2-line Arabic expired title | SF-02, DP-08, DP-06 |
| 6 | Home | loading → loaded | both | L/R | section-title jump; level-card jump; name 14/600; "LEVEL n" ellipsis | SF-04, SF-09, DP-01, DP-04 |
| 7 | Subjects / Units / Lessons | loaded with long names; loading | light | L/R | grid-card bottom edge; header ellipsis; list-row jump | DP-05, SF-08, DP-02 |
| 8 | Quiz | question with a 3-line option, graded | both | L/R | question > option hierarchy; badge alignment; Arabic leading | SF-05, DP-06, DP-07 |
| 9 | Quiz | leave dialog; creation error; result card | light | L/R | dialog title 20/700 over body 16; error row 14; both eyebrows 12 | SF-07, SF-02, SF-06 |
| 10 | Profile → Logout dialog | open | both | L/R | ✕ clear of the title; title on one line | SF-08 (DV-1 regression check) |
| 11 | Edit Profile | loading → loaded; rejected name; discard dialog | light | L/R | label-block jump; both error rows the same size; AlertDialog family matches the Logout dialog | SF-09, SF-02, SF-07 |
| 12 | Settings | Rank loading / failed / save error | light | L/R | section skeleton vs loaded; the two Rank messages the same size; row labels vs section title | DP-03, SF-02, UD-02 |
| 13 | Account → Refer / Support; Leaderboard / Message tabs | default | both | L/R | message 16 px ≥ the button label | SF-03 |

Not requested (not useful yet): Onboarding (no change this pass beyond UD-05), Leaderboard data (no endpoint).

---

## 6. Verification results (2026-08-22, tree = `0451284` + this pass)

| Check | Result |
| --- | --- |
| `dart format` on the 23 touched files | 3 re-wrapped (`quiz_result_screen.dart`, `typography_discipline_test.dart`, one other), then clean; CRLF preserved on all 23 (line count == CR count) |
| `flutter analyze` | 0 issues |
| Goldens | `flutter test --update-goldens test/goldens/design_goldens_test.dart` — only `home_header_bell_light.png` / `home_header_bell_dark.png` changed (md5 of all 18 compared before/after); `test/goldens` then passes 18/18 without `--update-goldens` |
| Targeted suites (core/theme, auth, registration, quiz, settings, profile, home, catalog, shell) | 664 passed / 0 failed |
| `tool\validate.ps1` | format PASS · analyze PASS (0) · tests **PASS 857 / 0** · **OVERALL: PASS** (record: `.ai/audits/current/test-results.md`) |
| Guards | none weakened: the typography guard gained four assertions (SF-12); palette, l10n, lifecycle and ratchet guards ran inside the 857 |
| Verification level | **BUILD** (SOURCE → BUILD). Nothing here is DEVICE-verified — see §5 |

Process note, for honesty: the first attempt at the one-line swaps (22:31) had to be reverted
because a peer session was splitting the dirty tree into commits; the revert of
`settings_screen.dart` was done with a captured-group regex that appended a `)` (the forward
swap had the same defect) and left the file unparseable until the peer restored it from my
verbatim transcript. The re-apply used literal substitutions and the Edit tool only, followed
immediately by `dart format` + `flutter analyze`. Two 0-byte files the shell batches left in the
repo root (`$H`, `'`) were deleted.

## 7. Git / diff safety

- Branch `merged`, HEAD `0451284` (== `origin/merged`). Nothing staged, nothing committed by this pass.
- This pass's files (28): the 22 `lib/` files named in SF-01…SF-11, `test/core/theme/typography_discipline_test.dart`, `test/goldens/home_header_bell_{light,dark}.png`, this register, and `.ai/audits/current/test-results.md` (rewritten by `validate.ps1`).
- **Not this pass — concurrent, uncommitted work by the `level-up-app-1f` session (the OTP owner, at the owner's request, 23:23, after `level-up-app-11`'s commit split ended at `0451284`):** `docs/DESIGN_ISSUES.md` (#49 "glyph landed"), `test/core/theme/app_colors_test.dart` (existing file; +1 test pinning the stopwatch export's stroke to the light primary), and the `_ResendTimerPill` hunks of `lib/features/auth/screens/otp_screen.dart` (glyph at native 15×19, `colorScheme.primary` tint, `TODO(design-asset)` removed). Both sessions confirmed this attribution. In `otp_screen.dart` this pass owns exactly four hunks: the `offline_banner.dart` import, `_OfflineBanner()` → `OfflineBanner()`, the deleted private `_OfflineBanner` class (replaced by a two-line comment), and the `_InlineMessage` one-liner — everything from `_ResendTimerPill` down to the `_ResendRow` doc comment is theirs. Commit that file by hunk (`git add -p`) to keep the two change sets apart.
- Untouched and unrelated: `contract/`, `lib/l10n/`, every `*.g.dart` / `*.freezed.dart`, `pubspec.*`; the three pre-existing untracked entries (`_to_delete/`, `skills/`, `tell_claude.md`) were left as found.
- No raw `fontSize:` / `fontWeight:` / hex colour was added in `lib/` outside `lib/core/theme/` (diff-grepped; the guards agree).
