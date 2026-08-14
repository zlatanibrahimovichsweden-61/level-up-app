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
