import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../registration/models/reference_models.dart' show CursorPage;
import '../models/support_models.dart';

/// The only place that touches Dio for the student's support tickets.
///
/// Five operations, all `x-stability: stable` (`openapi.yaml:2654-2845`),
/// authenticated and on the main [dioProvider]: `AuthInterceptor` attaches the
/// Bearer and `ErrorInterceptor` has already mapped failures by the time they
/// arrive here, so every failure is rethrown as the typed [AppException] the
/// interceptor produced.
///
/// **Text only (CW12a).** No call here ever sends `attachmentIds` and none
/// reads `attachments`: photos are CW12b, gated on CW04.
///
/// All five are **default-denied** while the account is inside its 30-day
/// deletion grace window: `403 account_pending_deletion`, an `ApiException`
/// recognised by `isAccountPendingDeletion`. It is surfaced untouched - no
/// retry, no sign-out.
///
/// `404 not_found` on a ticket route means the id is unknown, malformed **or
/// another student's** - one code for all three so it cannot be used as an
/// existence probe (`:2757`, `:2796`, `:2837`). It is surfaced as the typed
/// `ApiException(status: 404, code: 'not_found')`, not swallowed.
///
/// Nothing in this file logs a subject, a detail, a body, an id or a cursor.
class SupportRepository {
  SupportRepository(this._dio);

  final Dio _dio;

  /// `CreateSupportTicketRequest` / `PostSupportTicketMessageRequest` bounds,
  /// applied by the server to the TRIMMED value. Exposed so the form can
  /// enforce the same numbers as you type; the repository itself does not
  /// validate - the server is authoritative and answers `400 validation_failed`.
  static const maxSubjectLength = 120;
  static const maxDetailsLength = 4000;
  static const maxBodyLength = 4000;

  /// `GET /support/tickets` (`listMySupportTickets`) - one page of the caller's
  /// own tickets, most recently active first, pages of 20.
  ///
  /// **The operation takes no `limit`**, so none is ever sent. Only the
  /// contract's OPAQUE keyset [cursor] is: follow it, never parse or build it.
  /// `null` means the first page and sends no `cursor` at all (an absent
  /// parameter, not `cursor: null`, which would be a malformed cursor).
  ///
  /// 🔴 Branch on `hasMore`, never on `items.length`: the envelope is returned
  /// untouched so that signal survives.
  Future<CursorPage<SupportTicketSummary>> listMySupportTickets({
    String? cursor,
  }) => _guard(() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/support/tickets',
      queryParameters: {'cursor': ?cursor},
    );
    return CursorPage<SupportTicketSummary>.fromJson(
      res.data!,
      (json) => SupportTicketSummary.fromJson(json! as Map<String, dynamic>),
    );
  });

  /// `GET /support/tickets/{ticketId}` (`getMySupportTicket`) - one of the
  /// caller's own tickets. `404 not_found` for an unknown, malformed or foreign
  /// id.
  Future<SupportTicket> getMySupportTicket(String ticketId) => _guard(() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/support/tickets/${Uri.encodeComponent(ticketId)}',
    );
    return SupportTicket.fromJson(res.data!);
  });

  /// `GET /support/tickets/{ticketId}/messages` (`listMySupportTicketMessages`)
  /// - one page of the ticket's thread, OLDEST first, pages of 20, no `limit`.
  ///
  /// The ticket's opening text is its `details`, not a message. Same cursor and
  /// `hasMore` rules as [listMySupportTickets].
  Future<CursorPage<SupportTicketMessage>> listMySupportTicketMessages(
    String ticketId, {
    String? cursor,
  }) => _guard(() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/support/tickets/${Uri.encodeComponent(ticketId)}/messages',
      queryParameters: {'cursor': ?cursor},
    );
    return CursorPage<SupportTicketMessage>.fromJson(
      res.data!,
      (json) => SupportTicketMessage.fromJson(json! as Map<String, dynamic>),
    );
  });

  /// `POST /support/tickets` (`createSupportTicket`) - opens a ticket, status
  /// `open`. The body is exactly `{subject, details}`, both **trimmed** here
  /// (the server trims too and applies its 1-120 / 1-4000 limits to the trimmed
  /// value). Never `attachmentIds`.
  ///
  /// `429 rate_limited` (5 creates per student per day) carries the
  /// `Retry-After` the interceptor parsed onto `RateLimitedException`.
  Future<SupportTicket> createSupportTicket({
    required String subject,
    required String details,
  }) => _guard(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/support/tickets',
      data: <String, dynamic>{
        'subject': subject.trim(),
        'details': details.trim(),
      },
    );
    return SupportTicket.fromJson(res.data!);
  });

  /// `POST /support/tickets/{ticketId}/messages` (`postMySupportTicketMessage`)
  /// - a text reply. The body is exactly `{body}`, **trimmed**. Never
  /// `attachmentIds`.
  ///
  /// `409 ticket_closed` (a closed ticket takes no reply and cannot be
  /// reopened) and `429 rate_limited` (60 per hour) arrive as typed
  /// [ApiException]s for the notifier to branch on.
  Future<SupportTicketMessage> postMySupportTicketMessage(
    String ticketId,
    String body,
  ) => _guard(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/support/tickets/${Uri.encodeComponent(ticketId)}/messages',
      data: <String, dynamic>{'body': body.trim()},
    );
    return SupportTicketMessage.fromJson(res.data!);
  });

  /// Runs [call] and keeps the typed boundary: a [DioException] becomes the
  /// [AppException] the ErrorInterceptor mapped onto it (or [UnknownException]
  /// if something bypassed the chain), and a decode failure - which happens
  /// OUTSIDE Dio - becomes an [UnknownException] carrying only the runtime type.
  /// A subject, a detail, a body and an id are exactly what must never leak
  /// into an error detail.
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final err = e.error;
      throw err is AppException ? err : const UnknownException();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }
}

final supportRepositoryProvider = Provider<SupportRepository>(
  (ref) => SupportRepository(ref.watch(dioProvider)),
);
