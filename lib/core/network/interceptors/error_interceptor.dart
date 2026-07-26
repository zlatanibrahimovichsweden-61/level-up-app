import 'package:dio/dio.dart';

import '../exceptions.dart';

/// Maps raw DioExceptions into typed [AppException]s so the rest of the app
/// never touches Dio. Repositories catch these and rethrow domain errors;
/// notifiers turn them into `ScreenState`.
///
/// TODO(contract): full mapping of error-codes.md codes lands per-feature.
/// Every non-2xx body is RFC 9457 ProblemDetails with a stable `code`.
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
        400 when code == 'validation_failed' =>
          ValidationException(errors: _fieldMap(data)),
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
