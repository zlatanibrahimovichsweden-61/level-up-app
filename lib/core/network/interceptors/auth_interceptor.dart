import 'package:dio/dio.dart';

import '../../storage/secure_storage.dart';

/// Attaches `Authorization: Bearer <access>` to every request.
///
/// TODO(contract): implement the refresh flow. Per Seif's contract, on
/// `401 authentication_required` run POST /auth/refresh (rotating refresh
/// token) and retry the original request ONCE. On `401 session_superseded`
/// do NOT refresh — purge tokens and route to the forced-logout screen.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);
  final SecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
