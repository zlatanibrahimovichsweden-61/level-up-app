import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/student_profile.dart';
import '../models/track_transfer_request.dart';

/// The only place that touches Dio for the Track transfer
/// (`POST /me/track-transfer`, `transferToUniversity`, `x-stability: stable`,
/// `openapi.yaml:1338`).
///
/// A sibling of `ProfileRepository`, not an addition to it: that class is the
/// student's own profile reads and edits, and this is a one-off, irreversible
/// action with its own refusals.
///
/// **Data layer only (CW14).** No screen calls this yet: the Profile row and its
/// confirm dialog stay as they are until the design (DG-20), the row's
/// visibility rule (N-09) and the disclosure copy (H-13) are settled.
///
/// Authenticated and on the main [dioProvider]: `AuthInterceptor` attaches the
/// Bearer and `ErrorInterceptor` has already mapped failures by the time they
/// arrive here, so every failure is rethrown as the typed [AppException] the
/// interceptor produced.
///
/// **The `200` is the refreshed `StudentProfile`**, "the same schema as
/// `getMyProfile`" - now on the University track - "so the client re-renders
/// without a second call". It decodes with the existing [StudentProfile], and
/// the caller is expected to REPLACE its cached `GET /me` with it
/// (`meProvider`), not merge into it: the `school` block is gone, `university`
/// is populated, and `points.school` / `points.university` / `points.total` are
/// whatever the server says. Nothing is recomputed here.
///
/// **The refusals arrive as typed `ApiException`s, untouched:**
/// - `403 account_pending_deletion` - `isAccountPendingDeletion`;
/// - `409 track_transfer_not_allowed` - `isTrackTransferNotAllowed`;
/// - `403 track_transfer_not_eligible` - `isTrackTransferNotEligible`;
/// - `400 validation_failed` - a `ValidationException` carrying the field map
///   (`universityId` / `facultyId` / `studyYearId` / `acknowledgeIrreversible`).
///
/// A refused call changes nothing server-side, and nothing here retries it.
///
/// Nothing in this file logs a body, an id or a field.
class TrackTransferRepository {
  TrackTransferRepository(this._dio);

  final Dio _dio;

  /// `POST /me/track-transfer` - move the caller from the School track to the
  /// University track. **Permanent, once only.** The body is exactly
  /// [request]'s four contract keys, `acknowledgeIrreversible: true` included.
  Future<StudentProfile> transferToUniversity(
    TrackTransferRequest request,
  ) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/me/track-transfer',
        data: request.toJson(),
      );
      return StudentProfile.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // fromJson runs OUTSIDE Dio - real-API schema drift throws a core
      // TypeError/FormatException here, not a DioException. Wrap it so the
      // typed boundary holds. runtimeType only: response bodies carry minors'
      // data and must never leak into an error detail.
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

final trackTransferRepositoryProvider = Provider<TrackTransferRepository>(
  (ref) => TrackTransferRepository(ref.watch(dioProvider)),
);
