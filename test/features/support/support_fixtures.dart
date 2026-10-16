import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/support/models/support_models.dart';

/// Sample ticket ids. Plain strings are enough for the data layer - the app
/// treats `ticketId` as an opaque handle.
const ticketIdA = '5c000000-0000-4000-8000-00000000000a';
const ticketIdB = '5c000000-0000-4000-8000-00000000000b';

/// One list row with every field spelled out only when a test cares.
SupportTicketSummary ticketSummary(
  String id, {
  String reference = 'TK-1001',
  String subject = 'Sample subject',
  String status = 'open',
  DateTime? createdAt,
  DateTime? lastActivityAt,
}) {
  final created = createdAt ?? DateTime.utc(2026, 10, 9, 12);
  return SupportTicketSummary(
    ticketId: id,
    reference: reference,
    subject: subject,
    status: status,
    createdAt: created,
    lastActivityAt: lastActivityAt ?? created,
  );
}

/// One full ticket.
SupportTicket ticketDetail(
  String id, {
  String reference = 'TK-1001',
  String subject = 'Sample subject',
  String details = 'Sample details',
  String status = 'open',
  DateTime? createdAt,
  DateTime? lastActivityAt,
  DateTime? closedAt,
}) {
  final created = createdAt ?? DateTime.utc(2026, 10, 9, 12);
  return SupportTicket(
    ticketId: id,
    reference: reference,
    subject: subject,
    details: details,
    status: status,
    createdAt: created,
    lastActivityAt: lastActivityAt ?? created,
    closedAt: closedAt,
  );
}

/// A closed ticket, as the server reports it.
SupportTicket closedTicket(String id) =>
    ticketDetail(id, status: 'closed', closedAt: DateTime.utc(2026, 10, 9, 14));

/// One reply.
SupportTicketMessage supportMessage(
  String id, {
  String authorKind = 'student',
  String body = 'Sample reply',
  DateTime? createdAt,
}) => SupportTicketMessage(
  messageId: id,
  authorKind: authorKind,
  body: body,
  createdAt: createdAt ?? DateTime.utc(2026, 10, 9, 13),
);

/// A page of the ticket list. [hasMore] defaults to `false`, so a fixture is a
/// COMPLETE list unless a test deliberately says otherwise.
CursorPage<SupportTicketSummary> ticketsPage(
  List<SupportTicketSummary> items, {
  bool hasMore = false,
  String? nextCursor,
}) => CursorPage<SupportTicketSummary>(
  items: items,
  hasMore: hasMore,
  nextCursor: nextCursor,
);

/// A page of a thread.
CursorPage<SupportTicketMessage> messagesPage(
  List<SupportTicketMessage> items, {
  bool hasMore = false,
  String? nextCursor,
}) => CursorPage<SupportTicketMessage>(
  items: items,
  hasMore: hasMore,
  nextCursor: nextCursor,
);

/// The wire JSON of one list row, as `GET /support/tickets` sends it.
Map<String, dynamic> wireSummary({
  String ticketId = ticketIdA,
  String reference = 'TK-1001',
  String subject = 'Sample subject',
  String status = 'open',
  String createdAt = '2026-10-09T12:00:00Z',
  String lastActivityAt = '2026-10-09T12:00:00Z',
}) => {
  'ticketId': ticketId,
  'reference': reference,
  'subject': subject,
  'status': status,
  'createdAt': createdAt,
  'lastActivityAt': lastActivityAt,
};

/// The wire JSON of one ticket. It carries the contract's required
/// `attachments` array, which the app does not model.
Map<String, dynamic> wireTicket({
  String ticketId = ticketIdA,
  String reference = 'TK-1001',
  String subject = 'Sample subject',
  String details = 'Sample details',
  String status = 'open',
  String createdAt = '2026-10-09T12:00:00Z',
  String lastActivityAt = '2026-10-09T12:00:00Z',
  String? closedAt,
}) => {
  'ticketId': ticketId,
  'reference': reference,
  'subject': subject,
  'details': details,
  'status': status,
  'createdAt': createdAt,
  'lastActivityAt': lastActivityAt,
  'closedAt': closedAt,
  'attachments': <dynamic>[],
};

/// The wire JSON of one reply.
Map<String, dynamic> wireMessage({
  String messageId = '5d000000-0000-4000-8000-000000000001',
  String authorKind = 'student',
  String body = 'Sample reply',
  String createdAt = '2026-10-09T13:00:00Z',
}) => {
  'messageId': messageId,
  'authorKind': authorKind,
  'body': body,
  'createdAt': createdAt,
  'attachments': <dynamic>[],
};
