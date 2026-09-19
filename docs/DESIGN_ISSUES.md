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
| 18 | University Lectures draws a **Flashcard** quiz-type tab the contract has no value for | 🟠 | Seif + Designer | `quiz_type_tabs.dart` |
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

## 40. ✅ RESOLVED (rendering) — Sign Up_2 was correctly wired but rendered with stand-in art

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
variant, there being no evidence for the registration one.

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

---

## 46. 🟠 "Show Rank" is one switch where the contract has two independent booleans

**Where:** Setting (`176:1840`) — a single **Show Rank** toggle.
Code: `lib/features/settings/screens/settings_screen.dart`.

**What.** `PATCH /me` accepts two privacy fields (`openapi.yaml:620-621`), and adr-023 defaults them
differently (`:1380-1382`):

| Field | Question it answers | Default |
|---|---|---|
| `leaderboardVisible` | am I on the leaderboard at all? | `true` |
| `scoreHidden` | I am listed — is my score shown? | `false` |

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

## 49. 🟡 OTP resend-timer pill — built from a 100%-zoom screenshot, not Dev Mode; glyph landed

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
| Pill height / radius | 36 / 18 | measured; equals `LanguagePill`'s 36.10 stadium |
| Pill horizontal inset | 14 | measured |
| Glyph size | 15 × 19 | **read** — the export's own viewBox, drawn at native size |
| Gap glyph → digits | 8 | measured |
| Digits | `AppType.bodyMedium` (14/20, 400) | measured; 14 vs 16 is within the reading error |
| Pill fill | `AppColors.cardFill` | approved raised-surface token, not a read hex |
| Pill shadow | `elevationShadow` @ 0.25, 0.5/0.5/4 | the recipe the five #47 shadows share; the frame's looks softer/wider |
| Glyph tint | `colorScheme.primary` | **read** — the export's stroke is `#384F47`, the light primary and the colour of the "Resend OTP" label beneath it; `app_colors_test.dart` pins the two together |
| Digit tint | `AppColors.textSecondary` | approved token; the frame gives no value — **designer: same green as the glyph, or the dark grey?** |

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

**Still worth reading off the Properties panel** (view seat is enough): the pill's Width /
Height / Padding / Gap / corner radius, and the digits' text style and colour — each replaces a
measured row above.

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

---

## 54. 🟠 The dark review frame specifies no FOREGROUND anywhere — row text, AI glyph, or chip label

**Where:** quiz review dark `337:6705` — rows (`162:2510` in light), the AI glyph, and the selected
filter chip (`337:6825`). The light frame gives `#384F47` for the row content and `#FCFBF9` for the
chip label; the dark frame gives neither.

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

**Fix we need:** confirm the three dark values, or supply the intended foregrounds on `337:6705`.

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

## 64. 🟡 RTL variants exist; their node IDs are not yet mapped

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

### Recorded, not built (#55)

Glass exists on screens this app has not built: Customer Support (`337:8390`, G5 ×46 + G17),
Notifications (G5 ×46), Messages / chat (G5, G11 search), Friends (G5 chips `Frame 427319502`
47.5×19 `#384F47` @20%, G11 search), Create Ticket, Your progress, Refer a Friend (all G5), and the
University Learning Tools tiles (inner shadows — edit3 #43). Listed so the reading is not lost;
none of them is built by this pass.

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
