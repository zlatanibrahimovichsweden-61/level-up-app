import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_notifications.dart';
import 'package:level_up_app/features/notifications/models/notification_models.dart';
import 'package:level_up_app/features/notifications/notifier/notifications_notifier.dart';
import 'package:level_up_app/features/notifications/repository/notifications_repository.dart';

/// The two `stable` Notifications operations, served by the on-device mock.
///
/// The harness is the only place the inbox can be walked with more than one
/// page, every kind and a mix of read states: the staging account has an empty
/// inbox (SQ-16). So these pin what the contract specifies - newest first,
/// `limit` validated not clamped, `category` narrowing BEFORE paging, an opaque
/// cursor, an idempotent read that never moves `readAt`, one 404 for unknown
/// and foreign ids - and drive it through the REAL [NotificationsRepository],
/// which also proves the requests the app builds are the ones the mock
/// understands.
///
/// Every test gets a FRESH interceptor (`buildMockDio` per session), so no read
/// mark leaks from one test to the next.
void main() {
  group('GET /me/notifications - paging', () {
    test(
      '24 items page 20 / 4 by cursor, and hasMore says when to stop',
      () async {
        final s = _Session();

        final first = await s.repo.listMyNotifications();
        expect(first.items, hasLength(20));
        expect(first.hasMore, isTrue);
        expect(first.nextCursor, isNotNull);

        final second = await s.repo.listMyNotifications(
          cursor: first.nextCursor,
        );
        expect(second.items, hasLength(4));
        expect(second.hasMore, isFalse);
        expect(second.nextCursor, isNull);

        // One contiguous run, nothing repeated or skipped.
        expect([...first.items, ...second.items].map((i) => i.notificationId), [
          for (var n = 1; n <= kMockNotificationCount; n++)
            mockNotificationId(n),
        ]);
      },
    );

    test('newest first', () async {
      final s = _Session();

      final all = await s.allItems();

      final times = all.map((i) => i.createdAt).toList();
      for (var i = 1; i < times.length; i++) {
        expect(times[i].isBefore(times[i - 1]), isTrue, reason: 'row $i');
      }
    });

    test(
      'the default limit is 20; 1 and 100 (the bounds) are accepted',
      () async {
        final s = _Session();

        expect((await s.repo.listMyNotifications()).items, hasLength(20));

        final one = await s.repo.listMyNotifications(limit: 1);
        expect(one.items, hasLength(1));
        expect(one.hasMore, isTrue);

        final hundred = await s.repo.listMyNotifications(limit: 100);
        expect(hundred.items, hasLength(kMockNotificationCount));
        expect(hundred.hasMore, isFalse);
      },
    );

    test('a page size of 5 walks 5 / 5 / 5 / 5 / 4', () async {
      final s = _Session();

      final sizes = <int>[];
      String? cursor;
      do {
        final page = await s.repo.listMyNotifications(cursor: cursor, limit: 5);
        sizes.add(page.items.length);
        cursor = page.hasMore ? page.nextCursor : null;
      } while (cursor != null);

      expect(sizes, [5, 5, 5, 5, 4]);
    });

    test('the wire shape is the six contract fields', () async {
      final s = _Session();

      final res = await s.dio.get<Map<String, dynamic>>('/me/notifications');

      final body = res.data!;
      expect(body.keys, containsAll(['items', 'nextCursor', 'hasMore']));
      for (final raw in body['items'] as List<dynamic>) {
        final item = raw as Map<String, dynamic>;
        expect(item.keys.toSet(), {
          'notificationId',
          'kind',
          'category',
          'data',
          'createdAt',
          'readAt',
        });
        expect(item['data'], isA<Map<String, dynamic>>());
        expect(
          (item['data'] as Map<String, dynamic>).values,
          everyElement(isA<String>()),
        );
        expect(DateTime.parse(item['createdAt'] as String).isUtc, isTrue);
        expect(item['readAt'], anyOf(isNull, isA<String>()));
      }
    });
  });

  group('GET /me/notifications - category', () {
    test('absent is All, and All holds every kind', () async {
      final s = _Session();

      final all = await s.allItems();

      expect(all, hasLength(kMockNotificationCount));
      expect(all.map((i) => i.kind).toSet(), {
        'announcement',
        'moderation_warning',
        'support_ticket_replied',
        'academic_year_opened',
        'enrolment_opened',
        'future_kind_sample',
      });
    });

    test('announcements: 17, all announcements, across pages', () async {
      final s = _Session();

      final items = await s.allItems(
        category: NotificationCategory.announcements,
      );

      expect(items, hasLength(17));
      expect(items.map((i) => i.category).toSet(), {'announcements'});
      expect(items.map((i) => i.kind).toSet(), {'announcement'});
    });

    test(
      'system: the warnings, the year, the unknown kind, the welcome',
      () async {
        final s = _Session();

        final items = await s.allItems(category: NotificationCategory.system);

        expect(items.map((i) => i.kind), [
          'moderation_warning',
          'academic_year_opened',
          'future_kind_sample',
          'moderation_warning',
          'enrolment_opened',
        ]);
      },
    );

    test('support: the one ticket reply', () async {
      final s = _Session();

      final items = await s.allItems(category: NotificationCategory.support);

      expect(items.single.kind, 'support_ticket_replied');
      expect(items.single.data, {
        'ticketId': mockNotificationId(900),
        'reference': 'TK-12',
      });
    });

    test(
      'the filter narrows BEFORE paging, so the cursor walks the tab',
      () async {
        final s = _Session();

        final first = await s.repo.listMyNotifications(
          category: NotificationCategory.announcements,
          limit: 10,
        );
        expect(first.items, hasLength(10));
        expect(first.hasMore, isTrue);

        final second = await s.repo.listMyNotifications(
          category: NotificationCategory.announcements,
          cursor: first.nextCursor,
          limit: 10,
        );
        expect(second.items, hasLength(7));
        expect(second.hasMore, isFalse);
      },
    );

    test('the item with an unknown category is in All and in no tab', () async {
      final s = _Session();

      final all = await s.allItems();
      final unknown = all.where((i) => i.knownCategory == null).toList();
      expect(unknown, hasLength(1));
      expect(unknown.single.kind, 'announcement');
      expect(unknown.single.category, 'promotions');

      for (final category in NotificationCategory.values) {
        final tab = await s.allItems(category: category);
        expect(
          tab.map((i) => i.notificationId),
          isNot(contains(unknown.single.notificationId)),
          reason: category.wire,
        );
      }
    });

    test('a category outside the published set is 400 on `category`', () async {
      final s = _Session();

      for (final bad in const ['promotions', 'all', 'System', '']) {
        final e = await _rejection(
          s.dio.get<Object?>(
            '/me/notifications',
            queryParameters: {'category': bad},
          ),
        );
        expect(e, isA<ValidationException>(), reason: bad);
        expect((e as ValidationException).fields, contains('category'));
      }
    });
  });

  group('GET /me/notifications - validation', () {
    test('limit is VALIDATED, not clamped: 0, 101, -1, abc are 400', () async {
      final s = _Session();

      for (final bad in const [0, 101, -1, 'abc', 1000]) {
        final e = await _rejection(
          s.dio.get<Object?>(
            '/me/notifications',
            queryParameters: {'limit': bad},
          ),
        );
        expect(e, isA<ValidationException>(), reason: '$bad');
        expect((e as ValidationException).fields, contains('limit'));
      }
    });

    test('a cursor this mock did not issue is 400 on `cursor`', () async {
      final s = _Session();

      for (final bad in const ['', 'not-a-cursor', '%%%', 'bW9jay1pbmJveDp4']) {
        final e = await _rejection(
          s.dio.get<Object?>(
            '/me/notifications',
            queryParameters: {'cursor': bad},
          ),
        );
        expect(e, isA<ValidationException>(), reason: bad);
        expect((e as ValidationException).fields, contains('cursor'));
      }
    });

    test('every bad parameter is reported in one answer', () async {
      final s = _Session();

      final e = await _rejection(
        s.dio.get<Object?>(
          '/me/notifications',
          queryParameters: {'limit': 0, 'category': 'x', 'cursor': 'y'},
        ),
      );

      expect(
        (e as ValidationException).fields,
        containsAll(['limit', 'category', 'cursor']),
      );
    });

    test(
      'the cursor is opaque to the app: nothing is parsed or built here',
      () async {
        final s = _Session();

        final page = await s.repo.listMyNotifications(limit: 1);

        // Not a bare offset the client could be tempted to compute.
        expect(int.tryParse(page.nextCursor!), isNull);
      },
    );
  });

  group('the fixtures cover every case the app must handle', () {
    test('both read states are present', () async {
      final s = _Session();

      final all = await s.allItems();

      expect(all.where((i) => i.readAt == null), isNotEmpty);
      expect(all.where((i) => i.readAt != null), isNotEmpty);
    });

    test('the first row is the Figma sample announcement, unread', () async {
      final s = _Session();

      final first = (await s.allItems()).first;

      expect(first.kind, 'announcement');
      expect(first.readAt, isNull);
      final content = first.content! as AnnouncementContent;
      expect(content.titleEn, 'New Biology Quiz Available!');
      expect(
        content.bodyEn,
        'A new quiz on Cell Biology has been added. '
        'Test your knowledge now!',
      );
      expect(content.titleAr, isNotEmpty);
      expect(content.bodyAr, isNotEmpty);
    });

    test(
      'one announcement has a line break in its body, in both languages',
      () async {
        final s = _Session();

        final multiline = (await s.allItems()).where((i) {
          final c = i.content;
          return c is AnnouncementContent &&
              c.bodyEn.contains('\n') &&
              c.bodyAr.contains('\n');
        });

        expect(multiline, isNotEmpty);
      },
    );

    test('moderation warnings carry empty data', () async {
      final s = _Session();

      final warnings = (await s.allItems()).where(
        (i) => i.kind == 'moderation_warning',
      );

      expect(warnings, hasLength(2));
      for (final w in warnings) {
        expect(w.data, isEmpty);
        expect(w.category, 'system');
        expect(w.content, isA<ModerationWarningContent>());
      }
    });

    test('the academic year row carries track + academicYear', () async {
      final s = _Session();

      final year = (await s.allItems()).singleWhere(
        (i) => i.kind == 'academic_year_opened',
      );

      expect(year.data, {'track': 'school', 'academicYear': '2026/2027'});
    });

    test('exactly 19 of the 24 are rendered; 5 are ignored', () async {
      // Ignored: support reply, academic year, unknown kind, unknown category,
      // and the enrolment welcome.
      final s = _Session();

      final all = await s.allItems();

      expect(all.where((i) => i.content != null), hasLength(19));
      expect(all.where((i) => i.content == null), hasLength(5));
    });

    test('page one holds 4 ignored rows, so it renders 16 of its 20', () async {
      final s = _Session();

      final first = await s.repo.listMyNotifications();

      expect(first.items.where((i) => i.content != null), hasLength(16));
    });
  });

  group('POST /me/notifications/{id}/read', () {
    test('answers 204 and the row then carries a readAt', () async {
      final s = _Session();
      final id = mockNotificationId(1);
      expect((await s.allItems()).first.readAt, isNull);

      await s.repo.markNotificationRead(id);

      final row = (await s.allItems()).firstWhere(
        (i) => i.notificationId == id,
      );
      expect(row.readAt, isNotNull);
    });

    test('the raw answer is a 204 with no body', () async {
      final s = _Session();

      final res = await s.dio.post<Object?>(
        '/me/notifications/${mockNotificationId(1)}/read',
      );

      expect(res.statusCode, 204);
      expect(res.data, isNull);
    });

    test(
      'is idempotent: a second call is 204 and readAt does not move',
      () async {
        final s = _Session();
        final id = mockNotificationId(1);

        await s.repo.markNotificationRead(id);
        final firstReadAt = (await s.allItems())
            .firstWhere((i) => i.notificationId == id)
            .readAt;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await s.repo.markNotificationRead(id);
        final secondReadAt = (await s.allItems())
            .firstWhere((i) => i.notificationId == id)
            .readAt;

        expect(firstReadAt, isNotNull);
        expect(secondReadAt, firstReadAt);
      },
    );

    test('marking an already-read row leaves its readAt alone', () async {
      final s = _Session();
      final before = (await s.allItems())[4]; // fixture 5 is read
      expect(before.readAt, isNotNull);

      await s.repo.markNotificationRead(before.notificationId);

      final after = (await s.allItems())[4];
      expect(after.readAt, before.readAt);
    });

    test('only the named row changes', () async {
      final s = _Session();
      final unreadBefore = (await s.allItems())
          .where((i) => i.readAt == null)
          .length;

      await s.repo.markNotificationRead(mockNotificationId(1));

      final unreadAfter = (await s.allItems())
          .where((i) => i.readAt == null)
          .length;
      expect(unreadAfter, unreadBefore - 1);
    });

    test('the mark shows in every tab that lists the row', () async {
      final s = _Session();
      final id = mockNotificationId(1);

      await s.repo.markNotificationRead(id);

      final tab = await s.allItems(
        category: NotificationCategory.announcements,
      );
      expect(tab.firstWhere((i) => i.notificationId == id).readAt, isNotNull);
    });

    test(
      'an ignored kind can be marked too - the server does not care',
      () async {
        final s = _Session();

        await s.repo.markNotificationRead(mockNotificationId(3));

        final row = (await s.allItems()).firstWhere(
          (i) => i.notificationId == mockNotificationId(3),
        );
        expect(row.readAt, isNotNull);
      },
    );

    test('an unknown id is 404 not_found', () async {
      final s = _Session();

      final e = await _rejection(
        s.repo.markNotificationRead('00000000-0000-4000-8000-00000000dead'),
      );

      expect(e, isA<ApiException>());
      expect((e as ApiException).status, 404);
      expect(e.code, 'not_found');
    });

    test('a malformed id is the same 404 - no second code to probe', () async {
      final s = _Session();

      final e = await _rejection(s.repo.markNotificationRead('nope'));

      expect((e as ApiException).status, 404);
      expect(e.code, 'not_found');
    });

    test('a failed mark changes nothing', () async {
      final s = _Session();
      final before = (await s.allItems()).where((i) => i.readAt == null).length;

      await _rejection(s.repo.markNotificationRead('nope'));

      final after = (await s.allItems()).where((i) => i.readAt == null).length;
      expect(after, before);
    });

    test(
      'state is per mock session: a fresh session starts from the fixtures',
      () async {
        final one = _Session();
        await one.repo.markNotificationRead(mockNotificationId(1));
        final two = _Session();

        expect((await two.allItems()).first.readAt, isNull);
        expect((await one.allItems()).first.readAt, isNotNull);
      },
    );
  });

  group('the real notifier over the mock', () {
    // The fixtures and the notifier were written against the same contract
    // text; this is the one place they meet, with no stub in between.
    ProviderContainer containerOverMock() {
      final container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(buildMockDio(latency: Duration.zero)),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    Future<NotificationsNotifier> open(
      ProviderContainer container, [
      NotificationCategory? category,
    ]) async {
      final provider = notificationsProvider(category);
      container.listen(provider, (_, _) {});
      await container.read(provider.future);
      return container.read(provider.notifier);
    }

    InboxResults results(
      ProviderContainer container, [
      NotificationCategory? category,
    ]) => container.read(notificationsProvider(category)).requireValue;

    test(
      'All: 16 rows on page one, 19 after Load more, none ignored',
      () async {
        final container = containerOverMock();
        final notifier = await open(container);

        final first = results(container);
        expect(first.items, hasLength(20));
        expect(first.visibleItems, hasLength(16));
        expect(first.hasMore, isTrue);
        expect(first.isEmpty, isFalse);

        await notifier.loadMore();

        final all = results(container);
        expect(all.items, hasLength(kMockNotificationCount));
        expect(all.visibleItems, hasLength(19));
        expect(all.hasMore, isFalse);
        // Nothing the app ignores reaches the list it draws.
        expect(all.visibleItems.map((i) => i.kind).toSet(), {
          'announcement',
          'moderation_warning',
        });
        expect(all.visibleItems.every((i) => i.knownCategory != null), isTrue);
      },
    );

    test('a tab shows its own rows, and Support is the empty state', () async {
      final container = containerOverMock();

      await open(container, NotificationCategory.announcements);
      await open(container, NotificationCategory.system);
      await open(container, NotificationCategory.support);

      expect(
        results(container, NotificationCategory.announcements).visibleItems,
        hasLength(17),
      );
      // system holds 2 warnings + 3 ignored kinds.
      expect(
        results(container, NotificationCategory.system).visibleItems,
        hasLength(2),
      );
      // The only support row is a ticket reply, which CW07a ignores: one page,
      // hasMore false, nothing to draw.
      final support = results(container, NotificationCategory.support);
      expect(support.items, hasLength(1));
      expect(support.isEmpty, isTrue);
    });

    test('a tap marks the row read, and a reload agrees', () async {
      final container = containerOverMock();
      final notifier = await open(container);
      final first = results(container).visibleItems.first;
      expect(results(container).isUnread(first), isTrue);

      await notifier.markRead(first.notificationId);

      expect(results(container).isUnread(first), isFalse);
      await notifier.refresh();
      final reloaded = results(container);
      expect(
        reloaded.isUnread(
          reloaded.items.firstWhere(
            (i) => i.notificationId == first.notificationId,
          ),
        ),
        isFalse,
        reason: 'the server now has a readAt for it',
      );
      expect(
        reloaded.readIds,
        isEmpty,
        reason: 'server truth replaced the set',
      );
    });
  });

  group('routes the mock does not serve', () {
    test(
      'GET /me/notifications/unread-count falls through to the generic 404',
      () async {
        // The app does not call getUnreadNotificationCount yet (CW07b).
        final s = _Session();

        final e = await _rejection(
          s.dio.get<Object?>('/me/notifications/unread-count'),
        );

        expect((e as ApiException).status, 404);
      },
    );

    test('a GET on the read path is not the read operation', () async {
      final s = _Session();

      final e = await _rejection(
        s.dio.get<Object?>('/me/notifications/${mockNotificationId(1)}/read'),
      );

      expect((e as ApiException).status, 404);
      expect((await s.allItems()).first.readAt, isNull);
    });
  });
}

/// One mock student: a fresh interceptor driven through the REAL repository.
class _Session {
  _Session() : dio = buildMockDio(latency: Duration.zero) {
    repo = NotificationsRepository(dio);
  }

  final Dio dio;
  late final NotificationsRepository repo;

  /// Every item of one tab (or All), following the cursor to the end.
  Future<List<NotificationItem>> allItems({
    NotificationCategory? category,
  }) async {
    final items = <NotificationItem>[];
    String? cursor;
    do {
      final page = await repo.listMyNotifications(
        cursor: cursor,
        category: category,
      );
      items.addAll(page.items);
      cursor = page.hasMore ? page.nextCursor : null;
    } while (cursor != null);
    return items;
  }
}

/// The mapped [AppException] behind a rejected mock call - the harness runs the
/// REAL ErrorInterceptor, so this is the type a screen would receive. A call
/// that already went through a repository rethrows the [AppException] itself.
Future<AppException> _rejection(Future<Object?> call) async {
  try {
    await call;
  } on DioException catch (e) {
    return e.error! as AppException;
  } on AppException catch (e) {
    return e;
  }
  fail('expected the mock to reject this request');
}
