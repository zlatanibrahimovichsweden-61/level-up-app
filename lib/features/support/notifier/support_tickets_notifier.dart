import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../models/support_models.dart';
import '../repository/support_repository.dart';

/// One page-accumulated view of `GET /support/tickets`.
@immutable
class SupportTicketsResults {
  const SupportTicketsResults({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.isLoadingMore = false,
    this.appendError,
  });

  /// The caller's tickets, most recently active first - the order the server
  /// serves and the only order shown.
  final List<SupportTicketSummary> items;

  /// Straight from the server's `CursorPage.hasMore` - **never** inferred from
  /// the number of rows that arrived (`openapi.yaml:2667-2670`).
  final bool hasMore;

  /// The opaque cursor for the NEXT page; `null` once exhausted. Followed
  /// as-is, never parsed or constructed.
  final String? nextCursor;

  final bool isLoadingMore;

  /// A failed "load more". Kept HERE rather than flipping the whole
  /// `AsyncValue` to error, so the rows already on screen survive and the list
  /// can offer a retry for just the append.
  final Object? appendError;

  /// The Empty state: no ticket and the server says there are no more pages.
  /// A first page with no rows but `hasMore: true` is NOT empty - the contract
  /// forbids concluding anything from `items.length`.
  bool get isEmpty => items.isEmpty && !hasMore;

  SupportTicketsResults copyWith({
    List<SupportTicketSummary>? items,
    bool? hasMore,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    Object? appendError,
    bool clearAppendError = false,
  }) {
    return SupportTicketsResults(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      appendError: clearAppendError ? null : (appendError ?? this.appendError),
    );
  }
}

/// Cursor pagination over the caller's own support tickets.
///
/// Rules that shape this class, each a bug if dropped:
///
/// 1. **Page on `hasMore`, never on page size.** Pages are 20 and the operation
///    takes no `limit`.
/// 2. **The cursor is opaque.** It is echoed back unchanged and never parsed.
/// 3. **A failed append keeps the rows** and parks its error beside them - bar
///    one case: a malformed cursor restarts from page one (see [loadMore]).
/// 4. **A stale or disposed result never writes state.** The notifier is
///    autoDispose and screen-scoped: leaving the screen disposes it mid-await,
///    and a Retry or an invalidation replaces the build an append started under.
class SupportTicketsNotifier extends AsyncNotifier<SupportTicketsResults> {
  /// True once this notifier has been disposed - see [loadMore] and [refresh].
  bool _disposed = false;

  /// Bumped by every [build]. An append that started under an earlier build
  /// must not write its page onto the list that replaced it.
  int _epoch = 0;

  @override
  Future<SupportTicketsResults> build() async {
    // Reset first: `ref.onDispose` also fires when the provider is invalidated
    // and rebuilt, and this same notifier instance is reused for the rebuild.
    _disposed = false;
    _epoch++;
    // Registered before the first await so a dispose during the initial page
    // load is still recorded.
    ref.onDispose(() => _disposed = true);

    final page = await ref
        .read(supportRepositoryProvider)
        .listMySupportTickets();
    return SupportTicketsResults(
      items: page.items,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  /// Appends the next page. No-op without a cursor, when exhausted, or while an
  /// append is already in flight - and never a silent retry: a failure is kept
  /// beside the rows as [SupportTicketsResults.appendError] and the user
  /// re-triggers it. The one exception is a rejected cursor (`400
  /// validation_failed` naming `cursor`), which the contract answers with
  /// "request page one again": the list is [refresh]ed from the start.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final cursor = current.nextCursor;
    if (cursor == null) return;

    final epoch = _epoch;
    final repository = ref.read(supportRepositoryProvider);
    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearAppendError: true),
    );
    try {
      final page = await repository.listMySupportTickets(cursor: cursor);
      if (_disposed || epoch != _epoch) return;
      final latest = state.value ?? current;
      // A reply can bump a ticket between pages; the server's keyset never
      // serves a row twice, but a defensive guard costs nothing and a repeated
      // `ticketId` would be two rows for one ticket.
      final known = {for (final t in latest.items) t.ticketId};
      state = AsyncData(
        latest.copyWith(
          items: [
            ...latest.items,
            ...page.items.where((t) => !known.contains(t.ticketId)),
          ],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          clearNextCursor: page.nextCursor == null,
          isLoadingMore: false,
        ),
      );
    } on Object catch (error) {
      if (_disposed || epoch != _epoch) return;
      // A malformed `cursor` (`400 validation_failed` naming that field) has a
      // single remedy in the contract - "request page one again"
      // (`openapi.yaml:2728`) - so it is recovered, not reported: Retry would
      // resend the very same cursor. Any OTHER failure is parked as before.
      if (_isCursorRejected(error)) {
        await refresh();
        return;
      }
      // Keep the already-loaded rows visible; the list shows a retry for the
      // failed append rather than throwing the whole list away.
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(isLoadingMore: false, appendError: error),
      );
    }
  }

  /// Re-runs from page one (the user-tapped Retry). Replaces the list and the
  /// cursor with the server's current answer.
  Future<void> refresh() async {
    state = const AsyncLoading();
    // `guard` runs [build] synchronously, so this is that build's epoch. A
    // newer build cancels an older request, which then returns a result that
    // must not replace the newer one.
    final pending = AsyncValue.guard(build);
    final epoch = _epoch;
    final result = await pending;
    if (_disposed || epoch != _epoch) return;
    state = result;
  }

  /// A `400 validation_failed` whose field map names `cursor`.
  static bool _isCursorRejected(Object error) =>
      error is ValidationException && error.fields.contains('cursor');
}

/// autoDispose: the list lives only while its screen is shown, and returning
/// refetches page one. Invalidated by a successful create and by a sent reply
/// (a reply moves its ticket to the top).
final supportTicketsProvider =
    AsyncNotifierProvider.autoDispose<
      SupportTicketsNotifier,
      SupportTicketsResults
    >(
      SupportTicketsNotifier.new,
      // Riverpod 3 retries a failed build automatically with backoff, and while
      // it retries the state stays `AsyncLoading` - so the screen would sit on
      // its spinner instead of showing the error view, and a 403
      // `account_pending_deletion` (which must NOT be retried) would be
      // hammered. Retry is a user-tapped button here.
      retry: _noRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
