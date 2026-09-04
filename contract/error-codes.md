# Error-code registry (ADR-026 §5)

Stable machine codes carried in ProblemDetails `code`. The Flutter app maps each code to AR/EN copy; server `title`/`detail` are developer-facing English and never shown to users. **Rules:** snake_case; append-only (never rename/reuse a shipped code); every new code lands here in the same PR as the spec's Contracts section — never invented inline in code.

**Not-found codes are per-resource (adr-028 §3):** the generic `not_found` stays for opaque resource ids (e.g. an unknown quiz id), but reference-data lookups get a specific code — `country_not_found`, and by the same pattern `governorate_not_found`, `city_not_found`, `school_not_found`… as those lookups land — so the client renders a specific message instead of a generic one. A single `resource_not_found` + `resource` field was considered and rejected: it defeats client-side localization from `code` (adr-026 §5), which is the reason `code` exists at all.

| Code | HTTP | Meaning | Notes |
|---|---|---|---|
| `validation_failed` | 400 | Request shape/fields invalid | Field detail in `errors` map |
| `otp_invalid` | 400 | Wrong OTP code | |
| `otp_expired` | 400 | OTP window elapsed | |
| `otp_throttled` | 429 | OTP request/verify rate limit hit | adr-019 flood protection |
| `session_superseded` | 401 | Logged in on another device — this session was evicted | Device binding (adr-019); app shows forced-logout flow |
| `subscription_required` | 403 | Content requires `baseSubscription` | |
| `flashcard_subscription_required` | 403 | Flashcards require `flashcardSubscription` | University-only |
| `image_rejected_by_moderation` | 422 | SafeSearch rejected the upload | Avatar, chat photo, camera capture (adr-021) |
| `code_already_redeemed` | 409 | Subscription code used | adr-016 single-use |
| `insufficient_scope` | 403 | Authenticated but role/track forbids this | Generic BOLA guard; also: explanation before answering |
| `authentication_required` | 401 | Missing/expired access token | Client runs refresh flow, retries once (contract v1, 2026-07-19) |
| `not_found` | 404 | Resource id unknown | Generic — opaque resource ids only; reference-data lookups use a per-resource code instead (see above) |
| `country_not_found` | 404 | `countryCode` in the path/query isn't in the coded country list | adr-028 §3 — first application of the per-resource not-found convention; `/reference/countries/{countryCode}/governorates`, `/reference/cities` |
| `rate_limited` | 429 | Generic request rate limit hit (not OTP) | Unauthenticated `/reference/*` IP limit and any future non-OTP limiter. Distinct from `otp_throttled` on purpose — that code is OTP-specific and would make the client show an OTP message for a lookup. Honour `Retry-After` |
| `internal_error` | 500 | Unhandled server error | `traceId` is the support handle |
| `registration_token_invalid` | 401 | registrationToken/rebindToken expired, consumed, or wrong device | Restart the flow from the top |
| `refresh_token_invalid` | 401 | Refresh expired, revoked, or REUSED (reuse revokes the whole chain) | Full re-login (adr-019 reuse detection) |
| `phone_already_registered` | 409 | Phone belongs to an existing account | Register/recovery new-phone paths |
| `recovery_unavailable` | 404 | No recoverable account/parent number for this phone | ONE code for both cases (anti-enumeration); app routes to support path |
| `code_invalid` | 404 | Subscription code unknown | Distinct from `code_already_redeemed` |
| `weekly_question_limit_reached` | 403 | Free-plan 50 questions/week exhausted | Expected free-plan state, not a fault — the allowance resets at the start of the next week (requirements §3) |
| `not_enough_questions` | 422 | Scope pool smaller than requested quiz length | Normal mode only |
| `quiz_already_finished` | 409 | Answer submitted after finish | Finish itself is idempotent (returns summary) |
| `governorate_not_found` | 404 | `governorateId` isn't in the coded governorate list | adr-028 §3 per-resource not-found; `GET /reference/schools` |
| `city_not_found` | 404 | `cityId` isn't in the coded city list | adr-028 §3 per-resource not-found; `GET /reference/schools` |
| `school_not_found` | 404 | `schoolId` isn't in the coded school list | adr-028 §3 per-resource not-found; registration (spec-002) |
| `university_not_found` | 404 | `universityId` isn't in the coded university list | adr-028 §3 per-resource not-found; registration + study-year validation (spec-002) |
| `faculty_not_found` | 404 | `facultyId` isn't a faculty of the given university | adr-028 §3 per-resource not-found; registration + study-year validation (spec-002) |
| `study_year_not_found` | 404 | `studyYearId` isn't a study year of the given faculty | adr-028 §3 per-resource not-found; registration + study-year validation (spec-002) |
| `education_system_not_found` | 404 | `educationSystem` isn't a recognised education-system `code` | adr-028 §3 per-resource not-found; registration (spec-002) |
| `avatar_not_found` | 404 | `avatarId` isn't in the default avatar list | adr-028 §3 per-resource not-found; registration (spec-002) |

Reserved (add rows as specs land): track-transfer eligibility, chat block/report outcomes.
