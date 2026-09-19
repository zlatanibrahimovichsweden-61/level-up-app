# Day 7c Brief — contract v1.1 reconciliation (adr-028)

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq` · Contract: `contract/openapi.yaml` **pinned `ee2ed8f`
> (v1.1.0-m1)**, vendored 2026-08-03.
> Prereq: Day 7b committed (`f5d6cba`), `dev` clean.
>
> **This is not a feature day and not a design day.** It closes the gap between the vendored
> contract — which was re-pinned to v1.1 during the Day 7 commit and never reconciled — and the
> registration and profile code, which is still built against v1.0.
>
> **Every brief before this one carries a stale header.** Days 00–7b all say
> `contract/openapi.yaml (pinned 23f0535)`. That pin is two versions old. `contract/SOURCE.md` is
> the truth: `ee2ed8f`, vendored 2026-08-03, previous pin `23f0535`. Do not trust a contract
> reference in an older brief.
>
> No new endpoint is consumed. Endpoint coverage stays **21/36**.

> ⚠ **Superseded pin, content still valid (stamped 2026-09-05).** Written against contract pin
> `ee2ed8f` (v1.1.0-m1), 2026-08-05. The contract has since moved to `184d6ec` (`3.0.0-m1`)
> through `61905ce` (v2.1.0-m1) — see `contract/SOURCE.md`. **Unlike Day 7/8/9, none of this
> brief's registration/profile decisions were reversed**: the city union, optional `schoolId`,
> deleted `schoolName`, and the `ProfileCity` sealed union (`docs/DECISIONS.md` D-004) are all
> still exactly how the current contract and shipped code work. Only the `openapi.yaml:NNN` line
> citations throughout have drifted (the file has grown by 163 lines since this brief's pin, 1563 → 1726) —
> treat every citation here as a pointer to re-`grep`, not a trustworthy line number. See
> `docs/WAVE_STATUS.md`.

---

# Why this day exists

`contract/contract-changelog.md`, entry **2026-07-30**, says in its own words:

> **Breaking: yes (stable paths — `/auth/register` request bodies, `GET /me` response shape, two
> new 404s on `stable` reference paths).**

Three of the four breakages are already sitting in `lib/`. One of them can throw at runtime on a
well-formed server response. None of them is caught by the 563-test suite, because every test
asserts the **v1.0** rules — the tests are green *and* wrong, which is the worst configuration to
walk into Day 8 with.

The rule the whole change descends from, quoted from Seif's partner notice:

> **A student is never blocked from registering because a list we control is incomplete.**

---

# Assumptions this brief is built on

Locked with the owner before writing. If any is wrong, **stop and say so** rather than improvising
around it.

1. **The backend is the restricting authority this day.** Where the contract and the approved Figma
   disagree, the contract wins, and where the contract is silent Seif's partner notice wins. This is
   a deliberate reversal of the Day 7b rule hierarchy — see *Rules*, item 1.
2. **No revised Figma frames exist** for the two new registration states. They are specified in this
   brief from Seif's notice and styled from tokens already in the registration screens. This is a
   knowing build-ahead-of-design and gets a `DECISIONS.md` entry.
3. **`geography.city` is modelled as a sealed union**, not as a flat class with optional fields.
   Reason in section D.
4. **`429 rate_limited` gets a typed exception carrying `Retry-After`**, rendered through the
   pickers' existing error state. No countdown widget, no auto-retry.
5. **No new goldens.** The two new registration states have no approved frame to baseline against;
   a golden would freeze a look we invented. Behavioural widget tests instead.
6. **Sections A–F, one commit each**, in order, plus a seventh for the log entries — seven total.
   A–B–D are wire-format and can be verified by tests alone; C is the only one that changes what a
   student sees. The logs go last because S20 and `DESIGN_ISSUES.md` #44 both depend on what
   section 0 turns up.
7. **`RegistrationDraft` is in-memory only** (verified: no Hive/SharedPreferences reference anywhere
   under `lib/features/registration/`). Adding a field needs no migration.
8. **Nothing in this brief touches Day 8.** Profile and Settings *screens* are explicitly out — see
   *Out of scope*.

---

# Rules for this day

1. **The contract wins, then Seif's notice, then the frame.** Day 7b's rule *"do not invent states
   the design does not draw"* is **suspended for this day only**, by owner decision. It was the right
   rule when the design led; the backend leads now. Two states in section C exist in no frame and
   must still be built. Everywhere else — colour, spacing, typography, component choice — the
   existing screens and tokens remain the reference; invent behaviour, not styling.
2. **Delete, don't deprecate.** `schoolName` is gone from the contract, not renamed. Remove the
   field, the widget, the setter, the validation rule, the ARB strings and the tests. A commented-out
   field or a `@Deprecated` marker is a failure of this day.
3. **No new packages.**
4. **No behaviour changes outside registration, profile models and error mapping.** Auth, catalog,
   quiz, routing, Home layout and every Day 7b design fix stay exactly as they are.
5. **Every wire-shape rule lives in the request-body factory, not the screen.** `SchoolRegistration
   .fromDraft` / `UniversityRegistration.fromDraft` already own the adr-010 conditionality
   (`school_registration.dart:56`) — the adr-028 rules join them there. A screen must not be the only
   thing standing between a bad draft and the wire.
6. **Localize both canvases and both locales.** Every new string is an ARB pair. Seif's notice gives
   the Arabic; the English is ours and specified below.
7. **When you find drift this brief does not list, stop and report it** — do not fix it silently.
   Section 0 exists precisely to surface that case.

---

# The spec of record

Two documents, both already in hand. There is no third source and nothing to pull from Figma.

| Document | What it governs | Where |
|---|---|---|
| `contract/openapi.yaml` v1.1.0-m1 | wire shapes, requiredness, error responses | vendored, pinned `ee2ed8f` |
| Seif's partner notice, 2026-07-30 | what the two new registration states must *do* | quoted verbatim in section C |

The notice is addressed to the **UI/UX partner**; our matching notice is the changelog entry. It is
quoted here because it is the only statement of the intended interaction, and because it goes
**further than the contract** in one place: the contract merely makes `schoolId` optional for
everyone, while the notice removes the school step outright for non-Egypt students. Build the
notice's version — it is the stricter and the more recent of the two.

---

# Section 0 — verify the drift (no code, do this first)

Before changing anything, confirm the six items below are still true of `dev`, and **report anything
you find that this brief does not list.** The changelog is Seif's summary of his own change; it is
not a diff, and this brief is built on it.

| # | v1.1 rule | Where the code is wrong | Severity |
|---|---|---|---|
| 1 | `geography.city` is a union — `NamedRef` **or** `{ name }` (`openapi.yaml:1340`) | `student_profile.dart:98` — `required NamedRef city`, and `NamedRef.id` is non-null (`reference_models.dart:25`) | 🔴 throws on a valid `GET /me` |
| 2 | `schoolName` removed from the contract entirely; rejected server-side as an unknown property | `school_registration.dart:43` sends it; `registration_validation.dart:85` has a rule for it; `registration_draft.dart:50`, `registration_controller.dart:120`, `school_picker_field.dart:336-342`, both ARB files | 🔴 registration fails for non-Egypt school students |
| 3 | `cityId` **OR** `cityName`, at least one, never both (`openapi.yaml:1272-1273`, `:1283`) | `cityId` required unconditionally: `school_registration.dart:41`, `university_registration.dart:40`, `registration_validation.dart:78` and `:115`. `cityName` exists nowhere in `lib/` | 🟠 a student with an uncoded city cannot register |
| 4 | `schoolId` optional for **every** school student, Egypt included (`openapi.yaml:1274`) | `registration_validation.dart:84` requires it under `requiresGovernorate` | 🟠 we block a registration the server now accepts |
| 5 | `404 country_not_found` on governorates + cities (`openapi.yaml:443`, `:471`) | unmapped — falls through to `ApiException(status, code)` at `error_interceptor.dart:33` | 🟡 generic message, no crash |
| 6 | `429 rate_limited` + `Retry-After` on all three `/reference/*` (`openapi.yaml:420`, `:446`, `:474`) | unmapped, and `Retry-After` is read nowhere | 🟡 generic message, no crash |

**Also verify and report, do not fix:** v1.1 repaired six corrupted YAML descriptions
(`TokenPair.accessToken`, `SchoolRegistration.email`, `StudentProfile.badges`, `StudentProfile`'s and
`PATCH /me`'s `email`, `QuizQuestion.imageUrl`). We hand-write freezed models rather than generating
from the OpenAPI document, so this should be a **no-op** for us. Confirm that it is. If any of those
five schemas was transcribed into a model from the corrupted text, say so — that is the one place a
description-only fix could have left a real defect.

**Deliverable for this section:** no commit. A written confirmation, plus anything found that is not
in the table.

---

# Section A — request bodies (commit 1)

`lib/features/registration/models/school_registration.dart`,
`lib/features/registration/models/university_registration.dart`,
`lib/features/registration/models/registration_draft.dart`

### A1 · The city union

Add `cityName` to `RegistrationDraft` alongside the existing `cityId` (`registration_draft.dart:48`).
Both bodies gain `String? cityName` and **relax `cityId` from `required String` to `String?`**
(`school_registration.dart:41`, `university_registration.dart:40`).

`fromDraft` enforces the contract rule, exactly as it already enforces adr-010:

- exactly one of `cityId` / `cityName` present → serialize that one, omit the other key entirely
- neither → throw the same way the existing `requireField` helper does
- **both → throw.** The contract says both is `validation_failed`; the body factory must make it
  unreachable rather than let the server catch it.

`@JsonKey(includeIfNull: false)` on both, for the reason already documented at
`school_registration.dart:19-21`: sending `"cityName": null` is sending the key, and an unknown or
mutually-exclusive key is rejected server-side. **Omission and null are not the same thing on this
wire.**

`cityName` is trimmed and length-capped at **100** (`openapi.yaml:1273`). A blank-after-trim value is
treated as absent, never sent as `""`.

### A2 · `schoolName` is deleted

Remove from `RegistrationDraft` (`:50`), from `SchoolRegistration` (`:43`), from the doc comments at
`school_registration.dart:16`, `:21`, `:64-65`, and delete the `freeTextSchool` branch at `:76` and
`:89`. `UniversityRegistration` never had it.

### A3 · `schoolId` is optional everywhere

`schoolId` stays `String?` and is simply serialized when present. `fromDraft` no longer requires it
under any branch. It remains **absent for non-Egypt students** — not because the contract forbids it
(v1.1 doesn't), but because section C removes the step that could produce it, so a non-Egypt draft
carrying a `schoolId` is a bug, and the body factory should treat it as one and throw.

**Commit:** `fix(registration): v1.1 request bodies — cityId|cityName, drop schoolName, optional schoolId`

---

# Section B — validation rules (commit 2)

`lib/features/registration/models/registration_validation.dart`

Add `RegFields.cityName`; delete `RegFields.schoolName` (`:20`).

**School track** (`validateSchoolDraft`, currently `:59-95`) — the whole geography block is rewritten:

| field | v1.0 rule (now wrong) | v1.1 rule |
|---|---|---|
| `cityId` | required always (`:78`) | required **only if** `cityName` absent |
| `cityName` | — | required **only if** `cityId` absent; both present → `forbidden` on `cityName` |
| `schoolId` | required for EG (`:84`), forbidden otherwise (`:88`) | **never required**; still forbidden for non-EG |
| `schoolName` | forbidden for EG (`:85`), free text otherwise | **field deleted** |
| `governorateId` | required for EG, forbidden otherwise | **unchanged** — adr-010 stands, adr-028 does not touch it |

**University track** (`validateUniversityDraft`, `:98-118`) — same city rule. `cityId` at `:115`
becomes the same conditional pair. Nothing else on that track changes; there is still no school
step and still no geography branch.

Update the doc comments at `:48-58` and `:96-97`, which currently state the v1.0 rules as fact.

**Commit:** `fix(registration): v1.1 validation — city union, schoolId never required`

---

# Section C — registration UI (commit 3)

`school_detail_screen.dart`, `university_detail_screen.dart`, `school_picker_field.dart`,
`registration_controller.dart`, both ARB files.

**This is the section with no frame.** Seif's notice is the spec. Quoted verbatim:

> ## 1. City picker needs a "my city isn't listed" path
>
> **Needed:** the picker stays the primary path, but with a visible escape — e.g. a link under the
> field reading *"مدينتي غير موجودة"* — that swaps the dropdown for a plain text field (max 100
> characters).
>
> - Where does the escape link sit so it's findable but doesn't tempt students away from the picker?
>   Most students **should** use the list — the coded value is what we can filter and report on.
> - After the student types a free-text city, can they get back to the picker? (Probably yes — a
>   small *"اختر من القائمة"* link.)
>
> Applies to **both** tracks — school and university registration both collect city.

> ## 2. School picker must be skippable
>
> - **Egyptian school-track students** — pick from the list if their school is there, **or skip and
>   continue.** No free-text alternative: if they can't find it, the field simply stays empty.
> - **Non-Egypt school-track students (UAE / KSA / Oman)** — the school step is **removed entirely**
>   from their flow. Our coded list is Egyptian, so there's nothing for them to choose from and
>   nothing to type.
>
> **Note:** we previously planned to let non-Egypt students type their school name freely. That's now
> cancelled — no free-text school anywhere. If any screen shows a school text input, it should be
> removed.

### C1 · City escape — both tracks

An **in-place swap**, not a new step. The escape link sits directly under the city dropdown, styled
as the existing secondary link in the registration screens — small, not a button, low visual weight.
Seif's first question answers itself: the picker must stay the obvious path.

State lives on the controller, not in the widget, so it survives a rebuild:

- `setCity(String cityId)` — keep, and **clear `cityName`**. It already clears `schoolId`
  (`registration_controller.dart:110`); keep that.
- `setCityName(String? name)` — new. Trims, normalizes blank → null (mirror `setSchoolName` at
  `:120-124`, which is being deleted, so move its normalization logic here rather than reinventing
  it). Clears `cityId` **and** `schoolId`.

Toggling back to the picker clears `cityName`. The two are never both populated in the draft, which
is what makes A1's "both → throw" unreachable in practice.

**Consequence that is easy to miss:** the Egyptian school search is filtered by
`governorateId` + `cityId` (`school_picker_field.dart:65`, `:134`,
`reference_repository.dart:76,86`). A free-text city has no `cityId`, so the school search must fall
back to **governorate-only** filtering. Do not pass a null `cityId` as an empty string, and do not
disable the school picker — an Egyptian student with an uncoded city can still find their school.

Field key `field-cityName`, `maxLength: 100`, keyboard `TextInputType.text`.

### C2 · School step — Egypt only, and skippable

Two changes to `school_detail_screen.dart`:

- **Wrap the entire school block in `if (requiresGovernorate)`**, exactly as the governorate block
  already is at `:163`. Non-Egypt students see no school field of any kind. This is the same
  structural pattern, so it should read as symmetric with the governorate branch, not as a new idea.
- **Delete the free-text branch** — `_schoolNameController` (`:44`, `:53-54`, `:59`, `:157`, `:255`),
  and the `FieldLabel(l10n.schoolNameOptional)` + `TextField` block at
  `school_picker_field.dart:336-342`.

Under the Egyptian coded picker, add the skip affordance. Seif asks whether it should read *"تخطي"*
or *"لم أجد مدرستي"* and does not answer. **Choose "لم أجد مدرستي" / "I can't find my school"**, for
two reasons: his own guidance is that it must read as blameless rather than as a failure, and it
mirrors the city escape one field above, so the student meets the same affordance twice in the same
shape. Log the choice in `DECISIONS.md`.

Skipping clears any previously selected `schoolId` and marks the field visibly resolved — not an
empty field the student will read as unfinished. Selecting a school afterwards un-skips.

### C3 · Strings

Four new ARB pairs; two deleted (`schoolNameOptional`, `schoolNameHint` — declared at
`lib/l10n/app_localizations.dart:495` and `:501`, implemented at
`lib/l10n/app_localizations_en.dart:216,219` and `lib/l10n/app_localizations_ar.dart:216,219`).
Edit the `.arb` files and regenerate; do not hand-edit the generated `app_localizations*.dart`.

| key | AR (Seif's copy) | EN (ours) |
|---|---|---|
| `cityNotListed` | مدينتي غير موجودة | My city isn't listed |
| `chooseFromList` | اختر من القائمة | Choose from the list |
| `cityNameLabel` | اسم المدينة | City name |
| `schoolNotFound` | لم أجد مدرستي | I can't find my school |

Verify in **AR (RTL) and EN, light and dark** — the standard four combinations. The escape link is
inline text under a field; RTL alignment is the failure mode to check.

**Commit:** `feat(registration): free-text city escape and skippable/removed school step (adr-028)`

---

# Section D — `StudentProfile` model (commit 4)

`lib/features/profile/models/student_profile.dart`

**This is the one that can throw**, and it is the cheapest it will ever be to fix.
`ProfileGeography.city` currently has **zero call sites** anywhere in `lib/` — nothing renders it
yet. Day 8 is the day that changes. Fixing the shape now costs a model and a parser; fixing it after
Day 8 costs every screen that consumed it.

### D1 · `ProfileCity` as a sealed union

Contract (`openapi.yaml:1340`):

> Union (adr-028 §1): a `NamedRef` (has `id`) when the student picked a coded city, or `{ name }`
> free text when they used the "my city isn't listed" fallback. **Always present** — every student
> has a city, one way or the other.

```dart
@freezed
sealed class ProfileCity with _$ProfileCity {
  /// The student picked from `/reference/cities` — has an id and both locales.
  const factory ProfileCity.coded(NamedRef ref) = CodedCity;

  /// The adr-028 §1 fallback — a plain string, no id, no localization.
  const factory ProfileCity.freeText(String name) = FreeTextCity;

  /// Discriminated on the PRESENCE OF `id`, per the contract's own wording
  /// ("a NamedRef (has `id`)"). There is no discriminator field on the wire.
  factory ProfileCity.fromJson(Map<String, dynamic> json) =>
      json.containsKey('id')
          ? ProfileCity.coded(NamedRef.fromJson(json))
          : ProfileCity.freeText(json['name'] as String);
}
```

`ProfileGeography.city` becomes `required ProfileCity city` (still required — the contract keeps it
in `required: [countryCode, city]` at `:1349`).

A sealed union rather than a flat class with optional fields, because the failure being fixed *is* a
call site assuming structure that isn't there. With `switch` exhaustiveness the compiler refuses to
let a screen forget the free-text case; with optional fields it compiles and throws at runtime, which
is precisely where we are today. It also matches the repo's existing sealed `ScreenState` idiom, so
it is not a new pattern for anyone to learn.

**Do not add a display-name getter to the union.** Localization is a presentation concern and picking
`nameAr`/`nameEn` requires the current locale; that belongs at the call site, in Day 8, where a
`switch` will force the decision to be made explicitly.

**Leave `NamedRef` alone.** All seven reference pickers legitimately always have an id; weakening it
to serve one union would push nullability into six places that don't need it.

### D2 · `ProfileSchool.schoolName` is deleted

`student_profile.dart:116`. Removed from the contract (`openapi.yaml:1354` — only
`school`/`stage`/`educationSystem` remain, `school` nullable). Delete the field and correct the doc
comment at `:112-115`, which describes the v1.0 Egypt/non-Egypt split as if it still exists.

`ProfileSchool.school` was already nullable, so **no change is needed for a skipped school** — that
part of v1.1 we happen to already satisfy. Say so in the commit body; it is worth knowing which of
these were luck.

### D3 · Regenerate and prove the parse

`dart run build_runner build --delete-conflicting-outputs`, then update
`test/features/profile/profile_fixtures.dart:36` (currently emits `schoolName: null`).

**Commit:** `fix(profile): city union per adr-028, drop removed schoolName field`

---

# Section E — error mapping (commit 5)

`lib/core/network/exceptions.dart`, `lib/core/network/interceptors/error_interceptor.dart`

Neither code string exists anywhere in `lib/` today. Both currently fall through to the default arm
at `error_interceptor.dart:33` and surface as a generic error — no crash, wrong message.

### E1 · `429 rate_limited` + `Retry-After`

```dart
/// 429 — the unauthenticated per-IP limit on `/reference/*`. Deliberately NOT
/// `otp_throttled`: that code is OTP-specific and would make a geography lookup
/// show an OTP message (error-codes.md, `rate_limited` row).
class RateLimitedException extends ApiException {
  const RateLimitedException({this.retryAfter, super.detail})
      : super(status: 429, code: 'rate_limited');

  /// Parsed from the `Retry-After` header. Null if absent or unparseable —
  /// the header is not guaranteed, so no call site may assume a duration.
  final Duration? retryAfter;
}
```

Parse `Retry-After` **defensively**, the same way `_fieldMap` handles a malformed `errors` map: a
missing, non-numeric or HTTP-date-formatted value yields `null`, never a throw. Support the
delta-seconds form only; if a date form arrives, return null rather than guessing a clock skew.

### E2 · `404 country_not_found`

A plain `ApiException` with the right code — no new subclass. Seif's notice, section 3:

> If a country code isn't recognised, the API now returns a proper error rather than an empty list.
> Practically this shouldn't ever be visible to a student (they pick from a list), but if you have a
> generic error state for the geography steps, it stays as-is.

So: **map the code so it isn't `unknown`, render nothing new.** The pickers' existing error state
stands. The contract's 400-vs-404 split is worth internalizing while you are here and does not
change any code: a *malformed* `countryCode` (`EGY`, `1`, empty) is `400 validation_failed`; a
*well-formed but unrecognised* one (`XX`) is `404 country_not_found`. Codes normalize
case-insensitively, so `eg` is accepted.

### E3 · Rendering

`rate_limited` gets one ARB pair — `rateLimited`: *"طلبات كثيرة. حاول مرة أخرى بعد قليل."* /
*"Too many requests. Please try again shortly."* — shown in the reference pickers' existing error
state with the existing Retry button. **No countdown, no gating, no auto-retry.** When `retryAfter`
is non-null it may be interpolated into the message; when null the message stands alone. The
duration is carried so a later day *can* build a countdown without re-plumbing the interceptor —
that is the only reason it is parsed now.

**Commit:** `feat(network): map rate_limited (429) and country_not_found (404)`

---

# Section F — mock backend (commit 6)

`lib/dev/mock_backend.dart`

The harness currently validates the **v1.0** shapes, which means a device walkthrough would confirm
the old contract and hide every fix above. It is the only place any of this can be exercised
end-to-end — per `seif_fight.md` **S1**, we have still never made a single real request, and
`baseUrl` is still `TBD.example`.

- `:1131` — stop echoing `schoolName`; **reject the key** if present, as `400 validation_failed`,
  the way the real server now will. The mock's job is to be strict where the server is strict.
- `:1166` — drop `'schoolName': null` from the school profile fixture (the only other site; verified
  `grep -n "'schoolName'"` returns exactly `:1131` and `:1166`).
- `:1227` — `city` must be able to emit **both** union arms. Echo `cityName` back as
  `{ "name": ... }` when the registration used it, and the coded `_named(...)` when it used `cityId`.
  A free-text registration whose profile comes back coded proves nothing.
- `:142` `POST /auth/register` — enforce the adr-028 rules: exactly one of `cityId`/`cityName`
  (neither or both → `validation_failed`), `schoolId` accepted-or-absent for Egypt, rejected for
  non-Egypt.
- `:259` `/reference/cities` and `:266` `/reference/schools` — add a **triggerable** `429
  rate_limited` with a `Retry-After` header, and a `404 country_not_found` for an unrecognised
  `countryCode` on cities and governorates. Follow whatever trigger convention the file already uses
  for its error paths (the Day 7 quiz mock covers "every error path" — match that style rather than
  inventing a second one).

Walk the four combinations on a device afterwards if a device is available: Egypt coded city + coded
school · Egypt free-text city + skipped school · non-Egypt free-text city (no school step at all) ·
university free-text city.

**Commit:** `chore(mock): v1.1 shapes — city union, no schoolName, 429/404 paths`

---

# Tests

Rewrite to the v1.1 rules — do not add v1.1 cases alongside the v1.0 ones. **Every assertion below
currently passes and is wrong.** If a rewritten test passes without you having changed the
implementation, that test was not testing what its name claims.

**Rewrite:**

| file | what is asserting the dead rule |
|---|---|
| `test/features/registration/register_body_test.dart` | `:108`, `:115` schoolName absent for EG · `:132` schoolName sent for non-EG · `:147-156` blank/trim behaviour · `:277` "Egypt FORBIDS schoolName" · `:296` non-Egypt allows omitted schoolName |
| `test/features/registration/registration_controller_test.dart` | `:185`, `:216-226` schoolName normalization |
| `test/features/registration/registration_submit_notifier_test.dart` | `:159`, `:200`, `:212-222`, `:336` |
| `test/features/registration/school_detail_screen_test.dart` | `:147`, `:163` — presence/absence of `field-schoolName` |
| `test/features/registration/registration_repository_test.dart` | `:149`, `:159` |
| `test/core/network/error_interceptor_test.dart` | `:48`, `:57` — uses `schoolName` as a sample rejected field; swap for a field that still exists |
| `test/features/profile/profile_fixtures.dart` | `:36` |

**New:**

- `ProfileCity` parse — coded arm, free-text arm, and a `switch` proving exhaustiveness. Plus a
  `StudentProfile` parse with `school: null` and one with `school.school: null` (skipped school).
- City union body rules — `cityId` only, `cityName` only, neither (throws), both (throws), trimmed,
  100-char cap, blank → absent.
- `schoolId` accepted-or-absent for Egypt; still forbidden non-Egypt.
- Widget: the city escape toggles the dropdown for a text field and back, and the controller state
  follows (each choice clears the other, and both clear `schoolId`).
- Widget: the school block is **absent** for a non-Egypt country, and present-and-skippable for Egypt.
- Widget: free-text city still permits a school search, filtered by governorate alone.
- `RateLimitedException` — parsed `Retry-After`, absent header, and a garbage header (all three, and
  the last two must not throw).
- `country_not_found` maps to `ApiException` with that code, not `unknown`.

**No new goldens** (assumption 5). Run `flutter analyze` clean and the full suite green before each
commit, not only at the end.

---

# Log entries this day must write

**`seif_fight.md` — new S20 · `PATCH /me` cannot edit school or geography.** Seif's notice asks the
designer *"How does the profile screen render a student with no school? Blank row, hidden row, or an
'أضف مدرستك' prompt?"* — but `PATCH /me` accepts only `name`, `email`, `avatarId`,
`leaderboardVisible`, `scoreHidden` (`openapi.yaml:614-624`). School and geography are **immutable
after registration** in v1.1. One of the three options he is offering the designer is therefore not
implementable, and if the designer picks it we will be asked to build a prompt with no endpoint
behind it. Ask now, before the design revision, not after. Two questions: is post-registration school
selection intended, and if so does `PATCH /me` gain the field or does a separate endpoint appear?

**`DECISIONS.md` — three entries:**

- **Build-ahead-of-design for the two new registration states.** Day 7b's "do not invent states"
  rule suspended by owner decision; the backend is the restricting authority; Seif's notice is the
  spec of record. Revisit when the design revision lands — the states are then re-verified against
  the frames, not rebuilt.
- **`ProfileCity` as a sealed union.** Options considered: sealed union, flat class with optional
  fields, relaxing `NamedRef`. Chosen for compiler-enforced exhaustiveness at call sites that do not
  exist yet.
- **"لم أجد مدرستي" over "تخطي"** for the school skip. Seif left the choice open; blameless framing
  and symmetry with the city escape one field above.

**`DESIGN_ISSUES.md` — new #44 · the approved Figma has no path for either new state.** Both
registration flows are now, by design, reachable in a configuration the frames do not draw. Record
what was built and from what source, so the design revision is a comparison rather than a discovery.
Cross-reference Seif's three unanswered design questions (escape-link placement, how the profile
screen renders a free-text city, how it renders a missing school) — the last two are **Day 8's
problem and are not answered anywhere yet**.

Also correct the stale `contract/openapi.yaml (pinned 23f0535)` line in the Day 00–7b brief headers,
or add a one-line note to `PROGRESS.md` stating that pin references in briefs predating this one are
stale and `contract/SOURCE.md` is authoritative. The second is cheaper and less error-prone.

---

# Definition of done

- [ ] Section 0 confirmation written, including anything found beyond the six-row table.
- [ ] `schoolName` returns **zero** results across `lib/` and `test/` (`grep -rn schoolName`) — model,
      widget, setter, ARB, tests, mock. Zero, not "only in comments".
- [ ] `cityName` is round-trippable end to end: typed on the screen → in the draft → on the wire →
      parsed back from `GET /me` as `ProfileCity.freeText`.
- [ ] A non-Egypt school-track student sees **no school field of any kind**.
- [ ] An Egyptian school-track student can complete registration **without** selecting a school.
- [ ] `GET /me` parses both city arms and a null `school` block.
- [ ] `rate_limited` and `country_not_found` are mapped; `Retry-After` parses or safely yields null.
- [ ] Mock backend rejects `schoolName` and both-cities the way the server will.
- [ ] `flutter analyze` clean; full suite green; seven commits — one per section, plus the logs.
- [ ] Existing goldens still pass untouched. A broken golden means a surface changed that this day
      did not ask you to change.
- [ ] S20, three `DECISIONS.md` entries and `DESIGN_ISSUES.md` #44 written.
- [ ] `PROGRESS.md` gains a Day 7c section and the brief index gains this file.

---

# Out of scope — do not build

**Nothing from Day 8.** No Profile screen, no Settings screen, no `PATCH /me` consumption, no
avatar UI, no privacy toggles, no account recovery, no subscription or code-redemption surface. This
day changes models, request bodies, validation, two registration affordances and error mapping —
nothing that renders profile data. `lib/features/profile/screens/` stays a `.gitkeep`, and
`/profile`, `/settings`, `/subscription` stay `_Placeholder`.

Also out:

- `PUT /me/avatar` and `PUT /me/fcm-token` — still `x-stability: draft`. Not consumed, unchanged.
- The `/track-select` orphan route at `app_router.dart:121` — still out of scope, as in Day 7b.
- Any Day 7b design item left deliberately open: the track card's selected state, the level medallion
  (#43), `cardFill` light `#FDFDFD` vs `#FCFBF9`, the language pill's wording.
- The 2026-07-06 design-audit gaps Seif re-flags in his notice — monetization UI, code redemption,
  account recovery, flashcards, quiz history. All missing from the design, none of them this day's
  problem. Worth knowing that three of them sit next to Day 8's surface.
- Re-vendoring the contract. `ee2ed8f` is already in the repo and is what this day reconciles to.
  Do not pull a newer commit mid-day; if one exists, finish against `ee2ed8f` and report it.
