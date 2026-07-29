# Design issues & design ↔ contract gaps

> Living list of everything in the Figma that blocks or conflicts with the Flutter build.
> Share with the **designer** (and Seif where the contract is involved). Each item has:
> what's wrong, where (Figma node / screen), why it matters, the fix we need, and — where a
> placeholder already exists in code — the exact `file:line` + `TODO(design)` marker to grep.
>
> Figma file: `P6044i0giD9TmdQ7C2AmLq` · Contract: `contract/openapi.yaml` (commit 23f0535)
> Rule of thumb: **the contract wins**. Where the design lacks a required field, we build it
> anyway and flag it here so the design catches up.

## Severity
🔴 Blocking (breaks a required flow) · 🟠 Important (works, but wrong/incomplete) · 🟡 Minor / confirm

## Summary

| # | Issue | Sev | Owner | Code marker |
|---|---|---|---|---|
| 1 | Figma export disabled + our seat is View-only → can't export brand assets | 🔴 | Designer/Owner | `TODO(design-asset)` |
| 2 | `dateOfBirth` field missing from BOTH registration screens (contract-required) | 🔴 | Designer + Seif | `TODO(design)` ×3 |
| 3 | University `governorateId` missing from University Registration (contract-required) | 🔴 | Designer | `TODO(design)` |
| 4 | University field order breaks the University→Faculty→Year data cascade | 🟠 | Designer | built by cascade |
| 5 | OTP screen shows **4** digit boxes; contract requires **6** | 🟠 | Designer | built as 6 |
| 6 | Phone prefix shows `+02`; Egypt is `+20` | 🟠 | Designer | built as +20 |
| 7 | Referral / Invitation Code field has no backend field in the contract | 🟠 | PM + Seif | `TODO(contract)` |
| 8 | Login "Create New Account" implies a direct-registration path that can't exist | 🟠 | Designer | Day-3 fix |
| 9 | Legal URLs (User Agreement/Privacy/Cookie) not provided | 🟡 | Product/Legal | `TODO(legal)` |
| 10 | No in-app theme toggle although a full dark theme exists | 🟡 | Designer/PM | default light |
| 11 | Student phone re-shown on Sign Up_1 (already bound to token) | 🟡 | Designer | built read-only |
| 12 | Dark-mode primary accent flips green→purple — confirm intentional | 🟡 | Designer | — |
| 13 | Level-progress bar has no threshold to progress toward | 🔴 | Seif + Designer | `TODO(contract)` |
| 14 | ~~Learn Units/Chapters/Lessons frames unreachable~~ — **RESOLVED**, screens reconciled | ✅ | — | — |
| 15 | Subject-card caption is 8.56dp — below a readable minimum | 🟡 | Designer | built at 10 |
| 16 | Units/Chapters rows show a % progress the contract cannot supply | 🔴 | Seif + Designer | `tree_list_row.dart` |
| 17 | Search field drawn on all 3 drill-down screens, placeholder reads "Search Subjects" | 🟡 | Designer | not built |

---

## 1. 🔴 Asset export is blocked
**Where:** whole file. **What:** the file has *export disabled* and our account seat is **View-only**,
so the Figma MCP `download_assets` refuses. We cannot pull any brand art.
**Affected assets (currently placeholders in code):**
- **Bird logo** (Figma node `82:849`) → `lib/features/auth/screens/login_screen.dart:134`
  (`Icons.flutter_dash` placeholder) — `TODO(design-asset)`
- **OTP success badge** (green scalloped check, node `155:786`) →
  `lib/features/auth/screens/otp_screen.dart:354` (`Icons.check_circle` placeholder) — `TODO(design-asset)`
- Any future illustrations (empty/error states, onboarding).
**Fix we need (any one):** (a) owner re-enables *export/copy* on the file; or (b) grant Zlatan an
**Editor** seat; or (c) designer sends the SVGs directly. Then we swap placeholders for the real
assets via `flutter_svg`.
**Note:** national flags are NOT affected — handled by the `country_flags` package.

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

## 10. 🟡 No in-app theme toggle
**What:** a full **dark** theme exists in Figma, but no screen has a control to switch themes.
App currently **defaults to light** and follows nothing else. **Fix we need:** designer/PM decide
whether a theme toggle belongs in Settings (later) — dark theme is wired and ready.

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

---

## Code markers to grep
Run these to find every design-linked placeholder in the code:
```
grep -rn "TODO(design-asset)" lib/   # brand assets awaiting export
grep -rn "TODO(design)"       lib/   # design gaps built to the contract
grep -rn "TODO(contract)"     lib/   # fields with no backend (referral)
grep -rn "TODO(legal)"        lib/   # legal URLs
```
