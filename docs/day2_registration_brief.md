# Day 2 Brief — Registration front: Sign Up_1 + Sign Up_2 + spine

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Registration is a MULTI-SCREEN WIZARD. This brief builds the **front two screens**
> plus the shared spine and the reusable reference pickers. The track-specific field
> screens (geography / academic) and the final `POST /auth/register` are **Day 3**.

## Why the split

`POST /auth/register` submits ALL fields at once (discriminated on `track`). The design
collects them across a wizard:
1. **Sign Up_1** (`337:15875`) — identity
2. **Sign Up_2** (`337:15947`) — pick track (school | university)
3. → School Student Flow OR University Student Flow screens (geography, stage/system or
   university/faculty/year, avatar, DoB) — **Day 3**
4. → one `POST /auth/register` at the end — **Day 3**

The `registrationToken` from OTP's `registrationRequired` fork has a **10-minute TTL**, so
the whole wizard must complete inside that window; the spine holds it and surfaces expiry.

## Skills (in order)

1. `level-up-domain` — glossary + operating rules
2. `build-screen` — the loop
3. `seif-api-contract` — reference endpoints + the `SchoolRegistration`/`UniversityRegistration` shapes it's accumulating toward
4. `figma-frame` — layout from the frames; colours from the wired theme tokens (do NOT re-pull tokens)
5. `river` — `RegistrationController` (Notifier) + reference pickers (`FutureProvider`/`AsyncNotifier`)
6. `screen-states` — DoD pass

Figma nodes are dark-mode (`337:*`); layout is identical to light — the app renders both
via `Theme.of(context)` + `AppColors`. Pull the frames for detail if needed.

---

## ⚠️ Contract conflicts — resolve before coding

1. **Referral / "Invitation Code" field (Sign Up_1) has NO backend field.** Neither
   `SchoolRegistration` nor `UniversityRegistration` accepts a referral code. Options: treat
   it as **out of M1 scope** (collect nothing / hide it), or raise a Seif change request.
   **Do NOT invent a field.** Build the input as visually present but wire it to nothing, with
   a `TODO(contract)` — or omit. Recommend: keep the field, don't send it, flag to Seif.
2. **Student phone on Sign Up_1 is redundant.** The student's phone is already proven and
   bound to the `registrationToken`; the register body has NO student-phone field. Render it
   **read-only / pre-filled** (pass the phone from the OTP step through the router `extra`),
   never as an editable field that gets submitted.
3. **`parentPhone` IS required and IS in the contract** — the "Parent's Number" field maps to
   `parentPhone` (E.164, reuse the `Phone` value type from Day 1).
4. **`dateOfBirth` (required) is not on either front screen.** It must be collected on a Day-3
   track screen. Note it in the spine now (nullable until collected); confirm its screen.

---

## SCREEN 1 — Sign Up_1 (identity) · node `337:15875`

**Layout:** back chevron + language pill; "Create Account" / "Join thousands of students
leveling up"; **Full Name**; **Phone Number** (read-only, pre-filled — see conflict #2);
**Parent's Number** (`+20` chip like Login); **Referral Code (Optional)** (see conflict #1);
**Continue** (primary button).

**Behavior:**
- Entry: only reachable with a valid `registrationToken` (from OTP `registrationRequired`).
  Carry `{registrationToken, expiresInSeconds, phone}` via router `extra`.
- Validate: `name` non-empty (≤100); `parentPhone` valid E.164 (reuse `Phone.tryParse`).
- Continue → store name + parentPhone (+ referral, unsent) in `RegistrationController` → go `/register/track`.
- No network call on this screen.

**Files:** `features/registration/screens/signup_identity_screen.dart` (+ the shared controller below).

## SCREEN 2 — Sign Up_2 (track picker) · node `337:15947`

**Layout:** "Choose Your Track" / "This determines your content and quizzes"; two large
radio cards — **School Student** (books icon) / **University Student** (cap icon); **Continue**.

**Behavior:**
- Single select; Continue disabled until one is chosen.
- Sets `RegistrationController.track = school | university` (the register discriminator).
- Continue → route to the track sub-flow entry (Day-3 screens): school → `/register/school`,
  university → `/register/university` (add placeholder routes now).
- No network call.

**Files:** `features/registration/screens/signup_track_screen.dart`.

---

## The spine — `RegistrationController`

`features/registration/notifier/registration_controller.dart` — a `Notifier` holding an
immutable `RegistrationDraft` accumulated across the wizard, plus the token + its deadline:

```
class RegistrationDraft {
  final String registrationToken;
  final DateTime tokenExpiresAt;      // now + expiresInSeconds; surface expiry
  final String phone;                 // read-only, from OTP step
  final String? name;
  final String? parentPhone;          // E.164
  final String? referralCode;         // collected, NOT submitted (conflict #1)
  final RegTrack? track;              // school | university
  // Day-3 fields (nullable now): dateOfBirth, geography ids, academic ids, avatarId
  ...copyWith
}
enum RegTrack { school, university }
```

- Seeded from the OTP `registrationRequired` outcome (token + expiry + phone).
- If `DateTime.now() > tokenExpiresAt` at any step → show "registration expired, start again"
  and route back to `/login`. (Server also enforces; this is the friendly client guard.)
- Day 3 adds the geography/academic fields + the `POST /auth/register` submit.

## Reusable reference pickers (build now — Day 3 consumes them)

All under `features/registration/` (or `core/reference/`). One provider per endpoint; the
closed sets are bare arrays, schools is cursor-paginated. camelCase, freezed models.

| Provider | Endpoint | Shape |
|---|---|---|
| `countriesProvider` | `GET /reference/countries` | `[{code, nameAr, nameEn, requiresGovernorate}]` — `requiresGovernorate` drives the EG branch |
| `governoratesProvider(country)` | `GET /reference/countries/{code}/governorates` | `NamedRef[]` (empty for non-EG) |
| `citiesProvider(...)` | `GET /reference/cities` | `NamedRef[]` |
| `schoolsProvider(query, cursor)` | `GET /reference/schools` | cursor-paginated `NamedRef` (search) |
| `educationSystemsProvider` | `GET /reference/education-systems` | `[{code, nameAr, nameEn}]` (code ∈ nationalArabic/nationalLanguages/ig/american/ib) |
| `universitiesProvider` | `GET /reference/universities` | nested `[{id, name, faculties:[{id, name, years:[{id, yearNumber, status: active|soon}]}]}]` — client drills university→faculty→year |
| `avatarsProvider` | `GET /reference/avatars` | `[{id, url}]` (network images) |

Notes for Day 3 (record, don't build yet):
- **Geography conditionality (adr-010):** country EG → governorateId + cityId + schoolId all
  required, `schoolName` forbidden. Non-EG → cityId required, `schoolName` optional free text,
  schoolId + governorateId forbidden. University is Egypt-only (no country field).
- University `studyYearId` must be an **`active`** year (`soon` → validation_failed).
- Display `nameAr`/`nameEn` by current locale; submit the `id`.

## Files summary

```
lib/features/registration/
  models/        registration_draft.dart (+ freezed reference models: NamedRef, Country,
                 EducationSystemRef, University tree, Avatar)
  repository/    reference_repository.dart (the 7 GETs; typed AppException)
  notifier/      registration_controller.dart, reference_providers.dart
  screens/       signup_identity_screen.dart, signup_track_screen.dart
```
Router: add `/register` (identity), `/register/track`, and placeholder `/register/school`,
`/register/university`. Wire OTP's `registrationRequired` → `/register` with the token/phone `extra`.

## l10n (add keys, both .arb)

`createAccountTitle`, `createAccountSubtitle`, `fullNameLabel`, `parentNumberLabel`,
`referralCodeOptional`, `continueLabel` (exists), `chooseTrackTitle`, `chooseTrackSubtitle`,
`trackSchool`, `trackUniversity`, `registrationExpired`.

## Acceptance / DoD

- [ ] Both screens: loading / error / offline + AR (RTL) & EN (LTR); `EdgeInsetsDirectional`
- [ ] Reachable only with a valid `registrationToken`; expiry guard routes back to `/login`
- [ ] Student phone read-only; `parentPhone` validated E.164; referral collected but NOT submitted
- [ ] Track selection sets the discriminator and routes to the correct sub-flow placeholder
- [ ] Reference pickers fetch + cache; schools paginates; models camelCase (no `@JsonKey`)
- [ ] No token/PII logged; `flutter analyze` clean; `build_runner` ok; tests for the controller
      (accumulation + expiry) and the reference repo (`fromJson`, mock Dio)
- [ ] Do NOT build the track-detail screens or call `POST /auth/register` (Day 3)

## Scope / do NOT

- No `POST /auth/register` yet. No geography/academic field screens. Don't invent a referral field.
- Reuse Day-1 `Phone`, `AppColors`, `StateWidget`/`ScreenState` patterns, `AuthController`.
- Do NOT commit — leave for review.
