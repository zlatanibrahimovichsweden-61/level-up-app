import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/deletion_window.dart';

/// The only place that touches Dio for the caller's own account-deletion
/// request (adr-114).
///
/// Two operations on one path, `/me/deletion-request` (`openapi.yaml:1263`),
/// both `x-stability: stable`, authenticated, on the main [dioProvider]
/// (`AuthInterceptor` attaches the Bearer; `ErrorInterceptor` has already typed
/// the failure by the time it arrives here). Neither takes an id: the account
/// is the caller's, from the access token.
///
/// This is the data layer only. What the app DOES with the answers — the
/// confirm screen and its wording, purging the stored tokens, ending the
/// session, the entry row — is not here, and nothing in this file touches the
/// session.
///
/// **After a `202` this session is dead.** The server revokes the session and
/// refresh chain at request time, so a request made with the same token fails;
/// the caller must purge the token pair and send the student to sign-in. This
/// repository does neither, so that is a duty of whoever wires
/// [requestAccountDeletion] to a screen. If the answer to the request is ever
/// lost or unreadable (an [UnknownException], a dropped connection), the
/// request may still have been recorded: the next sign-in reads
/// `GET /me`'s `pendingDeletion`, which is the live truth.
///
/// Failures are rethrown as the interceptor typed them:
/// - `409 deletion_already_requested` → `ApiException`
///   (`isDeletionAlreadyRequested`): a request is already pending, this call
///   did NOT start a new window and did not move `effectiveAt`.
/// - `404 no_pending_deletion` → `ApiException` (`isNoPendingDeletion`).
/// - `401 authentication_required` / `session_superseded` →
///   [UnauthorizedException] (the interceptor refreshes or signs out first).
/// - no connection / timeout → [NetworkException].
///
/// `403 account_pending_deletion` is NOT an outcome of either call: they are
/// two of the four endpoints the rule exempts. Every other authenticated call
/// answers it during grace, which is `isAccountPendingDeletion`'s job.
///
/// Nothing in this file logs a time or a body.
class DeletionRepository {
  DeletionRepository(this._dio);

  final Dio _dio;

  /// `POST /me/deletion-request` — record a deletion request for the caller's
  /// own account and start the 30-day grace window. Answers `202` with the
  /// window ([DeletionWindow]).
  ///
  /// The request is reversible only inside that window, by signing in again and
  /// calling [cancelAccountDeletion]. A second request while one is pending is
  /// `409 deletion_already_requested`, deliberately explicit rather than an
  /// idempotent `202`, so the app can never show a fresh 30 days that is not
  /// real: read the live window from `GET /me` instead.
  Future<DeletionWindow> requestAccountDeletion() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>('/me/deletion-request');
      return DeletionWindow.fromJson(res.data!);
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

  /// `DELETE /me/deletion-request` — cancel the pending request inside the
  /// grace window. Answers `204`, so there is nothing to decode and nothing to
  /// return.
  ///
  /// One of the four authenticated endpoints a pending-deletion account may
  /// reach. On `204` the account is usable again on the very next request with
  /// the same token: the grace check is a live read, so nothing is cached and
  /// no token reissue is needed.
  ///
  /// `404 no_pending_deletion` means there is nothing to cancel — and also that
  /// erasure has begun executing for this account, when the window is over in
  /// fact and the request can no longer be withdrawn. It is surfaced as the
  /// typed `ApiException`, not swallowed: only the caller knows which of the
  /// two it is looking at.
  Future<void> cancelAccountDeletion() async {
    try {
      await _dio.delete<void>('/me/deletion-request');
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

final deletionRepositoryProvider = Provider<DeletionRepository>(
  (ref) => DeletionRepository(ref.watch(dioProvider)),
);
