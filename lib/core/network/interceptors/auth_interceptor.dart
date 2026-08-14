import 'package:dio/dio.dart';

import '../../../features/auth/models/token_pair.dart';
import '../../../features/auth/notifier/auth_controller.dart';
import '../../storage/secure_storage.dart';
import '../exceptions.dart';

/// Performs `POST /auth/refresh` on the BARE refresh Dio. Injected as a closure
/// so the interceptor never holds the repository directly (that would form a
/// provider construction cycle: dio → interceptor → repo → dio).
typedef TokenRefresher =
    Future<TokenPair> Function({
      required String refreshToken,
      required String deviceId,
    });

/// Attaches the Bearer token and drives silent token refresh on 401.
///
/// Correctness guarantees:
/// - **Single-flight:** concurrent 401s share ONE refresh (`_refreshing`).
/// - **Loop-safe:** refresh runs on a separate bare Dio; the original request is
///   retried at most once (`extra['__retried']`).
/// - **State-only:** on eviction/dead-refresh it flips [AuthController]; it never
///   navigates — the router's redirect reacts to the state change.
///
/// Runs BEFORE `ErrorInterceptor` in the chain, so the 401 `code` is read from
/// the raw ProblemDetails body here. Non-handled 401s are passed on with
/// `handler.next(err)` so `ErrorInterceptor` still maps them to a typed
/// [AppException] for the caller.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureStorage storage,
    required AuthController authController,
    required TokenRefresher refresh,
    required Dio retryDio,
  }) : _storage = storage,
       _authController = authController,
       _refresh = refresh,
       _retryDio = retryDio;

  final SecureStorage _storage;
  final AuthController _authController;
  final TokenRefresher _refresh;
  final Dio _retryDio;

  /// The in-flight refresh, shared by all concurrent 401s. Reset on completion.
  Future<TokenPair>? _refreshing;

  static const _retriedFlag = '__retried';

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

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final code = _codeOf(err);

    // Instant device eviction on ANY endpoint → forced logout, no refresh.
    if (code == 'session_superseded') {
      await _authController.forceLogout(LogoutReason.supersededOtherDevice);
      return handler.next(err);
    }

    // Only expired/missing access tokens are our job to refresh.
    if (code != 'authentication_required') {
      return handler.next(err);
    }

    // Already retried once → do not loop.
    if (err.requestOptions.extra[_retriedFlag] == true) {
      return handler.next(err);
    }

    final TokenPair tokens;
    try {
      tokens = await _sharedRefresh();
    } on AppException catch (e) {
      // Auth failures already triggered forceLogout inside _performRefresh;
      // offline/network did NOT (transient). Reject with the typed error so the
      // caller shows offline/error and can retry.
      return handler.reject(
        DioException(requestOptions: err.requestOptions, error: e),
      );
    } catch (_) {
      return handler.next(err);
    }

    // Re-issue the ORIGINAL request once, with the fresh access token.
    try {
      final options = err.requestOptions
        ..extra[_retriedFlag] = true
        ..headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      final response = await _retryDio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.reject(e);
    }
  }

  /// Single-flight: the first caller starts the refresh; concurrent callers await
  /// the same future. `??=` assigns synchronously before any await, so exactly
  /// one refresh runs even under a burst of 401s.
  Future<TokenPair> _sharedRefresh() {
    return _refreshing ??= _performRefresh().whenComplete(
      () => _refreshing = null,
    );
  }

  Future<TokenPair> _performRefresh() async {
    final refreshToken = await _storage.readRefreshToken();
    final deviceId = await _storage.readOrCreateDeviceId();

    if (refreshToken == null || refreshToken.isEmpty) {
      // No refresh token to spend → dead session.
      await _authController.forceLogout(LogoutReason.sessionExpired);
      throw const UnauthorizedException(code: 'refresh_token_invalid');
    }

    try {
      final tokens = await _refresh(
        refreshToken: refreshToken,
        deviceId: deviceId,
      );
      await _storage.writeTokens(
        access: tokens.accessToken,
        refresh: tokens.refreshToken,
      );
      return tokens;
    } on ApiException catch (e) {
      // Dead refresh chain or eviction → forced logout (tokens cleared).
      if (e.code == 'refresh_token_invalid') {
        await _authController.forceLogout(LogoutReason.sessionExpired);
      } else if (e.code == 'session_superseded') {
        await _authController.forceLogout(LogoutReason.supersededOtherDevice);
      }
      rethrow;
    }
    // NetworkException / OfflineException propagate untouched: transient, so
    // NO logout — the caller surfaces offline and may retry.
  }

  /// The stable ProblemDetails `code` from the raw 401 body (this interceptor
  /// runs before ErrorInterceptor maps it).
  String? _codeOf(DioException err) {
    final data = err.response?.data;
    if (data is Map && data['code'] is String) return data['code'] as String;
    return null;
  }
}
