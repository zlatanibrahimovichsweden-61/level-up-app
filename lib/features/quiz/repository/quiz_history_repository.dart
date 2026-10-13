import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../registration/models/reference_models.dart' show CursorPage;
import '../models/favorite_question.dart';
import '../models/quiz_history_item.dart';
import '../models/quiz_review_page.dart';

/// The only place that touches Dio for quiz history, the quiz review and the
/// favourites pool (CW16a data layer).
///
/// Five operations, all `x-stability: stable` with no `x-consumers`
/// (`openapi.yaml:1877`, `:1912`, `:2106`, `:2118`, `:2131`), authenticated and
/// on the main [dioProvider]: `AuthInterceptor` attaches the Bearer and
/// `ErrorInterceptor` has already mapped failures by the time they arrive here.
///
/// It sits beside, not inside, `QuizRepository`: that one is the quiz ENGINE
/// (create, answer, finish, explain) and feeds the Bloc; this one is the
/// student's record of past quizzes and their question pool. Nothing consumes
/// it yet - there is no provider, notifier or screen over it, and release
/// scope for history and favourites is an open owner ruling (N-11).
///
/// **Server-authoritative.** Nothing here grades, scores, counts or orders.
/// Pages come back in the server's order and [QuizReview] keeps the totals the
/// server froze at finish.
///
/// Every call is **default-denied** while the account is inside its 30-day
/// deletion grace window: `403 account_pending_deletion`, mapped to an
/// `ApiException` and recognised by `isAccountPendingDeletion`. It is surfaced
/// untouched - no retry, no sign-out.
class QuizHistoryRepository {
  QuizHistoryRepository(this._dio);

  final Dio _dio;

  /// The contract's published bound on `limit` (`Limit` parameter). It is
  /// **validated, not clamped**: a value outside 1-100 is
  /// `400 validation_failed` on field `limit`.
  static const minLimit = 1;
  static const maxLimit = 100;

  /// `GET /quizzes` - one page of the caller's own FINISHED quizzes, newest
  /// started first (quiz id as the tie-break). An open quiz appears the moment
  /// it is finished. Not release-gated and not entitlement-gated: a student who
  /// left a Track still sees their history.
  ///
  /// **Branch on `hasMore`, never on `items.length`.** This returns the
  /// envelope untouched so that signal survives.
  ///
  /// [cursor] is the contract's OPAQUE keyset token: follow it, never parse or
  /// construct it. `null` means the first page. A malformed cursor, or a
  /// [limit] outside 1-100, is a [ValidationException] (`400`).
  Future<CursorPage<QuizHistoryItem>> listQuizHistory({
    String? cursor,
    int? limit,
  }) => _page(
    '/quizzes',
    cursor: cursor,
    limit: limit,
    fromJson: QuizHistoryItem.fromJson,
  );

  /// `GET /quizzes/{quizId}` - the review of one FINISHED quiz of the caller's
  /// own: the questions, the student's answers and, for each question they
  /// answered, the correct option.
  ///
  /// Two different `403`s, both surfaced untouched as an [ApiException] -
  /// **branch on `code`**:
  /// - `insufficient_scope` - the id is unknown, malformed, or another
  ///   student's. All three are one indistinguishable refusal on purpose
  ///   (adr-178 D2), and there is deliberately no `404`.
  /// - `quiz_not_finished` - the caller's OWN quiz is still open. Finish it
  ///   (`QuizRepository.finishQuiz`), then review. Checked only after
  ///   ownership, so it never describes someone else's quiz.
  Future<QuizReview> getQuizReview(String quizId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/quizzes/${Uri.encodeComponent(quizId)}',
      );
      return QuizReview.fromJson(res.data!);
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw _parseFailure(e);
    }
  }

  /// `PUT /questions/{questionId}/favorite` - favourite a Question. Answers
  /// `204`, so there is nothing to decode and nothing to return.
  ///
  /// **Idempotent**: favouriting an already-favourite question is `204` too, so
  /// a retry after a dropped response is safe. The contract documents no other
  /// outcome than `204` and `401` for this operation; anything else (including
  /// `account_pending_deletion`) surfaces as the typed [ApiException].
  Future<void> addFavorite(String questionId) async {
    try {
      await _dio.put<void>(_favoritePath(questionId));
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    }
  }

  /// `DELETE /questions/{questionId}/favorite` - unfavourite a Question.
  /// Answers `204`.
  ///
  /// **Idempotent**: removing a question that is not a favourite is `204` too.
  Future<void> removeFavorite(String questionId) async {
    try {
      await _dio.delete<void>(_favoritePath(questionId));
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    }
  }

  /// `GET /me/favorites` - one page of the caller's favourited Questions. The
  /// list is exactly the pool a `mode: favorites` quiz can draw from. The
  /// contract does not state the order, so none is assumed: keep the page as
  /// received.
  ///
  /// **Branch on `hasMore`, never on `items.length`**: a page may be short
  /// while `hasMore` is true.
  ///
  /// [cursor] is OPAQUE, as for [listQuizHistory]. A malformed or foreign
  /// cursor, or a [limit] outside 1-100, is a [ValidationException] (`400`).
  Future<CursorPage<FavoriteQuestion>> listFavorites({
    String? cursor,
    int? limit,
  }) => _page(
    '/me/favorites',
    cursor: cursor,
    limit: limit,
    fromJson: FavoriteQuestion.fromJson,
  );

  String _favoritePath(String questionId) =>
      '/questions/${Uri.encodeComponent(questionId)}/favorite';

  Future<CursorPage<T>> _page<T>(
    String path, {
    required String? cursor,
    required int? limit,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    assert(
      limit == null || (limit >= minLimit && limit <= maxLimit),
      'limit must be $minLimit..$maxLimit - the server rejects anything else '
      'with 400 validation_failed rather than clamping it.',
    );
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        path,
        // Absent, not null: a `cursor: null` would be a malformed cursor (400).
        queryParameters: {'cursor': ?cursor, 'limit': ?limit},
      );
      return CursorPage<T>.fromJson(
        res.data!,
        (json) => fromJson(json! as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw _parseFailure(e);
    }
  }

  /// F-7-01: `fromJson` runs OUTSIDE Dio - real-API schema drift throws a core
  /// TypeError/FormatException there, not a DioException. Wrap it so the typed
  /// boundary holds. runtimeType only: a question stem and a subject name are
  /// exactly what must never leak into an error detail.
  AppException _parseFailure(Object e) =>
      UnknownException(detail: 'parse: ${e.runtimeType}');

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final quizHistoryRepositoryProvider = Provider<QuizHistoryRepository>(
  (ref) => QuizHistoryRepository(ref.watch(dioProvider)),
);
