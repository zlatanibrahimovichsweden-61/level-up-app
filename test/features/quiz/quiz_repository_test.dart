import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/quiz/models/explanation_result.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_setup_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/repository/quiz_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'quiz_fixtures.dart';

class _MockDio extends Mock implements Dio {}

/// The repository's job: build the contract's request bodies, parse the
/// contract's responses, and surface failures as the typed `AppException` the
/// Bloc branches on. Anything Dio-shaped stops here.
void main() {
  late _MockDio dio;
  late QuizRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = QuizRepository(dio);
  });

  Response<T> response<T>(T data, {int status = 200, String path = '/x'}) =>
      Response<T>(
        requestOptions: RequestOptions(path: path),
        statusCode: status,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
        requestOptions: RequestOptions(path: '/x'),
        error: mapped,
      );

  /// The body actually put on the wire by the last `post`.
  Map<String, dynamic> capturedBody() =>
      verify(() => dio.post<Map<String, dynamic>>(any(), data: captureAny(named: 'data')))
          .captured
          .single as Map<String, dynamic>;

  group('createQuiz', () {
    setUp(() {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response(quizJson(), status: 201));
    });

    test('school: sends lessonId and OMITS lectureId/quizType entirely',
        () async {
      await repo.createQuiz(
        scope: const QuizSetupArgs.lesson(
          lessonId: 'lesson-9',
          scopeName: 'Cell Structure',
        ),
        length: QuizLength.thirty,
      );

      final body = capturedBody();
      expect(body['mode'], 'normal');
      expect(body['length'], 30);
      expect(body['lessonId'], 'lesson-9');
      // Absent keys, not null values — the contract lists these as optional
      // properties and an explicit null is a different thing.
      expect(body.containsKey('lectureId'), isFalse);
      expect(body.containsKey('quizType'), isFalse);
    });

    test('university: sends lectureId + quizType and OMITS lessonId', () async {
      await repo.createQuiz(
        scope: const QuizSetupArgs.lecture(
          lectureId: 'lecture-4',
          scopeName: 'Lecture 4',
          quizType: QuizType.finalRevision,
        ),
        length: QuizLength.fifty,
      );

      final body = capturedBody();
      expect(body['lectureId'], 'lecture-4');
      expect(body['quizType'], 'finalRevision');
      expect(body['length'], 50);
      expect(body.containsKey('lessonId'), isFalse);
    });

    test('never sends both ids — the args type makes it unrepresentable',
        () async {
      for (final scope in const [
        QuizSetupArgs.lesson(lessonId: 'l', scopeName: 's'),
        QuizSetupArgs.lecture(
          lectureId: 'x',
          scopeName: 's',
          quizType: QuizType.normal,
        ),
      ]) {
        await repo.createQuiz(scope: scope, length: QuizLength.ten);
      }

      final bodies = verify(
        () => dio.post<Map<String, dynamic>>(any(), data: captureAny(named: 'data')),
      ).captured.cast<Map<String, dynamic>>();

      for (final body in bodies) {
        expect(
          body.containsKey('lessonId') && body.containsKey('lectureId'),
          isFalse,
        );
      }
    });

    test('mode is a parameter, not a hardcoded string', () async {
      await repo.createQuiz(
        scope: const QuizSetupArgs.lesson(lessonId: 'l', scopeName: 's'),
        length: QuizLength.ten,
        mode: QuizMode.favorites,
      );

      expect(capturedBody()['mode'], 'favorites');
    });

    test('parses the 201 into a Quiz', () async {
      final quiz = await repo.createQuiz(
        scope: const QuizSetupArgs.lesson(lessonId: 'l', scopeName: 's'),
        length: QuizLength.ten,
      );

      expect(quiz.id, 'quiz-1');
      expect(quiz.questions, hasLength(3));
    });

    test('403 weekly_question_limit_reached surfaces with its code', () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenThrow(
        failure(
          const ApiException(status: 403, code: 'weekly_question_limit_reached'),
        ),
      );

      expect(
        () => repo.createQuiz(
          scope: const QuizSetupArgs.lesson(lessonId: 'l', scopeName: 's'),
          length: QuizLength.thirty,
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'weekly_question_limit_reached')
              .having((e) => e.status, 'status', 403),
        ),
      );
    });

    test('422 not_enough_questions surfaces with its code', () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenThrow(
        failure(const ApiException(status: 422, code: 'not_enough_questions')),
      );

      expect(
        () => repo.createQuiz(
          scope: const QuizSetupArgs.lesson(lessonId: 'l', scopeName: 's'),
          length: QuizLength.fifty,
        ),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'not_enough_questions'),
        ),
      );
    });

    test('offline surfaces as OfflineException', () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenThrow(failure(const OfflineException()));

      expect(
        () => repo.createQuiz(
          scope: const QuizSetupArgs.lesson(lessonId: 'l', scopeName: 's'),
          length: QuizLength.ten,
        ),
        throwsA(isA<OfflineException>()),
      );
    });
  });

  group('submitAnswer', () {
    test('posts questionId + optionId to the quiz-scoped path', () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response(answerResultJson()));

      final result = await repo.submitAnswer(
        quizId: 'quiz-1',
        questionId: 'q1',
        optionId: 'q1-opt2',
      );

      verify(
        () => dio.post<Map<String, dynamic>>(
          '/quizzes/quiz-1/answers',
          data: <String, dynamic>{'questionId': 'q1', 'optionId': 'q1-opt2'},
        ),
      ).called(1);
      expect(result.correct, isTrue);
      expect(result.correctOptionId, 'q1-opt0');
    });

    test('a retry sends the IDENTICAL body — no client-side suppression',
        () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response(answerResultJson()));

      for (var i = 0; i < 2; i++) {
        await repo.submitAnswer(
          quizId: 'quiz-1',
          questionId: 'q1',
          optionId: 'q1-opt2',
        );
      }

      // Both calls reach the server. Idempotency is the server's guarantee
      // (key = quizId + questionId); the app must not second-guess it, because
      // the failure it has to survive is a DROPPED RESPONSE to a request that
      // was in fact processed.
      verify(
        () => dio.post<Map<String, dynamic>>(
          '/quizzes/quiz-1/answers',
          data: any(named: 'data'),
        ),
      ).called(2);
    });

    test('409 quiz_already_finished surfaces with its code', () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenThrow(
        failure(const ApiException(status: 409, code: 'quiz_already_finished')),
      );

      expect(
        () => repo.submitAnswer(quizId: 'q', questionId: 'q1', optionId: 'o'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'quiz_already_finished'),
        ),
      );
    });
  });

  group('finishQuiz', () {
    test('posts to the finish path and parses the summary', () async {
      when(() => dio.post<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => response(quizSummaryJson()));

      final summary = await repo.finishQuiz('quiz-1');

      verify(() => dio.post<Map<String, dynamic>>('/quizzes/quiz-1/finish'))
          .called(1);
      expect(summary.score, 5);
      expect(summary.answeredCount, 8);
      expect(summary.pointsAwarded, 5);
    });

    test('403 insufficient_scope surfaces with its code', () async {
      when(() => dio.post<Map<String, dynamic>>(any())).thenThrow(
        failure(const ApiException(status: 403, code: 'insufficient_scope')),
      );

      expect(
        () => repo.finishQuiz('quiz-1'),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'insufficient_scope'),
        ),
      );
    });
  });

  group('getExplanation', () {
    test('200 → ExplanationReady with the text', () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => response(
          <String, dynamic>{'status': 'ready', 'text': 'Because mitochondria.'},
        ),
      );

      final result = await repo.getExplanation('q1');

      verify(() => dio.get<Map<String, dynamic>>('/questions/q1/explanation'))
          .called(1);
      expect(result, isA<ExplanationReady>());
      expect((result as ExplanationReady).text, 'Because mitochondria.');
    });

    // The status code is the discriminator — a 202 body has no `text` at all,
    // so reading the body's `status` field would be the fragile way to do this.
    test('202 → ExplanationGenerating, not an error', () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => response(
          <String, dynamic>{'status': 'generating'},
          status: 202,
        ),
      );

      expect(await repo.getExplanation('q1'), isA<ExplanationGenerating>());
    });

    test('a 200 without text is contract drift, not an empty panel', () async {
      when(() => dio.get<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => response(<String, dynamic>{'status': 'ready'}));

      expect(
        () => repo.getExplanation('q1'),
        throwsA(isA<UnknownException>()),
      );
    });

    test('403 insufficient_scope still throws — the caller ordered wrongly',
        () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenThrow(
        failure(const ApiException(status: 403, code: 'insufficient_scope')),
      );

      expect(
        () => repo.getExplanation('q1'),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'insufficient_scope'),
        ),
      );
    });
  });
}
