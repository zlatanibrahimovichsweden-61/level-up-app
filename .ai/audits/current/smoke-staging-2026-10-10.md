# Staging smoke — 2026-10-10 (support tickets + name filter)

Run for the CW12a follow-up ("NEXT STEP — FINALIZE CW12a COPY, VERIFY STAGING READINESS, AND CLOSE REMAINING
GAPS", 2026-10-10). It answers two questions: are the five text support-ticket operations live on staging, and does
staging already enforce the 3.47.0-m1 name filter (`422 name_not_allowed`)? Previous run: `smoke-staging-2026-09-22.md`.

| | |
| --- | --- |
| Harness | a scratch probe in a throwaway copy of the working tree (never in the repo), built on the same seam and the same sign-in as `tool/smoke/real_api_smoke_test.dart` |
| Account | the documented whitelisted staging test number and its fixed code (see `smoke-staging-2026-09-22.md`); not repeated here |
| Base URL | `https://level-up-backend-staging.up.railway.app/api/v1` |
| Backend | `/health/version`: commit `1f4f0a8a2dfd1d329686b944905aaf0d8c2d3064`, Staging, built **2026-10-10T05:01:43Z** |
| App tree | branch `merged`, HEAD `b227f61` + the uncommitted N-26 / CW02 / CW07a / CW12a / O-15 changes (byte-identical to the 2963/0/0 gate) |
| Ran | 2026-10-10T12:03:16Z – 12:03:54Z, `flutter test --no-pub`, exit **0** |
| Level | **API**: real requests through `AppConfig → DioClient → interceptors → SupportRepository / ProfileRepository → freezed`. Only `SecureStorage` is stubbed. **Not DEVICE, not CI, not a UI walk.** |
| Logged | statuses, codes, counts, booleans only. No token, phone number, name, subject, body, reference, id or cursor. |

## Unauthenticated route probe (curl, before sign-in)

| Request | Answer |
| --- | --- |
| `GET /support/tickets` | `401 authentication_required` |
| `POST /support/tickets` | `401 authentication_required` |
| `GET /support/tickets/{uuid}` | `401 authentication_required` |
| `GET /support/tickets/{uuid}/messages` | `401 authentication_required` |
| `POST /support/tickets/{uuid}/messages` | `401 authentication_required` |
| control: `GET /definitely-not-a-route` | `404 not_found` |
| `GET /app/version-policy` (3.47.0-m1 `getAppVersionPolicy`, anonymous) | `200`, every value `null` (no prompt) |

The 401s only show that the routes are routed. The signed-in run below is what shows the operations work.

## Signed-in run

```
--- sign-in ---
  otp/request: OK
  otp/verify: AuthenticatedResult
--- 1 listMySupportTickets (first page) ---
  GET /support/tickets: OK
  items=0 hasMore=false nextCursor=null
--- not-found arms ---
  GET ticket (unknown uuid): ApiException(status=404, code=not_found)
  GET ticket (malformed id): ApiException(status=404, code=not_found)
  GET messages (unknown uuid): ApiException(status=404, code=not_found)
  POST reply (unknown uuid): ApiException(status=404, code=not_found)
--- 4 createSupportTicket (1 write) ---
  POST /support/tickets: OK
  status=open reference TK-<digits>: true closedAt=null
--- 5 postMySupportTicketMessage (1 write) ---
  POST /support/tickets/{id}/messages: OK
  authorKind=student
  GET /support/tickets (after create): OK
  new ticket listed first: true
  GET messages (after reply): OK
  items=1 authorKinds={student: 1}
  GET ticket (after reply): OK
  status still=open
--- name filter: PATCH /me ---
  GET /me: OK
  PATCH /me same stored name (control, never refused): OK
  PATCH /me name containing the probe term: ApiException(status=422, code=name_not_allowed)
  GET /me (after): OK
  name equals original: true
--- logout ---
  POST /auth/logout: OK
```

The probe term was one common English profanity; it is not recorded here.

## What this proves, and what it does not

| Claim | Level | Result |
| --- | --- | --- |
| `listMySupportTickets` live, decodes as `CursorPage<SupportTicketSummary>` | API | **yes** (an empty page, then a one-row page) |
| `getMySupportTicket` live, decodes as `SupportTicket` | API | **yes** |
| `listMySupportTicketMessages` live, decodes | API | **yes** (0 then 1 message, `authorKind` `student`) |
| `createSupportTicket` live: `open`, `TK-<digits>` reference, `closedAt` null | API | **yes** |
| `postMySupportTicketMessage` live; a reply does not change the status | API | **yes** |
| Unknown or malformed ticket id → `404 not_found` (get, messages, reply) | API | **yes** |
| **Another student's** ticket → `404` (isolation) | — | **not tested**: needs a second account (SQ-15) |
| A staff reply; `in_progress`, `pending` or `closed` tickets | — | **not observed**: the account had no seeded tickets (SQ-15) |
| `ticket_closed` (409) on a reply | — | **not observed**: no closed ticket |
| `429 rate_limited` + `Retry-After` on create (5/day) or reply (60/h) | — | **not tested on purpose**: it would take 6 creates or 61 replies |
| Staging enforces `name_not_allowed` on `updateMyProfile` | API | **yes**: 422, nothing changed; a PATCH re-sending the stored name is not refused |
| Staging enforces `name_not_allowed` on `completeRegistration` | — | **not tested**: it needs an unregistered number, and an unenforced filter would create an account |
| The app shows a useful message for it | — | the app's network layer turns it into a generic `ApiException(422, name_not_allowed)`; what the screens show is BUILD-reproduced in `completion/CW12a_FOLLOWUP_REPORT.md` §13 |

## Data left on staging

One test ticket on the test account: subject "Mobile app staging check - please ignore", one student reply
"Automated reply check - please ignore.", status `open`. A student cannot close a ticket, so it stays open until
Customer Service closes it; the Seif addendum asks for that (it would also give the account its first `closed`
ticket). The account's name is unchanged.
