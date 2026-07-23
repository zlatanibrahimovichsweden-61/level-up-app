import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/auth_result.dart';
import '../models/device_info.dart';
import '../models/otp_request_result.dart';

/// The only place that touches Dio for auth. Returns domain models, throws the
/// typed [AppException] hierarchy. Notifiers catch these; the UI never sees Dio.
///
/// Both endpoints are `x-stability: stable` in contract/openapi.yaml and take
/// no auth (`security: []`).
class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

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

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider)),
);
