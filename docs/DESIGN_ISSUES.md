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

**Fix we need:** the shadow's exact colour/opacity/blur — **still open**. Built as ~8% black,
blur 20, y+4 behind the `navShadow` token, which carries a `TODO(design)`.

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
2. Whether the ring around the back button is a shadow or a stroke. Built with **no** stroke.

Also unmeasured: the **dark** back chip. `backChipFill` and `backChipGlyph` carry `TODO(design)` —
their dark values are fallbacks (page fill; cream, because `#4B675E` on `#232428` is too low
contrast for a navigation control), not read off a frame.

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

Related and deliberately not folded in: **`navShadow` has the same defect** — 8% black in both
canvases, itself already a `TODO(design)` (issue #37, open question 2). It was left alone because
it has its own derivation and restyling the bottom nav on the strength of a decision about card
shadows would be the wrong trade. It should almost certainly follow whatever this one becomes.

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
