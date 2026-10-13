import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/quiz/repository/quiz_history_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// `addFavorite`, `removeFavorite` and `listFavorites` (CW16a data layer).
///
/// The rules guarded here are the ones the contract states in PROSE and that a
/// client can silently get wrong:
/// - both writes are `204` with nothing to decode and are idempotent, so a
///   repeat is safe;
/// - the list is a cursor page: the cursor is opaque and `hasMore`, never
///   `items.length`, says whether there is more;
/// - failures reach the caller as the typed `AppException`, and a payload that
///   drifts from the schema never leaks into an error detail.
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

  const questionId = '6b000000-0000-4000-8000-000000000001';
  const favoritePath = '/questions/$questionId/favorite';

  group('addFavorite', () {
    test(
      'PUTs the question-specific path and returns nothing on 204',
      () async {
        when(
          () => dio.put<void>(favoritePath),
        ).thenAnswer((_) async => response<void>(null, status: 204));

        await repo.addFavorite(questionId);

        verify(() => dio.put<void>(favoritePath)).called(1);
        verifyNever(() => dio.delete<void>(any()));
      },
    );

    test('is safe to repeat: a second 204 is also fine', () async {
      when(
        () => dio.put<void>(favoritePath),
      ).thenAnswer((_) async => response<void>(null, status: 204));

      await repo.addFavorite(questionId);
      await repo.addFavorite(questionId);

      verify(() => dio.put<void>(favoritePath)).called(2);
    });

    test('path-encodes the id', () async {
      when(
        () => dio.put<void>('/questions/a%2Fb/favorite'),
      ).thenAnswer((_) async => response<void>(null, status: 204));

      await repo.addFavorite('a/b');

      verify(() => dio.put<void>('/questions/a%2Fb/favorite')).called(1);
    });

    test(
      'surfaces 401, the deletion grace 403 and offline untouched',
      () async {
        for (final error in <AppException>[
          const UnauthorizedException(code: 'authentication_required'),
          const UnauthorizedException(code: 'session_superseded'),
          const ApiException(status: 403, code: 'account_pending_deletion'),
          const OfflineException(),
          const NetworkException(detail: 'timeout'),
        ]) {
          when(() => dio.put<void>(favoritePath)).thenThrow(failure(error));

          await expectLater(
            repo.addFavorite(questionId),
            throwsA(same(error)),
            reason: error.code,
          );
        }
      },
    );

    test('a DioException that bypassed the interceptor is Unknown', () async {
      when(
        () => dio.put<void>(favoritePath),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '/x')));

      await expectLater(
        repo.addFavorite(questionId),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('removeFavorite', () {
    test(
      'DELETEs the question-specific path and returns nothing on 204',
      () async {
        when(
          () => dio.delete<void>(favoritePath),
        ).thenAnswer((_) async => response<void>(null, status: 204));

        await repo.removeFavorite(questionId);

        verify(() => dio.delete<void>(favoritePath)).called(1);
        verifyNever(() => dio.put<void>(any()));
      },
    );

    test('is safe to repeat: removing a non-favourite is also a 204', () async {
      when(
        () => dio.delete<void>(favoritePath),
      ).thenAnswer((_) async => response<void>(null, status: 204));

      await repo.removeFavorite(questionId);
      await repo.removeFavorite(questionId);

      verify(() => dio.delete<void>(favoritePath)).called(2);
    });

    test(
      'surfaces 401, the deletion grace 403 and offline untouched',
      () async {
        for (final error in <AppException>[
          const UnauthorizedException(code: 'authentication_required'),
          const ApiException(status: 403, code: 'account_pending_deletion'),
          const OfflineException(),
          const NetworkException(detail: 'timeout'),
        ]) {
          when(() => dio.delete<void>(favoritePath)).thenThrow(failure(error));

          await expectLater(
            repo.removeFavorite(questionId),
            throwsA(same(error)),
            reason: error.code,
          );
        }
      },
    );

    test('a DioException that bypassed the interceptor is Unknown', () async {
      when(
        () => dio.delete<void>(favoritePath),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '/x')));

      await expectLater(
        repo.removeFavorite(questionId),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('listFavorites', () {
    const listPath = '/me/favorites';

    Map<String, dynamic> rowJson({String id = questionId}) => <String, dynamic>{
      'questionId': id,
      'text': 'Which statement about Physics is correct?',
      'subjectName': 'Physics',
      'favoritedAt': '2026-10-09T08:00:00Z',
    };

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
        'items': [rowJson(id: 'q-2'), rowJson(id: 'q-1')],
        'nextCursor': 'b3BhcXVl',
        'hasMore': true,
      });

      final page = await repo.listFavorites();

      expect(page.items.map((f) => f.questionId), ['q-2', 'q-1']);
      expect(page.items.first.subjectName, 'Physics');
      expect(page.items.first.favoritedAt, DateTime.utc(2026, 10, 9, 8));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'b3BhcXVl');
    });

    test('keeps the order the server sent', () async {
      // The contract states no order for this list, so none may be imposed:
      // ascending favoritedAt here must stay ascending.
      stubPage({
        'items': [
          rowJson(id: 'a')..['favoritedAt'] = '2026-10-01T08:00:00Z',
          rowJson(id: 'b')..['favoritedAt'] = '2026-10-08T08:00:00Z',
        ],
        'hasMore': false,
      });

      final page = await repo.listFavorites();

      expect(page.items.map((f) => f.questionId), ['a', 'b']);
    });

    test('an EMPTY page is a normal response, not an error', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      final page = await repo.listFavorites();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('a SHORT page with hasMore:true is not the end of the list', () async {
      stubPage({
        'items': [rowJson()],
        'nextCursor': 'opaque-keyset-token',
        'hasMore': true,
      });

      final page = await repo.listFavorites(limit: 20);

      expect(page.items.length, lessThan(20));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'opaque-keyset-token');
    });

    test('the first page sends NO cursor and NO limit', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.listFavorites();

      expect(capturedQuery(), isEmpty);
    });

    test('forwards the opaque cursor and limit unchanged', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.listFavorites(cursor: 'b3BhcXVlLWN1cnNvcj09', limit: 100);

      expect(capturedQuery(), {'cursor': 'b3BhcXVlLWN1cnNvcj09', 'limit': 100});
    });

    test(
      'a limit outside 1-100 is refused before it reaches the wire',
      () async {
        await expectLater(
          repo.listFavorites(limit: 0),
          throwsA(isA<AssertionError>()),
        );
        await expectLater(
          repo.listFavorites(limit: 101),
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

    test(
      'a malformed or foreign cursor surfaces as a ValidationException',
      () async {
        const error = ValidationException(
          errors: {
            'cursor': ['bad'],
          },
        );
        when(
          () => dio.get<Map<String, dynamic>>(
            listPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(failure(error));

        await expectLater(
          repo.listFavorites(cursor: 'not-ours'),
          throwsA(
            isA<ValidationException>().having(
              (e) => e.fields,
              'fields',
              contains('cursor'),
            ),
          ),
        );
      },
    );

    test('surfaces the other mapped failures untouched', () async {
      for (final error in <AppException>[
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const UnauthorizedException(code: 'authentication_required'),
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
          repo.listFavorites(),
          throwsA(same(error)),
          reason: error.code,
        );
      }
    });

    group('schema drift is wrapped, not leaked', () {
      Future<UnknownException> parseFailure(Map<String, dynamic> body) async {
        stubPage(body);
        try {
          await repo.listFavorites();
        } on UnknownException catch (e) {
          return e;
        }
        fail('expected the drifted payload to throw UnknownException');
      }

      test('a row missing a required field', () async {
        final e = await parseFailure({
          'items': [rowJson()..remove('favoritedAt')],
          'hasMore': false,
        });

        expect(e.detail, startsWith('parse: '));
      });

      test('a row with a wrong-typed field', () async {
        final e = await parseFailure({
          'items': [rowJson()..['text'] = 42],
          'hasMore': false,
        });

        expect(e.detail, startsWith('parse: '));
      });

      test('an unparseable favoritedAt', () async {
        final e = await parseFailure({
          'items': [rowJson()..['favoritedAt'] = 'not a date'],
          'hasMore': false,
        });

        expect(e.detail, startsWith('parse: '));
      });

      test(
        'the detail carries the runtime type only - no stem, no id',
        () async {
          final e = await parseFailure({
            'items': [
              rowJson(id: 'secret-question-id')
                ..['text'] = 'Secret stem'
                ..remove('favoritedAt'),
            ],
            'hasMore': false,
          });

          expect(e.detail, isNot(contains('Secret')));
          expect(e.detail, isNot(contains('secret')));
          expect(e.toString(), isNot(contains('Secret')));
        },
      );

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
          repo.listFavorites(),
          throwsA(isA<UnknownException>()),
        );
      });
    });
  });
}
