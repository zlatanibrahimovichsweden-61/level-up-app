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
  const ApiException({
    required this.status,
    required String code,
    super.detail,
  }) : super(code);
  final int status;
}

/// 401 — see error-codes.md. `session_superseded` → forced logout;
/// `authentication_required` → refresh + retry once (handled in interceptor).
class UnauthorizedException extends ApiException {
  const UnauthorizedException({required super.code, super.detail})
      : super(status: 401);
}

class UnknownException extends AppException {
  const UnknownException({super.detail}) : super('unknown');
}
