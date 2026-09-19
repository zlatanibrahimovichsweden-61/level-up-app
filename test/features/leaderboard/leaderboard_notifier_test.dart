import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/notifier/leaderboard_notifier.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'leaderboard_fixtures.dart';

class _MockRepo extends Mock implements LeaderboardRepository {}

void main() {
  late _MockRepo repo;

  setUpAll(() => registerFallbackValue(LeaderboardScope.system));

  setUp(() => repo = _MockRepo());

  ProviderContainer containerWith() {
    final container = ProviderContainer(
      overrides: [leaderboardRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<LeaderboardResults> load(ProviderContainer container) =>
      container.read(leaderboardProvider(LeaderboardScope.system).future);

  group('short pages', () {
    test(
      'an EMPTY page with hasMore:true is not the end of the board',
      () async {
        // The contract bounds the work ONE request does, so page 1 may carry no
        // rows at all while `hasMore` is true. Stopping there is THE defect the
        // 3.7.0-m1 clarification exists to prevent — and it is invisible on a
        // small test board, which is why this test hand-builds the case.
        var call = 0;
        when(
          () => repo.getLeaderboard(
            scope: any(named: 'scope'),
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async {
          call++;
          return call == 1 ? shortPage() : boardPage(ranks: const [1, 2, 3]);
        });

        final results = await load(containerWith());

        expect(results.items, hasLength(3));
        expect(
          results.isEmpty,
          isFalse,
          reason: 'a short first page must not render as an empty board',
        );
        verify(
          () => repo.getLeaderboard(
            scope: any(named: 'scope'),
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          ),
        ).called(2);
      },
    );

    test('the walk gives up rather than looping on a faulty server', () async {
      // Ten empty-but-hasMore pages in a row is a server fault, not a board.
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => shortPage());

      final results = await load(containerWith());

      expect(results.items, isEmpty);
      // Still not "empty" — the server never said the board had ended, and
      // claiming it did would be inventing an answer the server withheld.
      expect(results.hasMore, isTrue);
      expect(results.isEmpty, isFalse);
    });

    test('no rows AND hasMore:false is the genuine empty board', () async {
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => boardPage(ranks: const []));

      final results = await load(containerWith());

      expect(results.isEmpty, isTrue);
    });
  });

  group('the caller\'s own row', () {
    test('is exposed when the server marked a row isMe', () async {
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => boardPage(ranks: const [1, 2, 3], meRank: 2));

      final results = await load(containerWith());

      expect(results.me?.rank, 2);
    });

    test('is simply absent below the display bound — not an error', () async {
      // A student ranked below the published 200-row bound appears on NO page.
      // `me` is null and the board is still perfectly valid; a client that
      // paged looking for `isMe` would never terminate.
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => boardPage(ranks: const [1, 2, 3]));

      final results = await load(containerWith());

      expect(results.me, isNull);
      expect(results.isEmpty, isFalse);
    });
  });

  group('paging', () {
    test('loadMore appends and carries the server\'s hasMore', () async {
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: null,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => boardPage(
          ranks: const [1, 2],
          hasMore: true,
          nextCursor: 'cursor-2',
        ),
      );
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: 'cursor-2',
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => boardPage(ranks: const [3, 4]));

      final container = containerWith();
      await load(container);
      final notifier = container.read(
        leaderboardProvider(LeaderboardScope.system).notifier,
      );
      await notifier.loadMore();

      final results = container
          .read(leaderboardProvider(LeaderboardScope.system))
          .requireValue;
      expect(results.items.map((e) => e.rank), [1, 2, 3, 4]);
      expect(results.hasMore, isFalse);
    });

    test('an expired cursor restarts at page one instead of erroring', () async {
      // The cursor is server-signed and EXPIRING, so this is the normal cost of
      // leaving the screen open — not something to show the student.
      var page2Calls = 0;
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: null,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async =>
            boardPage(ranks: const [1, 2], hasMore: true, nextCursor: 'stale'),
      );
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: 'stale',
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async {
        page2Calls++;
        throw const ValidationException(
          errors: {
            'cursor': ['expired'],
          },
        );
      });

      final container = containerWith();
      await load(container);
      await container
          .read(leaderboardProvider(LeaderboardScope.system).notifier)
          .loadMore();

      final state = container.read(
        leaderboardProvider(LeaderboardScope.system),
      );
      expect(page2Calls, 1);
      expect(state.hasError, isFalse, reason: 'recovered, not reported');
      expect(state.requireValue.items.map((e) => e.rank), [1, 2]);
      expect(state.requireValue.appendError, isNull);
    });

    test(
      'a NON-cursor validation failure is surfaced, not swallowed',
      () async {
        when(
          () => repo.getLeaderboard(
            scope: any(named: 'scope'),
            cursor: null,
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => boardPage(
            ranks: const [1, 2],
            hasMore: true,
            nextCursor: 'cursor-2',
          ),
        );
        when(
          () => repo.getLeaderboard(
            scope: any(named: 'scope'),
            cursor: 'cursor-2',
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => throw const ValidationException(
            errors: {
              'scope': ['invalid for track'],
            },
          ),
        );

        final container = containerWith();
        await load(container);
        await container
            .read(leaderboardProvider(LeaderboardScope.system).notifier)
            .loadMore();

        final results = container
            .read(leaderboardProvider(LeaderboardScope.system))
            .requireValue;
        expect(results.appendError, isA<ValidationException>());
        // The rows already on screen survive an append failure.
        expect(results.items, hasLength(2));
      },
    );

    test('a failed append keeps the loaded rows on screen', () async {
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: null,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => boardPage(
          ranks: const [1, 2],
          hasMore: true,
          nextCursor: 'cursor-2',
        ),
      );
      when(
        () => repo.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: 'cursor-2',
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw const NetworkException());

      final container = containerWith();
      await load(container);
      await container
          .read(leaderboardProvider(LeaderboardScope.system).notifier)
          .loadMore();

      final results = container
          .read(leaderboardProvider(LeaderboardScope.system))
          .requireValue;
      expect(results.items, hasLength(2));
      expect(results.isLoadingMore, isFalse);
      expect(results.appendError, isA<NetworkException>());
    });
  });

  test('each scope is its own board — a cursor never crosses scopes', () async {
    when(
      () => repo.getLeaderboard(
        scope: LeaderboardScope.system,
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => boardPage(ranks: const [1]));
    when(
      () => repo.getLeaderboard(
        scope: LeaderboardScope.governorate,
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => boardPage(ranks: const [7, 8]));

    final container = containerWith();
    final system = await container.read(
      leaderboardProvider(LeaderboardScope.system).future,
    );
    final governorate = await container.read(
      leaderboardProvider(LeaderboardScope.governorate).future,
    );

    expect(system.items.map((e) => e.rank), [1]);
    expect(governorate.items.map((e) => e.rank), [7, 8]);
  });

  test('the provider does not silently auto-retry a failed board', () async {
    // Riverpod 3 retries a failed build with backoff and stays AsyncLoading
    // while it does, which would park the screen on its skeleton and keep
    // hitting a rate-limited endpoint. Retry here is a user-tapped button.
    when(
      () => repo.getLeaderboard(
        scope: any(named: 'scope'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => throw const RateLimitedException());

    final container = containerWith();
    await expectLater(
      container.read(leaderboardProvider(LeaderboardScope.system).future),
      throwsA(isA<RateLimitedException>()),
    );
    expect(
      container.read(leaderboardProvider(LeaderboardScope.system)).hasError,
      isTrue,
    );
  });
}
