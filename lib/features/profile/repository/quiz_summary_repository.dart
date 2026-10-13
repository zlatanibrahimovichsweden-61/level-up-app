import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/quiz_summary_solved.dart';

/// The only place that touches Dio for the Profile "Solved Questions" number
/// (CW16b data layer).
///
/// One operation, `x-stability: stable` with no `x-consumers`
/// (`openapi.yaml:1731`), authenticated and on the main [dioProvider]. It is a
/// file of its own so `ProfileRepository` does not grow a method nothing may
/// call yet.
///
/// **Unconsumed on purpose.** No provider, notifier or screen reads
/// [QuizSummaryRepository.getMyQuizSummary]: displaying the number reopens the
/// "Points only" Profile ruling, an owner decision (N-17) that is still
/// pending. Only the repository provider below exists.
class QuizSummaryRepository {
  QuizSummaryRepository(this._dio);

  final Dio _dio;

  /// `GET /me/quiz-summary` - distinct questions the caller has ever answered
  /// correctly, one server-computed integer. The caller comes from the token:
  /// there is no id in the path, the query or a header.
  ///
  /// Not `QuestionCounter.answered`, and never to be reconciled with it,
  /// summed from it or derived from `finishQuiz`'s `answeredCount` or from
  /// Mistakes. The app displays this number as received.
  ///
  /// The contract bounds it at `minimum: 0`; a negative count is schema drift
  /// and fails loudly as an [UnknownException] rather than reaching a screen.
  ///
  /// `403 account_pending_deletion` (this operation is not on the four-endpoint
  /// allowlist) surfaces untouched as an [ApiException]: the contract says not
  /// to log out and not to retry.
  Future<QuizSummarySolved> getMyQuizSummary() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/me/quiz-summary');
      final summary = QuizSummarySolved.fromJson(res.data!);
      if (summary.solvedQuestions < 0) {
        throw const UnknownException(
          detail: 'quiz-summary: solvedQuestions below the contract minimum',
        );
      }
      return summary;
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio - real-API schema drift throws a
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

final quizSummaryRepositoryProvider = Provider<QuizSummaryRepository>(
  (ref) => QuizSummaryRepository(ref.watch(dioProvider)),
);
