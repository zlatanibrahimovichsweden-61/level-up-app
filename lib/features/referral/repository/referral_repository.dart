import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/my_invite.dart';

/// The only place that touches Dio for the student's Refer a Friend record.
///
/// One operation, `GET /me/invite` (`getMyInvite`, `x-stability: stable`,
/// `openapi.yaml:1434`), authenticated and on the main [dioProvider]:
/// `AuthInterceptor` attaches the Bearer and `ErrorInterceptor` has already
/// mapped failures by the time they arrive here, so every failure is rethrown
/// as the typed [AppException] the interceptor produced.
///
/// **Data layer only (CW15).** No screen calls this yet: the Refer a Friend
/// screen stays the inert shell until the reward copy (H-01), the share
/// mechanism (N-05) and the redrawn frame (DG-21) are settled.
///
/// The call takes no id - the student is taken from the access token - and
/// sends no body or query. Its first call CREATES the student's code
/// server-side; every later call returns the same code with fresh counts, so
/// nothing is cached here.
///
/// **`403 account_pending_deletion`** (adr-114, inside the 30-day grace window)
/// is surfaced untouched as an `ApiException`, recognised by
/// `isAccountPendingDeletion`. The contract's client rule is *route to the
/// cancel screen*: no retry, no sign-out, and nothing in this file swallows or
/// reinterprets it.
///
/// **Nothing here logs.** The invite code identifies a student's referral
/// link, so it is never printed, never put in an error `detail` (a decode
/// failure reports the runtime type only), and never echoed by [MyInvite]'s
/// `toString`.
class ReferralRepository {
  ReferralRepository(this._dio);

  final Dio _dio;

  /// `GET /me/invite` - the caller's invite code and its two counts.
  Future<MyInvite> getMyInvite() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/me/invite');
      return MyInvite.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // fromJson runs OUTSIDE Dio - real-API schema drift throws a core
      // TypeError/FormatException here, not a DioException. Wrap it so the
      // typed boundary holds. runtimeType only: the response body carries the
      // invite code, which must never leak into an error detail.
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

final referralRepositoryProvider = Provider<ReferralRepository>(
  (ref) => ReferralRepository(ref.watch(dioProvider)),
);
