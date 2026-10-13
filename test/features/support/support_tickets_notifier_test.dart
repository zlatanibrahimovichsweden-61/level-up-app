import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/support/models/support_models.dart';
import 'package:level_up_app/features/support/notifier/support_tickets_notifier.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'support_fixtures.dart';

class _MockRepo extends Mock implements SupportRepository {}

/// The ticket-list notifier: paging on `hasMore`, a failed append next to loaded
/// rows, and the epoch / dispose guards.
///
/// The cases that matter most are the ones a one-page list never reaches: an
/// append that fails beside rows already on screen, and a page that lands after
/// the list was refreshed or its screen closed.
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

  /// Stubs `listMySupportTickets` for ONE cursor.
  When<Future<CursorPage<SupportTicketSummary>>> listCall({String? cursor}) =>
      when(() => repo.listMySupportTickets(cursor: cursor));

  VerificationResult verifyList({String? cursor}) =>
      verify(() => repo.listMySupportTickets(cursor: cursor));

  /// Mounts the list the way the screen does (a live listener) and waits for
  /// page one. An autoDispose notifier without a listener may be disposed at any
  /// time, which would make "after dispose" tests vacuous.
  Future<SupportTicketsNotifier> open(ProviderContainer container) async {
    container.listen(supportTicketsProvider, (_, _) {});
    await container.read(supportTicketsProvider.future);
    return container.read(supportTicketsProvider.notifier);
  }

  SupportTicketsResults results(ProviderContainer container) =>
      container.read(supportTicketsProvider).requireValue;

  List<String> ids(ProviderContainer container) =>
      results(container).items.map((t) => t.ticketId).toList();

  group('build - page one', () {
    test('asks for the first page: no cursor', () async {
      listCall().thenAnswer((_) async => ticketsPage([ticketSummary('a')]));

      final container = containerWith();
      await open(container);

      verifyList().called(1);
    });

    test('hasMore and the cursor are the server\'s, verbatim', () async {
      listCall().thenAnswer(
        (_) async =>
            ticketsPage([ticketSummary('a')], hasMore: true, nextCursor: 'c2'),
      );

      final container = containerWith();
      await open(container);

      expect(results(container).hasMore, isTrue);
      expect(results(container).nextCursor, 'c2');
      expect(results(container).isLoadingMore, isFalse);
      expect(results(container).appendError, isNull);
    });

    test('keeps the order the server sent', () async {
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary('b'),
          ticketSummary('a'),
          ticketSummary('c'),
        ]),
      );

      final container = containerWith();
      await open(container);

      expect(ids(container), ['b', 'a', 'c']);
    });

    test('no items and hasMore:false is the empty list', () async {
      listCall().thenAnswer((_) async => ticketsPage(const []));

      final container = containerWith();
      await open(container);

      expect(results(container).isEmpty, isTrue);
    });

    test('no items but hasMore:true is NOT empty', () async {
      // The contract forbids concluding anything from `items.length`.
      listCall().thenAnswer(
        (_) async => ticketsPage(const [], hasMore: true, nextCursor: 'c2'),
      );

      final container = containerWith();
      await open(container);

      expect(results(container).isEmpty, isFalse);
    });

    test('rows are not empty', () async {
      listCall().thenAnswer((_) async => ticketsPage([ticketSummary('a')]));

      final container = containerWith();
      await open(container);

      expect(results(container).isEmpty, isFalse);
    });
  });

  group('paging branches on hasMore, never on the page size', () {
    test('a FULL page with hasMore:false offers no further request', () async {
      listCall().thenAnswer(
        (_) async =>
            ticketsPage([for (var i = 0; i < 20; i++) ticketSummary('t$i')]),
      );

      final container = containerWith();
      final notifier = await open(container);
      clearInteractions(repo);

      await notifier.loadMore();

      verifyNever(
        () => repo.listMySupportTickets(cursor: any(named: 'cursor')),
      );
      expect(results(container).items, hasLength(20));
    });

    test('a ONE-row page with hasMore:true keeps paging', () async {
      listCall().thenAnswer(
        (_) async =>
            ticketsPage([ticketSummary('a')], hasMore: true, nextCursor: 'c2'),
      );
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => ticketsPage([ticketSummary('b')]));

      final container = containerWith();
      final notifier = await open(container);
      await notifier.loadMore();

      expect(ids(container), ['a', 'b']);
    });

    test('hasMore with no cursor cannot be followed - no request', () async {
      listCall().thenAnswer(
        (_) async => ticketsPage([ticketSummary('a')], hasMore: true),
      );

      final container = containerWith();
      final notifier = await open(container);
      clearInteractions(repo);

      await notifier.loadMore();

      verifyNever(
        () => repo.listMySupportTickets(cursor: any(named: 'cursor')),
      );
      expect(results(container).hasMore, isTrue);
      expect(results(container).nextCursor, isNull);
    });
  });

  group('loadMore', () {
    late SupportTicketsNotifier notifier;

    Future<ProviderContainer> twoPages() async {
      listCall().thenAnswer(
        (_) async => ticketsPage(
          [ticketSummary('a'), ticketSummary('b')],
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
          (_) async => ticketsPage(
            [ticketSummary('c')],
            hasMore: true,
            nextCursor: 'c3',
          ),
        );

        await notifier.loadMore();

        final r = results(container);
        expect(ids(container), ['a', 'b', 'c']);
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
      ).thenAnswer((_) async => ticketsPage([ticketSummary('c')]));

      await notifier.loadMore();

      expect(results(container).hasMore, isFalse);
      expect(results(container).nextCursor, isNull);
    });

    test('it is a no-op once the list is exhausted', () async {
      listCall().thenAnswer((_) async => ticketsPage([ticketSummary('a')]));
      final container = containerWith();
      final n = await open(container);
      clearInteractions(repo);

      await n.loadMore();
      await n.loadMore();

      verifyNever(
        () => repo.listMySupportTickets(cursor: any(named: 'cursor')),
      );
    });

    test('isLoadingMore is true while the page is in flight', () async {
      final container = await twoPages();
      final gate = Completer<CursorPage<SupportTicketSummary>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);

      final append = notifier.loadMore();

      expect(results(container).isLoadingMore, isTrue);
      gate.complete(ticketsPage([ticketSummary('c')]));
      await append;
      expect(results(container).isLoadingMore, isFalse);
    });

    test('two calls in the same tick make ONE request', () async {
      final container = await twoPages();
      final gate = Completer<CursorPage<SupportTicketSummary>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);

      final first = notifier.loadMore();
      final second = notifier.loadMore();
      gate.complete(ticketsPage([ticketSummary('c')]));
      await Future.wait([first, second]);

      verifyList(cursor: 'c2').called(1);
      expect(ids(container), ['a', 'b', 'c']);
    });

    test('a ticket the next page repeats is not shown twice', () async {
      final container = await twoPages();
      listCall(cursor: 'c2').thenAnswer(
        (_) async => ticketsPage([ticketSummary('b'), ticketSummary('c')]),
      );

      await notifier.loadMore();

      expect(ids(container), ['a', 'b', 'c']);
    });

    test(
      'a failed append keeps the rows and parks the error beside them',
      () async {
        final container = await twoPages();
        listCall(
          cursor: 'c2',
        ).thenAnswer((_) async => throw const NetworkException());

        await notifier.loadMore();

        final r = results(container);
        expect(r.items, hasLength(2));
        expect(r.hasMore, isTrue);
        expect(r.nextCursor, 'c2', reason: 'the same cursor is retried');
        expect(r.isLoadingMore, isFalse);
        expect(r.appendError, isA<NetworkException>());
        expect(container.read(supportTicketsProvider).hasError, isFalse);
      },
    );

    test('a failed append is NOT retried on its own', () async {
      final container = await twoPages();
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => throw const OfflineException());

      await notifier.loadMore();
      await pumpEventQueue();

      verifyList(cursor: 'c2').called(1);
      expect(results(container).appendError, isA<OfflineException>());
    });

    test('a user-tapped retry re-requests the same cursor and clears the '
        'error', () async {
      final container = await twoPages();
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => throw const NetworkException());
      await notifier.loadMore();

      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => ticketsPage([ticketSummary('c')]));
      await notifier.loadMore();

      final r = results(container);
      expect(ids(container), ['a', 'b', 'c']);
      expect(r.appendError, isNull);
      verifyList(cursor: 'c2').called(2);
    });

    test('a rejected cursor (400 naming `cursor`) restarts from page one '
        'instead of parking an error', () async {
      final container = await twoPages();
      listCall(cursor: 'c2').thenAnswer(
        (_) async => throw const ValidationException(
          errors: {
            'cursor': ['malformed'],
          },
        ),
      );
      listCall().thenAnswer(
        (_) async => ticketsPage([ticketSummary('fresh')], hasMore: false),
      );
      clearInteractions(repo);

      await notifier.loadMore();

      final r = results(container);
      expect(ids(container), ['fresh'], reason: 'the list starts over');
      expect(r.appendError, isNull, reason: 'not an error the student sees');
      expect(r.hasMore, isFalse);
      expect(r.nextCursor, isNull);
      expect(r.isLoadingMore, isFalse);
      expect(container.read(supportTicketsProvider).hasError, isFalse);
      verifyList(cursor: 'c2').called(1);
      verifyList().called(1);
    });

    test('a validation failure on another field is still parked', () async {
      final container = await twoPages();
      const error = ValidationException(
        errors: {
          'other': ['bad'],
        },
      );
      listCall(cursor: 'c2').thenAnswer((_) async => throw error);
      clearInteractions(repo);

      await notifier.loadMore();

      expect(results(container).appendError, same(error));
      expect(ids(container), ['a', 'b']);
      verifyNever(() => repo.listMySupportTickets(cursor: null));
    });

    test('every failure type is kept beside the rows, not thrown', () async {
      for (final error in <Object>[
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const RateLimitedException(retryAfter: Duration(seconds: 30)),
        const UnauthorizedException(code: 'authentication_required'),
        const ValidationException(errors: {}),
        const UnknownException(),
      ]) {
        final container = await twoPages();
        listCall(cursor: 'c2').thenAnswer((_) async => throw error);

        await notifier.loadMore();

        expect(results(container).appendError, same(error));
        expect(results(container).items, hasLength(2));
      }
    });
  });

  group('stale and disposed results never write state', () {
    test(
      'a page that lands after the screen closed is dropped quietly',
      () async {
        listCall().thenAnswer(
          (_) async => ticketsPage(
            [ticketSummary('a')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        final container = containerWith();
        final subscription = container.listen(
          supportTicketsProvider,
          (_, _) {},
        );
        await container.read(supportTicketsProvider.future);
        final n = container.read(supportTicketsProvider.notifier);
        final gate = Completer<CursorPage<SupportTicketSummary>>();
        listCall(cursor: 'c2').thenAnswer((_) => gate.future);

        final append = n.loadMore();
        subscription.close();
        await pumpEventQueue();
        expect(
          container.exists(supportTicketsProvider),
          isFalse,
          reason:
              'the notifier must really be disposed for this test to mean it',
        );
        gate.complete(ticketsPage([ticketSummary('b')]));

        // Writing `state` on a disposed notifier throws; the guard prevents it.
        await append;
      },
    );

    test(
      'a failure that lands after the screen closed is dropped quietly',
      () async {
        listCall().thenAnswer(
          (_) async => ticketsPage(
            [ticketSummary('a')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        final container = containerWith();
        final subscription = container.listen(
          supportTicketsProvider,
          (_, _) {},
        );
        await container.read(supportTicketsProvider.future);
        final n = container.read(supportTicketsProvider.notifier);
        final gate = Completer<CursorPage<SupportTicketSummary>>();
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
        // instance is reused for the rebuild. A flag that stayed `true` would make
        // every later page vanish without an error.
        listCall().thenAnswer(
          (_) async => ticketsPage(
            [ticketSummary('a')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        final container = containerWith();
        await open(container);
        container.invalidate(supportTicketsProvider);
        await container.read(supportTicketsProvider.future);
        listCall(
          cursor: 'c2',
        ).thenAnswer((_) async => ticketsPage([ticketSummary('b')]));

        await container.read(supportTicketsProvider.notifier).loadMore();

        expect(ids(container), ['a', 'b']);
      },
    );

    test('a refresh that lands mid-append discards the stale page', () async {
      listCall().thenAnswer(
        (_) async =>
            ticketsPage([ticketSummary('a')], hasMore: true, nextCursor: 'c2'),
      );
      final container = containerWith();
      final n = await open(container);
      final gate = Completer<CursorPage<SupportTicketSummary>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);

      final append = n.loadMore();
      listCall().thenAnswer((_) async => ticketsPage([ticketSummary('fresh')]));
      await n.refresh();
      gate.complete(ticketsPage([ticketSummary('stale')]));
      await append;

      expect(ids(container), ['fresh']);
      expect(results(container).hasMore, isFalse);
    });

    test('a failed append that a refresh outlived is discarded too', () async {
      listCall().thenAnswer(
        (_) async =>
            ticketsPage([ticketSummary('a')], hasMore: true, nextCursor: 'c2'),
      );
      final container = containerWith();
      final n = await open(container);
      final gate = Completer<CursorPage<SupportTicketSummary>>();
      listCall(cursor: 'c2').thenAnswer((_) => gate.future);

      final append = n.loadMore();
      listCall().thenAnswer((_) async => ticketsPage([ticketSummary('fresh')]));
      await n.refresh();
      gate.completeError(const NetworkException());
      await append;

      expect(ids(container), ['fresh']);
      expect(results(container).appendError, isNull);
    });

    test(
      'an older refresh that lands last does not replace the newer one',
      () async {
        listCall().thenAnswer(
          (_) async => ticketsPage(
            [ticketSummary('a')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        final container = containerWith();
        final n = await open(container);
        final gate = Completer<CursorPage<SupportTicketSummary>>();
        listCall().thenAnswer((_) => gate.future);
        final older = n.refresh();
        listCall().thenAnswer(
          (_) async => ticketsPage([ticketSummary('fresh')]),
        );
        await n.refresh();
        gate.complete(
          ticketsPage([ticketSummary('old')], hasMore: true, nextCursor: 'c9'),
        );
        await older;

        expect(ids(container), ['fresh']);
        expect(results(container).hasMore, isFalse);
      },
    );
  });

  group('error states', () {
    test('a first-page failure is the build error', () async {
      listCall().thenAnswer((_) async => throw const OfflineException());

      final container = containerWith();
      await expectLater(
        container.read(supportTicketsProvider.future),
        throwsA(isA<OfflineException>()),
      );
      expect(container.read(supportTicketsProvider).hasError, isTrue);
    });

    test('a pending-deletion 403 is the build error, untouched', () async {
      const error = ApiException(status: 403, code: 'account_pending_deletion');
      listCall().thenAnswer((_) async => throw error);

      final container = containerWith();
      await expectLater(
        container.read(supportTicketsProvider.future),
        throwsA(same(error)),
      );
    });

    test('refresh re-runs from page one and recovers', () async {
      listCall().thenAnswer((_) async => throw const NetworkException());
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await expectLater(
        container.read(supportTicketsProvider.future),
        throwsA(isA<NetworkException>()),
      );

      listCall().thenAnswer((_) async => ticketsPage([ticketSummary('a')]));
      await container.read(supportTicketsProvider.notifier).refresh();

      expect(ids(container), ['a']);
    });

    test('refresh replaces the rows and the cursor with the server\'s current '
        'answer', () async {
      listCall().thenAnswer(
        (_) async => ticketsPage(
          [ticketSummary('a'), ticketSummary('b')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      final container = containerWith();
      final n = await open(container);

      listCall().thenAnswer((_) async => ticketsPage([ticketSummary('z')]));
      await n.refresh();

      expect(ids(container), ['z']);
      expect(results(container).hasMore, isFalse);
      expect(results(container).nextCursor, isNull);
    });
  });

  test('the provider does not silently auto-retry a failed list', () async {
    // Riverpod 3 retries a failed build with backoff and stays AsyncLoading
    // while it does; here Retry is a user-tapped button.
    listCall().thenAnswer((_) async => throw const RateLimitedException());

    final container = containerWith();
    container.listen(supportTicketsProvider, (_, _) {});
    await expectLater(
      container.read(supportTicketsProvider.future),
      throwsA(isA<RateLimitedException>()),
    );
    await pumpEventQueue();

    expect(container.read(supportTicketsProvider).hasError, isTrue);
    verifyList().called(1);
  });
}
