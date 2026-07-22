import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Builds the single configured Dio instance. Constructed via `dioProvider`
/// so the whole app shares one client with the interceptor chain attached.
class DioClient {
  static Dio create({
    required AuthInterceptor auth,
    required ErrorInterceptor error,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {'Content-Type': 'application/json'},
      ),
    );
    // Order matters: auth attaches the token first, error maps failures last.
    dio.interceptors.addAll([auth, error]);
    return dio;
  }
}
