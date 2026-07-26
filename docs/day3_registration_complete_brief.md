# Day 3 Brief — Registration completion + submit (closes the auth epic)

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Builds the track-detail forms + the final `POST /auth/register`, consuming the Day-2
> `RegistrationController` (draft) and the 7 reference pickers. Plus the Create-New-Account fix.
>
> Figma note: the School/University registration screens live inside the **School Student Flow**
> (dark section `337:5268`) / **University Student Flow** sibling section. Chrome disconnected
> while gathering exact frame spacing, so **build the layout from the contract fields below using
> the established components/tokens; group fields sensibly**. If a screen looks off vs the design,
> say so and I'll pull the exact frame. The FIELDS and RULES here are contract-authoritative and
> final — do not invent or drop any.

## Skills (in order)
`level-up-domain` · `build-screen` · `seif-api-contract` · `figma-frame` · `river` · `screen-states`

## What already exists (reuse — do NOT rebuild)
- `RegistrationController` (`Notifier<RegistrationDraft?>`) holding token + `tokenExpiresAt` + phone +
  name + parentPhone + referral + track. Add setters for the Day-3 fields.
- 7 reference pickers + `reference_repository` + models (`NamedRef`, `Country`, `EducationSystemRef`,
  university tree, `Avatar`, `CursorPage<T>`).
- `Phone`, `AppColors`, `ScreenState`/`StateWidget`, `AuthController` (`markAuthenticated`).

---

## Contract — `POST /auth/register` (stable, `security: []`)

Discriminated on `track`. Returns **201 `AuthenticatedResult`** (tokens + profile) — i.e. register
LOGS YOU IN. On success: `SecureStorage.writeTokens` → `AuthController.markAuthenticated()` → `/home`.

```
201 AuthenticatedResult   → store tokens, markAuthenticated, go /home
400 validation_failed     → ProblemDetails.errors is a FIELD MAP (incl. geography conditionality) → inline per-field errors
401 registration_token_invalid → token expired/consumed/wrong device → restart at otp/request (send them to /login)
409 phone_already_registered   → an account appeared since verify → restart login (/login)
```

### SchoolRegistration (required*)
`track:"school"`, `registrationToken`, `name`, `dateOfBirth` (date), `countryCode`, `cityId`,
`stage`, `educationSystem`, `parentPhone`.
Optional: `governorateId`, `schoolId`, `schoolName`, `email`, `avatarId`.

**Geography conditionality (adr-010) — enforce client-side AND let the server's field map show through:**
- **countryCode == EG** → `governorateId` + `cityId` + `schoolId` ALL required; `schoolName` FORBIDDEN.
- **countryCode != EG** → `cityId` required; `schoolName` optional free text; `schoolId` + `governorateId` FORBIDDEN.
- `requiresGovernorate` on the country row (`GET /reference/countries`) is the switch — use it to drive the UI branch.

`stage` ∈ prep1/prep2/prep3/secondary1/secondary2/secondary3 · `educationSystem` ∈
nationalArabic/nationalLanguages/ig/american/ib (from `GET /reference/education-systems`, tolerate unknown).

### UniversityRegistration (required*) — Egypt-only (NO country field)
`track:"university"`, `registrationToken`, `name`, `dateOfBirth`, `universityId`, `facultyId`,
`studyYearId`, `governorateId`, `cityId`, `parentPhone`. Optional: `email`, `avatarId`.
- `universityId → facultyId → studyYearId` are drilled from the `GET /reference/universities` tree.
- **`studyYearId` must be an `active` year** — hide/disable `soon` years (`status: "soon"` → validation_failed).

`name` + `parentPhone` are already in the draft from Sign Up_1 — do NOT re-collect them.

### Reference query params (for the pickers)
- `GET /reference/cities?countryCode=EG&governorateId=…` (governorateId optional; required-ish for EG UX)
- `GET /reference/schools?q=&governorateId=&cityId=&cursor=&limit=` (cursor-paginated search; EG only)

---

## Screens

Build one **track-detail form per track** (SCHOOL and UNIVERSITY), reached from Sign Up_2:
`/register/school` and `/register/university` (currently placeholders). A single scrollable form is
fine; if the Figma clearly splits it into steps, match that — the draft accumulates either way.

### `/register/school` — SchoolDetailScreen
Fields, in order: **Date of birth** (date picker) · **Country** (`countriesProvider`) · then branch:
- EG: **Governorate** (`governoratesProvider('EG')`) → **City** (`citiesProvider(EG, governorateId)`) → **School** (searchable, `schoolsProvider`, paginated)
- non-EG: **City** (`citiesProvider(country)`) → **School name** (free text, optional)
· **Stage** (dropdown) · **Education system** (`educationSystemsProvider`) · **Avatar** (grid from `avatarsProvider`, optional) · **Email** (optional).
Submit → build `SchoolRegistration` from the draft → `POST /auth/register`.

### `/register/university` — UniversityDetailScreen
Fields: **Date of birth** · **University** (`universitiesProvider`) → **Faculty** → **Study year**
(active only) · **Governorate** → **City** · **Avatar** (optional) · **Email** (optional).
Submit → build `UniversityRegistration` → `POST /auth/register`.

Both: loading/empty/error/offline on every picker (via `StateWidget`); AR (RTL) + EN; display
`nameAr`/`nameEn` by locale, submit the `id`. Show the token-expiry guard (draft `isExpired`) →
`RegistrationExpiredView`. Avatar = network image (`cached_network_image` — add it).

### Submit handling (a `RegistrationSubmitNotifier`, AsyncNotifier)
- 201 → write tokens, `markAuthenticated()`, go `/home`.
- 400 `validation_failed` → map `errors` field map to per-field inline messages (this is how the
  server reports a geography-conditionality violation too).
- 401 `registration_token_invalid` → localized message, route `/login` (restart).
- 409 `phone_already_registered` → localized message, route `/login`.

---

## The Create-New-Account fix (do this too)

Currently Login's "Create New Account" pushes `/register` token-less → lands on the expiry guard.
Per the contract's **phone-verify-first** rule you cannot register without an OTP first. So:
- "Create New Account" should route into the **same phone→OTP entry** as Login (the fork to
  registration happens at `otp/verify` → `registrationRequired`). Simplest: point it at `/login`
  (or the phone-entry step) rather than `/register`. Remove the token-less `/register` dead-end.

## Files
```
lib/features/registration/
  models/       add school_registration.dart + university_registration.dart (freezed+json, camelCase,
                the discriminated register bodies); extend registration_draft.dart with the Day-3 fields
                (+ setters on the controller: setDob, setSchoolGeography, setSchoolAcademic, setUniversity…)
  repository/   registration_repository.dart (POST /auth/register; typed AppException)
  notifier/     registration_submit_notifier.dart (AsyncNotifier), + any per-form controllers
  screens/      school_detail_screen.dart, university_detail_screen.dart
```
Router: `/register/school` + `/register/university` → the real screens. Login "Create New Account" → `/login`.
Add dep: `cached_network_image` (avatars).

## l10n (add, both .arb)
`dobLabel`, `countryLabel`, `governorateLabel`, `cityLabel`, `schoolLabel`, `schoolNameLabel`,
`stageLabel`, `educationSystemLabel`, `avatarLabel`, `emailOptional`, `universityLabel`, `facultyLabel`,
`studyYearLabel`, `register` (submit), `phoneAlreadyRegistered`, `registrationTokenInvalid`,
stage names (prep1…secondary3), plus any picker empty/error strings.

## Acceptance / tests
- [ ] **Geography conditionality both ways:** EG requires governorate+city+school & forbids schoolName;
      non-EG requires city, allows schoolName, forbids governorate+school — asserted in the model/validation tests.
- [ ] University: only `active` years selectable; `soon` hidden/disabled.
- [ ] Submit builds the correct discriminated body from the draft (school vs university) — `toJson` tests.
- [ ] 201 → tokens stored + `markAuthenticated` + `/home`; 400 field map → per-field errors;
      401 → `/login`; 409 → `/login` (mock Dio).
- [ ] Every picker: loading/error/offline + AR/RTL; expiry guard fires when the draft is expired.
- [ ] name/parentPhone NOT re-collected; referral still never submitted.
- [ ] Create-New-Account no longer dead-ends on the expiry guard.
- [ ] `flutter analyze` clean · `build_runner` ok · full suite green.

## Scope / do NOT
- No home/catalog/quiz screens (placeholders stay). No Paymob. No profile edit.
- Do NOT commit — leave for review.
