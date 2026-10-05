# Design issues & design ↔ contract gaps

> Living list of everything in the Figma that blocks or conflicts with the Flutter build.
> Share with the **designer** (and Seif where the contract is involved). Each item has:
> what's wrong, where (Figma node / screen), why it matters, the fix we need, and — where a
> placeholder already exists in code — the exact `file:line` + `TODO(design)` marker to grep.
>
> Figma file: `P6044i0giD9TmdQ7C2AmLq` · Contract: `contract/openapi.yaml` (commit 184d6ec — v3.0.0-m1)
> Rule of thumb: **the contract wins**. Where the design lacks a required field, we build it
> anyway and flag it here so the design catches up.

## Severity
🔴 Blocking (breaks a required flow) · 🟠 Important (works, but wrong/incomplete) · 🟡 Minor / confirm

## Summary

| # | Issue | Sev | Owner | Code marker |
|---|---|---|---|---|
| 1 | ~~Figma export disabled → can't export brand assets~~ — **RESOLVED**, all 3 landed | ✅ | — | — |
| 2 | `dateOfBirth` field missing from BOTH registration screens (contract-required) | 🔴 | Designer + Seif | `TODO(design)` ×3 |
| 3 | University `governorateId` missing from University Registration (contract-required) | 🔴 | Designer | `TODO(design)` |
| 4 | University field order breaks the University→Faculty→Year data cascade | 🟠 | Designer | built by cascade |
| 5 | OTP screen shows **4** digit boxes; contract requires **6** | 🟠 | Designer | built as 6 |
| 6 | Phone prefix shows `+02`; Egypt is `+20` | 🟠 | Designer | built as +20 |
| 7 | Referral / Invitation Code field has no backend field in the contract | 🟠 | PM + Seif | `TODO(contract)` |
| 8 | Login "Create New Account" implies a direct-registration path that can't exist | 🟠 | Designer | Day-3 fix |
| 9 | Legal URLs (User Agreement/Privacy/Cookie) not provided | 🟡 | Product/Legal | `TODO(legal)` |
| 10 | ~~No in-app theme toggle although a full dark theme exists~~ — **RESOLVED** (Day 8 Settings) | ✅ | — | `theme_provider.dart` |
| 11 | Student phone re-shown on Sign Up_1 (already bound to token) | 🟡 | Designer | built read-only |
| 12 | Dark-mode primary accent flips green→purple — confirm intentional | 🟡 | Designer | — |
| 13 | Level-progress bar has no threshold to progress toward | 🔴 | Seif + Designer | `TODO(contract)` |
| 14 | ~~Learn Units/Chapters/Lessons frames unreachable~~ — **RESOLVED**, screens reconciled | ✅ | — | — |
| 15 | Subject-card caption is 8.56dp — below a readable minimum | 🟡 | Designer | built at 10 |
| 16 | Units/Chapters rows show a % progress the contract cannot supply | 🔴 | Seif + Designer | `tree_list_row.dart` |
| 17 | Search field drawn on all 3 drill-down screens, placeholder reads "Search Subjects" | 🟡 | Designer | not built |
| 18 | University Lectures draws a **Flashcard** quiz-type tab the contract has no value for — ✅ **built 2026-09-29** as a non-quiz-type tab (API→UI Wave 22, owner ruling) | 🟠 | Seif + Designer | `quiz_type_tabs.dart` |
| 19 | Arabic renders Latin digits (1, 2, 3) — confirm ٠١٢ was not intended | 🟡 | Designer | `tree_list_row.dart` |
| 20 | University Home "Learning Tools" cards have no endpoint in M1 | 🟠 | PM + Seif | `home_screen.dart` |
| 21 | Onboarding dark "Log In" button is the inverse of the dark Login button | 🟠 | Designer | built as Login |
| 22 | Onboarding dark border is purple; the token is green in both themes | 🟡 | Designer | token kept |
| 23 | Sheet dark fill is `#232628`; every neighbouring token is `#232428` | 🟡 | Designer | frame value kept |
| 24 | Five near-identical greys across two frames → consolidated to one token | 🟡 | Designer | `bodyMuted` |
| 25 | No dark OTP-success frame exists (same as Home / Learn) | 🟡 | Designer | theme-derived |
| 26 | Copy typo "Achive" in BOTH onboarding frames | 🟡 | Designer | shipped "Achieve" |
| 27 | Onboarding draws no language pill, though Login and Success both do | 🟠 | Designer | pill added |
| 28 | `flutter_svg` cannot render the success badge's `<filter>` drop shadow | 🟡 | Designer | shadow absent |

---

## 1. ✅ RESOLVED — asset export was blocked, and no longer is
**Was:** the file had *export disabled* on a **View-only** seat, so `download_assets` refused and
every piece of brand art shipped as a Material icon placeholder.

**Now:** re-verified with `download_assets` on Day 00 — it returns both SVG and PNG for all three
blocked nodes. No seat or file-permission change was needed on our side; whatever was blocking it
has been lifted. All three landed:

| Asset | Node | File | Bytes |
|---|---|---|---|
| Onboarding illustration | `337:15166` | `assets/images/onboarding_illustration.svg` | 189,450 |
| OTP success badge | `82:1598` | `assets/images/success_badge.svg` | 4,017 |
| Bird logo | `82:849` | `assets/images/bird_logo.svg` | 3,875 |

Both `TODO(design-asset)` markers are deleted (`login_screen.dart`, `otp_screen.dart`), the
`Icons.flutter_dash` and `Icons.check_circle` placeholders are gone, and all three render through
`flutter_svg`. `test/core/theme/app_colors_test.dart` asserts the three files exist and are
non-empty, so a future `.gitkeep`-only regression fails a test rather than shipping.

**One rendering caveat, see #28:** `flutter_svg` drops the badge's `<filter>` drop shadow.

**Note:** national flags were never affected — handled by the `country_flags` package.

## 2. 🔴 `dateOfBirth` missing from both registration screens
**Where:** School Registration (`337:5269`) and University Registration (`337:10373`).
**What:** neither screen has a date-of-birth field. **Contract requires `dateOfBirth`** for both
`SchoolRegistration` and `UniversityRegistration` (`registration` will 400 `validation_failed` without it).
Many users are **minors**, so DoB is also product-critical.
**Fix we need:** designer adds a **Date of birth** picker to both registration screens.
**Meanwhile in code (Day 3, built — contract wins):** a rounded date picker styled to match the
surrounding fields, placed directly under each subtitle.
- `lib/features/registration/widgets/date_of_birth_field.dart:10` — the widget (`TODO(design)`)
- `lib/features/registration/screens/school_detail_screen.dart:125` — School usage (`TODO(design)`)
- `lib/features/registration/screens/university_detail_screen.dart:113` — University usage (`TODO(design)`)

No minimum age is enforced client-side (many students are minors — the server owns that rule);
the range is simply "not in the future, within 100 years".

## 3. 🔴 University `governorateId` missing
**Where:** University Registration (`337:10373`) — shows only **City**, no Governorate.
**What:** contract's `UniversityRegistration` **requires `governorateId`** (and `cityId`).
Without governorate, city can't be filtered correctly and register 400s.
**Fix we need:** designer adds a **Governorate** dropdown above City on the university screen.
**Meanwhile in code (Day 3, built):** `lib/features/registration/screens/university_detail_screen.dart:202`
(`TODO(design)`) — placed **above** City, because `/reference/cities` needs a `governorateId` for
Egypt (it 400s without one), so City stays gated until Governorate is answered.

## 4. 🟠 University field order breaks the data cascade
**Where:** University Registration (`337:10373`). **What:** design order is Faculty → Academic Year
→ City → University Name, but faculties belong to a **university**, so **University must be selected
first** to load its faculties, then the faculty's years. As drawn, Faculty appears before University.
**Fix we need:** reorder to **University → Faculty → Academic Year** (or confirm we gate Faculty/Year
until University is picked, keeping the visual order).
**Decided in code (Day 3):** we follow the **data cascade**, not the drawn order. The screen renders
Date of Birth → University → Faculty → Academic Year → Governorate → City. Keeping the drawn order
would leave the student staring at two disabled fields above the one that unlocks them.
Faculty is disabled until a University is chosen, Academic Year until a Faculty is; changing either
clears everything below it. **Designer: please confirm or send a reordered frame.**
`lib/features/registration/screens/university_detail_screen.dart` (class doc explains the deviation).

**Addendum 2026-09-24 (API→UI Wave 04). The light frame already has the cascade order.**
`125:2336` (light, read for the first time) draws **University name → Faculty → Academic Year →
City**, the same order the build uses. Only the dark frame `337:10373` draws Faculty first and
University last. So the question is no longer "reorder the design". It is: **please make the dark
frame match the light one.** Nothing to build either way. The build's order is not a deviation from
the light frame.

## 5. 🟠 OTP boxes: 4 vs 6
**Where:** OTP screens (`82:1171` etc.). **What:** design draws **4** code boxes; the contract's
`otp/verify.code` is **exactly 6 digits**. **Fix:** designer updates the OTP UI to 6 boxes.
Built as **6** in code (contract wins).

## 6. 🟠 Phone country code `+02` vs `+20`
**Where:** Login (`82:819`) + Sign Up_1. **What:** the chip shows `+02`; Egypt's dial code is `+20`.
Looks like a typo. **Fix:** designer corrects to `+20`. Built as `+20` in code.

## 7. 🟠 Referral / Invitation Code has no backend
**Where:** Sign Up_1 ("Referral Code (Optional)" / "earn points together"). **What:** neither
register body accepts a referral/invitation code. **Fix we need:** PM + Seif decide — is this M1
scope? If yes, Seif adds a contract field; if no, remove it from the design.
**Meanwhile in code:** the field is shown and collected but **never submitted**, marked `TODO(contract)`.

## 8. 🟠 "Create New Account" flow
**Where:** Login (`82:819`). **What:** the button implies a direct registration path, but the
contract is **phone-verify-first** — you cannot register without an OTP first (the new-vs-existing
fork happens at `otp/verify`). So "Create New Account" must funnel to the same phone→OTP entry.
**Fixed in code (Day 3):** the button no longer pushes `/register` (which always dead-ended on the
registration expiry guard, since no `registrationToken` exists yet). Login **is** the phone-entry
screen, so the button now runs the same `requestOtp` → `/otp` flow as *Send OTP*
(`lib/features/auth/screens/login_screen.dart` — see the `_submit` doc comment).
**Still needed from the designer:** confirm the intended copy. As built, the two buttons do the same
thing, which is correct per the contract but reads oddly — this may want a single CTA, or copy like
"Sign in or create an account".

## 9. 🟡 Legal URLs are placeholders
**Where:** `lib/features/auth/screens/login_screen.dart:37–39` (`TODO(legal)`).
**What:** User Agreement / Privacy Policy / Cookie Policy point at `levelup.example/...`.
**Fix we need:** product/legal supply the real URLs.

**Addendum 2026-09-24 (API→UI Wave 01) — the WORDING differs too, and is also legal's call.**
Figma `82:1086` (read verbatim via `get_design_context`): *"By Continue to join or sign in, you
agree to Level Up's User Agreement, Privacy Policy, and Cookie Policy."* — the three document names
in `#E67E22`, Inter Regular 14, the rest `#384F47`. The app ships `legalPrefix` =
*"By continuing, you agree to our"* (`app_en.arb:36`; AR `app_ar.arb:19`) followed by the same three
names. The frame's sentence is ungrammatical ("By Continue") and names the brand; the shipped one
is grammatical and does not. **Not changed:** consent copy for minors is not the build's to reword
in either direction. **Fix we need:** product/legal approve one sentence (EN + AR) alongside the URLs.

## 10. ✅ RESOLVED (Day 8) — the theme toggle landed in Settings
**What:** a full **dark** theme existed in Figma and in `AppColors` from Day 0, but no screen had a
control to switch themes, so `MaterialApp.themeMode` was pinned to `ThemeMode.light` and **half the
palette was unreachable on a device**.

**Resolved 2026-08-07** by Settings' **Mode** section (Figma `176:1840`). `themeModeProvider`
(`lib/core/providers/theme_provider.dart`) is shaped exactly like the existing `localeProvider` — a
plain `Notifier`, light by default, no persistence across launches yet. `app.dart` watches it.
Nothing about either palette changed; the switch is what was missing.

**Two options, not the frame's three** — see #45 below, and `seif_fight.md` **S26**.
**Not `ThemeMode.system`**: the frame draws a choice between canvases, not a follow-the-OS option.

## 11. 🟡 Student phone re-shown on Sign Up_1
**What:** the student's phone is already proven and bound to the `registrationToken`; showing it as
an editable field is redundant. Built **read-only / pre-filled**. **Fix:** designer confirm it should
be read-only (not editable).

## 12. 🟡 Dark-mode primary flips green→purple
**What:** light primary is green `#384F47`, dark primary is purple `#AE87E7` (not a shade of the
same hue). Implemented faithfully. **Fix:** just confirm this hue flip is intentional, not a leftover
from the School(green)/University(purple) accent.

## 13. 🔴 Level-progress bar has no threshold to progress toward
**Where:** `lib/features/home/widgets/level_card.dart:8` (`TODO(contract)`), constant at
`lib/features/home/widgets/level_card.dart:20`. Figma Home `337:5303`, level card `337:5336`.

**What:** the card shows a progress bar from the current level to the next one, captioned
"2,450 / 5,000" in the frame. `GET /me` returns `points`, `level` and `badges` — but **not the
threshold for the next level**, so there is nothing server-side to draw the bar from.

The two available sources disagree:
- the **contract** says levels are "1–12, thresholds every 500 points" (so level 8 → 9 would be
  4,000, and the card's own "LEVEL 8 / 2,450" is itself inconsistent — 2,450 is level 5 under that
  rule);
- the **design** shows "/ 5,000", which is the post-level-12 **badge** cadence (first badge at
  11,000), not a level threshold.

**Built as:** `LEVEL {level}` and the points balance are rendered EXACTLY as `/me` returns them —
never recomputed. Only the bar's fill and the "x / y" caption are derived, from a documented client
constant `kPointsPerLevel = 500` that follows the contract, not the mock. The fraction is clamped,
so if the constant is wrong the bar is merely full or empty — nothing a student is scored on moves.
The frame's literal "/ 5,000" is deliberately NOT hardcoded.

**Fix we need — one of:**
1. *(preferred)* Seif adds the next-level threshold to `GET /me` (e.g. `nextLevelPoints`, or a
   `levelProgress { current, next, earned }` block) so the client derives nothing at all; or
2. Seif confirms 500/level is authoritative and static, and the designer corrects the frame's
   "/ 5,000" caption and its sample figures.

Until then the bar is the only number on Home the server did not supply.

## 14. ✅ RESOLVED — Learn drill-down frames, now confirmed
**Node ids (confirmed by the owner):**
- Units — **`337:5894`** ("Learn(Units) for school student")
- Chapters — **`337:6047`** ("Learn(Chapter) for school student")
- Lessons — **`337:6143`** ("Learn(lessons) for school student")
- shared row — **`337:5926`** · shared header — `337:6038`

*(Original problem, kept for the record: the Figma MCP addresses nodes only by exact id, and its
page index truncates at ~20 top-level nodes — the screen frames are not in it — so the three
frames could not be found by name. Ids had to come from the owner.)*

**Verified and reconciled (Day 5, second pass).** The derived screens were close on chrome but
wrong on the row, so the row was rebuilt from `337:5926`:

| | Frame | Was derived as | Now |
|---|---|---|---|
| Row surface | `#27282C`, 0.5px `#FCFBF9` border, radius 16, h 78 | fill only, radius 10.7 | `ext.catalogCardFill` + `ext.fieldBorder` border, radius 16 ✔ |
| Leading | 40dp numbered circle, `rgba(39,40,44,.2)`, Cairo Bold 16 | *(absent)* | added — `ext.cardFill`, locale-aware digits ✔ |
| Name | Inter SemiBold 16 / 21, `#FCFBF9` | Bold 16 | SemiBold 16, `ext.textPrimary` ✔ |
| Progress | bar h 6, track `#2E2D32`, fill `#AE87E7` + trailing label | *(absent)* | `ext.progressTrack` + `cs.primary`, **lessons only** — see #16 |
| Chevron | 28dp | 18dp | 28dp, RTL-mirrored ✔ |
| Title | "{parent} Units/Chapter/lessons" | static "Units"/"Chapters"/"Lessons" | parameterized (`unitsTitleFor` etc.), bare key kept as the deep-link fallback ✔ |

Every colour still resolves through `colorScheme`/`AppColors` — **no new tokens were needed**, and
a grep of `lib/features/catalog` for `Color(0x`/`Colors.`/hex returns nothing.

**Two copy points to confirm (built as noted, not blocking):**
1. The Chapters frame titles itself **"Cell Biology Chapter"** (singular) and Lessons
   **"…lessons"** (lower-case). Built as **"Chapters"/"Lessons"** — these are lists, and the other
   two levels are capitalised. Say the word and it flips.
2. The header draws a **back chevron on Subjects**, but Subjects is a tab root — nothing to pop.
   Rendered only when the navigator can actually pop (absent on Subjects, present on the other
   three). Confirm, or tell us where a Subjects chevron should lead.
   (`lib/features/catalog/widgets/catalog_scaffold.dart` — `CatalogHeader` class doc.)

## 16. 🔴 Units and Chapters show a progress % the contract cannot supply
**Where:** Units `337:5894`, Chapters `337:6047` — every row draws a progress bar and a trailing
"80%". Code: `lib/features/catalog/widgets/tree_list_row.dart` (`progress` is nullable and why).

**What:** in `SchoolSubjectTree`, `questionCounter` exists on **lessons only**. Units and chapters
carry `id`, `name` and their children — nothing else. So there is no server value to draw those
bars from, and the "80%" in the frame has no source.

The only way to produce it client-side is to sum the descendant lessons' counters, which is exactly
what the contract forbids: `questionCounter` is display-only, "render the number and a clamped
fraction and nothing more". A summed percentage would also be *wrong* the moment the server scopes
or weights progress differently from a naive lesson-count average — and it is the kind of number a
student reads as authoritative.

**Built as:** the bar + label render on **Lessons only**, from that lesson's own `questionCounter`.
Units and Chapters rows are name + chevron. Nothing is faked.

**Fix we need — one of:**
1. *(preferred)* Seif adds `questionCounter` to the unit and chapter nodes of `SchoolSubjectTree`,
   so the client renders three levels the same way and derives nothing; or
2. the designer drops the bar from the Units and Chapters rows.

**Also note:** the Lessons frame's trailing label is a rounded **"80%"**; we render the server's own
**"{answered} / {total} questions"** there instead — strictly more information, no extra client
math, and it matches the Subjects card. Confirm if the percentage was deliberate.

## 17. 🟡 A "Search Subjects" field is drawn on all three drill-down screens
**Where:** `337:5894`, `337:6047`, `337:6143` — each carries the same search field as Subjects,
placeholder text and all.
**What:** the placeholder still reads **"Search Subjects"** on the Units, Chapters and Lessons
screens, which is wrong copy at every one of those levels — it looks like an unreviewed
copy-paste of the Subjects frame.
**Built as:** search is on **Subjects only** (which is also what the Day-5 brief scopes it to).
**Fix we need:** designer confirms whether these three screens should really have search; if yes,
supply the correct placeholder for each level and we will wire the same client-side filter.
**Update 2026-09-25 (API→UI Wave 09):** the LIGHT Chapters frame `135:1270` reads **"Search Chapters"**,
the right copy for that level. The dark `337:6047` still reads "Search Subjects". The question stands, since
search is still not built below Subjects.
**Update 2026-09-25 (API→UI Wave 10):** the LIGHT Lessons frame `135:1485` ALSO reads "Search Chapters", and the
dark `337:6143` reads "Search Subjects". So the light placeholder is a copy-paste too, not per-level copy: no level
below Subjects has confirmed search copy.

## 15. 🟡 Subject-card caption is 8.56dp
**Where:** Subjects `337:5748` — the "216 / 480 questions" caption, `Cairo SemiBold 8.558px` on a
402dp-wide frame, so that is literal dp, not a scaled export.
**What:** 8.5dp is below any readable minimum on a real phone, and this caption carries the only
progress number on the card. **Built at 10dp** (`lib/features/catalog/widgets/subject_card.dart`).
**Fix we need:** designer confirms 10dp, or supplies an intended size.

## 18. 🟠 The Lectures tab row draws a "Flashcard" the contract has no value for
**Where:** University Lectures `180:5208`, tab row `180:5337` — tabs read
**Normal · Flashcard · Midterm · Final · Practice**.
Code: `lib/features/catalog/widgets/quiz_type_tabs.dart`, `lib/features/quiz/models/quiz_type.dart`.

**What:** the tab row is built from the server's `UniversitySubjectTree.quizTypes`, whose enum is
`[normal, midTermRevision, finalRevision, practicalRevision]` — **there is no flashcard value**.
Flashcards are a separate concern in the contract: a `flashcardSubscription` entitlement, with **no
content endpoint at all in M1**. So a Flashcard tab could not be populated even if we drew it; it
would be a tab that does nothing, in the one row a student uses to pick what they are about to be
quizzed on.

**Built as:** tabs come from `tree.quizTypes`, in server order, Flashcard omitted. A subject that
does not offer `practicalRevision` correctly shows no Practice tab (the mock harness serves three
such variations on purpose, so this is visible on device).

**Fix we need — answer two questions:**
1. **Seif:** is flashcard content in M1? If yes, which endpoint, and is it a `quizTypes` value or a
   separate entry point? If no, the tab should come out of the design.
2. **Designer:** if Flashcard stays, where does it lead, given there is nothing to open?

> **✅ Built 2026-09-29 (API→UI Wave 22, owner ruling).** Question 1 was answered by the contract:
> two flashcards operations have been `stable` since 3.13.0-m1 (`getFlashcardsForLecture`,
> `setFlashcardSelfGrade`), and they are a separate entry point, NOT a `quizTypes` value — the enum
> is still the closed four. The owner ruled the Lectures "Flashcard" tab the entry point: it is built
> as a tab that is not a quiz type (`LecturesTab` = `QuizTab(QuizType)` | `FlashcardsTab`,
> `quiz_type_tabs.dart`), **second**, as `180:5208`, `349:15962` and `337:11059` place it
> (`180:5354` alone puts it fourth). It lists only the lectures with `hasFlashcards`, each keeping its
> own number, with no progress bar or caption (the contract has no flashcards progress; owner:
> none invented); it is hidden when no lecture has cards (the contract: "the surface should not be
> offered at all"); a subject with no quiz types but with cards opens on it. A row opens Flash Card
> Setup (`1234:8797`). Not yet device-checked: whether five labels fit a 375 dp phone at full size
> in Inter (the widget tests measure the test font).

**Also in this frame, two smaller ones:**
- **Label for `practicalRevision`.** The frame says **"Practice"**; the wire word is *practical*
  (as in a practical/lab exam), which is a different thing in a medical faculty. Built as
  "Practice"/"عملي" — confirm which is meant.
- **Row label format.** The frame shows a rounded **"80%"**; we render the server's own
  **"{answered} / {total} questions"**, matching school's lesson rows (see #16). One format across
  both tracks, and no extra client math either way. Confirm.
- **Search field `180:5232`** carries the placeholder **"Search Chapters"** on a screen that lists
  lectures — the same unreviewed-paste problem as #17, one level over. Not built.

## 19. 🟡 Arabic renders Latin digits
**Where:** every numbered row (`337:5926`, `309:5713`) and every counter caption.
**What:** the numbers go through `MaterialLocalizations.formatDecimal`, i.e. the locale's own
formatter — the app never interpolates raw digits. For Flutter's Arabic locale data that formatter
produces **1, 2, 3**, not **١، ٢، ٣**. The Day-5 note assumed Arabic-Indic; it does not render that
way, and hardcoding the glyphs would mean overriding the locale rather than following it.
**Fix we need:** the designer confirms which digits Egyptian students should see. If Arabic-Indic is
wanted, that is a deliberate app-wide numbering choice (counters, points, levels, leaderboard —
not just these rows) and we will apply it in one place.

## 20. 🟠 University Home's "Learning Tools" cards have nothing behind them
**Where:** University Home `125:2373` — a section between Daily Tasks and Continue Learning, with
five cards (Flash Card, Normal EX, Midterm, Final, Practices) and a premium crown.
Code: `lib/features/home/screens/home_screen.dart`.

**What:** these are shortcuts into quiz creation and flashcards. Quiz creation (`POST /quizzes`) is
Day 7 and flashcards have no M1 content endpoint (#18), so every one of the five leads nowhere
today. The crown also implies a paywall state that this section does not receive — entitlements come
from `GET /me/entitlements`, and nothing in the frame says which of the five are gated.

**Built as:** a header + "Coming soon" card, exactly like Daily Tasks / Continue Learning / Top
Student, and only on the university track. Not drawn as five tappable cards that swallow a tap.

**Fix we need:** confirm the section survives to M1, and which of the five are behind
`baseSubscription` vs `flashcardSubscription`, so the crown reflects a real entitlement.

> **2026-09-29 (API→UI Wave 22).** "Flashcards have no M1 content endpoint" is no longer true (#18),
> but the owner ruled the Lectures tab the flashcards entry point, so this section stays the plain
> placeholder; only its code comment was corrected. A crown or any entitlement marking stays out
> (purchase-silent).

**The tiles' surface, read 2026-09-17 and recorded here rather than built** (edit3.md #43). The
owner's decision is that the section keeps the plain placeholder until an endpoint exists, so these
values have nowhere to land — but they were measured, and re-measuring them later costs a Dev Mode
session that this record makes unnecessary. `Frame 1000002992`–`96`, 110 × 85, radius 8:

| Canvas | Fill | Border | Effects |
| --- | --- | --- | --- |
| Light | `#FCFBF9` | 0.1 `#4B675E` | drop (0.02, 0.02) blur 5.4 black 25% |
| Dark | `#27282C` | — | drop (0.02, 0.02) blur 0.8 black 25% · **inset** (1, 1) blur 4 `rgba(255,255,255,0.25)` · **inset** (−2, −2) blur 4 black 25% |

If these are ever built, the dark pair is a new token rather than a reuse of
`pillTrackInsetShadows`: that one is a single black inset, and this is a black/white PAIR at a
diagonal offset. It is **not** the file's only non-black inner shadow, as an earlier draft of this
paragraph claimed — `scopeSelectedInsetShadows` already ships `rgba(255,255,255,0.6)`,
`scopeTrackInsetShadows` ships `rgba(207,179,255,0.1)`, and `otpTimerInsetShadows` ships
`rgba(198,198,198,0.25)`. What is unusual here is only the pairing, not the colour.

**Also noted (Day 7):** the university frame's Continue Learning row reads **"12 lecture left"**
where school reads "lesson". That noun lives inside the section's *content*, which is quiz-history
data we deliberately do not invent — so it has nowhere to render today. Marked at the call site
(`TODO(day7)`) so whoever builds the real card picks the noun by track instead of hardcoding
"lesson".

## 21. 🟠 The dark "Log In" button is the exact inverse of the dark Login screen
**Where:** Onboarding dark `337:15650`. **What:** it is drawn as a **cream `#fcfbf9` fill** with a
`#0e0e0e` label and an `#ae87e7` border. The dark Login screen's secondary button (`login_screen.dart`)
is the opposite: `ext.fieldFill` (translucent dark) + `ext.textPrimary` (cream) +
`ext.secondaryButtonBorder`. These are two consecutive pre-auth screens, so the inversion is visible
in a single tap.

**Why we read it as a paste, not an intent:** the same dark frame also leaves the status-bar clock
(`337:15149`) as **black text on the `#232428` background** — unreadable, and certainly not
deliberate. Both look like the light frame's values pasted onto the dark canvas.

**Built as:** the established Login pattern, so the two screens match.
**Fix we need:** confirm. If cream really was deliberate, it is a one-line change here — but then
Login should change too, and that is a separate decision we did not take on your behalf.

**Addendum 2026-09-24 (API→UI Wave 01 re-walk) — the premise needs re-reading.** This entry reads
the dark Login's secondary button as translucent, but that describes the BUILD. The dark Login FRAME
draws it cream too: `get_design_context` on `337:15652` gives `337:15730` = `bg #FCFBF9`, label
`#0E0E0E`, border `#384F47` 0.5 — the same inversion as `337:15650`. So both dark frames agree on a
cream-filled secondary CTA, which weakens "a paste, not an intent". Measured on a Pixel 8 the build's
dark button is the canvas `#232428` with a border. **Still not changed** — the question stays the
owner's/designer's, now with two frames of evidence for cream.

## 22. 🟡 That button's border is purple in the frame, green in the token
**Where:** `337:15650` border `#ae87e7`; `ext.secondaryButtonBorder` is `Brand.greenPrimary` in
**both** themes, sourced from dark Login `337:15652`. Same copy-paste family as #21.
**Built as:** the existing token (green). **No second border token was added** — one accent
disagreement should not fork the palette.
**Fix we need:** confirm green, or change the token once and let both screens follow.

## 23. 🟡 The sheet's dark fill is `#232628`, one digit off every neighbour
**Where:** `337:15643` — `rgba(35,38,40,.2)`. Every other dark surface in the file is `#232428`
(`rgba(35,36,40,…)`). The difference is the green channel: **38 vs 36**, i.e. 2/255 — invisible.
**Built as:** the frame's own value, verbatim, in `AppColors.sheetFill`.
**Fix we need:** if this was a slip, say so and we collapse it onto the existing dark surface value.

## 24. 🟡 Five near-identical greys; consolidated to one token
**Where:** onboarding + success frames introduce `#111`, `#7c7c7c`, `#858585`, `#ececec` and
`#000000` alongside the already-approved `#0e0e0e` / `#2c2c2c` / `#696969` / `#dcdcdc` / `#b3b3b3`.

**Built as:**
- `#000000` ("Level Up", light) → **`ext.textPrimary`** (`#0e0e0e`). 6/255 apart.
- `#111` ("Successful", light) → **`ext.textPrimary`**. 3/255 apart.
- `#7c7c7c` (success subtitle) and `#858585` (onboarding tagline) → **one** new token
  `ext.bodyMuted`, light value `#858585`. They are 9/255 apart and mean the same thing: muted body
  copy on the cream canvas. `#ececec` is its dark value.

**Fix we need:** confirm one muted grey. If the two really are meant to differ, tell us which
surfaces get which and we will split the token — but three tokens for 9/255 is how a palette rots.

**Addendum 2026-09-24 (API→UI Wave 03, School registration).** The School Registration subtitle
(`125:536`) is `#7C7C7C` too, so it now uses `bodyMuted` like the success subtitle. It had been
`textSecondary` (`#2C2C2C`), 80/255 too dark. One new data point for the designer: the **dark**
frame's subtitle (`337:5291`) is `#D6D6D6`. `bodyMuted`'s dark value is `#ECECEC` (the tagline),
22/255 lighter. So the dark subtitle is now slightly lighter than drawn. Before this change it was
`#DCDCDC`, 6/255 off. If muted subtitles should be `#D6D6D6` in dark, `bodyMuted` dark moves, not a
new token. The other wizard subtitles (Sign-up identity, track, University) still use
`textSecondary`. University is Wave 04. Identity and track have no wave of their own.
**Wave 04 (same day):** University registration's subtitle (`125:2361`) is `#7C7C7C` too and now
uses `bodyMuted`. Its dark frame (`337:10395`) draws `#DEDEDE`, a third dark value next to School's
`#D6D6D6` and the tagline's `#ECECEC`. Sign-up identity and track still use `textSecondary`.

## 25. 🟡 No dark OTP-success frame exists
**Where:** `155:786` and `82:1596` are both light; there is no dark variant in the file. Same
situation already noted for Home and Learn (see the comments in `app_colors.dart`).
**Built as:** the screen renders in dark through the theme — every value it uses is a token, so
nothing dark-only was invented.
**Fix we need:** a dark success frame whenever the standing "missing dark frames" set is drawn.

## 26. 🟡 "Achive" — a typo in BOTH onboarding frames
**Where:** `459:43887` / `459:43877` — the tagline reads "Study. Compete. **Achive.**"
**Built as:** **"Achieve"**. A design typo must never become user-facing copy, least of all on the
first screen a student ever sees. `app_en.arb` carries the correction and the onboarding widget test
asserts the misspelling never renders.
**Fix we need:** correct it in the frame so the two stop disagreeing.

## 27. 🟠 Onboarding has no language pill, but the next screen does
**Where:** `337:15146` / `459:43873` draw no language control. Login (`82:819`) and OTP success
(`155:809`) both do.
**What:** onboarding is now the app's FIRST screen (route `/`). A student who opens the app in the
wrong language has no way to change it until they have already tapped through to Login — on a screen
whose entire job is to be understood.
**Built as:** the shared `LanguagePill`, top-end, over the illustration, inside `SafeArea`.
**Fix we need:** confirm placement, or supply the intended treatment over the illustration.

## 28. 🟡 The success badge renders without its drop shadow
**Where:** `82:1598`. The exported SVG carries the shadow as an SVG `<filter>` element, which
`flutter_svg` does not implement — it logs `unhandled element <filter/>` and draws the shape only.
**What:** the scallop and checkmark are exact; only the soft shadow underneath is missing. Barely
perceptible against the cream canvas, which is why it was not worked around.
**Fix we need — either:** (a) it does not matter, confirm and we close this; or (b) if the shadow is
wanted, we can add it as a Flutter `BoxShadow` — but then the SVG should be re-exported *without* the
filter so the two do not double up.

**The shadow's actual values, recorded 2026-09-20 so answering (b) needs no re-read.** edit5 item
#53 asked for this and explicitly asked for **no change**, which is what happened. The `Vector`
inside the badge is `#22C55E` and carries a drop shadow at **(2, 1.5), blur 4, black 25%** — the
same in BOTH canvases, unlike every other surface in this wave, which is itself a small argument
that it was never restyled for dark rather than deliberately matched.

Two things make this a designer question rather than an implementation one. The filter is inside
the asset, so adding a Flutter shadow without a re-export double-draws it; and the badge's export
already pads its canvas by the shadow's own bleed (`inset[-1.79% -4.17% -3.93% -1.39%]` = 8dp per
axis, which is why the widget is sized 152 × 148 for a 144 × 140 shape). A re-export without the
filter changes that padding, and therefore the widget's size, so the two have to move together.

---

## 29. 🟠 The result screen has two buckets; a quiz can end with three

**Where:** result `159:1964` / `309:6375` — **Correct** and **Wrong**, side by side.

**What:** the contract separates `answeredCount` from `totalQuestions` precisely because
*"unanswered questions are recorded unanswered (not counted wrong)"*. A student who finishes a
10-question quiz after 8 answers with 5 correct got **5 correct, 3 wrong and 2 skipped** — and the
frame has nowhere to put the last two. Filling Wrong from `totalQuestions - score` would print 5 and
call two questions they never reached mistakes.

**Built as:** a third **Skipped** card, rendered only when `answeredCount < totalQuestions`, so a
fully-answered quiz still matches the frame exactly.

**Fix we need:** a three-bucket layout, or confirmation that Skipped folding into a footnote is
preferred. The two-card row gets cramped at three on a small screen.

---

## 30. 🟡 The limit sheet says "Daily"; the cap is weekly, and its bar has no data

**Where:** `199:2335` / `225:6634` / `225:7001`.

**Two separate things:**
1. The heading family says *"Daily Limit Reached"*. The contract says *"Free plan: 50 questions per
   WEEK"* and the error code is `weekly_question_limit_reached`. We ship **weekly** copy.
2. The sheet draws a **QUESTIONS 50/50** progress bar. Nothing in the contract exposes questions
   used or the cap — the 403 arrives with no numbers at all. Same situation as the setup screen's
   pool card (#31), so the bar is **not built**.

**Also:** the CTA reads **"Upgrade To Premium"**. The glossary is explicit that `base_subscription`
is never called "premium" (nor "plan", nor "pro"). Shipped as neutral **"Upgrade"** copy pending a
wording decision.

**Fix we need:** confirm weekly; drop the bar or tell us where its numbers come from; and an
approved CTA string that is not "Premium".

**Update 2026-09-04:** the CTA question is superseded by #51 — adr-049 removed the button entirely,
so there is no upgrade string to approve. Items 1 (weekly) and 2 (the bar) still stand.

---

## 31. 🟠 The setup screen's pool card and points chip have no data behind them

**Where:** setup `135:1622` / `309:5771`.

- **QUESTION POOL PROGRESS — "45 out of 100 questions, 55 remaining in pool"** (`146:2293`). No
  contract field exposes a per-scope pool size or a student's consumption of it. `POST /quizzes`
  only reveals the pool was too small *after the fact*, via `422 not_enough_questions`.
- **"Questions: 10 · Points: +30"** (`146:2343`). The contract awards `0 or 1` per question, so a
  10-question quiz can award at most 10. The chip also contradicts itself — it reads "10" while
  the 30-question size is the one selected in the frame.

**Built as:** both omitted.

**Fix we need:** drop both, or specify the endpoints that would feed them.

### The pool card's elevation, recorded 2026-09-20 so it is not re-read later

edit4 item #45 is the same card seen from the elevation side, and it is **BLOCKED on the
same thing** — `seif_fight.md` S15. The spec is written down here rather than lost, so that
whoever builds it when S15 resolves does not have to go back to Figma:

`Frame 5`, 363 × 127, radius 15.

| Canvas | Fill | Shadow | Glass | Back-light |
| --- | --- | --- | --- | --- |
| Light | `#FCFBF9` | (0.5, 0.5) blur 4 black 25% | — | — |
| Dark `337:6275` (uni `349:15412`) | `#27282C` @20% | the same black shadow | **G12** — frost 73 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion **0.11** · splay **0.59** | B4 `348:7592` (uni B12 `349:15376`), 100 × 14 at (4, 6.81) |

When S15 resolves: add `poolCard*` tokens to `AppColors`/`AppElevation` in the edit1 style
with these citations and build it with `ElevatedSurface`. G12's dispersion and splay are not
shared with any other node in the file, so it needs its own `GlassStyle` rather than G5.

---

## 32. 🟡 No level-up or badge celebration state exists, but the contract announces both

**Where:** result `159:1964` / `309:6375`.

**What:** `QuizSummary` carries `leveledUp: bool` and `newBadge: bool`, both **required**. The
server goes to the trouble of telling the app that a student just crossed a level or earned a badge,
and the frame has no state that says anything about it — the result screen is identical either way.

Confirmed by inspecting the frame: there is no variant, no overlay, no alternate rewards card.

**Built as:** both fields parsed, nothing rendered (owner decision — no celebration UI this ticket).

**Fix we need:** a level-up state and a badge state for this screen, or confirmation that the Home
level card is the only place either is acknowledged.

---

## 33. 🟡 The quiz option tile has no "selected but not yet confirmed" state

**Where:** options container `308:5152`.

**What:** the frame draws three presentations — idle (`308:5153`), the student's wrong choice
(`308:5158`) and the revealed correct answer (`308:5166`). There is no design for the state between
tapping an option and tapping Confirm, which is the one the student spends the most time looking at.

**Built as:** Material's selection convention in existing tokens — the primary accent as a thicker
border and a filled badge. No new colour was invented.

**Fix we need:** a selected-state design, or confirmation that the accent treatment is right.

---

## 34. 🟡 Only LIGHT quiz frames exist

**Where:** the whole Day 7 set — setup `135:1622`, quiz `159:845`/`159:1695`/`159:1852`, result
`159:1964`, limit `199:2335`.

**What:** the Day 7 brief says dark variants live in a sibling "Dark mode" group, but the document
has exactly **one** page (`0:1`) and no dark quiz frame was found on it. This is the Home/Learn
situation (#12-family) in reverse.

**Built as:** light values Figma-verbatim; dark values reuse already-approved dark tokens
(`catalogCardFill` for the option surface, `progressTrack` for the divider). The five **semantic**
tokens — correct/wrong fills, borders and badge — are deliberately identical in both palettes, for
the same reason as `successBadge`: a correctness signal must not flip colour with the theme.

**Fix we need:** dark quiz frames, or confirmation that the reused tokens are right.

---

## 35. 🟡 The quiz frames draw the bottom nav bar; the quiz is not a tab

**Where:** every Day 7 frame includes the 5-tab nav bar.

**What:** `/quiz/setup`, `/quiz/:quizId` and the result route live **outside** the nav shell — a
routing decision that predates Day 7 (taking a quiz is a full-screen task). Rendering the nav bar
would let a student tab away mid-question into a session they cannot return to, since quiz state is
in memory only.

**Built as:** full-screen, no nav bar. Noted rather than treated as a bug.

---

## Code markers to grep
Run these to find every design-linked placeholder in the code:
```
grep -rn "TODO(design-asset)" lib/   # brand assets awaiting export
grep -rn "TODO(design)"       lib/   # design gaps built to the contract
grep -rn "TODO(contract)"     lib/   # fields with no backend (referral)
grep -rn "TODO(legal)"        lib/   # legal URLs
```

---

## 36. ✅ RESOLVED — the five nav-bar glyphs were Flutter Material icons

**Where:** nav bar `59:1264` (component set) — variants `59:1263` Home · `59:1260` leaderboard ·
`59:1259` learn · `59:1262` message · `59:1261` Account. Code: `lib/features/shell/main_shell.dart:41-47`.

**What:** the shell renders `Icons.home / leaderboard / menu_book / chat_bubble / person` — five
placeholders standing in for the real glyphs while export was blocked
(`TODO(design-asset)` at `main_shell.dart:67`). Every one of them is a different shape from the
frame. The design mixes two icon sets: **MingCute filled** (`user_2_fill` for Account, and the
same family for Home / Learn / Message) and **Material Symbols** (`material-symbols:social-leaderboard`
— a rosette/medal, nothing like Flutter's bar-chart `Icons.leaderboard`).

**Status: RESOLVED (assets landed).** Export is working again (see #1), so all five were pulled and
committed as `currentColor` SVGs:

| Tab | Asset | Figma node | viewBox |
|---|---|---|---|
| Home | `assets/icons/nav/home.svg` | `59:1007` › icon/footer/home | 0 0 18 18.75 |
| Leaderboard | `assets/icons/nav/leaderboard.svg` | `59:1043` material-symbols:social-leaderboard | 0 0 24 24 |
| Learn | `assets/icons/nav/learn.svg` | `59:1031` icon/footer/course/off | 0 0 16 20 |
| Message | `assets/icons/nav/message.svg` | `59:1205` icon/footer/notification/off | 0 0 20 17.9495 |
| Account | `assets/icons/nav/account.svg` | `59:1254` icon/footer/account/off | 0 0 24 24 |

There is **no separate on/off glyph** — the design keeps one shape per tab and only changes its
fill, so each SVG paints `currentColor` and is tinted at the call site with `flutter_svg`'s
`colorFilter`. `pubspec.yaml` now lists `assets/icons/nav/` explicitly (Flutter asset dirs are not
recursive).

**Wired 2026-08-04 (Day 7b A1).** `main_shell.dart` now paints all five through `flutter_svg` with
a `colorFilter`, fitted `BoxFit.contain` into the frame's 24×24 slot — **not** forced square, since
Home is 18×18.75 and Message 20×17.9495 and both stretch if boxed. The `TODO(design-asset)` marker
is deleted and `Icons.*` no longer appears in the file. Guarded by ten nav goldens
(`test/goldens/nav_bar_*.png`).

**Fix we need:** none from the designer. Confirm only that mixing MingCute + Material Symbols in
one bar is intentional — **still open**.

---

## 37. ✅ RESOLVED — the bar was a flat rectangle; the design is a notched sheet

**Where:** `Union` boolean op inside every nav variant (`59:1000` on the Home variant).
Code: `lib/features/shell/main_shell.dart:51-57`.

**What:** the frame's bar is a single Union of a **64×64 circle** and a **375×96 rounded rect**, so
the Learn tab sits in a raised bump that is *part of the bar's outline*, with the bar's corners
rounded and a drop shadow underneath. The build is a plain `Container` with a 0.5px top
`BorderSide` — no notch, no corner radius, no shadow — and the elevated centre is faked with a
separate circle that overlaps a square bar. That is the "curve over the Learn tab is different".

Exact geometry (normalised to a 375×111 box, y=0 at the top of the bump):

```
M187 0 C198.426 0 208.452 5.99 214.113 15
H345 C361.569 15 375 28.4315 375 45
V111 H0 V45 C0 28.4315 13.4315 15 30 15
H159.887 C165.548 5.99 175.574 0 187 0 Z
```

- bar top edge `y = 15`, bar height **96**, total **111**
- corner radius **30**
- notch: circle **r = 32** centred at **(187, 32)** — i.e. horizontal centre, rising **15px** above
  the bar; tangents at `x = 159.887` and `x = 214.113`
- fill `#FCFBF9` (= `ext.background` light) with a drop shadow (filter bounds x −15, y −13,
  405×141 around the 375×111 box → roughly `blur 20, y-offset 4, black ~8%`)
- the Learn circle is **r = 26** concentric with the notch → a **6px** ring of bar showing around it

**Built 2026-08-04 (Day 7b A2).** `main_shell.dart` paints the shape with a `CustomPainter` and
clips the ripple to it with a `CustomClipper<Path>`. The 0.5px top border is gone.

`navBarPath()` rebuilds the outline **parametrically** rather than replaying the export scaled by
`width / 375`: scaling x alone turns the notch into an ellipse on a tablet and breaks concentricity
with the fixed r=26 centre button, so instead the radii and the bump stay fixed and only the
straight runs grow. At 375pt the two agree to within Figma's own rounding of the centre (187 vs
187.5). One derived value: the frame gives the notch geometry and the 96 bar height but no label
baseline, so all five labels share one row anchored to the centre button.

**Open question 2 — the shadow — ✅ RESOLVED 2026-09-18 (edit2 #2).** The 2026-09-16/17 elevation
re-read measured both canvases off the `Union` itself rather than off the export's filter bounds,
and they differ in colour *and* in blur, which is why one estimate could never have covered both:

| Canvas | Node | Offset | Blur (Figma) | Colour |
|---|---|---|---|---|
| Light | `59:1264` | (0, 2.144) | 16.08 | `rgba(184,184,210,0.5)` — a cool grey-lilac, not black |
| Dark | `349:16719` | (0, 2.144) | 12.5 | `rgba(124,58,237,0.1)` — a lavender haze |

Both now live in `AppElevation.navBarShadows` and are painted by
`lib/core/widgets/elevation/figma_shadow_painter.dart`, with the CSS sigma conversion (σ = blur/2)
and the knockout that stops the shadow filling the notch's inner curve. The `~8% black, blur 20,
y+4` reading was wrong on both counts — it was an estimate off the export's filter bounds, and 8%
black is invisible on the dark canvas, which is exactly why Figma puts a purple glow there instead.
`AppColors.navShadow` and its `TODO(design)` are **deleted**.

---

## 38. ✅ RESOLVED — selecting the Learn tab fills the circle; the build tinted the icon

**Where:** `Search` frame — `59:1003` (idle) vs `59:1084` (selected).
Code: `lib/features/shell/main_shell.dart:107,125-134`.

**What:** the centre tab is the one tab whose **background** carries the selected state:

| | circle r=26 fill | glyph | label |
|---|---|---|---|
| idle | `#F3F1F8` (lavender) | `#B3B3B3` | `#B3B3B3` |
| selected | `#4B675E` (green) | `white` | `#4B675E` |

The build paints the circle `ext.cardFill` in **both** states, adds a 0.5px border the frame does
not have, and recolours the glyph to `cs.primary` — the inverse of the design. The other four tabs
do behave as built (glyph + label `#B3B3B3` → `#4B675E`, plus the 26×2 top rule).

`#F3F1F8` has no token yet — it is the first use of a lavender wash in the light canvas.

**Inverted 2026-08-04 (Day 7b A3).** The circle now animates `navCentreIdleFill` → `navAccent` and
the glyph goes `mutedText` → white; the 0.5px border the frame does not have is deleted. The dark
equivalent of `#F3F1F8` was measured off `348:6686` as `#3E3E3E`, so the token pair
`navCentreIdleFill` is real in both palettes.

`test/features/shell/nav_centre_tab_test.dart` states the rule directly: the accent lands on the
CIRCLE, and the glyph never takes the accent at all.

**Fix we need:** confirmation that the idle lavender is a real design token rather than a one-off —
**still open**, but no longer blocking.

---

## 39. ✅ RESOLVED (glyph + box) — the pill used a Material globe; the design is a translate glyph

**Where:** `Button / Light` **`82:1093`** (on Log in `82:819`), icon child `82:1100`
`meteor-icons:language`, label `82:1098`.
Code: `lib/core/widgets/language_pill.dart` **and** a duplicate `_LanguagePill` at
`lib/features/auth/screens/login_screen.dart:310-342`.

**What:** three separate deviations in one small widget.

1. **Icon.** The build uses Flutter's `Icons.language` (a filled globe/meridian). The frame uses
   **`meteor-icons:language`** — the 文A translate glyph, stroke-drawn, not a globe. Exported and
   committed as `assets/icons/language.svg` (`currentColor` stroke, viewBox `0 0 20.129 20.129`,
   `stroke-width 1.67742`, round caps/joins).
2. **Label.** The build shows the *other* language's endonym — `switchLanguage` = "العربية" in
   `app_en.arb`, "English" in `app_ar.arb`. The frame shows a **2-letter code, `EN`**, in a 19×21
   box. It also reads as the **current** language, not the one being switched to (the Log in frame
   is an English screen and the pill says EN) — see the open question below.
3. **Metrics and colours.** Measured off the frame:

| | design | built |
|---|---|---|
| pill | 78.13 × 36.10, radius 18.05 (full) | hug, radius 24 |
| fill | `#FCFBF9` | `ext.background` ✔ (= `#FCFBF9` light) |
| border | `#4B675E` | `ext.secondaryButtonBorder` = `#384F47` ✗ |
| icon | 20.13, stroke `#384F47` | `Icons.language` at 18, `ext.textPrimary` |
| label | `#384F47`, ~14/21 | `ext.textPrimary`, 14 |
| padding | 14.47 start / 14.47 end, 10.07 gap | 14 / 14, 6 gap |
| position (Log in) | end inset ≈ 24, top 64.89 | — |

Note the design deliberately uses **two different greens**: border `#4B675E`, content `#384F47`.
The build collapses both onto `#384F47`.

**Fixed 2026-08-04 (Day 7b B).** Deviations 1 and 3 are closed:

- `assets/icons/language.svg` replaces `Icons.language` at 20.13, tinted via `colorFilter` and left
  **stroke**-drawn — the 1.67742 hairline is the whole look.
- Height 36.10, radius 18.05 (a true stadium — exactly half the height), 14.47 start/end inset,
  10.07 icon→label gap, label 14/21.
- Border is the lighter `#4B675E` in light and **absent in dark**: `languagePillBorder` is nullable
  per canvas, so dark draws none instead of substituting one. Content is `languagePillContent`
  (`#384F47` / `#FCFBF9`) — the build had collapsed the frame's two greens onto one.
- The duplicate `_LanguagePill` in `login_screen.dart` is deleted; all six call sites use the shared
  widget.

**Deviation:** the frame's **78.13 width is not applied.** It was measured around the 2-letter "EN"
label, and the wording deliberately stays "English" / "العربية" (Day 7b assumption 3), which does
not fit in 78.13 at 14px. Everything else holds and the width hugs.

**Fix we need — still open:** deviation 2, the **label**. The frame shows a 2-letter code reading
the CURRENT language; the build shows the endonym of the language you switch TO. Confirm which is
intended, and the Arabic form (`ع`? `AR`? `عر`?). Nothing was changed here — an ARB edit was
explicitly out of scope.

---

## 40. 🔴 Sign Up_2 — the stand-in art is RESOLVED; the SELECTED card is unreadable (2.19:1)

**Where:** **`82:1785`** `Sign Up_2` (light) — the light twin of `337:15947`, which
`signup_track_screen.dart` was built against. Cards `125:862` / `125:959`, back button `90:208`.
Code: `lib/features/registration/screens/signup_track_screen.dart`, route `/register/track`.

**Not a routing bug.** The screen exists and sits in the right place:
`/register` (identity) → `context.push('/register/track')` (`signup_identity_screen.dart:90`) →
`/register/school` | `/register/university`. What is wrong is everything visual.

| element | design (`82:1785`) | built |
|---|---|---|
| track card | 363×112, radius **25**, fill `#FCFBF9`, **1px gradient** border `#384F47` → `#95CDBB` (top-right → bottom-left) | radius 20, `ext.fieldFill`, flat `ext.fieldBorder` 1.17px |
| card art | **98×98 3D illustration** — a stack of books / a graduation cap | `Icons.menu_book_outlined` / `Icons.school_outlined` at 32 |
| card label | x=107, ~20 semibold | 20 w600 ✔, but no 107 offset (icon is only 32 wide) |
| radio | circle **r=9.5**, 1px `#384F47` outline, no fill | `Icons.radio_button_unchecked` |
| back button | **35×35 circle**, fill `#FCFBF9`, no stroke, holding `weui:arrow-filled` (15×30 chevron, `#4B675E`) | bare Material `IconButton(Icons.arrow_back)` |
| header block | title + subtitle at y=146, 20px side inset | 24px inset |

The chevron is exported and committed (`assets/icons/chevron.svg`, `currentColor`, points **right** —
mirror it for back / let RTL flip it).

**Illustrations: RESOLVED 2026-08-03.** Exported by the owner and committed as
`assets/images/track_school.svg` (99×101) and `assets/images/track_university.svg` (98×97). Note
`track_school.svg` carries a Figma `feGaussianBlur` drop-shadow filter that `flutter_svg` cannot
render — see `day7b_design_fixes_brief.md` C1 before shipping it.

**Rendered 2026-08-04 (Day 7b C).**

- Illustrations in a 99-wide leading slot so the label starts at x=107, drawn with **no**
  `colorFilter` — the only two assets in this pass rendered untinted.
- **`track_school.svg` is edited relative to the owner's export.** `flutter_svg` logs
  `unhandled element <filter/>` and paints the `<g opacity="0.53" filter="url(#filter0_f_771_4476)">`
  shadow paths *crisp* at 0.53 × 0.25 black — a hard grey duplicate offset right and below the
  books, confirmed by rendering the asset at 6×. That group and the now-unused `<defs>` filter are
  deleted; the illustration is complete without them. Same class of problem as #28.
- Card 112 tall, radius 25, page-fill surface, 1px gradient `#384F47` → `#95CDBB` top-end to
  bottom-start in light and **none** in dark (`trackCardBorderStart`/`End` are nullable and both
  null there). Flutter has no gradient `Border`, so the outline is a gradient-filled box with the
  surface inset 1px.
- Radio is a real r=9.5 hollow ring.
- New shared `core/widgets/circle_back_button.dart`: 35×35 filled circle, no stroke, chevron
  mirrored for back and un-mirrored under RTL.
- Side inset 20.

**Deviation:** the frame's **363 card width is not applied** — 363 + 2×20 exceeds the 375 frame, so
the inset (explicit in the brief) wins and the card stretches to the available width.

**Fix we need — both still open:**
1. The **selected** state of the track card. The frame draws both cards unselected, so the shipped
   `cs.primary` @ 8% + 2px border + filled radio is a Day-2 invention. It was **deliberately left
   untouched** — replacing one guess with a better-looking second guess would only move the problem.
2. ~~Whether the ring around the back button is a shadow or a stroke.~~ **✅ RESOLVED 2026-09-18
   (edit2 #8): it is a shadow.** `90:208` carries a drop shadow at (0.02833, 0.02833), blur 1.3,
   black 25% and no stroke at all — so "built with no stroke" was right, and the chip was simply
   missing its shadow. It is now `AppElevation.backChipShadows`, and on the light canvas the chip
   is visible for the first time: `#FCFBF9` on a `#FCFBF9` page with nothing else was literally
   invisible except for its chevron.

~~Also unmeasured: the **dark** back chip.~~ **✅ MEASURED 2026-09-17, built 2026-09-18 (edit2 #8).**
There are **two** dark chips, not one, and neither is the old `#232428` fallback:

| Where | Dark surface | Glass |
|---|---|---|
| Learn, Mistakes, Setup, Result, Leaderboard, Settings, Edit Profile (`404:7424`) | `#27282C` @ 20% | **G5** frost 4 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion 0.50 · splay 0 |
| The four registration frames (`337:19690`, `337:15896`, `340:19731`, `349:16811`) | `#333439` @ 20% | **G2** frost 20 · refraction 1.00 · depth 36 · angle 22 · intensity 0.25 · dispersion 0.70 · splay 0.16 |

`CircleBackButton` takes a `BackChipVariant` for that reason — it is a design distinction, not
something the widget can derive from the theme. **The dark chip has no shadow at all**; it elevates
with Glass instead (edit1.md R1), so the empty list is a reading, not a gap. `AppColors.backChipFill`
is deleted in favour of `backChipSurfaceFill` / `registrationBackChipFill`.

Still a fallback: **`backChipGlyph`'s dark value** (cream). The chevron's own colour was not part of
the elevation read.

The OTP screens have **no** back chip in Figma — the build added one — so it keeps the standard
variant, there being no evidence for the registration one. What the input frame (`82:1171`) DOES draw
top-end is the language pill (`82:1254`, the same position as the success frame's `155:809`); the build
showed it only after success until API→UI Wave 02 (2026-09-24). Now: back chip at start (build's own),
pill at end, on the input view; pill alone after success.

### The cards' elevation, and the art shadow coming BACK — 2026-09-20, edit5 #32 and #54

The visual list above was about geometry and art. What was still missing is how the card elevates,
and the two canvases turn out to do it by different mechanisms:

| | Light `125:862` | Dark `337:15981` |
|---|---|---|
| Fill | `#FCFBF9` | `#232428` at **20%** — the build painted the opaque page colour |
| Outline | 1px gradient `#384F47` → `#95CDBB`, inner alignment | **none** |
| Shadow | (0.5, 0.5) blur 4 black 25% | **none** |
| Glass | — | **G20** on card 1, **G5** on card 2 |

**The two cards carry two Glass tokens whose ONLY difference is the light angle** — 25 against
−45. That is why `AppElevation` keeps `trackCardGlassFirst` and `trackCardGlassSecond` apart
rather than sharing one, and why the index→track mapping had to be read rather than assumed:
**School is the first card on both canvases** (`337:15947` and `82:1785`, read 2026-09-20). The
build already listed School first, so nothing moved — but it is a fact now instead of a
coincidence.

Because the dark fill equals the dark page colour, the 20% change is invisible on its own; what
makes the card read at all in dark is the Glass rim, and the rim lands in different places on the
two cards. Measured in `test/goldens/track_screen_dark.png`: at x=300 the FIRST card's top and
bottom edges stay flat at (35, 36, 40) while the second card's read (81, 82, 85) and (54, 55, 59).
Both cards rim on their vertical edges. Every one of those pixels was flat before.

#### ✅ The illustration's shadow is back, and this entry is why it was gone

The 2026-08-04 note above records deleting `<g opacity="0.53" filter="url(#filter0_f_771_4476)">`
from `track_school.svg`, because `flutter_svg` ignores `<filter>` and painted the shadow paths
**crisp** — a hard grey duplicate beside the books. That was the right call then: a wrong-looking
shadow is worse than none. It also meant the app had been shipping the School illustration without
a shadow the frame draws.

`edit5.md` #54 asked for that layer to be identified before anything was built, and the read
settles it on both canvases:

- `Group 37219` (99 × 100) inside `Component 2` holds the **same 98 × 98 asset twice**;
- the front copy is sharp, at the group's origin;
- the back copy is offset **(left 1, top 2)**, at **53%** opacity, under a **layer blur of 7.4**
  (σ 3.7, edit1.md R3);
- **both copies wrap the same `Group` at 75.66 × 84.91** — the same shape — **but the back one's
  whole group is one flat `#000000` at 25%.**

So it is a black silhouette, not a coloured duplicate, and 0.53 × 0.25 black is exactly what the
2026-08-04 note read off the SVG. It is now rendered in Flutter, where the blur is real: a new
`lib/core/widgets/elevation/layer_blur.dart` wraps `ImageFiltered(ImageFilter.blur)` — the elevation
folder being one of the two the guard exempts from that ban — and the card draws the same
`SvgPicture` a second time behind the art under `ColorFilter.mode(trackCardArtShadow,
BlendMode.srcIn)`.

**This was nearly built wrong, and the way it was caught is worth recording.** The first
implementation blurred a copy of the COLOURED art, which is the natural reading of "a blurred
duplicate behind it" and is what `edit5.md` §7.10.2 prescribes. The golden measured it as a **teal**
haze under the teal book — `(252,251,249)` → `(172,224,222)`, a delta of 80 — which is not what the
frame draws. The correction measures neutral: `(252,251,249)` → `(228,228,226)`, delta 24, and on
the dark canvas **1139 pixels darker and 0 lighter**, which is what a black shadow must do.

**Only the School card has one.** The University card's art (`Component 3`) is a plain vector group
with no duplicate, so it gets none — `_TrackCard.artShadow` is per-card for that reason, and the
tests assert the University card has no `LayerBlur`.

#### 🔴 NEW, and the most serious thing this wave found: the SELECTED card is unreadable

**Found on a Pixel 8, 2026-09-20, `docs/DEVICE_VERIFICATION_2026-09-20-edit5.md`. Not changed.**

Tapping a track card turns it **solid `#384F47`**, not the 8%-primary wash its code reads as. The
label stays `textPrimary`, so it goes from **18.67:1 on the unselected card to 2.19:1 on the
selected one** — below WCAG AA's 4.5:1 for body text and below even the 3:1 large-text floor.
Selecting a track makes that track's own name the hardest text on the screen to read.

**The cause is a compositing order, not a wrong colour.** The card is two nested boxes: an outer
one filled `cs.primary` that draws the 2px outline, and an inner one, inset by the border width,
filled `cs.primary.withValues(alpha: 0.08)`. An 8% wash over a **solid primary parent** is solid
primary. The wash never had anything to tint.

**This is not an edit5 regression.** `git show HEAD:…/signup_track_screen.dart` has the identical
nesting — inner `color: selected ? cs.primary.withValues(alpha: 0.08) : ext.background` over outer
`color: selected ? cs.primary`. It has shipped this way since the state was invented on Day 2.
edit5 changed only the *unselected* inner fill (`ext.background` → `ext.trackCardFill`), which is
the 20%-in-dark correction #32 asked for and does not touch this path.

**Why it was left alone.** `edit5.md` §7.10.1 says in as many words to keep the invented selected
state exactly as it is, and the whole of open question 4 above is that this state has no frame
behind it. Fixing it means choosing — drop the outer fill to a ring, or light the label — and both
are design decisions on a state the designer has not drawn. It is the designer's call, and it is
now a call with a number attached.

#### 🟠 NEW, small, and recorded rather than changed: the radio is 16, not 19

`Ellipse 4` in `Group 37220` reads **16 × 16** on the light card. The build draws 19 (r = 9.5),
which the table above records as the frame's value. `edit5.md` §7.10.1 says to keep the radio, so
it is kept. Also noted: `Group 37220` holds a second, **hidden** `Ellipse 5` — presumably the
selected state's fill, which would be the first real evidence for a state this entry has called
invented since Day 2. Neither was acted on.

---

## 41. ✅ RESOLVED (chip built, dot gated) — the bell was a bare Material icon

**Where:** **`59:1466`** `mingcute:notification-fill` (36×36) on Home `59:1439` — the light twin of
`337:5330`. Code: `lib/features/home/widgets/home_header.dart:60-67`.

**What:** the build renders `Icons.notifications` on its own. The frame draws a three-part chip:

| part | spec |
|---|---|
| ring | 36.5 circle, fill `#FCFBF9`, **0.5px stroke `#4B675E`** |
| glyph | `mingcute:notification-fill`, `#4B675E`, centred in a 37 box |
| unread dot | circle **r = 3**, fill **`#E67E22`** (orange), centre (23.5, 11.5) — i.e. over the bell's top-right |

Neither the ring nor the dot exists in code, and the glyph itself was a placeholder.

**Status: glyph RESOLVED** — exported to `assets/icons/notification.svg` (`currentColor`, viewBox
`0 0 37 37`, so the ring and dot coordinates above drop straight onto it). The ring and dot are
decoration/state, not art — build them in Flutter, not in the asset.

**Built 2026-08-04 (Day 7b D2).** `home_header.dart` draws all three parts: a 36.5 ring with a 0.5px
`#4B675E` stroke on both canvases, the glyph tinted `#4B675E` / `#FCFBF9`, and the r=3 dot at the
frame's (23.5, 11.5) — laid out in the asset's own 37 viewBox, so those coordinates need no
rescaling. Ring and dot are drawn in Flutter rather than baked into the SVG: the ring is decoration
and the dot is state. Note the dot changes hue between canvases (`#E67E22` / `#AE87E7`), so it is
not a fixed "notification orange".

**The dot is GATED and currently never renders.** `HomeHeader.hasUnreadNotifications` defaults to
`false`, is marked `TODO(contract)`, and nothing sets it. Rendering it unconditionally to match the
frame would be a permanent "you have mail" lie. `test/features/home/home_header_unread_test.dart`
pins that: absent when false, false by DEFAULT, and correct in either hue when eventually forced
true.

**Fix we need — still open:** confirm with Seif whether an unread count is coming. Until it does,
the dot has no data source.

---

## 42. ✅ RESOLVED — a light Home frame **does exist** (`59:1439`) and contradicted the palette

**Where:** `59:1439` Home (light) · level card `308:4209` · bar `308:4221`.
Code: `lib/core/theme/app_colors.dart:212-214`, `lib/features/home/widgets/level_card.dart:78-137`.

**What:** several light-theme tokens carry the comment `// = light hint (no light Home frame)` /
`// = light fieldBorder (no light Home frame)` — they were **derived** on the assumption that Home
was only ever drawn in dark. That assumption is wrong; `59:1439` is a full light Home frame, and it
does **not** follow the green-in-light / purple-in-dark accent flip the rest of the app uses.

Measured off the frame:

| element | design (light `59:1439`) | built (light) |
|---|---|---|
| level progress **fill** | **`#AE87E7`** (purple) | `cs.primary` → `#384F47` green |
| level progress **track** | **`#ECECEC`** | `ext.progressTrack` → `#D1D1D1` |
| stat label ("current level", "Pts Balance") | **`#7070A0`** | `ext.cardLabel` → `#696969` |
| stat value ("LEVEL 8") | `#393939` | `ext.textPrimary` |
| divider between the two stats | **`#AE87E7`** | `cs.primary` green |
| card | 362×171, radius **15**, `#FCFBF9` | radius 15 ✔, `ext.cardFill` |

Note `#7070A0` is already in the palette as the **dark** `cardLabel` (`app_colors.dart:244`, Figma
`337:5340`) — light and dark use the same value here, which is exactly what "no light frame" made
us fail to see.

**This is the highest-value item in this pass**: it is not one wrong colour, it is a wrong *rule*.
Every place that assumed "no light Home frame" needs re-deriving against `59:1439`.

**Re-derived 2026-08-04 (Day 7b D1).** New token `homeAccent` (`#AE87E7`, both canvases) carries the
exemption **in the palette** rather than as a `Brand.purplePrimary` reference at a call site, which
would have hidden the rule change behind a colour swap. `colorScheme.primary` now appears nowhere
under `lib/features/home/`.

| token / element | was | now |
|---|---|---|
| level progress fill | `cs.primary` | `homeAccent` |
| stat divider | `cs.primary` | `homeAccent` |
| `progressTrack` (light) | `#D1D1D1` | `#ECECEC` |
| `cardLabel` (light) | `#696969` | `#7070A0` — same as dark |
| stat value | `textPrimary` | new `cardValue` `#393939` / `#FCFBF9` |

`home_banner.dart` is included although the brief's section D does not name it: it is on Home and
was drawing `cs.primary`. The frame gives no value for that placeholder box, so it follows the
surface's rule rather than a second invented one. It stays an acknowledged `TODO(design-asset)`.

**Its drop shadow, read 2026-09-17 — recorded, not built** (edit3.md #4). The `banner` node
(361 × 192.53, radius 19.25) carries `filter: drop-shadow(0.5px 0.5px 4px rgba(0,0,0,0.25))` in
light AND dark, on both tracks — the same single black shadow on both canvases, like the subject
card. It is **not applied**: the shadow belongs to the artwork, and the app renders a themed
placeholder box instead (the artwork is export-blocked). Shadowing a placeholder would elevate a
rectangle that is standing in for an image. When the real artwork lands: add a `bannerShadows`
token carrying black 25% (0.5, 0.5) blur 4 in both canvases, and wrap the image — not the
placeholder — in `ElevatedSurface(shape: r19.25)`.

The **dark** palette needed no change — `#2E2D32`, `#7070A0`, `#B3B3B3` already matched `337:5303`.

**Still wrong, and deliberately NOT changed:** `cardFill` light is `#FDFDFD`, derived from
`fieldFill` back when no light Home frame was known; `59:1439` says **`#FCFBF9`**. It sits outside
the brief's D1 change list, so it carries a `TODO(design)` in `app_colors.dart` and is reported
rather than silently corrected. It is the last surviving "no light Home frame" derivation.

**Fix we need — still open:** confirm the exemption is deliberate, i.e. that Home is meant to be
purple-accented in light too. Everything above assumes the frame is right.

---

## 43. ⛔ BLOCKED — the level medallion is a per-level raster illustration, not a tintable icon

**Where:** **`308:4217`** `Level badges`, an instance 91×91 whose only child is named **`Level= 8`**
— a component with a `Level` variant property, filled with **two raster PNGs**.
Code: `lib/features/home/widgets/level_card.dart:78-81` (`TODO(design-asset)`).

**What:** the build draws `Icons.emoji_events` at 56px tinted `cs.primary` — a flat green trophy.
The design has a **gold, shaded 3D medallion at 91×91** that is **different artwork per level**, not
one glyph recoloured. `kMaxLevel = 12` (`level_card.dart:24`), so this is potentially **12 assets**,
selected at runtime by the student's level.

Because the badge is raster (PNG image fills, not vectors) it cannot be exported as SVG and cannot
be tinted — it has to ship as images.

**Fix we need — designer:**
1. How many distinct badges exist? One per level 1–12, or tiers (bronze / silver / gold)?
2. Export the full set at **@3x**, named `level_badge_01.png` … `level_badge_12.png` (or by tier).
3. Confirm the fallback when a level has no artwork.

Until the set lands, keep the Material trophy and the `TODO(design-asset)` marker — do not ship a
single badge for all levels.

**Day 7b (2026-08-04): no code, by design.** The placeholder and its marker stay; the marker's
comment now spells out why, so the next person does not re-litigate it. Its tint moved
`cs.primary` → `homeAccent` with the rest of Home (#42) — a token change, not an implementation.

**Also for Seif, not the designer:** the Figma component `Level badges` is keyed `Level= 1…12` and
driven by `level`, while the contract's `badges` is an **integer counter of post-level-12
milestones** (every 5,000 points, first at 11,000). They are different concepts sharing a name.
Which drives the Home medallion, and is any badge imagery ever served by the API?

---

## 44. 🔴 The approved registration Figma has no path for either state contract v1.1 made valid

**Where:** School Registration `337:5269`, University Registration `337:10373`.
Code: `lib/features/registration/widgets/city_field.dart`,
`lib/features/registration/widgets/school_picker_field.dart`.

**What.** Contract v1.1.0-m1 (adr-028, vendored 2026-08-03) makes two registration configurations
valid, expected and — on the school track — reachable by an ordinary student:

1. **A city that is not in our coded list.** `cityId` **OR** `cityName` (free text, max 100), at
   least one required. Applies to **both** tracks.
2. **A school-track student with no school.** `schoolId` is now optional for **every** school
   student, Egypt included. And free-text `schoolName` was removed from the contract outright, so
   the non-Egypt school field the frames draw has nothing behind it at all.

The frames draw neither. They draw a required city dropdown and a school field that is either a
coded picker (Egypt) or a free-text input (elsewhere) — the second of which is now unbuildable.

The rule the whole change descends from, in Seif's words: **"A student is never blocked from
registering because a list we control is incomplete."**

**What was built (Day 7c, 2026-08-05), and from what source.** Seif's partner notice of 2026-07-30
is the spec of record; there was no frame to work from and none is promised. Recorded here so the
design revision is a **comparison, not a discovery**. See `DECISIONS.md` D-003 (build-ahead-of-design)
and D-005 (the wording).

| Element | What ships today |
|---|---|
| City escape link | Under the city dropdown, both tracks. `TextButton`, 14pt w500, `textSecondary`, underlined, start-aligned. Copy: *"مدينتي غير موجودة"* / *"My city isn't listed"* |
| Free-text city | An **in-place swap** — the dropdown is replaced by a `PlainTextField` in the same slot, not a new step. Label *"اسم المدينة"* / *"City name"*, `maxLength: 100` |
| Return link | *"اختر من القائمة"* / *"Choose from the list"*, same styling, returns to the picker and clears the typed value |
| School skip link | Under the Egyptian picker only. Identical widget to the city escape. Copy: *"لم أجد مدرستي"* / *"I can't find my school"* |
| Skipped school field | Reads *"لم يتم اختيار مدرسة"* / *"No school selected"* in `textSecondary` — **resolved, not blank**. The skip link disappears once used; picking a school un-skips |
| Non-Egypt school | **Removed entirely.** No picker, no text field, no label — structurally symmetric with the governorate branch |

Nothing new visually: every colour, size and component is already on those screens. The city escape
and the school skip are literally the same widget, so they cannot drift apart.

**Fix we need — designer.** Three questions, the first Seif's, the last two his and unanswered
anywhere:

1. **Where does the escape link sit** so it is findable but does not tempt students away from the
   picker? Most students *should* use the list — the coded id is the only value the backend can
   filter and report on. Our placement (directly under the field, low weight) is a guess in the
   right direction, not a design.
2. **How does the profile screen render a free-text city?** It has no `nameAr`/`nameEn` — one
   string, in whatever language the student typed, shown in both locales. **Day 8's problem, and
   answered nowhere.**
3. **How does the profile screen render a missing school?** Seif offers the designer "blank row,
   hidden row, or an 'أضف مدرستك' prompt" — but see `seif_fight.md` **S20**: `PATCH /me` cannot
   write a school, so the third option has no endpoint behind it and should be withdrawn before the
   designer picks it. **Also Day 8's problem.**

**When the revision lands:** re-verify these states against the frames, do not rebuild them. The
behaviour is contract-driven and will not change; only the presentation is up for revision.

---

## 45. 🟠 Settings "Mode" draws three themes; the app has exactly two

**Where:** Setting (`176:1840`) — three colour circles under **Mode**.
Code: `lib/features/settings/screens/settings_screen.dart`.

**What.** `AppColors` has two canvases and only two: light (`#FCFBF9` page, `#384F47` green accent)
and dark (`#232428` page, `#AE87E7` purple accent). Every fidelity pass since Day 7b — the nav bar,
the language pill, the track picker, Home, the whole Profile cluster — was measured against those
two. There is no third palette anywhere in the file, and no set of variables that would define one.

A third option would mean inventing roughly fifty token values and presenting the result as a
design. That is the same class of decision as inventing a screen state, which Day 7b ruled out.

**What ships (Day 8 step 3):** **two** rows, Light and Dark, each leading with a circle filled from
that palette's own `background` — so the swatch cannot drift from the canvas it selects. Wired to
the new `themeModeProvider`, which is what also closed #10.

**Fix we need — designer.** What is the third circle? Two plausible answers and they are very
different jobs:

1. **"Follow the system."** That is a *mode*, not a palette, and Flutter has it built in
   (`ThemeMode.system`) — a third row costs nothing. Say the word.
2. **A third palette.** Then it needs tokens: page, card, field, text, accent, nav, and the nine
   semantic colours that deliberately do not flip with the theme. Until those exist there is
   nothing to build.

Also `seif_fight.md` **S26**, because Seif's side sees it in the same screen.

### The swatches' own values, recorded 2026-09-20 so the unblock does not need a re-read

`edit5.md` item **#51** asked for the three circles' elevation to be recorded rather than built,
and this is that record. Nothing below was applied — the app still ships two `SettingsChoiceRow`s.

Three `Ellipse 124` circles, diameter **47.51**, at x **9.58 / 76.24 / 142.91**. On canvas each is
a diagonal two-colour split (green/white, purple/dark, teal/white), the second colour supplied by
an `Ellipse 125` (`#AE87E7`, rotated) forming one half.

| Swatch | Light frame | Dark frame |
| --- | --- | --- |
| 1 | `#FCFBF9` + a **5** `#384F47` ring (selected) + drop (0, −1) blur 3 black 25% + **inset** (0, 2) blur 4 black 25% | `#FCFBF9`, the same two shadows, **no ring** |
| 2 | `#232428` + drop (0, −1) blur 3 + **inset** (0, −2) blur 4 `#FFFFFF` | `#232428` + a **5** `#AE87E7` ring (selected) + drop (0, −1) blur 3 + **inset** (0, −2) blur 2 `rgba(255,255,255,0.25)` |
| 3 | `#FFFFFF` + drop (0, −1) blur 3 + **inset** (0, 2) blur 4 black 25% | same as light |

Two things in that table are worth naming, because they are the reason this cannot be half-built:

1. **The selected ring moves between canvases.** Light rings swatch 1, dark rings swatch 2 — so the
   frames do not merely restyle one control, they select a DIFFERENT option on each. That is a
   product statement (the default canvas differs per theme?) hiding inside a visual one.
2. **Every swatch carries an inner shadow, and two of them are white.** `#FFFFFF` and
   `rgba(255,255,255,0.25)` inner shadows appear nowhere else in this wave; they are not the
   measured-black family the rest of the dark frames use, so they cannot be derived from an
   existing token.

**Also recorded, and it is not only the swatches.** Figma draws **no section card** around Mode
(`176:1840`, `337:8141`) — the circles sit straight under the heading, exactly as the Languages
track does. The build keeps the card, deliberately: restyling the container of a control whose
contents are blocked would polish the wrong half, and removing it would leave two stand-in rows
floating with nothing to group them. When #45 is answered, the card goes with the rows.

---

## 46. 🟠 "Show Rank" is one switch where the contract has two independent booleans

**Where:** Setting (`176:1840`) — a single **Show Rank** toggle.
Code: `lib/features/settings/screens/settings_screen.dart`.

**What.** `PATCH /me` accepts two privacy fields (`openapi.yaml:846-847` at the 3.23.0-m1 pin; `:620-621` when this
was filed), and adr-023 defaults them differently (`:2481-2485`; was `:1380-1382`):

| Field | Question it answers | Default |
|---|---|---|
| `leaderboardVisible` | am I on the leaderboard at all? | `true` |
| `scoreHidden` | I am listed — is my score shown? | `false` |

> **2026-09-29 (API→UI Wave 21): the `scoreHidden` row above is stale.** Since adr-111 a score-hidden student is taken
> off every board, and `GET /leaderboard/me` refuses them their own rank (`openapi.yaml:2076-2083`, `:2181-2183`). See
> seif_fight S27 and KNOWN_BUGS BUG-017 (the app's help line still says "listed, without your score").

These are not two spellings of one setting. A student who wants to compete but not publish their
score picks the second without the first; a student who wants out entirely picks the first. One
switch cannot express the pair, and **mapping one control onto both would mean silently choosing a
privacy policy on behalf of a minor** — which is the sort of default that gets noticed by a parent,
not by us.

**What ships (Day 8 step 3):** **two** rows in the frame's styling, each with a one-line explanation
under the label, because four words cannot carry the difference. Each sends only its own field.

**Fix we need — designer.** Confirm two rows is right and give them their copy, or tell us which
single policy the one switch was meant to express. If the intent was "hide me completely", that is
`leaderboardVisible` alone and `scoreHidden` should come off the screen — but it stays on the
contract, so somebody still has to decide its value.

Also `seif_fight.md` **S27**.

---

## 47. 🟠 Five drop shadows are pure black, which does not exist on the dark canvas

> ✅ **SUPERSEDED 2026-09-17 — owner ruling. The cream derivation below is WITHDRAWN.**
>
> The finding rested on one premise: *"no dark frame exists for any of the five components."* It
> does. The 2026-09-16 elevation audit and the 2026-09-17 Glass reading measured **thirteen** dark
> nodes that carry a drop shadow — the subject card (`337:5732`), the profile stat card
> (`661:8579`), the profile header (`337:7455`), the profile edit chip (`337:7466`), the Mistakes
> card (`404:7637`) and pill (`404:7421`), the AI panel wrapper (`337:9278`), the setup length chips
> (`337:6289`/`337:6291`), the pool card (`337:6275`), the primary CTA (`348:8911`), the onboarding
> sheet (`337:15643`) and the avatar badge (`337:7925`).
>
> **Every one of them is black, at the same alpha as its light twin.** No dark node in the file has
> a cream or white *drop* shadow anywhere. White and lavender appear only as **inner** shadows (the
> scope toggle, the Settings swatches, the University tiles) and as deliberate coloured **glows**
> (the nav bar, the OTP card).
>
> **What the arithmetic above got right, and what it got wrong.** The L\* numbers are correct: black
> at 25% really does move `#232428` by about five points. What was wrong was the conclusion drawn
> from them — that the canvas therefore had to elevate *upward in the same shadow*. It elevates
> upward by a **different mechanism**: Figma's **Glass** effect over a 20%-alpha fill, plus a
> lavender back-light behind the surface (→ **#72**). The black shadow is then a real edge under a
> surface that is already lifted, not a failed attempt at one.
>
> **What ships now.** `lib/core/theme/app_elevation.dart` (`AppElevation`) carries every measured
> shadow, Glass setting, back-light and scrim per canvas, and
> `lib/core/widgets/elevation/` is the only code allowed to paint one. `AppColors.elevationShadow`
> is **frozen**, with its values unchanged: flipping it to black on its own would darken the
> 20%-alpha cards that still paint an unclipped shadow beneath their own fill. Each of the eight
> remaining call sites moves to the measured black in the edit that owns it (edit2 onboarding;
> edit3 Mistakes card; edit4 review pill and AI panel; edit5 OTP timer, avatar badge, profile
> header, profile stat card), and **whoever removes the last one deletes the token**, its
> `copyWith`/`lerp` lines and the `elevationShadow` group in `palette_discipline_test.dart`.
>
> `navShadow` is superseded the same way: `AppElevation.navBarShadows` has both canvases measured
> (light `59:1264`, dark `349:16719`) and they differ in colour *and* blur, so the "it should follow
> whatever this one becomes" note below is answered — it does not follow, it was read.
>
> Reasoning and rejected alternatives: `docs/DECISIONS.md` **D-009**.


**Where:** the onboarding sheet (`459:43873`), the Edit Profile avatar badge (`180:3989`), the
Profile header card (`169:4609`), a Profile stat card (`661:8571`) and the quiz AI panel
(`159:1851`). Code: `lib/core/theme/app_colors.dart` → `elevationShadow`, `TODO(design)`.

**What.** Every one of those five frames exports its elevation as
`drop-shadow(… rgba(0,0,0,α))`, and until this pass the build reproduced that literally — a raw
black at each call site, painted on both canvases. That is correct on cream and meaningless on
`#232428`:

| Canvas | Base | Black @25% composites to | L\* step |
|---|---|---|---|
| Light `#FCFBF9` | L\* ≈ 98 | `#BDBCBB` | **−21** |
| Dark `#232428` | L\* ≈ 13.8 | `#1A1B1E` | **−5** |

A five-point step under a 1–4px blur is not a shadow, it is nothing. The dark canvas has almost no
room left beneath it, so **elevation there has to be expressed upward**: cream at the same alphas
over `#232428` gives ≈ **+25 L\***, the same magnitude in the only direction available, and reads
as a rim light rather than a drop shadow.

**What ships.** One token, `AppColors.elevationShadow` — black in light, `#FCFBF9` in dark. It
carries **no alpha**: the five components are measured at two different depths (0.15 for the
onboarding sheet, 0.25 for the other four) and each call site keeps its own. How far a component
floats belongs to the component; what its shadow is made of belongs to the palette.

**Fix we need — designer.** The dark value is **derived, not measured** — no dark frame exists for
any of the five, which is the same situation as the Home, Learn, quiz and Profile token blocks.
`#FCFBF9` was chosen because it is already this file's approved dark foreground rather than an
invented hex. The alternative we rejected: keep black and raise the alpha. Arithmetically it cannot
reach a comparable step, because the canvas starts ≈14 L\* off the floor. **One value overrules
all of this** — send a dark shadow and it drops straight into the token.

Related and deliberately not folded in: **`navShadow` had the same defect** — 8% black in both
canvases, itself already a `TODO(design)` (issue #37, open question 2). It was left alone because
it has its own derivation and restyling the bottom nav on the strength of a decision about card
shadows would be the wrong trade.

> **Settled 2026-09-18 (edit2 #2).** It did not follow this decision: both nav shadows were
> *measured* off the `Union` and neither is black — light `59:1264` is `rgba(184,184,210,0.5)` at
> blur 16.08, dark `349:16719` is `rgba(124,58,237,0.1)` at blur 12.5. They live in
> `AppElevation.navBarShadows`; `AppColors.navShadow` is deleted. See #37, open question 2.

---

## 48. 🟡 Settings applies changes immediately; the frame draws a "Save Change" button

**Where:** Setting (`176:1840`). Code: `lib/features/settings/screens/settings_screen.dart`.

**What.** The frame ends with a full-width dark-green button, h≈60 / r≈30 — the same treatment as
Edit Profile's. The build has no such button: every control on the screen applies the moment it is
touched. Language and Mode change the app on tap; each privacy toggle sends its own `PATCH /me`.

**Why we built it that way.** Two of the four sections are pure client preferences with nothing to
submit, and a Save button that governs only half a screen teaches the wrong thing about the other
half. The privacy toggles are server-authoritative and non-optimistic — the switch shows what
`/me` says, and a successful write invalidates `/me` so the value comes back from the server —
which is a shape a Save button would have to be reconciled with rather than sit on top of. Edit
Profile's button is different: it batches a form of text fields into one request.

**This is a deliberate divergence, not an oversight, and it is the designer's call to overrule.**
If the frame's model is wanted, that is its own change and a real one: batching means the toggles
stop reflecting the server until submit, and the two client preferences need a defined answer for
what "unsaved" means when the app has already visibly changed language.

**Two other divergences from the same frame, both now reconciled:**

- **The four Notification Preferences toggles render ON**, matching the frame. They were shipped
  OFF when the frame could not be read. Both states are invented for a control nothing can persist
  (issue: `seif_fight.md` **S28**), so the frame's answer wins at no cost.
- **The frame draws the bottom nav bar on Settings, with Account selected.** `/settings` is routed
  *outside* the `StatefulShellRoute`, so it renders without one. **Owner decision, taken: it stays
  outside.** Every screen reached from the Profile hub — Edit Profile and the four shells included
  — is pushed over the shell and renders without a bar; moving Settings alone would make it the
  exception, change back-navigation for a screen that has already shipped, and leave the page with
  two different ways out of it. Designer should treat the bar in this frame as decoration.

---

## 49. 🟡 OTP resend-timer pill — was built from a 100%-zoom screenshot; the panel was read 2026-09-20 and three values moved

**Where:** OTP (`82:1328`, "Frame 1000002977") → its third child, Frame `427319517` (161 × hug,
vertical, gap 20): a stadium pill holding a stopwatch glyph and `00.21`, with "Resend OTP" under
it. Code: `lib/features/auth/screens/otp_screen.dart` (`_ResendRow`, `_ResendTimerPill`),
`assets/icons/stopwatch.svg`, ARB key `resendTimer`.

**What blocked a proper pull.** The Figma MCP connector authenticates as **Seif's account**
(`whoami` on 2026-08-22: `seifhamdii012@gmail.com`, Full seat on "Seif Hamdy's team"), which has
**view-only** rights on this file — so `get_design_context`, `get_screenshot`, `get_metadata` and
`download_assets` all return "you don't have edit access". Issue #1 records `download_assets`
working on Day 00; the connector's identity has changed since. The frame was read through the
owner's own logged-in browser instead, which gives the Properties panel (Layout only — no Dev
Mode) and a screenshot at 100% zoom.

**What is measured vs read.**

| Value | Built as | Source |
|---|---|---|
| Gap pill → label | 20 | Properties panel (Frame 427319517 · Gap) — **the only read value** |
| Pill height / radius | ~~36 / 18~~ → **42 / stadium** | **read 2026-09-20** (`332:3391`, r100 on a 42-high pill) — the measurement was 6dp short |
| Pill horizontal inset | ~~14~~ → **15** | **read 2026-09-20** (`332:3390` panel padding) |
| Glyph size | 15 × 19 | **read** — the export's own viewBox, drawn at native size |
| Gap glyph → digits | 8 | measured |
| Digits | `AppType.bodyMedium` (14/20, 400) | measured; 14 vs 16 is within the reading error |
| Pill fill | `AppColors.cardFill` | approved raised-surface token, not a read hex |
| Pill shadow | ~~`elevationShadow` @ 0.25, 0.5/0.5/4 outer~~ → **`AppElevation.otpTimerInsetShadows`** | **read 2026-09-20** — and it is an **inner** shadow, not a drop. Light `332:3391`: black 25%, (0, −1), blur 4. Dark `337:19503`: `rgba(198,198,198,0.25)`, (−0.5, 0.5), blur 1.2. The two canvases share nothing about it |
| Glyph tint | `colorScheme.primary` | **read** — the export's stroke is `#384F47`, the light primary and the colour of the "Resend OTP" label beneath it; `app_colors_test.dart` pins the two together |
| Digit tint | ~~`AppColors.textSecondary`~~ → **`AppColors.otpTimerContent`** | **read 2026-09-24** — `82:1316`'s digits are `#384F47` (the glyph's green) and `337:19503`'s are `#FCFBF9`; the dark glyph export is stroked cream as well, so the glyph moved off `colorScheme.primary` (lavender in dark) onto the same token. Digits are Montserrat Medium 12 → `AppType.labelMedium` (12/16, 500; the app's font) |

**The separator is a dot, on purpose.** The frame draws `00.21`, not `00:21`. Built verbatim
(`resendTimer` = `{minutes}.{seconds}` in both ARBs, digits zero-padded) because changing it is a
copy decision, not an engineering one — but a dot between minutes and seconds reads as a decimal
to many students. **Designer: confirm dot vs colon.** The change is one character in two ARB
files.

**The glyph landed (2026-08-22).** `assets/icons/stopwatch.svg` is now the owner's *Copy as SVG*
of the icon layer: 15 × 19, three stroke paths at 1.6 with round caps, stroke `#384F47`. It
shipped first as a hand-drawn placeholder with a `TODO(design-asset)` marker; both the marker
and the placeholder are gone. Two things the export settled that a screenshot could not: the
box is 15 × 19 (it had been drawn in an 18 × 18 square), and the glyph is the **green primary**,
not the dark body grey — the widget tints it with `colorScheme.primary` so it still follows the
accent flip on the dark canvas, and `test/core/theme/app_colors_test.dart` asserts the file's
literal stroke still equals that token, so a re-export in another colour fails a test instead
of quietly disagreeing with the palette.

**Still worth reading off the Properties panel** (view seat is enough): the digits' text style and
colour — the last measured row above. The pill's Width / Height / Padding / Gap / radius are now
read; see the table.

---

### The rest of the OTP screen, read and built 2026-09-20 (edit5 #30, #31, #52, §7.11a)

**The code card exists now, and the biggest finding is what is INSIDE it.** `308:5114` is a
component wrapper; the card is its variant `Type= correct` (dark: `337:19501`, in
`Component 18_dark`). Both canvases give the same four geometry numbers:

| | Value |
|---|---|
| Size | 354 × hug 171.01, radius **19** |
| Padding | top **15**, right **10**, bottom **15**, left **10** |
| Gap | **20** |
| Fill | light `#FCFBF9` (`308:5114`) · dark `#232428` (`337:19501`) |
| Shadow | light black 25% (0.2, 0.2) blur 4 · dark **lavender** `rgba(174,135,231,0.25)` (0.2, 0.2) blur **7.9** |

The variant has **exactly two children**: the digit row (`Frame 427319511`, 320 × 61.01, gap 14)
and the Verify button (`Component 8`, 334 × 60). 15 + 61.01 + 20 + 60 + 15 = 171.01 to the
hundredth, which is the arithmetic that proves the child list is complete — **the CTA is inside
the card**, which no previous reading of this screen had recorded. It is built that way.

**Two surrounding gaps moved with it**, both read rather than kept: `Frame 1000002976` (`308:5109`)
gives **35** between the subtitle block and the card (the build had 32), and `Frame 1000002977`
(`308:5108`) gives **26** between the card and the resend block (the build had 16). That frame also
confirms the screen's **24** left gutter, which the build already had.

~~**The inline error message has no Figma slot.**~~ **Wrong — corrected 2026-09-24 (API→UI Wave 02).**
Both component sets carry a `Type= wrong` variant: light `82:1170` → `82:1439`, dark `337:19271` →
`337:19284` (read with `get_design_context`). It draws the error, and the build now follows it:

| | Frame (`wrong`) | Build before | Build now |
|---|---|---|---|
| Cell fill | resting (`#FDFDFD` / `#232428` 20%) | error red at 6% | resting (`otpDigitFill`) |
| Cell stroke | `#EB001B` @ 50%, resting width (1.17333 / 0.5) | `colorScheme.error` (M3 seed red) at 1.5 | `otpDigitErrorBorder` at `otpDigitBorderWidth` |
| Error line | Inter Medium 10 `#FF465C`, start-aligned, no icon | bodyMedium 14 `colorScheme.error`, centred, with icon | `AppType.labelSmall` + `otpErrorText`, start, no icon |
| Gaps | digits → line 13, line → Verify 20 | 16 / 20 | 13 / 20 |

Every OTP failure (expired, throttled, network, generic) uses this one line; only `otp_invalid` also
turns the cells red. **Copy not changed:** the frame reads "This is incorrect Code, try again"; the ARB
keeps its grammatical "This is an incorrect code, try again" (the #26 rule — a design typo does not
become copy). **For the designer:** 10 px error text is small for students — confirm it is intended.

**Type sizes the handoff scale does not carry (not changed, same class as Login's title):** OTP title
Bold 25 (built `h1` 24), subtitle Regular 18 (built `bodyLarge` 16), "Resend OTP" Bold 18 (built
`buttonMedium` 14/600), success title Bold 22 / subtitle Regular 20 (built `h1` / `bodyLarge`), and the
CTAs' Bold 20 / SemiBold 22 labels (shared `PrimaryCta`, `buttonLarge` 16/600). The scale runs 28 → 10
and says not to add sizes, so which step each maps to is the designer's call.

**The digit cells take the frame's surface and keep the build's box.** Light `#FDFDFD` with a
**1.17333** `#D1D1D1` hairline; dark `#232428` at **20%** with a **0.5** hairline of the same grey
and **G19** (frost 56 · refraction 0.80 · depth 100 · angle −45 · intensity 0.80 · dispersion 0.65 ·
splay 0.50). Geometry stays 6 × 48 × 56 at r16 against Figma's 4 × 66 × 61.01 at r11.73, because the
contract mandates six digits (#5) and six boxes at the frame's width do not fit a 334-wide card.
The focused state (1.5 primary) is the app's own; Figma draws no focused cell. (The error state is
drawn after all — see the correction above.)

#### 🟡 The blinking caret is gone, and it was the owner's call

Moving the cells onto `Pinput.builder` — which the dark canvas forces, because `PinTheme` carries a
`BoxDecoration` and a `BoxDecoration` cannot express frost, refraction or splay — takes the caret
with it: pinput 6.0.2 hard-codes `showCursor = false` and `cursor = null` in that constructor
(`pinput.dart:176`). Reproducing it means a `Text('|')`, and the hardcoded-copy guard counts that
literal, so the baseline would have to rise from 4 to 5 on a ratchet `RISKS.md` R-7 freezes at
"may fall further, never rise".

**Owner's decision, 2026-09-20: keep the guard, drop the caret.** Recorded here because the screen
visibly changed and nothing in Figma asked for it. What replaces it is not nothing — the active
cell still carries its 1.5 `colorScheme.primary` stroke, so "where am I typing" is still answered.
If the caret is wanted back, the cheapest honest route is an ARB-free `cursor` widget upstream in
pinput, or the owner authorising the baseline raise.

**Both CTAs are wrapped.** "Verify" and the success "Continue" now take `PrimaryCta`
(`Frame 427319502` / `427319511`), so they get the light tight black shadow and the dark
`#AE87E7` glow layer. Verify's halo dims with the button until six digits are entered.

**`AppColors.elevationShadow` is deleted.** The pill was its last call site in `lib/`; the field's
own doc comment asked whoever removed it to delete the token, both values, its `copyWith` and
`lerp` lines and the `palette_discipline_test.dart` group that pinned them, and that is done. The
withdrawn cream survives only as a literal in `app_elevation_test.dart`, which asserts it appears
in no elevation token on either canvas. The raw-elevation guard reached **0** in the same change
and is now zero-enforcement rather than a ratchet.

**Behaviour, which the frame does not show.** Only the counting state is drawn. Built: while
`secondsRemaining > 0` the label is rendered in full colour under the pill (as drawn) but is
**inert** (`onPressed: null`); at zero the pill goes away and the label becomes the tappable
resend. The old "Resend in 21s" caption survives as the pill's **semantics label**, so a screen
reader says the sentence rather than "zero zero dot two one". Dark canvas: no dark OTP frame was
readable; every colour is a theme token, so it follows the palette (same caveat as #25).

---

## 50. 🟠 The result frame's level element — the app drew numbers, the contract says the frame draws a meter; element removed, meter unbuilt

**Where:** result `159:1964` (LTR) / `549:20247` (RTL) — the "Level Progress" element inside the
Rewards Earned card (`159:2020`).

**What:** since Day 7 the app rendered *"Level 3 · 1255 points"* there, fed from the `finish`
response. Contract 3.0.0-m1 (adr-102) removed those two fields from `QuizSummary` and states, as
design evidence, that the live frames *"render no absolute level number and no points total
anywhere"* — the level element is a **partial-fill meter**, `(points.total mod 500) / 500`. We could
not open either frame to confirm (the Figma connector is view-only on Seif's account), so either the
frames moved after Day 7 or the app built something the design never had.

**Built as:** the element is **removed** (owner ruling, D-006, `b7d0dfb`). The card shows the points
awarded and nothing else.

**Fix we need:** (1) confirm the meter exists on `159:1964` / `549:20247`, and if so its geometry —
height, fill and track colours, corner radius, and whether any caption (level number, "next level")
sits beside it; the data to draw it is on `GET /me` and the same 500-point rule Home already uses, so
it is a widget change once specified. (2) `549:20247` is an RTL result frame we had never catalogued
— confirm it is the Arabic counterpart of `159:1964` and whether other Day 7 frames now have RTL
twins (see #34).

---

## 51. 🔴 Three limit-sheet frames draw an upgrade CTA and a benefits list the product now forbids

**Where:** `199:2335` (school) · `225:6634` / `225:7001` (university).

**What:** adr-049 §3 (contract 2.2.0-m1, 2026-08-19): the mobile app is **purchase-silent** — never a
paywall, a price, an upgrade link, or where to buy; purchases happen on the website only, and voucher
redemption is web-only. The three frames draw **"Upgrade To Premium"** and a four-row benefits card
(unlimited questions, AI explanations, priority support, no ads). Both are dead by product rule, not
by our choice, and were removed from the app on 2026-09-04 (D-007, `5c4b855`). #30's ask for an
approved CTA string is moot — there is no CTA.

**Built as:** title + body + *"Not now"*. The bodies are **provisional engineering copy** (D-007,
`ce7da9a`): EN *"You've used all your questions for this week."* / *"This lesson needs an active
subscription."*, AR *"استخدمت كل أسئلتك لهذا الأسبوع."* / *"هذا الدرس يحتاج إلى اشتراك فعّال."*

**Fix we need:** (1) redraw the three frames without the CTA and the benefits list; (2) approved body
copy for `weekly_question_limit_reached` and `subscription_required` — neither may mention upgrading,
subscribing, a price or the website, and neither may use "premium" / "plan" / "pro" (glossary); (3) a
ruling on the title *"Subscription Required"* / *"الاشتراك مطلوب"* — it names the entitlement without
pointing anywhere, which we read as allowed, but that is product's call; (4) the reset moment may be
stated at week granularity (*"resets next week"* — the contract now says so) but **not** as a weekday:
Monday 00:00 Africa/Cairo is adr-091 §3 and is not on the wire.

**Update 2026-09-26 (API→UI Wave 11, owner ruling):** the sheet is now the frame's **centred card**, not a
bottom sheet. `limitation` (`207:5904`) is a 345-wide card at radius 22 with a 23 dp ✕ (`akar-icons:cross`,
stroke `#3F3F3F`) before a `#EF4444` title; the build follows it (✕ at the start edge, 18 dp side insets,
35 dp title row) and keeps "Not now" under the body. Two frame values are NOT taken: the title's Inter 600/22
(the type scale has no 22, so it is the app's dialog title, h2) and the card's 59 dp top / 16 dp bottom, which
were drawn around the benefits card and the CTA this entry removes; the build uses the Profile dialog's rhythm
(`180:4445`). Asks (1)–(4) above stand.

**Update 2026-09-26 (API→UI Wave 12, owner ruling):** the same card now also carries the contract's popup for
`GET /questions/{id}/explanation` `403 subscription_required`. Its body is the contract's approved copy,
verbatim: *"AI explanations are available with a Level Up subscription. Subscribe to get step-by-step
explanations and more learning features."* It says "subscribe", which ask (2) above would not allow for the
quiz-creation bodies. The owner ruled it compatible with purchase-silent: the contract mandates it, and the card
still has no price, link or buy button (D-015). AR (owner-approved): *"شروحات الذكاء الاصطناعي متاحة مع اشتراك
Level Up. اشترك لتحصل على شروحات خطوة بخطوة ومزايا تعليمية أخرى."*

---

## 52. 🟡 The review row's WRONG colours differ from the shipped quiz page's — by one hex digit and by opacity

**Where:** quiz review `162:2563` (wrong row) vs quiz page `308:5158` (the student's wrong choice).

**What:** the two frames disagree on the wrong-answer pair, and only on that pair:

| | Quiz page `308:5158` (shipped) | Quiz review `162:2563` |
| --- | --- | --- |
| fill | `rgba(255,192,192,.3)` — 30% opaque | `#FDE9E8` — opaque |
| border | `#921119` | `#921019` |

The **correct**-row values are byte-identical across both frames (`#BFFFC3` / `#00D33C`), which is
what makes the wrong-row divergence read as drift rather than intent — a designer would not restyle
one semantic pair and leave its twin alone, and `921119` → `921019` is a single-digit slip.

**Built as:** the **shipped** `quizWrongFill` / `quizWrongBorder`, unchanged (owner ruling,
2026-09-08). The review screen and the quiz page therefore render a wrong answer identically, which
is the behaviour a student would expect from two screens one tap apart.

**Fix we need:** confirm the drift. If `#FDE9E8` / `#921019` are deliberate for review, say so and
we will add the pair; if not, correct `162:2563` so the frame matches the shipped tokens and this
entry can close.

---

## 53. ✅ RESOLVED 2026-09-17 (designer ruling) — the dark review answer rows take the approved Glass treatment

> ✅ **DESIGNER RULING, 2026-09-17. This entry is closed. Do not block implementation on it, and do
> not re-raise it as an open question.** The 2026-09-08 "opaque in both themes" ruling recorded
> below is **superseded**, and the original finding is kept underneath for history.
>
> *Originally filed as: "The dark review frame draws the rows at 20% alpha, which contradicts the
> shipped correctness rule".*
>
> **The ruling, as given:**
>
> - **Do not keep the old opaque treatment.** Use the **approved Glass treatment**.
> - **The current Figma Glass design is the source of truth** for these rows.
> - The previous 20% opacity/alpha discussion is **not** a reason to invent a *different* treatment.
> - The requirement that matters is that the corresponding Review answer rows use the **same Glass
>   treatment consistently** — make the relevant rows **equal in treatment** rather than preserving
>   an opaque-vs-Glass difference because of the old 20% value.
> - The exact **20% value is not a separate product requirement** where it would conflict with
>   making the corresponding treatments consistent.
>
> **What that means for the build (edit4 owns it, item #48).** Take option **(c)** from
> `edit4.md` §"#48": the dark rows follow the frame — the semantic fills with the frame's alpha,
> the 0.5 semantic stroke, and **G5** Glass (`337:6731` …) — painted through edit1's
> `ElevatedSurface` with the `AppElevation` Glass token, never a second glass implementation and
> never a hardcoded colour. Options (a) "no change" and (b) "opaque plus a rim light" are withdrawn.
> **Consistency across the row states beats reproducing the literal 20% number**, so if a state's
> measured alpha would leave one row opaque and its neighbour glassed, the rows are made equal.
>
> **What this costs, recorded rather than discovered later:**
>
> 1. **`quiz_review_screen_test.dart` currently asserts the old ruling** — it renders the dark theme
>    and expects the same opaque marks as light. That assertion is now wrong and must be rewritten by
>    the edit that implements this, not deleted quietly.
> 2. **The palette rule still stands, and is not contradicted.** *"A correctness signal must never
>    flip colour with the canvas"* is about **hue** — a wrong answer is still red in dark. What
>    changes is the **treatment** (alpha + Glass), which is the dark canvas's elevation mechanism
>    everywhere else in this design (→ **#72**, **D-009**). Green does not become purple.
> 3. **Scope.** This ruling is about the **Review answer rows**. It does **not** instruct a change to
>    the quiz page's graded option tiles, which `edit4.md` option (c) noted would otherwise follow.
>    If, after this lands, the review screen and the quiz page visibly disagree one tap apart, that
>    is a **new** question for the designer — raise it then, with both renders side by side. Do not
>    treat it as a reason to delay these rows. The separate wrong-row hex/opacity divergence between
>    the two screens remains open as **#52**.
>
> Decision record: `docs/DECISIONS.md` **D-010**.

---

### The original finding (2026-09-08), kept for history


**Where:** quiz review dark `337:6705` (rows `337:6731`) vs `lib/core/theme/app_colors.dart:236`.

**What:** the dark frame does not introduce new row colours — it reuses the light hexes at **20%
opacity** over `#232428`. The app does the opposite, deliberately: all five semantic correct/wrong
tokens are **identical in both palettes**, under a rule written into the palette itself — *"a
correctness signal must never flip colour with the canvas. A wrong answer is red in dark mode too."*

This is a design-system decision, not a screen one: honouring the frame here would leave the review
screen and the quiz page disagreeing in dark mode, one tap apart.

**Built as (SUPERSEDED by the 2026-09-17 ruling above):** **opaque in both themes**, following the shipped rule (owner ruling, 2026-09-08).
Asserted by test — `quiz_review_screen_test.dart` renders the dark theme and expects the same marks.

**Fix we needed — ANSWERED 2026-09-17, see the banner above.** The original request read: a ruling. If 20% alpha is genuinely wanted, it must apply to the quiz page too, and
`app_colors.dart:230-237` needs rewriting — say so and we will do both. Otherwise re-draw
`337:6705`'s rows opaque.

### BUILT 2026-09-20, edit4 item #48 — what the ruling actually produced

Read first, built second. `337:6731` and its wrong twin were re-read off the Properties panel
on 2026-09-20, in the owner's signed-in Figma session:

| Dark row | Geometry | Fill | Stroke | Effects |
| --- | --- | --- | --- | --- |
| correct `337:6731` | 362 × 73, r16 | `#BFFFC3` **20%** | 0.5 `#00D33C`, inner | 1 effect (Glass; values hidden on this seat — #72) |
| wrong (its twin) | 362 × 73, r16 | `#FDE9E8` **20%** | 0.5 `#921019`, inner | 1 effect |

**Built:** three new `AppColors` tokens — `reviewRowCorrectFill`, `reviewRowWrongFill`,
`reviewRowSkippedFill` — plus `AppElevation.reviewRowGlass` (null light, G5 dark), consumed
through `ElevatedSurface`. Light is byte-identical to what shipped before; only dark moved.

Four decisions inside that, each of which could look like a mistake later:

1. **All three states take 20% and the same Glass**, including the skipped row the frame
   never draws. That is the ruling's "equal in treatment" clause. Here it costs nothing:
   20% is both the frame's number and the consistent one, so the clause and the literal
   value agree.
2. **The wrong row keeps the SHIPPED hue, not the frame's.** `#FDE9E8` / `#921019` is the
   drift **#52** already ruled unadopted; only the alpha follows the frame. Note this means
   the wrong row's alpha went **down**, 30% → 20% — it was never opaque.
3. **The correct row's foreground had to move, and it was READ, not chosen.** See #54.
4. **The quiz page's graded option tiles are untouched**, per the ruling's own scope. They
   are now visibly different from the review rows one tap apart: opaque mint there, a 20%
   wash with a Glass rim here. That is the comparison the ruling said to raise as a NEW
   question with both renders side by side. **It is open and nobody has looked at the two
   on a device yet.**

Pinned by `quiz_review_screen_test.dart`, whose dark-row assertions were **rewritten** to the
new ruling rather than deleted — including one that now asserts no row is left opaque beside
a glassed neighbour, which is the specific defect the ruling named.

---

## 54. 🟠 The dark review frame's foregrounds — PREMISE REFUTED 2026-09-20; it specifies four of them

> ⚠️ **CORRECTION, 2026-09-20.** This entry was titled *"The dark review frame specifies no
> FOREGROUND anywhere"* and every number under it was derived from that premise plus #53's
> since-superseded opaque-rows ruling. **Both are gone.** The dark frame was walked node by
> node on the Properties panel, in the owner's signed-in Figma session, and it specifies a
> foreground in every place this entry said it did not:
>
> | Element | Node | Value | Type |
> | --- | --- | --- | --- |
> | correct row question text | `337:6715` | **`#FCFBF9`** | Inter 500 / 18, line height 25.6 |
> | wrong row question text | `337:6725` | **`#FCFBF9`** | same |
> | "QUESTION n" label | `337:6711` | **`#AE87E7`** | Inter 400 / 12, line height 18 |
> | selected chip label ("All (10)") | inside `337:6825` | **`#FCFBF9`** | Inter 600 / 14 |
> | idle chip label ("Correct") | `337:6831` | **`#FCFBF9`** | Inter 600 / 14 |
> | correct badge tick | inside `337:6731` | `#FFFFFF`, 1.17 stroke | vector |
>
> The original finding is kept below for history. What is still open is narrower and is
> restated at the end of this entry.

**Where:** quiz review dark `337:6705` — rows (`162:2510` in light), the AI glyph, and the selected
filter chip (`337:6825`).

**What:** a foreground had to come from somewhere, and the obvious answer is wrong in a way worth
recording, because #53 causes it. Since the dark rows stay **opaque** (that ruling), the two fills
behave differently from each other:

- `quizCorrectFill` is opaque `#BFFFC3` in **both** canvases — it never follows the theme.
- `quizWrongFill` is 30% alpha and `quizOptionFill` follows the canvas — both **do**.

So a single foreground that flips with the theme puts cream on mint on every correct row in dark:
**1.11:1**, measured. Not dim — gone. And a single foreground that never flips puts dark green on
the dark-composited wrong row: **1.23:1**. Neither one value works for both rows.

**Built as:** the foreground follows the **fill**, not the canvas.

| Row | Foreground | Dark contrast |
| --- | --- | --- |
| correct | `quizReviewRowContent` — `#384F47`, identical in both palettes | 7.70:1 |
| wrong / skipped | `textPrimary` — flips, because their fills do | 6.94:1 |

The selected chip is the same class of fault and gained its own token: `colorScheme.onPrimary` is
`#FCFBF9` in both themes, right on the light chip's `#4B675E` (5.97:1) and wrong on the dark chip's
`#AE87E7` (**2.74:1**), so `quizReviewFilterLabel` is cream in light and the `#232428` page fill in
dark (5.48:1) — following the convention at `app_colors.dart:230-232`, *light is Figma-verbatim and
dark reuses an already-approved dark value rather than an invented hex.*

### What the rows actually do now (edit4 #48 / D-010, built 2026-09-20)

The fills stopped being opaque, so the old table's arithmetic is void. Composites are src-over
onto the `#232428` page; ratios are WCAG 2.1 with the sRGB linearisation.

| Dark row | Fill @20% | Composite | Foreground | Was | Is |
| --- | --- | --- | --- | --- | --- |
| correct | `#BFFFC3` | `#425047` | `quizReviewRowContent` | **1.04:1** with the old green | **8.24:1** with `#FCFBF9` |
| wrong | `#FFC0C0` | `#4F4346` | `textPrimary` | 6.92:1 at 30% | **9.11:1** |
| skipped | `#27282C` | `#242529` | `textPrimary` | 14.24:1 | **14.84:1** |

**The correct row's 1.04:1 is why `quizReviewRowContent` had to split.** It is the exact mirror
of the failure this entry originally recorded: a fixed dark-green foreground was right while
the fill was opaque mint and is invisible the moment the fill composites dark. The replacement
was **read off `337:6715`**, not chosen — which is also what refutes the premise above.

### Two things this did NOT fix, both still open

1. 🟠 **Non-text contrast fell, and the frame is what asks for it.** The hairlines and badges
   sit on a much darker surface now, and WCAG 1.4.11 wants 3:1 for them:

   | Mark vs its own row fill | @20% (shipped) |
   | --- | --- |
   | correct stroke `#00D33C` | 4.21:1 ✔ |
   | `successBadge` `#22C55E` | 3.74:1 ✔ |
   | wrong stroke `#921119` | **1.04:1** ✘ |
   | `quizWrongBadge` `#EF4444` | **2.50:1** ✘ |
   | skipped stroke `#4B675E` | **2.49:1** ✘ |

   The dark red hairline effectively disappears into its own row. It was already marginal —
   1.71:1 against the bare page — and the translucent fill finishes it. **Nothing was changed
   over this:** the stroke is the frame's own value at the frame's own alpha, the correctness
   signal is still carried by the badge and the text, and picking a lighter red would be
   inventing a token. It needs the designer, not a build decision.

2. 🟡 **Two frame values were read and deliberately not adopted.** Recording them so the gap
   is a decision rather than an oversight:
   - the **"QUESTION n" label** is `#AE87E7` lavender in the frame; the build paints it the
     same colour as the question text beneath it, because hierarchy there comes from size and
     weight. Adopting the lavender is a visual change with no elevation component, so it was
     out of edit4's scope.
   - the **selected chip label** is `#FCFBF9` in the frame, which is the 2.74:1 this entry
     already records. The build keeps `quizReviewFilterLabel` (the `#232428` page fill,
     5.48:1) because moving to the frame's value would be a deliberate accessibility
     regression. #77 is the sibling ruling and it accepted 2.74:1 for the pill track; whether
     it extends here is the designer's call.

**Fix we need:** a ruling on the wrong-row hairline at 1.04:1, and on whether the two read-but-
unadopted values above should ship as drawn.

**Update 2026-09-27 (API→UI Wave 14, owner ruling).** The "QUESTION n" label now has its own token,
`reviewRowLabel`: light takes the frame's `#4B675E` (`162:2492`), and **dark keeps cream**, not
`337:6714`'s lavender. On the dark row composites `#AE87E7` measures about **3.0:1** (correct row) and
**3.3:1** (wrong row), under the 4.5:1 a 12-pt label needs. The selected dark chip label stays `#232428`
as above. The wrong-row hairline question is unchanged and still open.

> ⚠ **The same fault is already shipped on the quiz page, and was left alone.**
> `question_option_tile.dart:119-120` paints the option label with `textPrimary` on
> `quizCorrectFill` — in dark, the identical **1.11:1** cream-on-mint. It is outside this day's
> scope and was not changed without a ruling. It needs one.

---

## 55. 🟠 The review frame has NO state for a skipped question

**Where:** quiz review `162:2377` — rows `162:2502` (correct) and `162:2563` (wrong) only.

**What:** the frame draws two row states. A quiz can be finished with questions never answered —
the result screen one push back has a whole **Skipped** bucket for exactly this, and the default
case (10 delivered, 8 answered) produces two of them. The frame has nowhere to put them.

**Built as:** a neutral row — the ungraded `quizOptionFill` / `quizOptionBorder` surface, with **no
✓/✕ mark and no AI glyph**, rather than a guessed third signal colour. Skipped is treated as its own
bucket throughout: the *Wrong* filter deliberately excludes it, matching `QuizSummary.wrong`, which
is `answeredCount − score` and not `totalQuestions − score`.
Code marker: `lib/features/quiz/screens/quiz_review_screen.dart` — `TODO(design)` on the `null` arm.

**Fix we need:** a skipped row design — fill, border, and whether the circle shows a dash, a hollow
ring, or nothing.

---

## 56. 🟡 The AI glyph on wrong review rows has no destination frame

**Where:** quiz review `162:2563` — the `tdesign:ai-education` glyph, wrong rows only.

**What:** the frame draws the glyph but specifies no tap target and no screen behind it. The
capability exists — `GET /questions/{id}/explanation` is `x-stability: stable` and
`AiExplanationPanel` is already built and shipped inside the quiz — so this is buildable the moment
a destination is specified. It is not buildable *now* without inventing one.

**Built as:** a **non-interactive indicator**, with a screen-reader label
(`quizReviewAiAvailable`) so it is not silent to assistive tech. Out of scope for Day 8-9 per the
Day 9 brief's assumption 6.

Two supplied assets differ in shape, not just colour: the light export (`Group.svg`, 27×25) carries
the cap **and** a 4-point sparkle; the dark export (`Vector.svg`, 27×24) carries the cap only. Read
as an export slip — the frame names one Iconify component and §1.4 describes dark as a colour
transform of light — so the app ships the **complete two-path glyph** as `assets/icons/ai_education.svg`
and recolours it per theme with a `colorFilter`, which is how every other SVG in this app is themed.

**Fix we need:** (1) does tapping it open the explanation, and in what — a sheet, a push, an inline
expand? (2) confirm the dark glyph should carry the sparkle.

---

## 57. 🟠 None of the review frame's four text styles exists in the type scale

**Where:** quiz review `162:2377` — title `162:2411`, filter label `162:2781`, "QUESTION n"
`162:2577`, question text `162:2510`.

**What:** all four are off the scale the designer supplied in `typography-style-inter.md`
(2026-08-21), which `AppType` transcribes verbatim:

| Frame | Nearest `AppType` | Drift |
| --- | --- | --- |
| 22 / 30.8 w700 (title) | `h2` 20/26 w700 | no 22px exists anywhere in the scale |
| 14 / 20 w600 (chip) | `labelLarge` 14/18 w600 | line-height 20 vs 18 |
| 12 / 18 w400 (QUESTION n) | `captionRegular` 12/16 w400 | line-height 18 vs 16 |
| 18 / 25.6 w500 (question) | `h3` 18/24 w600 | **weight and height both differ** |

There is no room to split the difference: `typography_discipline_test.dart` bans inline `fontSize`
**and** inline `fontWeight` outside `lib/core/theme/`, and the ratchet is 0.

**Built as:** mapped to the nearest existing entry — `h2` / `labelLarge` / `captionRegular` / `h3`
(owner ruling, 2026-09-08). The screen is therefore ~2px off the frame in four places, and the
question text is w600 where the frame says w500.

**Fix we need:** either extend `typography-style-inter.md` with the four missing entries, so they
can be transcribed into `AppType`, or re-spec `162:2377` onto the existing scale. The second is
cleaner long-term — a 22px title that exists once is a scale of one.

---

## 58. 🟡 The RTL review frame is half-done — built mirrored anyway; confirm

**Where:** quiz review RTL `549:20324` (LTR twin `162:2377`).

**What:** the frame exists, which the Day 9 brief did not know, but it is not a clean mirror.
Verified in a logged-in browser session, 2026-09-08:

| Element | State in `549:20324` |
| --- | --- |
| back chevron | ✅ mirrored to the right edge |
| filter row | ✅ mirrored, runs right→left: `الكل (10)` · `صحيح` · `خطأ` |
| header title | ❌ still reads **"Quiz Review"** in English |
| question rows | ❌ **not mirrored** — status circle still left, AI glyph still right |
| row copy | ❌ still English placeholder ("What is the powerhouse of the cell?") |

**Built as:** **mirrored**, deliberately — the rows use `EdgeInsetsDirectional` and a plain `Row`,
so they flip with the locale like every other list row in the app. Reproducing the frame here would
have shipped a bug. Title and copy are localized.

One deliberate copy divergence: the frame's chips read `صحيح` / `خطأ`, the app renders `صحيحة` /
`خاطئة` — the strings already shipped on the result screen one push back (`resultCorrect` /
`resultWrong`), human-written, and agreeing in gender with أسئلة. Reusing them beats translating the
same two words twice. §4 of the Day 8-9 brief sanctions keeping the app's shipped Arabic.

**Fix we need:** (1) mirror the rows in `549:20324` and localize its title and row copy, so the
frame stops disagreeing with the build; (2) confirm `صحيحة` / `خاطئة` over the frame's masculine
forms, or tell us to switch both screens.

---

> **#59–#67 filed 2026-09-12 with `docs/day10_mistakes_brief.md`** (the Mistakes / "My Fault"
> flow). Frames read anonymously in the Figma web app on that date — **no Properties panel**, so
> no exact geometry, colour or type value was captured for any frame in this family. Contract
> citations are **upstream `2dca3c5` (`3.13.0-m1`)**, not the vendored pin `184d6ec`, which does
> not contain this surface at all.

## 59. 🔴 Every Mistakes frame captions the count "N questions" — the field is `mistakeCount`

> ✅ **Built the contract's way, 2026-09-12 (Day 10).** New ARB key `mistakeCount`, an ICU
> `plural` in both locales; the frame's string is not transcribed anywhere.
> `test/features/mistakes/mistakes_screens_test.dart` asserts `20 mistakes` renders and
> `20 questions` does not. **Still open for the designer:** confirm the Arabic wording — the
> shipped `أخطاء` line was written here, not supplied, and the existing `mistakes` key is
> `أخطائي` ("my mistakes"), right for a button and wrong for a count caption.

**Where:** the whole `Learn(My Fault)` family — overview `404:6292` / `404:7110` (cards read
`20 questions`), Units `404:6539`, Chapters `404:6677`, Lessons `404:6762`, Lectures `404:7181`
(rows read `5 questions`, `15 questions`, `3 questions`, `1 questions`).

**What:** "20 questions" reads to a student as *how many questions this subject contains*. The
number is the opposite — how many they **currently have wrong** (upstream `openapi.yaml:915-920`,
`minimum: 1`). On a subject with 400 questions and 20 mistakes the copy is not vague, it is false.
This is the one number the entire flow exists to display.

**Fix we need:** designer supplies count copy that says *mistakes*, in both languages. The existing
ARB key `mistakes` is `أخطائي` ("my mistakes") — right for the header button, wrong as a count
caption, so this is a new string and not a reuse.

**Meanwhile in code:** the brief instructs the build to write mistake-copy and **not** transcribe
the frame's string. Contract wins.

## 60. 🟠 The Mistakes family has no empty state, and the contract makes empty the happy path

> ✅ **Neutral copy shipped 2026-09-12 by owner ruling; the design gap stays open.** The
> owner was asked before any copy was written, exactly as this entry demanded, and chose the
> register the app already uses — `noMistakes` = "No mistakes yet" / "لا توجد أخطاء",
> alongside `noSubjects`, `noLectures` and `nothingHere`. **No celebratory tone was
> invented.** Swapping in a warmer line later is a one-key change with no migration, which is
> why this could ship without blocking. Both empty cases render it — `200 []` on the
> overview and `mistakeCount: 0` with an empty child list on the tree — and a test asserts
> neither renders as an error.

**Where:** all six list frames.

**What:** the contract defines **two distinct** normal-empty responses and forbids rendering either
as an error — *"Clients MUST NOT render empty-as-error"* (upstream `:895-897`) for the overview's
`200 []`, and *"a normal response, not an error and not a `403`"* (`:960-964`) for an in-scope
subject returning `mistakeCount: 0` with an empty `units`/`lectures`. Neither frame draws an empty
state. The overview's empty state is the **happy path** — a student with nothing outstanding is a
student doing well.

**Fix we need:** a designed empty state for the overview (and ideally the tree), with its copy. The
*tone* is a product decision.

**Meanwhile in code:** `CatalogMessage`'s defaults render something correct, so this does not block
the build — but the brief marks celebratory copy as **stop-and-ask**, not something to invent.

## 61. 🟠 `insufficient_scope` means two different things, and the shared view collapses them

> ✅ **Fixed 2026-09-12 (Day 10).** `CatalogAsyncView` now takes a `ScopeErrorCopy` enum
> (`catalog_states.dart`) and the ROUTE states which meaning it carries, because the wire
> gives both the same code string. `subjectNotYours` is the default and is unchanged for
> every catalog screen; the Mistakes overview passes `enrolmentPending`, which swaps in the
> new `mistakesEnrolmentPending` key **and restores the retry button** the subject route
> suppresses — the state is transient (adr-032), so retrying is legitimate. Two tests hold
> the branches apart, including the one this entry asked for by name: the overview's `403`
> must not show `subjectUnavailable`.

**Where:** `lib/features/catalog/widgets/catalog_states.dart:51-64`, `:74-80`.

**What:** `CatalogAsyncView` maps `insufficient_scope` to `l10n.subjectUnavailable` ("isn't part of
your course") and suppresses retry. Correct for `getMyMistakesForSubject`. **Wrong for
`getMyMistakes`**, where the identical code means *"the caller currently has no active enrolment to
scope their history against"* — reachable in ordinary use because a track transfer closes the old
enrolment before the new one opens (adr-032, upstream `:925-939`). The contract is explicit:
*"it means something DIFFERENT from the subject route's `403` — do not collapse the two branches"*,
and it is *"not a reason to retry, and not a reason to log out"*.

**The code string is identical on both routes** — the client must branch on the **route**, not the
code.

**Fix we need:** copy for "your enrolment is between states" in both languages.

**Code marker:** `lib/features/catalog/widgets/catalog_states.dart:51`. Related to **S41** but
distinct — S41 is about two causes behind *one* route's 403; this is one code across *two* routes.

## 62. 🟠 `account_pending_deletion` has a mandated destination that does not exist

**What:** both Mistakes routes can return `403 account_pending_deletion`, and the contract's client
rule is unambiguous — *"do **not** log the user out and do **not** retry — route to the cancel
screen, drawn from `GET /me`'s `pendingDeletion.effectiveAt`"* (upstream `:82-83`). The grace-window
allowlist is an **exact four routes** and neither Mistakes route is on it (adr-114), so the refusal
lands before either handler runs.

There is no cancel screen, no route, and no `DELETE /me/deletion-request` call anywhere in `lib/`.

**Status change:** `seif_fight.md` **S38** filed this on 2026-09-04 as "Account deletion has no
endpoint". **That is now out of date** — `requestAccountDeletion` and `cancelAccountDeletion` are
both `x-stability: stable` at the target pin. The blocker is now build effort, not contract.

**Owner:** **not the Mistakes feature.** The code handling belongs in the global error interceptor
(one place, every endpoint); the screen belongs to the account surface. Day 10 only ensures the
code is not swallowed.

## 63. ❌ WITHDRAWN (same day) — the dark-mode frames DO exist; dark VALUES are still owed

> 🔴 **Corrected 2026-09-12, hours after filing.** The claim below — that `Dark mode`
> carries no Mistakes frames — is **WRONG**, and is kept rather than deleted because the way it
> went wrong is reusable. A signed-in pass ran Figma's layer search (`ctrl+F`, scope *This
> page*) for `My Fault`: **19 results — 18 frames plus one layer of that name — i.e. 6 per
> group across `light mode`, `Dark mode` and `RTL`.** `404:7428` was selected directly and is a
> **dark Mistakes overview**: 402×841, radius 30, canvas `#232428`, pink cards and red counts on
> the dark ground. `404:7894` and `404:7990` are two more dark family members.
>
> **Root cause — this will bite again.** The layer name carries a stray Arabic **kasratan**:
> the real string is `Learn(ٍMy Fault) for school student`, not `Learn(My Fault)`. Every search
> for the clean spelling returns nothing, silently. The same typo is in `Learn(ٍSubject)`.
> **Search `My Fault`, never `Learn(My Fault)`** — and never conclude absence from a
> virtualised layer panel.
>
> **What survives, and it is the half that mattered:** the dark **values** are still unread. Do
> not infer them from the light frames — read `404:7428` and its siblings. Still open; see #70.

**Where:** page `design` → group `Dark mode` → `School Student Flow`.

**What:** the group contains the four **catalog** frames (`Learn(lessons)`, `Learn(Chapter)`,
`Learn(Units)`, `Learn(Subject)`) and **no `Learn(My Fault)` entry**.

⚠️ **Verification level: strong but NOT conclusive.** Confirmed by two overlapping screenshots of
the layers panel plus an accessibility-tree query returning no match — but the panel is
**virtualised**, and `Dark mode → University Student Flow` and the **entire `RTL` group** were not
enumerated (the viewport collapsed mid-session and Figma's sign-up banner covered the panel). Do
not quote this as settled until a signed-in seat re-checks it with Figma's layer search.

**Why it matters more than usual:** the rows are pink/red on a light canvas and the correct dark
fill cannot be safely inferred. This repo has already paid for that twice on the review screen —
**#53** and **#54** — where an opaque correct-row fill produced a measured **1.11:1**
cream-on-mint in dark.

**Fix we need:** dark values for the Mistakes row fill, border and count caption.

**Meanwhile in code:** derive from the shipped quiz wrong-answer tokens
(`quizWrongFill`/`quizWrongBorder`/`quizWrongBadge`) rather than inventing, **measure** the
contrast, and record the figure — per `AGENT_WORKFLOW.md` §"Theme discipline", document the
uncertainty rather than invent a value.

## 64. ✅ MAPPED 2026-09-27 (API→UI Wave 18) — RTL variants exist; their node IDs are not yet mapped

> **Updated 2026-09-12.** The 19-result layer search (see #63) proves a **complete 6-frame RTL
> family**. What is missing is only the node-ID → screen mapping — clicking, not research.

**What:** the `RTL` group's individual frame IDs are unmapped. Figma syncs `node-id` into the
address bar only lazily after a selection settles, so enumerating the 12 dark + RTL IDs costs one
round trip each. Method: `ctrl+F` → `My Fault` → scope *This page* → click each row, reading the
`node-id` after each settles (`shift+2` forces the sync); identify the group from the canvas
ground — light `#FCFBF9`, dark `#232428`, RTL mirrored/Arabic.

**Meanwhile in code:** built mirrored regardless — `EdgeInsetsDirectional`,
`forwardChevron(context)`, no hardcoded `TextDirection` — because that is how every other list in
this app works and because reproducing a half-done RTL frame would ship a bug. Precedent: **#58**,
where the RTL review frame turned out to be half-mirrored and the build correctly ignored it.

> **Mapped 2026-09-27 (API→UI Wave 18).** A read-only plugin query over the Figma MCP listed every
> `Learn(My Fault)` phone frame on the `design` page (`57:36`), each identified by what it draws (its
> header title and its rows), not by its position. All 18:
>
> | Group | Overview | Units / Lectures | Chapters | Lessons |
> | --- | --- | --- | --- | --- |
> | School, light | `404:6292` | `404:6539` | `404:6677` | `404:6762` |
> | School, dark | `404:7428` | `404:7669` | `404:7894` | none: see below |
> | School, RTL | `549:19213` | `549:19284` | `549:19337` | `549:19390` |
> | University, light | `404:7110` | `404:7181` | — | — |
> | University, dark | `404:8623` | `404:8686` | — | — |
> | University, RTL | `565:18246` | `549:28773` | — | — |
>
> - **No dark frame draws Lessons.** `404:7990`, the dark frame in the Lessons slot, draws a Chapters
>   list: the title "Cell Biology Chapter" and four rows ("Cell Biology", then "Genetics" three times,
>   numbered 1, 2, 2, 2). Its list rhythm is the family's (25 under the header, rows 16 apart), and its
>   rows are the dark Chapters rows (#68, #70). The dark Lessons screen is checked against those.
> - **The RTL family is half-done, as this entry guessed.** Its headers mirror (the back chip on the
>   right, Arabic titles such as "دروس بنية الخلية"), but its rows do not: on all four RTL row frames
>   (`549:19284`, `549:19337`, `549:19390`, `549:28773`) every row keeps its badge 17 from the LEFT
>   and its chevron at the right, with English names and counts (`549:19390`'s render measures the
>   light row's numbers exactly). The build keeps its mirrored rows.

## 65. 🟡 The Mistakes frames' placeholder counts do not reconcile across levels

**Where:** `404:6539` shows unit "Cell Biology" = **5**; `404:6677` shows its chapters as **3** and
**1** (sum 4). The overview's `20` does reconcile with the units (5 + 15).

**What:** placeholder data, not a specification. The contract guarantees *"Every parent's
`mistakeCount` is the SUM of its descendants'"* (upstream `:953-957`).

**Fix we need:** nothing from the designer — **recorded so that nobody "fixes" the client to
reproduce the frame's arithmetic, and nobody files the discrepancy as a server bug.** The client
renders server numbers verbatim and performs no arithmetic at all.

## 66. 🟡 The Mistakes frames do not pluralise ("1 questions")

> ✅ **Built 2026-09-12.** `mistakeCount` is an ICU `plural` and is **the project's first** —
> `app_en.arb:428` previously recorded "the project has no ICU plural anywhere". Arabic
> carries all six categories and they are genuinely different words, not one stem with a
> number in front: `خطأ واحد` (one) · `خطآن` (two) · `3 أخطاء` (few, 3–10) · `20 خطأً`
> (many, 11–99) · `100 خطأ` (other). A test asserts one of each.
>
> **Digits are Western**, not Arabic-Indic — `intl` formats `ar` that way in this app, which
> #19 already records and two other tests already assert. Not changed here; whether Egyptian
> students should see ٠١٢ is a design question and is still that one.

**Where:** `404:6762` and `404:6677` both render `1 questions`.

**Fix we need:** nothing — but the ARB entries must use ICU `plural` in both languages. Arabic has
**six** plural categories (`zero`/`one`/`two`/`few`/`many`/`other`), so a naive interpolation is
wrong here specifically, not merely untidy.

## 67. 🟠 The replay-quiz frames draw a nav bar; the built quiz screens live outside the shell

**Where:** `404:6853` (school) and `404:7234` (university) — both are **Quiz pages**, the terminal
"replay" step of the Mistakes flow, not mistakes lists. (`docs/day7_quiz_brief.md:95` had assigned
them to this flow on positional evidence alone; opening them confirms the membership and corrects
the kind.)

**What:** both draw the bottom nav bar with `Learn` active, but `/quiz/*` routes sit at top level in
`app_router.dart`, deliberately outside the `StatefulShell` — the Day 9 brief records the same
frame detail for `162:2377` as *"drawn, but IGNORE"*. Either the replay quiz is a different,
in-shell surface, or these frames inherit a template.

**Fix we need:** designer confirms whether the replay quiz keeps the nav bar. **Not urgent** — the
replay is out of scope for Day 10 (owner ruling 2026-09-12); recorded now so it is not discovered
late on the day it is built.

## 68. 🔴 The Mistakes family mixes Inter and Cairo, and none of its five type styles is in the scale

> ✅ **Resolved in build 2026-09-12 on the #57 precedent, as this entry instructed —
> not re-derived.** Every style mapped to the nearest existing `AppType` entry by ROLE:
> card title and row name (Inter 700/16 and 600/16) → `AppType.h3`; both count captions
> (Cairo 600/14) → `AppType.labelLarge`. **Cairo was NOT added to the design system** and
> the scale gained nothing. Both ratchets stayed at **0**.
>
> Two sub-findings deliberately not transcribed: the **10.62px line height on a 14px font**
> (smaller than the glyph box — it would clip its own descenders, a Figma artefact rather
> than intent) and the row name's **`#000000`** (pure black is not in this palette at all;
> the shipped `#384F47` is used, per #57).
>
> **Still open for the designer:** whether the Cairo/Inter mix was deliberate.
>
> **Update 2026-09-27 (API→UI Wave 15), overview card only:** the mapped styles are unchanged, but the two lines
> now sit at the frame's line CENTRES, 34.16 and 61.78 below the card's top (from `404:6325`'s insets and the two
> leadings above), instead of in a centred block, which had put the title 3.7 high. On a real-font render the
> title's ink starts 0.2 and the count's 0.6 from the frame's.
>
> **Update 2026-09-27 (API→UI Wave 16), tree rows:** the same treatment on the Mistakes rows (`404:6642`). The name's
> line is centred 28.0 and the count's 46.5 below the row's top, with the badge and chevron at 37.0; the build had
> 29, 54 and 40 (a centred 46-dp text block, plus a 4-dp spacer the frame does not draw), in an 80-dp row. In the
> scale's lines (24 and 18) the two centres are closer than the lines, so the count is lifted 2.5 into the name's
> trailing space. On a real-font render the name's ink starts 0.3 and the count's 1.0 from the frame's; the row is 78.
> The badge numeral is `#000000` in the frame too (`404:6645`) and takes the content colour like the name.
> **Frame inconsistency, not built:** the dark Units row (`404:7765`) and the dark Lectures frame's first row
> (`404:8707`) centre their text block instead (name ~30.4, count ~51.5), while every light row, the dark Lectures
> frame's second row (`404:8723`) and the Chapters frame (`404:6677`) put it at 28.0 / 46.5. The build follows the
> majority in both palettes.
>
> **Update 2026-09-27 (API→UI Wave 17), Chapters:** the light Chapters rows (`404:6697`, `404:6708`) are the Units
> row exactly (on the 1× render the name's ink starts 21 below the row's top, the count's 42, and the chevron's ink
> ends 22 from the row's end). The dark Chapters frame (`404:7894`) repeats the inconsistency on both rows. The first
> (`404:7915`) centres its text block (name ink top 24, count 47). The second (`404:7931`) keeps the name at the light
> position but wraps the count in a "Group 2" with a 2.574 top pad (count ink top 45 against 42). Not built: the build
> keeps one geometry in both palettes.

**Where:** measured off the Properties panel, 2026-09-12 (signed-in view seat).

| Element | Node | Font | Weight | Size | Line height | Colour |
| --- | --- | --- | --- | --- | --- | --- |
| Card title "Biology" | `404:6329` | **Inter** | 700 Bold | 16 | 14.85 | `#384F47` |
| Card caption "20 questions" | `404:6338` | **Cairo** | 600 SemiBold | 14 | **10.62** | `#EF4444` |
| Row name "Cell Biology" | `404:6648` | **Inter** | **600** | 16 | 21 | **`#000000`** |
| Row caption "5 questions" | — | **Cairo** | 600 SemiBold | 14 | **10.62** | `#EF4444` |
| Row index badge "1" | — | **Cairo** | 700 Bold | 16 | 24 (cap-height trim) | not captured |

**Four problems in one table:**

1. 🔴 **Cairo is not in the design system.** Wave 3D's handoff `typography-style-inter.md`
   (2026-08-21) supplied **18 Inter styles**, transcribed verbatim into `AppType`
   (`lib/core/theme/app_typography.dart`). Cairo appears nowhere else in the app. Deliberate (it
   renders Arabic-Indic digits well) or drift? **We will not guess** — adding a second family to
   the design system is precisely the Wave 3D trap.
2. 🔴 **None of the five styles exists in `AppType`**, and the ratchet is **0** — no inline
   `fontSize:`/`fontWeight:` may be written. Same situation as **#57**, which the owner settled for
   the review screen by mapping to nearest-existing rather than extending the scale. **Ask for the
   same ruling; do not re-derive it.**
3. 🔴 **Line height 10.62px on a 14px font** — smaller than the glyph box, clipping descenders.
   Almost certainly a Figma artefact, but it must not be transcribed.
4. 🟠 **Two different "primary text" colours in one family** — row name `#000000`, card title
   `#384F47`. **Pure black is not in the palette at all**; `#384F47` *is* a shipped token
   (`quizReviewRowContent`, added Day 9). Use the token; do not add black.

**Fix we need:** confirm Cairo-vs-Inter; confirm the line height is an artefact; pick one primary
text colour.

## 69. 🟠 The Mistakes overview card carries two pure-black drop shadows

**Where:** `404:6322` — `#000000` at **25%**, twice: X 0.53 / Y 0 / blur 1.06 / spread −0.53, and
X 0 / Y 0.53 / blur 1.59 / spread 0.

**What:** **#47** already records *"Five drop shadows are pure black, which does not exist on the
dark canvas"*. These are instances six and seven.

**Fix we need:** the same ruling as #47, plus the dark frame's own shadow values — `404:7428` must
be read rather than having the light values reused.

> ✅ **Built 2026-09-12 through `elevationShadow`.** The card routes both shadows through the
> per-canvas token rather than painting `#000000`, exactly as `profile_header_card.dart:45`
> already does — so #47's ruling is applied without waiting on a capture. The two are collapsed
> into one `BoxShadow`: they differ by half a pixel of offset and composite to a single visible
> edge. The palette guard would have rejected the literal anyway, which is the guard working.
>
> **Still owed:** the dark frame's own shadow values, if they differ. Folded into #70.

> ✅ **Built EXACTLY 2026-09-19 (edit3 #10), and the collapse above is withdrawn.** Both shadows
> are now drawn, as two shadows, **black on both canvases**, through
> `AppElevation.mistakesCardShadows` under `ElevatedSurface`.
>
> Three things changed the answer. The dark frame `404:7637` was read and carries **the same black
> pair** — so there were never two sets of values to reconcile. The dark card is a **30% wash**,
> not an opaque fill, so black under it is not "nothing": it composites with the page and is
> visible, which is the premise #47 got wrong and #72 corrected. And `ElevatedSurface` knocks each
> shadow out behind the shape (edit1.md R4), so the 30% fill composites over the PAGE rather than
> over its own shadow — something a `Material` elevation could not do at any `shadowColor`.
>
> The half-pixel offset difference that justified collapsing them is now drawn as measured; at
> 1.06 and 1.59 blur they do composite to one visible edge, but that is a rendering outcome, not
> an approximation the code makes. Dark additionally carries Glass **G5**.
>
> This removed the last two `raw elevation effects` sites outside edits 4 and 5: the guard ratchet
> went 9 → 7 in the same change (`test/guards/project_rules_test.dart`).

## 70. ❌ RULING WITHDRAWN — the dark frames draw DARK cards; the carry-over rested on a misread

> 🔴 **Corrected 2026-09-12 (late) — the owner ruling recorded below is WITHDRAWN.** It is
> kept, not deleted: the way it went wrong is the reusable part.
>
> *Originally filed as: "The dark Mistakes frames exist but their VALUES are unread".*
>
> **The sequence, in order:**
>
> 1. **The observation.** `404:7428` was opened and *seen* drawing "the same pink cards and red
>    counts" on the `#232428` canvas. Only the frame's canvas fill was read off the Properties
>    panel. No card, row, text or border hex was.
> 2. **The decision it produced.** On that observation, all four Mistakes tokens were carried into
>    the dark palette unchanged, and the ruling below was written to defend the carry-over.
> 3. **The arithmetic was right.** 11.06:1, 6.30:1, 4.40:1, 2.68:1, 1.36:1 and 1.91:1 were each
>    re-derived independently and reproduce exactly — for a pink card on a dark canvas.
> 4. **The premise was wrong.** The owner compared the device build with the dark frames and they
>    did not match. Read off the Properties panel, the dark family draws a **dark** card and row
>    with **cream** text. Nobody had checked the thing being measured.
> 5. **So the ruling is invalid.** "What `404:7428` was observed drawing" was never true, and the
>    "measurably safer" comparison ranked two candidates the dark design does not contain.
> 6. **The Figma values are now the source of truth** — the table below.
> 7. **The implementation follows them.** The dark palette in `app_colors.dart` is corrected, and
>    two tokens are added because dark separates what light had merged.
>
> **Why step 3 did not catch it:** re-deriving a ratio verifies the sum, not the question. The
> 2026-09-12 device pass then saw pink-on-dark render "correctly" and recorded that as
> confirmation — it checked the build against the code, not against the frames.
> `docs/DEVICE_VERIFICATION_2026-09-12.md` carries its own correction.
>
> **Read values — dark family, 2026-09-12.** Figma desktop, signed-in view seat, Properties panel;
> node IDs from *Copy link to selection*. The same values were read on the dark **Units, Chapters
> and Lessons** rows, the dark school **overview**, and the dark **University** overview
> (`404:8623`) and **Lectures** (`404:8686`) frames, so they are family values, not
> frame-specific. Every colour row showed a raw hex — none is a named style or variable.
>
> | Element | Node · layer | Figma property | Figma value | Dark, before | Dark, now |
> | --- | --- | --- | --- | --- | --- |
> | Card fill | `404:7637` · `Container` | fill | `#27282C` @ **30%** | `mistakesCardFill` `#EAD5D5` | `mistakesCardFill` `#27282C` @ 30% |
> | Card title | `404:7642` · `Biology` | text fill | `#FCFBF9` | `mistakesContent` `#384F47` | `mistakesContent` `#FCFBF9` |
> | Card caption | `404:7649` · `20 questions` | text fill | `#EF4444` | `mistakesCount` `#EF4444` | unchanged |
> | Card chevron | `404:7651` · `Vector` | fill | `#FCFBF9` | `mistakesContent` `#384F47` | `mistakesContent` `#FCFBF9` |
> | Card shadows | `404:7637` | 2 × drop shadow | `#000000` @ 25%, same as light | via `elevationShadow` (#69) | unchanged |
> | Card border | `404:7637` | Layout "Border 0.63px" | no stroke colour exposed — same as light | none drawn | none drawn |
> | Row fill | `404:7765` · `Button` | fill | `#27282C` @ 100% | `mistakesCardFill` `#EAD5D5` | **new** `mistakesRowFill` `#27282C` |
> | Row hairline | `404:7765` · `Button` | stroke 0.5px, inside | `#FCFBF9` | `mistakesRowBorder` `#4B675E` | `mistakesRowBorder` `#FCFBF9` |
> | Row name | `404:7771` · `Cell Biology` | text fill | `#FCFBF9` | `mistakesContent` `#384F47` | `mistakesContent` `#FCFBF9` |
> | Row count | `404:7884` · `20 questions` | text fill | `#EF4444` | `mistakesCount` `#EF4444` | unchanged |
> | Badge disc | `404:7767` · `Container` 40×40 | fill (+ 1 effect) | `#27282C` @ **20%** | `cardFill` `#232428` @ 20% | **new** `mistakesBadgeFill` `#27282C` @ 20% |
> | Badge numeral | `404:7768` · `1` | text fill | `#FCFBF9` | `mistakesContent` `#384F47` | `mistakesContent` `#FCFBF9` |
> | Row chevron | `404:7778` · `Vector` | stroke 1.33px | `#FCFBF9` | `mistakesContent` `#384F47` | `mistakesContent` `#FCFBF9` |
>
> **Light is unchanged**, the badge disc included: its light Figma colour has never been read, so
> it keeps the shipped light `cardFill` `#FDFDFD` through the new `mistakesBadgeFill`. Both
> palettes are pinned value-by-value in `test/core/theme/app_colors_test.dart`.
>
> **Still unread, and not guessed:** the badge disc's single **effect** (its popover would not
> open on a view seat, so its type and values are unknown and nothing is built for it), and
> whether the light disc really is `#FDFDFD`.
>
> **Update 2026-09-27 (API→UI Wave 16):** the light disc HAS now been read: `get_design_context` on `404:6642` gives
> its disc (`404:6644`) the fill `#F4E6FF`, the catalog disc's lavender. `mistakesBadgeFill` light is now `#F4E6FF`;
> the dark value is unchanged. The effect is still unread.
>
> **Separate, and unchanged by this correction:** the dark rows draw chevrons toward the replay
> Quiz page; the built leaves stay inert because the replay quiz is deferred (owner ruling
> 2026-09-12). That is a deferred feature, not a theme defect. The count caption's contrast is
> re-measured in **#71**.

**Where:** `404:7428` (dark Mistakes overview — 402×841, radius 30, canvas `#232428`), plus
`404:7894`, `404:7990` and the rest of the dark family.

**What:** #63 was withdrawn because the frames exist — but only the frame-level canvas fill has
been read. The **card fill, row fill, border, count colour, text colours and shadows on the dark
ground are all still unmeasured**, and the light values must not be reused for them.

**Why this is the dangerous one:** the light row is `#EAD5D5` with `#EF4444` text and a `#4B675E`
border. Carried onto `#232428` unchanged, that is the exact failure **#53/#54** shipped on the
review screen — a measured **1.11:1**. Every dark token must be read from `404:7428` and its
siblings and its contrast **measured**, per `AGENT_WORKFLOW.md` §"Theme discipline".

**Fix we need:** nothing from the designer — the frames exist. This is a capture task, recorded so
it is not mistaken for a design gap.

> ✅ **Resolved by owner ruling 2026-09-12 — and the paragraph above gets a correction.**
>
> 🔴 **"Carried onto `#232428` unchanged, that is the exact failure #53/#54 shipped — a measured
> 1.11:1" is WRONG, and the numbers say so.** #53/#54 was a foreground that FOLLOWED the theme
> landing on a fill that did not — cream on opaque mint. Carrying *everything* unchanged is the
> opposite move and cannot reproduce it. Measured before the ruling, not after:
>
> | Pair | Ratio | |
> | --- | --- | --- |
> | `#EAD5D5` card vs the `#232428` canvas | **11.06:1** | the card reads as its own surface |
> | `#384F47` title/row name on `#EAD5D5` | **6.30:1** | passes AA |
> | `#4B675E` border on `#EAD5D5` | 4.40:1 | non-text |
> | **Rejected** — dark `quizWrongFill` over `#232428` = `#655356`, with `#EF4444` on it | **1.91:1** | WORSE than the light row, and the actual #53/#54 repeat |
> | **Proof of the rule** — dark `textPrimary` `#FCFBF9` on `#EAD5D5` | **1.36:1** | what a theme-following foreground would do here |
>
> So all four tokens are **identical in both palettes** (`mistakesCardFill`, `mistakesContent`,
> `mistakesCount`, `mistakesRowBorder`), which is also what `404:7428` was observed drawing —
> "the same pink cards and red counts on the dark ground". The rule is the one
> `quizReviewRowContent` already states: **a fill that never changes needs a foreground that
> never changes.**
>
> **What is still genuinely unread**, and is now the whole of this entry: the dark frame's own
> hexes were never taken off the Properties panel — only its canvas fill. If a capture pass ever
> shows `404:7428` using different values, this decision is reversible in one file. The shadow
> values from #69 belong to the same pass. The red-on-pink contrast problem the capture did NOT
> cause is split out as **#71**.

## 71. 🔴 REOPENED — the count caption fails AA in both palettes, on different grounds: 2.68:1 light, 3.91:1 / 4.07:1 dark

> 🔴 **Reopened and revised 2026-09-12 (late), with #70.** The original finding is kept below.
>
> *Originally filed as: "The count caption measures 2.68:1 on its own card — in BOTH canvases".*
>
> | | Light | Dark |
> | --- | --- | --- |
> | **Previous finding** | `#EF4444` on `#EAD5D5` = **2.68:1** | "identical in both canvases" — the same 2.68:1 |
> | **Status of that finding** | ✅ still valid — the light frame really is pink | ❌ invalid — it rested on #70's pink premise |
> | **Actual surface** | `#EAD5D5` (`404:6322`, `404:6642`) | row `#27282C` (`404:7765`); card `#27282C` @ 30% over `#232428` = `#242529` (`404:7637`) |
> | **Actual count colour** | `#EF4444` (`404:6338`) | `#EF4444` (`404:7884` row, `404:7649` card) |
> | **Measurement** | **2.68:1** | **3.91:1** on the row · **4.07:1** on the card |
> | **WCAG AA, 14px normal text (4.5:1)** | ❌ fails | ❌ fails, on both surfaces |
>
> **Final accessibility conclusion.** The caption fails AA in **both** palettes, as designed. Dark
> comes closer but is still short, and **the failure now lives in the Figma design itself, not in
> the build** — the build reproduces the frames' values exactly. So the red was **not** darkened:
> that would contradict the frame and invent a token. The `#B91C1C` idea below was measured on the
> pink only; on the dark row it measures **2.28:1**, so it cannot be the fix for both palettes.
> **Escalated to the designer** as one question covering both grounds.
>
> Every figure is WCAG 2.x relative luminance, with translucent fills composited source-over
> before measuring.

> **Found by measurement during the Day 10 build, 2026-09-12.** Not a capture gap and not a
> dark-mode problem: this one is in the light frames, where it was specified.

**Where:** `404:6338` (card caption) and the row caption — `#EF4444` on the `#EAD5D5` fill of
`404:6322` / `404:6642`.

**What:** **2.68:1**, against WCAG AA's 4.5:1 for normal text at 14px. Because the fill and the
count are both canvas-independent (#70), the figure is identical in light and dark — this is not
a theme bug that one canvas escapes.

**Why it was shipped rather than corrected:** darkening the red would be inventing a design token
the designer did not supply, on a surface where every other value is measured. That is precisely
the Wave-3D trap #68 exists to name. The measured number is recorded in
`app_colors.dart`'s `mistakesCount` doc so the next reader finds it rather than re-deriving it.

**Fix we need:** a ruling. Either a darker red for the caption (`#B91C1C` on `#EAD5D5` would
clear AA), a darker pink ground, or an explicit accept — the caption is short, bold-ish and
paired with the subject name, so the practical harm is smaller than the ratio suggests. What must
not happen is the number being quietly forgotten.

---

## 72. 🟠 Glass and lavender back-lights — the dark canvas's real elevation mechanism, read with a plugin because the seat hides it

**Where:** the whole `Dark mode` section of `P6044i0giD9TmdQ7C2AmLq`. Code:
`lib/core/theme/app_elevation.dart`, `lib/core/theme/glass_mapping.dart`,
`lib/core/widgets/elevation/`. Supersedes the derivation in **#47**; reasoning in
`docs/DECISIONS.md` **D-009**.

**What.** The dark frames do not elevate with a shadow. They elevate with Figma's **Glass** effect
over a 20%-alpha fill, plus a solid lavender ellipse locked behind the surface. Both were invisible
to this project for two months, and the reason they were invisible is itself the finding:

> **The view-only seat hides Glass in every surface Figma offers.** Design panel (icon only), Dev
> Mode inspect, CSS / SwiftUI / UIKit export, Copy properties, Copy as SVG. The design-mode Plugins
> menu reads "Unavailable in view-only". A surface with Glass therefore inspects as a plain
> translucent rectangle — which is exactly how it was built.

**How the values were read (2026-09-17, with the owner's approval).** A local **Dev Mode development
plugin** — no network, reading `node.effects` only, removed afterwards — walked every node on the
`design` page. The Plugin API reports Glass as
`{type:"GLASS", radius, refraction, depth, lightAngle, lightIntensity, dispersion, splay}`. 2169
nodes carry effects and **20 distinct Glass settings** exist. Values are the Figma UI values (the
API returns float32, so `0.7300000190734863` is 0.73).

### The twenty Glass groups

`frost` is the plugin's `radius`. Angles are degrees, in Figma's convention (y-up).

| # | Token | frost | refr | depth | angle | intens | disp | splay | Example node | Built by |
|---|---|---|---|---|---|---|---|---|---|---|
| G1 | `onboardingSheetGlass` (**both canvases**) | 80 | 0.73 | 27 | 37 | 0.95 | 0.62 | 0.76 | `459:43873`, `337:15643` | edit2 |
| G2 | `registrationBackChipGlass` | 20 | 1.00 | 36 | 22 | 0.25 | 0.70 | 0.16 | `337:19690` | edit2 |
| G3 | `languagePillGlass` | 4 | 0.80 | 20 | −45 | 0.25 | 0.50 | 0 | `340:19734` (all 7 pills) | edit2 |
| G4 | `fieldGlass` | 0 | 1.00 | 53 | 28 | 0.25 | 0.50 | 0.97 | `348:8659` (19 nodes) | edit2 |
| G5 | the Figma **default** | 4 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | 363 nodes | edits 2–5 |
| G6 | `levelCardGlass` | 62 | 0.80 | 78 | −45 | 0.80 | 0.50 | 1.00 | `337:5336` | edit3 |
| G7 | `dailyTasksGlass` | 39 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:5357` | edit3 |
| G8 | — not built | 4 | 0.80 | 20 | −45 | 0.80 | 0.43 | 0 | Home task discs `337:5359` | — |
| G9 | `topStudentGlass` | 34 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:5460` | edit3 |
| G10 | `leaderboardRowGroupGlass` | 4 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0.31 | `337:5629` (the GROUP) | edit4 |
| G11 | — not built | 76 | 0.87 | 38 | −45 | 0.80 | 0.48 | 0.27 | drill-down search `348:7436` | — |
| G12 | — blocked (S15) | 73 | 0.80 | 20 | −45 | 0.80 | 0.11 | 0.59 | pool card `337:6275` | — |
| G13 | `quizPrevButtonGlass` | 45 | 0.63 | 17 | 51 | 0.80 | 0.50 | 0.48 | `337:6464` (13 nodes) | edit4 |
| G14 | `rewardsCardGlass` | 54 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:6680` | edit4 |
| G15 | `profileHeaderGlass` | 57 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:7455` | edit5 |
| G16 | `settingsSectionGlass` | 63 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `642:8583`, `337:8195` | edit5 |
| G17 | — not built | 48 | 0.82 | 58 | −45 | 0.80 | 0.50 | 0 | Customer Support `337:8543` | — |
| G18 | `aiPanelGlass` | 33 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:9270` | edit4 |
| G19 | `otpDigitGlass` | 56 | 0.80 | 100 | −45 | 0.80 | 0.65 | 0.50 | `I337:19295;337:19276` | edit5 |
| G20 | `trackCardGlassFirst` | 4 | 0.80 | 20 | 25 | 0.80 | 0.50 | 0 | `337:15981` | edit5 |

**G1 is the only Glass in a light frame.** Every other row is `Dark mode` only, which is what makes
Glass a *mechanism* rather than a decoration: the two canvases raise a surface by different means.

Two pairs look like duplicates and are not. **G3 and G5** differ only in `lightIntensity` (0.25
against 0.80). **G5 and G20** differ only in `lightAngle` (−45 against 25) — and G20 is the FIRST
sign-up track card while its sibling is G5. Both pairs are kept as separate tokens.

### The sixteen back-lights

All 16 are `ELLIPSE`, fill `#AE87E7` at 100%, opacity 1, blend `PASS_THROUGH`, **no effects of their
own**, all in `Dark mode`. *Offset* is the ellipse origin minus the covering surface's origin.

| # | Track | Ellipse | Offset in surface | Size | Covering surface | Built by |
|---|---|---|---|---|---|---|
| B1 | School | `348:6951` | (23, 25) | 133×21 | level card `337:5336` | edit3 |
| B2 | School | `348:6952` | (3, 0) | 100×14 | Daily Tasks `337:5357` | edit3 |
| B3 | School | `348:6954` | (3, 7.57) | 100×14 | Top Student `337:5460` | edit3 |
| B4 | School | `348:7592` | (4, 6.81) | 100×14 | pool card `337:6275` | **blocked** |
| B5 | School | `348:7706` | (5, 11.02) | 100×14 | AI outer `337:9270` | edit4 |
| B6 | School | `348:8971` | (5, 11.83) | 100×14 | rewards `337:6680` | edit4 |
| B7 | School | `348:8973` | (4, 11) | 100×14 | profile header `337:7455` | edit5 |
| B8 | School | `348:8975` | (0, 33) | 100×14 | Notification Prefs `337:8195` | edit5 |
| B9 | Uni | `349:16784` | (23, 23) | 133×21 | level card `349:16593` | edit3 |
| B10 | Uni | `349:16786` | (13, 0) | 133×21 | Daily Tasks `349:16615` | edit3 |
| B11 | Uni | `349:16788` | — | 133×21 | **none** — no glass surface covers it | not built |
| B12 | Uni | `349:15376` | (4, 6.81) | 100×14 | pool card `349:15412` | **blocked** |
| B13 | Uni | `349:14914` | (5, 11.02) | 100×14 | AI outer `349:15005` | edit4 |
| B14 | Uni | `349:14523` | (5, 11.83) | 100×14 | rewards `349:14575` | edit4 |
| B15 | Uni | `349:12114` | (0, 27) | 100×14 | Notification Prefs `349:12171` | edit5 |
| B16 | Uni | `349:12920` | (4, 11) | 100×14 | profile header `349:12941` | edit5 |

**They are a property of the covering surface, not of the page.** On canvas at 100% zoom the glow is
a soft lavender haze inside the card near its top-start corner, with **no hard ellipse edge visible
anywhere** — i.e. what is on screen is the hard ellipse seen *through* the surface's frost. So they
are built inside the surface: below its tint, blurred with its own frost σ, clipped to its shape,
and scrolling with it. No light or RTL frame has one.

**B11 is a real gap, recorded rather than guessed:** an ellipse with nothing over it would render as
a hard lavender blob if it were built literally. It is not built — see edit3 #44.

### What this build actually renders — the tier-1 model

Figma Glass is tint + frost + rim light + refraction + dispersion. Over a **uniform** backdrop —
the flat page, or an opaque parent row, which is every glass surface in this app except the
onboarding sheet — frost, refraction and dispersion have nothing to distort. So tier 1 draws the
tint, a normal-based rim light, and the back-light frosted with the surface's own σ, and reserves a
real `BackdropFilter` for the one surface with content behind it. The rejected alternatives are in
D-009.

`refraction`, `dispersion` and `depth` are **stored in the tokens but not rendered**. That is a
stated limitation, not an oversight: a tier-2 Impeller `ImageFilter.shader` would need a
`flutter: shaders:` entry, a Skia fallback and the owner's approval, and it would only show a
difference on the onboarding sheet.

### Conversions (`lib/core/theme/glass_mapping.dart`)

| From | To | Why |
|---|---|---|
| drop/inner-shadow **Blur** `B` | σ = B/2 | Figma's Blur *is* the CSS blur radius, and CSS defines that as σ = B/2. **A definition — never tune it.** `BoxShadow(blurRadius: B)` would give σ = 0.57735·B + 0.5, up to 2× too soft on this file's 1.3px shadows |
| layer-blur panel value `P` | σ = P/2 | Figma's own CSS export halves it (panel 8 → `blur(4px)`) |
| CSS-exported `backdrop-filter: blur(X)` | σ = X | the export already halved it — which is why the scrim σ values are used as-is |
| Glass `frost` `R` | σ = R × `kGlassFrostToSigma` (0.50) | the same field name and convention as background blur. **A model constant** |

### ⬆️ Calibration — RUN 2026-09-18, and it found a MODEL fault (SUPERSEDED)

> **Read the 2026-09-19 re-calibration below before using any number in this
> section.** This pass sampled four points per node — the straight-edge
> midpoints — which at `lightAngle` −45 all sit at the same `|facing|`. Its
> sidedness finding held; its rulings on `kGlassRimMaxAlpha`,
> `kGlassRimStrokeWidth` and the exponents did not, and the ~0.73 "floor" it
> proposed is refuted. Kept because the shape of the error is instructive.

The side-by-side the 2026-09-17 entry could not run has now run. **Route:** the
Figma **desktop app**, signed in, view-only — computer-use access to it was
granted on 2026-09-18 after being declined on the 17th. Each reference is a
**3x PNG export of the containing frame** (Properties panel → Export → 3x → PNG),
so every reference pixel is Figma's own render at exactly device pixel ratio 3;
the Flutter side is `ElevatedSurface` at the node's Figma size and radius on the
dark canvas, captured through `RenderRepaintBoundary.toImage(pixelRatio: 3)`.
Both sides were then measured by the same script: **peak luminance of the rim at
each of the four edge midpoints**, page `#232428` = 36.

| Ref | Node | Ran? | Outcome |
| --- | --- | --- | --- |
| C1 | level card `337:5336` + B1 | ✅ | back-light σ **confirmed**; rim sidedness **wrong** |
| C2 | Notification Prefs `337:8195` + B8 | ❌ **not run** | it calibrates the same `kGlassFrostToSigma` that C1 confirmed, and the model fault below blocks the other four constants. Unchanged at its documented value. |
| C3 | profile menu row `337:7479` | ✅ | rim **2.5x too dim**; sidedness **wrong** |
| C4 | language pill `340:19734` | ✅ | intensity scaling **confirmed linear** |
| C5 | field `348:8659` | ✅ | **inconclusive** — frost 0, so what is measurable is the `depth` bevel and the node's own 0.03px hairline, neither of which tier 1 renders |
| C6 | quiz previous button `337:6464` | ✅ | **anomalous** — the node carries **Rotation −180°**, which no reading had recorded |
| C7 | onboarding sheet `337:15643` | ✅ | frost now visible and matching in character (built in **#75**) |

**Measured rim peaks** (luminance at the edge midpoint):

| Node | angle | Figma T | L | B | R | Flutter T | L | B | R |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| C1 level card | −45 | **128.6** | **124.2** | 99.6 | 99.2 | 99.3 | 99.3 | 94.3 | 98.0 |
| C3 menu row | −45 | **123.2** | **123.2** | 98.2 | 98.2 | 48.2 | 48.2 | 48.2 | 48.2 |
| C4 language pill | −45 | **61.2** | **66.2** | 55.2 | 52.2 | 39.2 | 39.2 | 39.2 | 40.2 |
| C5 field | 28 | 101.9 | 66.0 | 86.0 | 66.0 | 47.5 | 60.0 | 48.2 | 60.0 |
| C6 quiz prev | 51 | 81.5 | 113.2 | 97.6 | **148.2** | 72.2 | 53.5 | 72.2 | 53.5 |

#### The five constants

- **`kGlassFrostToSigma` = 0.50 — CONFIRMED. Unchanged.** C1's back-light is the
  direct test, and it is the cleanest result of the whole pass: sampled down the
  ellipse's vertical centre line, Figma and Flutter agree within **1–3/255 at
  every step** of the falloff — `(53,47,69)/(53,50,66)` at 8dp,
  `(64,56,80)/(61,54,75)` at 40dp, `(45,43,54)/(45,43,53)` at 80dp, both reaching
  the page by ~115dp. Frost 62 → σ 31 is right, so the halving convention is
  right.
- **`kGlassRimStrokeWidth` = 1.0 — CONFIRMED. Unchanged.** Figma's rim occupies
  ~3px at 3x with the same anti-aliased profile as ours (C3 top edge:
  123.2 → 93.6 → 44.2 → fill).
- **`kGlassRimMaxAlpha` = 0.5 — CONFIRMED on the lit side. Unchanged.** Solving
  Figma's lit-edge luminance back to an alpha gives **0.50–0.51 per unit
  `lightIntensity`** on both C3 (intensity 0.80 → α 0.411) and C4 (intensity 0.25
  → α 0.126–0.149). The ratio 0.31 against the intensity ratio 0.3125 also
  confirms the model's `× lightIntensity` term is linear and correct.
- **`kGlassRimExponentNarrow` = 6.0 — REFUTED, and deliberately NOT changed.**
  At splay 0 the model gives `0.5 × intensity × 0.707⁶` = 0.0625 × intensity, i.e.
  C3 renders 48 where Figma renders 98–123. But no value of this constant fixes
  C3, because of the fault below — changing it alone would trade one wrong
  picture for another.
- **`kGlassRimExponentWide` = 1.0 — not separable. Unchanged.** C1 (splay 1.00)
  and C5 (splay 0.97) are the only wide nodes; C1 is dominated by the same
  sidedness fault and C5 by `depth`/hairline.

#### ⬆️ SUPERSEDED 2026-09-19 — the fault was real, the proposed fix was not

Everything in this sub-section is the 2026-09-18 reading. It was right that the
model is broken and right about which side Figma lights. Its proposed fix — a
**floor of 0.73** under a one-sided rim — is **refuted** by the fuller
measurement in the next sub-section, which walked the whole outline instead of
its four midpoints. Kept verbatim because the way it was wrong is the point:
four samples that all sit at the same `|facing|` cannot constrain a falloff.

`paintGlassRim` (`lib/core/widgets/elevation/glass_surface.dart:129`) takes the
**absolute value** of the facing dot product:

```dart
final facing = (normal.dx * light.dx + normal.dy * light.dy).abs();
```

At ±45° every edge of a rectangle has `|facing| = 0.707`, so **the model paints
all four edges identically and has no lit side at all**. Figma does: at −45° it
lights **top and left** and leaves bottom and right ~25% dimmer, measured on
three nodes whose other Glass parameters could hardly differ more — C1
(frost 62, depth 78, splay 1.00, intensity 0.80), C3 (frost 4, depth 20,
splay 0, 0.80) and C4 (frost 4, depth 20, splay 0, **0.25**). All three agree.

Worse for the current code, the direction is **the opposite of what the comment
claims**. `light = (cos θ, −sin θ)` is `(0.707, +0.707)` at −45° — right and
down — which under a *signed* dot product would light exactly the two edges
Figma leaves dim. The 2026-09-17 note that "at −45° the rim highlight sits on
the top-left and bottom-right corners" was read off the canvas and is
half-right: the **top-left** is lit, the bottom-right is the dim side, and the
appearance of a diagonal comes from `.abs()`-style two-sidedness in Figma's own
shader, not from symmetry.

So the fix is **a model change, not a calibration**: drop `.abs()`, negate the
light vector, and give the unlit side a floor of about **0.73 of the lit side**
(C3: 0.299/0.411; C4: 0.086–0.099 / 0.126–0.149 — the same ratio at both
intensities). That touches every Glass surface in the app — −45° is the angle
on G5 (the Figma default, **363 nodes**), G6, G7, G9, G10, G14, G15, G16, G18
and G19 — so per `edit2_unblock.md` §2 it is **stopped and put to the owner
rather than applied**. The five constants stay at their documented values until
that is decided; re-run C1–C7 after it.

*(End of the 2026-09-18 reading. The floor is refuted below; the ratio is 0.65,
not 0.73, and there is no floor — between the two lobes the rim is absent.)*

**C6 does not fit either model and is set aside.** `337:6464` is
`tdesign:service-filled`, 79×58 r10, `#27282C` @20%, and it carries
**Rotation −180°** — a property no previous reading recorded. Its rim is
brightest on the **right** (148.2) and dimmest on the **top** (81.5), which
matches neither θ = 51° nor θ = 51−180 = −129° under either sign convention. It
is the only rotated node in the set and the only one adjacent to a glowing CTA,
so it is recorded as an open anomaly rather than used as evidence. **The y-up
question C6 was supposed to settle was settled by C1/C3/C4 instead.**

**One more thing the export shows, recorded but not built:** every Glass surface
in Figma is *darker inside than the page*, with a gradient running bright at the
top-start corner to dark at the bottom-end one — C1 `(41,40,47)→(30,30,35)`
across the card against a page of `(35,36,40)`. That is `depth`/`refraction`
shading, which tier 1 states it does not render (D-009). It is why a Glass
surface reads as *recessed* in Figma and *flat* in the build, independently of
the rim.

### ✅ Re-calibration — RUN 2026-09-19, and the model is now built

The 2026-09-18 pass measured Figma's rim at **four points per node**: the
midpoints of the four straight edges. On an axis-aligned surface at
`lightAngle` −45 — the file's default, on 363 nodes — all four sit at exactly
`|facing|` 0.7071. **Four samples at one value cannot constrain a falloff**,
which is why that pass could rule on sidedness and nothing else, and why the
floor it proposed looked like the only shape that fitted.

This pass walked the **whole outline** of the same three nodes in the same 3x
frame exports — every straight edge and every corner arc, at ~1° resolution —
and was then re-measured end to end by a second, independent script that fitted
each node's geometry from the pixels rather than taking it on trust. The two
agree on every number below.

#### What the corner arcs show that the midpoints could not

| | |
| --- | --- |
| **The rim is two-sided, and not symmetric.** | Both the light-facing and the away-facing side carry one. The far side is **0.65** of the near side: matched-`\|facing\|` medians 0.650 (C3), 0.638 (C4), 0.657 (C1); 0.64 at the straight edges, 0.65 at the corner apexes; the same at `lightIntensity` 0.80 and 0.25. An anti-aliasing-invariant integral of the rim's excess luminance returns 0.62–0.64 independently. |
| **There is no floor — there is a gap.** | The two corner arcs whose normals are square to the light axis are **bare**: the pixel inside the boundary is the surface's own fill to within one level, across roughly half of each arc. On C3 and C4 those diagonals measure alpha **0.0000**. The rim is two arcs, not a closed loop. It dies at `\|facing\|` ≈ 0.40 and is gone below ≈ 0.36. |
| **The peak is ~0.79, not 0.5.** | Per unit `lightIntensity`, where a corner arc turns square to the light: 0.765 (C1), 0.790 (C3), 0.794 (C4). The old 0.5 was the **straight-edge** value used as if it were the peak. |
| **The straight edges are 0.50 lit / 0.33 dim.** | Per unit intensity: 0.507 (C3), 0.489–0.525 (C4), 0.501–0.525 (C1) lit; 0.327 dim on all three. Alpha is constant *along* each edge (C3 top p10 = p90 = 0.4057), so the rim is a function of the normal only — not a gradient across the shape. |
| **`splay` does nothing.** | With the threshold pinned, the two splay-0.00 nodes fit exponent 0.50 and the splay-1.00 node 0.51. Where the rim is visible their predictions differ by under 2%. The splay-driven `narrow`/`wide` lerp was an `edit1.md` §7.4 b *assumption*, never a measurement. |
| **`lightIntensity` is linear.** | C4 at 0.25 returns the same alpha/intensity as C3 and C1 at 0.80, to ~5%. |
| **The rim is white and inside the shape.** | Excess RGB is achromatic (92/91/92, 55/56/55, 27/27/27). The pixel immediately outside the boundary is exactly the page, everywhere — including on the lit side. |
| **The width is constant.** | ~1.9 px at 3x (0.63 dp) everywhere, front lobe and back lobe alike despite the 1.55x brightness difference. Only the brightness varies. |

#### The model, as built

```dart
travel = (cos t, -sin t)                 // Figma lightAngle, y-up: where light GOES
facing = -(outwardNormal · travel)       // +1 square to the source, -1 square to its back
reach  = clamp((|facing| - 0.48) / (1 - 0.48), 0, 1)
spread = reach * reach * (3 - 2 * reach) // smoothstep: the profile is S-shaped
alpha  = 0.79 * lightIntensity * (facing >= 0 ? 1 : 0.65) * pow(spread, 0.50)
```

| Constant | Was | Now | Basis |
| --- | --- | --- | --- |
| `kGlassFrostToSigma` | 0.50 | **0.50** | unchanged — confirmed 2026-09-18, C1's back-light matches within 1–3/255 |
| `kGlassRimStrokeWidth` | 1.0 | **1.33** | Figma's rim is 1.9 px wide at 3x = 0.63 dp; a centred stroke is half-clipped, so 1.33 puts 0.67 dp inside. The shipped 1.0 rendered 1 px at 3x |
| `kGlassRimMaxAlpha` | 0.5 | **0.79** | the measured apex, per unit intensity |
| `kGlassRimThreshold` | — | **0.48** | new: where the rim stops |
| `kGlassRimBackLobe` | — | **0.65** | new: the far lobe |
| `kGlassRimExponent` | 6.0 / 1.0 | **0.50** | replaces the splay-lerped pair, which splay does not drive |

What that renders, against what Figma renders, per unit `lightIntensity`:

| | model | Figma |
| --- | --- | --- |
| straight edge, lit | 0.503 | 0.489–0.525 |
| straight edge, dim | 0.327 | 0.327 |
| corner apex, lit | 0.790 | 0.765–0.794 |
| corner apex, dim | 0.513 | 0.499–0.574 |
| corners square to the light | 0 | 0 |

**Known residual.** Between `|facing|` 0.36 and 0.48 Figma still paints a faint
tail (≤ 0.11 per unit intensity) that the threshold cuts. It is a fraction of
two corner arcs, it errs toward *less* paint, and closing it would cost accuracy
at the straight edges, which are ~90% of every outline. Recorded, not fixed.

**It is now a test, not a comment.** `test/core/widgets/elevation/glass_rim_calibration_test.dart`
renders the rim at device pixel ratio 3 and asserts the sidedness, the 0.65
ratio, the straight-edge alphas and the bare corners against these numbers. The
`.abs()` fault passed the whole suite for two days; a golden would have frozen
it just as happily.

#### ✅ RULED 2026-09-19 — the rim ships at 70% of the measured brightness

The question this pass escalated — Figma's rim is measured inside a surface that
`depth`/`refraction` darken, and tier 1 renders a flat one, so is the measured
alpha right *here*? — was answered by the owner the same day: **keep every
calibrated term and scale the strength down, deliberately, behind one constant.**
See `docs/DECISIONS.md` **D-011**.

`kGlassRimMaxAlpha` ships **0.55** against the measured **0.79**. The fraction
holds the two most prominent Glass surfaces (level card `splay` 1.00, form field
0.97) at the brightness the app already shipped — 0.354 per unit intensity at a
straight edge before, 0.350 now — while the small chrome comes up from 0.06 to
0.35 against Figma's 0.50.

**This is intentional visual compensation, not a measurement error and not a
deviation to be "fixed".** The geometry is untouched: direction, the two lobes,
the 0.65 ratio, the threshold, the width and the falloff all stay pinned to
Figma, and the calibration test checks the straight-edge *profile* against
Figma's numbers scaled by the dial, so the shape cannot be bent to dim the rim
instead. `kGlassRimMeasuredMaxAlpha` carries the 0.79 so the measurement is not
lost.

What each renders, per unit `lightIntensity`:

| | Figma | shipped (×0.70) |
| --- | --- | --- |
| straight edge, lit | 0.50 | 0.35 |
| straight edge, dim | 0.33 | 0.23 |
| corner apex, lit | 0.79 | 0.55 |
| corners square to the light | 0 | 0 |

**Not re-run after the change:** C2, C5, C6, C7. C2 calibrates the frost, which
did not move. C5 and C6 are confounded (see above) and neither is a rim
reference. C7 is the frost through a real backdrop and is unaffected by the rim.

### edit4 outcomes, 2026-09-20

**G10 was NOT layered, and the reason is structural rather than "we looked and could not see
it".** `edit4.md` §7.9 says a leaderboard row carries two Glass effects — G5 on the rectangle
`337:5630` and G10 (splay 0.31, else G5) on the `Group` wrapping it, `337:5629` — and to add a
rim-only second layer if the difference is visible. It is not layered, because
**`kGlassRimBackLobe` and the rim geometry are independent of `splay`** — that is what the
2026-09-19 calibration measured and what `glass_rim_calibration_test.dart` asserts. G10 and G5
differ only in `splay`, and `splay` moves nothing the tier-1 model renders, so a second layer
would paint the identical rim twice and read as one rim at roughly double alpha. That is a
brightness change nobody asked for, not a missing effect. **Recorded rather than built; revisit
if `depth`/`refraction` is ever implemented, since splay may drive those.**

**The light selected scope hex was re-read and it MOVED.** `edit4.md` §5 flagged `#D8B0FF`
(read 2026-09-08) against `#DBB0FF` (2026-09-16 CSS export) and asked for `158:840` to settle
it. Properties panel, 2026-09-20: **`#DBB0FF`**, together with `Fill (181px) × Fixed (44px)`,
`Radius 51`, `Padding 10`, `Gap 10`. `AppColors.scopeSelectedFill` light is corrected.
**`podiumAccent` was deliberately left at `#D8B0FF`**: the caller's own board row `134:3554`
was not re-read, and moving a token on the strength of a sibling's reading is exactly the
class of thing this register exists to stop.
**Resolved 2026-09-25 (API→UI Wave 06 walk, W06-3):** `134:3554` and the dark `337:5638` both read
**`#DBB0FF`**, so `podiumAccent` now carries `#DBB0FF` on both canvases. See `docs/KNOWN_BUGS.md` BUG-008.

**Three values `edit4.md` §13 listed as UNREAD are read.** None needed its documented fallback,
and one fallback would have been wrong:

| Value | Read | Node(s) | Note |
| --- | --- | --- | --- |
| previous-button chevron | `#FCFBF9` both canvases | `159:1922`, `337:6466` | §7.3's dark fallback proposed `textPrimary` — same number today, different token, different reason to move |
| light selected scope fill | `#DBB0FF` | `158:840` | see above |
| dark A/B/C/D badge ring | `#AE87E7` @50%, 1.18 stroke | `337:6447` | **differs from what ships** — see #83 |

Two more that `edit4.md` did not list as unread because its §5 table had no node for them: the
scope toggle's **idle** label (`158:843` `#384F47`, `337:5619` `#FCFBF9`) and its **selected**
label (`158:841` / `337:5617`, both `#FCFBF9`). §7.8 asked for `textSecondary` on the idle one,
which is the grey; it is a dark green, exactly as #77 found on the sibling control.

### Two edit4 readings that could not be reconciled, recorded rather than resolved

1. **`edit4.md` §5 #48 lists THREE dark review-row fills** — `#BFFFC3` / `#FDE9E8` /
   `#DCFFE9` — for what the 2026-09-20 walk of `337:6731` and its twin found to be **two**
   row states. `#DCFFE9` is a third mint, four units of green from the correct row's, and
   nothing on the frame was found drawing it. It may belong to a state the build does not
   render, or be a stale value in the guide. **Not adopted, not explained.**
2. **`edit4.md` §5 #20 says the dark frame's 9th leaderboard row is opaque `#232428` with no
   Glass**, against every other row's 20% + G5, and asks for it to be recorded as a probable
   designer slip. Recorded here. The build draws every ordinary row identically; no special
   case was added, which is what §5 asked for.

### Recorded, not built (#55)

Glass exists on screens this app has not built: Customer Support (`337:8390`, G5 ×46 + G17),
Notifications (G5 ×46), Messages / chat (G5, G11 search), Friends (G5 chips `Frame 427319502`
47.5×19 `#384F47` @20%, G11 search), Create Ticket, Your progress, Refer a Friend (all G5), and the
University Learning Tools tiles (inner shadows — edit3 #43). Listed so the reading is not lost;
none of them is built by this pass.

### edit5 outcomes, part 1 — Profile and Edit Profile, 2026-09-20

`edit5.md` §13 listed four **verify-first** items and three **unread colours**. Two of each fall in
this chunk. All four were read on the Properties panel of the owner's own signed-in Figma session
(the route §1.6 of `CLAUDE.md` describes), not from a CSS export and not from a canvas render.

**The icon disc is on EVERY menu row, and the build was drawing eight of them wrong.**

`edit5.md` §5 #24 flagged this as a contradiction: a CSS export showed a `#F4E6FF` 35×35 disc on
every row, while `ProfileMenuRow`'s own doc said the eight navigation rows carried a bare glyph and
cited an older frame (`170:4933`). **The export was right.**

| Row | Node | Read |
| --- | --- | --- |
| Settings (neutral) | `170:4861` | 35×35, radius 48.17, `#F4E6FF` |
| Privacy & policy (neutral) | `170:4902` | 35×35, radius 48.17, `#F4E6FF` |
| Logout (destructive) | `176:1186` | 35×35, radius 48.17, `#F4E6FF` |

**Why three readings disagreed with the layer list for two months.** The disc is not a sibling
`Ellipse` — it is the *Iconify component frame's own fill*. `Button` → `lets-icons:setting-fill` →
`Vector` is the whole subtree, so walking the layers looks exactly like "glyph, no disc"; and
`#F4E6FF` on `#FCFBF9` is invisible at the 50% zoom the frame is usually viewed at. Built on all
ten rows, and the enum's doc now says where the old reading came from.

**Two more row values, read in passing.** The emphasis row's stroke (`170:4921`) is `#101010` and
the destructive row's (`176:1185`) is `#EF4444`, both 0.5 all-sides on `#FCFBF9`. The first is a
NEW token — `profileMenuEmphasisRowBorder` — because the row had been borrowing `textPrimary`,
which is `#0E0E0E`. Two units of every channel: invisible, and still a different value from a
different source, which is exactly the class of drift this register exists to stop.

**The light edit-chip glyph is read, so no fallback was needed.** `edit5.md` §7.2.3 allowed keeping
`homeAccent` if the value could not be read. It could: `170:4674` is a 20×20 vector at (10, 10)
inside the 40 chip, filled **`#333333`**. With the dark `#FCFBF9` (`337:7466`, read 2026-09-17)
that is the new `profileEditChipGlyph`. The shipped lavender was on neither canvas.

**Two geometry readings taken and NOT adopted, both recorded rather than applied.**

| What | Frame | Build | Why not moved |
| --- | --- | --- | --- |
| menu row padding | 14 / 16 (`170:4790`) | 14.5 / 16.5 | half a dp; `edit5.md` §7.4.1 explicitly keeps the build's, and this edit changes elevation, not geometry |
| menu glyph size | 21–23, per export (`170:4674` 23×23, `170:4910` 21×26) | 22 | each Iconify export has its own box inside the shared 35 frame. The glyphs are Material stand-ins (ASSET_MANIFEST), so adopting one export's number for all ten would be precision the asset cannot cash |

**The header back-light renders, measured rather than eyeballed.** `test/goldens/profile_header_dark.png`
decoded pixel-wise: the page reads `(35, 36, 40)` with a blue-minus-green of **+4**, and the band the
B7 ellipse occupies peaks at `(52, 48, 63)` — **+15** — across x≈26–98, fading back to +9 by the
card's lower edge. The right-hand side of the same card (300, 60) stays at +4. That is a lavender
haze confined to the avatar side, which is what `edit5.md` §12 asks for, and it is the only place
the G15 frost and the B7 ellipse are proven to composite — the value test can only prove they were
handed over.

**The tap target and the frame's size are different numbers, and both are kept.** The edit chip is
drawn at the frame's 40 and given a 48 gesture box around it (`edit5.md` §7.2.2). Growing the disc
would change a read value to satisfy a platform minimum; shrinking the target would fail the
minimum. `IconButton` had been doing this for free and the replacement has to do it on purpose.

**Still owed on these screens.** Nothing designer-gated was found in this chunk. The Iconify glyph
set itself (`fluent:edit-16-filled`, `lets-icons:setting-fill`, `solar:logout-2-bold-duotone` and
the rest) is still a `TODO(design-asset)` in `docs/ASSET_MANIFEST.md`, unchanged by this pass — the
colours and boxes are read, the shapes are Material stand-ins.

### edit5 outcomes, part 2 — Settings, 2026-09-20

`edit5.md` §7.6.2 asked for the language segments' ORDER and their label colours to be read before
the control was rebuilt. Both were, on the Properties panel, on both canvases.

**The segment order was wrong in the build, and it is the only behavioural change in this chunk.**

| | Frame | Build (before) |
| --- | --- | --- |
| first segment | **English** — `176:2373` (light), `337:8179` (dark) | Arabic |
| second segment | Arabic — `176:2375`, `337:8181` | English |

Corrected to the frame's order. Nothing else about the behaviour moved: both `Key`s are carried
through `SegmentedTrack.keyOf`, both names are still endonyms in both locales, and the control
still calls `select()` rather than `toggle()` so tapping the current language does nothing.

**All four label colours confirm tokens edit3 already added** — no new token was needed and no
fallback was used:

| | Light | Dark |
| --- | --- | --- |
| idle | `#384F47` (`176:2375`) | `#FCFBF9` (`337:8181`) |
| selected | `#FCFBF9` (`176:2373`) | `#FCFBF9` (`337:8179`) |

The light track itself re-read at `#ECECEC`, `Fixed 362 × 44`, radius 32 (`176:2371`) — also
matching. The selected pair is the **2.74:1** the owner accepted under #77; it is unchanged here
and is not re-opened by this chunk.

#### 🟠 NEW, and it is a question rather than a finding: one component, three label sizes

Reading the labels turned up something `edit5.md` did not ask about and that no previous pass has
recorded. `Frame 1000003007` is ONE Figma component with two consumers, and it does not carry one
label size:

| Where | Node | Frame says | Build draws |
| --- | --- | --- | --- |
| Lectures quiz-type tabs | `180:5339` | Inter **Medium 500 / 14** | `AppType.labelMedium` — 12 / 500 |
| Settings › Languages | `176:2373`, `176:2375`, `337:8179`, `337:8181` | Inter **Medium 500 / 18** | `AppType.labelMedium` — 12 / 500 |

**Nothing was changed on the strength of it.** 18/w500 does not exist in the type scale at all
(`h3` is 18/**w600**, one weight heavier at the same size), and `docs/AGENT_WORKFLOW.md` puts
"typography scales" at the top of the never-invent list. 14/w500 *does* exist — it is
`bodyMediumStrong` — so the Lectures tabs could be corrected today; the Settings track could not,
and correcting one consumer of a shared style while the other stays put is how a shared style
stops being shared.

**For the designer, two questions, no answer proposed here:**

1. Is the size meant to differ per screen, or is one of the two frames stale?
2. If it is meant to be 18 at Medium weight, that is a new scale entry and it has to come from
   the scale's owner, not from this build.

Until then both consumers keep `labelMedium`, which is what they already shipped.

#### The rest of the Settings chunk

**The section card's light hairline moved for a reading, not a preference.** It had been borrowing
the Profile hub's `#7070A0` (`profileRowBorder`); `176:1840` draws **`#AE87E7`** at 0.5, and
`642:8583` / `337:8195` draw **no stroke at all** in dark, taking **G16** (frost 63, else G5) over
a 20% wash instead. Both halves of the dark reading are honoured: the colour token AND the width
token go to null/0 together, and the card checks both, because a 0-wide `BorderSide` is still a
decision the frame did not make.

**The divider inside a section is deliberately UNCHANGED.** No frame reading was taken for it on
either canvas. Moving it to the card's new lavender because the outline moved would be inferring a
value from a sibling, which is the same mistake `podiumAccent` was protected from in edit4.
Recorded here rather than left silent.

**The Notification Preferences back-light waits for `/me`.** Which ellipse to draw depends on the
student's track (school B8 `348:8975` at (0, 33); university B15 `349:12114` at (0, 27) — six
pixels apart, both kept verbatim). The track is a server fact, so the card renders without a
back-light until the profile arrives rather than guessing one and putting the haze at the wrong
height for half the students. Rank never gets one on either canvas, and neither does anything on
the light canvas.

**Measured, not eyeballed:** `test/goldens/settings_section_dark.png` decoded pixel-wise gives the
page at `(35, 36, 40)` — blue-minus-green **+4** — and the card's leading side at `(51, 48, 62)`,
**+14**, while the same card at x=300 stays at +4. A lavender haze at the top-start edge, which is
what §12's checklist asks for.

**One golden `edit5.md` §11.3 offers was deliberately NOT taken:** the dark Settings language
track. It would photograph the same `SegmentedTrack` with the same `pillTrack*` tokens that
`quiz_type_tabs_dark.png` already pins — different text over identical elevation. Its own claims
(order, keys, RTL, tokens, semantics, text scale 1.3) are asserted by value instead.

### edit5 outcomes, part 3 — OTP, 2026-09-20

The screen's three surfaces, its two CTAs and the guard's last ratchet step. **The full reading and
every value is in #49**, which is this screen's own entry; what follows is only what belongs to the
elevation wave's own ledger.

**The verify-first item (#31, "read the card's children and padding before building") paid for
itself.** `308:5114` turned out to be a component WRAPPER with no fill and no effects of its own —
the card is its `Type= correct` variant — and that variant's child list is the digit row **and the
Verify button**. edit5.md §7.8 assumed the card wrapped the Pinput; had it been built that way the
button would have sat outside a card the frame puts it inside, and nothing in the value assertions
would have caught it. Padding 15/10/15/10 and gap 20 came from the same read.

**Three raw-elevation values were corrected as well as re-mechanised**, which is the pattern every
chunk of this wave has repeated: the timer pill's height was 6dp short (36 → 42), its inset 1dp
short (14 → 15), and its shadow was an OUTER black borrowed from the five #47 card frames where
both canvases draw an **inner** bevel — and the two canvases share neither its colour, its offset
nor its blur.

**The ratchet is spent.** `raw elevation effects` went 11 → 9 → 7 → 4 → 1 → **0** across edits 2–5
and is now a zero-enforcement test that names offending `file:line`, which is what edit1.md §7.6
asked for at zero. `tool/verify_guards.ps1`'s probe was renamed with it and still fails the test on
a planted `BoxShadow`. `AppColors.elevationShadow` lost its last call site in the same change and
was deleted — field, both values, `copyWith`, `lerp`, and its `palette_discipline_test.dart` group.

**Measured, not eyeballed:** `test/goldens/otp_dark.png` decoded pixel-wise shows the lavender glow
**knocked out** exactly as edit1.md R4 requires. Outside the card's left edge the row at y=227 runs
(41,40,48) → (43,42,52) → (47,44,56) → (51,47,61) — blue-minus-green climbing +8 → +14 with red
climbing with it, which is lavender and not a black shadow — and then snaps to (35,36,40), the
card's own fill, at the first pixel inside the shape. The right edge peaks higher, at +16, because
the shadow's offset is (0.2, 0.2): down and to the right. The focused cell's stroke measures
(174,135,231) exactly — `#AE87E7` at full strength — and the other five hairlines measure neutral
grey, which is the `#D1D1D1` both canvases read.

**The cells' G19 rim needed a second measurement, because the golden alone cannot separate it from
the hairline.** The rim is a bright band ON the shape's edge and the 0.5 `#D1D1D1` stroke paints
over the same pixels, so in the image the two are one. A throwaway probe (written, run and deleted
2026-09-20) rendered the same 48 × 56 cell over the same `#232428` backdrop twice, once with the
token and once with `glass: null`, and diffed the raw RGBA: **692 of 32400 bytes differ, peak delta
71, at the cell's TOP-LEFT corner** — which is where G19's −45° angle and 0.50 splay put its lobe.
With the hairline on top the peak falls to **45**, so the stroke dims the rim but does not hide it.
G19 is painting, and it is painting where the frame's angle says it should. For contrast,
`settings_section_dark.png` — whose dark card carries **no** hairline — shows its rim cleanly in
the image itself, at (78,78,83) against a (35,36,40) page.

**Device-gated:** no device was connected. Nothing here is DEVICE VERIFIED.

### edit5 outcomes, part 4 — the sign-up track cards, 2026-09-20

The cards' own readings and the illustration-shadow finding live in **#40**, which is that screen's
entry. What belongs here is the wave-level outcome.

**The wave gained one primitive, and only one.** `lib/core/widgets/elevation/layer_blur.dart`:
`LayerBlur(sigma, opacity, child)` over `ImageFiltered(ImageFilter.blur)`. Figma's **layer** blur
is not its **background** blur — `GlassStyle.frost` is the latter — and the two are named apart
in that file because reaching for the wrong one produces a plausible picture of the wrong effect.
It uses `TileMode.decal`, not the default `clamp`, so the blurred art fades to transparent instead
of smearing its edge colour across the card. It lives in the elevation folder because that folder
and `lib/core/theme/` are the only two the `ImageFilter.blur` ban exempts.

**One token was added**, `AppColors.trackCardArtShadow` — `#000000` at 25%, the same on both
canvases because the frames draw the identical layer on both. It is a colour, so it is a token; a
`Color.fromRGBO(0, 0, 0, 0.25)` at the call site would have failed the palette guard, and rightly.

**One token was deleted.** `profileIconChip` had been unreferenced since edit5's Profile chunk
moved the menu rows onto `profileMenuIconDiscFill`; it is gone — field, both values, `copyWith`,
`lerp` — with a tombstone recording that its premise (only two rows have a disc) was refuted by
three Properties-panel reads. That is the second dead token this wave removed, after
`elevationShadow`.

**A golden HARNESS defect was fixed, and it had been hiding a whole page fill.**
`track_screen_{light,dark}.png` were captured from a private `_TrackCard` finder, and
`matchesGoldenFile` snapshots the nearest enclosing repaint boundary — `Scrollable`'s, which sits
INSIDE the `Scaffold`. So the page fill was outside the capture and both baselines were
transparent-backed. Harmless while the dark card was an opaque `#232428`; fatal the moment it
became `#232428` at 20%, because the baseline would have shown a card that all but vanished while
the device shows no change at all. The finder is now the `Scaffold`, which is the same rule
`golden_harness.dart` already follows for every widget-level golden. Both baselines therefore
change for TWO reasons at once, and this paragraph is the record of which is which.

**Measured, not eyeballed** (regions chosen to exclude the harness change, i.e. pixels opaque in
both baselines):

| | School art | University art | School's text half |
|---|---|---|---|
| light | 2270/8369 px changed, max **24**, toward neutral grey | 112 px, max 5 (resampling noise) | **0** px |
| dark | 1139 px **darker, 0 lighter**, max −3 | 109 px, max 5 | **0** px |

The University column is the point: it is the control. The card that the frame gives no shadow to
did not change, and the card that carries one changed only where the art is.

**Device-gated:** still no device. Nothing in this wave is DEVICE VERIFIED.

### edit5 outcomes, part 5 — the §12 visual QA pass, 2026-09-20

Parts 1–4 recorded what was built. This is the pass `edit5.md` §12 asks for, walked end to end.

**Every line was measured, not looked at.** Fifteen surfaces were rendered through a throwaway
probe (deleted), captured from their own repaint boundary and decoded pixel by pixel, on top of the
seven baselines the wave already owns. What follows is only what the numbers say.

| §12 line | Canvas | Measured |
|---|---|---|
| #21 header | light | shadow reaches 5 rows above, **6 below**, deepest −37 — offset (0.5, 0.5), blur 4 |
| | dark | rim **+47** top / **+31** bottom; fill flat at the page value; shadow −5 OUTSIDE only |
| #22 chip | light | 40×40 disc, shadow −9 above / −10 below — one row each, the tight blur-1.3 |
| | dark | rim +35 top / +29 bottom, 20% wash, shadow outside |
| #23 stat | light | edge reaches **2–3 rows** (blur 2), deepest −46 |
| | dark | interior exactly **(39, 40, 44) = #27282C**, opaque, **no rim** |
| #24 rows | light | `#7070A0`, `#101010`, `#EF4444` — all three recovered to the byte from a 37%-coverage hairline |
| | dark | rims only (b−g = 4, i.e. neutral) on two tones; Logout keeps r≫g |
| #25 badge | light | 34×34, shadow **one row, −7** — the 1.105 blur |
| | dark | **87** over the avatar and **78** over the page: 20% cream over each backdrop, exactly |
| #28 section | light | hairline **(223, 208, 242) = `#AE87E7`** at 37% coverage — lavender, not grey |
| | dark | no hairline at all; haze peaks at x≈40–50, y≈88 — the top-start corner |
| #50 track | light | selected **`#AE87E7`**, flat, no bevel; idle is **byte-identical to the bare track** |
| | dark | track recessed (bottom −8), selected recessed (top −41); idle identical to the track |
| #30 pill | light | **no outer shadow on any edge**; inset −37 bottom, −16 top, −24/−24 sides |
| | dark | pale inset **+20 top, +19 end**, +3 on the other two |
| #31/#52 | light | card knockout clean; resting cell border **(209,209,209) = `#D1D1D1`** |
| | | focused cell **(56, 79, 71) = `#384F47`** at coverage **1.50** |
| #12 CTA | light | fill `#384F47`, b−g −2 throughout — a neutral shadow, no glow |
| | dark | halo b−g rises **+4 → +46** over ~10 px — the lavender glow, unmistakable |

**Three things this pass established that no value assertion could.**

**The back-light really does mirror.** `edit5.md` §13 lists RTL mirroring as an *assumption*
(edit1.md R9) and the existing test can only show that the card hands the painter an unresolved
offset. Rendered: in LTR the haze spans x 39–116 and in RTL x 294–371 of the same 24–387 card —
mirrored to within a pixel, with the excess summing to 1009 and 1011. It is now measured, not
assumed.

**R10's 0.45 is exact, in three independent places.** The disabled Verify reads (164, 174, 169),
which is 0.45×`#384F47` over cream to the byte; the disabled dark CTA reads (98, 81, 126), which
is 0.45×`#AE87E7` over `#232428` to the byte.

**The `SegmentedTrack` idle segment is transparent in the rendered pixels**, not merely in the API.
On both canvases the idle half and the bare track are the same colour — (236, 236, 236) light,
(35, 36, 41) dark. That rule has been enforced by review since edit3; this is the first pixel proof.

#### ⚠️ One wording correction, and it is `edit5.md`'s, not the build's

§12 describes the OTP timer as "42 tall stadium with **an inner top bevel**". Its own §5 table
reads the effect as **inset (0, −1) blur 4 black 25%**, and an inner shadow with a negative y puts
its dark band along the **bottom** inside edge, the way CSS's does. The render agrees with the
table: −37 at the bottom against −16 at the top. The table is the Figma reading, the table is what
was built, and the checklist line is loose prose.

Two test NAMES in `test/features/auth/otp_elevation_test.dart` had inherited the same slip and were
corrected in this pass — light is "along the BOTTOM edge", dark is "in the TOP-END corner"
(−0.5 lands on the end edge, +0.5 on the top one). Neither assertion changed; both named the wrong
edge while checking the right number, which is the kind of comment that survives precisely because
nothing tests it.

#### Coverage closed in this pass

* **OTP forced-LTR under Arabic.** §11.2 asks for "6 cells, LTR even in AR"; the suite asserted the
  `Directionality` wrapper under `en`, which proves the widget exists and not that the boxes fill
  left-to-right on an RTL page. Now pumped in `ar`, asserting the page is RTL, the cells are not,
  and the six cells' laid-out x positions strictly increase.
* **Text scale 1.3 on the two surfaces that lacked it.** §12 names three — the language track, the
  menu rows and the OTP row — and only the track had a test. The hub and the OTP screen are now
  pumped at **402 wide** (the frame's own width; the harnesses' 800 is wide enough that nothing
  could overflow) at 1.3 in both locales. No overflow in any of the four. The #81 caveat stands:
  the test font is ~1.5× wider than Inter, so this is stricter than the device, and a pass here is
  still not a device pass.

**Device-gated:** at the time of writing, nothing in edit5 was DEVICE VERIFIED. That changed the
same day — see part 6.

### edit5 outcomes, part 6 — the §11.5 device walk, 2026-09-20

**`docs/DEVICE_VERIFICATION_2026-09-20-edit5.md` is the full record**, in the dated form the 09-12,
09-19 and 09-20-edit4 passes use. A second file for the same date because 09-20 already belongs to
the edit4 walk. Two things are repeated here rather than only linked.

**No local-only changes were needed.** The edit4 walk needed three unblocks and a paragraph
defending each, including switching `FLAG_SECURE` off. This one needed **none** — every edit5
surface is reachable in the stock `main_mock.dart` build and none of them sets `FLAG_SECURE`. The
only device-level change was the font scale, set to 1.3 for the text-scale checks and back to 1.0
after.

**Thirteen items across light, dark, RTL and 1.3, all measured off the screencap pixels.** The
three that only hardware could settle:

* **The back-light mirrors.** §13 listed it as an assumption. English against Arabic, row for row,
  the lavender excess matches within 1% (6540/6562, 8021/8045, 5985/6008) while the peak crosses
  from x≈170 to x≈870.
* **The two track cards rim differently, and it is visible.** Card 1 rims on its vertical edges only
  (128 left, 95 right, flat top and bottom); card 2 rims on all four (97, 75, 97, 75). That is the
  entire consequence of G20 vs G5 differing by light angle alone, and it is why `AppElevation`
  keeps both.
* **The illustration's shadow is neutral, School-only, and physical.** 5535 grey px in Arabic
  against 5588 in English — the same in both directions, so the offset does not mirror — and on the
  dark canvas 6882 px **darker and none lighter**. The University card has none in any of the three.

**R10's 0.45 turned up twice more, on mechanisms nothing had checked:** a disabled menu row's light
hairline is **0.448** of a live row's, and its dark Glass rim is **0.452** of a live rim's.

**What the device could NOT do.** §11.5 asks for a wrong OTP code. The mock has no `otp_invalid`
branch — `000000`/`111111` authenticate and *every* other 6-digit code forks to registration
(`lib/dev/mock_backend.dart:137`). Producing the error state would have meant editing the mock,
i.e. changing code to work around a harness limitation, so it was not done; the state stays covered
by `otp_elevation_test.dart`. Also uncovered: the avatar badge in RTL, iOS, and scales above 1.3.

**One defect found, and it is not ours to fix** — the selected track card at 2.19:1, recorded in
**#40** above with its cause and its `HEAD` provenance.

---

## 73. ✅ RESOLVED — the dark language pill is drawn ONE way, not two

**Where:** `Button / Light` — light `82:1093`; dark `340:19734`, `349:16814`, `337:19540` (Log in),
`337:19535` and `337:19530` (OTP), `337:19522` (Sign Up_1), `337:19693` (Sign Up_2).
Code: `lib/core/widgets/language_pill.dart`.

**What:** the 2026-09-16 sweep recorded the dark pill as drawn two different ways — solid on the OTP
screens, translucent elsewhere — and left it as an open question. The 2026-09-17 plugin read of all
seven dark instances shows them **identical**: `#232428` at **20% alpha**, **no stroke at all**, and
Glass **G3** (frost 4 · refraction 0.80 · depth 20 · angle −45 · intensity 0.25 · dispersion 0.50 ·
splay 0). The "solid on OTP" reading was wrong.

Light is unchanged and is the only canvas with a stroke: `#FCFBF9` under **0.629032** `#4B675E`.

**Built 2026-09-18 (edit2 #33).** `LanguagePill` is an `ElevatedSurface` on a `StadiumBorder`
reading `languagePillFill`, `languagePillBorderWidth` and `languagePillGlass`. Two real changes
came out of it: the pill used to paint `ext.background`, so on the dark canvas it was the page
colour on the page and **completely invisible**; and the light hairline was Flutter's default 1.0
rather than the frame's 0.629032. Golden-verified in both canvases
(`test/goldens/language_pill_{light,dark}.png`) — the dark pill now reads as a faint 20% stadium
with a two-sided rim highlight instead of nothing at all.

---

## 74. 🔴 BLOCKED — the Limitation sheet has no dark frame, so the dark scrim is unmeasured

**Where:** Limitation notification, `Rectangle 6427`. Code:
`lib/features/quiz/widgets/limit_sheet.dart`.

**What:** the light frame specifies the scrim exactly — `rgba(49,49,49,0.5)` over a page blurred at
`backdrop-filter: blur(5.75px)` (already a sigma in the CSS export). **No dark Limitation frame
exists anywhere in the file**, so there is nothing to measure for the dark canvas.

**Built 2026-09-18 (edit2 #18).** `AppElevation.light.limitSheetScrim` carries the measured light
values; `AppElevation.dark.limitSheetScrim` is **`null`**, and `showAppModalSheet` falls through to
the framework's default barrier on that canvas — the sheet is unchanged in dark. Null here means
"not measured", **not** "no scrim": nobody is to invent one by carrying the light values across or
by copying another sheet's. `test/core/widgets/elevation/app_modal_test.dart` pins that null so the
day a dark frame arrives, the test is what notices.

**Searched and still absent, 2026-09-18** (signed-in desktop app, view seat).
The search `edit2_unblock.md` §2 J3 asked for was run four ways:

1. **Find in file, all pages, "Limitation"** — 16 hits: `design` 10, `prototype`
   5, `Assets / component` 1. The ten on `design` are five `Limitation
   notification` frames plus the `limitation` instance inside each. **All five
   frames read fill `#FCFBF9`** — the light page background; a dark-canvas frame
   is `#232428`.
2. **The component set.** `limitation` on `Assets / component` has exactly four
   variants — `Subscribe now`, `Subscription Expired`, `Explanations Locked`,
   `daily limit` — and all four are light. That page names its dark twins
   explicitly (`Component 19_ dark`, `Component 18_ dark`, beside
   `Component 4_light`, `Component 1_light`), so a dark limitation component
   would have been called one. There is none.
3. **The whole `Dark mode` section, enumerated by hand** — all three
   sub-sections (`Common Sign in/ up Pages`, `University Student Flow`,
   `School Student Flow`, ~90 frames). No `Limitation notification` in any of
   them.
4. **`Rectangle 6427`** — 62 hits, because it is a generic auto-name reused
   across Messages, Edit Profile, Go to Uni and Logout. The one inside
   `Limitation notification` re-reads as **`#313131` at 50%** over a
   **Background blur panel value of 11.5** (→ σ 5.75, matching the CSS export
   this entry already records). The light values are confirmed; there is no dark
   twin to measure.

So this is not an unread value, it is an absent frame. **`limitSheetScrim` stays
`null` in dark and `app_modal_test.dart` keeps pinning it.**

**Fix we need (designer):** a dark Limitation notification frame, or a ruling
that the dark sheet takes another dark scrim already in the file (the avatar
sheets are 30% at σ 13.4/14.7; the dialogs are 60% at σ ~10).

**Update 2026-09-26 (API→UI Wave 11):** the sheet became a centred card (#51). Still no dark frame, so on the
dark canvas: the scrim stays `null` (framework barrier), the card takes the dark page fill `#232428` like the
Profile dialog, the title keeps the light `#EF4444` (`limitSheetTitle`, one value in both palettes, as
`quizOptionBorder`), and the ✕ takes `#FCFBF9` (`limitSheetClose`), the dark `textPrimary` the Profile dialog's
✕ already uses. The frame's `#3F3F3F` would all but vanish on `#232428`. That is a choice between two existing
values; a dark frame would replace all four.

Related: the sheet's benefits card and "Upgrade To Premium" CTA are deliberately **not built** — the
app is purchase-silent (adr-049 §3, D-007, issue #51).

---

## 75. ✅ RESOLVED 2026-09-18 — `337:19256` is the page background, and the light frame has no equivalent

**Where:** `on boarding screen_1` — light `81:92` / `459:43873`, dark `337:15146`
/ `337:15643`. Code: `lib/features/onboarding/screens/onboarding_screen.dart`,
`lib/core/theme/app_colors.dart`.

**What.** The sheet is a 20%-alpha fill under Glass **G1** (frost 80) with the
illustration (`image 79 [Vectorized]`) behind it. Figma keeps the illustration
from showing through the whole sheet with an oversized opaque rect, and the one
value this entry was blocked on was that rect's fill.

**Read 2026-09-18** from the Properties panel of the **signed-in Figma desktop
app** (computer-use access granted; the same request was declined on 2026-09-17,
which is what blocked it). Node `337:19256` is the layer **`Rectangle 6429`**:

| | |
| --- | --- |
| Size / position | **622 × 138** at Left **−140**, Top **540** — exactly the geometry the code comment had assumed |
| Fill | **`#232428` at 100%** (no alpha shown; contrast a 20% node, which the panel prints as `#27282C 20%`) |
| Z-order | `Frame 1000003081` (the sheet) → **`Rectangle 6429`** → `image 79 [Vectorized]` → `Status_Bars` — above the illustration, below the sheet |

`#232428` is **`AppColors.dark.background`** (`app_colors.dart:1001`), so this is
edit2.md §7.8.1's first row: the fill *is* the page background.

**The light frame has no equivalent node, and that is the real finding.** `81:92`
has exactly three children — `Frame 1000003082` (the sheet, `459:43873`),
`image 79 [Vectorized]` and `Status_Bars`. There is no rect. And the light
illustration is **419×682 at (−19, −39)**, so it ends at y 643 against the same
sheet top of y 529: **light frosts 114pt of artwork through the sheet where dark
frosts 11.** The two canvases genuinely differ, so the strip is built **dark-only**
— painting one in light would be inventing a node Figma does not draw (R2).

**Also corrected here:** the screen's own doc comment claimed "only the SHEET
exists in light… `459:43873` is a detached 402×360 frame". Both halves are
wrong. `459:43873` is 402×**413** at y 529 *inside* a full 402×878 light frame
that carries the illustration and the status bar like its dark twin.

**Built 2026-09-18.** New nullable palette token
**`AppColors.onboardingIllustrationMask`** — `null` light, `Color(0xFF232428)`
dark, cited to `337:19256` — following the `languagePillBorder` precedent for a
one-canvas token, mirrored. `_Sheet` drops the full-height opaque `DecoratedBox`
for a `Stack` whose first child is a `Positioned(top: 11, height: 138, left: 0,
right: 0)` `ColoredBox`, and the sheet takes **`GlassBackdrop.content`** — the
app's one real `BackdropFilter`. The strip is a positioned *sibling* rather than
a wrapper so that `top` measures from the sheet's own content-sized top edge,
and so that the backdrop frosts the strip's top edge exactly as Figma's Glass
frosts the rect's.

**Verified (C7 in #72).** Figma's 3x frame export against the real
`OnboardingScreen` rendered at 402×878 / dpr 3, aligned on the sheet's top edge:
both now show the illustration frosted into the sheet's top band, decaying to
the sheet tint over ~20–25dp. The residual difference — Flutter's band starts
brighter and decays faster — traces to *what is behind the edge*, not to the
frost: Figma's illustration is 419 wide at x −19 while the build uses
`BoxFit.fitWidth` at the frame width, so at the sheet's top edge Figma has the
dark book bottoms where the build has the pale green ellipse. That fit deviation
is pre-existing and documented in the widget.

**Light was checked the same way** and matters more, because light is where the
behaviour changed most: it used to sit on a full-height opaque backing and now
has none at all. Against a 3x export of `81:92`, the build reproduces the
design's soft green wash at the sheet's top, brightening into the cream over
the same distance — Figma `(224,226,216)→(236,239,230)` across the first 32dp,
the build `(202,208,193)→(212,218,203)`. The build's band is ~20/255 greener
throughout, from the same illustration-fit difference plus the refraction and
depth terms tier 1 does not render (D-009, and see #72's closing note).

**Not closed by this:** the sheet's top corner notch. Figma's rect is 622 wide
and clipped by the frame; the build's strip is clipped to the screen width. Both
leave the same page-coloured gap outside the r25 corners, and because the strip
*is* the page colour it is invisible in both. Recorded so nobody "fixes" it.
---

## 76. 🟡 Eight buttons in the app have no Figma frame, so they carry no CTA treatment — deliberately

**Where:** listed below. Code: `lib/core/widgets/elevation/primary_cta.dart` is the treatment they
do *not* get.

**What.** Figma draws two button shapes and nothing else: the full-width primary CTA
`Frame 427319502` (r20, 60 tall, drop shadow + a lavender glow layer in dark) and the outline CTA
`Frame 427319504`. Every button in the build that corresponds to one of those is wrapped in
`PrimaryCta` by edit2 (#12, #13) or by edits 4/5 for the screens they own.

**Eight buttons correspond to neither, because the design has no frame for the state they belong
to.** They are error, expiry and fallback affordances — states the Figma file does not draw at all
(the same gap `docs/screen-states` work keeps hitting). `edit2.md` §7.3 step 2 rules that they stay
unwrapped and asks for the list to be recorded. This is that record.

| Button | File | State it belongs to |
| --- | --- | --- |
| "Retry" | `lib/core/widgets/state_widget.dart` | the shared error state |
| "Retry" | `lib/features/catalog/widgets/catalog_states.dart` | catalog error — note the 403 branch deliberately suppresses Retry (FINDING-16) |
| "Retry" | `lib/features/home/screens/home_screen.dart` | Home error |
| "Retry" | `lib/features/profile/screens/profile_screen.dart` | Profile error |
| "Retry" | `lib/features/leaderboard/screens/leaderboard_screen.dart` | Leaderboard error |
| "Retry" | `lib/features/catalog/widgets/school_picker_field.dart` | picker error |
| the restart affordance | `lib/features/registration/screens/registration_expired_view.dart` | expired registration draft |
| the fallback action | `lib/core/router/app_router.dart` | unknown-route fallback |

**Why it is a decision and not an omission.** Wrapping them would give an undrawn state the visual
weight of the drawn primary CTA — including, in dark, the lavender glow that Figma reserves for the
one full-width purple button per screen. An error state competing with the screen's real CTA is a
worse outcome than an unstyled error state, and inventing a treatment for a frame that does not
exist is exactly what R2 forbids.

**Keep it true.** `grep -rn 'PrimaryCta(' lib/` should return only the CTAs listed in `edit2.md`
§7.3 step 1 plus those edits 4 and 5 own. If one of the eight above ever appears in that output,
either Figma has grown a frame for that state — in which case update this entry — or someone wrapped
it by reflex.

**Fix we need (designer):** frames for the error, offline, empty and expired states. Until they
exist these eight stay as they are.

Related: #21/#22 (the outline CTA's dark fill/border), `docs/DECISIONS.md` D-009.


---

## 77. 🟠 The segmented track's selected label fails AA — at the design's own value

**Where:** `Frame 1000003007` — the quiz-type tabs (light `180:5337`, dark `337:11059` /
`349:15962`) and, from edit5, Settings → Languages.
Code: `lib/features/catalog/widgets/quiz_type_tabs.dart`.

**What:** edit3 §7.6 step 2 asks for the selected and idle label fills off the Properties panel, so
they can become `pillTrackLabel` / `pillTrackSelectedLabel` tokens that both screens share.

> ✅ **READ 2026-09-19** — Properties panel, signed-in Chrome session on the owner's own Figma
> account. (The MCP connector still cannot do this: it is unauthenticated in the agent session and
> authenticates as a view-only seat regardless. The browser route is what worked, as it did for
> #72.) Nothing below is approximated from a screenshot.

| Token | Light | Dark |
| --- | --- | --- |
| `pillTrackLabel` (idle) | **`#384F47`** `180:5339` | **`#FCFBF9`** `337:11091` |
| `pillTrackSelectedLabel` | **`#FCFBF9`** `180:5341` | **`#FCFBF9`** `337:11095` |

Both are Inter 500 / 14 px, line height 100%, letter spacing 0, centre/middle.

⚠️ **Correction 2026-09-20.** An earlier version of this line said that "matches
`AppType.labelMedium` and confirms the style choice the build already made". **It does not.**
`AppType.labelMedium` is **12 px at a 16/12 line height**, w500 — the WEIGHT matches Figma and
nothing else does: the frame is 2 px larger and its line height is 100% where the token's is 133%.
The build uses `labelMedium` because the typography ratchet is 0 and a new size would have to come
from the designer's own scale, which is the same reasoning `#57` records for the review screen — it
is a **deliberate nearest-token mapping, not a match**. Do not cite this entry as evidence that a
type token agrees with a Figma reading.

**The idle light value is the finding.** It is `#384F47`, a dark GREEN. The hand-rolled chips drew
the grey `textSecondary` `#2C2C2C` there, and the §7.6.2 fallback would have shipped that grey
permanently. Both tokens are now built from the readings.

**Measured contrast** at the read values (WCAG 2.1, on the track's own fill):

| Pair | Light | Dark |
| --- | --- | --- |
| idle on `pillTrackFill` | **7.48:1** ✔ | **14.98:1** ✔ |
| selected `#FCFBF9` on `#AE87E7` | **2.74:1** ✘ | **2.74:1** ✘ |

**The selected label fails AA at 4.5:1 and also fails the 3:1 large-text floor**, on both canvases —
and it does so at Figma's own numbers, so this is the design's arithmetic rather than a build
choice. It is not a regression: `#FCFBF9` on `#AE87E7` is what the chips always drew and what every
filled CTA in the app draws. What is new is that it is measured, and that the segmented track makes
it permanent on a control that always has exactly one selected item.

**Fix we need — designer:** a darker selected label, or a darker selected fill. `#2B2B2B` on
`#AE87E7` would reach 6.0:1 and is a colour this design already uses on a lilac ground (the
Continue Learning card, #79) — offered as a precedent, not chosen here. If near-white on `#AE87E7`
is intended, say so and this is recorded as accepted.

> 🟠 **OWNER 2026-09-19 — routed to the designer, no colour chosen in the build.** The owner
> declined to pick a replacement here and asked that the designer confirm first, on the grounds that
> `#FCFBF9` on `#AE87E7` is their value and it reaches far past these tabs — the same pair is on
> every filled CTA in the app, so changing it here would either fork the palette or ripple app-wide.
> **The tabs therefore ship at Figma's measured 2.74:1**, which is a live AA failure on a control
> that always has exactly one selected item, recorded rather than quietly corrected. **This is
> question 2 of 2 for the designer**, alongside #81's question 1.

### 🔴 A SECOND, WORSE pair — found 2026-09-20 on the leaderboard scope toggle

The ruling above is explicitly scoped: *"`#FCFBF9` on `#AE87E7` is their value and it reaches
far past these tabs — the same pair is on every filled CTA"*. **The scope toggle is not that
pair.** `Frame 1000003008` is a different component with a different selected fill, and edit4
moved the control onto `SegmentedTrack` on 2026-09-20, which is what surfaced it.

| Pair | Node | Ratio |
| --- | --- | --- |
| `#FCFBF9` on `#DBB0FF` (light selected) | `158:841` on `158:840` | **1.74:1** |
| `#FCFBF9` on `#C4A8E3` (dark selected) | `337:5617` on `337:5616` | **2.02:1** |
| `#384F47` on `#ECECEC` (light idle) | `158:843` on `158:839` | 7.48:1 ✔ |
| `#FCFBF9` on `#232429` (dark idle) | `337:5619` on `337:5615` | 14.61:1 ✔ |

1.74:1 is the worst text contrast measured anywhere in this register — worse than the 2.74:1
the owner accepted above, and on a control that, like the tabs, always has exactly one
selected item. Because the fill is NOT `#AE87E7`, the reasoning that made 2.74:1 shippable
(changing it would fork the palette or ripple to every CTA) does **not** transfer: these two
fills are used by this control and by the podium, and nothing else.

**Shipped as measured, no colour chosen in the build**, following the same discipline as the
ruling above. `lib/features/leaderboard/widgets/scope_toggle.dart` carries the numbers in a
comment so the next reader does not rediscover them.

**Fix we need:** a darker selected label or a darker selected fill for `Frame 1000003008`
specifically. Two values this design already uses on a lilac ground, measured on both fills:

| Candidate label | on `#DBB0FF` (light) | on `#C4A8E3` (dark) |
| --- | --- | --- |
| `continueLearningContent` `#2B2B2B` (#79's precedent) | **7.87:1** | **6.78:1** |
| the page fill `#232428` (`quizReviewFilterLabel`'s precedent) | **8.61:1** | **7.43:1** |
| `Brand.greenPrimary` `#384F47` | 4.91:1 | 4.23:1 |

Offered as precedents, **not chosen here**. Going the other way instead — keeping the cream
label and darkening the fill — needs roughly `#8A5CD6` to reach 4.43:1, which is a hex nobody
has supplied and is well away from both frames. **This is question 3 for the designer.**

**Also for the designer — a contradiction inside our own spec, not inside Figma.** edit3.md §5
records the dark TRACK's inner shadow as `inset (0, −3) blur 4 black 25%`, and §12's QA checklist
describes the result as "a top inner shadow". A negative-Y inner shadow casts along the **bottom**
inside edge, in Figma and in CSS alike, and that is what the build now draws (verified pixel-wise:
`test/goldens/quiz_type_tabs_dark.png`, darkest pixels on the track's bottom row). The measured
value was followed and the prose was not. Confirm which one matches the canvas.

---

## 78. 🟡 University Home's Ellipse 123 lights nothing — probably a leftover

**Where:** `349:16788`, 133 × 21 at (33, 993) on university Home.

**What:** it is a back-light ellipse — the same `#AE87E7` solid the eight other back-lights use —
but the plugin overlap test finds **no glass surface above it**. A back-light is only ever visible
as that ellipse seen through a covering surface's frost (edit1.md R6); with nothing over it, Figma
renders nothing and a build that drew it would put a hard lavender blob on the page.

Its school-track counterpart is B3 `348:6954`, which sits under the Top Student block and *is*
covered. The university Top Student block has no back-light of its own.

**Built as:** nothing. `AppElevation.topStudentBacklightSchool` is school-only by name, and
`ComingSoonSection` resolves the university track to an empty list. Asserted in
`test/features/home/coming_soon_section_test.dart` so it cannot be "fixed" by symmetry later.

**Fix we need — designer:** is Ellipse 123 a leftover from a deleted surface, or is the university
Top Student block missing the glass cover its school twin has? Either answer is a one-line change;
guessing between them is not.

---

## 79. ✅ RESOLVED 2026-09-19 — "Coming soon" was invisible on Continue Learning at 1.00:1

**Where:** Home's Continue Learning placeholder, school and university.
Code: `lib/features/home/widgets/coming_soon_section.dart`.

**What:** the owner's 2026-09-17 decision gives each placeholder its section's Figma surface while
keeping the placeholder's own content — a `#B3B3B3` (`mutedText`) icon and caption. edit3 §7.2.4
requires that pairing to be measured. It is far worse than the 4.5:1 threshold:

| Surface | Light | Dark |
| --- | --- | --- |
| Daily Tasks | 2.03:1 | 7.40:1 ✔ |
| Top Student | 2.10:1 | 7.34:1 ✔ |
| **Continue Learning · school** | **1.74:1** | **1.00:1** |
| **Continue Learning · university** | **1.16:1** | **1.16:1** |
| plain box (`cardFill`) — the pre-existing baseline | 2.06:1 | 7.39:1 ✔ |

**1.00:1 is not "low contrast", it is invisible.** `#B3B3B3` has a relative luminance of
**0.45079** and the dark school fill `#C4A8E3` has **0.45287** — they agree to two decimal places,
which puts the ratio at **1.0042**, i.e. 1.00:1 to the two decimals this table reports. The caption
and its ground are the same brightness; only the hue differs, and hue alone is not contrast. The
lilac fills are what did it — `#F3E5FF`, `#C4A8E3` and `#DBB0FF` are all light colours, and
`mutedText` was chosen against the *page*, which is light in one canvas and dark in the other.

> ✅ **FIXED 2026-09-19, with the design's own value.** §7.2.4's remedy is to read the matching
> Figma card's text colours and add them as a token. That read succeeded over the browser route
> (see #77): the Continue Learning card captions itself **`#2B2B2B`** — title and caption alike,
> on **all four** frames, light school `308:4190`, dark school `337:5435` / `337:5436`, light
> university `309:5633`. One value, both canvases, both tracks.
>
> Shipped as `AppColors.continueLearningContent`, used by that surface's placeholder only; the
> other three surfaces keep `mutedText`.
>
> | Surface | was (`mutedText`) | now (`#2B2B2B`) |
> | --- | --- | --- |
> | Continue Learning · school light `#F3E5FF` | 1.74:1 | **11.77:1** ✔ |
> | Continue Learning · school dark `#C4A8E3` | **1.00:1** | **6.78:1** ✔ |
> | Continue Learning · university `#DBB0FF` | 1.16:1 | **7.87:1** ✔ |
>
> The card's type is Inter 700 / 16 (title) and Inter 400 / 12 at 130% (caption); the placeholder
> keeps its own `captionRegular`, because the "Coming soon" line is not the frame's title.
>
> ✅ **DEVICE VERIFIED 2026-09-19**, Pixel 8, all four configurations walked with the mock backend:
> school light `#F3E5FF`, school dark `#C4A8E3`, university light and dark `#DBB0FF`. The caption is
> legible on every one. The dark school card is the one that matters — at `mutedText` it measured
> 1.00:1, which on the device would have been a card with nothing written on it.

**Still open, and NOT this entry's fix.** The light canvas was already failing before this wave —
`mutedText` on the plain `cardFill` box measures **2.06:1**, and on Daily Tasks (2.03:1) and Top
Student (2.10:1) it is no better. Those three are unchanged by this edit and were failing
identically before it. They are a separate question:

**Fix we need — designer:** is `mutedText` `#B3B3B3` the intended colour for secondary text on a
near-white surface at all? At 2.0:1 it fails AA everywhere it is used in light, which is far wider
than these placeholders.

**Also measured, same wave, same class:** the Mistakes header pill's `#EF4444` label on its own
frame-specified fill is **3.64:1** light / **3.61:1** dark — passes the 3:1 large-text floor, fails
4.5:1. Both the label and the fill are Figma values, so this one is the design's own arithmetic, not
a build choice. Recorded for the same designer pass.


---

## 80. 🟠 RETURNED TO EDIT 2 — nothing in the catalog header can have a 48 dp tap target

> 📌 **OWNER RULING 2026-09-19.** Return this to the **Edit 2 / `CatalogHeader` owner**. Do not fix
> it in Edit 3, because the root cause is the shared 35 dp header height, not anything the Mistakes
> pill does. Recorded as `docs/DECISIONS.md` **D-013**. The finding below stands exactly as
> measured; what changed is who holds it.

**Where:** `CatalogHeader`, `lib/features/catalog/widgets/catalog_scaffold.dart:64` — a
`SizedBox(height: 35)` around a `Stack`. Its occupants today are the back chip and the Subjects
screen's "Mistakes" pill.

**What:** a render box refuses a pointer outside its own SIZE — `RenderBox.hitTest` returns false
before it ever reaches `hitTestChildren` — so a 48 dp child of a 35 dp box is tappable over 35 dp
of itself and the remainder goes to whatever is behind it. A child of this header therefore has a
maximum tap target of **35 dp**, whatever it asks for.

⚠️ **This is a LAYOUT bound, not a clipping one.** An earlier draft of this entry blamed the
`Stack`'s default `Clip.hardEdge` and offered `Clip.none` as a remedy. That is wrong twice over:
`clipBehavior` governs painting only, and switching it changes nothing here. Verified with a
throwaway probe — a `SizedBox(height: 35)` around a `Stack` holding a 48 dp `GestureDetector`
rejects a tap 20 dp off centre under **both** `Clip.hardEdge` and `Clip.none`, and a
`SizedBox(height: 48)` accepts it under both. Only the height matters.

This was found while rebuilding the Mistakes pill (edit3 #7), whose guide asks for the usual
">= 48 dp target under the drawn 35 dp pill". It turns out **the pill never had one**. The
`OutlinedButton` it replaced carried Material's default `tapTargetSize: padded`, which draws a
35 dp button inside a 48 dp hit box — and this header clipped that box away in exactly the same
manner, silently, for as long as the button has existed. Wrapping the new pill in an explicit
`SizedBox(height: 48)` was tried and behaves identically.

**Measured**, not inferred (`test/features/catalog/subjects_screen_test.dart`, "is the frame's
35 dp pill"): hit-testing the pill's centre +/- 15.5 dp lands on the pill's own ink box, and
+/- 24 dp — the edge of a nominal 48 dp target — does not. The test asserts exactly those three
distances; it does not identify what an out-of-range tap lands on instead, and this entry no
longer claims that it does.

**Not fixed here, and now formally not edit3's to fix.** `catalog_scaffold.dart` is shared chrome
that edit2 owns and edit3's file list does not include it; growing the header is a layout change to
every catalog screen, not a tweak to one pill. The pill therefore ships at exact parity with the
button it replaced — a 35 dp target — rather than carrying a 48 dp box that is silently clipped,
which would read as compliance in review and be false at runtime.

The owner confirmed that split on 2026-09-19 (D-013), so this is no longer a judgement edit3 made
about its own boundary; it is an assignment.

**Fix we need — whoever owns `CatalogHeader` next (edit2's surface):** give the header a 48 dp
minimum height — `SizedBox(height: 35)` at `catalog_scaffold.dart` becomes at least 48, with the
35 dp pill and the back chip centred inside it — and re-run the measurement above. That is the
ONLY remedy; see the warning above about `Clip.none`. Both the back chip and the pill benefit, and
neither can be fixed from its own file.

**The guideline this misses:** WCAG 2.5.5 / the Material and HIG minimums all put a touch target at
44-48 dp. 35 dp is below all three. This is a real accessibility defect on a live control, not a
cosmetic one, and it is not new — it is newly *measured*.


---

## 81. ✅ DECIDED AND BUILT 2026-09-19 — the segmented tabs used to shrink Arabic below legibility and discard the text-scale setting

> ✅ **OWNER RULING 2026-09-19, and it is built.** In the owner's words: **Arabic readability and
> text scaling are more important than strict Figma segmented-track geometry.** Do not accept
> `FittedBox(scaleDown)` shrinking Arabic labels to ~10 dp, and do not silently discard the text
> scale. Keep the segmented track as the default design and adapt the implementation. Do not invent
> a minimum font size, and do not change or abbreviate labels without recording it.
>
> Nothing was invented and no label was touched — see **What was built**. Full reasoning:
> `docs/DECISIONS.md` **D-012**.

**Where:** the Lectures quiz-type selector, `Frame 1000003007`.
Code: `lib/features/catalog/widgets/quiz_type_tabs.dart` →
`lib/core/widgets/elevation/segmented_track.dart`.

**What it was:** edit3 #9 replaced a horizontally-SCROLLING row of content-sized chips with Figma's
segmented track: one fixed-width groove, `Expanded` segments of equal width, and a
`FittedBox(BoxFit.scaleDown)` on each label. The scroll used to absorb a long label. Equal segments
cannot, so the label shrinks instead — and because the segment width is fixed, the shrink gives
back exactly what the user's text-scale setting added.

**Measured 2026-09-19, BEFORE the fix**, at a 375 dp phone width — painted glyph height against
the laid-out box (`test/features/catalog/lectures_screen_test.dart`):

| Case | Label | 1.0x painted / laid | 1.3x painted / laid |
| --- | --- | --- | --- |
| 3 types, en | all | 16.0 / 16.0 | 21.0 / 21.0 |
| 4 types, en | "Practice" | **14.0** / 16.0 | **14.1** / 21.0 |
| 4 types, en | "Midterm" | 15.9 / 16.0 | **16.1** / 21.0 |
| 3 types, ar | منتصف الترم | **13.5** / 16.0 | **13.7** / 21.0 |
| 4 types, ar | منتصف الترم | **10.2** / 16.0 | **10.2** / 21.0 |
| 4 types, ar | عادي | 16.0 / 16.0 | 21.0 / 21.0 |

Two distinct defects:

1. **Legibility.** 10.2 dp is below the floor this project has already named: `subject_card.dart`
   raised the frame's 8.56 dp caption to 10 because "8.5 dp is below any readable minimum on a real
   phone". Arabic is the worst case because its labels are longest, which makes this an
   Arabic-first defect on an Arabic-first product.
2. **Accessibility.** At 4 types in Arabic, raising the system text size from 1.0x to 1.3x moves
   منتصف الترم from 10.2 dp to 10.2 dp — **no change at all** — while عادي next to it grows 16 → 21.
   A student who enlarges their text gets a row with a 21 dp label beside a 10 dp one. The setting
   is silently discarded for the label that needed it most.

Four quiz types is a real payload: the tabs are built from the server's `tree.quizTypes`, and the
contract's enum has four values. The fixture ships three, which is why the first version of these
tests could not see this.

---

### What was built

**The track keeps the design's shape and gives up only its fixed WIDTH.** The `FittedBox` is gone
from `_Segment`; every label lays out at `labelStyle` times the student's text scale, always. The
segments are still equal, still 44 dp tall, still in one groove. When the labels genuinely do not
fit, the groove runs past the edge and **scrolls** — which is what the chip row this replaced
already did, on this same screen, so it is not a new behaviour in the product.

Mechanically it is four widgets around the existing track:
`LayoutBuilder` → `SingleChildScrollView(horizontal)` → `ConstrainedBox(minWidth: available)` →
`IntrinsicWidth`. A `Row` of flex-1 children reports `n x widest child` as its intrinsic width,
which is the same "Fill" rule the Figma frame uses, so nothing here measures a `TextPainter` by
hand; and `minWidth` puts the groove back to the full width whenever that is larger, so **the
common case lays out as it did before**.

`test/goldens/quiz_type_tabs_dark.png` moved by **exactly one pixel** — `(368, 40)`, from
`(34, 35, 39)` to `(33, 34, 39)`, i.e. one unit of blend on the groove's right edge. Diffed
channel by channel, not eyeballed: the groove's width now arrives through `IntrinsicWidth` instead
of straight off the parent's constraint, and that rounds one antialiased edge pixel. Nothing else
in the frame differs.

**No number was invented.** The one new value is `SegmentedTrackStyle.segmentPadding`, and it was
**read from Figma on 2026-09-19**, not chosen: both segment frames — idle `180:5338` and selected
`180:5340` — are auto-layout frames at `Fill (72.4px) x Fixed (44px)` with **`Padding 10`**. The
parent groove `180:5337` is `Fixed 362 x 44`, radius 32, with no padding of its own. Only the
horizontal component is modelled: the frame's height is fixed at 44 and its label is 17 tall, so
Figma's vertical 10 drives nothing there either, and modelling it here would only eat the headroom
a large text scale needs. The 44 dp height is unchanged; the label has room to roughly **3x**
inside it, measured.

**No label was changed.** Question 2 below stays open on purpose.

**Measured after**, same harness, same 375 dp phone, all four quiz types:

| Case | Label | 1.0x painted / laid | 1.3x painted / laid |
| --- | --- | --- | --- |
| 4 types, en | every label | 16.0 / 16.0 | 21.0 / 21.0 |
| 4 types, ar | منتصف الترم | **16.0** / 16.0 | **21.0** / 21.0 |
| 4 types, ar | عادي | 16.0 / 16.0 | 21.0 / 21.0 |

Both defects are gone: painted equals laid everywhere, and 1.0x → 1.3x now moves **every** label by
the same factor instead of moving the short ones and pinning the long one.

### ✅ DEVICE VERIFIED 2026-09-19 — and the device is kinder than the tests

Run on a physical **Pixel 8** (1080 x 2400 at density 420 = **411.4 dp** logical width), debug build
of `lib/main_mock.dart`, university account (`111111`), Arabic and English, both canvases.

**Widths measured off the device's own pixels**, not judged by eye: on the Arabic Lectures screen at
the default text scale, with all four quiz types, the groove spans x = **73..1006 px** — 933 px =
**355.4 dp**, entirely on screen — and the segment boundaries fall at ~296 / ~540 / ~783 px, four
equal segments of ~233 px (88.8 dp).

| Configuration | Result on a Pixel 8 |
| --- | --- |
| 4 types, ar, 1.0x | **Fits. No scrolling.** All four labels at full size, segments equal. |
| 4 types, ar, 1.3x | Does **not** fit. The fourth label clips at the edge and the track scrolls; a swipe reveals it. **Every label grew**, the longest included. |
| 4 types, en, 1.0x | Fits, light canvas, segments equal. |

**So the test-font estimate overstated the problem, exactly as the caveat above predicted.** The
test binding draws every glyph as a box of the font size — Figma reads "Normal" at **49 px** where
the test lays it out at **72**, ~1.5x wider — which is why the tests scroll at 375 dp where the
device does not. The tests prove the fallback *engages and behaves*; this is where it engages.

Two more things the device settled, which no test could:

- **The idle label really is a dark green on a phone.** `#384F47` reads as green against the
  `#ECECEC` groove in light — visibly not the grey `textSecondary` the §7.6.2 fallback would have
  shipped.
- **The selected label's 2.74:1 is visible as low contrast** in the hand, not just on paper. That is
  #77's problem, unchanged by this entry.

### The four follow-up questions, answered by the owner 2026-09-19

Two are closed. **One is escalated to the designer and is the only thing still owed on this entry.**

1. 🟠 **ESCALATED — is scrolling the right fallback, or should the track wrap to two lines?**
   The owner's call is that the designer decides, not the build. **The scrolling implementation
   holds unchanged in the meantime** — it is what ships today, and it was chosen because it needs
   no invented number and restores what this screen already did before edit3. Wrapping is the
   alternative, and its cost is explicit: Figma's 44 dp track height would have to become variable,
   trading one Figma value for another and inventing the two-line metrics. **This is question 1 of
   2 for whoever owns `Frame 1000003007`.**
2. ✅ **CLOSED — the Arabic labels stay exactly as they are.** منتصف الترم is 11 characters where
   "Midterm" is 7, and a shorter term would keep the track tiling even at 1.3x. The owner chose to
   keep it: on a Pixel 8 all four labels **fit at the default text scale**, so the length only bites
   at 1.3x, and the term is one students already recognise. No copy changed, and none will be
   without a string supplied by the copy owner.
3. Figma's own frame has almost no slack even in English: five tabs at 72.4 dp with 10 dp padding
   leaves **52.4 dp** for a label, and "Normal" is **49**. The design was drawn at its limit. Not a
   question — context for question 1.
4. ✅ **CLOSED — the overflow gets no affordance, deliberately.** Noticed on the device, invisible
   in every test: when the track does scroll, the dark groove `#232429` is within a shade of the
   dark page, so what a student sees is a half-drawn word at the screen edge and nothing that says
   "swipe me". In light the `#ECECEC` groove reads better. The owner's call is to leave it — it is
   only reachable at 1.3x text scale, and a fade, an arrow or a peeking next segment are each a
   visual element **the frame does not contain**, so building one would be inventing design. It
   stays recorded here rather than built, and it is worth revisiting if question 1 comes back as
   "keep scrolling".

**Pinned by tests** in `lectures_screen_test.dart` and
`test/core/widgets/elevation/segmented_track_test.dart`: painted == laid on every label, every
label growing by the same factor under text scale, and the groove never narrower than the space it
is given. A `FittedBox` coming back fails all three.

---

### 🟠 A SECOND consumer, and it fails in ENGLISH — measured 2026-09-20

edit4 moved the leaderboard scope toggle onto this same primitive, which made the ruling's fallback
reachable on a second screen. Measured there at the widths the tests use, with the two-scope school
board:

| Config | Groove | Scrolls? | Overflow |
| --- | --- | --- | --- |
| EN `System \| Governorate` @375 dp | 335 | **yes** | 101 |
| AR `نظامي \| المحافظة` @375 dp | 335 | no | — |
| EN @411.4 dp (Pixel 8 width) | 371.4 | **yes** | 64.6 |
| AR @411.4 dp | 371.4 | no | — |
| EN @375 dp at 1.3x text scale | 335 | yes | 219.8 |
| EN university `Global \| Cohort` @375 dp | 335 | no | — |

**This is the inverse of the finding above.** #81 is an Arabic-first legibility defect; here Arabic
fits comfortably and **English is the one that overflows**, because "Governorate" is simply a long
word and there are only two segments to spread across the groove. The university board, whose
labels are short, fits in both languages.

Two things this does NOT establish, and it matters because the numbers look alarming:

- **These are BUILD-level widths, not device widths.** The test binding's font is ~1.5x wider than
  Inter — the same caveat that made the quiz-type tabs scroll in tests and fit on a real Pixel 8.
  Scaled to Inter, "Governorate" is roughly 132 dp and two segments plus padding land near 304,
  which fits 371.4 comfortably and 335 marginally. **Nobody has put this control on a device.**
- **It is not a regression.** The hand-rolled toggle this replaced set `overflow: ellipsis`, so the
  same overflow used to truncate "Governorate" silently instead. Scrolling is the ruling's chosen
  behaviour and is strictly more recoverable than truncation.

Recorded rather than acted on, for the reason D-012 gives: shortening the label is a copy change
that needs the copy owner, and re-adding a `FittedBox` or an `ellipsis` is the defect D-012 removed.
`test/goldens/scope_toggle_dark.png` deliberately photographs the UNIVERSITY pair so the baseline
pins the control rather than the scrolling fallback.

**Fix we needed — ANSWERED 2026-09-20 by the device pass. It does not scroll.**

> **Classification of this sub-finding: device false positive.** The overflow was real in the
> test binding and is not real on a phone. Nothing is owed by the copy owner and no label
> changes.

On a Pixel 8 at **411 dp** with the system text size at **1.3** — Android's largest standard
setting — `System | Governorate` lays out as two **186 dp** segments in a groove spanning the
full width, and **nothing scrolls**. Arabic at the same scale measures the same 186 dp.

That is this entry's own caveat coming true: the 101 px was measured in a binding whose font
is roughly 1.5x wider than Inter, and the scaled estimate above — "roughly 132 dp… near 304,
which fits" — was the right one. D-012 had already seen this once on the quiz-type tabs.

`test/goldens/scope_toggle_dark.png` still photographs the UNIVERSITY pair deliberately, so
the baseline keeps pinning the control rather than a fallback that no real phone reaches.
Full record: `docs/DEVICE_VERIFICATION_2026-09-20.md`.

---

## 82. ✅ RESOLVED 2026-09-20 (owner ruling) — Setup, Result and Review move onto the shared header

> ✅ **OWNER RULING, 2026-09-20.** Option (b): all three screens move to the shared
> `TitledChrome` + `CircleBackButton`, treated as **one architectural decision, not three
> independent fixes**, with the shared header's contract and the existing navigation
> behaviour verified first. Both verifications are below. **Built the same day.**


**Where:** setup light `135:1622` / dark `337:6239`. Code:
`lib/features/quiz/screens/quiz_setup_screen.dart`.

**What:** Figma draws the title beside a 35 × 35 `tdesign:service-filled` back chip — light
`#FCFBF9` with a (0.02833, 0.02833) blur 1.3 black 25% shadow, dark 20% with **G5** — which is the
same chip `CircleBackButton` already implements for every other screen that has one. The setup
screen instead uses a Material `AppBar` with its default back arrow, so it has an `AppBar`'s height,
its own title alignment and no elevation treatment at all.

**Built as:** unchanged. This is a **structural** divergence, not an elevation one: fixing it means
replacing the `AppBar` with a custom header row, which changes the screen's layout, its scroll
behaviour and its `SafeArea` handling. edit4 §5 #49 explicitly records it rather than touching it.

**Fix we needed — ANSWERED 2026-09-20, see the banner.**

### What was verified before touching anything

The ruling asked for the shared header's contract and the existing navigation behaviour to be
checked first. Three things came out of that, and the third is the one that made this safe:

1. **`TitledChrome` is the contract** (`lib/core/widgets/titled_chrome.dart`): a `Column`, not
   an `AppBar`, so it goes in `Scaffold.body` under the screen's existing `SafeArea`. Title
   centred at `AppType.h2`, `CircleBackButton` pinned to the start edge, `onBack` defaulting
   to `maybePop`, and a `backKey` so a test can leave the screen the way a student does. Five
   screens already consume it the same way.
2. **The frames agree.** `135:1622`, `159:1964` and `162:2377` were opened on 2026-09-20: all
   three draw a back chip at the start edge beside a **centred** title. The quiz TAKING screen
   does not — its start-edge control is a `✕` that discards the attempt — so it is not part of
   this and keeps its `AppBar`.
3. **The title does not move.** `appBarTheme.centerTitle` is already `true` and
   `textTheme.titleLarge` is already `AppType.h2` (`app_typography.dart:257`), which is
   exactly what `TitledChrome` renders. So the migration changes the **affordance only** — a
   Material arrow becomes the 35 dp chip the frames draw, with its light shadow and its dark
   Glass. Had the title alignment or type actually differed, this would have been a visual
   decision and would have gone back to the owner rather than being built.

### What was built

| Screen | Back behaviour | Note |
| --- | --- | --- |
| Setup | default `maybePop` | unchanged from the `AppBar`'s implicit back |
| Result | `onBack: () => _leave(context)` | **not** `maybePop` — the finished quiz and its setup screen are both still on the stack; the existing `PopScope` is untouched |
| Review | default `maybePop` | was an explicit `pop`; identical today, and the default keeps behaving if a `PopScope` is ever added |

Two consequences worth naming:

- **Three tests moved from `Icons.arrow_back` to `CircleBackButton`.** The chip carries a
  `Semantics` label rather than a `Tooltip`, which is why the result screen's
  `expect(find.byType(Tooltip), findsNothing)` still holds.
- **The result screen's bottom CTA now needs scrolling to in the 800x600 test viewport.** The
  header and the new 33 dp star disc together moved "Review Questions" from y 559-619 to
  y 570-630, putting its centre exactly on the edge. The tests scroll first, the way
  `quiz_screen_test.dart` already does for the same reason. On a 375 x 812 phone the screen
  still fits without scrolling.

---

## 83. ✅ RESOLVED 2026-09-20 (owner ruling) — the dark A/B/C/D badge ring takes its own token

> ✅ **OWNER RULING, 2026-09-20.** Option (b): a dedicated `quizOptionBadgeRing`. **Keep
> `quizOptionBorder` unchanged, because it is shared by other surfaces.** Use the Figma-read
> lavender for dark and the existing appropriate light value. Built the same day.


**Where:** dark option tile `337:6445`, badge `337:6447`. Code:
`lib/features/quiz/widgets/question_option_tile.dart` (`_Badge`).

**What:** `edit4.md` §5 #47 recorded the dark ring's colour as **not read**, and §7.4 therefore
kept it on `quizOptionBorder`. It has now been read off the Properties panel:

| | Shipped | Figma `337:6447` |
| --- | --- | --- |
| ring colour | `quizOptionBorder` — `#4B675E`, a green | **`#AE87E7` at 50%**, lavender |
| ring width | 1.18 | 1.18 ✔ |

So in dark the ring is the **same value as the option tile's own hairline** (`337:6440`, which edit4
did move to `quizOptionTileBorder`) — the frame draws the tile outline and the letter ring in one
colour, and the build draws them in two.

**Built as:** unchanged, on purpose. `quizOptionBorder` is shared: the review screen's skipped row
takes it for both its outline and its badge, and it is the correct light value in every case. Moving
it in dark would restyle four surfaces to fix one, and §7.4 says the ring is unchanged. Changing
one shared token on the strength of one node's reading is the kind of expansion the wave was told
not to make.

**Fix we needed — ANSWERED 2026-09-20, see the banner.**

**Built as:** `AppColors.quizOptionBadgeRing`, consumed by `_Badge`'s **idle** branch only —
the three graded states draw their own semantic ring and never read it. Dark is `337:6447`'s
lavender at 50%, which makes it identical to `quizOptionTileBorder`, so the frame's "one
colour for the outline and the ring" is reproduced.

**The light value was NOT separately read.** It is `quizOptionBorder`'s light green carried
across, which is what the badge already drew, so the light canvas is byte-identical. Recorded
here rather than presented as a reading: if the light badge ever turns out to differ from the
tile hairline, this token is the one to move.

`quizOptionBorder` is untouched and still has four consumers, including the review screen's
skipped row, which reads it for both its outline and its own badge. Pinned by
`app_colors_test.dart` and `quiz_elevation_test.dart`, which assert both that the ring moved
and that the shared token did not.

---

## 84. ✅ RESOLVED 2026-09-20 (owner ruling) — an idle segment is transparent, always

> **Classification:** **resolved implementation item.** Built, pinned by tests, and confirmed
> on hardware for both consumers (`docs/DEVICE_VERIFICATION_2026-09-20.md`). Nothing is owed
> by the designer.

> ✅ **OWNER RULING, 2026-09-20:** *"idle segment = transparent always."*
>
> So the knob was **removed**, not defaulted. `SegmentedTrackStyle.idleSegmentColor` no
> longer exists; an unselected segment is always `selectedColor` at zero alpha. That is the
> answer to the second half of the question below — the style does not *reject* an opaque
> idle fill, it gives no way to express one — and it closes the first half at the same time,
> because edit3's consumer had nothing left to pass. `docs/ENFORCEMENT.md`'s rule: a
> mechanised rule holds where a prose one drifts.

**Where:** `lib/core/widgets/elevation/segmented_track.dart` (`_Segment.build`),
consumed by `lib/features/catalog/widgets/quiz_type_tabs.dart` and
`lib/features/leaderboard/widgets/scope_toggle.dart`.

**What:** a `_Segment` is the full height of the groove it sits in. If its idle fill is **opaque**,
it paints over the track's inner shadows and flattens the idle part of the control. On the LIGHT
canvas the two look identical — the track has no inner shadows there and both fills are the same
grey — which is exactly why an opaque idle fill looks correct when it is written.

**Measured, 2026-09-20.** Rendering the dark scope-toggle golden both ways differs in **2087
pixels**, every one of them inside the idle segment, concentrated in two bands: the top inside edge
(the lavender inner glow, up to 19/255 darker when covered) and the bottom (the black inner shadow).
At (34, 12) the opaque version paints the flat track `rgb(35,36,41)` where the transparent one
paints `rgb(46,44,55)`.

**Built as:** the field is gone from the style — constructor, `==`, `hashCode` and all — and
`_Segment` computes `style.selectedColor.withAlpha(0)` directly. The selected HUE at zero alpha
rather than a bare transparent, so the 150 ms tween runs one colour's alpha up instead of
cross-fading through a third colour; that is asserted mid-flight, not reasoned about.

Both consumers lost a line. `ScopeToggle` had already been corrected within this wave and was
passing `null`; `QuizTypeTabs` was passing `ext.pillTrackFill`, the opaque one.

### What it actually cost the Lectures screen — measured, 2026-09-20

`test/goldens/quiz_type_tabs_dark.png` was regenerated, alone, and it moved in **1699 pixels of
27336**, `x 32..369`, `y 12..55` — the full width of the groove, in exactly the two
inset-shadow bands, with the bottom one (`y 49..55`, ~190 px per row) carrying most of it.

**Max channel delta 9/255**, against the scope toggle's 19. So this was the same defect and a
milder one, because the pill track's inset shadows are the weaker pair — which is worth saying
plainly: it is subtle enough that it would probably never have been caught by looking, on this
screen. It was caught because the primitive was made incapable of it.

No other golden moved; the repo's 38 are still 38. Pinned twice — at the consumer by
`test/features/leaderboard/leaderboard_elevation_test.dart`, which now asserts on the PAINTED
colour rather than on a style field that no longer exists, and at the primitive by
`test/core/widgets/elevation/segmented_track_test.dart`, which covers all three call sites at
once including Settings > Language, which `edit5.md` §363 has not built yet.

**Fix we need:** nothing. Closed.

---

## 85. 🟡 The rewards row hard-overflowed at text scale 1.3, before and after this wave

**Where:** `lib/features/quiz/screens/quiz_result_screen.dart` (`_RewardsCard`'s star + points row).

**What:** the row is a star, an 8 dp gap and the points label, inside a card 331 dp wide. Measured at
375 x 812, the label had no `Flexible`, so once it outgrew the space the result was a hard
`RenderFlex` overflow rather than a wrap:

| Text scale | Before edit4 (22 dp glyph) | After the 33 dp disc | Shipped (`Flexible`) |
| --- | --- | --- | --- |
| 1.0 | 0 | 0 | 0 |
| 1.3 | **11 px** | **22 px** | 0 |
| 2.0 | — | 176 px | 0 |
| 3.0 | — | 396 px | 0 |

**1.3 is Android's largest standard font setting**, so this was reachable on a stock phone before
this wave touched the screen; the 33 dp star disc that `337:6685` specifies doubled it.

**Built as:** the label is `Flexible` and **not** ellipsised. Wrapping rather than truncating
because the one thing on that row that must survive is the number — an ellipsis could eat the digits
and leave "+2…" — and the card hugs its content, so a second line makes it taller rather than
clipping it. Pinned by a text-scale test in `quiz_result_screen_test.dart`.

**Fix we need:** nothing, unless the designer objects to the card growing a line at large text
scales. Recorded because it is a **pre-existing** defect this wave surfaced and fixed rather than
one it introduced, and because `docs/RESPONSIVE.md`'s queue is still 0/11 applied — there are very
likely more rows like this one.

---

## 86. 🟠 The leaderboard row that says "You" is 1.75:1 — found on a device, in both canvases

> **Classification:** **pre-existing finding** → **designer decision**. NOT an edit4
> regression, and NOT an implementation task. No colour is proposed here and none should be
> chosen until the designer rules. DEVICE VERIFIED
> (`docs/DEVICE_VERIFICATION_2026-09-20.md`).

**Where:** `lib/features/leaderboard/widgets/leaderboard_row.dart:44` — `podiumOnAccent` on
`podiumAccent`.

**Measured off a Pixel 8 screencap, 2026-09-20** (not computed from tokens — decoded from the pixels
the phone actually put on the glass):

| | fill | label | contrast |
| --- | --- | --- | --- |
| the caller's own row, light | `rgb(216,176,255)` = `#D8B0FF` | `#FCFBF9` | **1.75:1** |
| the caller's own row, dark | `rgb(216,176,255)` = `#D8B0FF` | `#FCFBF9` | **1.75:1** |
| an ordinary row, dark | `rgb(35,36,40)` (the 20% wash) | `#FCFBF9` | 14.99:1 |

`podiumAccent` is `#D8B0FF` and `podiumOnAccent` is `#FCFBF9` in **both** palettes, so the failure is
canvas-independent. The row beside it measures 14.99:1, which is why it reads as a drop rather than
as a style: the one row a student looks for first is the least legible thing on the board.

**Not this wave's.** edit4 gave `LeaderboardRow` its fill, its list shadow and its dark Glass; the
foreground pair predates it and was not touched. It is recorded here because the device pass is what
made it visible, and because it is the same **family** as #77 — `#FCFBF9` on a light lavender — at a
third set of values.

**Fix we need:** a designer ruling, and **no colour is proposed here.** Worth putting in front of
them together with #77: the review screen's own selected filter pill already solves this exact
problem the other way round, drawing a DARK label on the lavender and measuring **5.48:1** on the
same phone. That is an existing in-app precedent, not a suggestion.

---

## 87. 🔴 The dark quiz page's CORRECT option tile is 1.11:1 — effectively unreadable

> **Classification:** **pre-existing finding** → **designer decision**. NOT an edit4
> regression, and NOT an implementation task. This entry also carries **#53's device
> comparison**, which D-010 asked for; that comparison is evidence, not a ruling. No colour
> is proposed here. DEVICE VERIFIED (`docs/DEVICE_VERIFICATION_2026-09-20.md`).
>
> **Why the red marker**, since this file defines it as *"breaks a required flow"* and nothing
> here crashes: the flow the quiz page owes a student after they answer is *learning what the
> right answer was*, and at 1.11:1 the right answer cannot be read. The tile is drawn, the tap
> works, and the information does not arrive. If the designer reads that as cosmetic, the
> marker should drop to 🟠 — the number does not change either way.

**Where:** `lib/core/theme/app_colors.dart` — `quizCorrectFill` / `quizWrongFill`, drawn by
`lib/features/quiz/widgets/question_option_tile.dart`.

**What:** the two graded fills are not symmetrical, and never have been:

- `quizCorrectFill` is `0xFFBFFFC3` — **fully opaque**, the same light mint on both canvases;
- `quizWrongFill` is `0x4DFFC0C0` — **30% alpha**, so it composites against whatever is behind it.

In light that is invisible, because both fills stay pale and the label is near-black. In dark the
label flips to cream while the correct tile's fill does **not** flip, and the result is cream on
light mint.

**Measured off a Pixel 8 screencap, 2026-09-20:**

| tile | canvas | fill as rendered | label | contrast |
| --- | --- | --- | --- | --- |
| correct | dark | `rgb(191,255,195)` | `#FCFBF9` | **1.11:1** |
| wrong | dark | `rgb(101,83,86)` | `#FCFBF9` | 6.94:1 |
| idle | dark | `rgb(39,40,44)` | `#FCFBF9` | 14.24:1 |
| correct | light | `rgb(191,255,195)` | `rgb(14,14,14)` | 16.83:1 |
| wrong | light | `rgb(253,233,232)` | `rgb(14,14,14)` | 16.54:1 |

**1.11:1 is the worst number in this entire document.** It is on the one tile a student is most
likely to read — the one telling them what the right answer was — and it is reachable by finishing a
question in dark mode.

**Not this wave's, and deliberately not fixed.** edit4 touched the idle tile's hairline and the
A/B/C/D badge ring on this widget and nothing else; both graded fills and the foreground predate it.
Under the owner's 2026-09-20 instruction the build does not invent a colour and does not decide this.

### This is also #53's comparison, which D-010 asked for

D-010 deferred the question of whether the quiz page's graded tiles should follow the review rows
onto a 20% wash, and asked for the two to be seen **side by side** before anyone ruled. They now
have been, one tap apart, on the same phone, in the same session:

| | dark fill as rendered | label | contrast |
| --- | --- | --- | --- |
| **review** row, correct | `rgb(66,80,71)` — the 20% wash | `#FCFBF9` | **8.22:1** |
| **review** row, wrong | `rgb(79,67,70)` — the 20% wash | `#FCFBF9` | **9.13:1** |
| **quiz** tile, correct | `rgb(191,255,195)` — opaque | `#FCFBF9` | **1.11:1** |
| **quiz** tile, wrong | `rgb(101,83,86)` — 30% | `#FCFBF9` | 6.94:1 |

The measured review figure of 8.22:1 is the same number #54 computed from the tokens (8.24:1), which
is a useful check on that arithmetic: the phone and the spreadsheet agree to within rounding.

**Fix we need:** a ruling. The evidence points one way, but the decision is the owner's, and the
comparison is now on the record instead of being described.

---

## 88. ✅ RESOLVED 2026-09-27 — Question bodies render their markup as literal text

> ✅ **RESOLVED 2026-09-27 (API→UI Wave 14, owner ruling "both screens").** The contract answers the
> question this entry asked: `QuizQuestion.text` is "Plain text; only <u>…</u> markup allowed."
> (`openapi.yaml:2703`, and the format note at `:105`: no other HTML or Markdown is ever sent). The
> subset is stated, so there is nothing to ask Seif, and the mock's tags are valid content.
> `QuestionStemText` (`lib/features/quiz/widgets/question_stem_text.dart`) draws `<u>…</u>` as an
> underline on the quiz page and on review; the tags are never drawn and TalkBack never reads them;
> each stem takes its own text direction (KNOWN_BUGS BUG-014, DECISIONS D-017). The original finding
> is kept below.

> **Classification:** **contract clarification**. Not a design question, not a build defect
> until the contract says so, and explicitly NOT a renderer change made on an assumption.
> The next action is reading `contract/openapi.yaml` at the current pin, not editing
> `mcq_renderer.dart`.

**Where:** `lib/features/quiz/widgets/mcq_renderer.dart` — noticed on the device walk, 2026-09-20.

**What:** the mock's question bodies contain `<u>…</u>`, and the phone draws the angle brackets. The
renderer is a plain `Text`, so any markup in a question body appears verbatim.

**This may be nothing.** The tags come from `lib/dev/mock_backend.dart:1419`, which is a fixture, not
the server. Two things are unknown and neither was chased, because both are out of this wave:
whether `Question.body` is specified as plain text or as markup in `contract/openapi.yaml`, and
whether the real bank contains any.

**Fix we need:** someone to check the contract. If the body is plain text this entry closes and the
fixture should lose its tags; if it is markup, the renderer has a gap and it is a `seif_fight.md`
question about which subset is allowed.

## 89. 🟡 The language pill's tap target is the frame's 36.1 dp — below the 48 dp guideline

> **Classification:** pre-existing finding → **owner decision**, same class as #80 / `D-013`
> (a Figma-mandated control height under the 48 dp minimum). Found by API→UI Wave 01, 2026-09-24.
> Not fixed there: the pill is shared by Onboarding, Login, OTP and Sign-up, so widening its hit
> area is a cross-screen change the owner has not asked for.

**Where:** `lib/core/widgets/language_pill.dart:28` — `_height = 36.10`, the whole widget is the
tappable area.

**What:** Figma `82:1093` ("Button / Light") is **78.13 × 36.10** (read via `get_metadata`,
2026-09-24). The build matches the frame exactly, so the visible pill is right; only its hit area is
short of 48 dp.

**Fix we need:** the owner to say whether a transparent hit-area extension (visual unchanged) may be
added to shared controls like this pill and the 35 dp back chip (#80), or whether they stay at frame
size.

## 90. 🟡 Registration field blocks: what the frames draw vs the shared field widgets

> **Classification:** pre-existing finding. Found by API→UI Wave 03 (School registration), 2026-09-24,
> from `125:511` (light, first read) and `337:5269` (dark). **Not changed in Wave 03:** everything
> below lives in the shared field widgets (`FieldLabel`, `FieldShell`, `ReferenceDropdown`), which
> University registration (Wave 04), Sign-up identity and Edit Profile also use. What Wave 03 did change
> is screen-local: the 25 dp block rhythm and the subtitle grey (#24 addendum).

**The frame's field block** (`Component 4` / `Component 19_ dark`, each block 92 tall): label, then
a **10** gap, then the 60 × r20 box. Blocks are 25 apart.

| Element | Frame | Build | Class |
| --- | --- | --- | --- |
| Label → box gap | **10** (auto-layout) | 8 | frame-proven; shared widgets → owner call (fix once, for both tracks, in Wave 04?) |
| Label type | Inter Medium 18 / 1.2 | `labelLarge` 14/18 w600 | type scale: the handoff names Label/Large for "Form labels"; Login kept it (Wave 01) |
| Label colour | `#1B1B1B` light / `#FCFBF9` dark | `textSecondary` `#2C2C2C` / `#DCDCDC` | near; same call as the type |
| Value text | 18 Regular, `#696969` light (every value, selected or not) / `#FCFBF9` dark | `bodyLarge` 16, `textPrimary` | type scale (no 18/400 style); light colour ambiguous: the frame greys selected values too |
| Chevron | custom 13.48 × 8.09, `#2A2A2A` (BGray) | Material `keyboard_arrow_down`, `hint` `#696969` | shared widget; light only (see dark below) |
| Content inset | 10 (light) / 16 (dark) | 14 | the two canvases disagree; not changed |

**Dark-frame inconsistencies (`337:5269`), for the designer.** Governorate, City, Education System
and Grade have no chevron. The Country chevron is `#2A2A2A` on the dark canvas, so it can't be seen.
Education System shows "Cairo". School Name's value is `#696969` while every other dark value is cream.
The CTA's blurred glow layer is still labelled "Send OTP". None of this was built; the light frame
is the reference for these.

**Fix we need:** the owner to say whether the label → box gap (and, with the designer, the label and
value type) changes in the shared widgets, which would also move University registration, Sign-up identity and
Edit Profile.

**Addendum, Wave 04 (University registration, `125:2336` / `337:10373`).** Both University frames use
the same block: labels are 22 tall with the box at 32, so the label → box gap is **10**. Blocks are
**25** apart, the same as School. That makes the 10 dp gap frame-proven on both tracks, and it is
still unbuilt pending the owner's call. New disagreement: the **light University** frame colours the
title **and** every field label `#384F47` (brand green), while the light School frame uses black
(`#000`) and `#1B1B1B` for the same elements. Both build as `textPrimary` / `textSecondary`, and
that is not changed until the designer says which frame is right. The dark University fields
(`rgba(39,40,44,.2)`, no stroke) also differ from dark School (`rgba(35,36,40,.2)` + 0.03 cream).
That is Glass territory, so it wasn't read further. The dark CTA's blurred layer is labelled
"Send OTP" here too.

> #91 is held for the app-icon session's entry.

## 92. 🟡 The school Leaderboard toggle reads "NOW | Last Month", but the contract has scopes, not time periods

> **Classification:** design ↔ contract divergence, pre-existing, **built the contract's way**. Flagged
> by the 2026-09-24 COMPARE (`figma_ui_comparison.md` §6) and logged by API→UI Wave 06 (2026-09-25).
> That wave also read the university frame for the first time.

**What the frames draw:**

| Frame | Toggle |
| --- | --- |
| school light `133:3117` (`158:841`, `158:843`) | **NOW · Last Month** |
| school dark `337:5528` (`337:5617`, `337:5619`) | **NOW · Last Month** |
| university light `134:3626` | **Global · Cohort** |

**What the contract has:** `GET /leaderboard` takes a required `scope`
(`openapi.yaml:2123`): school `system | governorate`, university `cohort | global`, anything else
`400 validation_failed`. It also takes `cursor` and `limit`, and nothing else. There is no time
parameter and no historical board, so "Last Month" has nothing to call.

**What is built:** one scope switcher on both tracks (`scope_toggle.dart`): school
`System | Governorate`, university `Global | Cohort`. A school student outside Egypt gets no toggle,
because there is no `governorate` board for them. The university frame shows the designer already drew
this control as a scope switcher for one track, so the school frame reads as an older draft of the same
control.

**Fix we need:** the designer to redraw the school toggle as `System | Governorate`. If the product does
want a board by time period, that is a contract request to Seif (`docs/seif_fight.md`), not a client
change. The app must not approximate one.

## 93. 🟠 Dark podium: the rank numerals are cream on pale badges (1.06:1 and 1.00:1), as the frame draws them

> **Classification:** frame defect → **designer decision**, built as drawn (the #86 precedent). Found by
> API→UI Wave 06's frame re-read (2026-09-25); first seen on the Wave 05 device walk.

**The badges, read as vectors** (`Ranks`: light `134:3421`, dark `337:5577`):

| Place | Fill | Stroke | Numeral light | Numeral dark | Dark contrast |
| --- | --- | --- | --- | --- | --- |
| 1 | `#FFCA28` | black light · `#FCFBF9` dark | black | `#FCFBF9` | **1.48:1** |
| 2 | `#F4F4F4` | `#DC4A22` | black | `#FCFBF9` | **1.06:1** |
| 3 | `#FCFBF9` | `#DEDEDE` | black | `#FCFBF9` | **1.00:1** |

Light measures 12.6–18.7:1 with the build's `textPrimary`. In dark the frame keeps the pale badges and
flips only the numeral to cream, so places 2 and 3 carry no readable number and place 1 barely does.

**Changed in Wave 06, because the frame is explicit:** until then every badge took one near-black stroke,
and place 3 used place 2's `#F4F4F4` fill. Each place now takes its own fill and stroke in both
canvases (`podium.dart`; tokens `podiumSecondBadgeBorder` `#DC4A22` and `podiumThirdBadgeFill`
`#FCFBF9`; place 3's stroke reuses `podiumThirdRing` `#DEDEDE`). **Not changed:** the numeral colour.
It stays `textPrimary`, which is the frame's value on both canvases.

**Also recorded:** both frames set the numerals in NATS Regular 20. NATS is not an app font and a
20/400 style is not in the type scale, so the build keeps `AppType.captionSmall` (10/14). No size was
chosen.

**Fix we need:** a designer ruling on the dark numeral colour. No colour is proposed. The light frame's
own dark numeral on the same fills is the in-file precedent, as in #86.

## 94. 🟡 Lectures: the revision tabs draw a radio circle where Normal draws a chevron, and the contract takes one lecture

> **Classification:** product / designer question. Built as the Normal frame. Found by API→UI Wave 08's frame
> re-read (2026-09-25).

**Where:** the university Lectures screen has four frames. All four are named "Learn(Lecture) for school
student".

| Frame | Canvas | Selected tab | Tab order | Row trailing |
| --- | --- | --- | --- | --- |
| `180:5354` | light | Normal | Normal · Midterm · Final · Flashcard · Practice | chevron, 28, stroke `#4B675E` |
| `180:5208` | light | Midterm | Normal · Flashcard · Midterm · Final · Practice | empty circle `Group 37220`, 20, stroke `#384F47` |
| `349:15962` | dark | Normal | Normal · Flashcard · Midterm · Final · Practice | chevron, stroke `#FCFBF9` |
| `337:11059` | dark | Midterm | Normal · Flashcard · Midterm · Final · Practice | empty circle, stroke `#FCFBF9` |

**What:** on Midterm, every row ends in an empty circle. It is the same `Group 37220` the track-selection cards
use as a radio (#40). A radio reads as "pick lectures", which would mean several lectures in one revision quiz.
The contract has no such request. `POST /quizzes` takes one `lectureId` (required on `mode: normal`) and a
`quizType` (`contract/openapi.yaml:1499-1500`). There is no list of lectures to send. No frame shows a filled
circle or a control that submits a selection.

**Built as:** the Normal frame on every tab. Each row has a chevron, and a tap opens quiz setup for that one
lecture with the selected quiz type. No selection state was invented.

**Fix we need:**
1. **Designer:** what does the circle mean? If it is a multi-select, the selected state and the control that
   starts the quiz need drawing.
2. **Seif**, only if it is a multi-select: a multi-lecture scope for the revision quiz types.

**Also corrected by the same read:** COMPARE (§11) said there is no dark Lectures frame. There are two,
`349:15962` and `337:11059`. Their rows match the build: `#27282C` fill, a cream hairline and chevron, and an
`#AE87E7` bar on `#2E2D32`. The tab order differs between frames; the build keeps the server's `quizTypes`
order (#18). `349:15962`'s search placeholder reads "Search Subjects" (#17).

---

## 95. 🟡 The quiz header's AI "sparkle-cap" icon is not built

> **Classification:** designer question, owner ruling. Found by API→UI Wave 12's frame re-read (2026-09-26).

**Where:** the quiz header, `295:3103` (`tdesign:ai-education`, 26.55) in `159:845`, `159:1431` and `159:1852`;
drawn lit (a filled rounded square, `#AE87E7` radius 6 at 35 in dark `337:9213`) in `159:1695` and `337:9182`,
the two frames with the AI panel open.

**What:** the frames suggest a toggle for the explanation panel, but nothing specifies what it does. It is also
drawn on an unanswered question (`159:845`). The contract allows the explanation affordance only after grading:
*"Render the affordance from `AnswerResult.explanationAvailable`, and call this endpoint only when it is `true`
… When it is `false`, do not render the affordance."*

**Built as:** nothing in the header (owner ruling 2026-09-26). The panel's own "Show explanation" button is the
affordance, and it appears exactly when the contract allows. Before grading the icon would break the contract;
after grading it would duplicate that button. The bookmark and share icons beside it stay out too (seif_fight
S11). Pinned by `quiz_screen_test.dart` ("the header carries no AI icon, before or after grading").

**Fix we need:** the designer says what the icon does. If it is the panel's toggle, it should appear only once
the answer is graded and `explanationAvailable` is true.

---

## 96. 🟡 The question photo is shown whole, not cropped into the frame's 360 × 189 box

> **Classification:** deliberate divergence, owner ruling. Found by API→UI Wave 12's frame re-read (2026-09-26).

**Where:** `216:2973` "Quiz page with photo" (`216:3013`, `Rectangle 6425`), and `159:1852`.

**What:** the frame draws the image in a fixed 360 × 189 box, radius 17, 0.5 `#4B675E` hairline, with the sample
picture cropped to fill it. `QuizQuestion.imageUrl` is a full image of any shape (`openapi.yaml`, "Full image
(DO Spaces CDN, WebP)"), and the frame's sample is a labelled diagram. Cropped to a fixed box, a tall or wide
diagram loses labels.

**Built as:** the frame's position and chrome, the image's own shape. The image sits above the question card
(it used to sit below it), 22 over the card, the card 22 over the options, radius 17 with the card's hairline.
The image fills the width at its own aspect ratio (owner ruling 2026-09-26). The loading and failed states hold
the frame's 189 dp box. There is no dark photo frame, so dark takes the card's dark hairline.

**Fix we need:** the designer confirms whole-image, or specifies a fixed box and what happens to images that do
not fit it.

---

## 97. 🟡 The result ring's figure is 64 ExtraBold; the type scale stops at 28

> **Classification:** type-scale gap, owner ruling. Found by API→UI Wave 13's frame re-read (2026-09-26).

**Where:** the quiz result, `159:2239` "50%" (light) / `337:6654` (dark), inside the 192 ring.

**What:** the frames set the figure in Inter ExtraBold 64 (`#3D3D3D` light, `#FCFBF9` dark). The designer's type
scale tops out at `displayLarge`, 28 Bold, and the project rule is that no size is set outside the scale. At 28 the
figure fills about a third of the ring's width where the frame's fills about three quarters.

**Built as:** `AppType.displayLarge` in the frame's colours (owner ruling 2026-09-26: keep the scale, log it). The
same screen has four smaller off-scale sizes, each on the nearest scale style: the bucket numbers (Cairo Bold 22 →
`h2` 20), the rewards runs (19.45 → `h2` 20 bold and `bodyLarge` 16 regular), the title (22 → `h2`) and the CTA
label (22 → the button theme's 16).

**Fix we need:** the designer adds a display size for the ring (and says whether the other four should move), or
confirms the scale's sizes here.

---

## 98. ✅ FIXED 2026-09-27 on the panel and the CTA (owner ruling; DEVICE-VERIFIED 2026-09-27; review open) — The ai-education glyph draws about 9% large on the quiz panel and the result CTA

> **Classification:** build defect, cross-screen → **owner decision**. Found by API→UI Wave 14's frame re-read
> (2026-09-27), at SOURCE; not measured on the device. Not fixed there: the two sites are Waves 12 and 13.
>
> **OWNER RULING 2026-09-27: fix** (option a; the owner's reply "15-6 c, 100 a, 14-10 b, 98 a, 99 b", 2026-09-27). Both sites are sized by the
> drawing's height, as on review, after their own frames' boxes (`159:1695`, the result CTA in `159:1964`) are
> re-read.
>
> **Applied 2026-09-27 (owner `fix`), with the premise corrected by that re-read.** All five instances (the panel
> `159:1839` and dark `337:9272`, the CTA `159:2348` and dark `348:7871`, review `162:2589`) hold the same group in
> their 26.55 box: **22.12 × 21.01** at (2.215, 2.289), not "26.18 × 24.41, 0.18 in" (the number this entry and
> Wave 14 used). The asset's geometry is that group at 1:1: 22.12 × 21.01 from (2.031, 2.287) of its 27 × 25 viewBox.
> So the frames draw the asset at scale 1.0; the square-boxed sites drew it at **1.062×**, not 9% large. The square
> box also laid out 28.67 wide, so the panel title and the CTA label sat 2.12 further out than the frames' 8.089 and
> 10. Both sites now use `AiEducationGlyph` (`lib/features/quiz/widgets/ai_education_glyph.dart`): the 26.55 box, the
> asset 27 × 25 at (0.184, 0.002) in it; the title and the label sit on the frames' gaps. Golden `ai_panel_dark.png`
> regenerated (the glyph and the title only). **Review is not changed:** `quiz_review_screen.dart` sizes the glyph by
> a height of 24.41, which by the same reading draws it at 0.976×; that is a walked screen and waits for the owner.

**Where:** `lib/features/quiz/widgets/ai_explanation_panel.dart:80` and
`lib/features/quiz/screens/quiz_result_screen.dart:171`, both `SvgPicture.asset('assets/icons/ai_education.svg',
width: 26.55, height: 26.55, fit: BoxFit.contain)`.

**What:** in the review frame the glyph is a 26.55 Iconify box whose drawing is **26.18 × 24.41** (`162:2589`, from
the group's insets). `vector_graphics` 1.2.2, under `flutter_svg`, derives the width from the height whenever a
height is given and ignores the width passed with it (`vector_graphics.dart:473`). Both calls therefore draw the
27 × 25 asset at **28.67 × 26.55**: about 9% larger than the drawing and 2.1 wider than the box. The review row
(Wave 14) now sizes the glyph by the drawing's height, 24.41, and a test pins it.

**Fix we need:** the owner's go-ahead to size the other two the same way. Their own frames' boxes (`159:1695`,
the result CTA in `159:1964`) should be re-read first to confirm the same insets.

## 99. ✅ CLOSED 2026-09-27 (owner ruling) — The catalog header's title is Inter SemiBold 22 `#000000` in the frame; the build draws `h2` 20/700 `#0E0E0E`

> **Classification:** build ↔ frame drift, cross-screen → **owner decision**. Found by API→UI Wave 15's frame
> re-read (2026-09-27), at SOURCE and on a real-font render. Not changed there: `CatalogHeader` is shared by
> Subjects, Units, Chapters, Lessons and the Mistakes screens, and four of them have been walked at 100%.
>
> ✅ **OWNER RULING 2026-09-27: keep `#0E0E0E`** (option b; the owner's reply "15-6 c, 100 a, 14-10 b, 98 a, 99 b", 2026-09-27). Every catalog
> header keeps `ext.textPrimary`; no token is added and no screen is re-walked. Size and weight stay on #57's ruling.
> The review header keeps its own `quizReviewTitle` (`#000000`, Wave 14), so the two headers differ by 6/255 in
> light, accepted.

**Where:** `lib/features/catalog/widgets/catalog_scaffold.dart:84`, `AppType.h2.copyWith(color: ext.textPrimary)`.
Frame: "Mistakes" `404:6480` in `404:6292`. The dark instance (`404:7598`) is cream, like the build.

| | Frame | Build |
| --- | --- | --- |
| Size | 22 | 20 |
| Weight | 600 SemiBold | 700 Bold |
| Light colour | `#000000` | `#0E0E0E` (`textPrimary`) |
| Dark colour | `#FCFBF9` | `#FCFBF9` |
| Word "Mistakes", ink | 93 wide, cap top 9.6 below the header box | 84 wide, cap top 9.7 below it |

**What is actually open:** the size and weight follow **#57**'s ruling for the review title (the scale has no 22;
nearest by role is `h2`). The colour is the real difference: Wave 14 gave the review header the frame's `#000000`
through its own token (`quizReviewTitle`), while every catalog header still draws `#0E0E0E`.

**Fix we need:** the owner's call. Either give every catalog header the frame's black (one token, five screens, each
re-walked), or accept `#0E0E0E` and close this.

## 100. ✅ FIXED 2026-09-27 (owner ruling; DEVICE-VERIFIED 2026-09-27) — The tree row's chevron ends 12 from the row's edge in every row frame; the catalog rows inset it 17

> **Classification:** build ↔ frame drift, cross-screen → **owner decision**. Found by API→UI Wave 16's frame
> re-read (2026-09-27), at SOURCE and on a real-font render. Fixed on the Mistakes rows only; the catalog rows are
> walked screens (Waves 08–10) and share the widget.
>
> **OWNER RULING 2026-09-27: fix** (option a; the owner's reply "15-6 c, 100 a, 14-10 b, 98 a, 99 b", 2026-09-27). The catalog palette takes the
> Mistakes rows' end inset (11.5 + the 0.5 border), so the chevron ends 12 from the row's edge; the catalog Units,
> Chapters, Lessons and Lectures screens are re-walked after.
>
> **Applied 2026-09-27 (owner `fix`):** `_catalogPadding` in `tree_list_row.dart`, end 11.5 + 0.5, top and bottom
> unchanged. Re-read first on every catalog row frame, light and dark (`135:1064`, `135:1302`, `308:4769`,
> `309:5656`; `337:5926`, `348:7457`, `348:7527`, `349:16001`): the container 17 from the start, 334 wide, ending 12
> from the end; the chevron ending there; the text column 242 wide from 69 (the build's was 237); the caption 12.66
> before the chevron. Pinned by the "#100" group in `tree_list_row_test.dart`. The Lectures frames' circle variant
> (`309:5714`, #94) ends 12 from the edge too. **Device-verified 2026-09-27** on all four catalog list screens,
> light and dark, English and Arabic (`device_walk_results.md`, "Fix batch").

**Where:** `lib/features/catalog/widgets/tree_list_row.dart`, the catalog palette's `EdgeInsetsDirectional.all(16.5)`.
Frames: the catalog Chapters row `135:1302` and the Mistakes rows `404:6642`, `404:6697`, `404:8707` all draw the
row's content in one container 17 from the start and 334 wide inside a 363 row, so it ends **12** from the row's end,
and the 28-dp chevron ends there. The build pads 16.5 plus the 0.5 border on both sides, so the chevron ends **17**
from the edge, 5 dp too far in, and the name has 5 dp less width.

**Fixed in Wave 16 for the Mistakes palette** (`_mistakesPadding`, end 11.5 + 0.5). **Not changed** on the catalog
Units, Chapters, Lessons and Lectures rows.

**Fix we need:** the owner's call. Either give the catalog palette the same end inset (one line; the four catalog
list screens re-walked), or accept 17 there and close this.

## 101. 🟡 The Profile stat cards differ by frame: light draws Rank "HERO", dark and RTL draw Badges

> **Classification:** frame ↔ frame disagreement → **OWNER RULING 2026-09-27: keep Points only** (API→UI Wave 19).
> No card is added; the designer reconciles the frames. Noted under `seif_fight.md` S25.

**Where:** `lib/features/profile/screens/profile_screen.dart`, `_Loaded`: one `ProfileStatCard`, Points.
Frames: light `166:4416` / `309:7940` draw Solved Questions (full width), Points and **Rank "HERO"**; dark `337:7433` /
`349:12919` draw Solved Questions, Points and **Badges 8**; RTL `549:21052` / `549:26384` draw all three in ONE row:
عدد الاسئلة 300, النقاط 2,450, الشارات 8.

**What is real:** `badges` is a required integer on `StudentProfile` (`openapi.yaml:2478`), so a Badges card could be
filled; Solved Questions (S24) and Rank (S25) have no source.

**Fix we need:** the designer: one stat block for every canvas and language. Until then the build shows Points only.

## 102. ✅ BUILT 2026-09-27 (API→UI Wave 19) — The Logout dialog draws No and Yes; the build had one red confirm

> **Classification:** build ↔ frame drift (the wave's item 1), plus the button order in Arabic → **OWNER RULING
> 2026-09-27: mirror** it.

**Where:** `lib/features/profile/widgets/profile_confirm_dialog.dart` (the `cancelLabel` pair) and `_confirmLogout`
in `profile_screen.dart`. Frames, every Logout card (`180:4704`, `309:9472`, `337:7783`, `349:10855`, `549:21401`,
`565:13497`): the ✕, then a 315-wide row 15 in, **No** 155 × 60 `#EF4444` and **Yes** 155 × 60 `#384F47` light /
`#AE87E7` dark (both tracks), 5 apart, radius 20, the shadow and no glow; the card 345 × 239, ending 15 under the
row. The build drew Go to Uni's shape: the ✕ and one full-width red "Logout".

**Built:** the pair as drawn. No and the ✕ dismiss, Yes signs out (keys `logout_no`, `logout_confirm`); the copy
"No" / "Yes" and "لا" / "نعم" (the RTL frames' words). Yes takes the new `CtaTone.shadowOnly` (edit2 #12: neither
pair button glows). **Arabic:** the RTL frames keep No on the LEFT, the half-mirrored RTL family of #58 and #64; by the
owner's ruling the build mirrors it, so No sits at the reading start, on the right. `edit2.md` #12 still describes the
single-button build; it predates this.

**Also on these dialogs, frame-proven, same wave:** the ✕ is the frame's cross (the limit card's asset) in `#3F3F3F`
in light (it was `textPrimary` `#0E0E0E`; token `profileDialogClose`), with a 48 × 48 target centred on the frame's
23-dp box (it was 35 × 35); the card is 345 on the 402 frame (was 344); Go to Uni's button is 284 wide and centred
(was 309 at 18); the Logout card ends 15 under its pair, Go to Uni's 20 under its button. Pinned by the "Wave 19"
group in `profile_screen_test.dart` and the `confirm_dialog_*` goldens (two new: `_pair`).

**Not changed:** the text follows the type scale (title `h2`, body `bodyLarge`, buttons `buttonLarge`; the frame: 22,
20 Medium, 22), so the vertical rhythm is the app's dialog rhythm, not the frame's y values. The ✕ box is centred on
the title row (centre 37.5); the frame's box sits 1 dp higher (25–48 in a 20–55 bar).

## 103. 🟡 The dark university Logout frame's scrim is 30%; the dark school frame's is 60%

> **Classification:** frame ↔ frame disagreement → **OWNER RULING 2026-09-27: 60% on both tracks** (a likely copy slip).
> Found by API→UI Wave 19's frame read.

**Where:** `lib/core/theme/app_elevation.dart`, `AppElevation.dark.logoutDialogScrim` (`#313131` at 60%, sigma
9.95), one token for both tracks. Frames: dark school `337:7677` draws `#313131` at 60% with a 19.9 background blur;
dark university `349:10749` draws 30% with the same blur (the light frames' opacity, the dark blur); Go to Uni's dark
frame `337:7561` 60%.

**Fix we need:** the designer: confirm 60% for both tracks, or give the university frame its own value on purpose.

## 104. 🟡 The Profile menu labels are Inter Medium 18 in the frame; the build draws `h3` (18 / 600)

> **Classification:** record only (API→UI Wave 19's frame lens). The type scale has no 18 / 500 style; the scale wins,
> nearest by role (#57), as for the registration labels (Inter Medium 18 → `labelLarge`, #90's table).

**Where:** `lib/features/profile/widgets/profile_menu_row.dart`, the label `AppType.h3`. Frame: every Profile row
label (`170:4796` and siblings), Inter Medium 18, line 21.

---

## 105. ✅ BUILT 2026-09-28 (API→UI Wave 20, owner ruling) — Edit Profile's locked rows follow the frames

> **Classification:** owner ruling 2026-09-28 ("follow the frames").

**Where:** `lib/features/profile/screens/edit_profile_screen.dart`, `_ReadOnlySection`. Frames: school `176:1201`
(dark `337:7795`, RTL `549:21413`), university `180:6349` (dark `349:12688`, RTL `549:26807`).

**What the frames draw.** School: Full Name, E-Mail, Phone Number, Parent's Number, City, School name. Education
System and Grade are in the file as hidden layers (`176:1737`, `176:1747`). University: Full Name, E-Mail, Phone
Number, Faculty, Academic Year, City, University name. The Wave 20 plan said there was no real university frame;
`180:6349` is one.

**What the build drew.** Phone and City, then Education System, Grade and School (school), or University, Faculty and
Academic Year (university). Education System and Grade printed the raw wire codes (S35).

**Ruling and build.** The frames' rows, in the frames' order: school Phone, City, School name; university Phone,
Faculty, Academic Year, City, University name. Parent's Number is still not built: `GET /me` does not return it (S34).

**Kept, and not in the frames.** The rows stay locked (S20), so they do not wear the frames' input look: a padlock
where the frames draw a dropdown caret on City and School / University name, the "set when you registered" caption
above the rows, and the phone as one LTR line (`+201…`) where the frames draw a flag, a `+02` chip (#6 rules `+20`)
and the local number. The labels keep the type scale (#90).

---

## 106. ✅ BUILT 2026-09-28 (API→UI Wave 20) — The avatar action sheet wore the picker's title and ✕ over bordered icon rows; its frame is a drag handle over two plain rows

> **Classification:** frame-proven (`216:3341`, dark `337:8135`, RTL `549:21753`, university `309:8194`); the
> disabled row by owner ruling 2026-09-28.

**Where:** `lib/features/profile/widgets/avatar_sheets.dart`, `AvatarActionSheet` and `_SheetRow`.

**Frame.** A 94 x 4 handle (`#000000` light, `#FCFBF9` dark) 15 under the card's top; two full-width rows 44 tall,
the labels 20 in (Inter Medium 20), the first row at 39; one 0.5 hairline, `#4B675E` at 60%, along the first row's
bottom; 13 between the rows. No title, no ✕, no icons, no row borders.

**Build now.** Exactly that. The labels keep the scale's `h3` (18 / 600, the same 24 line), as #104 does.

**Kept, and not in the frame (owner ruling).** "Upload photo" is dimmed and inert, with the caption "Uploading your
own photo isn't available yet." under the rows: `PUT /me/avatar` is draft and moderated (S29). The frame draws the
row as a live one.

**Frame slips, recorded, not built.** The dark frame's first row is 57 tall (light and RTL: 44). In the RTL frame the
second label is set `align=LEFT` and the first `RIGHT`; both end 20 from the right edge, as the build's do.

**The picker (`180:4153`), same wave.** Its ✕ is the frame's `akar-icons:cross` in `#3F3F3F` / `#FCFBF9` with a
48 x 48 target (W19-3's pattern; it was `Icons.close` in `textPrimary`, 35 x 35), and every cell draws the frame's
radial gradient disc (`#4B675E` → `#95CDBB`), as Edit Profile's avatar now does (`176:1343`). The RTL picker frame
(`549:21642`) keeps the ✕ on the left; the build mirrors it, as every other ✕ in the app does. The selected ring (2.5,
`cs.primary`) is the build's: the frame's five cells are identical.

---

## 107. ✅ BUILT 2026-09-29 (API→UI Wave 21, owner ruling) — The Settings switch is the frame's 48 x 24 stadium, not Flutter's; 🟡 its OFF state is not designed

> **Classification:** frame-proven for ON (Rank `642:8525`, dark `642:8587`; Notification Preferences `176:2394` …
> `176:2421`, dark `337:8199` …; Arabic `549:21822` …); OFF by owner ruling 2026-09-29.

**Where:** `lib/features/settings/widgets/settings_rows.dart`, `SettingsToggle`; tokens `settingsToggleOnTrack`,
`settingsToggleOffTrack`, `settingsToggleKnob`.

**Frame.** A 48 x 24 fully rounded track in `#AE87E7` on both canvases; a 16 dp `#FFFFFF` knob 4 in from the right end,
centred; the switch ends 16 in from the card (inside its 0.5 hairline) and is centred on a 52 row. Every switch in the
file is drawn ON.

**Build before.** Material 3's stock `Switch`: 52 x 32 with a growing knob, in the theme's seed colours. No theme value
gives it the frame's shape.

**Build now.** The frame's shape and colours. The switch only paints; the row is the tap target and carries what the
stock switch used to announce (toggled, enabled, the tap).

**Ruling (OFF).** The knob moves to the left end over `#B3B3B3`, `mutedText`'s value (the app's inactive grey, the same
on both canvases), until the designer draws OFF. `#B3B3B3` on the `#FCFBF9` card is about 2.0:1 and ON's `#AE87E7` is
2.74:1 (#77): both under the 3:1 guideline for controls. The knob's position and the announced state carry the value.
**Ask (designer):** draw the OFF state.

**Drawn, and built as drawn.** The Arabic frame mirrors the row (the switch at the left edge, `549:21822`) but keeps the
ON knob at the switch's RIGHT end (`549:21823`), as in English. The knob's ends are physical. Platform switches mirror
it; the frame does not.

**Not the frame's colours on screen.** The four Notification Preferences switches are dimmed to 45% with their rows
(disabled, S28 / #48), so they do not paint the frame's full `#AE87E7` / `#FFFFFF`. The Rank switches do.

---

## 108. ✅ BUILT 2026-09-29 (API→UI Wave 21, owner ruling) — In Arabic the language track keeps English on the left

> **Classification:** frame-proven; owner ruling 2026-09-29 ("follow the frames").

**Where:** `lib/features/settings/screens/settings_screen.dart`, `_LanguagesSection`.

**Frames.** English at x 20 and Arabic at x 201 in every frame: light `176:2372` / `176:2374`, dark `337:8178` /
`337:8180`, Arabic `549:21798` "الانجليزية" / `549:21796` "العربية". Only the filled segment moves.

**Build before.** `SegmentedTrack` is a `Row`, so in Arabic it put العربية on the left.

**Build now.** This one instance is pinned to LTR; the page around it stays RTL. The primitive still mirrors for the
Lectures tabs and the leaderboard toggle, which share it.

**Kept, and not in the frame.** The Arabic frame names the English segment "الانجليزية"; the build writes each language
in its own script ("English", "العربية") in both locales, so a student stranded in a script they cannot read can find
the way out (`_LanguagesSection`'s rule since Day 8).

---

## 109. ✅ BUILT 2026-09-29 (API→UI Wave 21) — Settings' spacing, headings and row labels, measured against the frames

> **Classification:** frame-proven (`176:1840`, dark `337:8141`, Arabic `549:21759`).

**Where:** `lib/features/settings/widgets/settings_section.dart` (`kSettingsRhythm`, `SettingsHeading`),
`settings_screen.dart`, `settings_rows.dart`; token `settingsRowLabel`.

**Frame.** One spacing, 25. Each heading's box is trimmed to its cap height (13 tall), so the 25s run from the bar to
the first heading's cap top, from a heading's baseline to its control, and from a control to the next heading's cap
top. Headings sit on the content edge (x 20; the right edge, 382, in Arabic). Row labels are Inter Regular 16 in
`#384F47` light / `#FCFBF9` dark.

**Build before.** Heading to control 10 box to box (14.8 from the baseline); blocks 24 apart (30.1 to the next cap
top); content 12 under the bar (26.1 to the first cap top); headings inset 4; row labels `h3` (18 / 600) in
`textPrimary` (`#0E0E0E` in light).

**Build now.** The 25s, from Inter's own metrics (the baseline 19.22 down an `h3` line, the caps 13.10 above it).
`settings_frame_test.dart` checks them against the real font. Headings are flush with the edge, and marked as headers
for screen readers; row labels are `bodyLarge` in `settingsRowLabel`. Rows take the frame's padding, 16 / 14, inside the
card's 0.5 hairline, so a row is the frame's 52 (it was 53: 14.5 + 24 + 14.5, the hairline folded into every row), and
the note under a card is flush with it.

**Recorded, not changed.**
- The row pitch is 52.5 (52 + the build's 0.5 divider) against the frame's 52.2, so the Notification card is 210.5 tall
  to the frame's 209.
- A row label's baseline sits 1.4 lower in its row than the frame's. The build's label line is `bodyLarge`'s 24, the
  frame's is 21, and Flutter splits a line's leading in proportion to the font's ascent and descent where Figma splits
  it evenly. Every screen has this.
- The frame's row hairline is `#4B675E` at 50%, 0.2 dp, on both canvases (`176:2387`, `337:8196`): the first reading
  of it. The build's divider stays `profileRowBorder` at 0.5; a 0.2 dp line is half a device pixel.
- Headings keep `textPrimary` (`#0E0E0E` in light) where the frame reads `#000000`, as every heading and title in the
  app does.
- The line under Notification Preferences ("Notification settings aren't available yet.") is the build's, not the
  frame's: the reason the four switches cannot move (S28).
- Arabic headings fall back to Tajawal, whose ink sits differently in the same line; the gaps are Inter's.

---

## 110. ✅ BUILT 2026-09-29 (API→UI Wave 21, owner ruling) — The Arabic "Mode" heading is the frame's "الأوضاع", not "المظهر"

> **Classification:** frame copy; owner ruling 2026-09-29.

**Frame.** `549:21802` reads "الاوضاع". The ARB had "المظهر", a different word, not a spelling.

**Build now.** "الأوضاع", the frame's word spelled with its hamza (`settingsMode` in `app_ar.arb`).

**Kept.** The Arabic title: the frame's "الاعدادات" is the same word as the ARB's "الإعدادات" without the hamza, so the
ARB's spelling stays.

---

## 111. 🟡 The Arabic Settings frame has no Rank block

> **Classification:** frame gap.

**Frame.** `549:21759`'s content (`549:21790`) is 478 tall: Languages, Mode, Notification Preferences. There is no
Rank block ("الترتيب"), which the light and dark frames draw between Mode and Notification Preferences (`642:8516`,
`642:8579`). The university Arabic frame `565:14612` was not read.

**Build.** Rank stays in Arabic: a control a student has in English cannot disappear in Arabic.
**Ask (designer):** add the block to the Arabic frame.

---

## 112. 🟡 The language track's 44 dp height is under the 48 dp tap-target guideline

> **Classification:** frame value, the same class as #80 and #89.

**Frame.** `176:2371` / `337:8177` / `549:21795` are 44 tall; `SegmentedTrack` takes 44 by default, and so do the
Lectures tabs and the leaderboard toggle, which share it.

**Build.** Kept at the frame's 44, as #80 and #89 were. Not changed in Wave 21.

---

## 113. 🟡 The dark and Arabic flashcards frames are the OLDER layout — built from the updated light frame

> **Classification:** frame gap. Owner ruling 2026-09-29 (Wave 22, item 8).

**Frames.** The study screen's light frame `225:5582` is the updated layout: "Got it", the "<" button, a
restart button above the card (`1229:8739`), the card at 20,221.18 (363 x 454). The dark frame
`337:14475` and the Arabic frame `549:28041` are the older layout: no restart button anywhere, the card
358 wide at 22,178.18, the primary button reading "Confirm" / "التالى". The Arabic frame also keeps the
"<" at the left and the progress bar unmirrored. Hidden leftovers `222:5252`, `337:14430`, `549:27996`
are ignored.

**Build.** Both built from `225:5582` with directional layout: in Arabic the restart disc sits at the
LEFT (the end edge) and "<" behaves as the quiz's does in Arabic. Dark uses the dark frame's own values
where it draws the element (progress fill `#AE87E7`, track `#2E2D32`, the "<" Glass, the lavender
primary) and a stand-in where it draws nothing: the restart disc `#AE87E7` (the dark primary,
`flashcardAgainFill`) with a `#FCFBF9` glyph. The card stays `#FCFBF9` with `#384F47` text on the
dark canvas, as `337:14513` draws it.
**Ask (designer):** dark and Arabic frames of the updated layout, and the dark restart button.

---

## 114. 🟡 Flash Card Setup: light only, a white pill, a low-contrast helper, and provisional copy

> **Classification:** frame gap + copy. Owner rulings 2026-09-29 (Wave 22, items 3, 8, 9).

**Frame.** `1234:8797` (light only) matches the quiz setup `135:1622` for the header, back chip,
title, subject caption, lecture heading, hairline block and Start button (built with the quiz
setup's tokens). Its own elements: the pill `1234:8847` (363 x 45, fill `#FFFFFF`, 0.5 `#384F47`,
radius 10, Inter Semi Bold 18 `#384F47`) and the helper `1237:9845` (Inter Regular 12/18 `#6E7F7A`,
4 below the pill). The pill shows `Lecture.flashcardCount` (contract 3.27.0-m1; Seif's ruling
2026-09-25) and is not tappable (the changelog: "No size selector").

**Build and gaps.**
- The pill is `#FFFFFF` as drawn, although every other surface in these frames is `#FCFBF9`.
- The helper's `#6E7F7A` on `#FCFBF9` is about 4.1:1 at 12 px, under 4.5:1. Built as drawn.
- Dark is not drawn. Stand-ins: pill `#27282C` (the dark quiz setup's chip), border and label
  `#FCFBF9`, helper `#B3B3B3` (`mutedText`).
- The helper copy is the frame's, verbatim: "this is available Flash cards for this quiz" (lower
  case, "are" / "lecture" expected). **Its Arabic ("هذه الفلاش كارد المتاحة لهذا الاختبار") and the
  pill's Arabic ("{count} فلاش كارد") are PROVISIONAL**: the owner's term, but not the owner's
  wording.
- The English noun is spelled as each frame spells it: "Flashcard" (the tab), "Flash cards" (the study
  title), "Flash Card Setup", "{count} Flash Cards", "Flash cards" in the helper, and "flashcards" in the owner's
  preview-used-up line. The glossary term is "Flashcard".
**Ask:** the owner confirms or replaces the two Arabic strings; the designer confirms the helper's
English, its contrast, the pill's white, the English spellings, and draws dark and Arabic.

---

## 115. 🟡 The flashcards type sizes are off the scale — mapped to the nearest `AppType`

> **Classification:** frame value, the same class as #97 and #99.

**Frame.** Title Inter Semi Bold 22 (`225:5608`), the front Inter Bold 25 / 25.6 (`246:3244`), the back
Cairo Semi Bold 55.33 / 83 (`246:3236`), the buttons Inter Semi Bold 22, the counter Rajdhani Semi
Bold 12 (not bundled). `AppType` has no 22, 25 or 55.

**Build.** Title, buttons and counter use the quiz header's and action bar's styles (the frames match
the quiz's exactly). The front is `h1` (24 / 30); the back is `displayLarge` (28 / 34, the scale's
largest). The contract says `back` is free multi-line text that may hold several answers, so a
55-point block would not fit a real card; the back renders as a wrapping, centred block that scrolls
when long. The pill is `h3` (18, exact); the helper `captionRegular` (12 / 16 against 12 / 18).
**Ask (designer):** confirm the back's size for multi-line answers.

---

## 116. 🟡 No card without an image is drawn — and today no card has one

> **Classification:** frame gap against the contract.

**Frame.** Every drawn front reserves a 348 x 223 image (`image 71`) with the question 43 below it, and
the sample question ("What is A ?") points at labels in that image. The contract: `imageUrl` is
`string | null`, and "null is normal and is the answer in every environment today"
(`openapi.yaml`, `FlashcardCard`).

**Build.** Owner ruling 2026-09-29: an image only when the card has one. A card without one shows its
front text centred in the card, as the back's answer is. With one, the image box is centred (the
frame seats its column 5 / 10 in, a resize artefact) and a failed image collapses so the text
re-centres.
**Ask (designer):** the image-less front.

---

## 117. 🟡 The study title sits 26.5 dp left of centre; the header icons are dropped

> **Classification:** frame artefact + omitted affordance (owner rulings 2026-09-29).

**Frame.** `225:5607`'s title is centred at x 175, not 201: the header row is SPACE_BETWEEN over the ✕
(30), the title (122) and an 82-wide icon cluster (bookmark `503:6807`, share `503:6811`, hidden AI
`503:6802`). The quiz frame `159:845` centres its title.

**Build.** Centred (owner ruling), through the header shared with the quiz. Bookmark, share and the AI
icon are left out: no flashcards field or operation backs them (owner ruling; the quiz header's #95).

---

## 118. 🟡 The light progress fill is green here and lavender everywhere else

> **Classification:** frame value.

**Frame.** `225:5616` fills the progress bar `#5A7F73`. The dark frame (`349:15348`), the Arabic frame
(`565:17260`, light canvas) and every quiz frame fill it `#AE87E7`.

**Build.** `flashcardProgressFill`: `#5A7F73` light (the updated frame, in both languages), `#AE87E7`
dark.
**Ask (designer):** confirm the green is meant, and that the Arabic light frame follows it.

---

## 119. 🟡 The flashcards states and transitions nobody drew

> **Classification:** frame gap. Owner rulings 2026-09-29 (items 4-7) and the lead's calls.

**Build, per state.**
- **Loading:** the header without its counter, and a card-shaped skeleton.
- **Empty** (a `200` with no cards, e.g. a count gone stale): "Nothing here yet", no Retry.
- **Preview used up** (`403 flashcard_subscription_required`): the owner's line, "You've used this
  week's free flashcards." / "لقد استخدمت البطاقات المجانية لهذا الأسبوع.", and no button of any kind
  (a Retry would 403 again; purchase-silent).
- **Not part of your course** (`403 insufficient_scope`) and **pending deletion**: their existing
  lines, no Retry. **Offline / network:** the offline line and a Retry.
- **A grade that fails:** the student stays on the card with one line of copy under it; tapping the
  button again retries. A refusal that cannot succeed (`insufficient_scope`, `account_pending_deletion`)
  disables "Got it" and the restart button on that card instead. Grading is disabled while offline (the
  banner shows); flipping, "<" and ✕ still work. The line's colour is not designed:
  `flashcardGradeError`, the quiz's inline-error red `#921119` in light and the app's dark error text
  `#FF465C` in dark (the quiz's `#921119` is 1.7:1 on the dark canvas).
- **The flip:** 300 ms ease-out about the vertical axis (`247:3255` → `247:3256`, SMART_ANIMATE
  0.3 s); instant with reduced motion; each card starts on its front.
- **The end of a round:** no frame and no wording. Owner ruling: return to where the student came
  from — the study screen pops back to Setup. No completion screen.
- **"<" on the first card:** absent, as the quiz's is on question 1.
**Ask (designer):** the loading, empty, error, preview-used-up and grading-failure states.

---

# Appendix — edit4's open ledger, as of 2026-09-20

Everything the quiz/leaderboard elevation wave could not close by itself, in one
place, so that "unanswered" and "forgotten" stay distinguishable. Each row says who it is
waiting on. **None of it blocks the wave**; all of it blocks calling the wave finished.

## How to read a row — the six kinds

This wave produced all six, and they are not interchangeable. A row's **Kind** says what it is and
therefore who moves next; it does **not** say how urgent it is.

| Kind | What it means | Who acts next |
| --- | --- | --- |
| **pre-existing finding** | true before this wave touched the screen. Surfaced here, not caused here | nobody, until it is also classed below |
| **edit4 regression** | this wave made it worse or made it new | the build. **There are none.** |
| **designer decision** | the value is a choice, and the build must not make it | the designer |
| **contract clarification** | the answer is in `contract/openapi.yaml` or owed by Seif | whoever reads the pin |
| **device false positive** | the defect exists in the test binding and not on a phone | nobody — it closes |
| **resolved implementation item** | built, pinned, and confirmed | nobody — it closes |

Everything below is one of those. **None of it blocks the wave**; all of it blocks calling the wave
finished.

## Waiting on the DESIGNER — owner ruled 2026-09-20 that the build must not choose

Every row here is **pre-existing** unless it says otherwise, and **none is an implementation task**.
No colour is proposed in any of them, and none should be chosen from this table.

| # | Kind | Question | Shipped as | Why the build did not decide |
| --- | --- | --- | --- | --- |
| **#77** | pre-existing → designer | The scope toggle's selected label is **1.74:1** light and **2.02:1** dark | measured, unchanged | #77's 2.74:1 ruling is scoped to `#FCFBF9` on `#AE87E7`; this is a different pair on a different component, so it is not pre-covered. Three candidate labels are measured in #77 and **none was picked.** **DEVICE VERIFIED 2026-09-20** — both figures reproduced exactly off a Pixel 8 screencap. |
| **#86** | pre-existing → designer | The leaderboard's own row — the one that says "You" — is **1.75:1**, in BOTH canvases | measured, unchanged | Found by the device pass; worse than #77's, on a third colour pair (`podiumOnAccent` on `podiumAccent`), and the row beside it measures 14.99:1. **Not an edit4 regression** — this wave gave `LeaderboardRow` its fill, list shadow and dark Glass, never that foreground. |
| **#87** | pre-existing → designer | The dark quiz page's CORRECT option tile is **1.11:1** | measured, unchanged | Found by the device pass. **Not an edit4 regression:** `quizCorrectFill` is opaque in both canvases and only the foreground flips, so dark puts cream on a light mint. edit4 touched this widget's idle hairline and badge ring and nothing else. Carries **#53's comparison** as evidence. |
| **#54** | pre-existing → designer | The dark wrong row's hairline is **1.04:1** against its own fill | the frame's value at the frame's alpha | Any replacement red would be an invented hex. Raising the row's alpha instead is arithmetically dominated — the table in #54 shows it makes the badge and the text worse to make the stroke barely better. |
| **#54** | pre-existing → designer | Two frame values read and **not adopted** — the lavender "QUESTION n" label, and the selected chip label at 2.74:1 | build's own values | The first is a visual change with no elevation component; the second would be a deliberate accessibility regression. Both are recorded with their node ids. |
| **#72** | **NEW 2026-09-20 → designer** | `Frame 1000003007` is ONE component and its label reads **14** on Lectures (`180:5339`) and **18** on Settings (`176:2373`) — both Inter Medium 500 | `AppType.labelMedium`, 12/500, on both consumers | 18/w500 is **not in the type scale** (`h3` is 18/w600) and typography scales are top of the never-invent list. 14/w500 exists (`bodyMediumStrong`) so Lectures alone could move — but correcting one consumer of a shared style and not the other is how a shared style stops being shared. **No size was chosen.** Found while reading the Settings segments for edit5 #50. |

**One piece of context for the designer, offered as fact and not as a proposal.** The review
screen's own selected filter pill is the same lavender family as #77's and #86's fills, drawn the
other way round — a dark label on the accent — and it measures **5.48:1** on the same phone in the
same session. That is an existing product precedent. It is **not** a recommendation, and nothing in
this repo should be changed on the strength of it.

## Waiting on the CONTRACT

| # | Kind | Question | Next action |
| --- | --- | --- | --- |
| **#88** | contract clarification | Question bodies render `<u>…</u>` as literal text. Is `Question.body` plain text, or does the contract allow markup? | **Resolved 2026-09-27:** the contract allows `<u>…</u>` and nothing else (`openapi.yaml:2703`). Built in API→UI Wave 14 as `QuestionStemText`, on the quiz page and on review. |

## Closed by the 2026-09-20 device pass

| # | Kind | Was | Now |
| --- | --- | --- | --- |
| **#81** | **device false positive** | `System \| Governorate` overflows by 101 px at 375 dp and the groove scrolls | **It does not.** Pixel 8, 411 dp, English, text scale 1.3: two **186 dp** segments, groove spans the full width, nothing scrolls. Arabic measures the same. The 101 px was the test binding's font, ~1.5x wider than Inter — the caveat #81's own body already carried, and the case D-012 had already seen once. **No copy change is owed.** |
| **#53** | evidence gathered; **the ruling is still open** | The review rows are 20% + Glass while the quiz page's graded tiles are opaque, one tap apart, and nobody had seen them together | **The comparison D-010 asked for now exists**, measured on one phone in one session: review rows **8.22:1** and **9.13:1**, quiz correct tile **1.11:1**. Recorded in **#87**. **Neither treatment was changed**, and the decision remains the owner's. |

## Resolved implementation items from this wave

Listed so that "done" is as legible as "owed". None of these needs anything from anyone.

| # | What | Confirmation |
| --- | --- | --- |
| **#82** | Setup, Result and Review moved onto the shared header | built + DEVICE VERIFIED, both back paths walked |
| **#83** | the dark A/B/C/D badge ring took its own token | built + DEVICE VERIFIED |
| **#84** | `SegmentedTrackStyle.idleSegmentColor` removed; idle segments always transparent | built + DEVICE VERIFIED on **both** consumers. `quiz_type_tabs_dark.png` moved 1699/27336 px at a max channel delta of 9/255; no other golden moved and the repo's 38 are still 38 |
| **#85** | the rewards row's overflow at text scale 1.3 | built + DEVICE VERIFIED at 1.3 in Arabic |

## The walkthrough — RUN 2026-09-20 on a Pixel 8

**The full record is `docs/DEVICE_VERIFICATION_2026-09-20.md`**, in the dated form the 09-12 and
09-19 passes use: device and build, method, per-item coverage table, every contrast measurement,
and what was *not* covered. It is a separate file on purpose — this appendix is deleted when edit4
closes, and the device evidence should not go with it.

Two things are repeated here rather than only linked, because they must not be missed:

**A security control was switched off to take the screenshots.** The quiz screen sets `FLAG_SECURE`,
so `screencap` returns a black frame; `screenProtectionProvider` was overridden to a no-op **in
`lib/main_mock.dart` only**, which is the seam the feature was built with, against fabricated mock
questions, for one session. Together with a local-only `/leaderboard` ungating and a mock fixture
for it, that is three changes — **all three reverted**, `git diff` against `HEAD` empty for each,
and the reinstalled build re-checked on the phone showing "Coming soon" again.

**Still not verified on a device:** the university Lectures quiz-type tabs **in Arabic**, the
**offline and error states** of any edit4 screen, the **limit sheet**, **iOS**, and text scales
above 1.3.
