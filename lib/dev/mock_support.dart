/// Throwaway on-device preview data for the student's support tickets - NOT
/// production code.
///
/// Answers the five text-only operations the app calls - `GET`/`POST
/// /support/tickets`, `GET /support/tickets/{ticketId}` and `GET`/`POST
/// /support/tickets/{ticketId}/messages` (`contract/openapi.yaml:2654-2845`,
/// all `x-stability: stable`) - for `lib/dev/mock_backend.dart`, which owns the
/// request plumbing. This file holds the data and the contract's rules; the
/// interceptor turns a [MockSupportReply] into a Dio response.
///
/// It lives in its own file so the interceptor gains one field and one dispatch
/// block instead of a few hundred lines of fixtures.
///
/// **Everything below is MOCK SAMPLE DATA, not product copy.** The subjects,
/// details and replies are short invented samples about using the app (two
/// reuse the Figma frame's English samples); real ones are written by students
/// and Customer Service and arrive from the server. No phone number, e-mail
/// address or real person appears anywhere.
///
/// Strict where the server is strict, per `mock_backend.dart`'s own rule:
/// - lists are pages of **20**, no `limit`, ordered as the contract says
///   (tickets by `lastActivityAt` descending then `ticketId` descending;
///   replies by `createdAt` ascending then `messageId` ascending);
/// - `cursor` is opaque to the app; here it is a keyset in disguise (the last
///   row served), so a ticket that moves to the top between pages cannot repeat
///   a row. A token this mock did not issue - or one issued for another list -
///   is `400 validation_failed` on field `cursor`;
/// - an unknown ticket id is `404 not_found` on every ticket route (the
///   contract gives unknown, malformed and foreign ids one answer);
/// - creating validates the TRIMMED `subject` (1-120) and `details` (1-4000),
///   is capped at [kMockSupportCreateLimit] per mock session (then
///   `429 rate_limited` with `Retry-After`), and answers a text ticket with
///   status `open`, `closedAt: null`, the next `TK-` number and
///   `createdAt == lastActivityAt == now`;
/// - replying checks ownership (`404`), then closed (`409 ticket_closed`), then
///   the TRIMMED `body` (1-4000, `400 validation_failed`), and bumps the
///   ticket's `lastActivityAt` so it moves to the top of the list.
///
/// Every response carries the contract's required (empty) `attachments`
/// array; photos are CW12b and nothing here accepts `attachmentIds`.
///
/// State is per [MockSupportDesk] instance, so creates and replies persist for
/// the life of one mock session (one `buildMockDio`) and a fresh session starts
/// from the fixtures again.
library;

import 'dart:convert';

/// What the mock answers, in terms the interceptor maps onto its own `_ok`,
/// `_validationFailed` and `_problem` helpers.
sealed class MockSupportReply {
  const MockSupportReply();
}

/// A success: [status] (`200` or `201`) and the JSON body.
final class MockSupportOk extends MockSupportReply {
  const MockSupportOk(this.status, this.data);

  final int status;
  final Object? data;
}

/// `400 validation_failed` carrying the contract's `field -> [messages]` map.
final class MockSupportValidation extends MockSupportReply {
  const MockSupportValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// Any other ProblemDetails: `404 not_found`, `409 ticket_closed`,
/// `429 rate_limited`. [retryAfterSeconds], when set, is sent as the
/// `Retry-After` header (delta-seconds, the only form the client parses).
final class MockSupportProblem extends MockSupportReply {
  const MockSupportProblem(
    this.status,
    this.code,
    this.detail, {
    this.retryAfterSeconds,
  });

  final int status;
  final String code;
  final String detail;
  final int? retryAfterSeconds;
}

/// The id of fixture ticket number [n] (1-based, 1 = most recently active).
/// Exposed so a test can name a ticket without hard-coding a UUID. Tickets the
/// session creates continue the numbering from 23.
String mockSupportTicketId(int n) =>
    '5c000000-0000-4000-8000-${n.toRadixString(16).padLeft(12, '0')}';

/// The id of message number [m] (1-based, in the order the fixtures were laid
/// down; messages the session sends continue the numbering).
String mockSupportMessageId(int m) =>
    '5d000000-0000-4000-8000-${m.toRadixString(16).padLeft(12, '0')}';

/// How many tickets the fixtures hold. More than a page of 20, so the first
/// page ends with `hasMore: true` and the second holds 2.
const kMockSupportTicketCount = 22;

/// The fixture that holds 25 replies - two message pages (20 + 5).
const kMockSupportLongThreadTicket = 2;

/// The fixture whose status is a value this app predates (`escalated`).
const kMockSupportUnknownStatusTicket = 5;

/// Creates a mock session may make before `429 rate_limited` (the contract's
/// "at most 5 ticket creates per student per day").
const kMockSupportCreateLimit = 5;

/// The `Retry-After` the mock sends with its `429`, in seconds.
const kMockSupportRetryAfterSeconds = 3600;

/// One support desk per mock session. See the file header.
class MockSupportDesk {
  MockSupportDesk() {
    _populate();
  }

  final _tickets = <_MockTicket>[];
  var _nextMessageNumber = 1;
  var _nextTicketNumber = kMockSupportTicketCount + 1;
  var _createdThisSession = 0;

  static const _pageSize = 20;
  static const _maxSubject = 120;
  static const _maxDetails = 4000;
  static const _maxBody = 4000;

  static final _ticketsPath = RegExp(r'^/support/tickets$');
  static final _ticketPath = RegExp(r'^/support/tickets/([^/]+)$');
  static final _messagesPath = RegExp(r'^/support/tickets/([^/]+)/messages$');

  /// The reply for a support route, or `null` when [method] + [path] is not one
  /// of the five this mock serves (so the interceptor keeps looking -
  /// `/support/attachments*` is deliberately not served: photos are CW12b).
  MockSupportReply? handle(
    String method,
    String path,
    Map<String, dynamic> query,
    Map<String, dynamic> body,
  ) {
    if (_ticketsPath.hasMatch(path)) {
      if (method == 'GET') return _listTickets(query);
      if (method == 'POST') return _createTicket(body);
      return null;
    }
    final messages = _messagesPath.firstMatch(path);
    if (messages != null) {
      final id = Uri.decodeComponent(messages.group(1)!);
      if (method == 'GET') return _listMessages(id, query);
      if (method == 'POST') return _postMessage(id, body);
      return null;
    }
    final ticket = _ticketPath.firstMatch(path);
    if (ticket != null && method == 'GET') {
      return _getTicket(Uri.decodeComponent(ticket.group(1)!));
    }
    return null;
  }

  // -------------------------------------------------------------------------
  // GET /support/tickets
  // -------------------------------------------------------------------------

  MockSupportReply _listTickets(Map<String, dynamic> query) {
    final sorted = _sortedTickets();

    var start = 0;
    final rawCursor = query['cursor'];
    if (rawCursor != null) {
      final after = rawCursor is String ? _decodeTicketCursor(rawCursor) : null;
      if (after == null) return _badCursor();
      // Keyset: the first row strictly AFTER the one the cursor names, in the
      // list's own order. If that row has since moved, the walk still resumes
      // at the right place.
      start = sorted.indexWhere((t) => _isAfter(t, after));
      if (start < 0) start = sorted.length;
    }

    final end = (start + _pageSize).clamp(0, sorted.length);
    final hasMore = end < sorted.length;
    final page = sorted.sublist(start, end);

    return MockSupportOk(200, <String, dynamic>{
      'items': [for (final t in page) t.summaryJson()],
      'nextCursor': hasMore ? _encodeTicketCursor(page.last) : null,
      'hasMore': hasMore,
    });
  }

  /// Most recently active first; ties by `ticketId` descending.
  List<_MockTicket> _sortedTickets() {
    final sorted = [..._tickets];
    sorted.sort((a, b) {
      final byActivity = b.lastActivityAt.compareTo(a.lastActivityAt);
      return byActivity != 0 ? byActivity : b.id.compareTo(a.id);
    });
    return sorted;
  }

  /// Whether [t] sorts strictly after the cursor's row in the list's order.
  bool _isAfter(_MockTicket t, _TicketCursor cursor) {
    final byActivity = t.lastActivityAt.compareTo(cursor.lastActivityAt);
    if (byActivity != 0) return byActivity < 0;
    return t.id.compareTo(cursor.ticketId) < 0;
  }

  // -------------------------------------------------------------------------
  // GET /support/tickets/{ticketId}
  // -------------------------------------------------------------------------

  MockSupportReply _getTicket(String ticketId) {
    final ticket = _find(ticketId);
    if (ticket == null) return _notFound();
    return MockSupportOk(200, ticket.json());
  }

  // -------------------------------------------------------------------------
  // GET /support/tickets/{ticketId}/messages
  // -------------------------------------------------------------------------

  MockSupportReply _listMessages(String ticketId, Map<String, dynamic> query) {
    final ticket = _find(ticketId);
    if (ticket == null) return _notFound();

    // Already in chat order: messages are only ever appended, each stamped later
    // than the last.
    final messages = ticket.messages;
    var start = 0;
    final rawCursor = query['cursor'];
    if (rawCursor != null) {
      final after = rawCursor is String
          ? _decodeMessageCursor(rawCursor, ticketId)
          : null;
      if (after == null) return _badCursor();
      start = messages.indexWhere((m) => _isMessageAfter(m, after));
      if (start < 0) start = messages.length;
    }

    final end = (start + _pageSize).clamp(0, messages.length);
    final hasMore = end < messages.length;
    final page = messages.sublist(start, end);

    return MockSupportOk(200, <String, dynamic>{
      'items': [for (final m in page) m.json()],
      'nextCursor': hasMore ? _encodeMessageCursor(ticketId, page.last) : null,
      'hasMore': hasMore,
    });
  }

  bool _isMessageAfter(_MockMessage m, _MessageCursor cursor) {
    final byTime = m.createdAt.compareTo(cursor.createdAt);
    if (byTime != 0) return byTime > 0;
    return m.id.compareTo(cursor.messageId) > 0;
  }

  // -------------------------------------------------------------------------
  // POST /support/tickets
  // -------------------------------------------------------------------------

  MockSupportReply _createTicket(Map<String, dynamic> body) {
    // The daily budget is spent whatever the payload says.
    if (_createdThisSession >= kMockSupportCreateLimit) {
      return const MockSupportProblem(
        429,
        'rate_limited',
        'Too many support tickets today',
        retryAfterSeconds: kMockSupportRetryAfterSeconds,
      );
    }

    final subject = _trimmedString(body['subject']);
    final details = _trimmedString(body['details']);
    final errors = <String, List<String>>{};
    if (subject == null || subject.isEmpty) {
      errors['subject'] = ['Required.'];
    } else if (subject.length > _maxSubject) {
      errors['subject'] = ['Must be at most $_maxSubject characters.'];
    }
    if (details == null || details.isEmpty) {
      errors['details'] = ['Required.'];
    } else if (details.length > _maxDetails) {
      errors['details'] = ['Must be at most $_maxDetails characters.'];
    }
    if (errors.isNotEmpty) return MockSupportValidation(errors);

    final n = _nextTicketNumber++;
    _createdThisSession++;
    final now = _stamp();
    final ticket = _MockTicket(
      id: mockSupportTicketId(n),
      reference: 'TK-${1000 + n}',
      subject: subject!,
      details: details!,
      status: 'open',
      createdAt: now,
      lastActivityAt: now,
    );
    _tickets.add(ticket);
    return MockSupportOk(201, ticket.json());
  }

  // -------------------------------------------------------------------------
  // POST /support/tickets/{ticketId}/messages
  // -------------------------------------------------------------------------

  MockSupportReply _postMessage(String ticketId, Map<String, dynamic> body) {
    // The contract's check order: ownership, then closed, then the content.
    final ticket = _find(ticketId);
    if (ticket == null) return _notFound();
    if (ticket.status == 'closed') {
      return const MockSupportProblem(
        409,
        'ticket_closed',
        'This ticket is closed and takes no reply',
      );
    }

    final text = _trimmedString(body['body']);
    if (text == null || text.isEmpty) {
      return const MockSupportValidation({
        'body': ['Required.'],
      });
    }
    if (text.length > _maxBody) {
      return const MockSupportValidation({
        'body': ['Must be at most $_maxBody characters.'],
      });
    }

    final now = _stamp();
    final message = _MockMessage(
      id: mockSupportMessageId(_nextMessageNumber++),
      authorKind: 'student',
      body: text,
      createdAt: now,
    );
    ticket.messages.add(message);
    // "Moves the ticket's `lastActivityAt` to the reply's `createdAt`."
    ticket.lastActivityAt = now;
    return MockSupportOk(201, message.json());
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  _MockTicket? _find(String ticketId) =>
      _tickets.where((t) => t.id == ticketId).firstOrNull;

  /// `null` for anything that is not a string; the trimmed string otherwise.
  String? _trimmedString(Object? value) =>
      value is String ? value.trim() : null;

  /// A new instant for a create or a reply: the clock, but never earlier than
  /// one second after the latest activity already on the desk. A mock whose
  /// fixtures are dated in the future of a misset device clock would otherwise
  /// sort a brand-new ticket below them, and "a reply moves its ticket to the
  /// top" is the behaviour being previewed.
  DateTime _stamp() {
    final now = DateTime.now().toUtc();
    var latest = _newest;
    for (final t in _tickets) {
      if (t.lastActivityAt.isAfter(latest)) latest = t.lastActivityAt;
    }
    final floor = latest.add(const Duration(seconds: 1));
    return now.isAfter(floor) ? now : floor;
  }

  MockSupportProblem _notFound() => const MockSupportProblem(
    404,
    'not_found',
    'No such support ticket for this caller',
  );

  MockSupportValidation _badCursor() => const MockSupportValidation({
    'cursor': ['Not a cursor this API issued.'],
  });

  // -------------------------------------------------------------------------
  // Fixtures
  // -------------------------------------------------------------------------

  void _populate() {
    for (var i = 0; i < _seeds.length; i++) {
      final n = i + 1;
      final seed = _seeds[i];
      // Ticket 1 is the most recently active; each older one is a day earlier.
      final lastActivity = _newest.subtract(Duration(days: n - 1));
      // With replies, the ticket was opened three hours before the last of them.
      final hasReplies = seed.replies.isNotEmpty;
      final createdAt = hasReplies
          ? lastActivity.subtract(const Duration(hours: 3))
          : lastActivity;
      final ticket = _MockTicket(
        id: mockSupportTicketId(n),
        // The oldest ticket is TK-1001.
        reference: 'TK-${1001 + (kMockSupportTicketCount - n)}',
        subject: seed.subject,
        details: seed.details,
        status: seed.status,
        createdAt: createdAt,
        lastActivityAt: lastActivity,
        closedAt: seed.status == 'closed'
            ? lastActivity.add(const Duration(hours: 2))
            : null,
      );
      for (var j = 0; j < seed.replies.length; j++) {
        final reply = seed.replies[j];
        // Spread the replies over the three hours; the last lands exactly on
        // the ticket's `lastActivityAt`.
        final offset = Duration(
          seconds: 10800 * (j + 1) ~/ seed.replies.length,
        );
        ticket.messages.add(
          _MockMessage(
            id: mockSupportMessageId(_nextMessageNumber++),
            authorKind: reply.student ? 'student' : 'staff',
            body: reply.body,
            createdAt: createdAt.add(offset),
          ),
        );
      }
      _tickets.add(ticket);
    }
    assert(_tickets.length == kMockSupportTicketCount);
    assert(
      _tickets[kMockSupportLongThreadTicket - 1].messages.length == 25,
      'the long-thread fixture drifted',
    );
  }
}

// ---------------------------------------------------------------------------
// Cursors - opaque to the app, a keyset here
// ---------------------------------------------------------------------------

typedef _TicketCursor = ({DateTime lastActivityAt, String ticketId});

typedef _MessageCursor = ({DateTime createdAt, String messageId});

const _ticketCursorTag = 'mock-support-tickets:';
const _messageCursorTag = 'mock-support-messages:';

String _encodeTicketCursor(_MockTicket last) => base64Url.encode(
  utf8.encode(
    '$_ticketCursorTag${last.lastActivityAt.toIso8601String()}|${last.id}',
  ),
);

_TicketCursor? _decodeTicketCursor(String cursor) {
  try {
    final decoded = utf8.decode(base64Url.decode(cursor));
    if (!decoded.startsWith(_ticketCursorTag)) return null;
    final parts = decoded.substring(_ticketCursorTag.length).split('|');
    if (parts.length != 2) return null;
    final at = DateTime.tryParse(parts[0]);
    if (at == null || parts[1].isEmpty) return null;
    return (lastActivityAt: at, ticketId: parts[1]);
  } on FormatException {
    return null;
  }
}

String _encodeMessageCursor(String ticketId, _MockMessage last) =>
    base64Url.encode(
      utf8.encode(
        '$_messageCursorTag$ticketId|${last.createdAt.toIso8601String()}|'
        '${last.id}',
      ),
    );

/// A message cursor is bound to the ticket it was issued for.
_MessageCursor? _decodeMessageCursor(String cursor, String ticketId) {
  try {
    final decoded = utf8.decode(base64Url.decode(cursor));
    if (!decoded.startsWith(_messageCursorTag)) return null;
    final parts = decoded.substring(_messageCursorTag.length).split('|');
    if (parts.length != 3 || parts[0] != ticketId) return null;
    final at = DateTime.tryParse(parts[1]);
    if (at == null || parts[2].isEmpty) return null;
    return (createdAt: at, messageId: parts[2]);
  } on FormatException {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Rows
// ---------------------------------------------------------------------------

class _MockTicket {
  _MockTicket({
    required this.id,
    required this.reference,
    required this.subject,
    required this.details,
    required this.status,
    required this.createdAt,
    required this.lastActivityAt,
    this.closedAt,
  });

  final String id;
  final String reference;
  final String subject;
  final String details;
  final String status;
  final DateTime createdAt;
  DateTime lastActivityAt;
  final DateTime? closedAt;
  final messages = <_MockMessage>[];

  Map<String, dynamic> summaryJson() => <String, dynamic>{
    'ticketId': id,
    'reference': reference,
    'subject': subject,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'lastActivityAt': lastActivityAt.toIso8601String(),
  };

  Map<String, dynamic> json() => <String, dynamic>{
    'ticketId': id,
    'reference': reference,
    'subject': subject,
    'details': details,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'lastActivityAt': lastActivityAt.toIso8601String(),
    'closedAt': closedAt?.toIso8601String(),
    // Required by the contract; photos are CW12b, so always empty here.
    'attachments': <Object?>[],
  };
}

class _MockMessage {
  const _MockMessage({
    required this.id,
    required this.authorKind,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String authorKind;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> json() => <String, dynamic>{
    'messageId': id,
    'authorKind': authorKind,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'attachments': <Object?>[],
  };
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

/// The most recently active fixture's `lastActivityAt`; each older one is a day
/// earlier, so the 22 span 2026-09-18 to 2026-10-09.
final _newest = DateTime.utc(2026, 10, 9, 12);

typedef _Reply = ({bool student, String body});

typedef _Seed = ({
  String subject,
  String details,
  String status,
  List<_Reply> replies,
});

_Reply _s(String body) => (student: true, body: body);

_Reply _c(String body) => (student: false, body: body);

String _generic(String subject) =>
    'Sample details for "$subject". This is placeholder text for previewing '
    'the support screens.';

_Seed _seed(
  String subject,
  String status, {
  String? details,
  List<_Reply> replies = const [],
}) => (
  subject: subject,
  details: details ?? _generic(subject),
  status: status,
  replies: replies,
);

/// 22 tickets, most recently active first. What each is:
///
/// | # | ref | status | replies | note |
/// |---|-----|--------|---------|------|
/// | 1 | TK-1022 | open | 0 | frame sample subject |
/// | 2 | TK-1021 | in_progress | **25** | frame sample subject; two message pages |
/// | 3 | TK-1020 | pending | 1 (staff) | |
/// | 4 | TK-1019 | closed | 3 | student, staff, staff |
/// | 5 | TK-1018 | **escalated** | 2 | a status the app does not know |
/// | 6 | TK-1017 | open | 0 | a subject near the 120-character limit |
/// | 7-22 | TK-1016..TK-1001 | open / in_progress / pending / closed | 0-3 | |
///
/// So the list is 20 + 2, the statuses cover all four known values plus an
/// unknown one, and replies mix student and staff.
final List<_Seed> _seeds = [
  // 1
  _seed(
    'Points not credited after quiz',
    'open',
    details:
        'I finished a quiz yesterday and my total points did not change. '
        'Could you check it?',
  ),
  // 2 - the long thread: 25 replies, alternating student / staff.
  _seed(
    'Cannot access Biology quiz',
    'in_progress',
    details:
        'The Biology quiz does not open for me.\n'
        'It shows a message and then goes back to the list.',
    replies: [
      for (var j = 0; j < 25; j++)
        j.isEven
            ? _s('Sample student message ${j + 1} in a long thread.')
            : _c('Sample support message ${j + 1} in a long thread.'),
    ],
  ),
  // 3
  _seed(
    'Flashcards not loading',
    'pending',
    replies: [
      _c('Thanks for letting us know. We are looking into the flashcards.'),
    ],
  ),
  // 4
  _seed(
    'Question about the leaderboard',
    'closed',
    replies: [
      _s('How often does the leaderboard update?'),
      _c('The leaderboard refreshes as students finish quizzes.'),
      _c('We are closing this ticket. Please open a new one if you need more.'),
    ],
  ),
  // 5 - a status this app predates: it must read as "in progress, not closed".
  _seed(
    'Quiz timer shows the wrong time',
    'escalated',
    replies: [
      _s('The timer jumped from 20 seconds to 5 seconds.'),
      _c('We have passed this to the team that looks after quizzes.'),
    ],
  ),
  // 6 - near the 120-character subject limit, to exercise wrapping.
  _seed(
    'The explanation for a Chemistry question does not match the answer shown '
        'after I finish the quiz in the app',
    'open',
  ),
  // 7
  _seed(
    'Cannot change my profile photo',
    'closed',
    replies: [_c('You can pick a new photo from Edit Profile.')],
  ),
  // 8
  _seed(
    'App language reset after update',
    'open',
    replies: [_c('Could you tell us which update you installed?')],
  ),
  // 9
  _seed(
    'Notification badge never clears',
    'in_progress',
    replies: [
      _s('The dot stays on the bell even after I open the list.'),
      _c('Thanks. We can see this and are working on it.'),
    ],
  ),
  // 10
  _seed('Lecture list is empty for one subject', 'pending'),
  // 11
  _seed(
    'Quiz result screen is blank',
    'closed',
    replies: [
      _s('After the last question the result screen is empty.'),
      _c('This was fixed in the latest version. Please update the app.'),
    ],
  ),
  // 12
  _seed('Streak count looks wrong', 'open'),
  // 13
  _seed('Wrong subject shown on Home', 'closed'),
  // 14 - a multi-line opening text and a student-last thread.
  _seed(
    'Dark mode text is hard to read',
    'open',
    details:
        'Some grey text is hard to read in dark mode.\n'
        'It is worst on the quiz screen.',
    replies: [
      _s('Here is another example, on the settings screen.'),
      _c('Thanks, we have added it to the list.'),
      _s('Great, thank you.'),
    ],
  ),
  // 15
  _seed(
    'Cannot sign in on a second phone',
    'in_progress',
    replies: [_c('Only one device can be signed in at a time.')],
  ),
  // 16
  _seed(
    'Flashcard deck missing a lecture',
    'pending',
    replies: [
      _s('Lecture 4 has no flashcards.'),
      _c('Thanks. We have asked the content team.'),
    ],
  ),
  // 17
  _seed(
    'Typo in a question',
    'closed',
    replies: [_c('Thank you, the question has been corrected.')],
  ),
  // 18
  _seed('Leaderboard shows an old rank', 'open'),
  // 19
  _seed('Mistakes list not updating', 'in_progress'),
  // 20
  _seed(
    'Progress bar stuck at zero',
    'closed',
    replies: [
      _s('The bar does not move after I finish a lesson.'),
      _c('This is fixed. Please restart the app.'),
    ],
  ),
  // 21
  _seed(
    'Sound effects too loud',
    'open',
    replies: [_c('There is a sound switch in Settings.')],
  ),
  // 22
  _seed('How do I change my school?', 'closed'),
];
