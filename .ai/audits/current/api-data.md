# Agent 7 — API & Data

**Scope:** API contract conformance (field-by-field), models & serialization, repositories,
the error pipeline, the mock backend as a fidelity risk, mock→real migration readiness,
credentials/config, caching.

**Baseline:** dev @ e3651e6

**Repository areas inspected:**
- `contract/openapi.yaml`, `contract/error-codes.md`, `contract/contract-changelog.md`,
  `contract/realtime.md`, `contract/SOURCE.md`
- `lib/core/network/{dio_client,exceptions}.dart`, `lib/core/network/interceptors/{auth,error}_interceptor.dart`
- `lib/core/config/app_config.dart`, `lib/core/storage/{secure_storage,preferences_store}.dart`,
  `lib/core/providers/core_providers.dart`, `lib/core/models/date_only_converter.dart`
- every `lib/features/*/models/*.dart` (+ the `.g.dart` output where enum decoding mattered)
  and every `lib/features/*/repository/*.dart`
- `lib/features/{auth,registration,profile}/*_error_copy.dart`, `lib/features/quiz/widgets/quiz_error_copy.dart`
- `lib/features/quiz/bloc/quiz_bloc.dart`, `lib/features/profile/notifier/me_notifier.dart`,
  `lib/features/auth/notifier/auth_controller.dart`
- `lib/dev/mock_backend.dart` (all 1527 lines), `lib/main_mock.dart`
- `test/core/network/auth_interceptor_test.dart`, `test/dev/*`
- `android/app/build.gradle.kts`, `android/key.properties.example`, `android/.gitignore`,
  `docs/RELEASE_SIGNING.md`, `pubspec.yaml`, `docs/PROGRESS.md`
- vault: `01_Flutter_Specs/Networking_and_API.md`, `01_Flutter_Specs/Models_and_Serialization.md`

---

## 1. Contract conformance — field by field

**Endpoint census (mechanically derived from `x-stability` markers in `contract/openapi.yaml`):
36 operations = 21 `stable` + 15 `draft`, across 35 paths (21 stable paths + 14 draft-only paths;
`/questions/{questionId}/favorite` carries two draft operations, `/quizzes` carries one stable POST
and one draft GET).** All 21 stable operations have exactly one call site in `lib/` — 21 call sites
counted across the five repositories, no path string appears twice, and **no draft path is called
anywhere.** The brief's "22 consumed endpoints" is 21; see F-7-12.

### 1a. Nullability / required-ness mismatches

**Result: ZERO mismatches across all 21 consumed endpoints.** Every contract-optional or
`type: [x, "null"]` field is nullable in Dart; every contract-`required` field is `required` with no
default. I looked specifically for the failure the brief describes — a contract-nullable field
declared non-nullable in Dart — and it does not occur once.

| Contract field (`openapi.yaml:line`) | Contract nullability | Dart declaration (`file:line`) | Verdict |
|---|---|---|---|
| `StudentProfile.email` `:1324` | `[string,"null"]`, not required | `String? email` — `student_profile.dart:40` | OK |
| `StudentProfile.avatar.id` `:1330` | optional (`required: [type,url]`) | `String? id` — `student_profile.dart:84` | OK |
| `StudentProfile.geography.governorate` `:1337` | `oneOf[NamedRef, null]`, not required | `NamedRef? governorate` — `student_profile.dart:98` | OK |
| `StudentProfile.geography.city` `:1338-1348` | required, **union** | sealed `ProfileCity` — `student_profile.dart:99,128-152` | OK (see F-7-13) |
| `StudentProfile.school` `:1351` | `[object,"null"]`, not required | `ProfileSchool? school` — `student_profile.dart:46` | OK |
| `StudentProfile.school.school` `:1354` | `oneOf[NamedRef,null]`, not required | `NamedRef? school` — `student_profile.dart:169` | OK |
| `StudentProfile.university` `:1359` | `[object,"null"]`, not required | `ProfileUniversity? university` — `student_profile.dart:49` | OK |
| `EntitlementState.expiresAt` `:1398` | `[string,"null"]`, not required | `DateTime? expiresAt` — `entitlement_state.dart:36` | OK |
| `EntitlementState.graceEndsAt` `:1400` | `[string,"null"]`, not required | `DateTime? graceEndsAt` — `entitlement_state.dart:40` | OK |
| `Quiz.quizType` `:1481` | `[string,"null"]`, not required | `QuizType? quizType` — `quiz.dart:28`; generated `$enumDecodeNullable` — `quiz.g.dart:12` | OK |
| `QuizQuestion.imageUrl` `:1463` | `[string,"null"]`, not required | `String? imageUrl` — `quiz_question.dart:35` | OK |
| `QuizQuestion.thumbnailUrl` `:1464` | `[string,"null"]`, not required | `String? thumbnailUrl` — `quiz_question.dart:38` | OK |
| `QuizSummary.questions[].correct` `:1516` | `[boolean,"null"]`, not required | `bool? correct` — `quiz_summary.dart:114` | OK |
| `CursorPage.nextCursor` `:1196` | `[string,"null"]`, not required | `String? nextCursor` — `reference_models.dart:129` | OK |
| `DeviceInfo.model` `:1215` | optional (`required: [deviceId,platform]`) | `String? model` — `device_info.dart:18` | OK (populated — `device_info_provider.dart:21,25`) |
| `SchoolRegistration.{governorateId,cityId,cityName,schoolId,email,avatarId}` `:1271-1279` | optional; some **forbidden** in combination | `@JsonKey(includeIfNull: false) String?` ×6 — `school_registration.dart:42,47,48,49,53,54` | OK — omission ≠ null, correctly modelled |
| `UniversityRegistration.{cityId,cityName,email,avatarId}` `:1300-1304` | optional | `@JsonKey(includeIfNull: false) String?` ×4 — `university_registration.dart:46,47,49,50` | OK |
| `PATCH /me.email` `:618` | `[string,"null"]` — **`null` clears it** | 3-state `EmailPatch` union — `profile_update.dart:113-123,158-171` | OK — best-in-class; a `String?` would silently lose "clear" |
| all other `required:` fields on every consumed schema | required | `required` with no default | OK |

Two points worth stating explicitly because they are the *reason* the table is clean:
`student_profile.dart:14-20` and `token_pair.dart:7-8` record the house rule that a missing
contract-required field **must throw** rather than be defaulted, and `reference_models.dart:9-11`
repeats it. That rule is applied uniformly. `ProfileCity` (`student_profile.dart:128-152`) is a
hand-written sealed union with `toJson: false` because freezed's union envelope
(`{ref:{...},runtimeType:'coded'}`) is not a shape this API sends — this is exactly the correct call.

### 1b. Enum conformance

**Result: ZERO enum values the app cannot parse.** The contract marks exactly two enums extensible,
and both are handled; the closed ones are hard Dart enums by deliberate policy.

| Contract enum | Extensible? | Dart handling | Verdict |
|---|---|---|---|
| `EducationSystem` `:1240-1243` | **yes** ("clients must tolerate unknown values") | kept as wire `String` — `reference_models.dart:13-16,57`; `ProfileSchool.educationSystem` `String` — `student_profile.dart:171` | OK |
| `EntitlementType` `:1389-1392` | **yes** ("tolerate unknown values additively") | enum + `unknown` sink + `@JsonKey(unknownEnumValue:)` — `entitlement_state.dart:21-26,33-34`; generated `unknownValue:` — `entitlement_state.g.dart:14` | OK |
| `Stage` `:1244-1246` | no (closed) | `enum Stage` + `tryParse` returning null — `stage.dart:13-33`; carried as `String` on the profile — `student_profile.dart:170` | OK |
| `StudentProfile.track` `:1321` | no | `enum Track` — `student_profile.dart:29`; `$enumDecode` — `student_profile.g.dart:61` | OK — throws on drift, deliberate (`student_profile.dart:23-28`) |
| `Quiz.mode` `:1480` / request `:787` | no | `enum QuizMode` — `quiz_mode.dart:23` | OK |
| `quizType` `:790,1445,1481` | no | `enum QuizType` — `quiz_type.dart:25`; exhaustive label switch `:33-38` | OK |
| `avatar.type` `[default,custom]` `:1329` | no | kept as `String` — `student_profile.dart:81` | OK (documented: UI never branches on it) |
| `StudyYearRef.status` `[active,soon]` `:562` | no | kept as `String` — `reference_models.dart:102` | OK |
| `explanation.status` `[ready]/[generating]` `:936,946` | n/a | discriminated on **HTTP status**, not the field — `quiz_repository.dart:132`; sealed `ExplanationResult` | OK |

One latent (not current) risk: `UniversitySubjectTree.quizTypes` decodes with `$enumDecode` inside a
`.map()` (`subject_tree.g.dart:72`), so a *single* new contract quiz-type value would throw the whole
subject tree, not just drop a tab. The contract does not mark that enum extensible, so throwing is
the project's stated policy — but note `docs/DESIGN_ISSUES.md #18` already wants a `flashcard` tab,
and `openapi.yaml:695` shows this API's habit is additive enum growth. Worth a pre-emptive change
request asking Seif to declare `quizTypes` extensible before a fifth value ships.

**Conclusion for deliverable 1: the class of defect the brief was hunting for is not present.**
The models are the strongest part of this codebase. The real day-one risk lives one layer up — in
what happens *when* a strict model throws. That is F-7-01.

---

## 2. Findings

### F-7-01 [HIGH] [BUG] Deserialization failures escape the typed exception boundary, and `QuizBloc` does not catch them

**Evidence:**
- Every repository catches **only** `on DioException`:
  `quiz_repository.dart:63,92,107,142`; `profile_repository.dart:29,54,66`;
  `catalog_repository.dart:30,63`; `auth_repository.dart:36,59,79,90`;
  `reference_repository.dart:30,44,65,95,109,120,133`; `registration_repository.dart:52`.
- The `fromJson` call sits **outside** Dio — e.g. `quiz_repository.dart:91`
  `return AnswerResult.fromJson(res.data!);`, `profile_repository.dart:28`
  `return StudentProfile.fromJson(res.data!);`. A schema mismatch throws a core
  `TypeError`/`FormatException` there, which is not a `DioException` and is therefore never
  converted to an `AppException`.
- `QuizBloc` catches **only** `on AppException`: `quiz_bloc.dart:140` (submit answer),
  `quiz_bloc.dart:252` (explanation poll), `quiz_bloc.dart:295` (finish).
- The models are *designed* to throw on drift — `student_profile.dart:14-19`,
  `token_pair.dart:7-8`, `reference_models.dart:10-11`.

**Why it matters:** this is precisely the day-one-of-the-real-API failure. The moment the real
backend omits or retypes a field, `AnswerResult.fromJson` or `QuizSummary.fromJson` throws a
`TypeError` that (a) is not caught by the repository, (b) is not caught by `QuizBloc`, so **no state
is emitted** — the quiz screen stays on `AnswerConfirming`/`QuizFinishing` forever while the error
surfaces as an unhandled zone error. Mid-quiz, that is a hang with the student's answers stranded.
Riverpod-driven screens degrade more gracefully (`AsyncValue.guard` / provider `build()` capture
anything), but they land on `genericError` because no `*_error_copy.dart` arm matches a raw
`TypeError` (`error is ApiException` is false, `isOffline(error)` is false). The mock never produces
a malformed body (§3), so nothing in the 731-case suite exercises this.

**Recommended fix:** two lines per repository — widen the catch to
`} on DioException catch (e) { throw _asAppException(e); } on Object catch (e) { throw UnknownException(detail: 'parse: ${e.runtimeType}'); }`
(never include `e.toString()` — response bodies carry minors' data). Optionally add a
`ParseException extends AppException` so the copy mappers can distinguish contract drift from a
generic failure. Independently, change `quiz_bloc.dart:140,252,295` from `on AppException` to a
guarded `on Object` so the bloc always emits a terminal state.

**Risk of fixing:** low. It only widens existing catch clauses; no behaviour changes on the
happy path. The one judgement call is whether a parse failure should read as "something went wrong"
or as its own copy — that is a product decision, not an engineering one.

**Validation required:** a repository test that feeds a response missing a required field and
asserts an `AppException` (not a `TypeError`) reaches the caller; a bloc test that asserts a
terminal state is emitted. Neither can be run here (no Dart toolchain).

---

### F-7-02 [MEDIUM] [ARCHITECTURE ISSUE] No 5xx handling and `traceId` is discarded — `internal_error` has no support path

**Evidence:** `error-codes.md:23` — `internal_error | 500 | ... | traceId is the support handle`.
`ProblemDetails.traceId` is defined at `openapi.yaml:1189`. `ErrorInterceptor` reads only `code`
(`error_interceptor.dart:25-27`), `errors` (`:74-86`) and `Retry-After` (`:62-68`); **`traceId` is
never read**, and `AppException` has no field for it (`exceptions.dart:9-16`). There is no
`ServerException`/5xx arm — a 500 falls to `_ => ApiException(status: status, code: code)`
(`error_interceptor.dart:38`) and then to `l10n.genericError` in all four copy mappers. There is
also **no logging interceptor at all** in `lib/` (zero `print`/`debugPrint`/`LogInterceptor`
occurrences), so nothing records the traceId either.

**Why it matters:** the contract's stated mechanism for supporting a broken request is the traceId,
and the app throws it away before anything can see it. When the real API starts 500ing, a student
report is unactionable. The vault spec explicitly calls for both a `ServerException` and a
method+URL+status `LogInterceptor` (`Networking_and_API.md` "Interceptor stack"); neither exists.

**Recommended fix:** add `final String? traceId` to `ApiException`, populate it in
`error_interceptor.dart` alongside `code`, and surface it in the error state (a small, copyable
"reference: …" line is the usual shape). Separately add the spec's `LogInterceptor` with
`requestBody: false, responseBody: false, requestHeader: false, responseHeader: false` — the spec's
"NEVER bodies or headers" rule is what makes it safe.

**Risk of fixing:** low; additive. The only care needed is that no logger ever prints headers
(`Authorization`) or bodies (minors' PII).

**Validation required:** none beyond a unit test on the interceptor.

---

### F-7-03 [MEDIUM] [ARCHITECTURE ISSUE] Error-code→copy mapping is a per-feature ladder, which the project's own spec forbids; 8 registry codes have no mapping

**Evidence:** four independent mappers —
`auth_error_copy.dart:12-24` (switch on 4 codes), `registration_error_copy.dart:17-27` (switch on 3)
and `:42-52`, `profile_error_copy.dart:14-18`, `quiz_error_copy.dart:42-54` (switch on 5).
`Networking_and_API.md` §"Error codes: per-resource, and mapped by table" states: *"Map codes with a
`const Map<String, String Function(AppLocalizations)>` (or a switch expression over a sealed set) —
**not a hand-extended if/else ladder in each feature's `*_error_copy.dart`**. Adding a code should be
one line in one table."* The implementation is the thing the spec names.

**Error-code registry → exception → user copy (complete):**

| `error-codes.md` code | HTTP | `AppException` produced | User-facing copy | Site |
|---|---|---|---|---|
| `validation_failed` | 400 | `ValidationException` (`error_interceptor.dart:31-32`) | `errorValidationFailed` + per-field | auth `:20`, reg `:23`, profile `:16` — **falls through to generic in quiz** (`quiz_error_copy.dart:53`) |
| `otp_invalid` | 400 | `ApiException(400)` | `errorOtpInvalid` + red OTP boxes | `auth_error_copy.dart:14,29-30` |
| `otp_expired` | 400 | `ApiException(400)` | `errorOtpExpired` | `auth_error_copy.dart:16` |
| `otp_throttled` | 429 | `ApiException(429)` (not `RateLimitedException` — guard is `code=='rate_limited'`, `error_interceptor.dart:33`) | `errorOtpThrottled` | `auth_error_copy.dart:18` |
| `session_superseded` | 401 | `UnauthorizedException` | forced logout + one-shot login message | `auth_interceptor.dart:74-76`, `auth_controller.dart:56-59` |
| `subscription_required` | 403 | `ApiException` | `errorSubscriptionRequired` + paywall sheet | `quiz_error_copy.dart:48,58-61`, `limit_sheet.dart:48` |
| `flashcard_subscription_required` | 403 | `ApiException` | **none → `genericError`** | — (only reachable via draft `/checkout/sessions`) |
| `image_rejected_by_moderation` | 422 | `ApiException` | **none → `genericError`** | — (draft `PUT /me/avatar`) |
| `code_already_redeemed` | 409 | `ApiException` | **none → `genericError`** | — (draft) |
| `insufficient_scope` | 403 | `ApiException` | `errorInsufficientScope` / `subjectUnavailable` | `quiz_error_copy.dart:52`, `catalog_states.dart:63,75` |
| `authentication_required` | 401 | handled in interceptor | never user-facing (refresh+retry; swallowed on logout) | `auth_interceptor.dart:80`, `auth_repository.dart:92-94` |
| `not_found` | 404 | `ApiException` | **none → `genericError`** | — |
| `country_not_found` | 404 | `ApiException` | **deliberately generic** (documented `registration_error_copy.dart:38-41`) | — |
| `rate_limited` | 429 | `RateLimitedException` + `Retry-After` | `rateLimited` / `rateLimitedIn(n)` | `error_interceptor.dart:33-34,62-68`, `registration_error_copy.dart:44-50` |
| `internal_error` | 500 | `ApiException(500)` | **none → `genericError`**, traceId lost | see F-7-02 |
| `registration_token_invalid` | 401 | `UnauthorizedException` | `registrationTokenInvalid` + restart flow | `registration_error_copy.dart:19,76-81` |
| `refresh_token_invalid` | 401 | `UnauthorizedException` | forced logout (`sessionExpired`) | `auth_interceptor.dart:143-144` |
| `phone_already_registered` | 409 | `ApiException` | `phoneAlreadyRegistered` + restart | `registration_error_copy.dart:21,79` |
| `recovery_unavailable` | 404 | `ApiException` | **none → `genericError`** | — (draft) |
| `payment_initiation_failed` | 502 | `ApiException` | **none → `genericError`** | — (draft) |
| `code_invalid` | 404 | `ApiException` | **none → `genericError`** | — (draft) |
| `weekly_question_limit_reached` | 403 | `ApiException` | `errorWeeklyQuestionLimitReached` + paywall | `quiz_error_copy.dart:46,58-61` |
| `not_enough_questions` | 422 | `ApiException` | `errorNotEnoughQuestions` | `quiz_error_copy.dart:45` |
| `quiz_already_finished` | 409 | `ApiException` | `errorQuizAlreadyFinished` | `quiz_error_copy.dart:50` |

**Unmapped and reachable on a consumed stable endpoint: `internal_error` (any endpoint),
`not_found`, and `validation_failed` on the four quiz endpoints** (`openapi.yaml:799-801` documents
a 400 on `POST /quizzes`; `quiz_error_copy.dart` has no arm for it). The other six unmapped codes
belong to draft endpoints and are correctly absent. Every mapper has a safe fallback arm, so nothing
crashes — the cost is that a student who trips a quiz validation error, or any 500, sees
"حدث خطأ ما" with no route forward.

**Why it matters:** the registry is append-only by design (`error-codes.md:3`) and Seif has already
signalled more per-resource not-found codes are coming (`governorate_not_found`, `city_not_found`,
`school_not_found` — `error-codes.md:5`). With four ladders, each new code is a four-file hunt, and
the omission above shows the hunt is already being lost.

**Recommended fix:** one `const Map<String, String Function(AppLocalizations)> kErrorCopy` in
`lib/core/network/`, keyed by code; each feature mapper keeps only its feature-specific *behaviour*
(paywall sheet, restart-registration, red OTP boxes) and delegates copy to the table. Add
`internal_error` and `validation_failed` rows while doing it.

**Risk of fixing:** low-medium — touches four files and their tests, and the ARB needs 2–3 new keys
(AR + EN, RTL-checked).

**Validation required:** a test asserting every code in `contract/error-codes.md` resolves to a
non-generic string or is explicitly listed as intentionally generic. That test is also the
regression guard for the next contract bump.

---

### F-7-04 [MEDIUM] [QUALITY IMPROVEMENT] The mock cannot produce 401, 5xx, a timeout, or a malformed body — and mock-mode refresh would hit `TBD.example`

**Evidence:** `mock_backend.dart:40-41` states it outright — *"There is no `AuthInterceptor`: the
mock never answers 401"* — and `buildMockDio` (`:42-53`) installs only
`[MockBackendInterceptor, ErrorInterceptor]`. No handler in the 1527 lines emits 401, 500 or 502; no
`DioExceptionType.connectionTimeout`/`connectionError` is ever synthesised; every response body is a
well-formed Dart `Map`/`List`. `main_mock.dart:34` overrides **only** `dioProvider` —
`refreshDioProvider` (`core_providers.dart:32-34`) is untouched, so it is built from
`AppConfig.baseUrl`, i.e. `https://staging.TBD.example/api/v1`; a refresh in mock mode would attempt
a real DNS lookup against the placeholder host.

**In fairness — and contradicting the premise this audit started from:** the mock is *not* a
happy-path-only harness. It emits `400 validation_failed` **with the contract's `errors` field map**
(`:388-410`), `403 insufficient_scope` (`:239-245, 682-688`), `403 subscription_required` (`:518-524`),
`403 weekly_question_limit_reached` (`:530-538`), `404 country_not_found` (`:457-465`),
`404 not_found` (`:334, 579, 599, 631`), `409 quiz_already_finished` (`:581-589`),
`422 not_enough_questions` (`:541-549`), and `429 rate_limited` **with a real `Retry-After: 30`
header** (`:473-486`) — all as RFC 9457 ProblemDetails routed through the *real* `ErrorInterceptor`
via `handler.reject(..., callFollowingErrorInterceptor: true)` (`:721-749`). It emits **nulls for
nullable fields** (`email: null` `:1481`, `governorate: null` `:1490`, `school`/`university` null
`:1495-1496`, `imageUrl: null` `:1276-1279`, `expiresAt`/`graceEndsAt` null `:1523-1526`,
`nextCursor: null` `:895`, `correct: null` for unanswered `:661`) and **empty lists on purpose**
(`:851` cities, `:1060` lessons, `:1082` units, `:1156` lectures, `:292` non-EG governorates). It is
stateful, enforces idempotency, and has trigger tables documenting how to reach each error on device.
This is a genuinely good harness; the gap is narrow and specific.

**Why it matters:** the four 401 codes (`authentication_required`, `session_superseded`,
`refresh_token_invalid`, `registration_token_invalid`) and the entire refresh/retry/forced-logout
pipeline are unreachable in any device walkthrough. They *are* unit-tested —
`test/core/network/auth_interceptor_test.dart` covers refresh-once-then-retry (`:100`),
`session_superseded` → forceLogout (`:125`), dead refresh (`:149`), **concurrent 401s → exactly one
refresh** (`:163`), no-double-retry (`:186`) and offline-during-refresh (`:203`) — so this is a
device/integration gap, not an untested-logic gap. Still, "token expired while the student was
mid-quiz" is the single most likely first-week production incident and no one has ever seen it happen
on a phone.

**Recommended fix:** add three trigger-table entries in the mock's existing style — an OTP code that
mints a 60-second access token so a natural 401 occurs, a country/search trigger that returns
`500 internal_error` with a `traceId`, and one that returns a body with a required field removed.
Also override `refreshDioProvider` in `main_mock.dart` so refresh stays offline.

**Risk of fixing:** none to shipped code — `lib/dev/` and `lib/main_mock.dart` are additive by
construction (`mock_backend.dart:8-14`).

**Validation required:** device walkthrough.

---

### F-7-05 [MEDIUM] [QUALITY IMPROVEMENT] The mock short-circuits at `onRequest`, so nothing is ever JSON-encoded or JSON-decoded

**Evidence:** `mock_backend.dart:111-120` intercepts in `onRequest` and reads
`options.data as Map` directly; `_ok` (`:707-716`) resolves a `Response` whose `data` is a live Dart
object. Query params are read as native types — `query['limit'] as int? ?? 20` (`:316`) — a cast that
could never succeed against a real server, where Dio serialises `limit` into the query string and the
server returns it as text. `_problem` (`:733-741`) likewise hands back a Dart map.

**Why it matters:** every `toJson`/`fromJson` round-trip defect that only appears after a real
encode/decode is invisible in mock mode and in the four `test/dev/*` suites. Concretely at risk:
`DateOnlyConverter` (`date_only_converter.dart:16-32` — `format: date` vs full ISO-8601, and the
deliberate no-UTC-conversion decision), `ProfileUpdate.toJson`'s explicit `"email": null`
(`profile_update.dart:118`, which must survive any transformer), and the `includeIfNull: false`
omissions on the registration bodies where **omission and explicit null mean different things to the
server** (`school_registration.dart:19-24`). The mock is strict about *semantics* (it rejects
`schoolName` and both-cities, `:343-384`) but blind to *serialization*.

**Recommended fix:** in `_ok`/`_problem`, round-trip through
`jsonDecode(jsonEncode(data))` before resolving, and decode `options.data` the same way at the top of
`onRequest`. Four lines, and it makes the harness structurally honest.

**Risk of fixing:** none to shipped code. Some existing `test/dev/*` assertions may need type
adjustments — which is the finding proving itself.

**Validation required:** run `test/dev/*` after the change.

---

### F-7-06 [MEDIUM] [QUALITY IMPROVEMENT] The mock's entitlement fixture only ever expresses one state

**Evidence:** `mock_backend.dart:1519-1527` — a single-element list, `baseSubscription`,
`active: false`, `inGrace: false`, both dates null. Shared by `GET /me/entitlements` (`:210-214`) and
the `/me` embed (`:1512`).

**Why it matters:** `active: true`, `inGrace: true` + `graceEndsAt`, `flashcardSubscription`, an
empty `items` array, and an **unknown** entitlement type are all contract-legal and none is ever
produced. The `EntitlementType.unknown` sink (`entitlement_state.dart:21-26`) — the app's one
extensibility guard, written specifically because the contract says the set grows — has no runtime
exercise at all. The same applies to `EducationSystem`: the mock only emits the five known codes
(`:912-918`), so the "tolerate unknown values" `String` policy is untested too.

**Recommended fix:** make `_entitlements` a small function keyed off the session (e.g. the
university magic code grants an active `flashcardSubscription`; one trigger yields an in-grace state;
one yields `type: 'somethingNew'`).

**Risk of fixing:** none to shipped code.

**Validation required:** none.

---

### F-7-07 [MEDIUM] [QUALITY IMPROVEMENT] `hive_ce` is a dead dependency — three of them — and there is no caching layer at all

**Evidence:** `pubspec.yaml:46` `hive_ce: ^2.19.3`, `:47` `hive_ce_flutter: ^2.3.4`,
`:76` `hive_ce_generator: ^1.11.2`. A case-insensitive grep for `hive` across `lib/` and `test/`
returns **three hits, all false positives** (the string "Achive"/"Achieve" in
`app_localizations.dart:263` and `onboarding_screen_test.dart:85,91`). No import, no box, no adapter,
no `Hive.init`.

On caching more broadly: there is **no HTTP or response cache of any kind**. Persistence is
`flutter_secure_storage` for tokens/device id (`secure_storage.dart`) and `shared_preferences` for
theme/locale (`preferences_store.dart`); the only image cache is `cached_network_image` for avatars
(`pubspec.yaml:59-60`). All API caching is in-memory Riverpod provider lifetime — non-autoDispose
notifiers so data survives tab switches (`me_notifier.dart:11-13`, `subjects_notifier.dart:8`,
`subject_tree_notifier.dart:14`, `reference_providers.dart:10`) — and is gone on process death.
That is a defensible choice for M1 (server-authoritative points, `adr-013` token-derived scoping), but
it is undocumented as a choice.

**Why it matters:** three unused dependencies inflate the dependency graph and the build (a
generator dev-dependency in particular), and they imply a persistence design that does not exist —
the next developer will reasonably assume offline caching is half-built. On a metered Egyptian
connection, "no offline read of anything" is a real product gap that should be a stated decision, not
an accident.

**Recommended fix:** remove all three from `pubspec.yaml` and add one line to `docs/DECISIONS.md`:
"no persistent API cache in M1; Riverpod in-memory only." If offline reads are wanted later,
re-add deliberately.

**Risk of fixing:** near-zero (nothing imports them) but it is a `pubspec.yaml` edit, which this pass
is forbidden from making. `flutter pub get` + full test run required.

**Validation required:** `flutter pub get`, `flutter analyze`, `flutter test`.

---

### F-7-08 [LOW] [QUALITY IMPROVEMENT] `OfflineException` is declared and referenced but never thrown

**Evidence:** declared `exceptions.dart:19-21`; referenced by `isOffline` (`:95-96`),
`quiz_error_copy.dart:44` and doc comments (`auth_interceptor.dart:150`,
`registration_submit_notifier.dart:38`). The only mapper that could construct it —
`ErrorInterceptor` — maps `connectionError` and all three timeout types to `NetworkException`
(`error_interceptor.dart:16-21`). No `const OfflineException()` is ever instantiated in `lib/`.

**Why it matters:** minor, and currently harmless because `isOffline()` accepts both. But the vault
spec (`Networking_and_API.md`) says timeouts *should* map to `OfflineException`, and it also names a
`ServerException` that does not exist — so the spec and the hierarchy have drifted apart in two
places. A reader trusting either one is misled.

**Recommended fix:** either delete `OfflineException` and update the spec, or wire it to the
`connectivityProvider` (`core_providers.dart:54-61`) so a genuinely offline device gets the offline
signal rather than a timeout after 15s. The second is better product behaviour.

**Risk of fixing:** low.

---

### F-7-09 [LOW] [BUG] `ProfileCity.fromJson` throws a raw `TypeError` on a malformed city union

**Evidence:** `student_profile.dart:141-144` —
`json.containsKey('id') ? ProfileCity.coded(NamedRef.fromJson(json)) : ProfileCity.freeText(json['name'] as String)`.
A body of `{"id": null, "name": "X"}` takes the coded arm and fails on `json['id'] as String`; a body
with neither key fails on `json['name'] as String`.

**Why it matters:** on its own, contract drift that deserves to throw — but it throws the *untyped*
kind, feeding F-7-01. Called out separately because `geography.city` is the field the v1.1 contract
change reshaped (`contract-changelog.md` 2026-07-30) and is therefore the most likely spot for a
server-side implementation to disagree first.

**Recommended fix:** discriminate on `json['id'] is String` rather than `containsKey`, and throw a
typed `UnknownException(detail: 'city union')` in the else-of-else.

**Risk of fixing:** low. `test/features/profile/profile_models_test.dart` covers both arms already.

---

### F-7-10 [LOW] [PRODUCT DECISION — blocked] Base URLs are `TBD.example` placeholders

**Evidence:** `app_config.dart:37-44` — `TODO(contract)`, all three flavors resolve to
`https://staging.TBD.example/api/v1` / `https://TBD.example/api/v1`, matching
`openapi.yaml:57-58` ("URL TBD — announced via contract-changelog.md").

This is correctly recorded as blocked on the backend partner, not an oversight — the comment even
says "Do NOT ship." No finding against the code; §4 below is the deliverable that makes it
actionable. Two adjacent observations worth acting on when the URL lands: `Flavor.dev` and
`Flavor.staging` resolve to the *same* URL (`:41-42`), and there is no build-time override
(`--dart-define`), so pointing the app at a laptop or a preview host means editing a shipped source
file.

**Forward pointer (2026-09-05):** half-resolved — staging is now a real host (`67bdcc1`,
`app_config.dart:43`, `contract/SOURCE.md`); only prod remains `TBD.example`.

---

### F-7-11 [LOW] [QUALITY IMPROVEMENT] Contract gaps worth a change request (Seif's side, not ours)

**Evidence:**
1. `GET /reference/schools` (`:479-504`), `/education-systems` (`:508-525`), `/universities`
   (`:529-565`) and `/avatars` (`:569-585`) document **no error responses at all**, yet
   `error-codes.md:22` states the per-IP `rate_limited` limiter applies to `/reference/*`, and the
   other three reference paths do document the 429. The app handles 429 on all of them via the
   generic interceptor arm, so no bug — but the contract is internally inconsistent.
2. **No endpoint anywhere documents a `500`**, though `internal_error` is a registered code
   (`error-codes.md:23`).
3. `UniversitySubjectTree.quizTypes` (`:1443-1445`) is not marked extensible while two sibling enums
   are — see §1b.

**Recommended fix:** raise one change request covering all three. The project rule
(`.claude/skills/seif-api-contract/SKILL.md`) is exactly this: never invent, raise a CR.

---

### F-7-12 [LOW] [QUALITY IMPROVEMENT] `docs/PROGRESS.md` endpoint arithmetic is off by one — but the substantive claim is TRUE

**Verified by mechanical extraction of every `x-stability` marker:** 21 `stable` operations,
15 `draft` operations, 36 total. All 21 stable operations are consumed (21 call sites, one each).
**Zero draft paths are called anywhere in `lib/`.** So the claim at `docs/PROGRESS.md:242-244` —
*"Every stable path in the contract is consumed… every one of the 14 remaining paths is
`x-stability: draft`, so there is no further endpoint work"* — **is true, not an excuse.** The 14
unconsumed *paths* are: `/auth/recovery/{start,verify-parent,new-phone,confirm}`, `PUT /me/avatar`,
`PUT /me/fcm-token`, `GET /quizzes`, `GET /quizzes/{quizId}`, `/questions/{questionId}/favorite`
(PUT+DELETE), `GET /me/favorites`, `POST /checkout/sessions`,
`POST /subscription-codes/redemptions`, `GET /leaderboard`, `GET /leaderboard/me`.

**Evidence of the error:** `docs/PROGRESS.md:241` says "22/36 total" and `:247-249` enumerates the
unconsumed set — but that enumeration **omits `POST /subscription-codes/redemptions`** and counts the
two favourite operations plus `/me/favorites` as "three favourites", mixing path- and
operation-granularity. Correct figures: 21 consumed operations of 36 (21/36 by operation), or 21 of
35 paths; 15 unconsumed operations across 14 paths.

**Recommended fix:** one-line correction in `docs/PROGRESS.md` and add the missing path to the list.

**Forward pointer (2026-09-05):** `POST /checkout/sessions` — one of the 14 unconsumed paths
counted here — was deleted outright at 2.2.0-m1 (adr-049 §3), not merely left unconsumed. The
contract still totals 21 stable + 15 draft = 36 operations at 3.0.0-m1 (`contract/SOURCE.md`), so
this section's arithmetic is unaffected, but the specific path list above is stale — do not use it
to look up `/checkout/sessions` as still-draft-and-unconsumed; it no longer exists.

---

### F-7-13 [PASS] Credentials & config — clean

Checked and found **no hardcoded key, token or secret anywhere in `lib/` or `android/`.**

- Regex sweep for `api[_-]?key`, `secret`, `password`, `bearer <token>`, `sk_live`, `pk_live`,
  `AIza`, `ghp_` across `lib/**/*.dart` and `android/**/*.{kts,gradle,xml}` returns only the Gradle
  code that *reads* `key.properties` and one comment in `data_extraction_rules.xml`.
- `git ls-files` matching `key.properties`, `*.jks`, `*.keystore`, `*.env`, `secret`, `credential`
  returns **nothing**. `android/local.properties` is untracked. `android/.gitignore:12-14` ignores
  `key.properties`, `**/*.keystore`, `**/*.jks`; root `.gitignore:48` repeats it.
  `android/key.properties.example` is the only tracked file and contains `CHANGE_ME` placeholders.
- `android/app/build.gradle.kts:19-25,52-71` fails **closed**: absent `key.properties` ⇒ no release
  `signingConfig` ⇒ unsigned release, with a configuration-time warning (`:76-81`). The comment at
  `:65-70` explicitly forbids falling back to the debug keystore. `docs/RELEASE_SIGNING.md` is
  correct and mentions no real secret.
- **Token handling:** the access token reaches the interceptor only via
  `SecureStorage.readAccessToken()` inside `AuthInterceptor.onRequest`
  (`auth_interceptor.dart:55-58`) and is written to `options.headers['Authorization']`. It is never
  passed as a constructor argument, never stored in a provider, never in `AppConfig`.
- **Leak surface: none found.** `lib/` contains **zero** `print`/`debugPrint`/`LogInterceptor`/
  `dart:developer` calls. `AppException.toString()` prints only the code (`exceptions.dart:15`), never
  `detail`. `ValidationException` deliberately does not render server message strings
  (`exceptions.dart:50-53`). `RegistrationRepository`'s doc (`:25-26`) states the body carrying a
  minor's name/DOB/parent phone is never logged, and nothing logs it.
- **`flutter_secure_storage` usage is correct and unusually well-reasoned.** `secure_storage.dart:32-35`
  sets `KeychainAccessibility.first_unlock_this_device` + `synchronizable: false`, with the rationale
  at `:13-31`: without `_this_device` the item is restorable onto a different phone, which would carry
  `device_id` with it and defeat `adr-019` eviction entirely. Android options are deliberately
  omitted because `encryptedSharedPreferences` is deprecated in 10.x. `clearTokens()` (`:57-60`)
  preserves `device_id` and `clear()` is documented as never-for-logout. `readOrCreateDeviceId`
  (`:73-84`) uses `Random.secure()`, 128 bits, under the contract's `maxLength: 64`.
- `TokenPair` (`token_pair.dart:12-23`) is a plain freezed model with no `toString` override — freezed
  generates one that **includes all four fields**, so `print(tokenPair)` or an uncaught error carrying
  it would expose both tokens. Nothing does this today (no logging exists), but adding the
  `LogInterceptor` from F-7-02 makes it a live hazard. Add `@Freezed(toStringOverride: false)` or an
  explicit redacting `toString` at the same time.

---

## 3. The 401 → refresh → retry path — assessed in detail

Asked specifically, so answered specifically. **The implementation is correct**, including the
concurrency case.

- **Loop safety:** refresh runs on a *separate bare Dio* with no `AuthInterceptor`
  (`dio_client.dart:44-49`, `core_providers.dart:32-34`, `auth_repository.dart:74`), so a 401 on
  `/auth/refresh` cannot re-enter the retry path. Independently, the original request is retried at
  most once via `extra['__retried']` (`auth_interceptor.dart:48,85-87,106`). Two independent guards.
- **Failed refresh:** `_performRefresh` (`:123-152`) forces logout on `refresh_token_invalid` and on
  `session_superseded`, and **deliberately does not** on `NetworkException`/`OfflineException`
  (`:150-151`) — a transient failure must not sign a student out. Missing refresh token ⇒ immediate
  `forceLogout(sessionExpired)` (`:127-131`). The typed error is then re-thrown to the caller via
  `handler.reject` (`:92-98`) rather than swallowed.
- **Concurrent 401s — the classic bug — is handled.** `_sharedRefresh` (`:118-121`) uses
  `_refreshing ??= _performRefresh().whenComplete(() => _refreshing = null)`. The `??=` assigns
  **synchronously, before any await**, so a burst of N simultaneous 401s produces exactly one
  `POST /auth/refresh`; all N await the same future and all N retry with the same new token. Because
  `writeTokens` is awaited *inside* `_performRefresh` before it completes (`:136-140`), a refresh
  starting after that point reads the rotated token from storage — so even the sequential case cannot
  replay a spent refresh token and trip Seif's reuse detection. `test/core/network/auth_interceptor_test.dart:163`
  asserts exactly this ("concurrent 401s → refresh called exactly once, all retried").
- **`session_superseded` is checked first and never triggers a refresh** (`:74-77`), matching
  `openapi.yaml:26-32`.
- **Non-401 codes on a 401 status** (`registration_token_invalid`) fall through to `handler.next`
  (`:80-82`) and are typed by `ErrorInterceptor` — correct, no wasted refresh.

**The one residual risk** is structural, not logical: `_refreshing` is instance state on the
`AuthInterceptor`, and there is exactly one instance because `dioProvider` is a plain (cached)
`Provider` (`core_providers.dart:39`). If `dioProvider` is ever invalidated or made `autoDispose`
while requests are in flight, a second interceptor with a fresh `_refreshing` could run a second
refresh with the same refresh token — reuse detection would then revoke the whole chain and force a
full re-login. Worth a comment on `dioProvider` saying it must stay non-autoDispose, and worth
knowing before someone "tidies" it. Second, minor: `_retryDio.fetch(options)` (`:108`) re-plays
`options.data`; that is safe for JSON bodies but would fail for a consumed multipart stream — relevant
only when draft `PUT /me/avatar` is promoted.

---

## 4. Mock → trial API migration checklist

Assume a real staging base URL arrives tomorrow morning. Ordered; each step names what breaks first.

**Step 0 — before touching code (15 min).**
Re-vendor the contract if `contract-changelog.md` has moved since pin `ee2ed8f`
(`contract/SOURCE.md:4-5`); the URL announcement lands in that file, so it may carry other changes.
If `openapi.yaml` changed, run `dart run build_runner build --delete-conflicting-outputs` and read the
diff before anything else. *Breaks first:* nothing — this is the cheap step that prevents a wasted day.

**Step 1 — `lib/core/config/app_config.dart:37-44`.**
Replace the three `TBD.example` strings, delete the `TODO(contract)` block, and split dev from
staging (they are currently identical, `:41-42`). Add a `--dart-define` override so the host can be
pointed at a laptop without editing a shipped file:
`String.fromEnvironment('BASE_URL', defaultValue: _baseUrlFor(flavor))`.
*Breaks first:* nothing yet — but every later step depends on this one being right, including the
trailing `/api/v1` and the absence of a trailing slash (Dio joins `baseUrl` + `/auth/...`; a trailing
slash yields `//auth`).

**Step 2 — network reachability, before any feature.**
`flutter run -t lib/main_dev.dart` and hit **`GET /reference/countries`** first: it is unauthenticated
(`openapi.yaml:403`), returns a bare array, and is the smallest possible end-to-end proof. If the
registration Country picker fills, TLS, DNS, base path and JSON decoding all work.
*Breaks first:* certificate/TLS on Android 7-and-below devices; a base path that is `/v1` not
`/api/v1`; and `application/problem+json` decoding on the error path (`dio ^5.10.0` handles the
`+json` suffix — verify with a deliberate 404 rather than assuming).

**Step 3 — fix F-7-01 *before* step 4.**
Widen the repository catches and `QuizBloc`'s `on AppException`. Do this before touching auth,
because steps 4–7 are exactly where the first real schema mismatch will appear and you want it to
arrive as a typed error with a readable code, not as a `TypeError` in a stack trace.
*Breaks first:* nothing; this is the safety net.

**Step 4 — the auth walk: `POST /auth/otp/request` → `otp/verify` → `/auth/register`.**
Use the contract's staging test numbers `+20100000000xx` with fixed OTP `000000`
(`openapi.yaml:45-47`) — they exist precisely for this and never send SMS. Verify in order:
(a) `202` with `resendAfterSeconds`/`expiresInSeconds`; (b) the `oneOf` fork on `result` —
`authenticated` vs `registrationRequired` (`auth_result.dart:23-33`); (c) `DeviceInfo` is accepted
(`deviceId` ≤64 chars, `platform` in `[android,ios]`); (d) tokens land in Keychain/Keystore and
`AuthController` flips.
*Breaks first:* the `oneOf` discriminator. `AuthResult` reads `result` verbatim via
`@Freezed(unionKey: 'result', unionValueCase: FreezedUnionCase.none)`; if the server sends
`"Authenticated"` or omits `result`, **nothing parses** and the whole login is dead. Second-most
likely: `phone` E.164 formatting rejected by the server's `^\+[1-9][0-9]{7,14}$` pattern.

**Step 5 — the 401 pipeline, deliberately, with a real short token.**
Ask the backend for a build/flag issuing a ~60-second access token, then: open Home, wait, pull to
refresh. Assert one `POST /auth/refresh` (not two), the original request retried once, and no logout.
Then have someone log the same account in on a second device and confirm the first device shows the
forced-logout screen on its next call (`session_superseded`, any endpoint —
`openapi.yaml:26-32`). Then corrupt the stored refresh token and confirm a clean full re-login.
*Breaks first:* the ProblemDetails `code` on 401. `AuthInterceptor._codeOf` (`:156-160`) reads
`data['code']` from the **raw** body; if the server returns 401 with an empty body, a
`WWW-Authenticate` header instead, or an HTML error page from a proxy, the code is `null`, no refresh
runs, and every expired session becomes a hard failure. Verify the exact 401 body shape with the
backend before this step.

**Step 6 — reference pickers and registration submit.**
Walk the full wizard on both tracks. Verify the four v1.1 behaviours specifically: `cityId` XOR
`cityName` (`school_registration.dart:47-48`, `registration_body.dart:77-105`), `schoolId` optional
everywhere, `governorateId` required for EG / forbidden elsewhere, and `schoolName` absent. Then
confirm `GET /reference/countries/XX/governorates` returns `404 country_not_found` and
`.../EGY/...` returns `400 validation_failed` — the split the mock models at `:442-466`.
*Breaks first:* `includeIfNull: false` semantics. If any proxy, gateway or serializer inserts
explicit nulls, the server answers `validation_failed` on a body the client believes is correct
(`school_registration.dart:19-24`). Inspect one real request body on the wire, once.

**Step 7 — `GET /me`, the highest-surface-area parse in the app.**
`StudentProfile` has 14 required fields and three nested unions. Fetch a school student, a university
student, a student with a free-text city, and a student with no school. All four must parse.
*Breaks first:* `geography.city` — it is the field v1.1 reshaped and the one place the client
discriminates on the *presence of a key* (`student_profile.dart:141-144`, and F-7-09). Second:
`track` (`$enumDecode`, throws on anything but `school`/`university`).

**Step 8 — catalog, then the quiz loop.**
`GET /catalog/subjects` → `/tree` for both tracks (the `oneOf` is dispatched on `json['track']` in
`catalog_repository.dart:56-62`, so an unexpected value throws a typed `UnknownException` — good).
Then `POST /quizzes` → `POST /answers` ×N → `POST /finish`, plus one deliberate duplicate answer
submission to confirm server-side idempotency on `(quizId, questionId)` returns the *original* grade
and `pointsDelta: 0`. Finally `GET /questions/{id}/explanation` and confirm a real `202` is returned
at least once (the repo discriminates on **status code**, not the body field —
`quiz_repository.dart:132`).
*Breaks first:* the `202`. If the server returns `200` with `{"status":"generating"}` and no `text`,
the repository throws `UnknownException('explanation 200 without text')` (`:138-140`) and the panel
dies. Second: `receiveTimeout: 20s` (`dio_client.dart:18`) against a cold GPT-4o-mini generation.

**Step 9 — error and empty states against real data.**
Ask the backend to force one `500` and one `429`. Confirm `Retry-After` arrives as delta-seconds
(the client deliberately refuses the HTTP-date form, `error_interceptor.dart:59-61`), and confirm the
traceId is visible somewhere (F-7-02 must be fixed for this to be possible). Confirm a real empty
list renders the empty state, not the error state.

**Step 10 — only now, turn off the mock.**
Keep `main_mock.dart` and `lib/dev/` in the tree — they are additive, offline, and remain the fastest
way to walk a flow on a plane. Add the F-7-04/F-7-05 improvements while the real-API behaviour is
still fresh, so the harness converges on the server rather than drifting from it.

**Do not do, in any order:** do not add `?? 0`, `?? ''` or `@Default` to make a parse succeed. The
models throw on drift by design (`student_profile.dart:14-19`). A parse failure against the real API
is the system working — file a change request per
`.claude/skills/seif-api-contract/SKILL.md` and `Networking_and_API.md` §"Contract discipline".

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

## Remaining Risks

1. **F-7-01 is the one that detonates.** Not the models — they are clean — but the layer that
   catches them when they throw. It is invisible today because the mock cannot produce a malformed
   body (F-7-05).
2. The 401 pipeline is logically correct and well unit-tested but has **never run on a device**
   (F-7-04). Step 5 of the checklist exists for this.
3. `internal_error` + `traceId` (F-7-02) means the first production 500 will be unsupportable.
4. Everything in §1 was verified by reading source and the generated `.g.dart` output. It could not
   be verified by running `flutter analyze` or the suite. A machine check — a script that walks
   `openapi.yaml` and asserts each consumed schema's `required`/nullable set against the Dart
   declarations — would make this permanent instead of a point-in-time read. **Validation required.**

## Deferred Improvements

- Generate models from `openapi.yaml` rather than hand-writing them, or add the conformance script
  above. Hand-written is currently *better* than generated here (the `ProfileCity`, `EmailPatch` and
  `ExplanationResult` unions all encode judgement a generator would destroy) — but the conformance
  check should not be a human re-reading 36 schemas after every contract bump.
- Persistent read cache once offline behaviour becomes a product requirement (F-7-07).
- Redacting `toString` on `TokenPair` before any logging is introduced (F-7-13).

## Recommendations (ranked)

1. **Fix F-7-01** — widen repository catches and `QuizBloc`'s `on AppException`. Small, contained,
   and it is the difference between "the API drifted, here is the code" and "the quiz hangs".
2. **Fix F-7-02** — carry `traceId` on `ApiException` and add the spec's header-and-body-free
   `LogInterceptor`. Do it before the trial API, not after.
3. **Consolidate the error-code table (F-7-03)** and add the missing `internal_error` /
   quiz-`validation_failed` rows. One table, one line per code, as the vault spec already mandates.
4. **Teach the mock to fail (F-7-04, F-7-05, F-7-06)** — 401, 500, timeout, malformed body, a JSON
   round-trip, and a second entitlement state. All additive, zero risk to shipped code.
5. **Remove the three `hive_ce` dependencies (F-7-07)** and record "no persistent cache in M1" as a
   decision.
6. **Raise one contract change request (F-7-11)** covering the missing `/reference/*` error
   responses, the absent 500s, and `quizTypes` extensibility.
7. Correct the `docs/PROGRESS.md` endpoint arithmetic (F-7-12) — the claim is true, the count is not.
