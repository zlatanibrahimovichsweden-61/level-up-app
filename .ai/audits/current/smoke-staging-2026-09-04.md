# Live-staging smoke run — 2026-09-04

Produced by `flutter test tool/smoke/real_api_smoke_test.dart --dart-define=SMOKE_PHONE=+2010000000001`
on the dev host (Windows, Flutter 3.44.7), branch `merged`, harness `b17b7de` (unchanged since the
2026-08-23 run). Staging backend: `78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1`, built
2026-09-03T15:38:17Z. The number was already registered on staging — no account was created; one
OTP request and one verify. Status + `code` only; bodies are never logged (they carry minors' data).

Run against the tree at `9798dfa` (before the contract re-pin) — the client was still on the
2.1.0-m1 `QuizSummary`, which does not matter here because `finish` was not reached.

**Verification level:** BUILD plus a live-staging run from the dev host — not DEVICE, not CI.
Interpretation: `docs/WAVE_STATUS.md` §"Live staging", `docs/RISKS.md` R-8, `docs/seif_fight.md` S37.

## Verdict — all 21 `x-stability: stable` operations

| Verdict | Count | Operations |
| --- | --- | --- |
| **Decoded** | 13 | the 7 `/reference/*` reads (countries, governorates, cities incl. the deliberate EG-without-governorate 400 → typed `ValidationException[governorateId]`, education-systems, avatars, schools, universities), `POST /auth/otp/request`, `POST /auth/otp/verify` → `AuthenticatedResult`, `GET /me` → `StudentProfile` (track: school), **`GET /catalog/subjects` → `200` with `[]`** (NEW since 08-23 — the route is deployed; an empty list is a contract-legal state for an account with no released subjects), `POST /auth/refresh` (rotation), `POST /auth/logout` |
| **Typed server state** | 2 | `PATCH /me` → **405** `internal_error` (unchanged since 08-23); `GET /me/entitlements` → **404** `not_found` (unchanged) — `seif_fight.md` S37 |
| **Not reachable** | 6 | `POST /auth/register` (number already registered; arm skipped), `GET /catalog/subjects/{id}/tree`, `POST /quizzes`, `POST /quizzes/{id}/answers`, `POST /quizzes/{id}/finish`, `GET /questions/{id}/explanation` — the quiz loop is gated on a non-empty catalog for the test account |

Change from 2026-08-23: 12 → 13 decoded, 3 → 2 typed server states, 6 → 6 unreachable. What
would prove adr-102 on staging — a `finish` body without `totalPoints`/`level` — is still
unobserved. Nothing of the F-7-01 class leaked.

Unauthenticated route probes the same morning (`curl`, status + `code` only), for the record:
`GET /catalog/subjects` 401 `authentication_required` · `GET /me` 401 · `POST /quizzes` 401 ·
`GET /quizzes` 405 `internal_error` · `PATCH /me` 405 `internal_error` · `GET /me/entitlements`
404 `not_found` · `POST /checkout/sessions` 404 `not_found` (the path is gone from the contract
too) · `/health/ready` 200.

## Output (verbatim)

```text
00:00 +0: loading F:/level/level_up/level_up_app/tool/smoke/real_api_smoke_test.dart
00:00 +0: (setUpAll)
BASE URL = https://level-up-backend-staging.up.railway.app/api/v1
00:00 +0: GET /health/version — which backend commit is deployed

--- health/version ---
  status: 200
  body: {commit: 78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1, environment: Staging, builtAtUtc: 2026-09-03T15:38:17Z}
00:00 +1: reference/countries

--- countries  (GET /reference/countries) ---
  status: 200
  shape: array[4] first-keys={code,nameAr,nameEn,requiresGovernorate}
  decode: OK -> List<Country>
  count: 4
  exception: none
00:01 +2: reference/governorates (EG)

--- governorates  (GET /reference/countries/EG/governorates) ---
  status: 200
  shape: array[27] first-keys={id,nameAr,nameEn}
  decode: OK -> List<NamedRef>
  count: 27
  exception: none
00:01 +3: reference/cities (EG + governorateId)

--- cities  (GET /reference/cities) ---
  status: 200
  shape: array[42] first-keys={id,nameAr,nameEn}
  decode: OK -> List<NamedRef>
  count: 42
  exception: none
00:01 +4: reference/cities — EG WITHOUT governorateId is a typed 400

--- cities (EG, no governorateId — expected 400) ---
  status: 400
  code: validation_failed
  decode: OK -> ValidationException
  fields: [governorateId]
00:01 +5: reference/education-systems

--- education-systems  (GET /reference/education-systems) ---
  status: 200
  shape: array[5] first-keys={code,nameAr,nameEn}
  decode: OK -> List<EducationSystemRef>
  count: 5
  exception: none
00:02 +6: reference/avatars

--- avatars  (GET /reference/avatars) ---
  status: 200
  shape: array[20] first-keys={id,url}
  decode: OK -> List<Avatar>
  count: 20
  exception: none
00:02 +7: reference/schools (cursor page)

--- schools  (GET /reference/schools) ---
  status: 200
  shape: object{items,nextCursor,hasMore}
  decode: OK -> _CursorPage<NamedRef>
  items: 0
  hasMore: false
  nextCursor: null
  exception: none
00:02 +8: reference/universities

--- universities  (GET /reference/universities) ---
  status: 200
  shape: array[1] first-keys={id,nameAr,nameEn,faculties}
  decode: OK -> List<UniversityRef>
  count: 1
  exception: none
00:02 +9: auth: OTP request + verify + registration body

--- auth (phone=+2010000000001) ---
  otp/request: OK — decoded _OtpRequestResult
    resendAfterSeconds: 60
    expiresInSeconds: 300
  otp/verify: AuthenticatedResult — tokens + profile decoded
  discriminator: authenticated
00:02 +10: authenticated surface: me → entitlements → catalog → quiz → refresh → logout

--- GET /me ---
  decode: OK — StudentProfile
  track: Track.school

--- PATCH /me (no-op: same name — parse + roundtrip only) ---
  PATCH /me: typed ApiException(code=internal_error status=405) — reported, not failed

--- GET /me/entitlements ---
  GET /me/entitlements: typed ApiException(code=not_found status=404) — reported, not failed

--- GET /catalog/subjects ---
  count: 0
  empty: contract-legal (v2.1: pre-term accounts) — quiz loop skipped

--- POST /auth/refresh (rotation) ---
  decode: OK — TokenPair rotated

--- POST /auth/logout ---
  logout: OK (204, or already revoked)
00:03 +11: (tearDownAll)
00:03 +11: All tests passed!

```
