# Contract 3.0.0-m1 — Flutter Implementation Impact Audit

> **Phase 2 — audit only. No application source code was modified.** This document is the sole
> file this audit created. `git status --short` at the end of the audit is byte-identical to the
> start: `?? docs/STORE_READINESS.md`, `?? skills/`.
>
> **Date:** 2026-09-04 · **Branch:** `merged` · **HEAD:** `7e7129c`
> **Method:** one lead agent (Opus 5) + six independent subagents, every subagent finding
> re-verified against the repository by the lead before it appears below.
> **Verification level of this document: SOURCE + BUILD.** Nothing here is DEVICE or CI verified.
> Where a claim could not be settled from the repository it says **UNKNOWN** and says what would
> settle it.

> **Phase 3B status (2026-09-05, documentation only):** steps 1 and 2 of §12 done (instruction
> set corrected; day7/day9/day8/day7c briefs stamped; K-3 retired; S6 re-anchored; smoke report
> and RISKS R-8 school-cohort wording corrected; `seif_fight.md` restructured into the
> contract-change ladder). `zna.md` deliberately untouched (excluded). Steps 3–12 not started.

---

## 1. Executive Summary

| | |
| --- | --- |
| **Contract version** | `3.0.0-m1` (`contract/openapi.yaml` `info.version`) |
| **Contract pin** | `184d6ec80cbde708acfe605d00eb8a5c756de797` — mirror of `level-up-backend@4a8e7cf` |
| **Previous pin** | `61905ce` (`2.1.0-m1`), vendored 2026-08-18 — **two published versions were skipped** |
| **Delta actually absorbed** | 2.1.0-m1 → 2.2.0-m1 → 2.3.0-m1 → 3.0.0-m1 (three versions, not one) |
| **Validation baseline** | **862 passed / 0 failed** — re-run by the lead agent (`flutter test --no-pub`, 01:47, exit 0). Confirms the recorded baseline; writes no tracked file. |
| **Stable operations in the contract** | **21** (`grep -c '^      x-stability: stable'` = 21; draft = 15; 36 total) |
| **Stable operations with a client implementation** | **21 / 21** |
| **Client calls to removed / draft / web-only operations** | **0** |
| **Confirmed findings** | **24** — 1 HIGH, 12 MEDIUM, 11 LOW/INFORMATIONAL. **0 CRITICAL.** |
| **Subagent findings rejected or materially corrected by the lead** | **8** |
| **Backend-blocked / unverifiable areas** | **3** (quiz loop unreachable, `PATCH /me` 405, `GET /me/entitlements` 404) |

### Overall compatibility assessment

**The wire-level migration is done and it is done well.** Every client model's `required` set
matches the 3.0.0-m1 schema in both directions; no legal 3.0.0-m1 body can throw in any
repository; no client call targets a deleted, `draft`, or `x-consumers: [web]` operation; the
purchase surface is genuinely gone (`lib/features/subscription/` is four `.gitkeep` files);
and the Arabic copy is as purchase-silent as the English.

**What is not done is everything one layer out from the wire.** The findings that survived
verification cluster in three places, none of which a compiler or the test suite can see:

1. **The instruction set that every future session loads still teaches the deleted product.**
   Six tracked `.claude/skills/*/SKILL.md` files and the root `F:\level\CLAUDE.md` describe a
   Paymob web checkout and a Fawry `pending` subscription state. The contract says, in the
   operation description itself: *"There is no `pending` state — an entitlement is active or it
   isn't."* (`openapi.yaml:754`). This is the single highest-severity finding in the audit and it
   is not in any `.dart` file.
2. **`GET /me` is now the sole home of the student's standing, and its freshness was never
   hardened for that role.** It is invalidated on exactly one event, has no app-resume refresh,
   and a failed refetch blanks Home to a full-screen error while a perfectly good profile sits in
   the cache.
3. **The green suite is structurally disconnected from the contract.** No test reads
   `contract/openapi.yaml`. The 3.0.0-m1 `finish` body has never been seen on the wire.

### Implementation readiness

**Ready to start Phase 3.** Nothing found blocks work, and no finding requires a schema or model
change. The recommended first task (§13) is a documentation/instruction correction, not code —
because the instruction set is what a Phase 3 agent reads before it writes anything.

---

## 2. Repository Architecture Map

```text
contract/openapi.yaml  (3.0.0-m1, vendored, NEVER edited here)
        │  no codegen — models are hand-written freezed classes that TRANSCRIBE the schema.
        │  ⚠ nothing mechanical connects these two boxes. See §8.
        ▼
lib/core/config/app_config.dart        Flavor → baseUrl (staging host from the servers: block)
        ▼
lib/core/network/dio_client.dart       Dio + [AuthInterceptor, ErrorInterceptor]
        ├── interceptors/auth_interceptor.dart   Bearer; single-flight 401 refresh; replay-once
        └── interceptors/error_interceptor.dart  DioException → typed AppException hierarchy
        ▼
lib/features/*/repository/*.dart       the ONLY place that touches Dio. 6 repositories:
        auth · registration(+reference) · profile · catalog · quiz
        every method: try/catch DioException → AppException, plus an
        `on Object` arm wrapping decode failures (F-7-01 discipline)
        ▼
lib/features/*/models/*.dart           freezed + json_serializable. 24 models.
        QuizSummary · Quiz · AnswerResult · StudentProfile · EntitlementState ·
        Subject · SubjectTree(sealed) · School/UniversityRegistration · …
        ▼
state:  Riverpod everywhere  ──────────────  Bloc ONLY in lib/features/quiz/bloc/
        AsyncNotifier + `retry: _noRetry`     QuizBloc: typed events, strict state machine
        meProvider · entitlementsProvider     QuizInitial→Active→(AnswerFailed|FinishFailed)
        subjectsProvider · subjectTreeProvider                      →QuizCompleted
        quizSetupProvider · registration*
        ▼
lib/core/router/app_router.dart        go_router; StatefulShellRoute for the 5 tabs;
        no /subscription route exists (removed in 5c4b855)
        ▼
lib/features/*/screens/*.dart          every screen: loading / empty / error / offline, AR+EN
        ▼
lib/l10n/app_{en,ar}.arb               240 keys each, parity guard-enforced
```

**Side channels that matter to this audit:**

- `lib/dev/mock_backend.dart` — a full mock server **shipped inside `lib/`**. It drives
  `main_mock.dart` device runs *and* several tests. A drift here is invisible twice over.
- `tool/smoke/real_api_smoke_test.dart` — the live-staging harness. Deliberately outside `test/`
  so `flutter test` never makes a network call; therefore **never run by `validate.ps1` or CI**.
- `.claude/skills/*/SKILL.md` — auto-loaded instructions. Tracked. Mirrored untracked in `skills/`.

### The single most important structural fact

```text
Contract  ──✗ no mechanised link ✗──  Models · Fixtures · Mock backend
```

Every "shaped from `contract/openapi.yaml`" comment in the repository is a **human transcription
claim**, not a machine check. `git show 3db4f04` says so in its own commit body: *"No test reads
the contract, so this commit is green on its own."*

---

## 3. Contract Changes Detected

Derived by diffing `3db4f04^:contract/openapi.yaml` against HEAD directly, not read from the
changelog, then cross-checked against the changelog. **The changelog and the diff agree; no
contradiction was found between them.**

### 3.1 Schema changes — there is exactly one

| Change | Operation | Breaking? | Evidence |
| --- | --- | --- | --- |
| `QuizSummary.totalPoints` removed from `properties` **and** `required` | `finishQuiz` (200) | **yes** | `openapi.yaml:1652-1681`; `required` list at `:1681` |
| `QuizSummary.level` removed from `properties` **and** `required` | `finishQuiz` (200) | **yes** | same hunk |

Verified negatives, checked individually and found **unchanged**: every other schema's `required`
list; all 24 enum sites (no value added or removed); nullability (OpenAPI 3.1 `type: [x,"null"]`
unions — none moved); every query and path parameter; the `CursorPage` pagination shape; the
`bearerAuth` scheme and the 16 `security: []` public operations; the `ProblemDetails` envelope;
every surviving operation's response status-code set.

### 3.2 Path removal

| Change | Breaking? | Evidence |
| --- | --- | --- |
| `POST /checkout/sessions` (`createCheckoutSession`, was `x-stability: draft`) **deleted** | no (draft) | hunk `@@ -1133,50 +1183,11 @@` |
| `502 payment_initiation_failed` removed from the error registry | no | `error-codes.md` |

### 3.3 BEHAVIOURAL changes — zero build signal, zero codegen diff

| Change | Operations | Evidence |
| --- | --- | --- |
| **Catalog reads are no longer entitlement-gated.** Gate B is *relocated*, not weakened. `listSubjects` returns a strictly WIDER set; `getSubjectTree`'s `403` loses "entitlement lapsed" as a cause. | `listSubjects`, `getSubjectTree`, `listModules` | `openapi.yaml:788` — *"it does not consult entitlement state at all"* |
| **Entitlement is enforced at quiz creation.** An unsubscribed student may browse the whole catalog and build against the free allowance; exceeding it is `403 weekly_question_limit_reached`. | `createQuiz` | `:940-943` |
| `x-behaviour-changed` re-stamped `1.2.0-m1` → `2.3.0-m1` | the three above | `:776`, `:836`, `:924` |
| **Gate A (release) survives, UNIVERSITY-ONLY, fail-open.** *"School subjects are never release-gated (adr-073)."* | `listSubjects` | `:795-799` |

### 3.4 Server-only change with NO document change and NO stamp

**A replayed `POST /quizzes/{quizId}/answers` now returns `pointsDelta: 0`** (adr-102 D2).
`openapi.yaml` was not modified and `submitAnswer` carries no `x-behaviour-changed`, on the
reasoning that the published field text already said *"0 on retry replay"* (`:1649`) and the
server is what moved. **Consequence: an audit driven purely by `git show` of the contract misses
this entirely.** Verified inert in this client — see FINDING-15.

### 3.5 Product-behavioural changes delivered as prose edits

| Change | Why it matters |
| --- | --- |
| `error-codes.md`: `weekly_question_limit_reached` Notes "Paywall prompt" → *"Expected free-plan state, not a fault"* | A UI instruction **reversal** shipped as a Notes-column edit. |
| `getMyEntitlements` description drops *"refetch when the checkout deep link returns"* | There is no in-app checkout, so that moment no longer exists. Resume-only. |
| `x-consumers` added to 10 operations — 9 × `[mobile, web]`, 1 × **`[web]`** on `redeemSubscriptionCode` | The one operation the app must never build. Verified: it doesn't. |
| `insufficient_scope` Notes lose the "flashcard checkout for school student" clause | See FINDING-08 — this deleted the only machine-readable home of "flashcards are university-only". |

### 3.6 Full operation inventory

21 stable / 15 draft / 36 total. Stable operations, with client status:

| Path | Method | operationId | x-consumers | x-behaviour-changed | Client |
| --- | --- | --- | --- | --- | --- |
| `/auth/otp/request` | POST | requestOtp | `[mobile, web]` | — | ✅ |
| `/auth/otp/verify` | POST | verifyOtp | `[mobile, web]` | — | ✅ |
| `/auth/register` | POST | completeRegistration | *(mobile)* | — | ✅ |
| `/auth/refresh` | POST | refreshTokens | *(mobile)* | — | ✅ |
| `/auth/logout` | POST | logout | *(mobile)* | — | ✅ |
| `/reference/countries` | GET | listCountries | `[mobile, web]` | — | ✅ |
| `/reference/countries/{cc}/governorates` | GET | listGovernorates | `[mobile, web]` | — | ✅ |
| `/reference/cities` | GET | listCities | `[mobile, web]` | — | ✅ |
| `/reference/schools` | GET | searchSchools | `[mobile, web]` | — | ✅ |
| `/reference/education-systems` | GET | listEducationSystems | `[mobile, web]` | — | ✅ |
| `/reference/universities` | GET | listUniversities | `[mobile, web]` | — | ✅ |
| `/reference/avatars` | GET | listDefaultAvatars | `[mobile, web]` | — | ✅ |
| `/me` | GET | getMyProfile | *(mobile)* | — | ✅ |
| `/me` | PATCH | updateMyProfile | *(mobile)* | — | ✅ code, ⚠ unrunnable |
| `/me/entitlements` | GET | getMyEntitlements | *(mobile)* | — | ⚠ implemented, **never invoked** |
| `/catalog/subjects` | GET | listSubjects | *(mobile)* | **2.3.0-m1** | ✅ |
| `/catalog/subjects/{id}/tree` | GET | getSubjectTree | *(mobile)* | **2.3.0-m1** | ✅ |
| `/quizzes` | POST | createQuiz | *(mobile)* | **2.3.0-m1** | ✅ |
| `/quizzes/{id}/answers` | POST | submitAnswer | *(mobile)* | — (see §3.4) | ✅ |
| `/quizzes/{id}/finish` | POST | finishQuiz | *(mobile)* | — | ✅ |
| `/questions/{id}/explanation` | GET | getExplanation | *(mobile)* | — | ✅ |

The 15 `draft` operations are all correctly unimplemented. `POST /subscription-codes/redemptions`
is `draft` **and** `x-consumers: [web]` — doubly out of bounds, and not called.

---

## 4. Contract → Code Impact Matrix

| Contract/API area | Contract change | Flutter layer | File(s) | Current state | Required action | Severity | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `QuizSummary` | `totalPoints` removed | Model | `lib/features/quiz/models/quiz_summary.dart` | Field absent; generated files regenerated clean | **none — done** (`b7d0dfb`) | resolved | `quiz_summary.dart:25-70`; `.g.dart` has no `totalPoints` |
| `QuizSummary` | `level` removed | Model | same | Field absent | **none — done** | resolved | same |
| `QuizSummary` | standing relocates to `GET /me` | UI | `lib/features/quiz/screens/quiz_result_screen.dart` | The element was **deleted**, not re-sourced (owner ruling D-006). Screen is a `StatelessWidget` with no `ref`. | none now; the meter is a **design** question (DESIGN_ISSUES #50) | resolved | `quiz_result_screen.dart:27-31, 35` |
| `QuizSummary` | standing relocates to `GET /me` | State freshness | `lib/features/quiz/screens/quiz_screen.dart:219`, `lib/features/profile/notifier/me_notifier.dart` | `/me` invalidated on `QuizCompleted` only; **no app-resume refresh**; points are awarded at *answer* time | harden `/me` freshness | **MEDIUM** | FINDING-02 |
| `QuizSummary` | standing relocates to `GET /me` | Error state | `lib/features/home/screens/home_screen.dart:52-59` (+ profile, settings) | `.when()` routes a failed refetch to the error branch even with a cached profile | use `skipError`-aware mapping on the refresh path | **MEDIUM** | FINDING-03 |
| `QuizSummary` | `leveledUp`/`newBadge` are frozen EVENTS | Model + UI | `quiz_summary.dart:42-60` | Documented as frozen; parsed, not celebrated (D-002) | none; **never** recompute from two `/me` reads | resolved | `quiz_summary.dart:44-47` |
| `submitAnswer` | replay returns `pointsDelta: 0` (server-only) | Bloc/UI | `lib/features/quiz/bloc/quiz_bloc.dart:38` | `pointsDelta` is parsed and **rendered nowhere**; nothing sums it | none — inert. But the rule is **prose-only** | INFORMATIONAL | FINDING-15 |
| Purchase | `POST /checkout/sessions` deleted; app is purchase-silent | Routing | `lib/core/router/app_router.dart` | No `/subscription*` route; `lib/features/subscription/` is 4 × `.gitkeep` | **none — done** (`5c4b855`) | resolved | route list §4 of C's trace |
| Purchase | ditto | UI + l10n | `lib/features/quiz/widgets/limit_sheet.dart`, both ARBs | Title + body + one `TextButton` "Not now". EN **and AR** verified free of purchase language | **none — done** (`5c4b855`, `ce7da9a`) | resolved | `limit_sheet.dart:81-86` |
| Purchase | ditto | **Instructions** | `.claude/skills/{level-up-domain,river,screen-states,build-screen,seif-api-contract}/SKILL.md`, `F:\level\CLAUDE.md` | Still teach Paymob checkout + a Fawry `pending` state the contract denies | **correct the instruction set** | **HIGH** | FINDING-01 |
| Purchase | ditto | **Tests** | `test/features/quiz/quiz_setup_screen_test.dart` | Assertions are EN-only and structurally partial | add AR assertions + a mechanised guard | **MEDIUM** | FINDING-04, FINDING-05 |
| Purchase | ditto | Fix queue | `.ai/audits/current/known-issues.md:110` (K-3) | Prescribes building/disabling a screen the contract forbids, at 3 dead coordinates | retire K-3 | **MEDIUM** | FINDING-09 |
| Catalog | un-gated (2.3.0-m1, BEHAVIOURAL) | Notifier/UI | `lib/features/catalog/**` | **No** "empty ⇒ unsubscribed" heuristic anywhere. Empty copy is *"No subjects yet"* | none | resolved | `subjects_screen.dart:69`; `noSubjects` EN/AR |
| Catalog | `403` loses "entitlement lapsed"; remaining causes are scope (permanent) **and** un-release (reversible) | UI | `lib/features/catalog/widgets/catalog_states.dart:51-65` | Retry is suppressed because *"tapping retry would 403 again"*; copy says *"isn't part of your course"* | re-examine; ask Seif how to distinguish the two causes | **LOW** | FINDING-16 |
| Catalog | school subjects are **never** release-gated | Evidence/records | `.ai/audits/current/smoke-staging-2026-09-04.md:19`, `zna.md` | A **school** account's `[]` is explained by a **university-only** gate; the ask to Seif is university-shaped | correct the ask before sending | **MEDIUM** | FINDING-07 |
| Entitlements | `pending` does not exist; refetch on **resume** | Provider | `lib/features/profile/notifier/me_notifier.dart:55-78` | `entitlementsProvider` is **never built** in production → `AppLifecycleListener` never registers → the contract's resume-refetch is unimplemented | decide: wire it, or delete it and correct S8 | **MEDIUM** | FINDING-06 |
| Flashcards | "university-only" left the contract with `/checkout/sessions` | Records | `docs/seif_fight.md:177-186` | S6 still cites `openapi.yaml:1002`/`:1027` — both deleted | re-anchor or re-file with Seif | **MEDIUM** | FINDING-08 |
| Whole contract | pin moved 2.1.0-m1 → 3.0.0-m1 | Doc citations | 20 `openapi.yaml:NNN` anchors in `lib/` + bare `:NNNN` anchors in the registration models | **17 of 20 resolve to unrelated content.** Mixed provenance — see the finding | re-anchor; consider a guard | **LOW** | FINDING-11 |
| Whole contract | pin moved | Briefs | `docs/day7_quiz_brief.md`, `docs/day9_quiz_review_brief.md` | Day 7 documents the 10-field summary + the Upgrade CTA; **Day 9 — the next feature — pins 2.1.0-m1, names branch `dev`, and its one line citation was broken by this migration** | stamp both | **MEDIUM** | FINDING-10 |
| `PATCH /me` | unchanged at 3.0.0-m1 | Repo + mock | `profile_repository.dart:55`, `lib/dev/mock_backend.dart` | Client body correct incl. the email tri-state. **No mock handler**; staging 405 | seed a mock handler | **MEDIUM** | FINDING-13 |
| `submitAnswer` | award is immediate | Mock | `lib/dev/mock_backend.dart:670-672` | Mock moves the total only at **finish** — the opposite of the contract | correct the mock | **MEDIUM** | FINDING-12 |
| Everything | — | Tests | whole `test/` tree | **No test reads `contract/openapi.yaml`** | add a conformance guard | **MEDIUM** | FINDING-14 |

---

## 5. Endpoint Implementation Map

Status is **not** granted for a passing test. `READY` here means: client code matches the
3.0.0-m1 schema field-for-field, error codes are handled, and the path has been exercised
against **real staging**. `PARTIALLY IMPLEMENTED` means code is correct but a layer is missing.

| Endpoint | Contract | Client/Datasource | Repository | Model | Provider/Bloc | Screen(s) | Tests | Real API verified? | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `POST /auth/otp/request` | stable | dioProvider | `auth_repository.dart:29` | `OtpRequestResult` | `loginProvider` | login | ✅ | ✅ 2026-09-04 decoded | **READY** |
| `POST /auth/otp/verify` | stable | dioProvider | `:52` | `AuthResult` (union) | `otpProvider` | otp | ✅ | ✅ decoded | **READY** |
| `POST /auth/register` | stable | dioProvider | `registration_repository.dart:37` | `School/UniversityRegistration` | `registrationSubmitProvider` | wizard (5 screens) | ✅ | ⚠ arm skipped (number already registered) | **PARTIALLY IMPLEMENTED** — 6 per-resource `404`s unmapped (pre-existing, §7) |
| `POST /auth/refresh` | stable | bare refreshDio | `auth_repository.dart:81` | `TokenPair` | `AuthInterceptor` | — | ✅ | ✅ rotation observed | **READY** |
| `POST /auth/logout` | stable | dioProvider | `:107` | — | `AuthController` | settings, profile | ✅ | ✅ | **READY** |
| `GET /reference/countries` | stable | dioProvider | `reference_repository.dart:24` | `Country` | `countriesProvider` | school detail | ✅ | ✅ 4 rows | **READY** |
| `GET /reference/…/governorates` | stable | dioProvider | `:44` | `NamedRef` | `governoratesProvider` | school/uni detail | ✅ | ✅ 27 rows | **READY** |
| `GET /reference/cities` | stable | dioProvider | `:67` | `NamedRef` | `citiesProvider` | school/uni detail | ✅ | ✅ 42 rows + typed 400 | **READY** |
| `GET /reference/schools` | stable | dioProvider | `:97` | `CursorPage<NamedRef>` | `schoolSearchProvider` | school picker | ✅ | ✅ empty page | **READY** (dead duplicate `schoolsProvider`, §7) |
| `GET /reference/education-systems` | stable | dioProvider | `:133` | `EducationSystemRef` | `educationSystemsProvider` | school detail | ✅ | ✅ 5 rows | **READY** |
| `GET /reference/universities` | stable | dioProvider | `:153` | `UniversityRef` | `universitiesProvider` | uni detail | ✅ | ✅ 1 row | **READY** |
| `GET /reference/avatars` | stable | dioProvider | `:173` | `Avatar` | `avatarsProvider` | avatar sheet | ✅ | ✅ 20 rows | **READY** |
| `GET /me` | stable | dioProvider | `profile_repository.dart:25` | `StudentProfile` | `meProvider` | home, profile, settings, edit | ✅ | ✅ decoded (track: school) | **NEEDS CHANGE** — freshness, not shape (FINDING-02, -03) |
| `PATCH /me` | stable | dioProvider | `:55` | `ProfileUpdate` → `StudentProfile` | `editProfileProvider` | edit profile | ✅ (unit) | ❌ **405 `internal_error`** | **BLOCKED BY BACKEND** + no mock handler (FINDING-13) |
| `GET /me/entitlements` | stable | dioProvider | `:78` | `EntitlementsResponse` | `entitlementsProvider` | **none** | ✅ (container-only) | ❌ **404 `not_found`** | **NOT USED** (FINDING-06) |
| `GET /catalog/subjects` | stable | dioProvider | `catalog_repository.dart:24` | `Subject` | `subjectsProvider` | subjects | ✅ | ✅ `200 []` — contract-legal, **no data** | **PARTIALLY IMPLEMENTED** (unverified, not unimplemented) |
| `GET /catalog/subjects/{id}/tree` | stable | dioProvider | `:51` | `SubjectTree` (sealed) | `subjectTreeProvider` | units/chapters/lessons/lectures | ✅ | ❌ gated on empty catalog | **PARTIALLY IMPLEMENTED** (FINDING-16 on the 403 copy) |
| `POST /quizzes` | stable | dioProvider | `quiz_repository.dart:46` | `Quiz` | `quizSetupProvider` | quiz setup | ✅ | ❌ gated | **PARTIALLY IMPLEMENTED** — all three `403` codes handled; `400 validation_failed` falls to generic |
| `POST /quizzes/{id}/answers` | stable | dioProvider | `:86` | `AnswerResult` | `QuizBloc` | quiz | ✅ incl. replay | ❌ gated | **PARTIALLY IMPLEMENTED** |
| `POST /quizzes/{id}/finish` | stable | dioProvider | `:114` | `QuizSummary` **(3.0.0-m1)** | `QuizBloc` | quiz result | ✅ | ❌ **the 3.0.0-m1 body has never been seen on the wire** | **PARTIALLY IMPLEMENTED** — the headline unverified area |
| `GET /questions/{id}/explanation` | stable | dioProvider | `:148` | `ExplanationResult` | `QuizBloc` | AI panel | ✅ | ❌ gated | **PARTIALLY IMPLEMENTED** |
| all 15 `draft` operations | draft | — | — | — | — | — | — | — | **NOT USED** — correct |
| `POST /subscription-codes/redemptions` | draft + `[web]` | — | — | — | — | — | — | — | **NOT USED** — correct, and must stay that way |

---

## 6. Confirmed Findings

---

### [HIGH] FINDING-01 — The auto-loaded instruction set still teaches the deleted purchase product

**What changed.** Contract 2.2.0-m1 (adr-049) deleted `POST /checkout/sessions` and made the
mobile app purchase-silent. `getMyEntitlements`'s description states outright that no `pending`
state exists.

**Why it matters.** These files are not documentation a person may or may not open — they are the
instructions that load into every Claude Code session in this repository, and the
`level-up-domain` skill's own `description:` says to use it *"whenever working on ANY Level Up
feature, screen, model, prompt, or code review."* A Phase 3 implementer is told to build the
thing the contract deleted, before it reads a line of code.

**Exact files and symbols.**
- `.claude/skills/level-up-domain/SKILL.md:16` — *"**Payments are a hand-off.** The app opens the
  external Paymob web checkout via `url_launcher`, then re-fetches/polls subscription state."*
- `.claude/skills/level-up-domain/SKILL.md:15, 53` — Fawry `pending` as *"its own UI state
  ('Payment processing')"*
- `.claude/skills/river/SKILL.md:45` — *"`SubscriptionStatus` is sealed (`Active / Pending /
  Inactive`)"*
- `.claude/skills/screen-states/SKILL.md:19`, `.claude/skills/build-screen/SKILL.md:32`,
  `.claude/skills/seif-api-contract/SKILL.md:55` — the same `pending` claim
- **`F:\level\CLAUDE.md:11-12`** — under *"Operating rules (non-negotiable)"*:
  *"display what the API returns (including the Fawry `pending` subscription value)"* and
  *"Payments are a **hand-off** to the external Paymob web page"*
- The untracked `skills/` mirror is byte-identical (`diff -q` clean) — **do not edit it**, it is
  pre-existing untracked work.

**Contract evidence.** `contract/openapi.yaml:754` — *"Refetch on app resume. **There is no
`pending` state — an entitlement is active or it isn't.**"* `EntitlementState` (`:1533`) is
`required: [type, active, inGrace]`; no `pending` anywhere. `POST /checkout/sessions` is gone.

**Code evidence that the code already knows better.**
`lib/features/profile/models/entitlement_state.dart:14` — *"Note adr-020: card payments have NO
`pending` state."* The Dart is right; the instructions are wrong.

**Aggravating.** `docs/day9_quiz_review_brief.md:388-398` carries a section titled *"Four stale
claims inside those skills — this brief overrides them"*. It lists snake_case, `QuizTimeExpired`,
state names and vault paths. **It does not list Paymob or `pending`** — so a reader treats that
list as exhaustive and trusts everything else in the skills.

**User impact.** None today. The impact is on the next change: this is how a removed surface gets
rebuilt.

**Required action.** Correct the six `SKILL.md` files and the root `CLAUDE.md`. Cite
`openapi.yaml:754` and adr-049 §3.

**Test coverage.** None possible — these are prose files.

**Confidence: HIGH.** Every quotation above was read directly at HEAD by the lead agent.

---

### [MEDIUM] FINDING-02 — `/me` is refreshed on exactly one event, and points are awarded before it fires

**What changed.** adr-102 made `GET /me` the **only** place the student's points and level are
reported. The freshness of that one read now carries the whole feature.

**Why it matters.** The contract awards points **at answer time**, not at finish:
`openapi.yaml:1036` — *"Submit ONE answer — idempotent; returns correctness + **points delta
immediately**"*; `:1038-1039` — *"Points are awarded server-side only (+1 per correct)"*; and
adr-102 D2 in the changelog — *"the awarded point is already reflected in `pointsAwarded` at
finish **and in `GET /me`**"*.

**Exact files and symbols.**
- `lib/features/quiz/screens/quiz_screen.dart:219` — `ref.invalidate(meProvider)`, inside
  `case QuizCompleted(...)`. That is the **only** quiz-path trigger.
- Exiting mid-quiz (`_confirmExit`, `:234-256`) pops without touching `meProvider`.
- `lib/features/profile/notifier/me_notifier.dart:39` — `meProvider` is a plain (keepAlive)
  `AsyncNotifierProvider`.
- Invalidation sites in the whole of `lib/`: `edit_profile_notifier.dart:79` (after `PATCH /me`),
  `quiz_screen.dart:219`, `session_scope.dart:59` (logout). **That is all three.**
- **There is no app-resume refresh for `/me`.** The repository's single `AppLifecycleListener`
  is at `me_notifier.dart:58`, on `entitlementsProvider` — which never builds (FINDING-06).

**Failure scenario.** Home shows 120 pts / Level 1. Student starts a quiz, answers 5 correctly
(server total is now 125), taps X → "Leave". Home still reads 120 for the rest of the process
lifetime — corrected only by an unrelated `PATCH /me`, a logout, or an app restart. This
contradicts the project's own standing rule that the server is authoritative and the app displays
what the API returns.

**Required action.** Add a refresh trigger that does not depend on finishing: an app-resume
refetch of `meProvider`, and/or an invalidate on leaving a quiz that had at least one answer
submitted.

**Test coverage.** None. And it is **structurally masked** — see FINDING-12: the mock backend
moves the total only at finish, so neither a device walkthrough nor a widget test can surface it.

**Confidence: MEDIUM-HIGH on the code (verified by grep across `lib/`); the award-timing premise
is a HIGH-confidence contract reading that is UNOBSERVED on the wire.** See §9.

---

### [MEDIUM] FINDING-03 — The post-finish `/me` refetch discards a good profile on failure

**What changed.** The `ref.invalidate(meProvider)` at `quiz_screen.dart:219` exists *because* of
adr-102. It is a new-ish refresh on a network-fragile moment.

**Why it matters.** `AsyncValue.when` defaults to `skipError: false`, so a failed refetch routes
to the error branch **even though the previous value is retained**. (`skipLoadingOnRefresh`
defaults `true`, so there is no skeleton flash — only the error blanking.)

**Exact files and symbols.** `lib/features/home/screens/home_screen.dart:52-59`:

```dart
child: me.when(
  data: (profile) => _Loaded(profile: profile),
  loading: () => const _Skeleton(),
  error: (error, _) => _Failure(error: error, onRetry: ...),
),
```

Same shape at `lib/features/profile/screens/profile_screen.dart:56` and
`lib/features/settings/screens/settings_screen.dart:184`. Home stays mounted across the quiz
route (the shell page keeps its default `maintainState`), so it re-runs `build` the instant the
invalidate lands.

**Failure scenario.** Student finishes a quiz on a flaky connection. `POST /finish` returns 200,
the result screen renders correctly, the invalidate fires, the `/me` refetch times out — and
Home and the Account tab both flip to a full-screen error. The app has thrown away a profile
that was wrong about exactly two numbers.

**Required action.** On the refresh path, prefer the retained value and surface the failure
non-destructively (a banner or a stale marker) rather than replacing the whole screen.

**Test coverage.** `test/features/quiz/quiz_screen_test.dart:414` proves the refetch *happens*
with a healthy stub. There is no failing-refetch case.

**Confidence: HIGH** (mechanism verified in the riverpod source and at all three call sites).

---

### [MEDIUM] FINDING-04 — Arabic purchase-silence is never asserted

**What changed.** `ce7da9a` rewrote the limit-sheet bodies in both locales to remove upgrade
language (adr-049 §3, D-007).

**Why it matters.** Arabic is the baseline locale for this product, not an edge case.

**Exact files.** `test/features/quiz/quiz_setup_screen_test.dart:276-289` and `:311-317` — the
`find.textContaining('Upgrade' | 'Subscribe' | 'paid') → findsNothing` assertions run **only** in
the English-locale test cases. The `locale: 'ar'` group never repeats them and never asserts the
Arabic strings.

**Current state — verified correct today.** The lead agent parsed both ARBs directly:
`weeklyLimitBody` AR = *"استخدمت كل أسئلتك لهذا الأسبوع."*; `subscriptionRequiredBody` AR =
*"هذا الدرس يحتاج إلى اشتراك فعّال."*; a scan of all 240 AR values for
`اشترك / ترقية / ادفع / شراء / بريميوم / باقة` returned **zero** hits. ARB parity is exact
(240 keys each, no key in one file only).

**So this is a coverage gap, not a live defect** — and that is precisely the risk: a future
mistranslation reintroducing purchase language in Arabic would ship green.

**Required action.** Mirror the EN assertions into the `locale: 'ar'` group and assert the two AR
bodies verbatim.

**Confidence: HIGH.**

---

### [MEDIUM] FINDING-05 — Purchase-silence has no mechanised guard, and the widget assertion is weaker than it reads

**What changed.** adr-049 §3 is the project's newest high-stakes rule.

**Why it matters.** `CLAUDE.md` rule 3: *"Prose rules decay; mechanised rules hold… When you
write a new rule, ask first whether it can be a test."* The guard set in `test/guards/rules.dart`
is `blocOutsideQuiz`, `providerMutationInInitState`,
`autoDisposeNotifiersWithoutDisposalFlag`, `rawTextLiterals`, `hardcodedFontSizeCount`, plus ARB
parity. **No guard forbids a purchase surface.**

**Code evidence.** What exists instead is this, at
`test/features/quiz/quiz_setup_screen_test.dart:284-289`:

```dart
expect(
  find.descendant(of: find.byType(LimitSheet), matching: find.byType(FilledButton)),
  findsNothing,
);
```

`LimitSheet`'s only action is a **`TextButton`** (`limit_sheet.dart:83`). So the assertion is
**partial, not vacuous** — it would catch a `FilledButton` CTA, but a `TextButton` CTA whose
label avoids the three watched words passes every assertion in the file. Combined with FINDING-01
(instructions that actively describe building the checkout), nothing mechanical stands between a
Phase 3 agent and reintroducing the surface.

**Required action.** A ~10-line grep guard over `lib/` for `checkout|paymob|fawry|upgrade|premium|
price|voucher|redeem`, in the existing `test/guards/rules.dart` style, with a proof-it-can-fail
case in `verify_guards.ps1`. Also assert no `/subscription*` path is registered in the router.

**Confidence: HIGH.**

---

### [MEDIUM] FINDING-06 — `GET /me/entitlements` is dead in production; the contract's resume-refetch never runs

**What changed.** 2.2.0-m1 rewrote this operation from *"the paywall signal"* to *"the entitlement
source of truth"* and replaced the deep-link-return refetch with **resume-only**.

**Exact files and symbols.** `lib/features/profile/notifier/me_notifier.dart:55-78`:

```dart
Future<List<EntitlementState>> build() {
  final listener = AppLifecycleListener(onResume: refresh);   // :58
  ref.onDispose(listener.dispose);
  return ref.watch(profileRepositoryProvider).getEntitlements();
}
```

Nothing in `lib/` watches or reads `entitlementsProvider`. Its only production reference is
`ref.invalidate(entitlementsProvider)` at `lib/core/session/session_scope.dart:60` — and
Riverpod's `invalidate` is a **no-op on a provider with no live element**. So `build()` never
runs, the lifecycle listener is never registered, and `ProfileRepository.getEntitlements()` is
dead code in production.

**Consequences.**
1. The staging `404` has no path to any screen — the app is genuinely unaffected today.
2. The contract's *"Refetch on app resume"* (`openapi.yaml:754`) is **not implemented in effect**.
3. `docs/seif_fight.md:239` is now factually wrong: it claims the S8 stance *"survives as the
   on-resume refetch of `GET /me/entitlements`, which is the only entitlement signal the app now
   acts on."* The app acts on **no** entitlement signal — only the `403` codes at `POST /quizzes`.

**Arguably correct by accident.** adr-091 moved the gate to quiz creation, so the 403 codes *are*
the right live signal. But the notifier carries a lifecycle listener nobody runs, and a
documented mitigation that has never executed.

**Test coverage is the trap.** `test/features/profile/me_notifier_test.dart:121-170` and
`test/core/session/session_isolation_test.dart:155` build the provider **directly in a
`ProviderContainer`**, so the suite proves the notifier works while the app never uses it.

**Required action.** An owner decision: wire it (a resume refetch on `meProvider` would serve the
same purpose more usefully), or delete it and correct S8. Do not leave it as-is silently.

**Confidence: HIGH.** Independently reached by two subagents and re-verified by the lead.

---

### [MEDIUM] FINDING-07 — The staging evidence explains a *school* account's empty catalog with a *university-only* gate, and the ask to Seif inherits the error

**Why it matters.** This is the one blocker on exercising the quiz loop — and therefore on ever
seeing the 3.0.0-m1 `finish` body on the wire. A wrong ask costs a round trip.

**The contradiction, both sides quoted.**

- `.ai/audits/current/smoke-staging-2026-09-04.md:19` states, in one row: `GET /me` →
  `StudentProfile` (**track: school**) … `GET /catalog/subjects` → `200 []` — *"an empty list is a
  contract-legal state for **an account with no released subjects**"*. The verbatim output at
  `:121` confirms `track: Track.school`.
- `contract/openapi.yaml:795-799`: *"**Gate A — release — survives unchanged and remains
  UNIVERSITY-ONLY** … **School subjects are never release-gated (adr-073).**"*
- `contract/contract-changelog.md` attaches the `[]` explanation specifically to *"a university
  student registering before their Term 1 start date."*
- `zna.md` then carries it into the ask: *"**Seed a released term for `+2010000000001`** so
  `POST /quizzes` has questions to draw."* `+2010000000001` is the **school** test account.

For a school account after adr-091 the catalog consults neither release nor entitlement — only
enrolment scope. So `[]` here cannot mean "no released subjects"; it means no subjects are seeded
under that account's stage / education-system cohort.

**Required action.** Correct the smoke report's explanatory clause and re-word the ask to Seif to
*"seed subjects for the school cohort of `+2010000000001`"* — or register a university test
account, for which "seed a released term" is the right ask.

**Confidence: HIGH.** All four quotations re-read by the lead agent at HEAD.

---

### [MEDIUM] FINDING-08 — "Flashcards are university-only" left the contract with `/checkout/sessions`

**What changed.** 2.2.0-m1 deleted the checkout path, and 3.0.0-m1's registry edit dropped the
*"flashcard checkout for school student"* clause from `insufficient_scope`'s Notes.

**Contract evidence, counted.** At the **previous pin**, `flashcard` appeared **3×** in
`openapi.yaml`: `:1146` (*"School students requesting flashcardSubscription get
`insufficient_scope` (university-only)"*), `:1171` (the matching 403), `:1521` (the enum value).
At **3.0.0-m1** it appears **once** — `:1532`, the bare enum value. The two occurrences carrying
the university-only constraint went with the deleted path.

**Where the constraint now lives.** Only `contract/error-codes.md:15`'s Notes column
(*"University-only"*) — and the changelog says of that file that it is *"prose for humans and is
never machine-read."*

**Why it matters for the app.** `docs/seif_fight.md:177-186` (S6, flashcards) builds its entire
argument on `openapi.yaml:1342`, `:1002` and `:1027`. Two of those three lines no longer exist,
and the surviving one is just the enum. The doc-reconciliation commit `7e7129c` updated S3, S8,
S18, S37 and S38 in that same file and left S6 untouched.

**Required action.** Re-anchor S6, and ask Seif whether the university-only constraint should be
restated on a surviving operation now that its only home was a deleted draft path.

**Confidence: HIGH** (occurrence counts run against both revisions).

---

### [MEDIUM] FINDING-09 — The fix queue prescribes building a screen the contract forbids

**Exact file.** `.ai/audits/current/known-issues.md:110`, Tier 1 (user-visible defects) — a file
`CLAUDE.md` names as *"The ordered fix queue"*:

> | K-3 | `/subscription` dead-end reachable from the quiz paywall — hardcoded English, unthemed |
> `limit_sheet.dart:123` → `app_router.dart:250,347` | Disable the entry point (mirror how
> Profile's was disabled), **or build the screen**. Small either way. |

**Why it is wrong now.** All three coordinates are dead: `limit_sheet.dart` is 92 lines;
`app_router.dart` is 365 and both `/subscription` routes were deleted in `5c4b855`. Both
prescribed remedies are also wrong — "mirror how Profile's was disabled" points at a row `5c4b855`
also removed, and "build the screen" is forbidden by adr-049 §3.

**Required action.** Retire K-3 with a pointer to D-007.

**Confidence: HIGH.**

---

### [MEDIUM] FINDING-10 — Two day-briefs will mislead Phase 3, and one of them is the next feature's brief

**`docs/day9_quiz_review_brief.md` — the brief Phase 3 picks up.** `docs/WAVE_STATUS.md` lists
"Day 9 quiz review" under *"Deliberately not done in this wave."*

- `:4-5` — *"Contract: `contract/openapi.yaml` **pinned `61905ce` (v2.1.0-m1)**"*. The pin is
  `184d6ec` / `3.0.0-m1`.
- `:3` — *"branch `dev`"*. All work is on `merged`.
- `:77` — *"`QuizReview` (`contract/openapi.yaml:1675`)"*. **This citation was correct at
  2.1.0-m1 and was broken by this migration**: line 1675 was `QuizReview:` then, is `type: object`
  now; `QuizReview` is at `:1693`.
- `CLAUDE.md`'s rule *"contract references in every brief **before Day 7c** are stale"* gives this
  brief a **false clean bill of health** — Day 9 is after Day 7c.

**`docs/day7_quiz_brief.md` — the quiz brief.**
- `:233-238` documents the **ten-field** `QuizSummary`, including `totalPoints` and `level`, with
  *"required: ALL TEN"*.
- `:109-110` — *"Render `QuizSummary.pointsAwarded` and `totalPoints` verbatim from `finish`."*
- `:32-33` — *"The limit sheet's 'Upgrade' CTA routes to the existing `/subscription`
  placeholder."*

**Required action.** Stamp both briefs with a superseded-by header pointing at `WAVE_STATUS.md`
and D-006/D-007.

**Confidence: HIGH** (line 1675 compared against both revisions directly).

---

### [LOW] FINDING-11 — 17 of 20 `openapi.yaml:NNN` citations in `lib/` resolve to unrelated content

**This finding is the lead agent's adjudication of a direct contradiction between two subagents**
(see §10). Resolved by scripting every citation against both contract revisions.

**Result.** 20 prefixed `openapi.yaml:NNN` citations exist in non-generated `lib/`. All 20 point
at a different line than they did at the previous pin. Of those:

- **3 are correct today** — `app_config.dart:38` → `:85` (the `servers:` URL),
  `quiz_summary.dart:6` → `:1652` (`QuizSummary:`), `quiz_summary.dart:111` → `:1671`
  (`questions:`). All three were fixed deliberately in `b7d0dfb`.
- **17 resolve to unrelated content.** Examples verified line by line:
  `profile_update.dart:5` cites `:601-624` for the `PATCH /me` body → now `nameEn: {type: string}`;
  `student_profile.dart:93` cites `:1349` for `required: [countryCode, city]` → now `deviceId:`;
  `quiz.dart:10` cites `:1426` for the `Quiz` schema → now a `cityId` description;
  `registration_body.dart:66,100` cite `:1272-1273` → now leaderboard query params.

**The provenance is mixed, and both subagents got half of it.**

- Most were **already stale at the 2.1.0-m1 pin** — e.g. `profile_update.dart:5`'s `:601` was
  `security: []` then, not the PATCH body. Those date from an older contract and this migration
  did not break them.
- Some **were correct at 2.1.0-m1 and were broken by this migration** — the registration models
  use bare `` `:NNNN` `` anchors: `school_registration.dart:15` cites `:1406` for
  *"`required: [track, registrationToken, device, name, dateOfBirth, countryCode, …]`"*, and at
  the previous pin line 1406 was **exactly that list**. It is now `dateOfBirth:`.

**Why it matters.** A Phase 3 implementer navigates by these anchors. Sending them to the wrong
schema is how a wrong shape gets "confirmed against the contract."

**Required action.** Re-anchor. Better: this is mechanisable — a guard that resolves each citation
and asserts the target line contains the named schema/path key would hold where the prose has not.

**Confidence: HIGH** (scripted against both revisions; script kept in the session scratchpad).

---

### [MEDIUM] FINDING-12 — The dev mock awards points at *finish*; the contract awards them at *answer*

**Exact file.** `lib/dev/mock_backend.dart:670-672`, inside `_finishQuiz`:

```dart
final before = _totalPoints;
// +1 per correct, server-side — the ONLY place points are decided.
_totalPoints += score;
```

`_submitAnswer` (`:639-646`) correctly returns `pointsDelta: replay ? 0 : (correct ? 1 : 0)` —
but never moves `_totalPoints`. So the mock's `GET /me` does not reflect an awarded point until
the quiz is finished.

**Contract evidence.** `openapi.yaml:1036` — *"returns correctness + points delta immediately"*;
`:1038` — *"Points are awarded server-side only (+1 per correct)"*.

**Why it matters.** This is what makes FINDING-02 invisible: on device, through the mock, an
abandoned quiz genuinely awards nothing, so the staleness never appears. The mock encodes the
opposite of the contract at the exact point the audit needs it to be faithful.

**Required action.** Move the award into `_submitAnswer` and keep `finish` idempotent, **after**
FINDING-02's award-timing question is answered by Seif or by staging (§9).

**Confidence: HIGH on the code; MEDIUM-HIGH on the contract reading** (see §9).

---

### [MEDIUM] FINDING-13 — `PATCH /me` has no runnable environment anywhere

**Exact files.** `lib/dev/mock_backend.dart` handles `GET /me` (`:193`) and `GET /me/entitlements`
(`:215`) — there is **no `PATCH /me` handler**, so it falls through to the catch-all
`404 not_found` (`:355-364`). Staging answers **`405 internal_error`**
(`.ai/audits/current/smoke-staging-2026-09-04.md`, unchanged since 2026-08-23).

**Consequence.** A `stable` operation whose client code is verified correct — including the email
tri-state (explicit JSON `null` = *clear it*, which no interceptor or serializer in the path may
strip) — **cannot be exercised successfully on staging or on device.** Edit Profile's success path
has never run end to end.

**Also.** `ErrorInterceptor` maps a 405 with a non-ProblemDetails body to
`ApiException(status: 405, code: 'unknown')` → `l10n.genericError`. That is contract-correct
client behaviour (405 is undocumented on this operation) and is recorded here only so it is not
mistaken for a client bug.

**Required action.** Add a mock `PATCH /me` handler (test-infrastructure only). Staging's 405 is
already filed as `seif_fight` S37.

**Confidence: HIGH.**

---

### [MEDIUM] FINDING-14 — Nothing mechanical connects the contract to the code

**Evidence.** Zero tests read `contract/openapi.yaml`. There is no `yaml` dependency in
`pubspec.yaml`. `git show 3db4f04` (the pure contract-file commit) states it plainly: *"No test
reads the contract, so this commit is green on its own."* The five guard rules cover Bloc
placement, `initState` mutation, `autoDispose` disposal flags, raw text literals and hardcoded
font sizes, plus ARB parity — **none touches contract conformance.**

**Scenario that slips through 862/0.** A future re-vendor renames a field. `json_serializable`
produces a null/default rather than erroring; the hand-typed fixtures still carry the old key;
the mock still emits the old shape. The suite stays green and the app is broken on the wire.

**Required action.** A conformance guard in the project's own guard style: parse
`contract/openapi.yaml`, extract each schema's `required` list, and assert the fixture builders in
`test/features/**/\*_fixtures.dart` and the mock's emitted bodies carry exactly those keys. This is
the single highest-leverage test in the Phase 3 queue and it directly obeys `CLAUDE.md` rule 3.

**Confidence: HIGH.**

---

### [INFORMATIONAL] FINDING-15 — `pointsDelta: 0` on replay is inert here, but the rule that makes it inert is prose-only

**Verified.** `pointsDelta` appears in exactly two non-generated places in `lib/`:
`answer_result.dart:40` (the model field) and `mock_backend.dart:643`. **Nothing renders it, sums
it, previews it, or reconciles it against `pointsAwarded`.** `quiz_bloc.dart:38` states the rule:
*"It never grades, never sums `pointsDelta`, never derives a score or a verdict."*

**The two replay paths were both traced.**
1. `AuthInterceptor` (`auth_interceptor.dart:104-113`) replays **any** method and **any** path,
   once, after a successful refresh. **This is not the adr-102 D2 case** — a 401 means the server
   never processed the original, so the replay is the *first* award, not a server-side replay.
2. `AnswerRetried` (`quiz_bloc.dart:113-120`, wired at `quiz_screen.dart:187`) is a true
   user-tapped replay and **does** now return `pointsDelta: 0`. Harmless, because it is not shown.

**Risk to record.** "Never render `pointsDelta`" has no guard. Per `CLAUDE.md` rule 3, that is
exactly the class of rule this repository has watched decay. Fold it into FINDING-05's guard.

---

### [LOW] FINDING-16 — The subject-tree `403` suppresses retry on reasoning the contract narrowed

**Exact file.** `lib/features/catalog/widgets/catalog_states.dart:51-54, 63-65`:

```dart
// `insufficient_scope` (403) means this subject is not in the student's
// server-derived scope — tapping retry would 403 again, so no retry button.
…
onRetry: scopeError ? null : onRetry,
```

**Contract evidence.** `openapi.yaml:843-849`: the 403 now has exactly two causes — the subject
*"fell outside the caller's enrolment scope"* (permanent) **or** *"the admin **un-released** its
term for the cohort"* (reversible). *"Clients holding a cached `subjectId` must still handle that
403 as a normal state, not a bug."* The copy — `subjectUnavailable` = *"This subject isn't part of
your course."* / *"هذه المادة ليست ضمن مقررك."* — is also wrong for the un-release case: the
subject **is** part of their course, it just isn't released yet.

**Honest attribution.** This is **pre-existing**, not caused by 3.0.0-m1 — the un-release cause was
already in the 1.2.0-m1 note at the previous pin. What 2.3.0-m1 changed is that it *removed* the
third cause (lapsed entitlement), which made the client's copy **more** accurate, not less.
Recorded because it is contract-connected and squarely in the un-gating blast radius.

**Required action.** The contract offers no discriminator between the two causes — same code, no
field. Per rule 4, do not invent one: file a `seif_fight` question.

---

### [LOW] Finding cluster — stale in-code and in-tool prose (nine items, all verified at HEAD)

None of these change behaviour. All of them will mislead a Phase 3 reader.

| # | File:line | What it says | What is true now |
| --- | --- | --- | --- |
| 17 | `lib/dev/mock_backend.dart:15-18` | *"pinned `ee2ed8f`, v1.1.0-m1"* | pin is `184d6ec`, 3.0.0-m1. The *bodies* were updated by `b7d0dfb` (`:653` cites 3.0.0-m1 correctly); only the header lagged. |
| 18 | `lib/core/session/session_scope.dart:63` | *"Catalogue: scoped to the student's track/entitlements"* | adr-091: the catalog *"does not consult entitlement state at all"* (`openapi.yaml:788`). The invalidation is still right; the stated reason is not. |
| 19 | `lib/features/quiz/bloc/quiz_bloc.dart:41-43` | invalidating `/me` after finish *"is the result screen's job"* | It is `quiz_screen.dart:219`. Whoever builds the DESIGN_ISSUES #50 meter will look in the wrong file. |
| 20 | `lib/features/quiz/repository/quiz_repository.dart:76` | *"a retry returns the ORIGINAL grade"* | True for verdict and `correctOptionId`; `pointsDelta` is now `0` (adr-102 D2, `seif_fight` S18 closed). |
| 21 | `lib/features/home/widgets/level_card.dart:8-15` | `TODO(contract)`: *"confirm level thresholds with Seif — `GET /me` returns `level` and `points` but NOT the threshold"* | `seif_fight` S3 was **closed 2026-09-04**: `StudentProfile.level`'s own description (`openapi.yaml:1514`) says *"1–12, thresholds every 500 points; static, not configurable."* |
| 22 | `lib/l10n/app_en.arb:491` → generated `app_localizations.dart:1325` | *"the same call made for `upgradeCta`"* | `upgradeCta` was deleted in `5c4b855`. The one thread the purchase sweep left. (The *key* is correctly absent from both ARBs — only this textual reference survives.) |
| 23 | `tool/smoke/real_api_smoke_test.dart:507-509` | *"contract-legal (v2.1: pre-term accounts)"*; and on the explanation probe, *"a 403 without base_subscription is contract-expected"* | Cites a superseded version; and `getExplanation`'s 403 is documented as *"question not yet answered by the caller"* (`:1127`) — entitlement is not a documented cause there, and after adr-091 is enforced at quiz creation. |
| 24 | `lib/l10n/app_{en,ar}.arb` `subscriptionRequiredBody` | *"This **lesson** needs an active subscription."* | `LimitSheet` serves the university frames too (`limit_sheet.dart:7-8`) and branches only on `code`, never on `track`. A university student's scope is a **lecture**. `DESIGN_ISSUES.md:329-333` records the same noun-by-track problem elsewhere. `ce7da9a` rewrote this string and carried the noun through; `zna.md` ships it to the designer as approved-pending. |

**One more, forward-looking.** DESIGN_ISSUES #50 and the changelog both record the deferred
result-screen meter's formula as `(points.total mod 500) / 500`. That formula **wraps past level
12**, where students keep earning points but stop earning levels. `lib/features/home/widgets/
level_card.dart:31-35` already handles this correctly (`if (level >= kMaxLevel) return 1;` and
`totalPoints - (level - 1) * kPointsPerLevel`). **Phase 3 must reuse `levelProgressFraction`, not
transcribe the changelog formula**, or the result screen and Home will disagree for the app's
strongest students.

---

## 7. Already Resolved Findings — do not re-open

| Item | Resolved by |
| --- | --- |
| `QuizSummary` drops `totalPoints` / `level`; freezed + `.g.dart` regenerated clean; fixtures follow; a test added proving a 2.x body still parses (unknown keys ignored) and does not round-trip them | `b7d0dfb` |
| The result screen stops drawing *"Level N · P points"* (owner ruling D-006); ARB keys `resultLevelProgress` and `levelAndPoints` deleted from both locales | `b7d0dfb` |
| Mock `finish` stops emitting the two keys; its idempotency test now reads `/me` for the live total rather than the summary | `b7d0dfb` |
| `meProvider` invalidated on `QuizCompleted`, with a real regression test (`quiz_screen_test.dart:414`, `verify(...).called(1)` before and after) | Day 7 + `b7d0dfb` |
| Purchase surface removed: Upgrade button, benefits card, `/subscription` and `/subscription/return` routes, the Profile row, six ARB keys | `5c4b855` |
| Limit-sheet bodies stop telling the student to upgrade, in **both** locales (D-007) | `ce7da9a` |
| `app_config.dart`'s `servers:` citation updated to the 3.0.0-m1 line | `b7d0dfb` |
| `seif_fight` S3 (`level` has no threshold) — answered by the contract's own field description | `7e7129c` |
| `seif_fight` S18 (`pointsDelta` on retry: original or 0?) — adr-102 D2 rules 0; the mock already did it | `7e7129c` |
| R-6 (`/subscription` unbuilt screen on the revenue path) — decided by the contract: removed, not built | `7e7129c` |
| `DESIGN_ISSUES` #50/#51, `DECISIONS` D-006/D-007, `RISKS`, `WAVE_STATUS`, the smoke evidence | `7e7129c` |

**Verified clean by more than one workstream** (well-evidenced negatives, recorded so they are not
re-audited): generated-code drift — every `const factory` field list compared against its `.g.dart`
and `.freezed.dart`, **zero real mismatches** across 16 + 18 generated files, no hand-edit
fingerprints; model requiredness — every schema `required` list compared against the Dart models,
**exact match in both directions**, no "required in Dart, optional in contract" landmine; l10n
orphans from the purchase sweep — all eight deleted keys gone from both ARBs, only
`correctAnswerRevealed` remains orphaned and it predates the migration by two months; Android/iOS
config — no Paymob URL scheme was ever registered, so deleting `/subscription/return` left no
native orphan; `assets/` — no purchase artwork; the mock's catalog — gated on track/id only, never
on entitlement, with `subscription_required` emitted from the quiz-creation path exactly where
adr-091 put it.

---

## 8. False Confidence / Test Gaps

862 passing tests is **largely meaningful** — the migration's own additions are unusually rigorous,
asserting rendered content (`quiz_result_screen_test.dart:140-146` checks
`find.textContaining(RegExp(r'\d+ points')) → findsNothing`) and real mock-invocation counts, not
"does it build". The gaps below are **structural**, not sloppy.

| # | Risk | Why green ≠ correct | Concrete scenario that slips through |
| --- | --- | --- | --- |
| 1 | **Nothing in the suite reads the contract** | Every "shaped from openapi.yaml" comment is a transcription claim | A re-vendor renames a field; `json_serializable` yields a default rather than erroring; fixtures and the mock keep the old key; suite green, app broken |
| 2 | **The 3.0.0-m1 `finish` body has never been observed** | `WAVE_STATUS.md` says so itself; the harness cannot reach `finish` with an empty catalog | The live backend's `finish` differs from the vendored contract in a way SOURCE review missed — no test can catch it |
| 3 | **Arabic purchase-silence is unasserted** | The `Upgrade`/`Subscribe`/`paid` checks run only in EN cases | A mistranslation reintroduces purchase language in the language most users read; full suite green |
| 4 | **The purchase-silence widget assertion is partial** | `find.byType(FilledButton)` inside a sheet whose only action is a `TextButton` | A `TextButton` CTA labelled e.g. "Get more questions" passes every assertion in the file |
| 5 | **`entitlementsProvider` is tested in a `ProviderContainer`, never through the app** | Container tests prove the notifier works; they cannot prove anything builds it | Dead production code with full green coverage (FINDING-06) — the exact shape that hides it |
| 6 | **The mock encodes the wrong award timing** | The mock is the device-walkthrough backend and several tests' backend | FINDING-02 is unobservable on device *by construction* |
| 7 | **`PATCH /me` has no successful path anywhere** | Unit tests stub the Dio call | The email tri-state — the one place explicit JSON `null` is correct — has never round-tripped against a real server |
| 8 | **No router-level guard against a purchase route** | Only two widget call-sites are asserted | Someone re-registers `/subscription`; nothing fails |
| 9 | **The "never render `pointsDelta`" rule is prose** | No guard | A future "+1" animation on answer submit would show `+0` on every retry |

---

## 9. Backend-Blocked Verification

**Separated deliberately. None of these is a client bug.**

### A. Client implemented, staging cannot verify (data, not code)

| Area | State |
| --- | --- |
| `GET /catalog/subjects/{id}/tree`, `POST /quizzes`, `POST /quizzes/{id}/answers`, **`POST /quizzes/{id}/finish`**, `GET /questions/{id}/explanation` | The whole quiz loop is gated on a non-empty catalog for the test account. `GET /catalog/subjects` now returns `200 []` — the route is deployed and the empty list is contract-legal. **This is "not verified", not "not implemented."** |
| **The 3.0.0-m1 `finish` body** | **Never observed on the wire.** The client accepts both the 2.x and 3.x shapes (json_serializable ignores unknown keys, and a test proves it), so nothing depends on the observation — but it remains the single biggest unverified fact of this migration. |

**Blocker:** seed data for the test account — and see **FINDING-07**, the ask currently in `zna.md`
is university-shaped for a school account.

### B. Backend endpoint unavailable

| Endpoint | Staging | Filed as |
| --- | --- | --- |
| `PATCH /me` | `405 internal_error` (unchanged since 2026-08-23) | `seif_fight` S37 |
| `GET /me/entitlements` | `404 not_found` (unchanged since 2026-08-23) | `seif_fight` S37 |

Both are `x-stability: stable` in 3.0.0-m1. **The client is correct for both.** The
entitlements 404 additionally cannot reach any screen (FINDING-06), so it is invisible at runtime
today. Do not classify either as a client defect.

### C. Contract ambiguity — open questions, not bugs

1. **When is a point actually credited — at `submitAnswer` or at `finish`?** The contract says
   *immediately* at submit (`:1036-1039`) and adr-102 D2 says the point *"is already reflected …
   in `GET /me`"*. That is a strong reading, but it is **UNOBSERVED**, and the repository's own
   mock encodes the opposite. FINDING-02 and FINDING-12 both hinge on it. **Ask Seif, or observe
   it once the catalog is seeded. Do not "fix" the mock until this is settled.**
2. **`createQuiz`'s `403` lists three codes** (`weekly_question_limit_reached` ·
   `subscription_required` · `insufficient_scope`) with no stated way to tell them apart, and
   after adr-091 it is genuinely unclear when an unsubscribed student gets `subscription_required`
   rather than the allowance. The client handles all three, so nothing is broken — but the
   distinction is not derivable. Candidate `seif_fight` entry.
3. **`getSubjectTree`'s `403` has two causes with one code** and no discriminator (FINDING-16).
4. **Where does "flashcards are university-only" live now** that its only machine-readable home
   was deleted (FINDING-08)?

### D. Provenance caveat, quoted from the repository's own record

`contract/SOURCE.md`: staging serves backend `78c6e5d`, built **after** the mirror commit, but the
backend repo is private *"and the ancestry could not be checked from outside it."* **Whether
staging serves the 3.0.0-m1 `QuizSummary` is UNOBSERVED.**

---

## 10. Agent Findings Review

Six subagents ran independently and in parallel. **Model note, stated for auditability:** the
harness exposes four model selectors to the Agent tool — `opus`, `sonnet`, `haiku`, `fable`. The
specific point releases named in the brief (Opus 4.8 / Opus 4.7) are **not selectable from this
session**, so the deep-investigation workstreams ran on `opus` and the broad-inventory
workstreams on `sonnet`. Lead/adjudication was Opus 5 throughout.

| Agent | Model | Workstream | Findings | Confirmed | Corrected | Rejected | Notes |
| --- | --- | --- | ---: | --- : | --- : | --- : | --- |
| **A** | opus | Contract/schema diff | 20 changes + 9 forward notes | 20 | 2 | 1 | Re-derived the delta with two independent filtered diffs rather than trusting the commit message. Best artefact: the operation inventory. |
| **B** | opus | API/data-layer trace | 14 | 9 | 3 | 2 | The only agent to produce a complete endpoint→layer table. Also the only one to catch the missing mock `PATCH /me`. |
| **C** | sonnet | UI/feature impact | 0 open (clean report) | — | 1 | — | A well-evidenced negative: traced all three changes into the UI and found no reachable violation. Independently confirmed by the lead. |
| **D** | sonnet | Tests/mocks/fixtures | 5 risks + 5 gaps | 5 | 0 | 0 | Strongest section: the false-confidence analysis. Correctly refused to equate green with correct. |
| **E** | opus | Architecture/session/error state | 8 | 6 | 0 | 0 | Opened by **rejecting its own brief's premise** — the result screen has no `GET /me` dependency. Verified the riverpod source rather than assuming. Found E-1/E-2/E-4. |
| **F** | opus | Adversarial | 9 + a "found nothing" section | 8 | 1 | 0 | Highest-value agent. Went where none of the others could: `.claude/skills/`, the day-briefs, `known-issues.md`, the smoke report. Found FINDING-01. |

### Useful findings by agent

- **A** — the full 36-operation inventory with `x-stability` / `x-consumers` / `x-behaviour-changed`;
  the systematic negatives (enums, nullability, parameters, pagination, security, status codes — all
  unchanged); the observation that the *changelog* and the *diff* agree, so there is no contract
  self-contradiction; and the §3.4 trap — a real behaviour change (`pointsDelta: 0`) with no
  document change and therefore no diff signal.
- **B** — the endpoint→layer table; the missing mock `PATCH /me` handler; the `entitlementsProvider`
  dead path (independently, before E); the stale `session_scope.dart:63` comment; the dead
  `schoolsProvider`; verifying dio's `assureResponse<T>` re-cast so the 401-replay path is type-safe.
- **C** — a clean, quotable negative on the UI: the exact current EN **and AR** limit-sheet strings,
  the full route list, and confirmation that `lib/features/subscription/` is four `.gitkeep` files.
- **D** — the false-confidence ranking; catching that the AR-locale test group never repeats the
  purchase-silence assertions; and finding the commit body that admits no test reads the contract.
- **E** — the `/me` invalidation trace (all three sites in `lib/`); the `skipError: false` blanking;
  the `ref.invalidate` no-op on an unbuilt provider; verifying `retry: _noRetry` against the
  riverpod 3.3.2 source rather than by inspection; and noting the `initState` guard would not catch
  a `ref.invalidate` — which matters the moment the result screen gains a `ref`.
- **F** — the skills/CLAUDE.md contradiction (FINDING-01); the day9 brief's stale pin and broken
  citation; K-3 in the fix queue; the school-vs-university-gate contradiction in the smoke report
  and `zna.md`; the loss of "flashcards are university-only"; the partial purchase-silence
  assertion; and a genuinely useful "where I looked and found nothing" section.

### Duplicated findings (independent convergence — treated as corroboration)

- `GET /me/entitlements` is dead in production — **B-01 and E-4**, reached by different routes
  (B by grepping consumers, E by reasoning about `invalidate` on an unbuilt element). Merged as
  FINDING-06 and given higher confidence for the convergence.
- The `catalog_states.dart` retry-suppression justification — **B-12 and the lead independently**.
  Merged as FINDING-16.
- The dangling `upgradeCta` reference — **F-8 and the lead independently**. Merged as item 22.
- Purchase surface / limit-sheet copy verified clean — **C, D, F and the lead**, four times.

### Contradictions between agents, and how each was resolved

**1. Stale `openapi.yaml:NNN` citations — B says 18 stale, F says exactly one.**
Resolved by the lead by scripting every citation against **both** contract revisions
(`git show 3db4f04^:contract/openapi.yaml` vs HEAD). Result: 20 prefixed citations in `lib/`;
17 resolve to unrelated content; but **most were already stale at the 2.1.0-m1 pin**, so B's
framing ("stale *after* the re-vendor") is wrong, while F's method — "was correct before, wrong
now" — by construction cannot see a citation that was already wrong, so F's "only one" understates
it. **Both were half right.** The registration models' bare `:1406` / `:1393` anchors *were*
correct at 2.1.0-m1 and *were* broken by this migration, which F's `lib/`-wide sweep missed
because they carry no `openapi.yaml` prefix. See FINDING-11.

**2. Agent C: the catalog `403` copy is "correctly worded either way". Lead: not quite.**
C is right that it is not an *entitlement* gate. But `openapi.yaml:843-849` gives the 403 two
causes, and *"This subject isn't part of your course"* is false for the un-released-term one.
Recorded as FINDING-16 with honest attribution (**pre-existing**, not caused by 3.0.0-m1).

**3. Agent C: `upgradeCta` "verified absent from both ARBs". Lead: the key yes, the reference no.**
Both agents are describing different things. The key is gone; a textual reference to it survives
at `app_en.arb:491` and is regenerated into `app_localizations.dart:1325`. Item 22.

### Findings rejected by the lead, with reasons

| Rejected | Source | Why |
| --- | --- | --- |
| *"The result screen now has an independently-failing `GET /me` dependency; it needs loading/error/offline for it."* | A §4.2, and the brief given to E | **False at HEAD.** D-006 removed the element rather than re-sourcing it. `quiz_result_screen.dart:35` is a `StatelessWidget` with no `ref` and no provider import. E rejected this itself in its headline; A asserted it while its own §4.9 verified the opposite. It remains a correct *forward-looking* concern for the deferred meter (DESIGN_ISSUES #50) and is recorded there, not as an open finding. |
| *"22 stable operations."* | A §1, B (coverage line) | **Wrong count.** `grep -c '^      x-stability: stable' contract/openapi.yaml` = **21** (draft = 15, total = 36). A's own tally note shows it counting prose occurrences of the string. 21 also matches the project's own records and the smoke harness's "all 21 stable operations". |
| *"The 3.0.0-m1 file is 1726 lines vs 2.1.0-m1's ~1590; the schemas block shifted ~200 lines."* | B-05 preamble | **Wrong.** Measured: old **1708** lines, new **1726** — a net **+18**. The large per-citation offsets B tabulated are real but come from *older* contract versions, not this delta. This mis-measurement is what produced contradiction 1. |
| *"The purchase-silence assertion is vacuous."* | F-6 | **Overstated.** It is *partial*: it would catch a `FilledButton` CTA; it would miss a `TextButton` one. Downgraded and re-worded in FINDING-05 — the conclusion (a real guard is needed) survives. |
| *"Six per-resource `404`s unhandled on registration."* (B-07) | B | **Real, but out of scope.** Verified against `error-codes.md:34-39` — the six codes exist and the client maps none of them. But those registry rows are **unchanged** by this migration (A confirmed the only registry edits were the `502` removal and two Notes edits). Not a 3.0.0-m1 impact. Recorded in §12 as a candidate `seif_fight` entry so it is not lost, and deliberately kept out of the findings count. |
| *"Dead duplicate `schoolsProvider`."* (B-10), *"`main_mock.dart` doesn't override `refreshDioProvider`"* (B-14), *"`validation_failed` unmapped on the quiz surface"* (B-08) | B | **Real but not contract-3.0.0 impacts.** B-14 is self-documented as unreachable. B-08 is a doc-comment overstatement with low impact. Per §12 of the brief ("do not over-report"), excluded from the findings count; B-08 is noted in the endpoint map. |
| *"`x-consumers: [web]` has a trailing YAML comment a regex parser could capture."* | A §4.4 | **Moot here.** No tooling in this repository parses `openapi.yaml` at all (FINDING-14). Recorded as a caveat for whoever writes the conformance guard, not as a finding. |
| Stray zero-byte files `./1` and `./1590` at the repo root | created by a subagent's shell redirect | Not a repository finding. The agent removed its own artefacts; the lead verified `git status --short` matches the pre-audit state exactly. |

---

## 11. Final Opus 5 Assessment

### Is the Flutter application compatible with contract 3.0.0-m1?

# **YES, WITH REQUIRED CHANGES**

**Why "YES" is the right first word.** I verified the wire boundary myself rather than accepting
it. All 21 stable operations have a client implementation. Every model's `required` set matches
the schema in both directions — there is no field the Dart insists on that the contract makes
optional, and none the contract requires that the Dart omits. `QuizSummary` carries exactly the
eight surviving fields; the generated files carry no trace of the two removed ones; a 2.x server
still parses. Nothing calls a deleted, `draft`, or `x-consumers: [web]` operation. The purchase
surface is genuinely gone in code, routes, and **both** ARB files. No legal 3.0.0-m1 response body
can throw anywhere in the data layer. **There is no CRITICAL finding and no HIGH finding in any
`.dart` file.** The three migration commits did the work they claim, and their commit bodies
describe it accurately.

**Why "WITH REQUIRED CHANGES" is not a hedge.** The changes this migration still needs are all
*one layer out* from the wire, and that is exactly where this repository has been bitten before —
its own `CLAUDE.md` records two bugs that were SOURCE-correct and still broken. Three things are
genuinely owed:

1. **The instruction set contradicts the contract** (FINDING-01). Six auto-loaded skill files and
   the root project file tell the next implementer to build a Paymob checkout and render a Fawry
   `pending` state that `openapi.yaml:754` denies exists. This is the highest-severity finding in
   the audit and it is not code. Left alone, it is how the deleted surface comes back.
2. **`GET /me` became load-bearing and was not hardened for it** (FINDING-02, -03, -06). adr-102
   made it the sole home of the student's standing. It is refreshed on one event, has no
   app-resume refetch, blanks Home to an error when a refetch fails over a cached-good profile,
   and its sibling entitlements provider never runs at all. Every one of these predates the
   migration; **the migration is what made them matter.**
3. **The contract and the code are connected only by human transcription** (FINDING-14). 862/0 is
   real, but it cannot fail for a contract reason, and the 3.0.0-m1 `finish` body has never been
   seen on the wire.

**On verification level, stated plainly.** This audit is **SOURCE + BUILD**. I re-ran the suite
(862/0, exit 0) and read every claim's evidence at HEAD. Nothing here is DEVICE or CI verified,
and the headline unverified fact remains the one `WAVE_STATUS.md` already names: staging has never
returned a 3.0.0-m1 `finish` body. The client accepts both shapes, so nothing *depends* on that
observation — but it should not be reported as more settled than it is.

**One thing I want on the record as a compliment to the work, not a caveat.** The reason this
audit found no CRITICAL and no HIGH in the code is not that it looked shallowly. Six agents plus
the lead went at the data layer, the UI, the tests, the providers and the contract diff
adversarially, and the strongest finding any of them produced against `lib/` is a stale comment.
The migration commits were done properly, and the records — `WAVE_STATUS.md`, `DECISIONS.md`,
`SOURCE.md` — were honest about their own limits in a way that made this audit faster, not slower.

---

## 12. Phase 3 Implementation Plan

Ordered by **dependency**, not by severity. Each step's reason states what breaks if it runs later.

| # | Step | Affected files | Depends on | Reason for this position | Expected result | Verification |
| --- | --- | --- | --- | --- | --- | --- |
| **1** | **Correct the instruction set** — remove Paymob checkout and Fawry `pending`; state adr-049 §3 and `openapi.yaml:754` | `.claude/skills/{level-up-domain,river,screen-states,build-screen,seif-api-contract}/SKILL.md`; `F:\level\CLAUDE.md` | — | **First, because everything after it is done by an agent that reads these files.** Any other ordering risks rebuilding the deleted surface mid-plan. | No auto-loaded instruction contradicts the contract | SOURCE — grep for `paymob|pending|checkout` across `.claude/skills/` |
| **2** | **Stamp the stale records** — day7 + day9 briefs, K-3 in `known-issues.md`, `seif_fight` S6 re-anchor, the smoke report's school/university clause and the `zna.md` ask | `docs/day7_quiz_brief.md`, `docs/day9_quiz_review_brief.md`, `.ai/audits/current/known-issues.md`, `docs/seif_fight.md`, `.ai/audits/current/smoke-staging-2026-09-04.md`, `zna.md` | 1 | Same reason as 1, one tier down. Step 2's corrected ask is also the input to step 8. | No record instructs Phase 3 toward the old contract | SOURCE |
| **3** | **Ask Seif the four open questions** (§9C) — award timing first | `docs/seif_fight.md` | 2 | **Award timing gates steps 4 and 5.** Do not guess it; rule 4 forbids inventing API semantics. | Answers, or an explicit "unknown, proceed under assumption X" | owner sign-off |
| **4** | **Harden `/me` freshness** — app-resume refetch; invalidate on leaving a quiz that submitted at least one answer | `lib/features/profile/notifier/me_notifier.dart`, `lib/features/quiz/screens/quiz_screen.dart` | 3 | Needs the award-timing answer to know whether an abandoned quiz can move the total | Home never shows a stale total for the process lifetime | BUILD + a widget test for the abandon path |
| **5** | **Correct the mock's award timing** | `lib/dev/mock_backend.dart` (`_submitAnswer`, `_finishQuiz`) | 3, 4 | Must follow 4, not lead it: correcting the mock first would make step 4 look already-fixed on device while production is not | Device walkthroughs can surface `/me` staleness | DEVICE via `main_mock.dart` |
| **6** | **Non-destructive refresh failure** on `meProvider`'s three consumers | `home_screen.dart`, `profile_screen.dart`, `settings_screen.dart` | 4 | Depends on 4 because 4 adds refresh triggers, which multiplies the failure occasions | A failed refetch keeps the cached profile and surfaces the failure without blanking | BUILD + a failing-refetch widget test |
| **7** | **Decide `entitlementsProvider`** — wire it or delete it; correct `seif_fight` S8 either way | `lib/features/profile/notifier/me_notifier.dart`, `lib/core/session/session_scope.dart`, `docs/seif_fight.md` | 3 | Owner decision (product), so it must follow the Seif round trip | The contract's resume-refetch is implemented, or explicitly and honestly not | BUILD |
| **8** | **Unblock staging** — seed subjects for the school cohort of `+2010000000001` (or register a university account), then re-run the smoke harness | `tool/smoke/real_api_smoke_test.dart` (run only) | 2, 3 | Needs the corrected ask from step 2 | The quiz loop's 6 operations decode; **the 3.0.0-m1 `finish` body is observed** | live-staging run |
| **9** | **Mechanise the rules** — the contract-conformance guard (FINDING-14), the purchase-silence guard (FINDING-05), a router guard against `/subscription*` | `test/guards/rules.dart`, `test/guards/project_rules_test.dart`, `tool/verify_guards.ps1` | 4–7 | Guards must be written **after** the code they lock, or they lock the wrong shape | The suite can fail for a contract reason | BUILD + `verify_guards.ps1` proving each can fail |
| **10** | **Close the test gaps** — AR purchase-silence assertions; a mock `PATCH /me` handler; a failing-refetch case | `test/features/quiz/quiz_setup_screen_test.dart`, `lib/dev/mock_backend.dart`, `test/features/home/home_screen_test.dart` | 9 | Cheaper once the guards define the shape | AR coverage; `PATCH /me` runnable on device | BUILD |
| **11** | **Sweep the stale prose** — items 17–24, plus re-anchoring the 17 citations | 9 `lib/` files, `tool/smoke/real_api_smoke_test.dart`, `app_en.arb` | 9 | Last: a citation guard from step 9 tells you exactly which anchors are wrong, so the sweep is mechanical instead of manual | Every anchor resolves to the schema it names | BUILD + the new guard |
| **12** | **Device verification** of the quiz loop end to end | — | 5, 8 | The ladder's top rung; needs both a correct mock and a seeded staging | DEVICE-level evidence for adr-102 | install + drive the flow |

**Deliberately not in this plan** (so nobody infers they were forgotten): the DESIGN_ISSUES #50
meter — it is a **design** question, blocked on the designer confirming frames `159:1964` /
`549:20247`, and building it before that would be inventing UI (rule 4). When it is unblocked, it
must reuse `levelProgressFraction` from `level_card.dart`, **not** the changelog's `mod 500`
formula (see the end of §6). Also excluded, as pre-existing and not 3.0.0-m1 impacts: the six
registration `404` codes (candidate `seif_fight` entry), the dead `schoolsProvider`,
`validation_failed` on the quiz surface, and the orphaned `correctAnswerRevealed` key.

---

## 13. Recommended First Implementation Task

## Correct the auto-loaded instruction set (FINDING-01) — step 1 above

**The single task:** edit the six `.claude/skills/*/SKILL.md` files and `F:\level\CLAUDE.md` to
delete the Paymob-checkout hand-off and the Fawry `pending` subscription state, replacing them
with the contract's actual rule — the app is **purchase-silent** (adr-049 §3), and *"There is no
`pending` state — an entitlement is active or it isn't"* (`openapi.yaml:754`). Leave the untracked
`skills/` mirror alone; it is pre-existing untracked work and not this session's to touch.

**Why this one, ahead of every code change.**

- **It is the highest-severity finding in the audit** and the only HIGH one.
- **It is the only finding that actively causes new defects.** Every other item is a stale comment,
  a missing test, or a freshness gap. This one is a standing instruction to build a surface the
  contract deleted — and `level-up-domain`'s own `description:` puts it in front of *"ANY Level Up
  feature, screen, model, prompt, or code review."*
- **It gates the rest of the plan.** Steps 4–11 will be executed by an agent that loads these files
  first. Fixing them last means every intervening step ran under contradicted instructions.
- **It is the safest possible first move.** Prose only. No `.dart` file, no test, no model, no
  route. It cannot regress the 862 baseline, and `validate.ps1` should come back byte-identical.
- **It has the best evidence-to-effort ratio in the audit.** The contract sentence that settles it
  is one line, the app's own `entitlement_state.dart:14` already agrees with the contract, and
  every affected line is quoted with a path in FINDING-01.

**Definition of done.** `grep -rin 'paymob\|fawry\|pending' .claude/skills/ ../../CLAUDE.md`
returns only correct statements; each edited file cites `openapi.yaml:754` and adr-049 §3;
`docs/day9_quiz_review_brief.md`'s *"Four stale claims inside those skills"* section is extended
to name this fifth one (or the whole section is repointed at this document); `validate.ps1`
returns **OVERALL: PASS** with **862 passed / 0 failed**.

---

*Audited 2026-09-04 against HEAD `7e7129c`, contract pin `184d6ec` (`3.0.0-m1`). Lead: Opus 5.
Six subagents. **No application source code, test, model, provider, repository, route,
localization file, or unrelated document was modified.***
