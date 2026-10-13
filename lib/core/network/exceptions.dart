/// Typed exceptions thrown in the data layer, caught in notifiers/blocs,
/// mapped to `ScreenState` in the UI. The UI never sees Dio or raw errors.
///
/// `code` is the stable machine code from Seif's error-codes.md (RFC 9457
/// ProblemDetails `code`). The app maps each code to AR/EN copy — server
/// `title`/`detail` are developer-facing English and never shown to users.
library;

sealed class AppException implements Exception {
  const AppException(this.code, {this.detail});
  final String code;
  final String? detail;

  @override
  String toString() => 'AppException($code)';
}

/// No connectivity — drives the Offline state, not a generic error.
class OfflineException extends AppException {
  const OfflineException() : super('offline');
}

/// Transport-level failure (timeout, DNS, socket) with no HTTP response.
class NetworkException extends AppException {
  const NetworkException({super.detail}) : super('network_error');
}

/// A structured API error carrying an error-codes.md `code` + HTTP status.
class ApiException extends AppException {
  const ApiException({required this.status, required String code, super.detail})
    : super(code);
  final int status;
}

/// 401 — see error-codes.md. `session_superseded` → forced logout;
/// `authentication_required` → refresh + retry once (handled in interceptor).
class UnauthorizedException extends ApiException {
  const UnauthorizedException({required super.code, super.detail})
    : super(status: 401);
}

/// 400 `validation_failed` carrying `ProblemDetails.errors` — the contract's
/// field map (`field -> [messages]`). Screens turn it into per-field inline
/// errors; it is how the server reports a geography-conditionality violation
/// (adr-010) too.
///
/// The message strings are NOT rendered: `ProblemDetails.title`/`detail` are
/// documented as developer-facing English, and the contract says nothing about
/// the language of `errors` values. Only the field NAMES are used, mapped to
/// localized copy at the screen. They are never logged either (minors' data).
class ValidationException extends ApiException {
  const ValidationException({required this.errors, super.detail})
    : super(status: 400, code: 'validation_failed');

  /// Contract shape: `additionalProperties: { type: array, items: string }`.
  final Map<String, List<String>> errors;

  /// The field names the server rejected — the only part the UI consumes.
  Iterable<String> get fields => errors.keys;
}

/// 429 — the unauthenticated per-IP limit on `/reference/*` (error-codes.md,
/// `rate_limited` row; documented on countries/governorates/cities).
///
/// Deliberately NOT `otp_throttled`: that code is OTP-specific and reusing it
/// would make a geography lookup show an OTP message. Seif split them for
/// exactly this reason.
class RateLimitedException extends ApiException {
  const RateLimitedException({this.retryAfter, super.detail})
    : super(status: 429, code: 'rate_limited');

  /// Parsed from the `Retry-After` response header. Null when the header is
  /// absent or unparseable — it is not guaranteed by the contract (only the
  /// response descriptions mention it, there is no `headers:` block), so no
  /// call site may assume a duration.
  ///
  /// Carried but not yet rendered as a countdown: the point is that a later day
  /// can build one without re-plumbing the interceptor.
  final Duration? retryAfter;
}

class UnknownException extends AppException {
  const UnknownException({super.detail}) : super('unknown');
}

/// Connectivity failure → drives the Offline state, not a generic error.
/// The ErrorInterceptor maps timeouts/connection errors to [NetworkException];
/// [OfflineException] is the explicit no-connectivity signal.
///
/// Lives here (not in a feature) because every feature's screens branch on it
/// to pick the Offline view.
bool isOffline(Object? error) =>
    error is OfflineException || error is NetworkException;

/// `403 account_pending_deletion` (adr-114) — the account is inside its 30-day
/// deletion grace window.
///
/// Lives here beside [isOffline], and for the same reason: it is **not one
/// endpoint's error**. The contract's rule is **default-deny** — every
/// authenticated `/api/v1` endpoint answers this except a four-endpoint
/// allowlist (`GET /me`, `POST`/`DELETE /me/deletion-request`,
/// `POST /auth/logout`), and an endpoint added later is blocked unless it is
/// added to that list (`openapi.yaml:62-71`). So "which operations return it"
/// is not a property of the operations, and branching on the code at one
/// screen would be a fix for one of sixteen.
///
/// **Only seven of the sixteen stable operations that can return it actually
/// declare it** — `getMyMistakes`, `getMyMistakesForSubject`, `getExplanation`,
/// `getFlashcardsForLecture`, `setFlashcardSelfGrade`, `getLeaderboard`,
/// `getMyRank` — and the contract says so itself on two of them: *"DECLARED
/// from 3.5.1-m1, but REACHABLE since 3.3.0-m1 — this operation simply failed
/// to declare it"* (`:2101`, `:2175`). A declaration-only census therefore
/// materially under-counts the reachable surface, which is exactly why this is
/// a predicate and not a per-operation branch.
///
/// Count operations, not text matches: `getExplanation` declares it twice
/// (`:1629`, `:1656`), and the occurrence at `:1023` is inside the allowlisted
/// `requestAccountDeletion`, which documents the rule rather than declaring the
/// refusal.
///
/// The two client rules the contract states, in its own words (`:82-83`): do
/// **not** log the user out, and do **not** retry. The first already holds —
/// nothing in [AppException] handling logs out, and `AuthInterceptor` returns
/// early on anything that is not a `401`. The second is what every call site
/// that renders a Retry button must ask this function.
///
/// The third rule — *route to the cancel screen* — is NOT implemented, because
/// that screen does not exist. See `docs/seif_fight.md` / the deletion pair in
/// the stable inventory; this predicate is the seam it will hook into.
///
/// Matches on `code` rather than an exception subclass so that a plain
/// `ApiException` (what `ErrorInterceptor` builds today, and what the existing
/// tests construct) is recognised alongside any future subclass.
bool isAccountPendingDeletion(Object? error) =>
    error is ApiException && error.code == 'account_pending_deletion';

/// `403 account_banned` — the account is banned (`contract/error-codes.md:51`,
/// `contract/openapi.yaml:231`).
///
/// **Four operations return it** — `verifyOtp`, `verifyParentOtp`,
/// `confirmRecovery` and the web-only `verifyRedemptionSessionOtp`
/// (`contract-changelog.md`, 3.42.0-m1) — and it comes back **only after a
/// correct code**, with **no tokens and no session** issued by any of them.
/// What the contract says about the code differs by operation: for `verifyOtp`
/// (`contract/openapi.yaml:231`) and `verifyRedemptionSessionOtp` (`:371`) it
/// states "the code is consumed"; for `verifyParentOtp` (`:542`) and
/// `confirmRecovery` (`:625`) it says only that no tokens or session were
/// issued. `contract/error-codes.md:51` marks the code as consumed for
/// `verifyOtp` alone. So the `verifyParentOtp` and `confirmRecovery` handlers
/// (CW06) must not assume the code was consumed. The contract's client rule is
/// *do not retry; route to Support*.
///
/// **CW02 handles `verifyOtp` only.** The `verifyParentOtp` and
/// `confirmRecovery` arms land with recovery in CW06. It is never returned on
/// token refresh or on an authenticated call, so no interceptor branches on it
/// and nothing here logs the student out — there is no session to end.
///
/// "Route to Support" is NOT implemented: there is no signed-out Support route
/// yet (a question for Seif). Until the designer's banned frame exists the OTP
/// screen shows the contract's suggested copy inline.
///
/// Matches on `code`, like [isAccountPendingDeletion], so a plain
/// `ApiException` (what `ErrorInterceptor` builds) is recognised.
bool isAccountBanned(Object? error) =>
    error is ApiException && error.code == 'account_banned';
