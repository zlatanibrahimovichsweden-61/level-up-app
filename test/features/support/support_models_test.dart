import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/support/models/support_models.dart';

import 'support_fixtures.dart';

/// The three wire shapes of the support tickets (`openapi.yaml:3931-3982`).
///
/// What matters most is the contract's tolerance rule: an UNKNOWN `status` must
/// parse, and must read as "in progress - not closed". A generated enum would
/// turn the first status Customer Service adds into a parse failure for the
/// whole ticket list.
void main() {
  group('SupportTicketStatus', () {
    test('the four contract values parse to their members', () {
      expect(SupportTicketStatus.tryParse('open'), SupportTicketStatus.open);
      expect(
        SupportTicketStatus.tryParse('in_progress'),
        SupportTicketStatus.inProgress,
      );
      expect(
        SupportTicketStatus.tryParse('pending'),
        SupportTicketStatus.pending,
      );
      expect(
        SupportTicketStatus.tryParse('closed'),
        SupportTicketStatus.closed,
      );
    });

    test('wire values are the contract spellings', () {
      expect(SupportTicketStatus.values.map((s) => s.wire), [
        'open',
        'in_progress',
        'pending',
        'closed',
      ]);
    });

    test('anything else is null and never throws', () {
      for (final value in <String?>[
        null,
        '',
        'escalated',
        'Closed',
        'CLOSED',
        ' closed',
        'closed ',
        'inProgress',
      ]) {
        expect(SupportTicketStatus.tryParse(value), isNull, reason: '$value');
      }
    });
  });

  group('SupportTicketSummary', () {
    test('decodes the six contract fields', () {
      final t = SupportTicketSummary.fromJson(
        wireSummary(
          ticketId: ticketIdB,
          reference: 'TK-123',
          subject: 'Cannot access Biology quiz',
          status: 'in_progress',
          createdAt: '2026-10-08T09:30:00Z',
          lastActivityAt: '2026-10-09T10:15:00Z',
        ),
      );

      expect(t.ticketId, ticketIdB);
      expect(t.reference, 'TK-123');
      expect(t.subject, 'Cannot access Biology quiz');
      expect(t.status, 'in_progress');
      expect(t.createdAt, DateTime.utc(2026, 10, 8, 9, 30));
      expect(t.lastActivityAt, DateTime.utc(2026, 10, 9, 10, 15));
      expect(t.knownStatus, SupportTicketStatus.inProgress);
      expect(t.isClosed, isFalse);
    });

    for (final key in [
      'ticketId',
      'reference',
      'subject',
      'status',
      'createdAt',
      'lastActivityAt',
    ]) {
      test('a missing required "$key" throws', () {
        final json = wireSummary()..remove(key);

        expect(() => SupportTicketSummary.fromJson(json), throwsA(anything));
      });
    }

    test('a wrong-typed field throws', () {
      expect(
        () => SupportTicketSummary.fromJson(wireSummary()..['subject'] = 7),
        throwsA(anything),
      );
      expect(
        () => SupportTicketSummary.fromJson(
          wireSummary()..['createdAt'] = 'not a date',
        ),
        throwsA(anything),
      );
    });

    test('an UNKNOWN status parses, is kept verbatim, and is not closed', () {
      final t = SupportTicketSummary.fromJson(wireSummary(status: 'escalated'));

      expect(t.status, 'escalated');
      expect(t.knownStatus, isNull);
      expect(t.isClosed, isFalse);
    });

    test('only the exact value "closed" is closed', () {
      expect(
        SupportTicketSummary.fromJson(wireSummary(status: 'closed')).isClosed,
        isTrue,
      );
      for (final status in ['open', 'in_progress', 'pending', 'Closed', '']) {
        expect(
          SupportTicketSummary.fromJson(wireSummary(status: status)).isClosed,
          isFalse,
          reason: status,
        );
      }
    });

    test('unknown extra keys are ignored', () {
      final json = wireSummary()
        ..['category'] = 'billing'
        ..['assignee'] = 'someone';

      expect(() => SupportTicketSummary.fromJson(json), returnsNormally);
    });
  });

  group('SupportTicket', () {
    test('decodes an open ticket with closedAt null', () {
      final t = SupportTicket.fromJson(
        wireTicket(
          reference: 'TK-5',
          details: 'The opening text\nover two lines',
        ),
      );

      expect(t.details, 'The opening text\nover two lines');
      expect(t.closedAt, isNull);
      expect(t.isClosed, isFalse);
      expect(t.knownStatus, SupportTicketStatus.open);
    });

    test('decodes a closed ticket with its closedAt', () {
      final t = SupportTicket.fromJson(
        wireTicket(status: 'closed', closedAt: '2026-10-09T14:00:00Z'),
      );

      expect(t.closedAt, DateTime.utc(2026, 10, 9, 14));
      expect(t.isClosed, isTrue);
    });

    test('closedAt may be explicitly null on the wire', () {
      final json = wireTicket();
      expect(json.containsKey('closedAt'), isTrue);
      expect(json['closedAt'], isNull);

      expect(SupportTicket.fromJson(json).closedAt, isNull);
    });

    for (final key in [
      'ticketId',
      'reference',
      'subject',
      'details',
      'status',
      'createdAt',
      'lastActivityAt',
    ]) {
      test('a missing required "$key" throws', () {
        final json = wireTicket()..remove(key);

        expect(() => SupportTicket.fromJson(json), throwsA(anything));
      });
    }

    test('an UNKNOWN status parses and is not closed', () {
      final t = SupportTicket.fromJson(wireTicket(status: 'waiting_on_you'));

      expect(t.status, 'waiting_on_you');
      expect(t.knownStatus, isNull);
      expect(t.isClosed, isFalse);
    });

    test('attachments are not modelled: the wire array is ignored', () {
      final json = wireTicket()
        ..['attachments'] = [
          {'attachmentId': 'x', 'anything': 'at all'},
        ];

      expect(() => SupportTicket.fromJson(json), returnsNormally);
      expect(
        SupportTicket.fromJson(json).toJson().keys,
        isNot(contains('attachments')),
      );
    });

    test('round-trips through toJson', () {
      final t = SupportTicket.fromJson(
        wireTicket(status: 'closed', closedAt: '2026-10-09T14:00:00Z'),
      );

      expect(SupportTicket.fromJson(t.toJson()), t);
    });
  });

  group('SupportTicketMessage', () {
    test('a student reply', () {
      final m = SupportTicketMessage.fromJson(wireMessage());

      expect(m.messageId, '5d000000-0000-4000-8000-000000000001');
      expect(m.authorKind, 'student');
      expect(m.body, 'Sample reply');
      expect(m.createdAt, DateTime.utc(2026, 10, 9, 13));
      expect(m.isStudent, isTrue);
    });

    test('a staff reply is not the student', () {
      expect(
        SupportTicketMessage.fromJson(
          wireMessage(authorKind: 'staff'),
        ).isStudent,
        isFalse,
      );
    });

    test('an UNKNOWN authorKind is not the student', () {
      for (final kind in ['bot', 'Student', 'STUDENT', ' student', '']) {
        final m = SupportTicketMessage.fromJson(wireMessage(authorKind: kind));

        expect(m.authorKind, kind);
        expect(m.isStudent, isFalse, reason: "'$kind'");
      }
    });

    test('an EMPTY body decodes (a photo-only reply from another client)', () {
      final m = SupportTicketMessage.fromJson(wireMessage(body: ''));

      expect(m.body, isEmpty);
    });

    for (final key in ['messageId', 'authorKind', 'body', 'createdAt']) {
      test('a missing required "$key" throws', () {
        final json = wireMessage()..remove(key);

        expect(() => SupportTicketMessage.fromJson(json), throwsA(anything));
      });
    }

    test('attachments are not modelled: the wire array is ignored', () {
      final json = wireMessage()
        ..['attachments'] = [
          {'attachmentId': 'x'},
        ];

      expect(() => SupportTicketMessage.fromJson(json), returnsNormally);
    });
  });

  group('inside the CursorPage envelope', () {
    test('a page of tickets keeps hasMore and the opaque cursor', () {
      final page = CursorPage<SupportTicketSummary>.fromJson(
        {
          'items': [
            wireSummary(ticketId: ticketIdA, status: 'closed'),
            wireSummary(ticketId: ticketIdB, status: 'escalated'),
          ],
          'nextCursor': 'b3BhcXVl',
          'hasMore': true,
        },
        (json) => SupportTicketSummary.fromJson(json! as Map<String, dynamic>),
      );

      expect(page.items.map((t) => t.isClosed), [true, false]);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'b3BhcXVl');
    });

    test('a page of messages with a null cursor is the last page', () {
      final page = CursorPage<SupportTicketMessage>.fromJson(
        {
          'items': [wireMessage()],
          'nextCursor': null,
          'hasMore': false,
        },
        (json) => SupportTicketMessage.fromJson(json! as Map<String, dynamic>),
      );

      expect(page.items, hasLength(1));
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });
  });
}
