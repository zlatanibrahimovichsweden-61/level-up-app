import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/notifications/models/notification_models.dart';
import 'package:level_up_app/features/notifications/repository/notifications_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_fixtures.dart';

class _MockDio extends Mock implements Dio {}

/// The Notifications data layer.
///
/// The rules guarded here are the ones the contract states in PROSE and that a
/// client can silently get wrong:
/// - All sends NO `category` (there is no `all` value);
/// - the cursor is opaque - followed, never built;
/// - a short or empty page with `hasMore: true` is not the end of the inbox;
/// - ignored kinds are NOT dropped at this layer;
/// - marking read is a `204` with nothing to decode, and a `404` is typed.
void main() {
  late _MockDio dio;
  late NotificationsRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = NotificationsRepository(dio);
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

  const listPath = '/me/notifications';

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

  group('listMyNotifications', () {
    test('decodes a page: unread, read and the envelope', () async {
      stubPage({
        'items': [
          wireItem(notificationId: 'n-1'),
          wireItem(
            notificationId: 'n-2',
            kind: 'moderation_warning',
            category: 'system',
            data: const <String, dynamic>{},
            readAt: '2026-10-09T13:00:00Z',
          ),
        ],
        'nextCursor': 'b3BhcXVl',
        'hasMore': true,
      });

      final page = await repo.listMyNotifications();

      expect(page.items.map((i) => i.notificationId), ['n-1', 'n-2']);
      expect(page.items.first.readAt, isNull);
      expect(page.items.last.readAt, DateTime.utc(2026, 10, 9, 13));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'b3BhcXVl');
    });

    test(
      'ignored kinds and unknown categories are returned untouched',
      () async {
        // Filtering them is the notifier's decision, made where paging is. A
        // repository that dropped them would hide that the page was not empty.
        stubPage({
          'items': [
            wireItem(
              notificationId: 'n-1',
              kind: 'enrolment_opened',
              category: 'system',
              data: const <String, dynamic>{},
            ),
            wireItem(notificationId: 'n-2', kind: 'brand_new_kind'),
            wireItem(notificationId: 'n-3', category: 'promotions'),
          ],
          'hasMore': false,
        });

        final page = await repo.listMyNotifications();

        expect(page.items, hasLength(3));
        expect(page.items.map((i) => i.kind), [
          'enrolment_opened',
          'brand_new_kind',
          'announcement',
        ]);
      },
    );

    test('an EMPTY page is a normal response, not an error', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      final page = await repo.listMyNotifications();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test(
      'a SHORT page with hasMore:true is not the end of the inbox',
      () async {
        // `items.length` says nothing about whether there is more (`hasMore`
        // does), so a one-row page keeps its cursor and its `hasMore`.
        stubPage({
          'items': [wireItem()],
          'nextCursor': 'opaque-keyset-token',
          'hasMore': true,
        });

        final page = await repo.listMyNotifications(limit: 20);

        expect(page.items.length, lessThan(20));
        expect(page.hasMore, isTrue);
        expect(page.nextCursor, 'opaque-keyset-token');
      },
    );

    test('All sends NO category, no cursor, no limit', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.listMyNotifications();

      // Absent, not null: `cursor: null` would be a malformed cursor (400) and
      // there is no `all` category to send.
      expect(capturedQuery(), isEmpty);
    });

    for (final category in NotificationCategory.values) {
      test('${category.wire} sends exactly that category', () async {
        stubPage({'items': <dynamic>[], 'hasMore': false});

        await repo.listMyNotifications(category: category);

        expect(capturedQuery(), {'category': category.wire});
      });
    }

    test('forwards the opaque cursor and limit unchanged', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.listMyNotifications(
        cursor: 'b3BhcXVlLWN1cnNvcj09',
        limit: 50,
        category: NotificationCategory.announcements,
      );

      expect(capturedQuery(), {
        'cursor': 'b3BhcXVlLWN1cnNvcj09',
        'limit': 50,
        'category': 'announcements',
      });
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
                  'items': [wireItem(notificationId: 'n-1')],
                  'nextCursor': 'cursor-2',
                  'hasMore': true,
                }
              : {
                  'items': [wireItem(notificationId: 'n-2')],
                  'nextCursor': null,
                  'hasMore': false,
                },
        );
      });

      final first = await repo.listMyNotifications();
      final second = await repo.listMyNotifications(cursor: first.nextCursor);

      expect(second.items.single.notificationId, 'n-2');
      expect(second.hasMore, isFalse);
      final captured = verify(
        () => dio.get<Map<String, dynamic>>(
          listPath,
          queryParameters: captureAny(named: 'queryParameters'),
        ),
      ).captured;
      expect(captured.last, {'cursor': 'cursor-2'});
    });

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
          repo.listMyNotifications(),
          throwsA(same(error)),
          reason: error.code,
        );
      }
    });

    test(
      'a 403 account_pending_deletion is recognised by the predicate',
      () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            listPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          failure(
            const ApiException(status: 403, code: 'account_pending_deletion'),
          ),
        );

        await expectLater(
          repo.listMyNotifications(),
          throwsA(predicate<Object>(isAccountPendingDeletion)),
        );
      },
    );

    test('a DioException that bypassed the interceptor is Unknown', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          listPath,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '/x')));

      await expectLater(
        repo.listMyNotifications(),
        throwsA(isA<UnknownException>()),
      );
    });

    group('schema drift is wrapped, not leaked', () {
      Future<UnknownException> parseFailure(Map<String, dynamic> body) async {
        stubPage(body);
        try {
          await repo.listMyNotifications();
        } on UnknownException catch (e) {
          return e;
        }
        fail('expected the drifted payload to throw UnknownException');
      }

      test('an item missing a required field', () async {
        final e = await parseFailure({
          'items': [wireItem(notificationId: 'secret-id')..remove('kind')],
          'hasMore': false,
        });

        expect(e.detail, startsWith('parse: '));
      });

      test('an item with a wrong-typed field', () async {
        final e = await parseFailure({
          'items': [wireItem()..['data'] = 'not an object'],
          'hasMore': false,
        });

        expect(e.detail, startsWith('parse: '));
      });

      test('an envelope without hasMore', () async {
        final e = await parseFailure({'items': <dynamic>[]});

        expect(e.detail, startsWith('parse: '));
      });

      test('an unparseable createdAt', () async {
        final e = await parseFailure({
          'items': [wireItem(createdAt: 'not a date')],
          'hasMore': false,
        });

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
          repo.listMyNotifications(),
          throwsA(isA<UnknownException>()),
        );
      });

      test(
        'the detail carries the runtime type only - no id, no text',
        () async {
          final e = await parseFailure({
            'items': [
              wireItem(
                notificationId: 'secret-notification-id',
                data: announcementData(
                  titleEn: 'Secret title',
                  bodyEn: 'Secret body',
                ),
              )..remove('createdAt'),
            ],
            'hasMore': false,
          });

          expect(e.detail, isNot(contains('secret')));
          expect(e.detail, isNot(contains('Secret')));
          expect(e.toString(), isNot(contains('Secret')));
        },
      );
    });
  });

  group('markNotificationRead', () {
    const id = '5a000000-0000-4000-8000-000000000007';
    const readPath = '/me/notifications/$id/read';

    test('POSTs the id-specific path and returns nothing on 204', () async {
      when(
        () => dio.post<void>(readPath),
      ).thenAnswer((_) async => response<void>(null, status: 204));

      await repo.markNotificationRead(id);

      verify(() => dio.post<void>(readPath)).called(1);
    });

    test('is safe to repeat: a second 204 is also fine', () async {
      when(
        () => dio.post<void>(readPath),
      ).thenAnswer((_) async => response<void>(null, status: 204));

      await repo.markNotificationRead(id);
      await repo.markNotificationRead(id);

      verify(() => dio.post<void>(readPath)).called(2);
    });

    test('a 404 not_found surfaces as the typed ApiException', () async {
      // "unknown id, OR an id belonging to another account" - one code for
      // both. It is NOT swallowed here: the notifier decides it means "gone".
      when(
        () => dio.post<void>(readPath),
      ).thenThrow(failure(const ApiException(status: 404, code: 'not_found')));

      await expectLater(
        repo.markNotificationRead(id),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 404)
              .having((e) => e.code, 'code', 'not_found'),
        ),
      );
    });

    test(
      'surfaces 401, the deletion grace 403 and offline untouched',
      () async {
        for (final error in <AppException>[
          const UnauthorizedException(code: 'session_superseded'),
          const ApiException(status: 403, code: 'account_pending_deletion'),
          const OfflineException(),
          const NetworkException(detail: 'timeout'),
        ]) {
          when(() => dio.post<void>(readPath)).thenThrow(failure(error));

          await expectLater(
            repo.markNotificationRead(id),
            throwsA(same(error)),
            reason: error.code,
          );
        }
      },
    );

    test('a DioException that bypassed the interceptor is Unknown', () async {
      when(
        () => dio.post<void>(readPath),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '/x')));

      await expectLater(
        repo.markNotificationRead(id),
        throwsA(isA<UnknownException>()),
      );
    });

    test('the id is path-encoded, never interpolated raw', () async {
      when(
        () => dio.post<void>('/me/notifications/a%2Fb/read'),
      ).thenAnswer((_) async => response<void>(null, status: 204));

      await repo.markNotificationRead('a/b');

      verify(() => dio.post<void>('/me/notifications/a%2Fb/read')).called(1);
    });
  });
}
