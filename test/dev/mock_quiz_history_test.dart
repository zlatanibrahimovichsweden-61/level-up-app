import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/dev/mock_quiz_history.dart';
import 'package:level_up_app/features/profile/repository/quiz_summary_repository.dart';
import 'package:level_up_app/features/quiz/models/favorite_question.dart';
import 'package:level_up_app/features/quiz/models/quiz_history_item.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_review_page.dart';
import 'package:level_up_app/features/quiz/repository/quiz_history_repository.dart';

/// The six quiz-history operations, served by the standalone on-device mock
/// (`lib/dev/mock_quiz_history.dart`).
///
/// Seif's seed-account table (`docs/BACKEND_HANDOFF.md` BH-H1, Seif-stated and
/// not probed by this repo) lists a single finished quiz each for S1 and U1 and
/// no favourites, so a history or favourites list with more than one page
/// cannot be walked on those accounts; this mock is how a screen gets one.
/// These pin what the contract specifies - finished quizzes only, ordered
/// by START, pages of 20, `limit` validated not clamped, an opaque cursor, one
/// `403` for an unknown or foreign quiz and another for the caller's open one,
/// answers withheld for unanswered questions, idempotent `204`s - and drive it
/// through the REAL [QuizHistoryRepository] and [QuizSummaryRepository], which
/// also proves the requests the app builds are the ones the mock understands.
///
/// Each session here wires the mock into a Dio of its own the way the
/// interceptor does: the mock's reply resolved or rejected, the REAL
/// `ErrorInterceptor` after it, so the rules are tested alone. That
/// `mock_backend.dart` dispatches to it is proven by
/// `mock_backend_quiz_history_test.dart`.
///
/// Every test gets a FRESH [MockQuizHistory], so no favourite leaks from one
/// test to the next.
void main() {
  group('GET /quizzes - paging and order', () {
    test(
      '26 quizzes page 20 / 6 by cursor, and hasMore says when to stop',
      () async {
        final s = _Session();

        final first = await s.history.listQuizHistory();
        expect(first.items, hasLength(20));
        expect(first.hasMore, isTrue);
        expect(first.nextCursor, isNotNull);

        final second = await s.history.listQuizHistory(
          cursor: first.nextCursor,
        );
        expect(second.items, hasLength(6));
        expect(second.hasMore, isFalse);
        expect(second.nextCursor, isNull);

        // One contiguous run, newest started first, nothing repeated or skipped.
        expect([...first.items, ...second.items].map((i) => i.id), [
          for (var n = 1; n <= kMockFinishedQuizCount; n++)
            mockHistoryQuizId(n),
        ]);
      },
    );

    test(
      'ordered by when each was STARTED, with the id as the tie-break',
      () async {
        final s = _Session();

        final all = await s.allHistory();

        // `finishedAt` is the start plus a fixed 25 minutes, so it carries the
        // start order; two quizzes share a start, and only those two tie.
        var ties = 0;
        for (var i = 1; i < all.length; i++) {
          final cmp = all[i - 1].finishedAt.compareTo(all[i].finishedAt);
          expect(cmp, greaterThanOrEqualTo(0), reason: 'row $i');
          if (cmp == 0) {
            ties++;
            // The tie resolves to the larger id first.
            expect(all[i - 1].id.compareTo(all[i].id), greaterThan(0));
          }
        }
        expect(ties, 1);
        final (a, b) = (kMockTieBreakQuizzes.first, kMockTieBreakQuizzes.last);
        expect(all[a - 1].finishedAt, all[b - 1].finishedAt);
        expect(all[a - 1].id, mockHistoryQuizId(a));
        expect(all[b - 1].id, mockHistoryQuizId(b));
      },
    );

    test('only FINISHED quizzes are listed: the open one is absent', () async {
      final s = _Session();

      final ids = (await s.allHistory()).map((i) => i.id);

      expect(ids, isNot(contains(kMockOpenQuizId)));
      expect(ids.toSet(), hasLength(kMockFinishedQuizCount));
    });

    test('timestamps are fixed UTC instants in 2026-09 / 2026-10', () async {
      final s = _Session();

      for (final item in await s.allHistory()) {
        expect(item.finishedAt.isUtc, isTrue);
        expect(item.finishedAt.isAfter(DateTime.utc(2026, 9)), isTrue);
        expect(item.finishedAt.isBefore(DateTime.utc(2026, 11)), isTrue);
      }
    });

    test(
      'all three modes appear, and only a normal quiz names a subject',
      () async {
        final s = _Session();

        final all = await s.allHistory();

        expect(all.map((i) => i.mode).toSet(), QuizMode.values.toSet());
        for (final item in all) {
          if (item.mode == QuizMode.normal &&
              item.id != mockHistoryQuizId(kMockUnresolvedSubjectQuiz)) {
            expect(item.subjectName, isNotEmpty, reason: item.id);
          } else {
            expect(item.subjectName, '', reason: item.id);
            expect(item.hasSubject, isFalse);
          }
        }
      },
    );

    test(
      'a normal quiz whose subject is gone reads as an empty name',
      () async {
        final s = _Session();

        final item = (await s.allHistory()).firstWhere(
          (i) => i.id == mockHistoryQuizId(kMockUnresolvedSubjectQuiz),
        );

        expect(item.mode, QuizMode.normal);
        expect(item.subjectName, '');
      },
    );

    test(
      'scopeName: a label for one pooled mode and empty for the other',
      () async {
        // The contract does not say what `scopeName` holds for a pooled quiz, so
        // the fixtures cover both a label and an empty string.
        final s = _Session();

        final all = await s.allHistory();

        expect(
          all
              .where((i) => i.mode == QuizMode.retakeWrong)
              .map((i) => i.scopeName),
          everyElement(isNotEmpty),
        );
        expect(
          all
              .where((i) => i.mode == QuizMode.favorites)
              .map((i) => i.scopeName),
          everyElement(isEmpty),
        );
      },
    );

    test('limit is honoured', () async {
      final s = _Session();

      final five = await s.history.listQuizHistory(limit: 5);
      expect(five.items, hasLength(5));
      expect(five.hasMore, isTrue);

      final all = await s.history.listQuizHistory(limit: 100);
      expect(all.items, hasLength(kMockFinishedQuizCount));
      expect(all.hasMore, isFalse);
      expect(all.nextCursor, isNull);
    });

    test('a limit outside 1..100 is a 400 on `limit`, never clamped', () async {
      final s = _Session();

      for (final limit in [0, 101, -3]) {
        await s.expectValidation(
          () => s.dio.get<Map<String, dynamic>>(
            '/quizzes',
            queryParameters: {'limit': limit},
          ),
          'limit',
        );
      }
    });

    test('a cursor this mock did not issue is a 400 on `cursor`', () async {
      final s = _Session();

      await s.expectValidation(
        () => s.dio.get<Map<String, dynamic>>(
          '/quizzes',
          queryParameters: {'cursor': 'bm90LWEtY3Vyc29y'},
        ),
        'cursor',
      );
      await s.expectValidation(
        () => s.dio.get<Map<String, dynamic>>(
          '/quizzes',
          queryParameters: {'cursor': '***not base64***'},
        ),
        'cursor',
      );
    });

    test('a FAVOURITES cursor is foreign to the history list', () async {
      final s = _Session();
      final favorites = await s.favorites.listFavorites(limit: 5);

      await s.expectValidation(
        () => s.dio.get<Map<String, dynamic>>(
          '/quizzes',
          queryParameters: {'cursor': favorites.nextCursor},
        ),
        'cursor',
      );
    });

    test('a bad limit AND a bad cursor are reported together', () async {
      final s = _Session();

      try {
        await s.dio.get<Map<String, dynamic>>(
          '/quizzes',
          queryParameters: {'limit': 0, 'cursor': 'x'},
        );
        fail('expected a 400');
      } on DioException catch (e) {
        final v = e.error! as ValidationException;
        expect(v.fields, containsAll(['limit', 'cursor']));
      }
    });

    test('no finished quiz at all is an empty page, not an error', () async {
      final s = _Session(finishedQuizzes: 0);

      final page = await s.history.listQuizHistory();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });
  });

  // -------------------------------------------------------------------------

  group('GET /quizzes/{quizId} - the review', () {
    test('a finished quiz answers the full review', () async {
      final s = _Session();

      final review = await s.history.getQuizReview(mockHistoryQuizId(1));

      expect(review.id, mockHistoryQuizId(1));
      expect(review.questions, isNotEmpty);
      expect(review.finishedAt.isUtc, isTrue);
      expect(review.scopeName, isNotEmpty);
      for (var i = 0; i < review.questions.length; i++) {
        final q = review.questions[i].question;
        expect(q.order, i + 1);
        expect(q.options, hasLength(4));
        expect(q.text, isNotEmpty);
      }
    });

    test(
      'an unanswered question reveals NOTHING; an answered one does',
      () async {
        final s = _Session();

        final all = await s.allReviews();

        final questions = [for (final r in all) ...r.questions];
        expect(questions.where((q) => !q.isAnswered), isNotEmpty);
        for (final q in questions) {
          if (q.isAnswered) {
            expect(q.selectedOptionId, isNotNull);
            expect(q.correctOptionId, isNotNull);
            expect(q.correct, isNotNull);
            // The recorded verdict agrees with the two option ids.
            expect(q.correct, q.selectedOptionId == q.correctOptionId);
            // (Two `contains`, not `containsAll`: a right answer makes the
            // pick and the key the same id.)
            final optionIds = q.question.options.map((o) => o.id).toList();
            expect(optionIds, contains(q.selectedOptionId));
            expect(optionIds, contains(q.correctOptionId));
          } else {
            expect(q.selectedOptionId, isNull);
            expect(q.correctOptionId, isNull);
            expect(q.correct, isNull);
            expect(q.explanationAvailable, isFalse);
          }
        }
      },
    );

    test('right, wrong and unanswered are all reachable', () async {
      final s = _Session();

      final questions = [for (final r in await s.allReviews()) ...r.questions];

      expect(questions.where((q) => q.isCorrect), isNotEmpty);
      expect(questions.where((q) => q.isWrong), isNotEmpty);
      expect(questions.where((q) => !q.isAnswered), isNotEmpty);
      // An unanswered question is never wrong.
      expect(questions.where((q) => !q.isAnswered && q.isWrong), isEmpty);
    });

    test(
      'explanationAvailable: always false unanswered, not always true answered',
      () async {
        final s = _Session();

        final answered = [
          for (final r in await s.allReviews())
            ...r.questions.where((q) => q.isAnswered),
        ];

        expect(answered.where((q) => q.explanationAvailable), isNotEmpty);
        expect(answered.where((q) => !q.explanationAvailable), isNotEmpty);
      },
    );

    test(
      'the totals match the history row, and the recount matches the score',
      () async {
        final s = _Session();
        final history = await s.allHistory();

        for (final item in history) {
          final review = await s.history.getQuizReview(item.id);
          expect(review.score, item.score, reason: item.id);
          expect(review.totalQuestions, item.totalQuestions, reason: item.id);
          expect(review.finishedAt, item.finishedAt, reason: item.id);
          expect(review.scopeName, item.scopeName, reason: item.id);
          expect(item.score, lessThanOrEqualTo(item.totalQuestions));

          if (item.id == mockHistoryQuizId(kMockOmittedQuestionQuiz)) continue;
          expect(
            review.questions.where((q) => q.isCorrect),
            hasLength(review.score),
            reason: item.id,
          );
          expect(review.questions, hasLength(review.totalQuestions));
        }
      },
    );

    test(
      'a question whose content is gone is omitted; the totals stay frozen',
      () async {
        final s = _Session();

        final review = await s.history.getQuizReview(
          mockHistoryQuizId(kMockOmittedQuestionQuiz),
        );

        expect(review.questions, hasLength(review.totalQuestions - 1));
        // The omitted question was a correct one, still counted in the score.
        expect(
          review.questions.where((q) => q.isCorrect),
          hasLength(review.score - 1),
        );
      },
    );

    test('subjectName: null in the review, empty in the history', () async {
      final s = _Session();
      final history = {for (final i in await s.allHistory()) i.id: i};

      for (final entry in history.entries) {
        final review = await s.history.getQuizReview(entry.key);
        if (entry.value.subjectName.isEmpty) {
          expect(review.subjectName, isNull, reason: entry.key);
        } else {
          expect(review.subjectName, entry.value.subjectName);
        }
      }
    });

    test(
      'an unknown, malformed or foreign id is ONE 403 insufficient_scope',
      () async {
        final s = _Session();

        for (final id in [
          '6a000000-0000-4000-8000-00000000abcd', // a well-formed id nobody owns
          'not-a-uuid',
        ]) {
          await s.expectApi(
            () => s.history.getQuizReview(id),
            403,
            'insufficient_scope',
          );
        }
      },
    );

    test(
      'the open quiz is 403 quiz_not_finished, after the ownership check',
      () async {
        final s = _Session();

        await s.expectApi(
          () => s.history.getQuizReview(kMockOpenQuizId),
          403,
          'quiz_not_finished',
        );
      },
    );

    test('there is no 404 for a quiz id', () async {
      final s = _Session();

      try {
        await s.history.getQuizReview('nope');
        fail('expected a 403');
      } on ApiException catch (e) {
        expect(e.status, isNot(404));
      }
    });

    test('a review reflects favourites live', () async {
      final s = _Session();
      // A quiz that serves bank question 1 (favourited by default).
      final review = (await s.allReviews()).firstWhere(
        (r) =>
            r.questions.any((q) => q.question.id == mockHistoryQuestionId(1)),
      );
      bool favorite(QuizReview r) => r.questions
          .firstWhere((q) => q.question.id == mockHistoryQuestionId(1))
          .question
          .isFavorite;
      expect(favorite(review), isTrue);

      await s.favorites.removeFavorite(mockHistoryQuestionId(1));

      expect(favorite(await s.history.getQuizReview(review.id)), isFalse);

      await s.favorites.addFavorite(mockHistoryQuestionId(1));

      expect(favorite(await s.history.getQuizReview(review.id)), isTrue);
    });
  });

  // -------------------------------------------------------------------------

  group('favourites - GET /me/favorites, PUT and DELETE', () {
    test(
      '22 favourites page 20 / 2 by cursor, most recently favourited first',
      () async {
        final s = _Session();

        final first = await s.favorites.listFavorites();
        expect(first.items, hasLength(20));
        expect(first.hasMore, isTrue);
        final second = await s.favorites.listFavorites(
          cursor: first.nextCursor,
        );
        expect(second.items, hasLength(2));
        expect(second.hasMore, isFalse);
        expect(second.nextCursor, isNull);

        final all = [...first.items, ...second.items];
        expect(all.map((f) => f.questionId), [
          for (var n = 1; n <= kMockFavoriteCount; n++)
            mockHistoryQuestionId(n),
        ]);
        for (var i = 1; i < all.length; i++) {
          expect(all[i].favoritedAt.isBefore(all[i - 1].favoritedAt), isTrue);
        }
      },
    );

    test('a row carries a stem and a subject, and never an answer', () async {
      final s = _Session();

      final all = await s.allFavorites();

      for (final f in all) {
        expect(f.text, isNotEmpty);
        expect(f.subjectName, isNotEmpty);
        expect(f.favoritedAt.isUtc, isTrue);
      }
      // The one markup the contract allows in a stem is exercised.
      expect(all.any((f) => f.text.contains('<u>')), isTrue);
    });

    test('PUT adds a question to the top of the list', () async {
      final s = _Session();
      final before = (await s.allFavorites()).first.favoritedAt;

      await s.favorites.addFavorite(mockHistoryQuestionId(23));

      final all = await s.allFavorites();
      expect(all, hasLength(kMockFavoriteCount + 1));
      expect(all.first.questionId, mockHistoryQuestionId(23));
      expect(all.first.favoritedAt.isAfter(before), isTrue);
    });

    test(
      'PUT is idempotent: a repeat keeps the original favoritedAt',
      () async {
        final s = _Session();
        await s.favorites.addFavorite(mockHistoryQuestionId(23));
        final once = (await s.allFavorites()).first.favoritedAt;

        await s.favorites.addFavorite(mockHistoryQuestionId(23));
        // And an already-favourite fixture question.
        final fixtureBefore = (await s.allFavorites())
            .firstWhere((f) => f.questionId == mockHistoryQuestionId(5))
            .favoritedAt;
        await s.favorites.addFavorite(mockHistoryQuestionId(5));

        final all = await s.allFavorites();
        expect(all, hasLength(kMockFavoriteCount + 1));
        expect(all.first.favoritedAt, once);
        expect(
          all
              .firstWhere((f) => f.questionId == mockHistoryQuestionId(5))
              .favoritedAt,
          fixtureBefore,
        );
      },
    );

    test(
      'DELETE removes a question; a repeat and a non-favourite are fine',
      () async {
        final s = _Session();

        await s.favorites.removeFavorite(mockHistoryQuestionId(3));
        await s.favorites.removeFavorite(mockHistoryQuestionId(3));
        await s.favorites.removeFavorite(
          mockHistoryQuestionId(24),
        ); // never one

        final ids = (await s.allFavorites()).map((f) => f.questionId);
        expect(ids, hasLength(kMockFavoriteCount - 1));
        expect(ids, isNot(contains(mockHistoryQuestionId(3))));
      },
    );

    test('the writes answer a real 204 with no body', () async {
      final s = _Session();

      final put = await s.dio.put<Object?>(
        '/questions/${mockHistoryQuestionId(23)}/favorite',
      );
      final delete = await s.dio.delete<Object?>(
        '/questions/${mockHistoryQuestionId(23)}/favorite',
      );

      expect(put.statusCode, 204);
      expect(put.data, isNull);
      expect(delete.statusCode, 204);
    });

    test('an id outside the bank is a 204 and leaves no row', () async {
      // The contract documents no other answer for these two operations.
      final s = _Session();

      await s.favorites.addFavorite('not-a-question');
      await s.favorites.addFavorite('6b000000-0000-4000-8000-0000000000aa');

      expect(await s.allFavorites(), hasLength(kMockFavoriteCount));
    });

    test(
      'the cursor is a keyset: an unfavourite between pages repeats nothing',
      () async {
        final s = _Session();
        final first = await s.favorites.listFavorites();

        // Remove a row that was already served, then follow the cursor.
        await s.favorites.removeFavorite(mockHistoryQuestionId(5));
        final second = await s.favorites.listFavorites(
          cursor: first.nextCursor,
        );

        expect(second.items.map((f) => f.questionId), [
          mockHistoryQuestionId(21),
          mockHistoryQuestionId(22),
        ]);
      },
    );

    test('limit is honoured; outside 1..100 is a 400 on `limit`', () async {
      final s = _Session();

      expect((await s.favorites.listFavorites(limit: 3)).items, hasLength(3));
      for (final limit in [0, 101]) {
        await s.expectValidation(
          () => s.dio.get<Map<String, dynamic>>(
            '/me/favorites',
            queryParameters: {'limit': limit},
          ),
          'limit',
        );
      }
    });

    test(
      'a cursor this mock did not issue, or another list\'s, is a 400',
      () async {
        final s = _Session();
        final history = await s.history.listQuizHistory(limit: 5);

        for (final cursor in ['bm90LWEtY3Vyc29y', history.nextCursor]) {
          await s.expectValidation(
            () => s.dio.get<Map<String, dynamic>>(
              '/me/favorites',
              queryParameters: {'cursor': cursor},
            ),
            'cursor',
          );
        }
      },
    );

    test('no favourite at all is an empty page, not an error', () async {
      final s = _Session(favoriteCount: 0);

      final page = await s.favorites.listFavorites();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });
  });

  // -------------------------------------------------------------------------

  group('GET /me/quiz-summary', () {
    int number(String questionId) =>
        int.parse(questionId.substring(questionId.length - 12), radix: 16);

    test(
      'counts DISTINCT questions answered correctly, finished or not',
      () async {
        final s = _Session();

        final solved = (await s.summary.getMyQuizSummary()).solvedQuestions;

        // What the finished reviews show...
        final visible = <int>{};
        var correctAnswers = 0;
        for (final r in await s.allReviews()) {
          for (final q in r.questions.where((q) => q.isCorrect)) {
            visible.add(number(q.question.id));
            correctAnswers++;
          }
        }
        // ...plus what they no longer show (the omitted question is bank
        // question 24, answered correctly) and the open quiz's two correct
        // answers (questions 1 and 4).
        final expected = {...visible, 24, 1, 4};
        expect(solved, expected.length);
        // Distinct: the same question answered correctly in many quizzes counts
        // once.
        expect(solved, lessThan(correctAnswers));
        expect(solved, lessThanOrEqualTo(kMockQuestionCount));
      },
    );

    test('with no finished quiz it still counts the open quiz', () async {
      final s = _Session(finishedQuizzes: 0);

      expect((await s.summary.getMyQuizSummary()).solvedQuestions, 2);
    });

    test('is not a count of favourites or of history rows', () async {
      final a = _Session();
      final b = _Session(favoriteCount: 0);

      expect(
        (await a.summary.getMyQuizSummary()).solvedQuestions,
        (await b.summary.getMyQuizSummary()).solvedQuestions,
      );
    });

    test('is a non-negative integer, as the contract bounds it', () async {
      final s = _Session();

      final res = await s.dio.get<Map<String, dynamic>>('/me/quiz-summary');

      expect(res.data!.keys, ['solvedQuestions']);
      expect(res.data!['solvedQuestions'], isA<int>());
      expect(res.data!['solvedQuestions'] as int, greaterThanOrEqualTo(0));
    });
  });

  // -------------------------------------------------------------------------

  group('routing', () {
    test('serves exactly its six operations and nothing else', () {
      final mock = MockQuizHistory();

      expect(mock.handle('GET', '/quizzes', {}), isNotNull);
      expect(
        mock.handle('GET', '/quizzes/${mockHistoryQuizId(1)}', {}),
        isNotNull,
      );
      expect(
        mock.handle(
          'PUT',
          '/questions/${mockHistoryQuestionId(1)}/favorite',
          {},
        ),
        isNotNull,
      );
      expect(
        mock.handle(
          'DELETE',
          '/questions/${mockHistoryQuestionId(1)}/favorite',
          {},
        ),
        isNotNull,
      );
      expect(mock.handle('GET', '/me/favorites', {}), isNotNull);
      expect(mock.handle('GET', '/me/quiz-summary', {}), isNotNull);
    });

    test('leaves the quiz-engine routes to the interceptor', () {
      final mock = MockQuizHistory();
      final id = mockHistoryQuizId(1);
      final q = mockHistoryQuestionId(1);

      expect(mock.handle('POST', '/quizzes', {}), isNull);
      expect(mock.handle('POST', '/quizzes/$id/answers', {}), isNull);
      expect(mock.handle('POST', '/quizzes/$id/finish', {}), isNull);
      expect(mock.handle('GET', '/questions/$q/explanation', {}), isNull);
      expect(mock.handle('POST', '/questions/$q/favorite', {}), isNull);
      expect(mock.handle('GET', '/quizzes/$id/answers', {}), isNull);
      expect(mock.handle('GET', '/me', {}), isNull);
      expect(mock.handle('PUT', '/me/favorites', {}), isNull);
    });

    test('two sessions start from the same fixtures', () async {
      final a = await _Session().allHistory();
      final b = await _Session().allHistory();

      expect(a, b);
    });
  });
}

/// One mock session: a [MockQuizHistory] behind the same wiring the interceptor
/// uses (reply resolved or rejected, then the REAL `ErrorInterceptor`), driven
/// by the REAL repositories.
class _Session {
  _Session({
    int finishedQuizzes = kMockFinishedQuizCount,
    int favoriteCount = kMockFavoriteCount,
  }) {
    final mock = MockQuizHistory(
      finishedQuizzes: finishedQuizzes,
      favorites: favoriteCount,
    );
    dio = Dio(BaseOptions(baseUrl: 'http://mock.local/api/v1'))
      ..interceptors.addAll([_Route(mock), ErrorInterceptor()]);
    history = QuizHistoryRepository(dio);
    summary = QuizSummaryRepository(dio);
  }

  late final Dio dio;
  late final QuizHistoryRepository history;
  late final QuizSummaryRepository summary;

  /// The favourites operations live on the same repository as the history.
  QuizHistoryRepository get favorites => history;

  Future<List<QuizHistoryItem>> allHistory() async {
    final out = <QuizHistoryItem>[];
    String? cursor;
    do {
      final page = await history.listQuizHistory(cursor: cursor, limit: 7);
      out.addAll(page.items);
      cursor = page.hasMore ? page.nextCursor : null;
    } while (cursor != null);
    return out;
  }

  Future<List<FavoriteQuestion>> allFavorites() async {
    final out = <FavoriteQuestion>[];
    String? cursor;
    do {
      final page = await favorites.listFavorites(cursor: cursor, limit: 7);
      out.addAll(page.items);
      cursor = page.hasMore ? page.nextCursor : null;
    } while (cursor != null);
    return out;
  }

  Future<List<QuizReview>> allReviews() async => [
    for (final item in await allHistory()) await history.getQuizReview(item.id),
  ];

  /// The call fails as the typed [ApiException] with [status] and [code].
  Future<void> expectApi(
    Future<Object?> Function() call,
    int status,
    String code,
  ) async {
    try {
      await call();
    } on ApiException catch (e) {
      expect(e.status, status);
      expect(e.code, code);
      return;
    }
    fail('expected $status $code');
  }

  /// A raw Dio call (the repository's own assert would refuse a bad `limit`
  /// before it left the app) fails as `400 validation_failed` on [field].
  Future<void> expectValidation(
    Future<Object?> Function() call,
    String field,
  ) async {
    try {
      await call();
    } on DioException catch (e) {
      final error = e.error;
      expect(error, isA<ValidationException>());
      expect((error! as ValidationException).fields, contains(field));
      return;
    }
    fail('expected a 400 on `$field`');
  }
}

/// What `MockBackendInterceptor` does with a `handle` reply: success resolved,
/// failure rejected THROUGH the following `ErrorInterceptor`, and a route the
/// mock does not serve the interceptor's generic 404.
class _Route extends Interceptor {
  _Route(this._mock);

  final MockQuizHistory _mock;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final reply = _mock.handle(
      options.method.toUpperCase(),
      options.path,
      options.queryParameters,
    );
    switch (reply) {
      case MockQuizHistoryOk(:final status, :final data):
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: status,
            data: data,
          ),
        );
      case MockQuizHistoryValidation(:final errors):
        _reject(handler, options, 400, <String, dynamic>{
          'title': 'Validation failed',
          'status': 400,
          'code': 'validation_failed',
          'errors': errors,
        });
      case MockQuizHistoryProblem(:final status, :final code, :final detail):
        _reject(handler, options, status, <String, dynamic>{
          'title': detail,
          'status': status,
          'code': code,
          'detail': detail,
        });
      case null:
        _reject(handler, options, 404, <String, dynamic>{
          'title': 'Not served',
          'status': 404,
          'code': 'not_found',
        });
    }
  }

  void _reject(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    Map<String, dynamic> body,
  ) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: status,
          data: body,
        ),
      ),
      true,
    );
  }
}
