import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/support_models.dart';
import '../repository/support_repository.dart';
import 'support_tickets_notifier.dart';

/// Opening a support ticket (`POST /support/tickets`, text only).
///
/// The state is the form's whole lifecycle in one `AsyncValue`:
/// - `AsyncData(null)` - nothing submitted yet (what [build] returns);
/// - `AsyncLoading` - a submit is in flight (the screen disables the fields and
///   the button and shows a spinner in the button);
/// - `AsyncData(ticket)` - the server created the ticket; the screen replaces
///   its route with the new thread;
/// - `AsyncError` - the submit failed. The text stays in the fields, and the
///   screen maps the error with `supportActionFailureText`.
///
/// **One submit at a time.** A tap while a submit is in flight is ignored: the
/// server allows 5 creates per student per day (`429 rate_limited`), and a
/// double tap must not spend two of them on one ticket.
///
/// The validation (trimmed empty, over 120 / 4000 characters) belongs to the
/// form and, authoritatively, to the server's `400 validation_failed`; this
/// notifier sends what it is given, trimmed by the repository.
class CreateSupportTicketNotifier extends AsyncNotifier<SupportTicket?> {
  /// True once this notifier has been disposed.
  bool _disposed = false;

  /// A submit is in flight.
  bool _submitting = false;

  @override
  Future<SupportTicket?> build() async {
    // Reset first: `ref.onDispose` also fires on invalidation, and the same
    // notifier instance is reused for the rebuild.
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return null;
  }

  /// Creates the ticket. Ignored while another submit is in flight.
  ///
  /// On success the ticket list is invalidated (the new ticket belongs at its
  /// top), through the container so that it also happens when the student left
  /// the form while the request was running - the ticket exists either way.
  Future<void> submit(String subject, String details) async {
    if (_submitting) return;
    _submitting = true;

    final repository = ref.read(supportRepositoryProvider);
    final container = ref.container;
    state = const AsyncLoading();

    final SupportTicket ticket;
    try {
      ticket = await repository.createSupportTicket(
        subject: subject,
        details: details,
      );
    } on Object catch (error, stackTrace) {
      _submitting = false;
      if (!_disposed) state = AsyncError(error, stackTrace);
      return;
    }

    // The ticket exists. Nothing below may turn that into a failure.
    _submitting = false;
    container.invalidate(supportTicketsProvider);
    if (_disposed) return;
    state = AsyncData(ticket);
  }
}

/// autoDispose: the form's state dies with its screen, so reopening it starts
/// clean. No automatic retry - a failed create is a user-tapped Submit, and
/// retrying a write on a timer would spend the daily budget.
final createSupportTicketProvider =
    AsyncNotifierProvider.autoDispose<
      CreateSupportTicketNotifier,
      SupportTicket?
    >(CreateSupportTicketNotifier.new, retry: _noRetry);

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
