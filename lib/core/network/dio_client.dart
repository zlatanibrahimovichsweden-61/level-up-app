import 'package:dio/dio.dart';

import '../../features/auth/notifier/auth_controller.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Builds the app's Dio instances. Two kinds:
/// - [create]: the main client — `AuthInterceptor` (Bearer + refresh/retry) then
///   `ErrorInterceptor`.
/// - [createBare]: refresh-only client — `ErrorInterceptor` ONLY, no
///   `AuthInterceptor`, so `POST /auth/refresh` can never re-enter the retry path.
class DioClient {
  static BaseOptions _baseOptions() => BaseOptions(
    baseUrl: AppConfig.instance.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    headers: const {
      'Content-Type': 'application/json',
      // Contract 3.32.0-m1: send Accept: application/json on every call, so the
      // API can write its ProblemDetails body at all. A default, not a lock: a
      // request that wants other bytes (the support-photo GET sends
      // `image/*, application/problem+json`) overrides it per request.
      'Accept': 'application/json',
    },
  );

  static Dio create({
    required SecureStorage storage,
    required AuthController authController,
    required TokenRefresher refresh,
    required ErrorInterceptor error,
  }) {
    final dio = Dio(_baseOptions());
    final auth = AuthInterceptor(
      storage: storage,
      authController: authController,
      refresh: refresh,
      // The interceptor re-issues the original request through THIS same client
      // (tagged `__retried`); passing the local instance avoids reading
      // dioProvider back into itself.
      retryDio: dio,
    );
    // Order matters: auth attaches the token / handles 401 first, error maps
    // any remaining failure to a typed AppException last.
    dio.interceptors.addAll([auth, error]);
    return dio;
  }

  /// The bare refresh client. No AuthInterceptor → loop-safe refresh.
  static Dio createBare({required ErrorInterceptor error}) {
    final dio = Dio(_baseOptions());
    dio.interceptors.add(error);
    return dio;
  }
}
