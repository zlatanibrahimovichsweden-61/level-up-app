# Level Up — Project Report (2026-09-13)

**Branch** `merged` · **HEAD** `9f415dd` (dirty tree, ~55 uncommitted files) · **Contract pin** 3.13.0-m1 (`2dca3c5`)
**Last validate** 2026-09-12 19:12 UTC — `OVERALL: PASS`, 955 passed / 0 failed / 1 skipped (`.ai/audits/current/test-results.md:10`)
**Method** three Sonnet agents (screens, design adjustments, colour/shadow) → Fable spot-audit of every load-bearing claim. Verification level of this document: **SOURCE VERIFIED** unless a row says otherwise.

---

## 1. Snapshot

| Area | State |
| --- | --- |
| Waves 0–4, 3B/3D/3E | complete; W3-1 lifecycle warning still open (`docs/WAVE_STATUS.md`) |
| Day 00–10 features | all shipped except Leaderboard (built, gated, D-008) and Mistakes replay quiz (deliberately not built) |
| Guards | colour, fontSize ratchet = 0, Bloc-only-in-quiz, no initState mutation, ARB parity — all green |
| Design register | 71 entries in `docs/DESIGN_ISSUES.md`: 4 🔴 · 9 🟠 · 12 🟡 open in summary table; many resolved by mapping |
| Responsive queue | `docs/RESPONSIVE.md` 0 / 11 applied; text-scale clamp is an untaken product decision |
| Known runtime bugs | BUG-001 fixed; BUG-002 open (Arabic overflow at 1.3× on Mistakes cards) |

---

## 2. Implemented screens

Routes are path-only (no `name:`), all in `lib/core/router/app_router.dart`. States: L = loading, E = empty, Er = error, O = offline. "—" = not applicable (no fetch). All screens are AR/EN.

| Route | Screen | Status | L | E | Er | O | Note |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `/` | OnboardingScreen | done | — | — | — | — | static |
| `/login` | LoginScreen | done | ✓ | — | ✓ | ✓ | |
| `/otp` | OtpScreen | done | ✓ | — | ✓ | ✓ | |
| `/register` | SignupIdentityScreen | done | — | — | expired view | ✓ | local step, no network |
| `/register/track` | SignupTrackScreen | done | — | — | expired view | ✓ | local step, no network |
| `/register/school` | SchoolDetailScreen | done | ✓ | — | ✓ | ✓ | pickers async |
| `/register/university` | UniversityDetailScreen | done | ✓ | — | ✓ | ✓ | |
| `/home` | HomeScreen | done | ✓ | — | ✓ | ✓ | |
| `/learn` | SubjectsScreen | done | ✓ | ✓ | ✓ | ✓ | hosts Mistakes entry |
| `/learn/subject/…` (3 levels) | SubjectTreeScreen → ChaptersScreen → LessonsScreen | done | ✓ | ✓ | ✓ | ✓ | Units/Lectures views inside tree screen |
| `/learn/mistakes` (+3 levels) | MistakesOverview / Subject / Chapters / Lessons | done 2026-09-12 | ✓ | ✓ | ✓ | ✓ | read-only; leaves inert |
| `/quiz/setup` | QuizSetupScreen | done | ✓ | — | ✓ (403 → LimitSheet) | ✓ | |
| `/quiz/:id` | QuizScreen | done | Bloc | — | Bloc | none as distinct branch | Bloc state machine, outside shell |
| `/quiz/:id/result` | QuizResultScreen | done | — | — | — | — | force-unwraps `extra`, no fallback |
| `/quiz/:id/result/review` | QuizReviewScreen | done 2026-09-08 | — | ✓ | — | — | session-scoped, zero endpoints |
| `/account`, `/profile` | ProfileScreen | done | ✓ | — | ✓ | ✓ | |
| `/profile/edit` | EditProfileScreen | done | ✓ | — | ✓ | ✓ | only stable write path (PATCH /me) |
| `/settings` | SettingsScreen | done | ✓ | — | ✓ | ✓ | notification toggles dead by design |
| `/leaderboard` | LeaderboardPlaceholderScreen | placeholder | — | — | — | — | real LeaderboardScreen built (13 files, 25 tests), **not routed** — D-008 |
| `/message` | MessagePlaceholderScreen | placeholder | — | — | — | — | no endpoint exists |
| `/refer`, `/support`, `/friends` | account shells | disabled shells | — | — | — | — | `/friends` has **no entry point** |
| `/legal/privacy`, `/legal/terms` | LegalDocumentScreen | shell | — | — | — | — | placeholder legal copy owed |
| `/track-select` | inline `_Placeholder` | **dead route** | | | | | nothing navigates to it |

**Discrepancy:** `WAVE_STATUS.md:3` quotes 943 tests; the newer validate record says 955. WAVE_STATUS is the declared truth and is 12 tests stale.

---

## 3. UI adjustments to the design

### 3.1 Design fixes applied (Day 7b and after)

| Where | Change | Source |
| --- | --- | --- |
| Bottom nav | real SVG glyphs; notched Union path via CustomPainter; selection = filled circle (was inverted) | `759196c`, #36–38 |
| Language pill | real `meteor-icons:language` glyph, corrected 36.10 / 18.05 metrics, own tokens | `6c89ef8`, #39 |
| Sign Up_2 track cards | 3D illustrations, 1px gradient border, r=9.5 radio, 35×35 `CircleBackButton` | `21b02b6`, #40 |
| Home | light palette re-derived from `59:1439`; `homeAccent` token; 3-part bell chip | `da00ee6`, #41–42 |
| OTP | back chip, stadium resend pill, stopwatch glyph, `mm.ss` | `da794de`, #49 |
| Typography | 18-style `AppType` scale, ratchet 153 → 0 | `6e2df3d` |
| Shadows | `elevationShadow` token replaces raw black on 5 sites | `e3651e6`, #47 |
| Mistakes dark | dark card/row/badge tokens corrected after misread | `d9f8d73`, #70 |
| Purchase surface | removed entirely; limit sheets say "Not now" | `5c4b855`, `ce7da9a`, #51 |

### 3.2 Deliberate divergences (contract or product rule wins)

- DoB and governorate fields added to registration; university field order changed (#2–4).
- OTP is 6 boxes not 4; dial code `+20` not `+02` (#5–6).
- Home level bar derives from client constant `kPointsPerLevel = 500`; no threshold on `/me` (#13, violates "server is authoritative" in spirit — flagged).
- Unit/chapter rows carry no progress bar; only lessons do (#16).
- No Flashcard tab, no "Learning Tools" cards, no pool-progress card, no level-up celebration (#18, #20, #31, #32).
- Quiz result: "Skipped" bucket added; level meter removed (#29, #50).
- Settings: two theme rows not three; two privacy switches not one; no Save button (#45, #46, #48).
- Quiz review and Mistakes type styles mapped to nearest `AppType` entry (#57, #68).

### 3.3 Still open visually

| Screen | Gap | Ref |
| --- | --- | --- |
| Home | flat trophy icon instead of 12 per-level medallions | #43 blocked |
| Quiz review dark | rows opaque (frame 20% alpha); foreground follows fill | #53, #54 |
| Mistakes | count caption fails AA in both palettes (2.68:1 / 3.91:1) | #71 🔴 |
| Onboarding dark | Log In button inverted relative to frame | #21 |
| Registration | free-text city / skip-school escape hatches have no frame | #44 |
| Arabic | Tajawal ships 400/500/700 only; 45 w600 call sites render Bold | RESPONSIVE.md:105 |
| Arabic | Mistakes cards overflow at 1.3× text scale | BUG-002, DEVICE VERIFIED |

---

## 4. Colour gaps

`lib/core/theme/app_colors.dart`: 67 tokens, light + dark palettes. No colour leaks outside the theme (guard-enforced; 10-file sample of dark-mode reads all go through `Theme.of(context)`). The gaps are inside the tokens.

| Token | Problem | Line |
| --- | --- | --- |
| `cardFill` (light) | `#FDFDFD`, frame says `#FCFBF9` — TODO(design) | :646 |
| `navShadow` | 8% black in **both** palettes — invisible on dark | :689, :774 |
| `elevationShadow` (dark) | `#FCFBF9` derived, not measured | :789 |
| `backChipFill` / `backChipGlyph` (dark) | fallback values, no dark frame | :780–781 |
| `podiumThirdRing`, `podiumBadgeIdle` | light values carried to dark; `337:5528` never measured | :797–798 |
| `mistakesBadgeFill` (light) | "never read", historical value | :684 |
| `mistakesCount` | `#EF4444` same both palettes, fails AA on both | :679, #71 |

**26 / 67 tokens are identical in light and dark.** Roughly 20 are semantic and must not flip (correct/wrong, medals, destructive). The rest above are unmeasured carry-overs.

**Contrast failures recorded** (`.ai/audits/current/theme.md`): 21 non-text pairs under 3:1. The ones that matter: `homeAccent` on `progressTrack` light **2.40:1** (level bar unreadable for low vision); `quizWrongBorder`, `quizOptionBorder`, `bellRing`, `secondaryButtonBorder` effectively invisible on `#232428` dark; inactive nav labels `mutedText` **2.03:1** light (logged as design decision, H-6).

---

## 5. Shadow gaps ("dead" and missing elevation)

Global theme is flat: `AppBarTheme.elevation: 0`, dialog and date-picker `surfaceTintColor: transparent`, no `CardTheme`. All elevation is per-widget through one token.

### 5.1 Shadow sites that exist (all via `elevationShadow`)

| Widget | Params | Verdict |
| --- | --- | --- |
| OTP resend pill | α 0.25, (0.5, 0.5), blur 4 | ok |
| Onboarding sheet | α 0.15, (0, −1.5), blur 9.2 | ok |
| Edit-profile avatar badge | α 0.25, (0.5, 0.5), blur 2 | ok |
| Profile header card | α 0.25, (0.5, 0.5), blur 4 — Figma `169:4609` | ok |
| Profile stat card | α 0.25, (0.02, 0.02), blur 1 — Figma `661:8571` | ok |
| Quiz AI explanation panel | α 0.25, (0.02, 0.02), blur 1.5 | ok |
| Mistakes subject card | `Material` elevation 1.06, α 0.25 | two Figma shadows collapsed into one |
| Quiz-review filter pill | elevation 2 / 0 when selected; `shadowColor` without alpha | selected state flat by design |

### 5.2 Dead or missing

| Where | Finding | Severity |
| --- | --- | --- |
| Bottom nav (`main_shell.dart:90`) | `navShadow` 8% black on both canvases; on dark `#232428` the shadow is **dead**. `elevationShadow` was flipped to cream for exactly this reason; `navShadow` was not. | 🟠 #37, #47 |
| `elevationShadow` dark | cream rim-light is a derived guess; five sites plus Mistakes card inherit it. Designer never supplied a dark shadow. | 🟠 #47 |
| `LevelCard` (Home) | **no shadow at all**. `cardFill` is documented as the "raised card surface (level card…)" and `cardFill` vs `background` measures **1.02:1 light / 1.00:1 dark**, so without a shadow the card is invisible as a surface. Sibling cards on the same token carry Figma shadows. Frame `337:5336` shadow was never recorded. | 🟠 new |
| `home_banner`, `coming_soon_section`, `catalog_scaffold`, `settings_section` | same `cardFill`, no shadow, same 1.0:1 problem | 🟡 new |
| OTP success badge SVG | `<filter>` drop shadow dropped by `flutter_svg` | 🟡 #28 |
| `track_school.svg` | `feGaussianBlur` shadow renders as a crisp grey duplicate, not a blur | 🟡 DESIGN_ISSUES:735 |
| Mistakes card dark | dark frame's own shadow values still owed | 🟡 #69 |

Theme audit verdict, verbatim: "any component that forgets its shadow becomes literally invisible as a surface" (`theme.md:513–527`). `LevelCard` is that component.

---

## 6. Fable audit notes

- **Checked directly:** dead `/track-select` (0 references), leaderboard not routed, `/friends` unlinked, signup screens have no network call (so "no loading" is correct), 955-test record and date, Tajawal weight files (400/500/700), `LevelCard` decoration (no `boxShadow`), `navShadow` painter wiring, contrast rows in `theme.md`, light==dark token count (recount agrees at 26).
- **Corrected from agent output:** signup identity/track "loading not found" reclassified as not applicable, not a coverage gap.
- **Not verified this session:** any Figma value (Figma MCP is view-only / unauthenticated). Every frame claim above is quoted from repo docs, not re-read from the canvas.
- **Highest-value next actions:** (1) ask the designer for the dark shadow spec and let `navShadow` follow `elevationShadow`; (2) decide whether `LevelCard` floats; (3) fix `WAVE_STATUS.md` test count; (4) delete `/track-select`; (5) take the 1.3× text-scale clamp decision.
