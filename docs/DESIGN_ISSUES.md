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

---

## Code markers to grep
Run these to find every design-linked placeholder in the code:
```
grep -rn "TODO(design-asset)" lib/   # brand assets awaiting export
grep -rn "TODO(design)"       lib/   # design gaps built to the contract
grep -rn "TODO(contract)"     lib/   # fields with no backend (referral)
grep -rn "TODO(legal)"        lib/   # legal URLs
```
