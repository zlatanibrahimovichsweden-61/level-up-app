import 'package:dio/dio.dart';

import '../exceptions.dart';

/// Maps raw DioExceptions into typed [AppException]s so the rest of the app
/// never touches Dio. Repositories catch these and rethrow domain errors;
/// notifiers turn them into `ScreenState`.
///
/// TODO(contract): full mapping of error-codes.md codes lands per-feature.
///
/// Error responses the API writes normally are RFC 9457 ProblemDetails with a
/// stable `code`, but not every non-2xx is (contract 3.32.0-m1): a failure
/// while the response is being written, a host shutdown, a request whose
/// `Accept` excludes JSON, a non-API endpoint or a proxy/edge 502/503/504 can
/// arrive with no body, or a body without `code`. That maps to code `unknown`
/// below (a 401 stays [UnauthorizedException]). It is an UNKNOWN outcome: the
/// contract says to treat it like `internal_error`. `DioClient` sends
/// `Accept: application/json` on every request so the API can write its body.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final AppException mapped;

    if (err.type == DioExceptionType.connectionError) {
      mapped = const NetworkException(detail: 'connection error');
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      mapped = const NetworkException(detail: 'timeout');
    } else if (err.response != null) {
      final res = err.response!;
      final data = res.data;
      final code = (data is Map && data['code'] is String)
          ? data['code'] as String
          : 'unknown';
      final status = res.statusCode ?? 0;
      mapped = switch (status) {
        401 => UnauthorizedException(code: code),
        400 when code == 'validation_failed' => ValidationException(
          errors: _fieldMap(data),
        ),
        429 when code == 'rate_limited' => RateLimitedException(
          retryAfter: _retryAfter(res),
        ),
        // `404 country_not_found` (adr-028 §3) needs no subclass and no new UI:
        // the geography pickers' existing error state stands. It is listed here
        // only so the code is carried through as itself rather than `unknown`.
        _ => ApiException(status: status, code: code),
      };
    } else {
      mapped = const UnknownException();
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
      ),
    );
  }

  /// `Retry-After`, parsed as defensively as [_fieldMap]: absent, non-numeric,
  /// negative or HTTP-date values all yield null rather than throwing. A
  /// rate-limit error must still surface as a rate-limit error even when the
  /// hint that accompanies it is unusable.
  ///
  /// **Delta-seconds only.** The HTTP-date form is deliberately not supported:
  /// converting it means trusting the device clock against the server's, and a
  /// wrong countdown is worse than no countdown.
  static Duration? _retryAfter(Response<dynamic> response) {
    final raw = response.headers.value('retry-after')?.trim();
    if (raw == null || raw.isEmpty) return null;
    final seconds = int.tryParse(raw);
    if (seconds == null || seconds < 0) return null;
    return Duration(seconds: seconds);
  }

  /// `ProblemDetails.errors` — `field -> [messages]`. Parsed defensively (a
  /// malformed or absent map yields `{}`, not a crash): the field NAMES are what
  /// the UI needs, and a validation error must still surface as a validation
  /// error even if the map is unusable.
  static Map<String, List<String>> _fieldMap(Object? data) {
    if (data is! Map) return const {};
    final errors = data['errors'];
    if (errors is! Map) return const {};
    return {
      for (final entry in errors.entries)
        entry.key.toString(): switch (entry.value) {
          final List<dynamic> messages =>
            messages.map((m) => m.toString()).toList(),
          final Object? single => [if (single != null) single.toString()],
        },
    };
  }
}
