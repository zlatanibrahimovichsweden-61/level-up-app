import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../models/leaderboard_models.dart';
import '../repository/leaderboard_repository.dart';

/// One page-accumulated view of `GET /leaderboard` for a single scope.
@immutable
class LeaderboardResults {
  const LeaderboardResults({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
    this.appendError,
  });

  final List<LeaderboardEntry> items;

  /// Straight from the server's `CursorPage.hasMore` — **never** inferred from
  /// the number of rows that arrived.
  final bool hasMore;

  final bool isLoadingMore;

  /// A failed "load more". Kept HERE rather than flipping the whole
  /// `AsyncValue` to error, so the rows already on screen survive and the list
  /// can offer a retry for just the append.
  final Object? appendError;

  /// The Empty state.
  ///
  /// **`items.isEmpty` alone is NOT empty.** The contract (3.7.0-m1) bounds the
  /// work one request will do, so a page may return fewer rows than asked for —
  /// *including zero* — while `hasMore` is still `true`. Treating a short first
  /// page as "the board is empty" is the specific defect that clarification
  /// exists to prevent, and it would not reproduce on a small test board.
  bool get isEmpty => items.isEmpty && !hasMore;

  /// The caller's own row, when it is genuinely on the board.
  ///
  /// Null is a normal outcome, not a failure: the board renders at most the top
  /// 200, so a student ranked below that appears on no page and `isMe` is true
  /// nowhere. The screen highlights this row when present and shows nothing
  /// extra when absent — it must never synthesise a self-rank row.
  LeaderboardEntry? get me {
    for (final entry in items) {
      if (entry.isMe) return entry;
    }
    return null;
  }

  LeaderboardResults copyWith({
    List<LeaderboardEntry>? items,
    bool? hasMore,
    bool? isLoadingMore,
    Object? appendError,
    bool clearAppendError = false,
  }) {
    return LeaderboardResults(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      appendError: clearAppendError ? null : (appendError ?? this.appendError),
    );
  }
}

/// Cursor pagination over one scope of the leaderboard.
///
/// Three contract rules shape this class, and each of them is a bug if dropped:
///
/// 1. **Page on `hasMore`, never on page size.** A short page — even an empty
///    one — is not the end of the list. [build] therefore *keeps walking* while
///    the server says there is more but has handed back nothing to show, so the
///    screen never opens on a blank list that has more rows behind it.
/// 2. **Never page looking for `isMe`.** The board is bounded at 200 rows, so
///    for a student below that the search never terminates. The self row is
///    read off whatever pages arrive ([LeaderboardResults.me]) and is simply
///    absent otherwise.
/// 3. **The cursor is opaque, expiring and scope-bound.** It is echoed back
///    unchanged and never parsed, stored or reused across scopes. When the
///    server rejects one, the only remedy is to ask for page one again — which
///    [loadMore] does automatically, because an expired cursor is a normal
///    consequence of leaving the screen open, not a user error to report.
class LeaderboardNotifier extends AsyncNotifier<LeaderboardResults> {
  LeaderboardNotifier(this.scope);

  final LeaderboardScope scope;

  /// The cursor for the NEXT page; null once exhausted.
  String? _nextCursor;

  /// True once this notifier has been disposed — see [loadMore] and [refresh].
  bool _disposed = false;

  static const _pageSize = 20;

  /// Safety bound on the short-page walk in [build]. Ten empty-but-`hasMore`
  /// pages in a row is a server fault, not a board; stopping lets the UI show
  /// an empty state instead of spinning forever.
  static const _maxShortPageHops = 10;

  @override
  Future<LeaderboardResults> build() async {
    // Registered before the first await so a dispose during the initial page
    // load is still recorded.
    ref.onDispose(() => _disposed = true);

    final items = <LeaderboardEntry>[];
    var hasMore = true;
    String? cursor;

    for (var hop = 0; hop < _maxShortPageHops; hop++) {
      final page = await ref
          .read(leaderboardRepositoryProvider)
          .getLeaderboard(scope: scope, cursor: cursor, limit: _pageSize);
      items.addAll(page.items);
      hasMore = page.hasMore;
      cursor = page.nextCursor;
      // Stop as soon as there is something to render, or the server says the
      // board is finished. Only a genuinely short page continues the walk.
      if (items.isNotEmpty || !hasMore) break;
    }

    _nextCursor = cursor;
    return LeaderboardResults(items: items, hasMore: hasMore);
  }

  /// Appends the next page. No-op when exhausted or already appending — and
  /// never a silent retry: a failure surfaces as an error the user re-triggers.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final cursor = _nextCursor;
    if (cursor == null) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearAppendError: true),
    );
    try {
      final page = await ref
          .read(leaderboardRepositoryProvider)
          .getLeaderboard(scope: scope, cursor: cursor, limit: _pageSize);
      _nextCursor = page.nextCursor;
      // The notifier is autoDispose and tab-scoped: switching scope or leaving
      // the tab disposes it mid-await, and the assignment would throw on a
      // dead notifier.
      if (_disposed) return;
      state = AsyncData(
        LeaderboardResults(
          // A short page appends fewer rows than asked for. That is legal and
          // needs no special case here — `hasMore` still decides whether the
          // list keeps offering "load more".
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
        ),
      );
    } on ValidationException catch (error) {
      if (_disposed) return;
      // An expired, altered or foreign-scope cursor. The contract's remedy is
      // always the same — request page one again — so this is recovered rather
      // than reported: the student did nothing wrong by leaving the screen
      // open. Any OTHER validation failure is a real error and is surfaced.
      if (error.fields.contains('cursor')) {
        await refresh();
        return;
      }
      state = AsyncData(
        current.copyWith(isLoadingMore: false, appendError: error),
      );
    } on Object catch (error) {
      // Keep the already-loaded rows visible; the list shows a retry for the
      // failed append rather than throwing the whole board away.
      if (_disposed) return;
      state = AsyncData(
        current.copyWith(isLoadingMore: false, appendError: error),
      );
    }
  }

  /// Re-runs from page one (the user-tapped retry, and the expired-cursor
  /// recovery). Drops the stale cursor first — it is scope-bound and cannot be
  /// reused across a reload.
  Future<void> refresh() async {
    _nextCursor = null;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(build);
    if (_disposed) return;
    state = result;
  }
}

/// One notifier per scope, so switching the segmented control keeps each board
/// warm instead of refetching, and so a cursor can never cross scopes.
final leaderboardProvider = AsyncNotifierProvider.autoDispose
    .family<LeaderboardNotifier, LeaderboardResults, LeaderboardScope>(
      LeaderboardNotifier.new,
      // Riverpod 3 retries a failed build automatically with backoff, and while
      // it retries the state stays `AsyncLoading` — so the screen would sit on
      // its skeleton instead of showing the error view, and would keep hitting
      // a rate-limited endpoint. Retry is a user-tapped button here.
      retry: _noRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
