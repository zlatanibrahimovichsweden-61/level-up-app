---
name: seif-api-contract
description: How to consume Seif's OpenAPI contract in the Level Up Flutter app — freezed models, the Dio client, repositories, pagination, the standard error format, and change requests. Use this skill whenever work touches the Level Up API in any way; creating or editing any API model, endpoint call, repository, or auth/subscription/leaderboard/quiz data flow; parsing any JSON from the server; or whenever an endpoint, field, or response shape seems missing, ambiguous, or mismatched — even if the user just says "build the profile screen" or "hook this up to the backend" without mentioning the contract.
---

# Seif's API Contract — Consuming It Correctly

Seif (backend lead) owns the OpenAPI/Swagger contract. It specifies every endpoint, request/response shape, the standard error format, the pagination convention, and entitlement signals. The app builds against the contract and nothing else — never against assumptions, memory of "typical APIs", or the database you imagine behind it.

Why this is rigid: an invented field or endpoint compiles fine, demos fine, and then silently becomes "the contract" in code. Weeks later the real backend disagrees and the bug surfaces in production, in front of paying students. The most expensive mistake in this project is a plausible-looking invented response model.

## Step 0 — Locate the contract section (always first)

1. Find the spec: look for `openapi*.{json,yaml,yml}` or `swagger*.{json,yaml}` in the repo (conventionally under `contract/`). The user may also paste an excerpt — treat a pasted excerpt as authoritative for this task.
2. Read ONLY the section the feature needs (its paths + referenced schemas). Don't load the whole spec into context.
3. **If the spec file, endpoint, or field does not exist: STOP.** Do not scaffold "temporary" shapes. Say exactly what is missing and draft a change request instead (template at the end). Building against a missing artifact is never the helpful option here.

## Models — freezed + json_serializable, mirroring the contract exactly

Never write manual `fromJson` for contract types. Every API model:

```dart
@freezed
class StreakPair with _$StreakPair {
  const factory StreakPair({
    @JsonKey(name: 'current_streak') required int currentStreak,
    @JsonKey(name: 'longest_streak') required int longestStreak,
  }) = _StreakPair;

  factory StreakPair.fromJson(Map<String, dynamic> json) => _$StreakPairFromJson(json);
}
```

Rules, each existing for a reason:

- **Nullability mirrors the contract exactly.** Contract-optional → `String?`. Contract-required → `required`, **no default**. If the server omits a required field the parse throws — that is the system working: it surfaces contract drift the moment it happens instead of hiding it behind `?? 0`. Never add defensive defaults "to be safe"; a safe-looking `?? 0` on `total_points` shows a student the wrong score.
- **`@JsonKey(name: 'snake_case')` is the only bridge.** API is snake_case, Dart is camelCase; the mapping lives in exactly one auditable place per field. Never rename Dart fields to snake_case, never map keys anywhere else.
- **Glossary terms verbatim** as class and field names: `Track`, `LearningItem`, `Question`, `Flashcard`, `StreakPair`, `totalPoints` ↔ `total_points`, `base_subscription`, `flashcard_subscription`. No synonyms ("premium", "plan", "score").
- Regenerate after model changes: `dart run build_runner build --delete-conflicting-outputs`.

## The Dio client and repositories

One configured Dio instance, provided via Riverpod, base URL from flavor config (`AppConfig.baseUrl`). Interceptor stack (already specified in `01_Flutter_Specs/Networking_and_API.md`):

- `AuthInterceptor` — token from `flutter_secure_storage` → `Authorization: Bearer`.
- `ErrorMappingInterceptor` — maps `DioException` to the sealed `AppException` hierarchy: timeouts/`connectionError` → `OfflineException`, 401 → `UnauthorizedException`, 5xx → `ServerException`, else `NetworkException`.
- `LogInterceptor` with `requestBody: false, responseBody: false` — method + URL + status ONLY. Many users are minors: never log bodies, headers, tokens, or personal data, and there is no debug-build exemption. Never put a literal token in example code either.

Structure every endpoint as: **Service/client method (raw call, returns model) → Repository (returns domain model, throws typed `AppException`) → notifier/bloc catches → sealed `ScreenState`.** UI never sees Dio or raw exceptions.

## Contract-wide conventions — mirror, don't improvise

- **Standard error format:** every non-2xx body follows the contract's single error shape. Parse it once in the error interceptor; never per-endpoint ad-hoc error parsing.
- **Pagination convention:** used everywhere lists appear (leaderboards, questions, tickets, inbox). Model the envelope once, reuse it generically (`Paginated<T>`), and never fetch an unpaginated "whole list" — leaderboards are large and Egyptian mobile networks are the baseline, not the edge case.
- **Server is authoritative:** display `total_points`, `level`, badges, and subscription state exactly as returned. Never compute or "correct" them client-side. Fawry `pending` is its own state — never rendered as loading, never as active.

## When code and contract disagree

The contract wins. If a response fails to parse, a field changed type, or a needed endpoint/field doesn't exist:

1. Do not rename, default, retype, or work around it locally.
2. File a change request to Seif and (if asked to keep building) build only the parts the contract does cover.

Change request template:

```
CR: <short title>
Endpoint/schema: <path or schema name, or "missing">
What the contract says: <quote or "absent">
What is needed / observed: <field, type, endpoint, actual payload>
Impact if unresolved: <blocked screen/feature>
Proposed change: <concrete suggestion>
```

Log it in `00_Project/Decisions_Log.md` (one line) and reference the CR in code comments at the blocked site — never a silent TODO.

## Verification checklist (before calling API work done)

1. `dart run build_runner build --delete-conflicting-outputs` succeeds.
2. `dart analyze` clean.
3. Unit test each model's `fromJson` against a **sample payload copied from the contract** (not hand-invented): required-field-missing throws, optional-field-missing parses, snake_case keys map.
4. Repository test: mocked Dio errors surface as the right `AppException` subtypes.
5. Every field name traces back to a line in the contract or a filed CR.
