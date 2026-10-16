import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/notifications/models/notification_models.dart';
import 'package:level_up_app/features/notifications/notifier/notifications_notifier.dart';
import 'package:level_up_app/features/notifications/repository/notifications_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_fixtures.dart';

class _MockRepo extends Mock implements NotificationsRepository {}

/// The inbox notifier: paging on `hasMore`, the walk over pages with nothing
/// renderable, and mark-as-read.
///
/// The cases that matter most are the ones a small happy-path inbox never
/// reaches: a first page made ONLY of ignored items while `hasMore` is true
/// (every student's welcome item is one), a failed append next to loaded rows,
/// and a tap racing a page that is still in flight.
void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  ProviderContainer containerWith() {
    final container = ProviderContainer(
      overrides: [notificationsRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Stubs `listMyNotifications` for ONE cursor + category pair.
  When<Future<CursorPage<NotificationItem>>> listCall({
    String? cursor,
    NotificationCategory? category,
  }) => when(
    () => repo.listMyNotifications(
      cursor: cursor,
      limit: any(named: 'limit'),
      category: category,
    ),
  );

  /// Every `listMyNotifications` call, whatever its arguments.
  VerificationResult verifyAnyList() => verify(
    () => repo.listMyNotifications(
      cursor: any(named: 'cursor'),
      limit: any(named: 'limit'),
      category: any(named: 'category'),
    ),
  );

  /// No `listMyNotifications` call at all since the last `clearInteractions`.
  void verifyNoList() => verifyNever(
    () => repo.listMyNotifications(
      cursor: any(named: 'cursor'),
      limit: any(named: 'limit'),
      category: any(named: 'category'),
    ),
  );

  /// Mounts a tab the way the screen does (a live listener) and waits for page
  /// one. An autoDispose notifier without a listener may be disposed at any
  /// time, which would make "after dispose" tests vacuous.
  Future<NotificationsNotifier> open(
    ProviderContainer container, {
    NotificationCategory? category,
  }) async {
    final provider = notificationsProvider(category);
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
    return container.read(provider.notifier);
  }

  InboxResults results(
    ProviderContainer container, [
    NotificationCategory? category,
  ]) => container.read(notificationsProvider(category)).requireValue;

  group('build - page one', () {
    test('All asks for no category and the page size', () async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('a')]));

      final container = containerWith();
      await open(container);

      verify(
        () => repo.listMyNotifications(cursor: null, limit: 20, category: null),
      ).called(1);
    });

    test('a tab asks for its own category', () async {
      listCall(
        category: NotificationCategory.support,
      ).thenAnswer((_) async => inboxPage(const []));

      final container = containerWith();
      await open(container, category: NotificationCategory.support);

      verify(
        () => repo.listMyNotifications(
          cursor: null,
          limit: 20,
          category: NotificationCategory.support,
        ),
      ).called(1);
    });

    test(
      'items keeps everything; visibleItems drops what is ignored',
      () async {
        listCall().thenAnswer(
          (_) async => inboxPage([
            announcementItem('a'),
            ignoredItem('e'),
            warningItem('w'),
            notification('x', kind: 'brand_new_kind'),
            notification('p', category: 'promotions'),
          ]),
        );

        final container = containerWith();
        await open(container);

        final r = results(container);
        expect(r.items.map((i) => i.notificationId), ['a', 'e', 'w', 'x', 'p']);
        expect(r.visibleItems.map((i) => i.notificationId), ['a', 'w']);
        expect(r.isEmpty, isFalse);
      },
    );

    test('hasMore and the cursor are the server\'s, verbatim', () async {
      listCall().thenAnswer(
        (_) async => inboxPage(
          [announcementItem('a')],
          hasMore: true,
          nextCursor: 'opaque-2',
        ),
      );

      final container = containerWith();
      await open(container);

      expect(results(container).hasMore, isTrue);
      expect(results(container).nextCursor, 'opaque-2');
    });

    test('isUnread: the server readAt wins, and a local mark counts', () async {
      listCall().thenAnswer(
        (_) async => inboxPage([
          announcementItem('unread'),
          announcementItem('read', readAt: DateTime.utc(2026, 10, 9, 13)),
        ]),
      );

      final container = containerWith();
      await open(container);

      final r = results(container);
      expect(r.isUnread(r.items[0]), isTrue);
      expect(r.isUnread(r.items[1]), isFalse);
    });
  });

  group('the walk over pages with nothing renderable', () {
    test('a first page of ONLY ignored items with hasMore:true is not an empty '
        'inbox', () async {
      // Every student's inbox starts with an `enrolment_opened` welcome item,
      // which this app does not render. Stopping on that page would show
      // "nothing here" over a list full of announcements.
      listCall().thenAnswer(
        (_) async => ignoredOnlyPage('e1', nextCursor: 'c2'),
      );
      listCall(cursor: 'c2').thenAnswer(
        (_) async =>
            inboxPage([announcementItem('a1'), announcementItem('a2')]),
      );

      final container = containerWith();
      await open(container);

      final r = results(container);
      expect(r.visibleItems.map((i) => i.notificationId), ['a1', 'a2']);
      expect(r.items.map((i) => i.notificationId), ['e1', 'a1', 'a2']);
      expect(r.isEmpty, isFalse);
      verifyAnyList().called(2);
    });

    test('it follows the cursor each page hands back', () async {
      listCall().thenAnswer(
        (_) async => ignoredOnlyPage('e1', nextCursor: 'c2'),
      );
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => ignoredOnlyPage('e2', nextCursor: 'c3'));
      listCall(
        cursor: 'c3',
      ).thenAnswer((_) async => inboxPage([announcementItem('a1')]));

      final container = containerWith();
      await open(container);

      verifyInOrder([
        () => repo.listMyNotifications(
          cursor: null,
          limit: any(named: 'limit'),
          category: null,
        ),
        () => repo.listMyNotifications(
          cursor: 'c2',
          limit: any(named: 'limit'),
          category: null,
        ),
        () => repo.listMyNotifications(
          cursor: 'c3',
          limit: any(named: 'limit'),
          category: null,
        ),
      ]);
      expect(results(container).visibleItems, hasLength(1));
    });

    test('it stops at the first page that has something to show', () async {
      listCall().thenAnswer(
        (_) async => inboxPage(
          [announcementItem('a1')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );

      final container = containerWith();
      await open(container);

      // Page two is NOT fetched eagerly: that is what Load more is for.
      verifyAnyList().called(1);
      expect(results(container).hasMore, isTrue);
    });

    test('the walk gives up after 10 pages rather than looping', () async {
      // Ten ignored-only pages in a row with hasMore:true is a server fault,
      // not an inbox.
      listCall().thenAnswer((_) async => ignoredOnlyPage('e', nextCursor: 'c'));
      listCall(
        cursor: 'c',
      ).thenAnswer((_) async => ignoredOnlyPage('e', nextCursor: 'c'));

      final container = containerWith();
      await open(container);

      verifyAnyList().called(10);
      final r = results(container);
      expect(r.visibleItems, isEmpty);
      // Still not "empty": the server never said the inbox had ended, and
      // claiming it did would invent an answer it withheld.
      expect(r.hasMore, isTrue);
      expect(r.isEmpty, isFalse);
    });

    test('only ignored items and hasMore:false IS the empty inbox', () async {
      listCall().thenAnswer((_) async => inboxPage([ignoredItem('e1')]));

      final container = containerWith();
      await open(container);

      verifyAnyList().called(1);
      final r = results(container);
      expect(r.items, hasLength(1));
      expect(r.visibleItems, isEmpty);
      expect(r.isEmpty, isTrue);
    });

    test('no items and hasMore:false is the empty inbox', () async {
      listCall().thenAnswer((_) async => inboxPage(const []));

      final container = containerWith();
      await open(container);

      expect(results(container).isEmpty, isTrue);
    });

    test(
      'hasMore with no cursor cannot be followed - one request only',
      () async {
        // Asking again with no cursor would re-fetch page one. The state reports
        // what the server said; there is just nothing to follow.
        listCall().thenAnswer(
          (_) async => inboxPage([ignoredItem('e1')], hasMore: true),
        );

        final container = containerWith();
        final notifier = await open(container);

        verifyAnyList().called(1);
        expect(results(container).hasMore, isTrue);
        expect(results(container).nextCursor, isNull);

        clearInteractions(repo);
        await notifier.loadMore();
        verifyNoList();
      },
    );
  });

  group('paging branches on hasMore, never on the page size', () {
    test('a FULL page with hasMore:false offers no further request', () async {
      listCall().thenAnswer(
        (_) async =>
            inboxPage([for (var i = 0; i < 20; i++) announcementItem('a$i')]),
      );

      final container = containerWith();
      final notifier = await open(container);
      clearInteractions(repo);

      await notifier.loadMore();

      verifyNoList();
      expect(results(container).items, hasLength(20));
    });

    test('a ONE-row page with hasMore:true keeps paging', () async {
      listCall().thenAnswer(
        (_) async => inboxPage(
          [announcementItem('a1')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => inboxPage([announcementItem('a2')]));

      final container = containerWith();
      final notifier = await open(container);
      await notifier.loadMore();

      expect(results(container).items.map((i) => i.notificationId), [
        'a1',
        'a2',
      ]);
    });
  });

  group('loadMore', () {
    NotificationsNotifier? notifier;

    Future<ProviderContainer> twoPages() async {
      listCall().thenAnswer(
        (_) async => inboxPage(
          [announcementItem('a1'), announcementItem('a2')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      final container = containerWith();
      notifier = await open(container);
      return container;
    }

    test(
      'appends the page and carries the server\'s hasMore and cursor',
      () async {
        final container = await twoPages();
        listCall(cursor: 'c2').thenAnswer(
          (_) async => inboxPage(
            [announcementItem('a3')],
            hasMore: true,
            nextCursor: 'c3',
          ),
        );

        await notifier!.loadMore();

        final r = results(container);
        expect(r.items.map((i) => i.notificationId), ['a1', 'a2', 'a3']);
        expect(r.hasMore, isTrue);
        expect(r.nextCursor, 'c3');
        expect(r.isLoadingMore, isFalse);
        expect(r.appendError, isNull);
      },
    );

    test('the last page clears hasMore and the cursor', () async {
      final container = await twoPages();
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => inboxPage([announcementItem('a3')]));

      await notifier!.loadMore();

      expect(results(container).hasMore, isFalse);
      expect(results(container).nextCursor, isNull);
    });

    test('it is a no-op once the inbox is exhausted', () async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('a1')]));
      final container = containerWith();
      final n = await open(container);
      clearInteractions(repo);

      await n.loadMore();
      await n.loadMore();

      verifyNoList();
    });

    test('two calls in the same tick make ONE request', () async {
      final container = await twoPages();
      final gate = Completer<CursorPage<NotificationItem>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);

      final first = notifier!.loadMore();
      final second = notifier!.loadMore();
      expect(results(container).isLoadingMore, isTrue);
      gate.complete(inboxPage([announcementItem('a3')]));
      await Future.wait([first, second]);

      verify(
        () => repo.listMyNotifications(
          cursor: 'c2',
          limit: any(named: 'limit'),
          category: null,
        ),
      ).called(1);
      expect(results(container).items, hasLength(3));
    });

    test('a page with nothing renderable keeps walking', () async {
      final container = await twoPages();
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => ignoredOnlyPage('e', nextCursor: 'c3'));
      listCall(
        cursor: 'c3',
      ).thenAnswer((_) async => inboxPage([announcementItem('a3')]));

      await notifier!.loadMore();

      final r = results(container);
      expect(r.items.map((i) => i.notificationId), ['a1', 'a2', 'e', 'a3']);
      expect(r.visibleItems.map((i) => i.notificationId), ['a1', 'a2', 'a3']);
      expect(r.hasMore, isFalse);
    });

    test('that walk is bounded at 10 pages too', () async {
      final container = await twoPages();
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => ignoredOnlyPage('e', nextCursor: 'c2'));

      await notifier!.loadMore();

      verify(
        () => repo.listMyNotifications(
          cursor: 'c2',
          limit: any(named: 'limit'),
          category: null,
        ),
      ).called(10);
      final r = results(container);
      expect(r.visibleItems, hasLength(2));
      expect(r.hasMore, isTrue);
      expect(r.isLoadingMore, isFalse);
    });

    test(
      'a failed append keeps the rows and parks the error beside them',
      () async {
        final container = await twoPages();
        listCall(
          cursor: 'c2',
        ).thenAnswer((_) async => throw const NetworkException());

        await notifier!.loadMore();

        final r = results(container);
        expect(r.items, hasLength(2));
        expect(r.hasMore, isTrue);
        expect(r.nextCursor, 'c2', reason: 'the same cursor is retried');
        expect(r.isLoadingMore, isFalse);
        expect(r.appendError, isA<NetworkException>());
        expect(container.read(notificationsProvider(null)).hasError, isFalse);
      },
    );

    test('a failed append is NOT retried on its own', () async {
      final container = await twoPages();
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => throw const OfflineException());

      await notifier!.loadMore();
      await pumpEventQueue();

      verify(
        () => repo.listMyNotifications(
          cursor: 'c2',
          limit: any(named: 'limit'),
          category: null,
        ),
      ).called(1);
      expect(results(container).appendError, isA<OfflineException>());
    });

    test('a user-tapped retry re-requests the same cursor and clears the '
        'error', () async {
      final container = await twoPages();
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => throw const NetworkException());
      await notifier!.loadMore();

      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => inboxPage([announcementItem('a3')]));
      await notifier!.loadMore();

      final r = results(container);
      expect(r.appendError, isNull);
      expect(r.items.map((i) => i.notificationId), ['a1', 'a2', 'a3']);
    });

    test('every failure type is kept beside the rows, not thrown', () async {
      for (final error in <Object>[
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const UnauthorizedException(code: 'authentication_required'),
        const ValidationException(
          errors: {
            'cursor': ['bad'],
          },
        ),
        const ApiException(status: 500, code: 'internal_error'),
        const UnknownException(detail: 'parse: TypeError'),
      ]) {
        final container = await twoPages();
        listCall(cursor: 'c2').thenAnswer((_) async => throw error);

        await notifier!.loadMore();

        expect(results(container).appendError, same(error));
        expect(results(container).items, hasLength(2));
      }
    });

    test('a tap that lands while the page is in flight survives it', () async {
      final container = await twoPages();
      final gate = Completer<CursorPage<NotificationItem>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);
      when(() => repo.markNotificationRead('a1')).thenAnswer((_) async {});

      final append = notifier!.loadMore();
      await notifier!.markRead('a1');
      gate.complete(inboxPage([announcementItem('a3')]));
      await append;

      final r = results(container);
      expect(r.items, hasLength(3));
      expect(
        r.readIds,
        contains('a1'),
        reason: 'writing the stale state back would un-read the row',
      );
    });

    test(
      'a page that lands after the screen closed is dropped quietly',
      () async {
        listCall().thenAnswer(
          (_) async => inboxPage(
            [announcementItem('a1')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        final container = containerWith();
        final provider = notificationsProvider(null);
        final subscription = container.listen(provider, (_, _) {});
        await container.read(provider.future);
        final n = container.read(provider.notifier);
        final gate = Completer<CursorPage<NotificationItem>>();
        listCall(cursor: 'c2').thenAnswer((_) => gate.future);

        final append = n.loadMore();
        subscription.close();
        await pumpEventQueue();
        expect(
          container.exists(provider),
          isFalse,
          reason:
              'the notifier must really be disposed for this test to mean it',
        );
        gate.complete(inboxPage([announcementItem('a2')]));

        // Writing `state` on a disposed notifier throws; the guard prevents it.
        await append;
      },
    );

    test(
      'a failure that lands after the screen closed is dropped quietly',
      () async {
        listCall().thenAnswer(
          (_) async => inboxPage(
            [announcementItem('a1')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        final container = containerWith();
        final provider = notificationsProvider(null);
        final subscription = container.listen(provider, (_, _) {});
        await container.read(provider.future);
        final n = container.read(provider.notifier);
        final gate = Completer<CursorPage<NotificationItem>>();
        listCall(cursor: 'c2').thenAnswer((_) => gate.future);

        final append = n.loadMore();
        subscription.close();
        await pumpEventQueue();
        gate.completeError(const NetworkException());

        await append;
      },
    );

    test(
      'after the provider is invalidated and rebuilt, paging still works',
      () async {
        // `ref.onDispose` also fires on invalidation, and the same notifier
        // instance is reused for the rebuild. A flag that stayed `true` would
        // make every later page vanish without an error.
        final container = await twoPages();
        container.invalidate(notificationsProvider(null));
        await container.read(notificationsProvider(null).future);
        listCall(
          cursor: 'c2',
        ).thenAnswer((_) async => inboxPage([announcementItem('a3')]));

        await container.read(notificationsProvider(null).notifier).loadMore();

        expect(results(container).items.map((i) => i.notificationId), [
          'a1',
          'a2',
          'a3',
        ]);
      },
    );

    test('a refresh that lands mid-append discards the stale page', () async {
      final container = await twoPages();
      final gate = Completer<CursorPage<NotificationItem>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);

      final append = notifier!.loadMore();
      listCall().thenAnswer(
        (_) async => inboxPage([announcementItem('fresh')]),
      );
      await notifier!.refresh();
      gate.complete(inboxPage([announcementItem('stale')]));
      await append;

      final r = results(container);
      expect(r.items.map((i) => i.notificationId), ['fresh']);
      expect(r.hasMore, isFalse);
    });

    test('a walk that a refresh outlived asks for nothing more', () async {
      // The stale page is all ignored with a cursor: the old walk would hop
      // on to `c3` (which may have expired) before `loadMore` threw it away.
      final container = await twoPages();
      final gate = Completer<CursorPage<NotificationItem>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);
      listCall(
        cursor: 'c3',
      ).thenAnswer((_) async => inboxPage([announcementItem('stale')]));

      final append = notifier!.loadMore();
      listCall().thenAnswer(
        (_) async => inboxPage([announcementItem('fresh')]),
      );
      await notifier!.refresh();
      gate.complete(ignoredOnlyPage('e', nextCursor: 'c3'));
      await append;

      verify(
        () => repo.listMyNotifications(
          cursor: 'c2',
          limit: any(named: 'limit'),
          category: null,
        ),
      ).called(1);
      verifyNever(
        () => repo.listMyNotifications(
          cursor: 'c3',
          limit: any(named: 'limit'),
          category: null,
        ),
      );
      expect(results(container).items.map((i) => i.notificationId), ['fresh']);
    });

    test('an older refresh that lands last does not replace the newer '
        'one', () async {
      final container = await twoPages();
      final gate = Completer<CursorPage<NotificationItem>>();
      listCall().thenAnswer((_) => gate.future);
      final older = notifier!.refresh();
      listCall().thenAnswer(
        (_) async => inboxPage([announcementItem('fresh')]),
      );
      await notifier!.refresh();
      gate.complete(ignoredOnlyPage('e', nextCursor: 'c9'));
      await older;

      final r = results(container);
      expect(r.items.map((i) => i.notificationId), ['fresh']);
      expect(r.hasMore, isFalse);
    });
  });

  group('markRead', () {
    Future<(ProviderContainer, NotificationsNotifier)> open2() async {
      listCall().thenAnswer(
        (_) async => inboxPage([
          announcementItem('a'),
          announcementItem('b'),
          announcementItem('done', readAt: DateTime.utc(2026, 10, 9, 13)),
        ]),
      );
      final container = containerWith();
      final n = await open(container);
      return (container, n);
    }

    test(
      'a tap on an unread row makes exactly one request and reads it',
      () async {
        final (container, n) = await open2();
        when(() => repo.markNotificationRead('a')).thenAnswer((_) async {});

        await n.markRead('a');

        verify(() => repo.markNotificationRead('a')).called(1);
        final r = results(container);
        expect(r.readIds, {'a'});
        expect(r.isUnread(r.items[0]), isFalse);
        expect(r.isUnread(r.items[1]), isTrue, reason: 'only the tapped row');
      },
    );

    test('it never fabricates a readAt', () async {
      final (container, n) = await open2();
      when(() => repo.markNotificationRead('a')).thenAnswer((_) async {});

      await n.markRead('a');

      expect(results(container).items[0].readAt, isNull);
    });

    test('a second tap on the same row makes no second request', () async {
      final (_, n) = await open2();
      when(() => repo.markNotificationRead('a')).thenAnswer((_) async {});

      await n.markRead('a');
      await n.markRead('a');

      verify(() => repo.markNotificationRead('a')).called(1);
    });

    test('two taps in the same tick make ONE request', () async {
      final (container, n) = await open2();
      final gate = Completer<void>();
      when(() => repo.markNotificationRead('a')).thenAnswer((_) => gate.future);

      final first = n.markRead('a');
      final second = n.markRead('a');
      gate.complete();
      await Future.wait([first, second]);

      verify(() => repo.markNotificationRead('a')).called(1);
      expect(results(container).readIds, {'a'});
    });

    test('a row the server already has as read is never sent', () async {
      final (container, n) = await open2();

      await n.markRead('done');

      verifyNever(() => repo.markNotificationRead(any()));
      expect(results(container).readIds, isEmpty);
    });

    test('an id that is not in this list is never sent', () async {
      final (_, n) = await open2();

      await n.markRead('someone-elses');

      verifyNever(() => repo.markNotificationRead(any()));
    });

    test('a 404 not_found counts as read - the item is gone', () async {
      // "Unknown id, or an id belonging to another account." Showing it unread
      // forever would leave a dot nobody can clear.
      final (container, n) = await open2();
      when(() => repo.markNotificationRead('a')).thenAnswer(
        (_) async => throw const ApiException(status: 404, code: 'not_found'),
      );

      await n.markRead('a');

      verify(() => repo.markNotificationRead('a')).called(1);
      expect(results(container).readIds, {'a'});
    });

    test('any OTHER failure leaves it unread and is not retried', () async {
      for (final error in <Object>[
        const NetworkException(),
        const OfflineException(),
        const ApiException(status: 500, code: 'internal_error'),
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const UnauthorizedException(code: 'session_superseded'),
        const UnknownException(),
        // 404 is only "gone" when the code says so.
        const ApiException(status: 404, code: 'route_not_found'),
        StateError('anything at all'),
      ]) {
        clearInteractions(repo);
        final (container, n) = await open2();
        when(
          () => repo.markNotificationRead('a'),
        ).thenAnswer((_) async => throw error);

        await n.markRead('a');
        await pumpEventQueue();

        verify(() => repo.markNotificationRead('a')).called(1);
        final r = results(container);
        expect(r.readIds, isEmpty, reason: '$error');
        expect(r.isUnread(r.items[0]), isTrue, reason: '$error');
        // Marking read is a courtesy: no error is surfaced anywhere.
        expect(r.appendError, isNull);
        expect(container.read(notificationsProvider(null)).hasError, isFalse);
      }
    });

    test('after a failure the student can tap again', () async {
      final (container, n) = await open2();
      when(
        () => repo.markNotificationRead('a'),
      ).thenAnswer((_) async => throw const NetworkException());
      await n.markRead('a');

      when(() => repo.markNotificationRead('a')).thenAnswer((_) async {});
      await n.markRead('a');

      verify(() => repo.markNotificationRead('a')).called(2);
      expect(results(container).readIds, {'a'});
    });

    test(
      'a result that lands after the screen closed is dropped quietly',
      () async {
        listCall().thenAnswer((_) async => inboxPage([announcementItem('a')]));
        final container = containerWith();
        final provider = notificationsProvider(null);
        final subscription = container.listen(provider, (_, _) {});
        await container.read(provider.future);
        final n = container.read(provider.notifier);
        final gate = Completer<void>();
        when(
          () => repo.markNotificationRead('a'),
        ).thenAnswer((_) => gate.future);

        final tap = n.markRead('a');
        subscription.close();
        await pumpEventQueue();
        expect(container.exists(provider), isFalse);
        gate.complete();

        await tap;
      },
    );
  });

  group('error states', () {
    test(
      'a 403 account_pending_deletion is an error, shown once, not retried',
      () async {
        listCall().thenAnswer(
          (_) async => throw const ApiException(
            status: 403,
            code: 'account_pending_deletion',
          ),
        );
        final container = containerWith();
        final provider = notificationsProvider(null);
        container.listen(provider, (_, _) {});

        await expectLater(
          container.read(provider.future),
          throwsA(predicate<Object>(isAccountPendingDeletion)),
        );
        // Riverpod 3 would retry a failed build ~10 times over ~38 s and stay in
        // AsyncLoading meanwhile. The contract's client rule here is "do not
        // retry"; so this waits past the first retry slot (200 ms) and counts.
        await Future<void>.delayed(const Duration(milliseconds: 300));

        final state = container.read(provider);
        expect(state.hasError, isTrue);
        expect(isAccountPendingDeletion(state.error), isTrue);
        verifyAnyList().called(1);
      },
    );

    test(
      'offline is an error that the screen can recognise as offline',
      () async {
        listCall().thenAnswer((_) async => throw const OfflineException());
        final container = containerWith();
        final provider = notificationsProvider(null);
        container.listen(provider, (_, _) {});

        await expectLater(
          container.read(provider.future),
          throwsA(isA<OfflineException>()),
        );

        expect(isOffline(container.read(provider).error), isTrue);
        verifyAnyList().called(1);
      },
    );

    test('a transport failure is offline too', () async {
      listCall().thenAnswer((_) async => throw const NetworkException());
      final container = containerWith();
      final provider = notificationsProvider(null);
      container.listen(provider, (_, _) {});

      await expectLater(
        container.read(provider.future),
        throwsA(isA<NetworkException>()),
      );

      expect(isOffline(container.read(provider).error), isTrue);
    });

    test('a failure inside the walk is the build error', () async {
      listCall().thenAnswer(
        (_) async => ignoredOnlyPage('e', nextCursor: 'c2'),
      );
      listCall(cursor: 'c2').thenAnswer(
        (_) async => throw const ApiException(status: 500, code: 'x'),
      );
      final container = containerWith();
      final provider = notificationsProvider(null);
      container.listen(provider, (_, _) {});

      await expectLater(
        container.read(provider.future),
        throwsA(isA<ApiException>()),
      );
    });

    test('refresh re-runs from page one and recovers', () async {
      var healthy = false;
      listCall().thenAnswer((_) async {
        if (!healthy) throw const NetworkException();
        return inboxPage([announcementItem('a')]);
      });
      final container = containerWith();
      final provider = notificationsProvider(null);
      container.listen(provider, (_, _) {});
      await expectLater(
        container.read(provider.future),
        throwsA(isA<NetworkException>()),
      );

      healthy = true;
      await container.read(provider.notifier).refresh();

      expect(container.read(provider).hasError, isFalse);
      expect(results(container).items.single.notificationId, 'a');
    });

    test(
      'refresh drops the local read marks for the server\'s answer',
      () async {
        var readOnServer = false;
        listCall().thenAnswer(
          (_) async => inboxPage([
            announcementItem(
              'a',
              readAt: readOnServer ? DateTime.utc(2026, 10, 9, 14) : null,
            ),
          ]),
        );
        when(() => repo.markNotificationRead('a')).thenAnswer((_) async {});
        final container = containerWith();
        final n = await open(container);
        await n.markRead('a');
        expect(results(container).readIds, {'a'});

        readOnServer = true;
        await n.refresh();

        final r = results(container);
        expect(r.readIds, isEmpty);
        expect(
          r.isUnread(r.items.single),
          isFalse,
          reason: 'the server says so',
        );
      },
    );
  });

  group('one notifier per tab', () {
    test('each tab has its own list, cursor and read marks', () async {
      listCall().thenAnswer(
        (_) async => inboxPage(
          [announcementItem('all-1'), warningItem('all-2')],
          hasMore: true,
          nextCursor: 'all-cursor',
        ),
      );
      listCall(category: NotificationCategory.announcements).thenAnswer(
        (_) async => inboxPage(
          [announcementItem('ann-1')],
          hasMore: true,
          nextCursor: 'ann-cursor',
        ),
      );
      when(() => repo.markNotificationRead('ann-1')).thenAnswer((_) async {});

      final container = containerWith();
      await open(container);
      final announcements = await open(
        container,
        category: NotificationCategory.announcements,
      );
      await announcements.markRead('ann-1');

      final all = results(container);
      final ann = results(container, NotificationCategory.announcements);
      expect(all.items.map((i) => i.notificationId), ['all-1', 'all-2']);
      expect(all.nextCursor, 'all-cursor');
      expect(all.readIds, isEmpty);
      expect(ann.items.map((i) => i.notificationId), ['ann-1']);
      expect(ann.nextCursor, 'ann-cursor');
      expect(ann.readIds, {'ann-1'});
    });

    test(
      'a tab\'s Load more sends that tab\'s category and its own cursor',
      () async {
        listCall(category: NotificationCategory.system).thenAnswer(
          (_) async => inboxPage(
            [warningItem('w1')],
            hasMore: true,
            nextCursor: 'sys-2',
          ),
        );
        listCall(
          cursor: 'sys-2',
          category: NotificationCategory.system,
        ).thenAnswer((_) async => inboxPage([warningItem('w2')]));

        final container = containerWith();
        final n = await open(container, category: NotificationCategory.system);
        await n.loadMore();

        verify(
          () => repo.listMyNotifications(
            cursor: 'sys-2',
            limit: 20,
            category: NotificationCategory.system,
          ),
        ).called(1);
        expect(
          results(container, NotificationCategory.system).items,
          hasLength(2),
        );
      },
    );

    test('an empty tab is the per-tab empty state', () async {
      listCall(
        category: NotificationCategory.support,
      ).thenAnswer((_) async => inboxPage(const []));

      final container = containerWith();
      await open(container, category: NotificationCategory.support);

      expect(results(container, NotificationCategory.support).isEmpty, isTrue);
    });
  });

  test('the provider does not silently auto-retry a failed inbox', () async {
    // Riverpod 3 retries a failed build with backoff and stays AsyncLoading
    // while it does; here Retry is a user-tapped button.
    listCall().thenAnswer((_) async => throw const RateLimitedException());

    final container = containerWith();
    await expectLater(
      container.read(notificationsProvider(null).future),
      throwsA(isA<RateLimitedException>()),
    );
    expect(container.read(notificationsProvider(null)).hasError, isTrue);
  });
}
