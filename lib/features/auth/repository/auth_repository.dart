import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/auth_result.dart';
import '../models/device_info.dart';
import '../models/otp_request_result.dart';
import '../models/token_pair.dart';

/// The only place that touches Dio for auth. Returns domain models, throws the
/// typed [AppException] hierarchy. Notifiers catch these; the UI never sees Dio.
///
/// The otp/verify/logout endpoints go through the main [_dio] (Bearer +
/// AuthInterceptor). [refresh] MUST go through [_refreshDio] — a bare client
/// with NO AuthInterceptor — so a 401 on refresh can never re-enter the retry
/// path (loop safety). All are `x-stability: stable`; refresh is `security: []`.
class AuthRepository {
  AuthRepository({required Dio dio, required Dio refreshDio})
      : _dio = dio,
        _refreshDio = refreshDio;

  final Dio _dio;
  final Dio _refreshDio;

  /// `POST /auth/otp/request` — always `202` for a well-formed phone, whether or
  /// not an account exists (anti-enumeration). The caller ALWAYS advances to the
  /// OTP screen on success; it must not branch on account existence here.
  Future<OtpRequestResult> requestOtp(String phone) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/otp/request',
        data: {'phone': phone},
      );
      return OtpRequestResult.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    }
  }

  /// `POST /auth/otp/verify` — proving possession forks the flow into
  /// [AuthenticatedResult] (tokens + profile) or [RegistrationRequiredResult]
  /// (short-lived registrationToken, no account yet).
  Future<AuthResult> verifyOtp({
    required String phone,
    required String code,
    required DeviceInfo device,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: {
          'phone': phone,
          'code': code,
          'device': device.toJson(),
        },
      );
      return AuthResult.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    }
  }

  /// `POST /auth/refresh` — rotate the refresh token, mint a new access token.
  /// Runs on the BARE [_refreshDio] (no AuthInterceptor) so a 401 here cannot
  /// recurse. Throws `UnauthorizedException` carrying `refresh_token_invalid`
  /// (dead chain → full re-login) or `session_superseded` (evicted by a newer
  /// device); the caller decides the logout reason.
  Future<TokenPair> refresh({
    required String refreshToken,
    required String deviceId,
  }) async {
    try {
      final res = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken, 'deviceId': deviceId},
      );
      return TokenPair.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    }
  }

  /// `POST /auth/logout` — revoke this session (Bearer, idempotent 204). A
  /// `401 authentication_required` just means already-logged-out; swallow it so
  /// the caller can clear tokens regardless.
  Future<void> logout() async {
    try {
      await _dio.post<void>('/auth/logout');
    } on DioException catch (e) {
      final err = e.error;
      if (err is ApiException && err.code == 'authentication_required') {
        return; // already revoked — treat as success
      }
      throw _asAppException(e);
    }
  }

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

// Explicit left-side type breaks the static reference cycle with dioProvider
// (which reads this provider lazily inside its refresh closure).
final Provider<AuthRepository> authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    dio: ref.watch(dioProvider),
    refreshDio: ref.watch(refreshDioProvider),
  ),
);
