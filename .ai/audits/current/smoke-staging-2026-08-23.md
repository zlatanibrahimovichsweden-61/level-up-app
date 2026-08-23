# Live-staging smoke run — 2026-08-23

Produced by `flutter test tool/smoke/real_api_smoke_test.dart --dart-define=SMOKE_PHONE=+2010000000001`
on the dev host (Windows, Flutter 3.44.7), branch `merged`. Staging backend:
`0b53cdcad20cc0029fea0f18ef2e62a980b48aca`, built 2026-08-23T10:53:37Z. The number was already
registered on staging — no account was created; one OTP request and one verify per run.

Three runs. Run 1 (harness `dcd655b`) stopped at `PATCH /me` because the harness only tolerated
typed server states inside the quiz loop. Runs 2 and 3 (harness `b17b7de`) apply that rule to every
authenticated op and give all 21 stable operations a verdict; their output is identical. Run 3 is
reproduced verbatim below; run 1's tail is transcribed from the session screen because its file
capture failed.

**Verification level:** BUILD plus a live-staging run from the dev host — not DEVICE, not CI.
Interpretation: `docs/WAVE_STATUS.md` §"Live staging", `docs/RISKS.md` R-8, `docs/seif_fight.md` S37.

## Run 3 — harness `b17b7de` (complete, verbatim)

```text
00:00 +0: loading F:/level/level_up/level_up_app/tool/smoke/real_api_smoke_test.dart
00:00 +0: (setUpAll)
BASE URL = https://level-up-backend-staging.up.railway.app/api/v1
00:00 +0: GET /health/version — which backend commit is deployed
--- health/version ---
  status: 200
  body: {commit: 0b53cdcad20cc0029fea0f18ef2e62a980b48aca, environment: Staging, builtAtUtc: 2026-08-23T10:53:37Z}
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
00:02 +4: reference/cities — EG WITHOUT governorateId is a typed 400
--- cities (EG, no governorateId — expected 400) ---
  status: 400
  code: validation_failed
  decode: OK -> ValidationException
  fields: [governorateId]
00:02 +5: reference/education-systems
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
00:03 +7: reference/schools (cursor page)
--- schools  (GET /reference/schools) ---
  status: 200
  shape: object{items,nextCursor,hasMore}
  decode: OK -> _CursorPage<NamedRef>
  items: 0
  hasMore: false
  nextCursor: null
  exception: none
00:03 +8: reference/universities
--- universities  (GET /reference/universities) ---
  status: 200
  shape: array[1] first-keys={id,nameAr,nameEn,faculties}
  decode: OK -> List<UniversityRef>
  count: 1
  exception: none
00:03 +9: auth: OTP request + verify + registration body
--- auth (phone=+2010000000001) ---
  otp/request: OK — decoded _OtpRequestResult
    resendAfterSeconds: 60
    expiresInSeconds: 300
  otp/verify: AuthenticatedResult — tokens + profile decoded
  discriminator: authenticated
00:04 +10: authenticated surface: me → entitlements → catalog → quiz → refresh → logout
--- GET /me ---
  decode: OK — StudentProfile
  track: Track.school
--- PATCH /me (no-op: same name — parse + roundtrip only) ---
  PATCH /me: typed ApiException(code=internal_error status=405) — reported, not failed
--- GET /me/entitlements ---
  GET /me/entitlements: typed ApiException(code=not_found status=404) — reported, not failed
--- GET /catalog/subjects ---
  GET /catalog/subjects: typed ApiException(code=not_found status=404) — reported, not failed
  quiz loop: SKIPPED — no subject list
--- POST /auth/refresh (rotation) ---
  decode: OK — TokenPair rotated
--- POST /auth/logout ---
  logout: OK (204, or already revoked)
00:05 +11: (tearDownAll)
00:05 +11: All tests passed!
```

## Run 1 — harness `dcd655b` (tail, transcribed)

Identical to run 3 through `GET /me`, then:

```text
--- PATCH /me (no-op: same name — parse + roundtrip only) ---
00:14 +10 -1: authenticated surface: me → entitlements → catalog → quiz → refresh → logout [E]
  AppException(internal_error)
  package:level_up_app/features/profile/repository/profile_repository.dart 63:7  ProfileRepository.updateMe
00:14 +10 -1: (tearDownAll)
00:14 +10 -1: Some tests failed.
```

The exception was typed (`ApiException`, HTTP 405, code `internal_error` — run 3 prints the status).
The F-7-01 boundary held; the harness, not the client, was what stopped.
