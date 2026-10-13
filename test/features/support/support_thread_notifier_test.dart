import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/support/models/support_models.dart';
import 'package:level_up_app/features/support/notifier/support_thread_notifier.dart';
import 'package:level_up_app/features/support/notifier/support_tickets_notifier.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'support_fixtures.dart';

class _MockRepo extends Mock implements SupportRepository {}

/// The thread notifier: the concurrent ticket + first page load, the bounded
/// walk, paging, and the student's own reply.
///
/// The cases that matter most are the ones a short thread never reaches: a walk
/// that must stop, a failure halfway through it, a reply racing a refresh or a
/// closed screen, and the `409 ticket_closed` that turns the composer into the
/// closed bar.
void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  ProviderContainer containerWith() {
    final container = ProviderContainer(
      overrides: [supportRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  final provider = supportThreadProvider(ticketIdA);

  When<Future<SupportTicket>> ticketCall() =>
      when(() => repo.getMySupportTicket(ticketIdA));

  When<Future<CursorPage<SupportTicketMessage>>> pageCall({String? cursor}) =>
      when(() => repo.listMySupportTicketMessages(ticketIdA, cursor: cursor));

  When<Future<SupportTicketMessage>> postCall([String? body]) =>
      when(() => repo.postMySupportTicketMessage(ticketIdA, body ?? any()));

  VerificationResult verifyAnyPage() => verify(
    () => repo.listMySupportTicketMessages(
      ticketIdA,
      cursor: any(named: 'cursor'),
    ),
  );

  /// A one-page thread of [count] replies, all loaded.
  void stubSimpleThread({
    SupportTicket? ticket,
    List<SupportTicketMessage>? messages,
    bool hasMore = false,
    String? nextCursor,
  }) {
    ticketCall().thenAnswer((_) async => ticket ?? ticketDetail(ticketIdA));
    pageCall().thenAnswer(
      (_) async => messagesPage(
        messages ?? [supportMessage('m1')],
        hasMore: hasMore,
        nextCursor: nextCursor,
      ),
    );
  }

  /// Mounts the thread the way the screen does (a live listener) and waits for
  /// the first load.
  Future<SupportThreadNotifier> open(ProviderContainer container) async {
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
    return container.read(provider.notifier);
  }

  SupportThread thread(ProviderContainer container) =>
      container.read(provider).requireValue;

  List<String> messageIds(ProviderContainer container) =>
      thread(container).messages.map((m) => m.messageId).toList();

  group('build - ticket and first page', () {
    test('the ticket and the first page are requested TOGETHER', () async {
      final ticketGate = Completer<SupportTicket>();
      final pageGate = Completer<CursorPage<SupportTicketMessage>>();
      ticketCall().thenAnswer((_) => ticketGate.future);
      pageCall().thenAnswer((_) => pageGate.future);

      final container = containerWith();
      container.listen(provider, (_, _) {});
      final loaded = container.read(provider.future);
      await pumpEventQueue();

      // Neither has answered, and both are already on the wire.
      verify(() => repo.getMySupportTicket(ticketIdA)).called(1);
      verifyAnyPage().called(1);

      pageGate.complete(messagesPage([supportMessage('m1')]));
      ticketGate.complete(ticketDetail(ticketIdA));
      await loaded;
      expect(messageIds(container), ['m1']);
    });

    test('the first page asks for no cursor', () async {
      stubSimpleThread();

      final container = containerWith();
      await open(container);

      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: null),
      ).called(1);
    });

    test('the ticket and the replies, oldest first, as the server sent '
        'them', () async {
      stubSimpleThread(
        ticket: ticketDetail(ticketIdA, details: 'The opening text'),
        messages: [
          supportMessage('m1'),
          supportMessage('m2', authorKind: 'staff'),
          supportMessage('m3'),
        ],
      );

      final container = containerWith();
      await open(container);

      final t = thread(container);
      expect(t.ticket.details, 'The opening text');
      expect(messageIds(container), ['m1', 'm2', 'm3']);
      expect(
        t.messages.every((m) => m.body != 'The opening text'),
        isTrue,
        reason: '`details` is the opening text, not a thread message',
      );
      expect(t.hasMore, isFalse);
      expect(t.nextCursor, isNull);
      expect(t.isLoadingMore, isFalse);
      expect(t.isSending, isFalse);
      expect(t.appendError, isNull);
    });

    test('an empty thread is a normal thread', () async {
      stubSimpleThread(messages: const []);

      final container = containerWith();
      await open(container);

      expect(thread(container).messages, isEmpty);
      expect(thread(container).hasMore, isFalse);
    });

    test('isClosed is true only for a closed ticket', () async {
      stubSimpleThread(ticket: closedTicket(ticketIdA));
      var container = containerWith();
      await open(container);
      expect(thread(container).isClosed, isTrue);

      for (final status in ['open', 'in_progress', 'pending', 'escalated']) {
        stubSimpleThread(ticket: ticketDetail(ticketIdA, status: status));
        container = containerWith();
        await open(container);
        expect(thread(container).isClosed, isFalse, reason: status);
      }
    });

    test('a ticket failure is the build error - and wins over a page '
        'failure', () async {
      const notFound = ApiException(status: 404, code: 'not_found');
      ticketCall().thenAnswer((_) async => throw notFound);
      pageCall().thenAnswer((_) async => throw const NetworkException());

      final container = containerWith();
      await expectLater(
        container.read(provider.future),
        throwsA(same(notFound)),
      );
      // The loser's error was consumed, not left to reach the zone: this test
      // would fail on an unhandled async error.
      await pumpEventQueue();
    });

    test('a first-page failure is the build error', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      pageCall().thenAnswer((_) async => throw const OfflineException());

      final container = containerWith();
      await expectLater(
        container.read(provider.future),
        throwsA(isA<OfflineException>()),
      );
      expect(container.read(provider).hasError, isTrue);
    });

    test('the provider does not silently auto-retry a failed build', () async {
      // Riverpod 3 retries a failed build with backoff and stays AsyncLoading
      // while it does; here Retry is a user-tapped button.
      ticketCall().thenAnswer((_) async => throw const RateLimitedException());
      pageCall().thenAnswer((_) async => messagesPage(const []));

      final container = containerWith();
      container.listen(provider, (_, _) {});
      await expectLater(
        container.read(provider.future),
        throwsA(isA<RateLimitedException>()),
      );
      await pumpEventQueue();

      expect(container.read(provider).hasError, isTrue);
      verify(() => repo.getMySupportTicket(ticketIdA)).called(1);
    });
  });

  group('build - the bounded walk', () {
    test('it follows the cursor while the server says there is more', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      pageCall().thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m1')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      pageCall(cursor: 'c2').thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m2')],
          hasMore: true,
          nextCursor: 'c3',
        ),
      );
      pageCall(
        cursor: 'c3',
      ).thenAnswer((_) async => messagesPage([supportMessage('m3')]));

      final container = containerWith();
      await open(container);

      expect(messageIds(container), ['m1', 'm2', 'm3']);
      expect(thread(container).hasMore, isFalse);
      expect(thread(container).nextCursor, isNull);
      verifyInOrder([
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: null),
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c2'),
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c3'),
      ]);
    });

    test('it stops after 10 pages in all and leaves Load more', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      var n = 0;
      pageCall().thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m${++n}')],
          hasMore: true,
          nextCursor: 'c$n',
        ),
      );
      when(
        () => repo.listMySupportTicketMessages(
          ticketIdA,
          cursor: any(named: 'cursor', that: isNotNull),
        ),
      ).thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m${++n}')],
          hasMore: true,
          nextCursor: 'c$n',
        ),
      );

      final container = containerWith();
      await open(container);

      verifyAnyPage().called(10);
      final t = thread(container);
      expect(t.messages, hasLength(10));
      expect(t.hasMore, isTrue, reason: 'the server never said it had ended');
      expect(t.nextCursor, 'c10');
      expect(t.appendError, isNull);
    });

    test('hasMore with no cursor cannot be followed - one request', () async {
      stubSimpleThread(hasMore: true);

      final container = containerWith();
      await open(container);

      verifyAnyPage().called(1);
      expect(thread(container).hasMore, isTrue);
      expect(thread(container).nextCursor, isNull);
    });

    test(
      'a full 20-row page with hasMore:false needs no second page',
      () async {
        stubSimpleThread(
          messages: [for (var i = 0; i < 20; i++) supportMessage('m$i')],
        );

        final container = containerWith();
        await open(container);

        verifyAnyPage().called(1);
        expect(thread(container).messages, hasLength(20));
      },
    );

    test('a failure on page three keeps pages one and two beside an append '
        'error', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      pageCall().thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m1')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      pageCall(cursor: 'c2').thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m2')],
          hasMore: true,
          nextCursor: 'c3',
        ),
      );
      pageCall(
        cursor: 'c3',
      ).thenAnswer((_) async => throw const NetworkException());

      final container = containerWith();
      await open(container);

      final t = thread(container);
      expect(container.read(provider).hasError, isFalse);
      expect(messageIds(container), ['m1', 'm2']);
      expect(t.hasMore, isTrue);
      expect(t.nextCursor, 'c3', reason: 'the failed page is retried');
      expect(t.appendError, isA<NetworkException>());
    });

    test(
      'Load more after that failure continues from the failed cursor',
      () async {
        ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
        pageCall().thenAnswer(
          (_) async => messagesPage(
            [supportMessage('m1')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        pageCall(
          cursor: 'c2',
        ).thenAnswer((_) async => throw const OfflineException());
        final container = containerWith();
        final n = await open(container);
        expect(thread(container).appendError, isA<OfflineException>());

        pageCall(
          cursor: 'c2',
        ).thenAnswer((_) async => messagesPage([supportMessage('m2')]));
        await n.loadMore();

        expect(messageIds(container), ['m1', 'm2']);
        expect(thread(container).appendError, isNull);
        expect(thread(container).hasMore, isFalse);
      },
    );

    test('a rejected cursor (400 naming `cursor`) in the walk restarts from '
        'page one', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      var pageOneCalls = 0;
      pageCall().thenAnswer((_) async {
        pageOneCalls++;
        return pageOneCalls == 1
            ? messagesPage(
                [supportMessage('stale')],
                hasMore: true,
                nextCursor: 'c2',
              )
            : messagesPage([supportMessage('fresh')]);
      });
      pageCall(cursor: 'c2').thenAnswer(
        (_) async => throw const ValidationException(
          errors: {
            'cursor': ['malformed'],
          },
        ),
      );

      final container = containerWith();
      await open(container);

      final t = thread(container);
      expect(messageIds(container), ['fresh'], reason: 'page one, again');
      expect(t.appendError, isNull, reason: 'recovered, not reported');
      expect(t.hasMore, isFalse);
      expect(t.nextCursor, isNull);
      expect(container.read(provider).hasError, isFalse);
      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c2'),
      ).called(1);
      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: null),
      ).called(2);
    });

    test('the walk restarts ONCE: a second rejection is parked, not looped '
        'on', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      pageCall().thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m1')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      pageCall(cursor: 'c2').thenAnswer(
        (_) async => throw const ValidationException(
          errors: {
            'cursor': ['malformed'],
          },
        ),
      );

      final container = containerWith();
      await open(container);

      final t = thread(container);
      expect(messageIds(container), ['m1']);
      expect(t.appendError, isA<ValidationException>());
      expect(t.nextCursor, 'c2');
      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c2'),
      ).called(2);
      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: null),
      ).called(2);
    });

    test('a validation failure on another field in the walk is parked, not '
        'restarted', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      pageCall().thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m1')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      pageCall(cursor: 'c2').thenAnswer(
        (_) async => throw const ValidationException(
          errors: {
            'other': ['bad'],
          },
        ),
      );

      final container = containerWith();
      await open(container);

      expect(thread(container).appendError, isA<ValidationException>());
      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: null),
      ).called(1);
    });

    test('a walk the screen outlived asks for nothing more', () async {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      final gate = Completer<CursorPage<SupportTicketMessage>>();
      pageCall().thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m1')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      pageCall(cursor: 'c2').thenAnswer((_) => gate.future);
      pageCall(
        cursor: 'c3',
      ).thenAnswer((_) async => messagesPage([supportMessage('late')]));

      final container = containerWith();
      final subscription = container.listen(provider, (_, _) {});
      // Nobody awaits the build once its screen is gone; keep any outcome of it
      // from reaching the zone as unhandled.
      container.read(provider.future).then<void>((_) {}, onError: (_) {});
      await pumpEventQueue();
      subscription.close();
      await pumpEventQueue();
      expect(container.exists(provider), isFalse);
      gate.complete(
        messagesPage([supportMessage('m2')], hasMore: true, nextCursor: 'c3'),
      );
      await pumpEventQueue();

      verifyNever(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c3'),
      );
    });
  });

  group('loadMore', () {
    late SupportThreadNotifier notifier;

    /// The first walk follows every cursor on its own, so the only threads that
    /// reach `loadMore` with pages left are one the 10-page cap stopped and one
    /// a failure stopped. This is the first: ten one-message pages, `m1` to
    /// `m10`, the server still saying there is more behind cursor `c10`.
    void stubCappedThread() {
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      for (var i = 1; i <= 10; i++) {
        pageCall(cursor: i == 1 ? null : 'c${i - 1}').thenAnswer(
          (_) async => messagesPage(
            [supportMessage('m$i')],
            hasMore: true,
            nextCursor: 'c$i',
          ),
        );
      }
    }

    final capped = [for (var i = 1; i <= 10; i++) 'm$i'];

    Future<ProviderContainer> cappedThread() async {
      stubCappedThread();
      final container = containerWith();
      notifier = await open(container);
      expect(thread(container).nextCursor, 'c10');
      clearInteractions(repo);
      return container;
    }

    test(
      "appends the page and carries the server's hasMore and cursor",
      () async {
        final container = await cappedThread();
        pageCall(cursor: 'c10').thenAnswer(
          (_) async => messagesPage(
            [supportMessage('m11')],
            hasMore: true,
            nextCursor: 'c11',
          ),
        );

        await notifier.loadMore();

        final t = thread(container);
        expect(messageIds(container), [...capped, 'm11']);
        expect(t.hasMore, isTrue);
        expect(t.nextCursor, 'c11');
        expect(t.isLoadingMore, isFalse);
      },
    );

    test('the last page clears hasMore and the cursor', () async {
      final container = await cappedThread();
      pageCall(
        cursor: 'c10',
      ).thenAnswer((_) async => messagesPage([supportMessage('m11')]));

      await notifier.loadMore();

      expect(thread(container).hasMore, isFalse);
      expect(thread(container).nextCursor, isNull);
    });

    test('a message the next page repeats is not shown twice', () async {
      final container = await cappedThread();
      pageCall(cursor: 'c10').thenAnswer(
        (_) async =>
            messagesPage([supportMessage('m10'), supportMessage('m11')]),
      );

      await notifier.loadMore();

      expect(messageIds(container), [...capped, 'm11']);
    });

    test('a rejected cursor (400 naming `cursor`) restarts the thread from '
        'page one instead of parking an error', () async {
      final container = await cappedThread();
      pageCall(cursor: 'c10').thenAnswer(
        (_) async => throw const ValidationException(
          errors: {
            'cursor': ['malformed'],
          },
        ),
      );
      stubSimpleThread(messages: [supportMessage('fresh')]);

      await notifier.loadMore();

      final t = thread(container);
      expect(messageIds(container), [
        'fresh',
      ], reason: 'the thread starts over');
      expect(t.appendError, isNull, reason: 'not an error the student sees');
      expect(t.hasMore, isFalse);
      expect(t.nextCursor, isNull);
      expect(t.isLoadingMore, isFalse);
      expect(container.read(provider).hasError, isFalse);
      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c10'),
      ).called(1);
      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: null),
      ).called(1);
    });

    test('a validation failure on another field is still parked', () async {
      final container = await cappedThread();
      const error = ValidationException(
        errors: {
          'other': ['bad'],
        },
      );
      pageCall(cursor: 'c10').thenAnswer((_) async => throw error);

      await notifier.loadMore();

      expect(thread(container).appendError, same(error));
      expect(thread(container).messages, hasLength(10));
      verifyNever(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: null),
      );
    });

    test('it is a no-op once the thread is exhausted', () async {
      stubSimpleThread();
      final container = containerWith();
      final n = await open(container);
      clearInteractions(repo);

      await n.loadMore();

      verifyNever(
        () => repo.listMySupportTicketMessages(
          any(),
          cursor: any(named: 'cursor'),
        ),
      );
      expect(thread(container).messages, hasLength(1));
    });

    test('two calls in the same tick make ONE request', () async {
      final container = await cappedThread();
      final gate = Completer<CursorPage<SupportTicketMessage>>();
      pageCall(cursor: 'c10').thenAnswer((_) => gate.future);

      final first = notifier.loadMore();
      final second = notifier.loadMore();
      expect(thread(container).isLoadingMore, isTrue);
      gate.complete(messagesPage([supportMessage('m11')]));
      await Future.wait([first, second]);

      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c10'),
      ).called(1);
      expect(messageIds(container), [...capped, 'm11']);
    });

    test('a failed append keeps the messages and parks the error', () async {
      final container = await cappedThread();
      pageCall(
        cursor: 'c10',
      ).thenAnswer((_) async => throw const NetworkException());

      await notifier.loadMore();

      final t = thread(container);
      expect(t.messages, hasLength(10));
      expect(t.hasMore, isTrue);
      expect(t.nextCursor, 'c10');
      expect(t.isLoadingMore, isFalse);
      expect(t.appendError, isA<NetworkException>());
      expect(container.read(provider).hasError, isFalse);
    });

    test('a failed append is NOT retried on its own', () async {
      final container = await cappedThread();
      pageCall(
        cursor: 'c10',
      ).thenAnswer((_) async => throw const OfflineException());

      await notifier.loadMore();
      await pumpEventQueue();

      verify(
        () => repo.listMySupportTicketMessages(ticketIdA, cursor: 'c10'),
      ).called(1);
      expect(thread(container).appendError, isA<OfflineException>());
    });

    test(
      'a page that lands after the screen closed is dropped quietly',
      () async {
        stubCappedThread();
        final container = containerWith();
        final subscription = container.listen(provider, (_, _) {});
        await container.read(provider.future);
        final n = container.read(provider.notifier);
        final gate = Completer<CursorPage<SupportTicketMessage>>();
        pageCall(cursor: 'c10').thenAnswer((_) => gate.future);

        final append = n.loadMore();
        subscription.close();
        await pumpEventQueue();
        expect(container.exists(provider), isFalse);
        gate.complete(messagesPage([supportMessage('m11')]));

        // Writing `state` on a disposed notifier throws; the guard prevents it.
        await append;
      },
    );

    test(
      'a failure that lands after the screen closed is dropped quietly',
      () async {
        stubCappedThread();
        final container = containerWith();
        final subscription = container.listen(provider, (_, _) {});
        await container.read(provider.future);
        final n = container.read(provider.notifier);
        final gate = Completer<CursorPage<SupportTicketMessage>>();
        pageCall(cursor: 'c10').thenAnswer((_) => gate.future);

        final append = n.loadMore();
        subscription.close();
        await pumpEventQueue();
        gate.completeError(const NetworkException());

        await append;
      },
    );

    test('a refresh that lands mid-append discards the stale page', () async {
      final container = await cappedThread();
      final gate = Completer<CursorPage<SupportTicketMessage>>();
      pageCall(cursor: 'c10').thenAnswer((_) => gate.future);

      final append = notifier.loadMore();
      stubSimpleThread(messages: [supportMessage('fresh')]);
      await notifier.refresh();
      gate.complete(messagesPage([supportMessage('stale')]));
      await append;

      expect(messageIds(container), ['fresh']);
      expect(thread(container).hasMore, isFalse);
    });

    test(
      'after the provider is invalidated and rebuilt, paging still works',
      () async {
        // `ref.onDispose` also fires on invalidation, and the same notifier
        // instance is reused for the rebuild. A flag that stayed `true` would
        // make every later page vanish without an error.
        final container = await cappedThread();
        container.invalidate(provider);
        await container.read(provider.future);
        pageCall(
          cursor: 'c10',
        ).thenAnswer((_) async => messagesPage([supportMessage('m11')]));

        await container.read(provider.notifier).loadMore();

        expect(messageIds(container), [...capped, 'm11']);
      },
    );
  });

  group('refresh', () {
    test('re-runs from the ticket and page one and recovers', () async {
      ticketCall().thenAnswer((_) async => throw const NetworkException());
      pageCall().thenAnswer((_) async => messagesPage(const []));
      final container = containerWith();
      container.listen(provider, (_, _) {});
      await expectLater(
        container.read(provider.future),
        throwsA(isA<NetworkException>()),
      );

      stubSimpleThread(messages: [supportMessage('m1')]);
      await container.read(provider.notifier).refresh();

      expect(messageIds(container), ['m1']);
    });

    test(
      'an older refresh that lands last does not replace the newer one',
      () async {
        stubSimpleThread(messages: [supportMessage('m1')]);
        final container = containerWith();
        final n = await open(container);
        final gate = Completer<CursorPage<SupportTicketMessage>>();
        pageCall().thenAnswer((_) => gate.future);
        final older = n.refresh();
        stubSimpleThread(messages: [supportMessage('fresh')]);
        await n.refresh();
        gate.complete(messagesPage([supportMessage('old')]));
        await older;

        expect(messageIds(container), ['fresh']);
      },
    );
  });

  group('sendReply - success', () {
    test('appends the returned message when every page is loaded', () async {
      stubSimpleThread(messages: [supportMessage('m1')]);
      postCall(
        'hello',
      ).thenAnswer((_) async => supportMessage('m2', body: 'hello'));
      final container = containerWith();
      final n = await open(container);

      final outcome = await n.sendReply('hello');

      expect(outcome, isA<SendReplySent>());
      expect(messageIds(container), ['m1', 'm2']);
      expect(thread(container).messages.last.body, 'hello');
      expect(thread(container).isSending, isFalse);
      // Appended in place: no re-read of the thread.
      verify(() => repo.getMySupportTicket(ticketIdA)).called(1);
      verifyAnyPage().called(1);
    });

    test(
      'a reply a page already delivered mid-send is not shown twice',
      () async {
        // Page one says there is more, and the walk's next page failed: the
        // thread is stopped at `m1` with a cursor.
        ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));
        pageCall().thenAnswer(
          (_) async => messagesPage(
            [supportMessage('m1')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        pageCall(
          cursor: 'c2',
        ).thenAnswer((_) async => throw const OfflineException());
        final gate = Completer<SupportTicketMessage>();
        postCall().thenAnswer((_) => gate.future);
        final container = containerWith();
        final n = await open(container);

        final send = n.sendReply('hello');
        // While the send is in flight the next page lands - and the server has
        // already written the reply, so it is in that page.
        pageCall(cursor: 'c2').thenAnswer(
          (_) async => messagesPage([supportMessage('m2', body: 'hello')]),
        );
        await n.loadMore();
        expect(thread(container).hasMore, isFalse);
        gate.complete(supportMessage('m2', body: 'hello'));
        final outcome = await send;

        expect(outcome, isA<SendReplySent>());
        expect(messageIds(container), ['m1', 'm2']);
        expect(thread(container).isSending, isFalse);
      },
    );

    test('sends the TRIMMED text', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => supportMessage('m2'));
      final container = containerWith();
      final n = await open(container);

      await n.sendReply('  hello \n');

      verify(
        () => repo.postMySupportTicketMessage(ticketIdA, 'hello'),
      ).called(1);
    });

    test('when pages are still unloaded the thread is REFRESHED instead of '
        'appended to', () async {
      stubSimpleThread(
        messages: [supportMessage('m1')],
        hasMore: true,
        nextCursor: null,
      );
      postCall().thenAnswer((_) async => supportMessage('m-new'));
      final container = containerWith();
      final n = await open(container);
      // After the send the server's thread holds the new reply.
      stubSimpleThread(
        messages: [supportMessage('m1'), supportMessage('m-new')],
      );

      final outcome = await n.sendReply('hello');

      expect(outcome, isA<SendReplySent>());
      // Never inserted after a gap: the thread came back from the server.
      verify(() => repo.getMySupportTicket(ticketIdA)).called(2);
      expect(messageIds(container), ['m1', 'm-new']);
      expect(thread(container).isSending, isFalse);
    });

    test('isSending is true while the reply is in flight', () async {
      stubSimpleThread();
      final gate = Completer<SupportTicketMessage>();
      postCall().thenAnswer((_) => gate.future);
      final container = containerWith();
      final n = await open(container);

      final send = n.sendReply('hello');
      expect(thread(container).isSending, isTrue);
      gate.complete(supportMessage('m2'));
      await send;

      expect(thread(container).isSending, isFalse);
    });

    test(
      'a double send while one is in flight is ignored: ONE request',
      () async {
        stubSimpleThread();
        final gate = Completer<SupportTicketMessage>();
        postCall().thenAnswer((_) => gate.future);
        final container = containerWith();
        final n = await open(container);

        final first = n.sendReply('hello');
        final second = await n.sendReply('hello again');
        gate.complete(supportMessage('m2'));
        final firstOutcome = await first;

        expect(second, isA<SendReplyIgnored>());
        expect(firstOutcome, isA<SendReplySent>());
        verify(
          () => repo.postMySupportTicketMessage(ticketIdA, any()),
        ).called(1);
        expect(messageIds(container), ['m1', 'm2']);
      },
    );

    test('a trimmed-empty text is ignored: no request', () async {
      stubSimpleThread();
      final container = containerWith();
      final n = await open(container);

      expect(await n.sendReply(''), isA<SendReplyIgnored>());
      expect(await n.sendReply('   \n\t '), isA<SendReplyIgnored>());

      verifyNever(() => repo.postMySupportTicketMessage(any(), any()));
    });

    test('after a send the student can send again', () async {
      stubSimpleThread();
      var n = 1;
      postCall().thenAnswer((_) async => supportMessage('m${++n}'));
      final container = containerWith();
      final notifier = await open(container);

      await notifier.sendReply('one');
      await notifier.sendReply('two');

      expect(messageIds(container), ['m1', 'm2', 'm3']);
    });

    test('the ticket list is invalidated: a reply moves its ticket to the '
        'top', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => supportMessage('m2'));
      when(
        () => repo.listMySupportTickets(cursor: null),
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdA)]));
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await container.read(supportTicketsProvider.future);
      final n = await open(container);

      await n.sendReply('hello');
      await container.read(supportTicketsProvider.future);

      verify(() => repo.listMySupportTickets(cursor: null)).called(2);
    });
  });

  group('sendReply - 409 ticket_closed', () {
    const closedError = ApiException(status: 409, code: 'ticket_closed');

    test('re-reads the ticket, reads closed, and returns Closed', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => throw closedError);
      final container = containerWith();
      final n = await open(container);
      expect(thread(container).isClosed, isFalse);
      ticketCall().thenAnswer((_) async => closedTicket(ticketIdA));

      final outcome = await n.sendReply('hello');

      expect(outcome, isA<SendReplyClosed>());
      expect(thread(container).isClosed, isTrue);
      expect(
        thread(container).ticket.closedAt,
        DateTime.utc(2026, 10, 9, 14),
        reason: 'the server\'s ticket, not a client guess',
      );
      verify(() => repo.getMySupportTicket(ticketIdA)).called(2);
      expect(messageIds(container), ['m1'], reason: 'nothing was added');
      expect(thread(container).isSending, isFalse);
    });

    test('the 409 is the authority when the re-read fails', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => throw closedError);
      final container = containerWith();
      final n = await open(container);
      ticketCall().thenAnswer((_) async => throw const OfflineException());

      final outcome = await n.sendReply('hello');

      expect(outcome, isA<SendReplyClosed>());
      expect(thread(container).isClosed, isTrue);
      expect(
        thread(container).ticket.closedAt,
        isNull,
        reason: 'a closing time is never invented',
      );
      expect(container.read(provider).hasError, isFalse);
    });

    test('the 409 is the authority when the re-read still says open', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => throw closedError);
      final container = containerWith();
      final n = await open(container);
      // A replica that has not caught up yet.
      ticketCall().thenAnswer((_) async => ticketDetail(ticketIdA));

      final outcome = await n.sendReply('hello');

      expect(outcome, isA<SendReplyClosed>());
      expect(thread(container).isClosed, isTrue);
    });

    test('the ticket list is invalidated (its row now reads closed)', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => throw closedError);
      when(
        () => repo.listMySupportTickets(cursor: null),
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdA)]));
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await container.read(supportTicketsProvider.future);
      final n = await open(container);
      ticketCall().thenAnswer((_) async => closedTicket(ticketIdA));

      await n.sendReply('hello');
      await container.read(supportTicketsProvider.future);

      verify(() => repo.listMySupportTickets(cursor: null)).called(2);
    });

    test('a closed thread refuses further sends only at the server', () async {
      // The notifier does not pre-judge: `isClosed` is for the screen to swap
      // the composer. A stale send would simply 409 again and re-read.
      stubSimpleThread(ticket: closedTicket(ticketIdA));
      postCall().thenAnswer((_) async => throw closedError);
      final container = containerWith();
      final n = await open(container);

      final outcome = await n.sendReply('hello');

      expect(outcome, isA<SendReplyClosed>());
      expect(thread(container).isClosed, isTrue);
    });
  });

  group('sendReply - other failures', () {
    for (final error in <Object>[
      const OfflineException(),
      const NetworkException(detail: 'timeout'),
      const RateLimitedException(retryAfter: Duration(seconds: 120)),
      const ApiException(status: 403, code: 'account_pending_deletion'),
      const ValidationException(
        errors: {
          'body': ['too long'],
        },
      ),
      const ApiException(status: 404, code: 'not_found'),
      const ApiException(status: 500, code: 'internal_error'),
      const UnknownException(),
    ]) {
      test(
        '${error.runtimeType} -> Failed(error), messages unchanged',
        () async {
          stubSimpleThread();
          postCall().thenAnswer((_) async => throw error);
          final container = containerWith();
          final n = await open(container);

          final outcome = await n.sendReply('hello');

          expect(outcome, isA<SendReplyFailed>());
          expect((outcome as SendReplyFailed).error, same(error));
          expect(messageIds(container), ['m1']);
          expect(thread(container).isSending, isFalse);
          expect(thread(container).isClosed, isFalse);
          expect(container.read(provider).hasError, isFalse);
          // Nothing to re-read, nothing to refresh.
          verify(() => repo.getMySupportTicket(ticketIdA)).called(1);
        },
      );
    }

    test('the ticket list is NOT invalidated by a failed send', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => throw const OfflineException());
      when(
        () => repo.listMySupportTickets(cursor: null),
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdA)]));
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await container.read(supportTicketsProvider.future);
      final n = await open(container);

      await n.sendReply('hello');
      await pumpEventQueue();

      verify(() => repo.listMySupportTickets(cursor: null)).called(1);
    });

    test('after a failure the student can send again', () async {
      stubSimpleThread();
      postCall().thenAnswer((_) async => throw const OfflineException());
      final container = containerWith();
      final n = await open(container);
      expect(await n.sendReply('hello'), isA<SendReplyFailed>());

      postCall().thenAnswer((_) async => supportMessage('m2'));
      final outcome = await n.sendReply('hello');

      expect(outcome, isA<SendReplySent>());
      expect(messageIds(container), ['m1', 'm2']);
    });
  });

  group('sendReply - epoch and dispose guards', () {
    test('a reply that lands after the screen closed writes no state but '
        'still refreshes the list', () async {
      stubSimpleThread();
      final gate = Completer<SupportTicketMessage>();
      postCall().thenAnswer((_) => gate.future);
      when(
        () => repo.listMySupportTickets(cursor: null),
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdA)]));
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await container.read(supportTicketsProvider.future);
      final subscription = container.listen(provider, (_, _) {});
      await container.read(provider.future);
      final n = container.read(provider.notifier);

      final send = n.sendReply('hello');
      subscription.close();
      await pumpEventQueue();
      expect(container.exists(provider), isFalse);
      gate.complete(supportMessage('m2'));
      final outcome = await send;

      // The reply WAS written, so this is Sent - and the list, which is still
      // on screen behind the thread, learns that its order changed.
      expect(outcome, isA<SendReplySent>());
      await container.read(supportTicketsProvider.future);
      verify(() => repo.listMySupportTickets(cursor: null)).called(2);
    });

    test('a failure that lands after the screen closed is returned, not '
        'thrown', () async {
      stubSimpleThread();
      final gate = Completer<SupportTicketMessage>();
      postCall().thenAnswer((_) => gate.future);
      final container = containerWith();
      final subscription = container.listen(provider, (_, _) {});
      await container.read(provider.future);
      final n = container.read(provider.notifier);

      final send = n.sendReply('hello');
      subscription.close();
      await pumpEventQueue();
      gate.completeError(const OfflineException());

      expect(await send, isA<SendReplyFailed>());
    });

    test(
      'a 409 that lands after the screen closed is Closed, not thrown',
      () async {
        stubSimpleThread();
        final gate = Completer<SupportTicketMessage>();
        postCall().thenAnswer((_) => gate.future);
        final container = containerWith();
        final subscription = container.listen(provider, (_, _) {});
        await container.read(provider.future);
        final n = container.read(provider.notifier);

        final send = n.sendReply('hello');
        subscription.close();
        await pumpEventQueue();
        gate.completeError(
          const ApiException(status: 409, code: 'ticket_closed'),
        );

        expect(await send, isA<SendReplyClosed>());
      },
    );

    test('a refresh that lands mid-send is followed by one more, so the reply '
        'is not missing', () async {
      stubSimpleThread();
      final gate = Completer<SupportTicketMessage>();
      postCall().thenAnswer((_) => gate.future);
      final container = containerWith();
      final n = await open(container);

      final send = n.sendReply('hello');
      // A Retry elsewhere rebuilds the thread from a read that PRECEDED the
      // write.
      await n.refresh();
      stubSimpleThread(messages: [supportMessage('m1'), supportMessage('m2')]);
      gate.complete(supportMessage('m2'));
      final outcome = await send;

      expect(outcome, isA<SendReplySent>());
      expect(messageIds(container), ['m1', 'm2']);
      expect(thread(container).isSending, isFalse);
    });

    test('a failure that lands after a refresh mid-send ends the send: '
        'isSending is cleared on the rebuilt state', () async {
      stubSimpleThread();
      final gate = Completer<SupportTicketMessage>();
      postCall().thenAnswer((_) => gate.future);
      final container = containerWith();
      final n = await open(container);

      final send = n.sendReply('hello');
      await n.refresh();
      // The rebuilt thread was built while the send was in flight.
      expect(thread(container).isSending, isTrue);
      gate.completeError(const OfflineException());
      final outcome = await send;

      expect(outcome, isA<SendReplyFailed>());
      expect(thread(container).isSending, isFalse);
      expect(messageIds(container), ['m1']);

      // The composer is usable again.
      postCall().thenAnswer((_) async => supportMessage('m2'));
      expect(await n.sendReply('again'), isA<SendReplySent>());
    });

    for (final reRead in ['closes', 'fails']) {
      test('a 409 that lands after a refresh mid-send closes the CURRENT '
          'state and ends the send (the re-read $reRead)', () async {
        stubSimpleThread();
        final gate = Completer<SupportTicketMessage>();
        postCall().thenAnswer((_) => gate.future);
        final container = containerWith();
        final n = await open(container);

        final send = n.sendReply('hello');
        await n.refresh();
        expect(thread(container).isSending, isTrue);
        expect(thread(container).isClosed, isFalse);
        if (reRead == 'closes') {
          ticketCall().thenAnswer((_) async => closedTicket(ticketIdA));
        } else {
          ticketCall().thenAnswer((_) async => throw const OfflineException());
        }
        gate.completeError(
          const ApiException(status: 409, code: 'ticket_closed'),
        );
        final outcome = await send;

        expect(outcome, isA<SendReplyClosed>());
        expect(thread(container).isClosed, isTrue);
        expect(thread(container).isSending, isFalse);
        expect(messageIds(container), ['m1'], reason: 'nothing was added');
      });
    }

    test(
      'a second send during a refresh-rebuilt state is still ignored',
      () async {
        stubSimpleThread();
        final gate = Completer<SupportTicketMessage>();
        postCall().thenAnswer((_) => gate.future);
        final container = containerWith();
        final n = await open(container);

        final first = n.sendReply('hello');
        await n.refresh();
        final second = await n.sendReply('again');
        gate.complete(supportMessage('m2'));
        await first;

        expect(second, isA<SendReplyIgnored>());
        verify(
          () => repo.postMySupportTicketMessage(ticketIdA, any()),
        ).called(1);
      },
    );
  });
}
