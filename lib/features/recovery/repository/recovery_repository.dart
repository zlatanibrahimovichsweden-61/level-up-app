import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/models/auth_result.dart';
import '../../auth/models/device_info.dart';
import '../../auth/models/otp_request_result.dart';
import '../models/recovery_models.dart';

/// The only place that touches Dio for the lost-phone recovery ladder
/// (adr-019's primary recovery path, `contract/openapi.yaml:462-629`).
///
/// Four operations, all `x-stability: stable`, all `security: []`: recovery
/// happens before any session exists, so they ride the main [dioProvider] with
/// no Bearer attached when storage is empty. The ladder is **anonymous by
/// construction** and stays open during an account-deletion grace window (a
/// lost-device student must be able to recover in order to cancel the deletion
/// - `openapi.yaml:74-80`).
///
/// | step | method | answers |
/// |---|---|---|
/// | 1 | [startRecovery] | the parent phone gets a code; masked number back |
/// | 2 | [verifyParentOtp] | guardianship proven; a rebind token back |
/// | 3 | [submitNewPhone] | the NEW phone gets a code |
/// | 4 | [confirmRecovery] | phone + device rebound; a fresh session back |
///
/// Failures are rethrown as the interceptor typed them; `classifyRecoveryFailure`
/// (`recovery_errors.dart`) names them:
/// - `404 recovery_unavailable` (step 1) - the app routes to the support path.
/// - `400 otp_invalid` / `otp_expired` (steps 2, 4).
/// - `400 validation_failed` - documented for step 3 (`newPhone`) and step 4 (a
///   malformed `device`) only; steps 1 and 2 document no such answer.
/// - `401 registration_token_invalid` (steps 2, 3, 4) -> [UnauthorizedException]:
///   the recovery id or rebind token expired, was consumed or is wrong; the
///   flow restarts from the top. **It is not `authentication_required`**, so
///   the auth interceptor passes it through untouched - no refresh, no sign-out.
/// - `409 phone_already_registered` (step 3) - the new number is another
///   account's.
/// - `429 otp_throttled` (steps 1-4). **No duration is read or assumed**: the
///   contract states none for the recovery ladder, and nothing here has a
///   timer for it.
/// - `403 account_banned` (steps 2, 4) - returned only after a verified code;
///   no tokens or session were issued. The contract says that, and says
///   nothing about the code being consumed on these two arms (it says so for
///   `verifyOtp` alone), so nothing here assumes it either way.
/// - no connection / timeout -> [NetworkException].
///
/// **PII.** The request carries phone numbers and codes; the responses carry
/// a recovery id, a rebind token and a masked parent number. None of it is
/// logged, kept, or put in an error detail: the parse guard reports the runtime
/// type only.
class RecoveryRepository {
  RecoveryRepository(this._dio);

  final Dio _dio;

  /// Step 1 - `POST /auth/recovery/start`: look up the account by its OLD
  /// registered phone ([phone], E.164) and send a one-time code to the parent
  /// phone. This endpoint inherently confirms that an account exists, which is
  /// why its limits are stricter than login's.
  ///
  /// `recovery_unavailable` is ONE shared code for every reason the parent-phone
  /// rung cannot run (an unknown phone, an unusable parent number), on purpose,
  /// so the cases cannot be told apart.
  Future<RecoveryStartResult> startRecovery(String phone) {
    return _call(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/recovery/start',
        data: {'phone': phone},
      ),
      RecoveryStartResult.fromJson,
    );
  }

  /// Step 2 - `POST /auth/recovery/verify-parent`: verify the parent-phone
  /// [code] for [recoveryId]. The answer is the rebind token for steps 3 and 4.
  Future<ParentVerifiedResult> verifyParentOtp({
    required String recoveryId,
    required String code,
  }) {
    return _call(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/recovery/verify-parent',
        data: {'recoveryId': recoveryId, 'code': code},
      ),
      ParentVerifiedResult.fromJson,
    );
  }

  /// Step 3 - `POST /auth/recovery/new-phone`: submit the NEW phone
  /// ([newPhone], E.164); a code is sent to it. The parent's code proves
  /// guardianship and this step proves possession of the new number - otherwise
  /// a typo would lock the student out again.
  ///
  /// Answers `202` with the code's timing, the same `{resendAfterSeconds,
  /// expiresInSeconds}` shape `requestOtp` answers, so it is the same
  /// [OtpRequestResult]. `409 phone_already_registered` when the number belongs
  /// to another account.
  Future<OtpRequestResult> submitNewPhone({
    required String rebindToken,
    required String newPhone,
  }) {
    return _call(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/recovery/new-phone',
        data: {'rebindToken': rebindToken, 'newPhone': newPhone},
      ),
      OtpRequestResult.fromJson,
    );
  }

  /// Step 4 - `POST /auth/recovery/confirm`: verify the new phone's [code].
  /// On success the account's phone is replaced, [device] becomes the one
  /// active device, any previous session is revoked and the event is audited -
  /// recovery never grants a second concurrent session.
  ///
  /// **Recovery LOGS YOU IN.** The `200` body is an `AuthenticatedResult`
  /// (tokens + profile) - the existing type, not a new one - so the caller must
  /// store the tokens and flip `AuthController` exactly as the OTP
  /// `authenticated` fork does (including `markAuthenticated(studentId:)`, so
  /// the return target stays bound to this student). This repository stores
  /// nothing.
  Future<AuthenticatedResult> confirmRecovery({
    required String rebindToken,
    required String code,
    required DeviceInfo device,
  }) {
    return _call(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/recovery/confirm',
        data: {
          'rebindToken': rebindToken,
          'code': code,
          // `model` is optional (`DeviceInfo.required` is deviceId + platform)
          // and, when present, a string: an absent label is left out rather
          // than sent as `null`.
          'device': device.toJson()..removeWhere((_, value) => value == null),
        },
      ),
      (json) => switch (AuthResult.fromJson(json)) {
        final AuthenticatedResult result => result,
        // The contract documents 200 as AuthenticatedResult only. Anything
        // else is contract drift - surface it rather than coercing it.
        RegistrationRequiredResult() => throw const UnknownException(
          detail: 'confirmRecovery returned a non-authenticated result',
        ),
      },
    );
  }

  /// One round trip: send, decode with [decode], and keep the typed boundary -
  /// only an [AppException] ever leaves.
  Future<T> _call<T>(
    Future<Response<Map<String, dynamic>>> Function() send,
    T Function(Map<String, dynamic> json) decode,
  ) async {
    try {
      final res = await send();
      return decode(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // `decode` runs OUTSIDE Dio, so a body that breaks the contract throws a
      // TypeError / FormatException here. The runtime type only: the body
      // carries a recovery id, a rebind token, a masked guardian number and,
      // on the last step, a minor's profile.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final recoveryRepositoryProvider = Provider<RecoveryRepository>(
  (ref) => RecoveryRepository(ref.watch(dioProvider)),
);
