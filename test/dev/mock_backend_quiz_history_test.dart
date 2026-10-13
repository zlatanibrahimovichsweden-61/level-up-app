import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_quiz_history.dart';
import 'package:level_up_app/features/catalog/repository/catalog_modules_repository.dart';
import 'package:level_up_app/features/profile/repository/quiz_summary_repository.dart';
import 'package:level_up_app/features/quiz/repository/quiz_history_repository.dart';

/// The six quiz-history operations and `GET /catalog/modules`, reached through
/// the real `buildMockDio` chain (MockBackendInterceptor -> ErrorInterceptor)
/// and the real repositories.
///
/// The rules themselves (paging, validation, the two 403s, idempotent 204s) are
/// pinned in `mock_quiz_history_test.dart` and `mock_modules_test.dart`; this
/// proves the dispatch blocks in `mock_backend.dart` are wired, and that the
/// quiz-engine routes around them still answer.
void main() {
  test('the six quiz-history operations answer through buildMockDio', () async {
    final dio = buildMockDio(latency: Duration.zero);
    final history = QuizHistoryRepository(dio);

    final page = await history.listQuizHistory();
    expect(page.items, hasLength(20));
    expect(page.hasMore, isTrue);

    final review = await history.getQuizReview(page.items.first.id);
    expect(review.questions, isNotEmpty);

    final favourited = mockHistoryQuestionId(23);
    await history.addFavorite(favourited);
    final favourites = await history.listFavorites();
    expect(favourites.items.first.questionId, favourited);
    await history.removeFavorite(favourited);

    final summary = await QuizSummaryRepository(dio).getMyQuizSummary();
    expect(summary.solvedQuestions, greaterThan(0));

    await expectLater(
      history.getQuizReview(kMockOpenQuizId),
      throwsA(
        isA<ApiException>()
            .having((e) => e.status, 'status', 403)
            .having((e) => e.code, 'code', 'quiz_not_finished'),
      ),
    );
  });

  test('GET /catalog/modules follows the mock session track', () async {
    final dio = buildMockDio(latency: Duration.zero);
    final modules = CatalogModulesRepository(dio);

    // The mock starts as a School session: no modules.
    expect(await modules.listModules(), isEmpty);

    // `111111` is the OTP screen's University magic code.
    await dio.post<Object?>(
      '/auth/otp/verify',
      data: <String, dynamic>{'phone': '+201001234567', 'code': '111111'},
    );

    expect(await modules.listModules(), hasLength(4));
  });

  test('the quiz-engine routes around the new ones still work', () async {
    final dio = buildMockDio(latency: Duration.zero);

    final started = await dio.post<Map<String, dynamic>>(
      '/quizzes',
      data: <String, dynamic>{
        'mode': 'normal',
        'length': 10,
        'lessonId': 'bio-u1-c1-l1',
      },
    );
    expect(started.statusCode, 201);

    try {
      await dio.get<Object?>('/definitely/not/a/route');
      fail('an unknown route must be refused');
    } on DioException catch (e) {
      expect(e.response?.statusCode, 404);
    }
  });
}
