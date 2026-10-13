import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/features/profile/repository/quiz_summary_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// `getMyQuizSummary` (CW16b data layer) - the Profile "Solved Questions"
/// number. Nothing consumes it yet (owner ruling N-17 is pending); these tests
/// pin the data layer so the day it is ruled in, the call is already right.
void main() {
  late _MockDio dio;
  late QuizSummaryRepository repo;

  const path = '/me/quiz-summary';

  setUp(() {
    dio = _MockDio();
    repo = QuizSummaryRepository(dio);
  });

  Response<Map<String, dynamic>> response(Map<String, dynamic>? data) =>
      Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: path),
    error: mapped,
  );

  void stub(Map<String, dynamic>? body) {
    when(
      () => dio.get<Map<String, dynamic>>(path),
    ).thenAnswer((_) async => response(body));
  }

  test('GETs /me/quiz-summary with no id, no query and no body', () async {
    stub({'solvedQuestions': 12});

    final summary = await repo.getMyQuizSummary();

    // The caller comes from the token: there is nothing else to send. The stub
    // and this verify name the path alone, and mocktail matches an invocation's
    // named arguments exactly, so a call that added a `queryParameters` would
    // match neither and fail.
    verify(() => dio.get<Map<String, dynamic>>(path)).called(1);
    expect(summary.solvedQuestions, 12);
  });

  test('zero is a normal answer', () async {
    stub({'solvedQuestions': 0});

    expect((await repo.getMyQuizSummary()).solvedQuestions, 0);
  });

  test('the number is returned as received - no arithmetic', () async {
    // Not QuestionCounter.answered, not finishQuiz's answeredCount: the app
    // displays what the server says and never reconciles it with those.
    stub({'solvedQuestions': 1234});

    expect((await repo.getMyQuizSummary()).solvedQuestions, 1234);
  });

  test(
    'a negative count breaks the contract minimum and fails loudly',
    () async {
      stub({'solvedQuestions': -1});

      await expectLater(
        repo.getMyQuizSummary(),
        throwsA(
          isA<UnknownException>().having(
            (e) => e.detail,
            'detail',
            contains('quiz-summary'),
          ),
        ),
      );
    },
  );

  test('surfaces the mapped failures untouched', () async {
    for (final error in <AppException>[
      const UnauthorizedException(code: 'authentication_required'),
      const UnauthorizedException(code: 'session_superseded'),
      // Not on the four-endpoint allowlist: refused while the account is in its
      // deletion grace window. The contract says do not log out, do not retry.
      const ApiException(status: 403, code: 'account_pending_deletion'),
      const OfflineException(),
      const NetworkException(detail: 'timeout'),
      const ApiException(status: 500, code: 'internal_error'),
    ]) {
      when(() => dio.get<Map<String, dynamic>>(path)).thenThrow(failure(error));

      await expectLater(
        repo.getMyQuizSummary(),
        throwsA(same(error)),
        reason: error.code,
      );
    }
  });

  test(
    'a 403 account_pending_deletion is recognised by the predicate',
    () async {
      when(() => dio.get<Map<String, dynamic>>(path)).thenThrow(
        failure(
          const ApiException(status: 403, code: 'account_pending_deletion'),
        ),
      );

      await expectLater(
        repo.getMyQuizSummary(),
        throwsA(predicate<Object>(isAccountPendingDeletion)),
      );
    },
  );

  test('a DioException that bypassed the interceptor is Unknown', () async {
    when(
      () => dio.get<Map<String, dynamic>>(path),
    ).thenThrow(DioException(requestOptions: RequestOptions(path: path)));

    await expectLater(
      repo.getMyQuizSummary(),
      throwsA(isA<UnknownException>()),
    );
  });

  group('schema drift is wrapped, not leaked', () {
    test('a body without solvedQuestions', () async {
      stub(<String, dynamic>{});

      await expectLater(
        repo.getMyQuizSummary(),
        throwsA(
          isA<UnknownException>().having(
            (e) => e.detail,
            'detail',
            startsWith('parse: '),
          ),
        ),
      );
    });

    test('a wrong-typed solvedQuestions', () async {
      stub({'solvedQuestions': 'twelve'});

      await expectLater(
        repo.getMyQuizSummary(),
        throwsA(isA<UnknownException>()),
      );
    });

    test('a response with no body at all', () async {
      stub(null);

      await expectLater(
        repo.getMyQuizSummary(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  test('the Riverpod provider builds the repository over dioProvider', () {
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    expect(
      container.read(quizSummaryRepositoryProvider),
      isA<QuizSummaryRepository>(),
    );
  });
}
