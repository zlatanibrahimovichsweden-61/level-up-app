import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../models/notification_models.dart';
import '../repository/notifications_repository.dart';

/// One page-accumulated view of `GET /me/notifications` for a single inbox tab.
@immutable
class InboxResults {
  InboxResults({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.isLoadingMore = false,
    this.appendError,
    this.readIds = const {},
  });

  /// EVERY decoded item, including the ones the app ignores. Screens read
  /// [visibleItems]; this is kept whole so the paging state stays honest about
  /// what the server actually returned.
  final List<NotificationItem> items;

  /// Straight from the server's `CursorPage.hasMore` — **never** inferred from
  /// the number of rows that arrived, and never from how many survive
  /// [visibleItems].
  final bool hasMore;

  /// The opaque cursor for the NEXT page; `null` once exhausted. Followed
  /// as-is, never parsed or constructed.
  final String? nextCursor;

  final bool isLoadingMore;

  /// A failed "load more". Kept HERE rather than flipping the whole
  /// `AsyncValue` to error, so the rows already on screen survive and the list
  /// can offer a retry for just the append.
  final Object? appendError;

  /// Ids of items the student opened this session and the server acknowledged
  /// (`204`) or said are gone (`404`). The `readAt` of the item itself is never
  /// edited — inventing a timestamp would author a time the server did not
  /// report. A reload from page one replaces this with the server's truth.
  final Set<String> readIds;

  /// The items the screen renders: those with a [NotificationContent]. An
  /// unknown kind, an unknown category, a malformed announcement and the three
  /// known-but-unsourced kinds are decoded, counted by the paging, and absent
  /// here — see [notificationContentFor].
  late final List<NotificationItem> visibleItems = List.unmodifiable(
    items.where((item) => item.content != null),
  );

  /// Whether [item] shows the unread mark: the server has no `readAt` for it
  /// AND the student has not just read it here.
  bool isUnread(NotificationItem item) =>
      item.readAt == null && !readIds.contains(item.notificationId);

  /// The Empty state.
  ///
  /// **`visibleItems.isEmpty` alone is NOT empty.** A page can arrive made
  /// entirely of items this app ignores — every student gets an
  /// `enrolment_opened` welcome item it does not render — while `hasMore` is
  /// still `true`, and the next page may be full of announcements. Treating
  /// "nothing renderable yet" as "the inbox is empty" is the leaderboard's
  /// short-page defect in another costume (`openapi.yaml:1165`).
  bool get isEmpty => visibleItems.isEmpty && !hasMore;

  InboxResults copyWith({
    List<NotificationItem>? items,
    bool? hasMore,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    Object? appendError,
    bool clearAppendError = false,
    Set<String>? readIds,
  }) {
    return InboxResults(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      appendError: clearAppendError ? null : (appendError ?? this.appendError),
      readIds: readIds ?? this.readIds,
    );
  }
}

/// Cursor pagination over one tab of the caller's inbox, plus mark-as-read.
///
/// Keyed by a nullable [NotificationCategory]: `null` is **All** and sends no
/// `category`; every other tab sends its own value and keeps its own list,
/// cursor and read marks, so a cursor never crosses tabs.
///
/// Rules that shape this class, each a bug if dropped:
///
/// 1. **Page on `hasMore`, never on page size or on what is visible.** [build]
///    and [loadMore] therefore *keep walking* while the server says there is
///    more but nothing renderable has arrived, so the screen never opens on a
///    blank list with rows behind it.
/// 2. **The cursor is opaque.** It is echoed back unchanged and never parsed.
/// 3. **Read state is the server's, plus what this session just did.** A tap
///    marks a row read only after the server said so — [markRead].
class NotificationsNotifier extends AsyncNotifier<InboxResults> {
  NotificationsNotifier(this.category);

  /// `null` = All.
  final NotificationCategory? category;

  /// True once this notifier has been disposed — see [loadMore] and [refresh].
  bool _disposed = false;

  /// Bumped by every [build]. An append that started under an earlier build
  /// (the user hit Retry, or the provider was invalidated, mid-flight) must not
  /// write its page onto the list that replaced it.
  int _epoch = 0;

  /// Ids with a `markNotificationRead` call in flight. A second tap on the same
  /// row during the await is a no-op, so one tap costs exactly one request.
  final _markingRead = <String>{};

  static const _pageSize = 20;

  /// Safety bound on the walk over pages that hold nothing renderable. Ten
  /// such pages in a row is a server fault, not an inbox; stopping lets the UI
  /// show what it has instead of spinning forever. Same bound as the
  /// leaderboard's short-page walk.
  static const _maxShortPageHops = 10;

  @override
  Future<InboxResults> build() async {
    // Reset first: `ref.onDispose` also fires when the provider is invalidated
    // and rebuilt, and this same notifier instance is reused for the rebuild.
    _disposed = false;
    _epoch++;
    // Registered before the first await so a dispose during the initial page
    // load is still recorded.
    ref.onDispose(() => _disposed = true);

    final walk = await _walk(cursor: null);
    return walk.toResults();
  }

  /// Appends the next page. No-op when exhausted or already appending — and
  /// never a silent retry: a failure is kept beside the rows as
  /// [InboxResults.appendError] and the user re-triggers it.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final cursor = current.nextCursor;
    if (cursor == null) return;

    final epoch = _epoch;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearAppendError: true),
    );
    try {
      final walk = await _walk(cursor: cursor);
      // The notifier is autoDispose and tab-scoped: leaving the screen disposes
      // it mid-await, and the assignment would throw on a dead notifier.
      if (_disposed || epoch != _epoch) return;
      // Re-read: a tap may have marked rows read while the page was in flight,
      // and writing `current` back would silently un-read them.
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(
          items: [...latest.items, ...walk.items],
          hasMore: walk.hasMore,
          nextCursor: walk.nextCursor,
          clearNextCursor: walk.nextCursor == null,
          isLoadingMore: false,
        ),
      );
    } on Object catch (error) {
      // Keep the already-loaded rows visible; the list shows a retry for the
      // failed append rather than throwing the whole inbox away.
      if (_disposed || epoch != _epoch) return;
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(isLoadingMore: false, appendError: error),
      );
    }
  }

  /// Marks [id] read after the student opens that row.
  ///
  /// **Exactly one request per unread row.** A no-op when the row is not in this
  /// list, is already read (server `readAt` or marked earlier), or has a call in
  /// flight.
  ///
  /// The row turns read only when the server says it can: on `204`, or on
  /// `404 not_found` — "unknown, or another account's" (`openapi.yaml:1255-1258`),
  /// i.e. the item is gone or was never theirs, and showing it unread forever
  /// would be a dot nobody can clear. Any OTHER failure (offline, `5xx`, the
  /// deletion grace window) leaves it unread and is **not retried**: the student
  /// can tap again, and nothing here loops. Nothing is surfaced either — marking
  /// read is a courtesy, not something worth interrupting the list for.
  Future<void> markRead(String id) async {
    final current = state.value;
    if (current == null) return;

    final item = current.items
        .where((candidate) => candidate.notificationId == id)
        .firstOrNull;
    if (item == null || !current.isUnread(item)) return;
    if (!_markingRead.add(id)) return;

    var markLocally = false;
    try {
      await ref.read(notificationsRepositoryProvider).markNotificationRead(id);
      markLocally = true;
    } on ApiException catch (error) {
      markLocally = error.status == 404 && error.code == 'not_found';
    } on Object {
      // Offline, unknown, anything else: stays unread, no retry.
    } finally {
      _markingRead.remove(id);
    }

    if (!markLocally || _disposed) return;
    // Re-read: the list may have grown (or been reloaded) during the await.
    final latest = state.value;
    if (latest == null) return;
    state = AsyncData(latest.copyWith(readIds: {...latest.readIds, id}));
  }

  /// Re-runs from page one (the user-tapped Retry). Replaces the list, the
  /// cursor and the local read marks with the server's current answer.
  Future<void> refresh() async {
    state = const AsyncLoading();
    // `guard` runs [build] synchronously, so this is that build's epoch. A
    // newer build cancels an older walk, which then returns a partial result
    // that must not replace the newer one.
    final pending = AsyncValue.guard(build);
    final epoch = _epoch;
    final result = await pending;
    if (_disposed || epoch != _epoch) return;
    state = result;
  }

  /// Fetches pages from [cursor] until one of them holds something renderable
  /// or the server says it is finished, at most [_maxShortPageHops] requests.
  ///
  /// Used by [build] (from page one) and [loadMore] (from the stored cursor):
  /// the "stop" condition looks only at the pages fetched HERE, so an append
  /// that surfaces nothing new keeps walking too.
  ///
  /// A walk belongs to the build it started under: once the notifier is
  /// disposed or rebuilt it asks for nothing more (the cursor may have expired,
  /// and `ref.read` on a dead notifier throws). It then returns what it has,
  /// which every caller discards for the same reason.
  Future<_Walk> _walk({required String? cursor}) async {
    final items = <NotificationItem>[];
    var hasMore = true;
    var next = cursor;
    final epoch = _epoch;

    for (var hop = 0; hop < _maxShortPageHops; hop++) {
      if (_disposed || epoch != _epoch) break;
      final page = await ref
          .read(notificationsRepositoryProvider)
          .listMyNotifications(
            cursor: next,
            limit: _pageSize,
            category: category,
          );
      items.addAll(page.items);
      hasMore = page.hasMore;
      next = page.nextCursor;
      // Done: something to render, or the server says the inbox is finished.
      // A page of ignored items with `hasMore: true` continues the walk.
      if (!hasMore || items.any((item) => item.content != null)) break;
      // `hasMore` without a cursor cannot be followed; asking again would
      // re-fetch page one. Stop and report what the server said.
      if (next == null) break;
    }
    return _Walk(items: items, hasMore: hasMore, nextCursor: next);
  }
}

/// The outcome of one [NotificationsNotifier._walk].
class _Walk {
  const _Walk({
    required this.items,
    required this.hasMore,
    required this.nextCursor,
  });

  final List<NotificationItem> items;
  final bool hasMore;
  final String? nextCursor;

  InboxResults toResults() =>
      InboxResults(items: items, hasMore: hasMore, nextCursor: nextCursor);
}

/// One notifier per tab, so a cursor can never cross tabs. A tab's list lives
/// only while that tab is shown: deselecting its chip unmounts it, the
/// autoDispose notifier goes with it, and returning refetches page one. The
/// key is the tab's category; **`null` is All**.
final notificationsProvider = AsyncNotifierProvider.autoDispose
    .family<NotificationsNotifier, InboxResults, NotificationCategory?>(
      NotificationsNotifier.new,
      // Riverpod 3 retries a failed build automatically with backoff, and while
      // it retries the state stays `AsyncLoading` — so the screen would sit on
      // its skeleton instead of showing the error view, and a 403
      // `account_pending_deletion` (which must NOT be retried) would be
      // hammered. Retry is a user-tapped button here.
      retry: _noRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
