import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/repository/quiz_history_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// `listQuizHistory` and `getQuizReview` (CW16a data layer).
///
/// The rules guarded here are the ones the contract states in PROSE and that a
/// client can silently get wrong:
/// - the cursor is opaque - followed, never built, and absent (not null) on the
///   first page;
/// - a short page with `hasMore: true` is not the end of the list;
/// - the review's two `403`s carry different codes and both reach the caller
///   untouched, so it can branch on `code`;
/// - a payload that drifts from the schema becomes a typed `UnknownException`
///   whose detail never carries the payload.
void main() {
  late _MockDio dio;
  late QuizHistoryRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = QuizHistoryRepository(dio);
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

  Map<String, dynamic> itemJson({
    String id = 'quiz-1',
    String subjectName = 'Physics',
    String mode = 'normal',
  }) => <String, dynamic>{
    'id': id,
    'subjectName': subjectName,
    'scopeName': 'Lesson 2',
    'mode': mode,
    'score': 3,
    'totalQuestions': 5,
    'finishedAt': '2026-10-09T10:25:00Z',
  };

  group('listQuizHistory', () {
    const listPath = '/quizzes';

    void stubPage(Map<String, dynamic> body) {
      when(
        () => dio.get<Map<String, dynamic>>(
          listPath,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => response(body));
    }

    Map<String, dynamic> capturedQuery() =>
        verify(
              () => dio.get<Map<String, dynamic>>(
                listPath,
                queryParameters: captureAny(named: 'queryParameters'),
              ),
            ).captured.single
            as Map<String, dynamic>;

    test('decodes a page: the rows and the envelope', () async {
      stubPage({
        'items': [
          itemJson(id: 'quiz-2'),
          itemJson(id: 'quiz-1', subjectName: '', mode: 'favorites'),
        ],
        'nextCursor': 'b3BhcXVl',
        'hasMore': true,
      });

      final page = await repo.listQuizHistory();

      expect(page.items.map((i) => i.id), ['quiz-2', 'quiz-1']);
      expect(page.items.last.mode, QuizMode.favorites);
      expect(page.items.last.hasSubject, isFalse);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'b3BhcXVl');
    });

    test('keeps the order the server sent', () async {
      // The item exposes `finishedAt`, not the start time the list is ordered
      // by, so the rows cannot be re-sorted client-side: here the older finish
      // comes first and must stay first.
      stubPage({
        'items': [
          itemJson(id: 'a')..['finishedAt'] = '2026-10-01T10:00:00Z',
          itemJson(id: 'b')..['finishedAt'] = '2026-10-08T10:00:00Z',
        ],
        'hasMore': false,
      });

      final page = await repo.listQuizHistory();

      expect(page.items.map((i) => i.id), ['a', 'b']);
    });

    test('an EMPTY page is a normal response, not an error', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      final page = await repo.listQuizHistory();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('a SHORT page with hasMore:true is not the end of the list', () async {
      stubPage({
        'items': [itemJson()],
        'nextCursor': 'opaque-keyset-token',
        'hasMore': true,
      });

      final page = await repo.listQuizHistory(limit: 20);

      expect(page.items.length, lessThan(20));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'opaque-keyset-token');
    });

    test('the first page sends NO cursor and NO limit', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.listQuizHistory();

      // Absent, not null: `cursor: null` would be a malformed cursor (400).
      expect(capturedQuery(), isEmpty);
    });

    test('forwards the opaque cursor and limit unchanged', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.listQuizHistory(cursor: 'b3BhcXVlLWN1cnNvcj09', limit: 50);

      expect(capturedQuery(), {'cursor': 'b3BhcXVlLWN1cnNvcj09', 'limit': 50});
    });

    test('follows a cursor across pages without touching it', () async {
      var call = 0;
      when(
        () => dio.get<Map<String, dynamic>>(
          listPath,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        call++;
        return response(
          call == 1
              ? {
                  'items': [itemJson(id: 'quiz-2')],
                  'nextCursor': 'cursor-2',
                  'hasMore': true,
                }
              : {
                  'items': [itemJson(id: 'quiz-1')],
                  'nextCursor': null,
                  'hasMore': false,
                },
        );
      });

      final first = await repo.listQuizHistory();
      final second = await repo.listQuizHistory(cursor: first.nextCursor);

      expect(second.items.single.id, 'quiz-1');
      expect(second.hasMore, isFalse);
      final captured = verify(
        () => dio.get<Map<String, dynamic>>(
          listPath,
          queryParameters: captureAny(named: 'queryParameters'),
        ),
      ).captured;
      expect(captured.last, {'cursor': 'cursor-2'});
    });

    test(
      'a limit outside 1-100 is refused before it reaches the wire',
      () async {
        // The server VALIDATES, never clamps; the debug assert catches the
        // mistake at the call site rather than as a 400 on a device.
        await expectLater(
          repo.listQuizHistory(limit: 0),
          throwsA(isA<AssertionError>()),
        );
        await expectLater(
          repo.listQuizHistory(limit: 101),
          throwsA(isA<AssertionError>()),
        );
        verifyNever(
          () => dio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        );
      },
    );

    test('surfaces the mapped failures untouched', () async {
      for (final error in <AppException>[
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const UnauthorizedException(code: 'authentication_required'),
        const ValidationException(
          errors: {
            'cursor': ['bad'],
          },
        ),
        const OfflineException(),
        const NetworkException(detail: 'timeout'),
        const ApiException(status: 500, code: 'internal_error'),
      ]) {
        when(
          () => dio.get<Map<String, dynamic>>(
            listPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(failure(error));

        await expectLater(
          repo.listQuizHistory(),
          throwsA(same(error)),
          reason: error.code,
        );
      }
    });

    test('a DioException that bypassed the interceptor is Unknown', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          listPath,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '/x')));

      await expectLater(
        repo.listQuizHistory(),
        throwsA(isA<UnknownException>()),
      );
    });

    group('schema drift is wrapped, not leaked', () {
      Future<UnknownException> parseFailure(Map<String, dynamic> body) async {
        stubPage(body);
        try {
          await repo.listQuizHistory();
        } on UnknownException catch (e) {
          return e;
        }
        fail('expected the drifted payload to throw UnknownException');
      }

      test('an item missing a required field', () async {
        final e = await parseFailure({
          'items': [itemJson(subjectName: 'a-subject-name')..remove('score')],
          'hasMore': false,
        });

        expect(e.detail, startsWith('parse: '));
        expect(e.detail, isNot(contains('a-subject-name')));
      });

      test('an item with a mode the contract does not define', () async {
        final e = await parseFailure({
          'items': [itemJson(mode: 'speedrun')],
          'hasMore': false,
        });

        expect(e.detail, startsWith('parse: '));
      });

      test('an envelope without hasMore', () async {
        final e = await parseFailure({'items': <dynamic>[]});

        expect(e.detail, startsWith('parse: '));
      });

      test('a response with no body at all', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            listPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: listPath),
            statusCode: 200,
          ),
        );

        await expectLater(
          repo.listQuizHistory(),
          throwsA(isA<UnknownException>()),
        );
      });
    });
  });

  // -------------------------------------------------------------------------

  Map<String, dynamic> reviewJson({String? subjectName = 'Physics'}) =>
      <String, dynamic>{
        'id': 'quiz-1',
        'subjectName': subjectName,
        'scopeName': 'Lesson 2',
        'score': 1,
        'totalQuestions': 2,
        'finishedAt': '2026-10-09T10:25:00Z',
        'questions': [
          <String, dynamic>{
            'id': 'q1',
            'order': 1,
            'text': 'Question q1?',
            'imageUrl': null,
            'thumbnailUrl': null,
            'options': [
              <String, dynamic>{'id': 'q1-a', 'text': 'A'},
              <String, dynamic>{'id': 'q1-b', 'text': 'B'},
            ],
            'isFavorite': true,
            'selectedOptionId': 'q1-a',
            'correctOptionId': 'q1-a',
            'correct': true,
            'explanationAvailable': true,
          },
          <String, dynamic>{
            'id': 'q2',
            'order': 2,
            'text': 'Question q2?',
            'imageUrl': null,
            'thumbnailUrl': null,
            'options': [
              <String, dynamic>{'id': 'q2-a', 'text': 'A'},
              <String, dynamic>{'id': 'q2-b', 'text': 'B'},
            ],
            'isFavorite': false,
            'selectedOptionId': null,
            'correctOptionId': null,
            'correct': null,
            'explanationAvailable': false,
          },
        ],
      };

  group('getQuizReview', () {
    void stubReview(Map<String, dynamic>? body, {String id = 'quiz-1'}) {
      when(() => dio.get<Map<String, dynamic>>('/quizzes/$id')).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/quizzes/$id'),
          statusCode: 200,
          data: body,
        ),
      );
    }

    test('gets the quiz-scoped path and decodes the review', () async {
      stubReview(reviewJson());

      final review = await repo.getQuizReview('quiz-1');

      verify(() => dio.get<Map<String, dynamic>>('/quizzes/quiz-1')).called(1);
      expect(review.id, 'quiz-1');
      expect(review.subjectName, 'Physics');
      expect(review.questions, hasLength(2));
      expect(review.questions.first.correct, isTrue);
      expect(review.questions.last.isAnswered, isFalse);
    });

    test('an unanswered question comes back without its answer', () async {
      stubReview(reviewJson());

      final review = await repo.getQuizReview('quiz-1');

      expect(review.questions.last.correctOptionId, isNull);
      expect(review.questions.last.explanationAvailable, isFalse);
    });

    test('the recorded verdict survives even when it disagrees with the option '
        'ids', () async {
      // `correct` is the verdict at submit time, `correctOptionId` the CURRENT
      // key: an edited question makes them differ. The repository hands both
      // over exactly as sent and never reconciles them.
      final body = reviewJson();
      final questions = (body['questions'] as List)
          .cast<Map<String, dynamic>>();
      // q1: pick == current key, but the recorded verdict is "wrong".
      questions[0]['correct'] = false;
      // q2: answered with a pick that is NOT the current key, recorded "right".
      questions[1]
        ..['selectedOptionId'] = 'q2-a'
        ..['correctOptionId'] = 'q2-b'
        ..['correct'] = true;
      stubReview(body);

      final review = await repo.getQuizReview('quiz-1');

      final first = review.questions.first;
      expect(first.selectedOptionId, first.correctOptionId);
      expect(first.correct, isFalse);
      expect(first.isWrong, isTrue);
      final second = review.questions.last;
      expect(second.selectedOptionId, isNot(second.correctOptionId));
      expect(second.correct, isTrue);
      expect(second.isCorrect, isTrue);
      expect(second.isWrong, isFalse);
    });

    test('a null subjectName survives', () async {
      stubReview(reviewJson(subjectName: null));

      expect((await repo.getQuizReview('quiz-1')).subjectName, isNull);
    });

    test('path-encodes the id', () async {
      stubReview(reviewJson(), id: 'a%2Fb');

      await repo.getQuizReview('a/b');

      verify(() => dio.get<Map<String, dynamic>>('/quizzes/a%2Fb')).called(1);
    });

    test(
      '403 insufficient_scope and 403 quiz_not_finished stay distinct',
      () async {
        // Unknown, malformed and foreign ids are ONE refusal (adr-178 D2); the
        // caller's own open quiz is another. Both are 403 - only `code` tells
        // them apart, so the repository must not collapse them.
        for (final code in ['insufficient_scope', 'quiz_not_finished']) {
          final error = ApiException(status: 403, code: code);
          when(
            () => dio.get<Map<String, dynamic>>('/quizzes/quiz-1'),
          ).thenThrow(failure(error));

          await expectLater(
            repo.getQuizReview('quiz-1'),
            throwsA(
              isA<ApiException>()
                  .having((e) => e.status, 'status', 403)
                  .having((e) => e.code, 'code', code),
            ),
            reason: code,
          );
        }
      },
    );

    test('surfaces the other mapped failures untouched', () async {
      for (final error in <AppException>[
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const UnauthorizedException(code: 'session_superseded'),
        const OfflineException(),
        const NetworkException(detail: 'timeout'),
      ]) {
        when(
          () => dio.get<Map<String, dynamic>>('/quizzes/quiz-1'),
        ).thenThrow(failure(error));

        await expectLater(
          repo.getQuizReview('quiz-1'),
          throwsA(same(error)),
          reason: error.code,
        );
      }
    });

    test(
      'a review that drifts from the schema is wrapped, not leaked',
      () async {
        stubReview(
          reviewJson()
            ..['questions'] = [
              <String, dynamic>{'id': 'a-question-stem-that-must-not-leak'},
            ],
        );

        try {
          await repo.getQuizReview('quiz-1');
          fail('expected UnknownException');
        } on UnknownException catch (e) {
          expect(e.detail, startsWith('parse: '));
          expect(e.detail, isNot(contains('must-not-leak')));
        }
      },
    );

    test('a question that drops the correctOptionId key is drift, wrapped '
        'without its content', () async {
      final body = reviewJson();
      ((body['questions'] as List).first as Map<String, dynamic>).remove(
        'correctOptionId',
      );
      stubReview(body);

      try {
        await repo.getQuizReview('quiz-1');
        fail('expected UnknownException');
      } on UnknownException catch (e) {
        expect(e.detail, 'parse: FormatException');
        expect(e.detail, isNot(contains('q1')));
      }
    });

    test('a response with no body at all is Unknown', () async {
      stubReview(null);

      await expectLater(
        repo.getQuizReview('quiz-1'),
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
      container.read(quizHistoryRepositoryProvider),
      isA<QuizHistoryRepository>(),
    );
  });
}
