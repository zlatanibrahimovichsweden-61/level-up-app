import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/entitlement_state.dart';
import '../models/student_profile.dart';

/// The only place that touches Dio for the signed-in student's own profile.
/// Returns domain models, throws the typed [AppException] hierarchy; notifiers
/// catch these and the UI never sees Dio.
///
/// Both endpoints are `x-stability: stable` and authenticated — they ride the
/// main [dioProvider], so the AuthInterceptor attaches the Bearer and handles
/// the 401 refresh/retry. A `session_superseded` 401 surfaces here as an
/// `UnauthorizedException` after the interceptor has already forced the logout.
class ProfileRepository {
  ProfileRepository(this._dio);

  final Dio _dio;

  /// `GET /me` — identity, geography, points/level/badges, privacy, and the
  /// embedded entitlements for first paint.
  Future<StudentProfile> getMe() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/me');
      return StudentProfile.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    }
  }

  /// `GET /me/entitlements` — the paywall source of truth. The contract says to
  /// refetch this on app resume and when the checkout deep link returns; the
  /// resume half is wired in `entitlementsProvider`.
  Future<List<EntitlementState>> getEntitlements() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/me/entitlements');
      return EntitlementsResponse.fromJson(res.data!).items;
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

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(dioProvider)),
);
