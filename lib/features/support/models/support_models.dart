import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_models.freezed.dart';
part 'support_models.g.dart';

/// The ticket statuses the contract names today (`SupportTicketStatus`,
/// `openapi.yaml:3911-3922`): `open`, `in_progress`, `pending`, `closed`.
///
/// **Never a field type.** The wire `status` stays a plain `String` on the
/// models below, because the contract says clients MUST tolerate an unknown
/// value ("treat any value you do not recognise as 'in progress - not closed'
/// rather than failing to parse the ticket") and a generated enum would throw
/// on the first status Customer Service adds. This enum is reached through
/// [tryParse], which returns `null` for anything it does not know.
///
/// `in_progress` and `pending` are set only by Customer Service; a student
/// never chooses a status, and a reply from either side never changes it. Only
/// [closed] means the ticket takes no reply, and it is final - there is no
/// reopen.
enum SupportTicketStatus {
  open('open'),
  inProgress('in_progress'),
  pending('pending'),
  closed('closed');

  const SupportTicketStatus(this.wire);

  /// The contract's spelling (`in_progress`, not `inProgress`).
  final String wire;

  /// The member whose wire value is exactly [value], or `null` for anything
  /// else - including `null` itself and a differently-cased spelling. Never
  /// throws.
  static SupportTicketStatus? tryParse(String? value) {
    for (final status in values) {
      if (status.wire == value) return status;
    }
    return null;
  }
}

/// The two `authorKind` values the contract names (`SupportTicketMessage`,
/// `openapi.yaml:3975`): `student` and `staff`.
///
/// [SupportTicketMessage.isStudent] is true ONLY for [student]; every other
/// value - `staff` and any kind added later - is shown as Customer support.
abstract final class SupportAuthorKinds {
  static const student = 'student';
  static const staff = 'staff';
}

/// One row of `GET /support/tickets` (`SupportTicketSummary`,
/// `openapi.yaml:3931-3943`).
///
/// All six fields are `required` in the contract and all six are required here:
/// a missing one throws, and the repository wraps that into a typed
/// `UnknownException`.
///
/// [reference] (`TK-{n}`) is a **display label, never an id** - it is not
/// accepted as a path parameter anywhere. [ticketId] is the only handle.
/// [createdAt] and [lastActivityAt] are the server's instants (normally UTC);
/// call `.toLocal()` before formatting them for display.
///
/// `toString` is redacted to the type name: [subject] is text the student
/// wrote, and the project rule is that none of it reaches a log, an error
/// detail or a test report by accident. Equality and JSON are the generated
/// ones.
@freezed
abstract class SupportTicketSummary with _$SupportTicketSummary {
  const SupportTicketSummary._();

  const factory SupportTicketSummary({
    required String ticketId,
    required String reference,
    required String subject,

    /// The wire status, verbatim. Read it through [knownStatus] / [isClosed];
    /// never switch exhaustively on the string.
    required String status,
    required DateTime createdAt,

    /// The ticket's creation or its latest reply, whichever is later - the
    /// list's sort key.
    required DateTime lastActivityAt,
  }) = _SupportTicketSummary;

  factory SupportTicketSummary.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketSummaryFromJson(json);

  /// [status] as an enum, or `null` for a value this app predates.
  SupportTicketStatus? get knownStatus => SupportTicketStatus.tryParse(status);

  /// True ONLY for the wire value `closed`. An unknown status is "in progress -
  /// not closed" (`openapi.yaml:3911-3922`), so it reads as `false`.
  bool get isClosed => knownStatus == SupportTicketStatus.closed;

  @override
  String toString() => 'SupportTicketSummary(<redacted>)';
}

/// One ticket from `GET /support/tickets/{ticketId}` and the answer to
/// `POST /support/tickets` (`SupportTicket`, `openapi.yaml:3945-3967`).
///
/// [details] is the ticket's **opening text**, not a thread message: the thread
/// (`listMySupportTicketMessages`) holds replies only.
///
/// [closedAt] is the one nullable field: `null` while the ticket is not closed
/// (the key is still present on the wire).
///
/// **`attachments` is deliberately not modelled** (photos are CW12b, gated on
/// CW04). The contract lists it as required on the wire, so it is always
/// there, but json_serializable ignores keys it has no field for.
///
/// `toString` is redacted to the type name: [subject] and [details] are text
/// the student wrote (a minor, usually), and none of it reaches a log, an error
/// detail or a test report by accident.
@freezed
abstract class SupportTicket with _$SupportTicket {
  const SupportTicket._();

  const factory SupportTicket({
    required String ticketId,
    required String reference,
    required String subject,
    required String details,

    /// The wire status, verbatim. Read it through [knownStatus] / [isClosed].
    required String status,
    required DateTime createdAt,
    required DateTime lastActivityAt,
    required DateTime? closedAt,
  }) = _SupportTicket;

  factory SupportTicket.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketFromJson(json);

  /// [status] as an enum, or `null` for a value this app predates.
  SupportTicketStatus? get knownStatus => SupportTicketStatus.tryParse(status);

  /// True ONLY for the wire value `closed`. An unknown status reads as `false`
  /// - it never refuses a reply on the client's say-so.
  bool get isClosed => knownStatus == SupportTicketStatus.closed;

  @override
  String toString() => 'SupportTicket(<redacted>)';
}

/// One reply in a ticket's thread (`SupportTicketMessage`,
/// `openapi.yaml:3968-3982`).
///
/// It carries **no staff identity or role**: a `staff` message is shown as
/// Customer support. [authorKind] stays a wire `String` for the same reason
/// [SupportTicket.status] does - read it through [isStudent].
///
/// [body] may be an empty string (a photo-only reply from another client,
/// spec-067); `attachments` is not modelled in CW12a, so such a reply is a
/// name with no text.
///
/// `toString` is redacted to the type name: [body] is text the student wrote,
/// and none of it reaches a log, an error detail or a test report by accident.
@freezed
abstract class SupportTicketMessage with _$SupportTicketMessage {
  const SupportTicketMessage._();

  const factory SupportTicketMessage({
    required String messageId,
    required String authorKind,
    required String body,
    required DateTime createdAt,
  }) = _SupportTicketMessage;

  factory SupportTicketMessage.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketMessageFromJson(json);

  /// True ONLY for `student`. Anything else renders as Customer support.
  bool get isStudent => authorKind == SupportAuthorKinds.student;

  @override
  String toString() => 'SupportTicketMessage(<redacted>)';
}
