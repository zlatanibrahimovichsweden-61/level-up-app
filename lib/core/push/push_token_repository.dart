import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/exceptions.dart';
import '../providers/core_providers.dart';

/// The only place that touches Dio for the device's push token.
///
/// One operation, `PUT /me/fcm-token` (`registerFcmToken`, `x-stability:
/// stable`, `openapi.yaml:1064`), authenticated and on the main [dioProvider]:
/// `AuthInterceptor` attaches the Bearer and `ErrorInterceptor` has already
/// mapped failures by the time they arrive here, so every failure is rethrown
/// as the typed [AppException] the interceptor produced.
///
/// The body is exactly `{ "token": <string> }` - the contract's one required
/// property - and nothing else: no device id, no platform, no locale. The call
/// is idempotent ("one token per the single active device"; the latest wins),
/// so a repeat is harmless. The answer is `204`; there is nothing to decode.
///
/// Failures the caller must tell apart (it is `PushRegistrationLifecycle` that
/// does):
/// - `400 validation_failed` - the token is absent, empty/whitespace-only or
///   longer than 4096 characters: retrying the SAME token cannot succeed;
/// - `401 authentication_required` / `session_superseded` - the session is gone
///   (the interceptor already forced the logout for the second);
/// - `403 account_pending_deletion` - inside the deletion grace window
///   (`isAccountPendingDeletion`): do not retry, do not sign out;
/// - anything else (offline, timeout, `5xx`, `429`) - transient.
///
/// **The token is never logged**, never put in an error `detail`, and never
/// kept by this class. This file does not log at all.
class PushTokenRepository {
  PushTokenRepository(this._dio);

  final Dio _dio;

  /// `PUT /me/fcm-token` - register or replace this device's push token.
  Future<void> registerFcmToken(String token) async {
    try {
      await _dio.put<void>(
        '/me/fcm-token',
        data: <String, dynamic>{'token': token},
      );
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    }
  }

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final pushTokenRepositoryProvider = Provider<PushTokenRepository>(
  (ref) => PushTokenRepository(ref.watch(dioProvider)),
);
