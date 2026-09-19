import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/answer_result.dart';
import '../models/explanation_result.dart';
import '../models/quiz.dart';
import '../models/quiz_mode.dart';
import '../models/quiz_setup_args.dart';
import '../models/quiz_summary.dart';

/// The only place that touches Dio for the quiz engine.
///
/// All four endpoints are `x-stability: stable` and authenticated, so they ride
/// the main [dioProvider] and the AuthInterceptor attaches the Bearer.
///
/// Every method throws a typed [AppException] — the ErrorInterceptor has
/// already mapped the failure, this just unwraps it. The Bloc catches these and
/// turns them into states; it never sees Dio.
///
/// **Nothing here grades, scores or awards.** The repository posts what the
/// student did and hands back what the server decided.
class QuizRepository {
  QuizRepository(this._dio);

  final Dio _dio;

  /// `POST /quizzes` → `201 Quiz`.
  ///
  /// The body is built FROM [scope], which is why `lessonId` and `lectureId`
  /// can never both be sent: [QuizSetupArgs]'s two constructors make that
  /// combination unrepresentable, so there is no validation to forget here.
  /// School contributes `lessonId`; university contributes `lectureId` +
  /// `quizType`. Null fields are OMITTED, not sent as null — the contract lists
  /// them as optional properties, and an explicit `null` is a different thing
  /// from an absent key (same rule as Day 3's registration body).
  ///
  /// [mode] is a parameter rather than a hardcoded `"normal"`: the day
  /// `retakeWrong` is enabled, this method does not change.
  ///
  /// Throws [ApiException] carrying the contract's own code —
  /// `weekly_question_limit_reached` / `subscription_required` /
  /// `insufficient_scope` (403), `not_enough_questions` (422),
  /// `validation_failed` (400) — for the caller to branch on.
  Future<Quiz> createQuiz({
    required QuizSetupArgs scope,
    required QuizLength length,
    QuizMode mode = QuizMode.normal,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/quizzes',
        data: <String, dynamic>{
          'mode': mode.name,
          'length': length.value,
          if (scope.lessonId != null) 'lessonId': scope.lessonId,
          if (scope.lectureId != null) 'lectureId': scope.lectureId,
          if (scope.quizType != null) 'quizType': scope.quizType!.name,
        },
      );
      return Quiz.fromJson(res.data!);
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

  /// `POST /quizzes/{quizId}/answers` → `200 AnswerResult`.
  ///
  /// Idempotent on `(quizId, questionId)`: a retry returns the ORIGINAL verdict
  /// and `correctOptionId` with `pointsDelta: 0` (adr-102 D2) and never
  /// double-awards. That is a server guarantee the app relies on
  /// rather than duplicating — there is no client-side "already sent" guard
  /// here, because the failure this method actually has to survive is a dropped
  /// RESPONSE to a request the server did process.
  ///
  /// Throws [ApiException] with `quiz_already_finished` (409),
  /// `weekly_question_limit_reached` or `insufficient_scope` (403).
  Future<AnswerResult> submitAnswer({
    required String quizId,
    required String questionId,
    required String optionId,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/quizzes/$quizId/answers',
        data: <String, dynamic>{'questionId': questionId, 'optionId': optionId},
      );
      return AnswerResult.fromJson(res.data!);
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

  /// `POST /quizzes/{quizId}/finish` → `200 QuizSummary`.
  ///
  /// Also idempotent — repeat calls return the same summary — so a retry after
  /// a dropped response is safe and cannot award twice.
  Future<QuizSummary> finishQuiz(String quizId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/quizzes/$quizId/finish',
      );
      return QuizSummary.fromJson(res.data!);
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

  /// `GET /questions/{questionId}/explanation` → `200` **or `202`**.
  ///
  /// The status code is the discriminator, so this reads
  /// [Response.statusCode] rather than the body's `status` field — Dio treats
  /// both as success (202 is inside the default 200–299 validation), so neither
  /// arrives as a DioException.
  ///
  /// A `403 insufficient_scope` means the caller has not answered that question
  /// yet. That is EXPECTED, not a bug, and it still throws — the Bloc only
  /// requests an explanation after a grade exists, so a 403 reaching a caller
  /// signals a real ordering mistake and should not be swallowed here.
  ///
  /// Single-shot on purpose: the polling cadence is a session-state decision
  /// and lives in the Bloc, which can cancel it. A repository that slept and
  /// retried on its own would be untestable and uncancellable.
  Future<ExplanationResult> getExplanation(String questionId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/questions/$questionId/explanation',
      );
      if (res.statusCode == 202) return const ExplanationGenerating();

      final text = res.data?['text'];
      // A 200 whose body has no `text` is contract drift: the schema marks it
      // required. Fail loudly rather than rendering an empty panel that looks
      // like the AI had nothing to say.
      if (text is! String) {
        throw const UnknownException(detail: 'explanation 200 without text');
      }
      return ExplanationReady(text);
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

final quizRepositoryProvider = Provider<QuizRepository>(
  (ref) => QuizRepository(ref.watch(dioProvider)),
);
