import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_support.dart';
import 'package:level_up_app/features/support/models/support_models.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';

/// The five text-only support operations, served by the on-device mock.
///
/// The harness is the only place the support screens can be walked with more
/// than one page, every status, a 25-reply thread, a closed ticket and the
/// error paths: the staging account has no tickets. So these pin what the
/// contract specifies - the list order, pages of 20, an opaque cursor, one 404
/// for an unknown id, the create limits and the daily 429, the closed-ticket
/// 409, a reply that moves its ticket to the top - and drive it through the
/// REAL [SupportRepository], which also proves the requests the app builds are
/// the ones the mock understands.
///
/// Every test gets a FRESH interceptor (`buildMockDio` per session), so no
/// create or reply leaks from one test to the next.
void main() {
  group('GET /support/tickets - paging and order', () {
    test(
      '22 tickets page 20 / 2 by cursor, and hasMore says when to stop',
      () async {
        final s = _Session();

        final first = await s.repo.listMySupportTickets();
        expect(first.items, hasLength(20));
        expect(first.hasMore, isTrue);
        expect(first.nextCursor, isNotNull);

        final second = await s.repo.listMySupportTickets(
          cursor: first.nextCursor,
        );
        expect(second.items, hasLength(2));
        expect(second.hasMore, isFalse);
        expect(second.nextCursor, isNull);

        // One contiguous run, nothing repeated or skipped.
        expect([...first.items, ...second.items].map((t) => t.ticketId), [
          for (var n = 1; n <= kMockSupportTicketCount; n++)
            mockSupportTicketId(n),
        ]);
      },
    );

    test('most recently active first, ties by ticketId descending', () async {
      final s = _Session();

      final all = await s.allTickets();

      for (var i = 1; i < all.length; i++) {
        final a = all[i - 1];
        final b = all[i];
        final byActivity = b.lastActivityAt.compareTo(a.lastActivityAt);
        expect(
          byActivity < 0 ||
              (byActivity == 0 && b.ticketId.compareTo(a.ticketId) < 0),
          isTrue,
          reason: 'row $i',
        );
      }
    });

    test('references run TK-1001 (oldest) to TK-1022 (newest)', () async {
      final s = _Session();

      final all = await s.allTickets();

      expect(all.first.reference, 'TK-1022');
      expect(all.last.reference, 'TK-1001');
      expect(all.map((t) => t.reference).toSet(), hasLength(22));
      expect(all.map((t) => t.reference), everyElement(startsWith('TK-')));
    });

    test('timestamps are fixed UTC instants in 2026-09 / 2026-10', () async {
      final s = _Session();

      final all = await s.allTickets();

      for (final t in all) {
        expect(t.createdAt.isUtc, isTrue);
        expect(t.lastActivityAt.isUtc, isTrue);
        expect(t.createdAt.isAfter(DateTime.utc(2026, 9)), isTrue);
        expect(t.lastActivityAt.isBefore(DateTime.utc(2026, 11)), isTrue);
        expect(t.lastActivityAt.isBefore(t.createdAt), isFalse);
      }
    });

    test('the statuses cover all four known values and one the app does not '
        'know', () async {
      final s = _Session();

      final all = await s.allTickets();

      expect(all.map((t) => t.status).toSet(), {
        'open',
        'in_progress',
        'pending',
        'closed',
        'escalated',
      });
      final unknown = all.firstWhere((t) => t.status == 'escalated');
      expect(
        unknown.ticketId,
        mockSupportTicketId(kMockSupportUnknownStatusTicket),
      );
      expect(unknown.knownStatus, isNull);
      expect(unknown.isClosed, isFalse);
      expect(all.where((t) => t.isClosed), isNotEmpty);
    });

    test('the frame samples are in the list', () async {
      final s = _Session();

      final subjects = (await s.allTickets()).map((t) => t.subject);

      expect(subjects, contains('Cannot access Biology quiz'));
      expect(subjects, contains('Points not credited after quiz'));
    });

    test('one subject runs close to the 120-character limit', () async {
      final s = _Session();

      final lengths = (await s.allTickets()).map((t) => t.subject.length);

      expect(
        lengths.reduce((a, b) => a > b ? a : b),
        inInclusiveRange(100, 120),
      );
    });

    test('the wire shape is the six contract fields', () async {
      final s = _Session();

      final res = await s.dio.get<Map<String, dynamic>>('/support/tickets');

      final body = res.data!;
      expect(body.keys, containsAll(['items', 'nextCursor', 'hasMore']));
      for (final raw in body['items'] as List<dynamic>) {
        final item = raw as Map<String, dynamic>;
        expect(item.keys.toSet(), {
          'ticketId',
          'reference',
          'subject',
          'status',
          'createdAt',
          'lastActivityAt',
        });
        expect(DateTime.parse(item['createdAt'] as String).isUtc, isTrue);
      }
    });

    test(
      'the request carries no limit and the mock does not need one',
      () async {
        final s = _Session();

        final res = await s.dio.get<Map<String, dynamic>>('/support/tickets');

        expect((res.data!['items'] as List<dynamic>), hasLength(20));
      },
    );
  });

  group('GET /support/tickets - cursor', () {
    test(
      'a malformed cursor is 400 validation_failed on field cursor',
      () async {
        final s = _Session();

        for (final cursor in ['not-a-cursor', '!!!', '', 'aGVsbG8=']) {
          final e = await _rejection(
            s.repo.listMySupportTickets(cursor: cursor),
          );

          expect(e, isA<ValidationException>(), reason: "'$cursor'");
          expect((e as ValidationException).fields, ['cursor']);
        }
      },
    );

    test('a cursor issued for a thread is not a ticket-list cursor', () async {
      final s = _Session();
      final page = await s.repo.listMySupportTicketMessages(
        mockSupportTicketId(kMockSupportLongThreadTicket),
      );
      expect(page.nextCursor, isNotNull);

      final e = await _rejection(
        s.repo.listMySupportTickets(cursor: page.nextCursor),
      );

      expect(e, isA<ValidationException>());
    });

    test(
      'a ticket that moves to the top between pages cannot repeat a row',
      () async {
        final s = _Session();
        final first = await s.repo.listMySupportTickets();
        // Replies land between the two page loads: one on a ticket page one
        // already showed (19), one on a ticket that was waiting on page two
        // (21). Both jump to the top of the list.
        await s.repo.postMySupportTicketMessage(mockSupportTicketId(19), 'a');
        await s.repo.postMySupportTicketMessage(mockSupportTicketId(21), 'b');

        final second = await s.repo.listMySupportTickets(
          cursor: first.nextCursor,
        );

        // Page two resumes after the row the cursor named: neither mover is
        // served again, and nothing that was still waiting is skipped.
        expect(second.items.map((t) => t.ticketId), [mockSupportTicketId(22)]);
        expect(second.hasMore, isFalse);
      },
    );
  });

  group('GET /support/tickets/{ticketId}', () {
    test(
      'an open ticket: details, closedAt null, the contract fields',
      () async {
        final s = _Session();

        final t = await s.repo.getMySupportTicket(mockSupportTicketId(1));

        expect(t.subject, 'Points not credited after quiz');
        expect(t.details, isNotEmpty);
        expect(t.status, 'open');
        expect(t.closedAt, isNull);
        expect(t.reference, 'TK-1022');
      },
    );

    test('a closed ticket carries its closedAt', () async {
      final s = _Session();
      final closed = (await s.allTickets()).firstWhere((t) => t.isClosed);

      final t = await s.repo.getMySupportTicket(closed.ticketId);

      expect(t.isClosed, isTrue);
      expect(t.closedAt, isNotNull);
      expect(t.closedAt!.isUtc, isTrue);
    });

    test(
      'the wire shape is the nine contract fields, attachments empty',
      () async {
        final s = _Session();

        final res = await s.dio.get<Map<String, dynamic>>(
          '/support/tickets/${mockSupportTicketId(4)}',
        );

        final body = res.data!;
        expect(body.keys.toSet(), {
          'ticketId',
          'reference',
          'subject',
          'details',
          'status',
          'createdAt',
          'lastActivityAt',
          'closedAt',
          'attachments',
        });
        expect(body['attachments'], isEmpty);
        expect(body['closedAt'], isNotNull);
      },
    );

    test('an unknown id is 404 not_found', () async {
      final s = _Session();

      final e = await _rejection(
        s.repo.getMySupportTicket(mockSupportTicketId(999)),
      );

      expect(e, isA<ApiException>());
      expect((e as ApiException).status, 404);
      expect(e.code, 'not_found');
    });

    test('a malformed id is the same 404', () async {
      final s = _Session();

      for (final id in ['nope', '123', 'a/b', '']) {
        final e = await _rejection(s.repo.getMySupportTicket(id));

        expect((e as ApiException).status, 404, reason: "'$id'");
      }
    });
  });

  group('GET /support/tickets/{ticketId}/messages', () {
    final long = mockSupportTicketId(kMockSupportLongThreadTicket);

    test(
      'the long thread has 25 replies: pages of 20 then 5, oldest first',
      () async {
        final s = _Session();

        final first = await s.repo.listMySupportTicketMessages(long);
        expect(first.items, hasLength(20));
        expect(first.hasMore, isTrue);
        final second = await s.repo.listMySupportTicketMessages(
          long,
          cursor: first.nextCursor,
        );
        expect(second.items, hasLength(5));
        expect(second.hasMore, isFalse);
        expect(second.nextCursor, isNull);

        final all = [...first.items, ...second.items];
        expect(all.map((m) => m.messageId).toSet(), hasLength(25));
        for (var i = 1; i < all.length; i++) {
          expect(
            all[i].createdAt.isAfter(all[i - 1].createdAt),
            isTrue,
            reason: 'reply $i',
          );
        }
        expect(all.first.body, contains('1 in a long thread'));
        expect(all.last.body, contains('25 in a long thread'));
      },
    );

    test('replies mix student and staff', () async {
      final s = _Session();

      final page = await s.repo.listMySupportTicketMessages(long);

      expect(page.items.map((m) => m.isStudent).toSet(), {true, false});
      expect(page.items.map((m) => m.authorKind).toSet(), {'student', 'staff'});
    });

    test('a ticket with no replies answers an empty, final page', () async {
      final s = _Session();

      final page = await s.repo.listMySupportTicketMessages(
        mockSupportTicketId(1),
      );

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('other tickets hold 0 to 3 replies', () async {
      final s = _Session();

      for (var n = 1; n <= kMockSupportTicketCount; n++) {
        if (n == kMockSupportLongThreadTicket) continue;
        final page = await s.repo.listMySupportTicketMessages(
          mockSupportTicketId(n),
        );
        expect(page.items.length, inInclusiveRange(0, 3), reason: 'ticket $n');
        expect(page.hasMore, isFalse);
      }
    });

    test(
      'the wire shape is the five contract fields, attachments empty',
      () async {
        final s = _Session();

        final res = await s.dio.get<Map<String, dynamic>>(
          '/support/tickets/$long/messages',
        );

        for (final raw in res.data!['items'] as List<dynamic>) {
          final item = raw as Map<String, dynamic>;
          expect(item.keys.toSet(), {
            'messageId',
            'authorKind',
            'body',
            'createdAt',
            'attachments',
          });
          expect(item['attachments'], isEmpty);
          expect(item['authorKind'], anyOf('student', 'staff'));
        }
      },
    );

    test('the opening text is NOT a message', () async {
      final s = _Session();
      final ticket = await s.repo.getMySupportTicket(long);

      final page = await s.repo.listMySupportTicketMessages(long);

      expect(page.items.map((m) => m.body), isNot(contains(ticket.details)));
    });

    test('an unknown ticket is 404 not_found', () async {
      final s = _Session();

      final e = await _rejection(
        s.repo.listMySupportTicketMessages(mockSupportTicketId(999)),
      );

      expect((e as ApiException).status, 404);
      expect(e.code, 'not_found');
    });

    test(
      'a malformed cursor is 400 validation_failed on field cursor',
      () async {
        final s = _Session();

        final e = await _rejection(
          s.repo.listMySupportTicketMessages(long, cursor: 'garbage'),
        );

        expect(e, isA<ValidationException>());
        expect((e as ValidationException).fields, ['cursor']);
      },
    );

    test("another ticket's cursor is not this ticket's cursor", () async {
      final s = _Session();
      final page = await s.repo.listMySupportTicketMessages(long);

      final e = await _rejection(
        s.repo.listMySupportTicketMessages(
          mockSupportTicketId(4),
          cursor: page.nextCursor,
        ),
      );

      expect(e, isA<ValidationException>());
    });
  });

  group('POST /support/tickets', () {
    test('creates an open ticket that appears first in the list', () async {
      final s = _Session();

      final t = await s.repo.createSupportTicket(
        subject: 'My new ticket',
        details: 'Some details',
      );

      expect(t.subject, 'My new ticket');
      expect(t.details, 'Some details');
      expect(t.status, 'open');
      expect(t.closedAt, isNull);
      expect(t.reference, 'TK-1023', reason: 'the next TK number');
      expect(t.createdAt, t.lastActivityAt);
      expect(t.createdAt.isUtc, isTrue);

      final first = await s.repo.listMySupportTickets();
      expect(first.items.first.ticketId, t.ticketId);
      expect(first.items.first.reference, 'TK-1023');
      expect(first.items, hasLength(20));
      final second = await s.repo.listMySupportTickets(
        cursor: first.nextCursor,
      );
      expect(second.items, hasLength(3));
    });

    test('it can then be read and replied to', () async {
      final s = _Session();
      final t = await s.repo.createSupportTicket(subject: 'S', details: 'D');

      final read = await s.repo.getMySupportTicket(t.ticketId);
      final reply = await s.repo.postMySupportTicketMessage(t.ticketId, 'more');
      final thread = await s.repo.listMySupportTicketMessages(t.ticketId);

      expect(read.details, 'D');
      expect(thread.items.single.messageId, reply.messageId);
    });

    test('references keep counting', () async {
      final s = _Session();

      final a = await s.repo.createSupportTicket(subject: 'A', details: 'D');
      final b = await s.repo.createSupportTicket(subject: 'B', details: 'D');

      expect([a.reference, b.reference], ['TK-1023', 'TK-1024']);
      expect(
        (await s.repo.listMySupportTickets()).items.first.ticketId,
        b.ticketId,
      );
    });

    test('subject and details are stored TRIMMED', () async {
      final s = _Session();

      final t = await s.repo.createSupportTicket(
        subject: '  Padded subject \n',
        details: '\n Padded details  ',
      );

      expect(t.subject, 'Padded subject');
      expect(t.details, 'Padded details');
    });

    test('the response wire shape has the nine contract fields', () async {
      final s = _Session();

      final res = await s.dio.post<Map<String, dynamic>>(
        '/support/tickets',
        data: {'subject': 'S', 'details': 'D'},
      );

      expect(res.statusCode, 201);
      expect(res.data!.keys.toSet(), {
        'ticketId',
        'reference',
        'subject',
        'details',
        'status',
        'createdAt',
        'lastActivityAt',
        'closedAt',
        'attachments',
      });
      expect(res.data!['closedAt'], isNull);
      expect(res.data!['attachments'], isEmpty);
    });

    group('validation - 400 validation_failed with a field map', () {
      Future<List<String>> failedFields(
        _Session s, {
        Object? subject,
        Object? details,
      }) async {
        final e = await _rejection(
          s.dio.post<Object?>(
            '/support/tickets',
            data: {'subject': ?subject, 'details': ?details},
          ),
        );
        expect(e, isA<ValidationException>());
        return (e as ValidationException).fields.toList()..sort();
      }

      test('an empty or whitespace-only subject', () async {
        final s = _Session();

        expect(await failedFields(s, subject: '', details: 'D'), ['subject']);
        expect(await failedFields(s, subject: '  \n ', details: 'D'), [
          'subject',
        ]);
      });

      test('an empty or whitespace-only details', () async {
        final s = _Session();

        expect(await failedFields(s, subject: 'S', details: ''), ['details']);
        expect(await failedFields(s, subject: 'S', details: ' \t '), [
          'details',
        ]);
      });

      test('both bad: both fields are named', () async {
        final s = _Session();

        expect(await failedFields(s, subject: '', details: ''), [
          'details',
          'subject',
        ]);
      });

      test('missing keys and non-string values', () async {
        final s = _Session();

        expect(await failedFields(s), ['details', 'subject']);
        expect(await failedFields(s, subject: 5, details: 'D'), ['subject']);
        expect(await failedFields(s, subject: 'S', details: <String>[]), [
          'details',
        ]);
      });

      test(
        'subject: 120 characters pass, 121 do not - after trimming',
        () async {
          final s = _Session();

          expect(await failedFields(s, subject: 'a' * 121, details: 'D'), [
            'subject',
          ]);
          final ok = await s.repo.createSupportTicket(
            subject: ' ${'a' * 120} ',
            details: 'D',
          );
          expect(ok.subject, hasLength(120));
        },
      );

      test(
        'details: 4000 characters pass, 4001 do not - after trimming',
        () async {
          final s = _Session();

          expect(await failedFields(s, subject: 'S', details: 'b' * 4001), [
            'details',
          ]);
          final ok = await s.repo.createSupportTicket(
            subject: 'S',
            details: '\n${'b' * 4000}\n',
          );
          expect(ok.details, hasLength(4000));
        },
      );

      test('a rejected create writes nothing and spends no budget', () async {
        final s = _Session();

        for (var i = 0; i < 8; i++) {
          await failedFields(s, subject: '', details: 'D');
        }
        for (var i = 0; i < kMockSupportCreateLimit; i++) {
          await s.repo.createSupportTicket(subject: 'S$i', details: 'D');
        }

        expect(
          (await s.allTickets()),
          hasLength(kMockSupportTicketCount + kMockSupportCreateLimit),
        );
      });
    });

    group('the daily limit - 429 rate_limited', () {
      test('5 creates per session, then 429 with Retry-After', () async {
        final s = _Session();
        // The contract: "at most 5 ticket creates per student per day"
        // (`openapi.yaml:2700`) - the literal, not the mock's own constant.
        expect(kMockSupportCreateLimit, 5);
        for (var i = 1; i <= 5; i++) {
          await s.repo.createSupportTicket(subject: 'S$i', details: 'D');
        }

        final e = await _rejection(
          s.repo.createSupportTicket(subject: 'one too many', details: 'D'),
        );

        expect(e, isA<RateLimitedException>());
        expect(
          (e as RateLimitedException).retryAfter,
          const Duration(seconds: kMockSupportRetryAfterSeconds),
          reason: 'the header reaches the real ErrorInterceptor parser',
        );
      });

      test('the refused create writes nothing', () async {
        final s = _Session();
        for (var i = 1; i <= kMockSupportCreateLimit; i++) {
          await s.repo.createSupportTicket(subject: 'S$i', details: 'D');
        }

        await _rejection(
          s.repo.createSupportTicket(subject: 'one too many', details: 'D'),
        );

        final all = await s.allTickets();
        expect(
          all,
          hasLength(kMockSupportTicketCount + kMockSupportCreateLimit),
        );
        expect(all.map((t) => t.subject), isNot(contains('one too many')));
      });

      test('it stays 429 for every later create, valid or not', () async {
        final s = _Session();
        for (var i = 1; i <= kMockSupportCreateLimit; i++) {
          await s.repo.createSupportTicket(subject: 'S$i', details: 'D');
        }

        for (final subject in ['again', '']) {
          final e = await _rejection(
            s.repo.createSupportTicket(subject: subject, details: 'D'),
          );
          expect(e, isA<RateLimitedException>(), reason: "'$subject'");
        }
      });

      test('replies have their own budget: a reply still works', () async {
        final s = _Session();
        for (var i = 1; i <= kMockSupportCreateLimit; i++) {
          await s.repo.createSupportTicket(subject: 'S$i', details: 'D');
        }

        final m = await s.repo.postMySupportTicketMessage(
          mockSupportTicketId(1),
          'still here',
        );

        expect(m.body, 'still here');
      });

      test('a new session starts with a fresh budget', () async {
        final first = _Session();
        for (var i = 1; i <= kMockSupportCreateLimit; i++) {
          await first.repo.createSupportTicket(subject: 'S$i', details: 'D');
        }

        final second = _Session();
        final t = await second.repo.createSupportTicket(
          subject: 'fresh',
          details: 'D',
        );

        expect(t.reference, 'TK-1023');
        expect(
          await second.allTickets(),
          hasLength(kMockSupportTicketCount + 1),
        );
      });
    });
  });

  group('POST /support/tickets/{ticketId}/messages', () {
    test('creates a student reply, appended last in the thread', () async {
      final s = _Session();
      final id = mockSupportTicketId(3);
      final before = await s.repo.listMySupportTicketMessages(id);

      final m = await s.repo.postMySupportTicketMessage(id, 'My reply');

      expect(m.isStudent, isTrue);
      expect(m.body, 'My reply');
      expect(m.createdAt.isUtc, isTrue);
      final after = await s.repo.listMySupportTicketMessages(id);
      expect(after.items, hasLength(before.items.length + 1));
      expect(after.items.last.messageId, m.messageId);
      expect(
        after.items.last.createdAt.isAfter(before.items.last.createdAt),
        isTrue,
      );
    });

    test('the body is stored TRIMMED', () async {
      final s = _Session();

      final m = await s.repo.postMySupportTicketMessage(
        mockSupportTicketId(1),
        '  padded \n',
      );

      expect(m.body, 'padded');
    });

    test('the ticket moves to the top and its lastActivityAt is the reply\'s '
        'createdAt', () async {
      final s = _Session();
      final id = mockSupportTicketId(12);
      expect(
        (await s.repo.listMySupportTickets()).items.first.ticketId,
        isNot(id),
      );

      final m = await s.repo.postMySupportTicketMessage(id, 'bump');

      final first = (await s.repo.listMySupportTickets()).items.first;
      expect(first.ticketId, id);
      expect(first.lastActivityAt, m.createdAt);
      expect((await s.repo.getMySupportTicket(id)).lastActivityAt, m.createdAt);
      expect(
        (await s.allTickets()).map((t) => t.ticketId).toSet(),
        hasLength(kMockSupportTicketCount),
        reason: 'moved, not duplicated',
      );
    });

    test(
      'a reply on the long thread makes it 26: pages of 20 then 6',
      () async {
        final s = _Session();
        final id = mockSupportTicketId(kMockSupportLongThreadTicket);

        await s.repo.postMySupportTicketMessage(id, 'one more');

        final first = await s.repo.listMySupportTicketMessages(id);
        final second = await s.repo.listMySupportTicketMessages(
          id,
          cursor: first.nextCursor,
        );
        expect(first.items, hasLength(20));
        expect(second.items, hasLength(6));
        expect(second.items.last.body, 'one more');
      },
    );

    test('the response wire shape has the five contract fields', () async {
      final s = _Session();

      final res = await s.dio.post<Map<String, dynamic>>(
        '/support/tickets/${mockSupportTicketId(1)}/messages',
        data: {'body': 'hi'},
      );

      expect(res.statusCode, 201);
      expect(res.data!.keys.toSet(), {
        'messageId',
        'authorKind',
        'body',
        'createdAt',
        'attachments',
      });
      expect(res.data!['authorKind'], 'student');
    });

    test(
      'a ticket whose status the app does not know still takes replies',
      () async {
        final s = _Session();

        final m = await s.repo.postMySupportTicketMessage(
          mockSupportTicketId(kMockSupportUnknownStatusTicket),
          'hello',
        );

        expect(m.body, 'hello');
      },
    );

    test(
      'a closed ticket is 409 ticket_closed and nothing is written',
      () async {
        final s = _Session();
        final closed = (await s.allTickets()).firstWhere((t) => t.isClosed);
        final before = await s.repo.listMySupportTicketMessages(
          closed.ticketId,
        );

        final e = await _rejection(
          s.repo.postMySupportTicketMessage(closed.ticketId, 'too late'),
        );

        expect(e, isA<ApiException>());
        expect((e as ApiException).status, 409);
        expect(e.code, 'ticket_closed');
        final after = await s.repo.listMySupportTicketMessages(closed.ticketId);
        expect(after.items, hasLength(before.items.length));
        expect(
          (await s.repo.getMySupportTicket(closed.ticketId)).lastActivityAt,
          closed.lastActivityAt,
        );
      },
    );

    test('the closed check comes before the content check', () async {
      final s = _Session();
      final closed = (await s.allTickets()).firstWhere((t) => t.isClosed);

      final e = await _rejection(
        s.dio.post<Object?>(
          '/support/tickets/${closed.ticketId}/messages',
          data: {'body': ''},
        ),
      );

      expect((e as ApiException).code, 'ticket_closed');
    });

    test('an unknown ticket is 404 not_found', () async {
      final s = _Session();

      final e = await _rejection(
        s.repo.postMySupportTicketMessage(mockSupportTicketId(999), 'hello'),
      );

      expect((e as ApiException).status, 404);
      expect(e.code, 'not_found');
    });

    group('validation - 400 validation_failed on field body', () {
      Future<void> expectBodyRejected(_Session s, Object? body) async {
        final e = await _rejection(
          s.dio.post<Object?>(
            '/support/tickets/${mockSupportTicketId(1)}/messages',
            data: {'body': ?body},
          ),
        );
        expect(e, isA<ValidationException>(), reason: '$body');
        expect((e as ValidationException).fields, ['body']);
      }

      test('empty, whitespace-only, missing and non-string', () async {
        final s = _Session();

        await expectBodyRejected(s, '');
        await expectBodyRejected(s, '  \n\t ');
        await expectBodyRejected(s, null);
        await expectBodyRejected(s, 42);
      });

      test('4000 characters pass, 4001 do not - after trimming', () async {
        final s = _Session();

        await expectBodyRejected(s, 'c' * 4001);
        final ok = await s.repo.postMySupportTicketMessage(
          mockSupportTicketId(1),
          ' ${'c' * 4000} ',
        );
        expect(ok.body, hasLength(4000));
      });

      test('a rejected reply writes nothing', () async {
        final s = _Session();
        final id = mockSupportTicketId(3);
        final before = await s.repo.listMySupportTicketMessages(id);
        final top = (await s.repo.listMySupportTickets()).items.first.ticketId;

        await expectBodyRejected(s, '');

        expect(
          (await s.repo.listMySupportTicketMessages(id)).items,
          hasLength(before.items.length),
        );
        expect((await s.repo.listMySupportTickets()).items.first.ticketId, top);
      });
    });
  });

  group('the fixtures are neutral sample data', () {
    test('no e-mail address and no phone-like number anywhere', () async {
      final s = _Session();
      final texts = <String>[];
      for (final t in await s.allTickets()) {
        texts.addAll([t.subject, t.reference]);
        final full = await s.repo.getMySupportTicket(t.ticketId);
        texts.add(full.details);
        for (final m in (await s.allMessages(t.ticketId))) {
          texts.add(m.body);
        }
      }

      expect(texts, isNotEmpty);
      for (final text in texts) {
        expect(text, isNot(contains('@')), reason: text);
        expect(RegExp(r'\d{7,}').hasMatch(text), isFalse, reason: text);
        expect(text, isNot(contains('+')), reason: text);
      }
    });

    test('ids follow the 5c / 5d UUID shapes', () async {
      final s = _Session();
      final ticketShape = RegExp(r'^5c000000-0000-4000-8000-[0-9a-f]{12}$');
      final messageShape = RegExp(r'^5d000000-0000-4000-8000-[0-9a-f]{12}$');

      for (final t in await s.allTickets()) {
        expect(t.ticketId, matches(ticketShape));
        for (final m in await s.allMessages(t.ticketId)) {
          expect(m.messageId, matches(messageShape));
        }
      }
    });

    test('a message id is unique across tickets', () async {
      final s = _Session();
      final ids = <String>[];
      for (final t in await s.allTickets()) {
        ids.addAll((await s.allMessages(t.ticketId)).map((m) => m.messageId));
      }

      expect(ids.toSet(), hasLength(ids.length));
    });
  });

  group('routes the mock does not serve', () {
    test('/support/attachments (photos, CW12b) falls through to the generic '
        '404', () async {
      final s = _Session();

      final e = await _rejection(
        s.dio.post<Object?>('/support/attachments', data: {'any': 'thing'}),
      );

      expect((e as ApiException).status, 404);
    });

    test('a POST on a single ticket is not an operation', () async {
      final s = _Session();

      final e = await _rejection(
        s.dio.post<Object?>(
          '/support/tickets/${mockSupportTicketId(1)}',
          data: {'subject': 'x'},
        ),
      );

      expect((e as ApiException).status, 404);
    });

    test('a DELETE and a PATCH on a ticket are not operations', () async {
      final s = _Session();
      final path = '/support/tickets/${mockSupportTicketId(1)}';

      for (final call in [
        s.dio.delete<Object?>(path),
        s.dio.patch<Object?>(path),
      ]) {
        final e = await _rejection(call);
        expect((e as ApiException).status, 404);
      }
      expect(
        (await s.repo.getMySupportTicket(mockSupportTicketId(1))).ticketId,
        mockSupportTicketId(1),
      );
    });

    test(
      'a path that merely starts with /support/tickets is not served',
      () async {
        final s = _Session();

        final e = await _rejection(s.dio.get<Object?>('/support/ticketsX'));

        expect((e as ApiException).status, 404);
      },
    );
  });

  group('sessions are independent', () {
    test(
      'a create and a reply in one session do not show in another',
      () async {
        final a = _Session();
        final b = _Session();

        await a.repo.createSupportTicket(subject: 'only in A', details: 'D');
        await a.repo.postMySupportTicketMessage(
          mockSupportTicketId(1),
          'only A',
        );

        expect(await b.allTickets(), hasLength(kMockSupportTicketCount));
        expect(
          (await b.repo.listMySupportTicketMessages(
            mockSupportTicketId(1),
          )).items,
          isEmpty,
        );
      },
    );
  });
}

/// One mock student: a fresh interceptor driven through the REAL repository.
class _Session {
  _Session() : dio = buildMockDio(latency: Duration.zero) {
    repo = SupportRepository(dio);
  }

  final Dio dio;
  late final SupportRepository repo;

  /// Every ticket, following the cursor to the end.
  Future<List<SupportTicketSummary>> allTickets() async {
    final items = <SupportTicketSummary>[];
    String? cursor;
    do {
      final page = await repo.listMySupportTickets(cursor: cursor);
      items.addAll(page.items);
      cursor = page.hasMore ? page.nextCursor : null;
    } while (cursor != null);
    return items;
  }

  /// Every reply on one ticket, following the cursor to the end.
  Future<List<SupportTicketMessage>> allMessages(String ticketId) async {
    final items = <SupportTicketMessage>[];
    String? cursor;
    do {
      final page = await repo.listMySupportTicketMessages(
        ticketId,
        cursor: cursor,
      );
      items.addAll(page.items);
      cursor = page.hasMore ? page.nextCursor : null;
    } while (cursor != null);
    return items;
  }
}

/// The mapped [AppException] behind a rejected mock call - the harness runs the
/// REAL ErrorInterceptor, so this is the type a screen would receive. A call
/// that already went through a repository rethrows the [AppException] itself.
Future<AppException> _rejection(Future<Object?> call) async {
  try {
    await call;
  } on DioException catch (e) {
    return e.error! as AppException;
  } on AppException catch (e) {
    return e;
  }
  fail('expected the mock to reject this request');
}
