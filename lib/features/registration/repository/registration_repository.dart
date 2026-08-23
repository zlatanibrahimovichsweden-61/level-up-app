import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/models/auth_result.dart';
import '../models/registration_body.dart';

/// The only place that touches Dio for `POST /auth/register`. Returns the
/// domain model, throws the typed [AppException] hierarchy.
///
/// The endpoint is `x-stability: stable` and `security: []` — registration
/// happens before any account exists, so it rides the main [dioProvider] with
/// no Bearer attached (the AuthInterceptor adds none when storage is empty).
///
/// **Register LOGS YOU IN.** The `201` body is an `AuthenticatedResult`
/// (tokens + profile), so the caller must store tokens and flip
/// `AuthController` exactly as the OTP `authenticated` fork does.
///
/// The error mapping is entirely the ErrorInterceptor's job; this just unwraps:
/// - `400 validation_failed` → [ValidationException] (field map)
/// - `401 registration_token_invalid` → [UnauthorizedException]
/// - `409 phone_already_registered` → [ApiException]
///
/// Nothing here logs the body: it carries the student's name, date of birth and
/// parent's phone (minors' data — never logged, not even in debug).
class RegistrationRepository {
  RegistrationRepository(this._dio);

  final Dio _dio;

  /// Completes registration, consuming the `registrationToken`.
  ///
  /// [body] is one of the two discriminated shapes (`SchoolRegistration` /
  /// `UniversityRegistration`); `track` inside the JSON is what the server
  /// switches on.
  Future<AuthenticatedResult> register(RegistrationBody body) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: body.toJson(),
      );
      final result = AuthResult.fromJson(res.data!);
      return switch (result) {
        AuthenticatedResult() => result,
        // The contract documents 201 as AuthenticatedResult only. Anything else
        // is contract drift — surface it rather than silently coercing it.
        RegistrationRequiredResult() => throw const UnknownException(
          detail: 'register returned a non-authenticated result',
        ),
      };
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

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final registrationRepositoryProvider = Provider<RegistrationRepository>(
  (ref) => RegistrationRepository(ref.watch(dioProvider)),
);
