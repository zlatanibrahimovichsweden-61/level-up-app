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
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
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
        data: {'phone': phone, 'code': code, 'device': device.toJson()},
      );
      return AuthResult.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `POST /auth/refresh` — rotate the refresh token, mint a new access token.
  /// Runs on the BARE [_refreshDio] (no AuthInterceptor) so a 401 here cannot
  /// recurse. Throws `UnauthorizedException` carrying `refresh_token_invalid`
  /// (dead chain → full re-login) or `session_superseded` (evicted by a newer
  /// device); the caller decides the logout reason.
  ///
  /// The app's own refresh path (`dioProvider`'s interceptor) does NOT call this
  /// method: it calls [requestTokenRefresh] on the bare client directly, because
  /// reaching this repository from `dioProvider` is a provider cycle. See there.
  /// This is the same implementation, kept for callers that already hold the
  /// repository.
  Future<TokenPair> refresh({
    required String refreshToken,
    required String deviceId,
  }) => requestTokenRefresh(
    _refreshDio,
    refreshToken: refreshToken,
    deviceId: deviceId,
  );

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
}

/// `POST /auth/refresh` on the BARE [refreshDio] — the one implementation of the
/// call, shared by [AuthRepository.refresh] and `dioProvider`.
///
/// **Why a function on the bare client and not a call on the repository.**
/// `dioProvider`'s interceptor needs a refresher, and the repository's main
/// client IS `dioProvider` (`authRepositoryProvider` watches it). A refresher that
/// reads the repository therefore makes `dioProvider` read one of its own
/// descendants: a provider cycle. Release builds never notice, but in a debug
/// build Riverpod's `Ref.read` asserts and throws `CircularDependencyError`,
/// `AuthInterceptor` swallows it, and the 401 reaches the screen: a debug or
/// staging session could never refresh an expired access token and was stranded
/// after the access token's 15 minutes (E4-01). This function needs only the bare
/// client, which depends on nothing, so the graph has no cycle in any build.
///
/// [refreshDio] MUST be the bare client (no AuthInterceptor), so a 401 here
/// cannot re-enter the retry path. Throws the same typed [AppException]s the
/// repository does.
Future<TokenPair> requestTokenRefresh(
  Dio refreshDio, {
  required String refreshToken,
  required String deviceId,
}) async {
  try {
    final res = await refreshDio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refreshToken': refreshToken, 'deviceId': deviceId},
    );
    return TokenPair.fromJson(res.data!);
  } on DioException catch (e) {
    throw _asAppException(e);
  } on AppException {
    rethrow;
  } on Object catch (e) {
    // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a core
    // TypeError/FormatException here, not a DioException. Wrap it so the typed
    // boundary holds. runtimeType only: response bodies carry minors' data and
    // must never leak into an error detail.
    throw UnknownException(detail: 'parse: ${e.runtimeType}');
  }
}

/// The ErrorInterceptor already mapped the failure onto [DioException.error].
/// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
AppException _asAppException(DioException e) {
  final err = e.error;
  return err is AppException ? err : const UnknownException();
}

// Explicit left-side type: this file and core_providers.dart import each other
// (the repository watches dioProvider; dioProvider uses [requestTokenRefresh]),
// so the annotation keeps type inference from ever looping between them. There
// is no PROVIDER cycle: dioProvider does not read this provider.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
      (ref) => AuthRepository(
        dio: ref.watch(dioProvider),
        refreshDio: ref.watch(refreshDioProvider),
      ),
    );
