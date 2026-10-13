import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../registration/models/reference_models.dart' show CursorPage;
import '../models/support_models.dart';
import '../repository/support_repository.dart';
import 'support_tickets_notifier.dart';

/// One ticket and its accumulated thread.
@immutable
class SupportThread {
  const SupportThread({
    required this.ticket,
    required this.messages,
    required this.hasMore,
    this.nextCursor,
    this.isLoadingMore = false,
    this.appendError,
    this.isSending = false,
  });

  /// The ticket. Its `details` is the OPENING text and is not in [messages].
  final SupportTicket ticket;

  /// The replies, oldest first - chat order, the order the server serves.
  final List<SupportTicketMessage> messages;

  /// Straight from the server's `CursorPage.hasMore` - never inferred from the
  /// number of rows that arrived. `true` also when the bounded first walk
  /// stopped at its page cap, or stopped on a failure.
  final bool hasMore;

  /// The opaque cursor for the NEXT page; `null` once exhausted.
  final String? nextCursor;

  final bool isLoadingMore;

  /// A failed page after the first: from [SupportThreadNotifier.loadMore], or
  /// from the first walk past page one. Kept beside the messages already
  /// loaded rather than discarding them.
  final Object? appendError;

  /// A reply is in flight. The composer disables itself on this; a second send
  /// is ignored by the notifier too.
  final bool isSending;

  /// True ONLY when the server's status is `closed`; an unknown status never
  /// refuses a reply.
  bool get isClosed => ticket.isClosed;

  SupportThread copyWith({
    SupportTicket? ticket,
    List<SupportTicketMessage>? messages,
    bool? hasMore,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    Object? appendError,
    bool clearAppendError = false,
    bool? isSending,
  }) {
    return SupportThread(
      ticket: ticket ?? this.ticket,
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      appendError: clearAppendError ? null : (appendError ?? this.appendError),
      isSending: isSending ?? this.isSending,
    );
  }
}

/// What [SupportThreadNotifier.sendReply] did. Sealed, so a screen's `switch`
/// is exhaustive and a fifth outcome cannot be added without the compiler
/// pointing at every place that must learn about it.
sealed class SendReplyOutcome {
  const SendReplyOutcome();
}

/// The server accepted the reply (`201`). The thread already shows it (or was
/// refreshed to), the ticket list was invalidated, and the composer may clear.
final class SendReplySent extends SendReplyOutcome {
  const SendReplySent();
}

/// `409 ticket_closed`: the ticket is closed and takes no reply. The thread's
/// ticket now reads closed ([SupportThread.isClosed]); the composer is replaced
/// by the closed bar, and the text the student typed is NOT lost to a failure
/// message - there is nothing to retry.
final class SendReplyClosed extends SendReplyOutcome {
  const SendReplyClosed();
}

/// Any other failure. Nothing was added to the thread; the text stays in the
/// field. Map [error] with `supportActionFailureText`.
final class SendReplyFailed extends SendReplyOutcome {
  const SendReplyFailed(this.error);

  final Object error;
}

/// Nothing was sent: a reply is already in flight, the trimmed text is empty,
/// or the thread is not loaded. **Not a failure** - show nothing.
///
/// This fourth case is an addition to the three the brief names: a double-tap
/// on Send has to return *something*, and `Sent` would clear the field while
/// the first request is still running, `Failed` would flash an error over a
/// reply that is about to succeed.
final class SendReplyIgnored extends SendReplyOutcome {
  const SendReplyIgnored();
}

/// A ticket's thread: the ticket, its replies oldest first, paging, and the
/// student's own reply.
///
/// Keyed by `ticketId` (the only handle the API takes - never the `TK-` label).
///
/// Rules that shape this class, each a bug if dropped:
///
/// 1. **Page on `hasMore`, never on page size.** [build] loads the ticket and
///    the first page TOGETHER, then follows `nextCursor` while the server says
///    there is more, at most [_maxPages] pages in all; beyond that the screen
///    offers Load more ([loadMore]).
/// 2. **The cursor is opaque.** Echoed back unchanged, never parsed.
/// 3. **The server decides what is closed.** Only a `409 ticket_closed` or a
///    ticket whose status is exactly `closed` is closed.
/// 4. **A stale or disposed result never writes state** - the same epoch and
///    disposed guards the notifications inbox uses.
class SupportThreadNotifier extends AsyncNotifier<SupportThread> {
  SupportThreadNotifier(this.ticketId);

  final String ticketId;

  /// True once this notifier has been disposed.
  bool _disposed = false;

  /// Bumped by every [build]. A result that started under an earlier build (a
  /// Retry, an invalidation) must not write onto the thread that replaced it.
  int _epoch = 0;

  /// A reply is in flight. Held on the notifier as well as in the state because
  /// a [refresh] mid-send rebuilds the state, and the second tap must stay
  /// ignored until the first request has answered.
  bool _sending = false;

  /// First-walk bound: the ticket's first page plus at most nine more - 200
  /// replies. A longer thread is a server oddity for a student's help ticket;
  /// stopping lets the UI show what it has behind a Load more footer instead of
  /// spinning.
  static const _maxPages = 10;

  @override
  Future<SupportThread> build() async {
    // Reset first: `ref.onDispose` also fires when the provider is invalidated
    // and rebuilt, and this same notifier instance is reused for the rebuild.
    _disposed = false;
    _epoch++;
    // Registered before the first await so a dispose during the initial load
    // is still recorded.
    ref.onDispose(() => _disposed = true);

    final epoch = _epoch;
    final repository = ref.read(supportRepositoryProvider);

    // Both requests go out together; whichever fails, the ticket's own error is
    // the one reported (a `404 not_found` belongs to the ticket). `ignore` only
    // stops the loser's error reaching the zone as unhandled - awaiting it
    // below still rethrows.
    final ticketRequest = repository.getMySupportTicket(ticketId)..ignore();
    final pageRequest = repository.listMySupportTicketMessages(ticketId)
      ..ignore();
    final ticket = await ticketRequest;
    final first = await pageRequest;

    final messages = [...first.items];
    var hasMore = first.hasMore;
    var next = first.nextCursor;
    Object? stoppedBy;

    // Pages 2..10. A failure here keeps what is already loaded and parks the
    // error as an append error, so Retry (loadMore) continues from the cursor
    // that failed instead of throwing a readable thread away.
    //
    // The one failure that is NOT parked is a rejected cursor (`400
    // validation_failed` naming `cursor`): the contract's remedy is "request
    // page one again" (`openapi.yaml:2787`), and Retry would resend the very
    // same cursor. The walk restarts from page one, once - a second rejection
    // is a server fault and is parked like any other failure, so this cannot
    // loop.
    var fetched = 1;
    var restarted = false;
    while (fetched < _maxPages && hasMore && next != null) {
      if (_disposed || epoch != _epoch) break;
      try {
        final more = await repository.listMySupportTicketMessages(
          ticketId,
          cursor: next,
        );
        if (_disposed || epoch != _epoch) break;
        messages.addAll(more.items);
        hasMore = more.hasMore;
        next = more.nextCursor;
        fetched++;
      } on Object catch (error) {
        if (restarted || !_isCursorRejected(error)) {
          stoppedBy = error;
          break;
        }
        restarted = true;
        try {
          final again = await repository.listMySupportTicketMessages(ticketId);
          if (_disposed || epoch != _epoch) break;
          // Only now that page one is in hand is what was loaded replaced.
          messages
            ..clear()
            ..addAll(again.items);
          hasMore = again.hasMore;
          next = again.nextCursor;
          fetched = 1;
        } on Object catch (restartError) {
          stoppedBy = restartError;
          break;
        }
      }
    }

    return SupportThread(
      ticket: ticket,
      messages: messages,
      hasMore: hasMore,
      nextCursor: next,
      appendError: stoppedBy,
      isSending: _sending,
    );
  }

  /// Appends the next page of replies. No-op without a cursor, when exhausted,
  /// or while an append is already in flight - and never a silent retry: a
  /// failure is kept beside the messages as [SupportThread.appendError]. The one
  /// exception is a rejected cursor (`400 validation_failed` naming `cursor`),
  /// which the contract answers with "request page one again": the thread is
  /// [refresh]ed from the start.
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
      final CursorPage<SupportTicketMessage> page = await repository
          .listMySupportTicketMessages(ticketId, cursor: cursor);
      if (_disposed || epoch != _epoch) return;
      // Re-read: a send may have changed the thread while the page was in
      // flight, and writing `current` back would silently undo it.
      final latest = state.value ?? current;
      final known = {for (final m in latest.messages) m.messageId};
      state = AsyncData(
        latest.copyWith(
          messages: [
            ...latest.messages,
            ...page.items.where((m) => !known.contains(m.messageId)),
          ],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          clearNextCursor: page.nextCursor == null,
          isLoadingMore: false,
        ),
      );
    } on Object catch (error) {
      if (_disposed || epoch != _epoch) return;
      // A rejected cursor is recovered, not reported - see [loadMore]'s doc.
      if (_isCursorRejected(error)) {
        await refresh();
        return;
      }
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(isLoadingMore: false, appendError: error),
      );
    }
  }

  /// Re-runs from the ticket and page one (the user-tapped Retry).
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

  /// Sends [text] as a reply on this ticket.
  ///
  /// - **Ignored** ([SendReplyIgnored]) while a reply is in flight, when the
  ///   trimmed text is empty, or when the thread is not loaded. No request.
  /// - **Sent**: the returned message is appended when every page is loaded
  ///   (`!hasMore`); otherwise the thread is refreshed, so the new message is
  ///   never inserted in the middle of an unloaded gap. Either way the ticket
  ///   list is invalidated - a reply moves its ticket to the top.
  /// - **Closed**: `409 ticket_closed`. The ticket is re-read and the state
  ///   updated so [SupportThread.isClosed] is true. The server's `409` is the
  ///   authority even if the re-read fails or disagrees.
  /// - **Failed**: anything else; the messages are unchanged.
  ///
  /// A reply that lands after the screen closed writes no state, but the ticket
  /// list is still invalidated through the container, because the list behind
  /// this screen is still showing the old order.
  Future<SendReplyOutcome> sendReply(String text) async {
    final current = state.value;
    final body = text.trim();
    if (current == null || _sending || current.isSending || body.isEmpty) {
      return const SendReplyIgnored();
    }

    final epoch = _epoch;
    final repository = ref.read(supportRepositoryProvider);
    final container = ref.container;
    _sending = true;
    state = AsyncData(current.copyWith(isSending: true));

    final SupportTicketMessage message;
    try {
      message = await repository.postMySupportTicketMessage(ticketId, body);
    } on Object catch (error) {
      _sending = false;
      if (_isTicketClosed(error)) {
        container.invalidate(supportTicketsProvider);
        if (_disposed) return const SendReplyClosed();
        // Even when a rebuild landed mid-send: the new state was built while
        // the send was in flight (`isSending: true`) and the held ticket may
        // still read open, so it is the CURRENT state that is corrected.
        await _markClosed(repository);
        return const SendReplyClosed();
      }
      _stopSending();
      return SendReplyFailed(error);
    }

    // The reply is written. Nothing below may turn that into a failure, which
    // is why it sits outside the `try`.
    _sending = false;
    container.invalidate(supportTicketsProvider);
    if (_disposed) return const SendReplySent();
    if (epoch != _epoch) {
      // A refresh landed during the send and may have read the thread before
      // the reply was written; read it again rather than guess.
      await refresh();
      return const SendReplySent();
    }
    final latest = state.value ?? current;
    if (latest.hasMore) {
      // Not every page is loaded: appending would put the reply after a gap.
      await refresh();
    } else {
      // A page that landed while the send was in flight may already carry the
      // reply the server just wrote; a message is never shown twice.
      final alreadyShown = latest.messages.any(
        (m) => m.messageId == message.messageId,
      );
      state = AsyncData(
        latest.copyWith(
          messages: alreadyShown
              ? latest.messages
              : [...latest.messages, message],
          isSending: false,
        ),
      );
    }
    return const SendReplySent();
  }

  /// Clears `isSending` on the CURRENT state, whichever build produced it.
  ///
  /// A rebuild that landed mid-send (a Retry, an invalidation) built its state
  /// with `isSending: true` (it reads [_sending] as it finishes), so a send that
  /// then ends without a state of its own to write - a failure - has to undo
  /// that. With no value yet (a rebuild still running) there is nothing to
  /// clear: that build reads [_sending], already `false`, when it finishes.
  void _stopSending() {
    if (_disposed) return;
    final latest = state.value;
    if (latest == null) return;
    state = AsyncData(latest.copyWith(isSending: false));
  }

  /// After a `409 ticket_closed`: re-read the ticket so the thread shows the
  /// server's closed ticket. If the re-read fails, or somehow does not say
  /// `closed`, the `409` itself is the truth and the status is set to `closed`
  /// on the held ticket - `closedAt` is left as the server last reported it,
  /// never invented. Also ends the send ([SupportThread.isSending]).
  ///
  /// Works on the CURRENT state, so it serves a send whose build was replaced
  /// mid-flight too; a rebuild landing during the re-read is newer than this
  /// and wins.
  Future<void> _markClosed(SupportRepository repository) async {
    final epoch = _epoch;
    SupportTicket? fresh;
    try {
      fresh = await repository.getMySupportTicket(ticketId);
    } on Object {
      // Offline or anything else: the 409 already said it.
    }
    if (_disposed || epoch != _epoch) return;
    final latest = state.value;
    if (latest == null) return;
    final ticket = (fresh != null && fresh.isClosed)
        ? fresh
        : latest.ticket.copyWith(status: SupportTicketStatus.closed.wire);
    state = AsyncData(latest.copyWith(ticket: ticket, isSending: false));
  }

  /// A `400 validation_failed` whose field map names `cursor`.
  static bool _isCursorRejected(Object error) =>
      error is ValidationException && error.fields.contains('cursor');

  static bool _isTicketClosed(Object error) =>
      error is ApiException &&
      error.status == 409 &&
      error.code == 'ticket_closed';
}

/// One notifier per ticket id. autoDispose: leaving the thread disposes it and
/// returning refetches. Not session-scoped state: it dies with its screen.
final supportThreadProvider = AsyncNotifierProvider.autoDispose
    .family<SupportThreadNotifier, SupportThread, String>(
      SupportThreadNotifier.new,
      // See `supportTicketsProvider`: a failed build must reach the error view
      // at once, and `account_pending_deletion` must not be hammered.
      retry: _noRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
