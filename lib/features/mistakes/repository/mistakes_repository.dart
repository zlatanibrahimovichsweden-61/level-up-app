import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/mistakes_subject.dart';
import '../models/mistakes_tree.dart';

/// The only place that touches Dio for the Mistakes flow.
///
/// Both operations are `x-stability: stable` (contract 3.10.0-m1, vendored at
/// `2dca3c5`) and authenticated, so they ride the main [dioProvider] and the
/// AuthInterceptor attaches the Bearer.
///
/// **Neither call takes scope parameters.** The server derives the student's
/// scope from the token; the only client-supplied value on this entire surface
/// is `subjectId`. If you ever find yourself adding a query parameter here, the
/// contract is being worked around.
///
/// **Neither path paginates, deliberately** — both sets are closed and bounded
/// by the caller's own enrolment and history, so there is no cursor and the
/// contract says none will be added.
class MistakesRepository {
  MistakesRepository(this._dio);

  final Dio _dio;

  /// `GET /me/mistakes` — a BARE array, like `GET /catalog/subjects`.
  ///
  /// **An empty list is a NORMAL response**, not an error: it is the record of
  /// a student who has nothing outstanding. A subject with zero current
  /// mistakes is absent from the array rather than present with `0`, which is
  /// why `mistakeCount` publishes `minimum: 1`. Callers MUST NOT render
  /// empty-as-error.
  ///
  /// The result is already ordered (`name` ascending, then `id`) — return it
  /// untouched rather than sorting.
  ///
  /// A `403` arrives here as an [ApiException] carrying the contract's own
  /// code. ⚠️ **`insufficient_scope` on THIS route does not mean what it means
  /// on [getMistakesForSubject].** Here it means the caller has no active
  /// enrolment to scope a history against — reachable in ordinary use, because
  /// a track transfer closes the old enrolment before the new one opens
  /// (adr-032). It is not a membership refusal about any subject, not a reason
  /// to log out, and the screen renders it as "your enrolment is between
  /// states". `account_pending_deletion` is the other possible code and belongs
  /// to the global interceptor, not to this feature.
  Future<List<MistakesSubject>> getMistakes() async {
    try {
      final res = await _dio.get<List<dynamic>>('/me/mistakes');
      return (res.data ?? const [])
          .map((e) => MistakesSubject.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
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

  /// `GET /me/mistakes/subjects/{subjectId}` — the pruned, summed tree for ONE
  /// subject, in one call.
  ///
  /// **A `200` with `mistakeCount: 0` and an empty child list is NORMAL** — an
  /// in-scope subject the student has nothing outstanding in. A `subjectId`
  /// outside the caller's scope is `403 insufficient_scope` instead. The two
  /// are different states and both are reachable with an empty history, so
  /// callers **branch on the status, never on emptiness**.
  ///
  /// That `403`'s two causes — "not in your scope" and "no enrolment at all" —
  /// are **deliberately indistinguishable and must stay so**; it is the same
  /// answer `getSubjectTree` gives about the same id, so nothing new is
  /// learnable from it (see `seif_fight.md` S41).
  Future<MistakesTree> getMistakesForSubject(String subjectId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/me/mistakes/subjects/$subjectId',
      );
      final json = res.data!;
      // The contract's `discriminator: {propertyName: track, mapping: {...}}`,
      // mirrored one-for-one. Dispatching on the key BEFORE parsing is what
      // keeps a university payload from being fed to the school model, where
      // the missing `units` would surface as a raw TypeError out of generated
      // code.
      //
      // A third value is contract drift, not a client bug: it fails loudly with
      // a typed error instead of rendering an empty screen.
      return switch (json['track']) {
        'school' => SchoolMistakesTree.fromJson(json),
        'university' => UniversityMistakesTree.fromJson(json),
        final track => throw UnknownException(
          detail: 'unsupported mistakes tree track: $track',
        ),
      };
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01 — see getMistakes.
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

final mistakesRepositoryProvider = Provider<MistakesRepository>(
  (ref) => MistakesRepository(ref.watch(dioProvider)),
);
