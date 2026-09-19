import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../registration/models/reference_models.dart';
import '../models/leaderboard_models.dart';

/// The only place that touches Dio for the leaderboard.
///
/// One endpoint: `GET /leaderboard`. `GET /leaderboard/me` is deliberately NOT
/// called — the product decision is that the student sees their own row only
/// when it is genuinely on the board (inside the top 200), and the contract is
/// explicit that a self-rank must not be injected as a synthetic row:
/// *"Do not add a synthetic self-rank row to the board."*
class LeaderboardRepository {
  LeaderboardRepository(this._dio);

  final Dio _dio;

  /// The contract's published bound on `limit`.
  ///
  /// It is **validated, not clamped**: a value outside 1–100 comes back as
  /// `400 validation_failed` on field `limit` rather than being quietly
  /// reduced. Nothing here clamps either — a bad page size is a bug in the
  /// caller, and hiding it would only move the failure somewhere quieter.
  static const minLimit = 1;
  static const maxLimit = 100;

  /// `GET /leaderboard` — one page of the scoped, privacy-filtered board.
  ///
  /// [cursor] is **opaque, server-signed and expiring**, and is valid only for
  /// the [scope] it was issued for. Echo it back unchanged: it cannot be
  /// decoded or constructed, and an altered, expired or foreign-scope token is
  /// `validation_failed` on field `cursor`. Omit it for the first page.
  ///
  /// A page may carry FEWER rows than [limit] — including zero — while
  /// `hasMore` is `true`. Callers must page on `hasMore`, never on page size.
  Future<CursorPage<LeaderboardEntry>> getLeaderboard({
    required LeaderboardScope scope,
    String? cursor,
    int? limit,
  }) async {
    assert(
      limit == null || (limit >= minLimit && limit <= maxLimit),
      'limit must be $minLimit..$maxLimit — the server rejects anything else '
      'with 400 validation_failed rather than clamping it.',
    );
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/leaderboard',
        queryParameters: {
          'scope': scope.wire,
          'cursor': ?cursor,
          'limit': ?limit,
        },
      );
      return CursorPage<LeaderboardEntry>.fromJson(
        res.data!,
        (json) => LeaderboardEntry.fromJson(json! as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // fromJson runs OUTSIDE Dio — real-API schema drift throws a core
      // TypeError/FormatException here, not a DioException. Wrap it so the
      // typed boundary holds. runtimeType only: board rows carry minors'
      // names and scores and must never leak into an error detail.
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

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => LeaderboardRepository(ref.watch(dioProvider)),
);
