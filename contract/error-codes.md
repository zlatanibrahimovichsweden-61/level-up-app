# Error-code registry (ADR-026 §5)

Stable machine codes carried in ProblemDetails `code`. The Flutter app maps each code to AR/EN copy; server `title`/`detail` are developer-facing English and never shown to users. **Rules:** snake_case; append-only (never rename/reuse a shipped code); every new code lands here in the same PR as the spec's Contracts section — never invented inline in code.

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
| `insufficient_scope` | 403 | Authenticated but role/track forbids this | Generic BOLA guard; also: explanation before answering, flashcard checkout for school student |
| `authentication_required` | 401 | Missing/expired access token | Client runs refresh flow, retries once (contract v1, 2026-07-19) |
| `not_found` | 404 | Resource id unknown | Generic |
| `internal_error` | 500 | Unhandled server error | `traceId` is the support handle |
| `registration_token_invalid` | 401 | registrationToken/rebindToken expired, consumed, or wrong device | Restart the flow from the top |
| `refresh_token_invalid` | 401 | Refresh expired, revoked, or REUSED (reuse revokes the whole chain) | Full re-login (adr-019 reuse detection) |
| `phone_already_registered` | 409 | Phone belongs to an existing account | Register/recovery new-phone paths |
| `recovery_unavailable` | 404 | No recoverable account/parent number for this phone | ONE code for both cases (anti-enumeration); app routes to support path |
| `payment_initiation_failed` | 502 | Paymob checkout session could not be created | Client offers retry |
| `code_invalid` | 404 | Subscription code unknown | Distinct from `code_already_redeemed` |
| `weekly_question_limit_reached` | 403 | Free-plan 50 questions/week exhausted | Paywall prompt (requirements §3) |
| `not_enough_questions` | 422 | Scope pool smaller than requested quiz length | Normal mode only |
| `quiz_already_finished` | 409 | Answer submitted after finish | Finish itself is idempotent (returns summary) |

Reserved (add rows as specs land): track-transfer eligibility, chat block/report outcomes.
