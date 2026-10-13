import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/terms_acceptance.dart';

/// The only place that touches Dio for the caller's Terms acceptance.
///
/// Two operations on one path, `/me/terms-acceptance` (`openapi.yaml:1083`),
/// both `x-stability: stable`, authenticated, on the main [dioProvider]
/// (`AuthInterceptor` attaches the Bearer; `ErrorInterceptor` has already typed
/// the failure by the time it arrives here):
///
/// - [getTermsAcceptance] — `getTermsAcceptance`: the version the student must
///   accept, and what they have accepted.
/// - [acceptTerms] — `acceptTerms`: record that the caller accepts a version.
///
/// This is the RECORD of acceptance. The text of the Terms is a different
/// operation (`getLegalDocument`, `LegalRepository`), and "recorded, not
/// enforced" is the contract's own phrase: no other operation refuses a student
/// for not having accepted — except the photo operations, which answer
/// `403 terms_acceptance_required` (see `isTermsAcceptanceRequired`).
///
/// Failures are rethrown as the interceptor typed them:
/// - `401 authentication_required` / `session_superseded` →
///   [UnauthorizedException] (the interceptor refreshes or signs out first).
/// - `403 account_pending_deletion` → `ApiException`, recognised by
///   `isAccountPendingDeletion`; not retried, not a sign-out.
/// - `400 validation_failed` on `termsVersion` ([acceptTerms] only) →
///   [ValidationException]; see `isTermsVersionRejected`.
/// - no connection / timeout → [NetworkException].
///
/// Nothing in this file logs a version, a time or a body.
class TermsRepository {
  TermsRepository(this._dio);

  final Dio _dio;

  /// The contract's `maxLength` on a Terms version (`currentVersion`,
  /// `acceptedVersion`, `termsVersion`).
  static const maxVersionLength = 32;

  /// `GET /me/terms-acceptance` — the caller's own record; the student comes
  /// from the access token, so there is no id anywhere in the request.
  Future<TermsAcceptance> getTermsAcceptance() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/me/terms-acceptance');
      return TermsAcceptance.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // fromJson runs OUTSIDE Dio, so a body that breaks the contract throws a
      // TypeError / FormatException here. The runtime type only: never the
      // body.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `POST /me/terms-acceptance` — record that the caller accepts
  /// [termsVersion], which must be the `currentVersion` the latest
  /// [getTermsAcceptance] returned. The server records the time; the request
  /// carries none.
  ///
  /// **Idempotent**: accepting a version already accepted is `204` and changes
  /// nothing (the first acceptance time stands), so a repeat is safe. A later
  /// version adds a new record and keeps the earlier ones. Answers `204`, so
  /// there is nothing to decode and nothing to return — read
  /// [getTermsAcceptance] for the new state.
  ///
  /// `400 validation_failed` on `termsVersion` means absent, empty, not a
  /// string, or **not equal to the currently required version — including when
  /// no version is configured**. The response never says which version is
  /// required: re-read [getTermsAcceptance].
  Future<void> acceptTerms(String termsVersion) async {
    assert(
      termsVersion.isNotEmpty && termsVersion.length <= maxVersionLength,
      'termsVersion must be 1..$maxVersionLength characters — it is the '
      'currentVersion the server served, which has the same bound.',
    );
    try {
      await _dio.post<void>(
        '/me/terms-acceptance',
        data: {'termsVersion': termsVersion},
      );
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

final termsRepositoryProvider = Provider<TermsRepository>(
  (ref) => TermsRepository(ref.watch(dioProvider)),
);
