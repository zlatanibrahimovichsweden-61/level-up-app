import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'support_fixtures.dart';

class _MockDio extends Mock implements Dio {}

/// The support data layer: five stable operations, text only.
///
/// The rules guarded here are the ones the contract states in PROSE and that a
/// client can silently get wrong:
/// - the list operations take NO `limit`, and the cursor is opaque - followed,
///   never built, and absent (not null) on page one;
/// - a page with `hasMore: true` is not the end, whatever its size;
/// - a create is exactly `{subject, details}` and a reply exactly `{body}`,
///   both TRIMMED, and never `attachmentIds` (photos are CW12b);
/// - failures arrive as the typed [AppException] the interceptor mapped.
void main() {
  late _MockDio dio;
  late SupportRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = SupportRepository(dio);
  });

  Response<T> response<T>(T data, {int status = 200, String path = '/x'}) =>
      Response<T>(
        requestOptions: RequestOptions(path: path),
        statusCode: status,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: '/x'),
    error: mapped,
  );

  const listPath = '/support/tickets';
  const ticketPath = '/support/tickets/$ticketIdA';
  const messagesPath = '/support/tickets/$ticketIdA/messages';

  void stubGet(String path, Map<String, dynamic> body) {
    when(
      () => dio.get<Map<String, dynamic>>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => response(body));
  }

  /// `getMySupportTicket` passes no query parameters, so its stub must not name
  /// the argument either (mocktail matches named arguments by presence).
  void stubGetPlain(String path, Map<String, dynamic> body) {
    when(
      () => dio.get<Map<String, dynamic>>(path),
    ).thenAnswer((_) async => response(body));
  }

  void stubGetPlainThrows(String path, Object error) {
    when(() => dio.get<Map<String, dynamic>>(path)).thenThrow(error);
  }

  void stubGetThrows(String path, Object error) {
    when(
      () => dio.get<Map<String, dynamic>>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenThrow(error);
  }

  Map<String, dynamic> capturedQuery(String path) =>
      verify(
            () => dio.get<Map<String, dynamic>>(
              path,
              queryParameters: captureAny(named: 'queryParameters'),
            ),
          ).captured.single
          as Map<String, dynamic>;

  void stubPost(String path, Map<String, dynamic> body, {int status = 201}) {
    when(
      () => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')),
    ).thenAnswer((_) async => response(body, status: status));
  }

  Map<String, dynamic> capturedBody(String path) =>
      verify(
            () => dio.post<Map<String, dynamic>>(
              path,
              data: captureAny(named: 'data'),
            ),
          ).captured.single
          as Map<String, dynamic>;

  group('listMySupportTickets', () {
    test('decodes a page: statuses, the envelope and the cursor', () async {
      stubGet(listPath, {
        'items': [
          wireSummary(ticketId: ticketIdA, status: 'closed'),
          wireSummary(ticketId: ticketIdB, status: 'escalated'),
        ],
        'nextCursor': 'b3BhcXVl',
        'hasMore': true,
      });

      final page = await repo.listMySupportTickets();

      expect(page.items.map((t) => t.ticketId), [ticketIdA, ticketIdB]);
      expect(page.items.map((t) => t.isClosed), [true, false]);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'b3BhcXVl');
    });

    test('an EMPTY page is a normal response, not an error', () async {
      stubGet(listPath, {'items': <dynamic>[], 'hasMore': false});

      final page = await repo.listMySupportTickets();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('a SHORT page with hasMore:true is not the end of the list', () async {
      stubGet(listPath, {
        'items': [wireSummary()],
        'nextCursor': 'opaque-keyset-token',
        'hasMore': true,
      });

      final page = await repo.listMySupportTickets();

      expect(page.items.length, lessThan(20));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'opaque-keyset-token');
    });

    test('page one sends NO query parameters at all - no limit, no '
        'cursor', () async {
      stubGet(listPath, {'items': <dynamic>[], 'hasMore': false});

      await repo.listMySupportTickets();

      // Absent, not null: `cursor: null` would be a malformed cursor (400),
      // and this operation takes no `limit`.
      expect(capturedQuery(listPath), isEmpty);
    });

    test('forwards the opaque cursor unchanged and nothing else', () async {
      stubGet(listPath, {'items': <dynamic>[], 'hasMore': false});

      await repo.listMySupportTickets(cursor: 'b3BhcXVlLWN1cnNvcj09');

      expect(capturedQuery(listPath), {'cursor': 'b3BhcXVlLWN1cnNvcj09'});
    });
  });

  group('getMySupportTicket', () {
    test('GETs the id-specific path and decodes the ticket', () async {
      stubGetPlain(
        ticketPath,
        wireTicket(status: 'closed', closedAt: '2026-10-09T14:00:00Z'),
      );

      final t = await repo.getMySupportTicket(ticketIdA);

      expect(t.ticketId, ticketIdA);
      expect(t.isClosed, isTrue);
      expect(t.closedAt, DateTime.utc(2026, 10, 9, 14));
      verify(() => dio.get<Map<String, dynamic>>(ticketPath)).called(1);
    });

    test('an unknown status decodes as not closed', () async {
      stubGetPlain(ticketPath, wireTicket(status: 'escalated'));

      final t = await repo.getMySupportTicket(ticketIdA);

      expect(t.status, 'escalated');
      expect(t.isClosed, isFalse);
    });

    test('the id is path-encoded, never interpolated raw', () async {
      when(
        () => dio.get<Map<String, dynamic>>('/support/tickets/a%2Fb'),
      ).thenAnswer((_) async => response(wireTicket()));

      await repo.getMySupportTicket('a/b');

      verify(
        () => dio.get<Map<String, dynamic>>('/support/tickets/a%2Fb'),
      ).called(1);
    });

    test('a 404 not_found surfaces as the typed ApiException', () async {
      // "unknown, malformed, or another student's" - one code for all three.
      stubGetPlainThrows(
        ticketPath,
        failure(const ApiException(status: 404, code: 'not_found')),
      );

      await expectLater(
        repo.getMySupportTicket(ticketIdA),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 404)
              .having((e) => e.code, 'code', 'not_found'),
        ),
      );
    });
  });

  group('listMySupportTicketMessages', () {
    test('GETs the messages path and decodes a page', () async {
      stubGet(messagesPath, {
        'items': [
          wireMessage(messageId: 'm-1'),
          wireMessage(messageId: 'm-2', authorKind: 'staff', body: 'Hello'),
        ],
        'nextCursor': 'next',
        'hasMore': true,
      });

      final page = await repo.listMySupportTicketMessages(ticketIdA);

      expect(page.items.map((m) => m.messageId), ['m-1', 'm-2']);
      expect(page.items.map((m) => m.isStudent), [true, false]);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'next');
    });

    test('page one sends no query parameters; later pages send only the '
        'cursor', () async {
      stubGet(messagesPath, {'items': <dynamic>[], 'hasMore': false});

      await repo.listMySupportTicketMessages(ticketIdA);
      await repo.listMySupportTicketMessages(ticketIdA, cursor: 'c2');

      final queries = verify(
        () => dio.get<Map<String, dynamic>>(
          messagesPath,
          queryParameters: captureAny(named: 'queryParameters'),
        ),
      ).captured;
      expect(queries.first, isEmpty);
      expect(queries.last, {'cursor': 'c2'});
    });

    test('follows a cursor across pages without touching it', () async {
      var call = 0;
      when(
        () => dio.get<Map<String, dynamic>>(
          messagesPath,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        call++;
        return response(
          call == 1
              ? {
                  'items': [wireMessage(messageId: 'm-1')],
                  'nextCursor': 'cursor-2',
                  'hasMore': true,
                }
              : {
                  'items': [wireMessage(messageId: 'm-2')],
                  'nextCursor': null,
                  'hasMore': false,
                },
        );
      });

      final first = await repo.listMySupportTicketMessages(ticketIdA);
      final second = await repo.listMySupportTicketMessages(
        ticketIdA,
        cursor: first.nextCursor,
      );

      expect(second.items.single.messageId, 'm-2');
      expect(second.hasMore, isFalse);
      // "Without touching it": the second call sent exactly the cursor the
      // first page handed over - page one sent none at all.
      final queries = verify(
        () => dio.get<Map<String, dynamic>>(
          messagesPath,
          queryParameters: captureAny(named: 'queryParameters'),
        ),
      ).captured;
      expect(queries, hasLength(2));
      expect(queries.first, isEmpty);
      expect(queries.last, {'cursor': 'cursor-2'});
    });

    test('an empty-body reply decodes', () async {
      stubGet(messagesPath, {
        'items': [wireMessage(body: '')],
        'hasMore': false,
      });

      final page = await repo.listMySupportTicketMessages(ticketIdA);

      expect(page.items.single.body, isEmpty);
    });
  });

  group('createSupportTicket', () {
    test('POSTs exactly {subject, details} and decodes the ticket', () async {
      stubPost(listPath, wireTicket(subject: 'S', details: 'D'));

      final t = await repo.createSupportTicket(subject: 'S', details: 'D');

      expect(t.subject, 'S');
      expect(t.details, 'D');
      expect(capturedBody(listPath), {'subject': 'S', 'details': 'D'});
    });

    test('both fields are trimmed', () async {
      stubPost(listPath, wireTicket());

      await repo.createSupportTicket(
        subject: '  Points missing \n',
        details: '\n\tThe quiz gave no points.  ',
      );

      expect(capturedBody(listPath), {
        'subject': 'Points missing',
        'details': 'The quiz gave no points.',
      });
    });

    test('inner whitespace and line breaks are kept', () async {
      stubPost(listPath, wireTicket());

      await repo.createSupportTicket(
        subject: 'A  B',
        details: 'Line one\nLine two',
      );

      expect(capturedBody(listPath), {
        'subject': 'A  B',
        'details': 'Line one\nLine two',
      });
    });

    test('NEVER sends attachmentIds (photos are CW12b)', () async {
      stubPost(listPath, wireTicket());

      await repo.createSupportTicket(subject: 'S', details: 'D');

      final body = capturedBody(listPath);
      expect(body.keys.toSet(), {'subject', 'details'});
      expect(body.containsKey('attachmentIds'), isFalse);
    });

    test('a 429 keeps its Retry-After', () async {
      const limited = RateLimitedException(retryAfter: Duration(seconds: 90));
      when(
        () =>
            dio.post<Map<String, dynamic>>(listPath, data: any(named: 'data')),
      ).thenThrow(failure(limited));

      await expectLater(
        repo.createSupportTicket(subject: 'S', details: 'D'),
        throwsA(
          isA<RateLimitedException>().having(
            (e) => e.retryAfter,
            'retryAfter',
            const Duration(seconds: 90),
          ),
        ),
      );
    });

    test('a 400 validation_failed keeps its field map', () async {
      when(
        () =>
            dio.post<Map<String, dynamic>>(listPath, data: any(named: 'data')),
      ).thenThrow(
        failure(
          const ValidationException(
            errors: {
              'subject': ['too long'],
            },
          ),
        ),
      );

      await expectLater(
        repo.createSupportTicket(subject: 'S', details: 'D'),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fields.toList(),
            'fields',
            ['subject'],
          ),
        ),
      );
    });
  });

  group('postMySupportTicketMessage', () {
    test('POSTs exactly {body} to the messages path and decodes it', () async {
      stubPost(messagesPath, wireMessage(body: 'Thanks'));

      final m = await repo.postMySupportTicketMessage(ticketIdA, 'Thanks');

      expect(m.body, 'Thanks');
      expect(m.isStudent, isTrue);
      expect(capturedBody(messagesPath), {'body': 'Thanks'});
    });

    test('the body is trimmed', () async {
      stubPost(messagesPath, wireMessage());

      await repo.postMySupportTicketMessage(ticketIdA, '  hello \n');

      expect(capturedBody(messagesPath), {'body': 'hello'});
    });

    test('NEVER sends attachmentIds (photos are CW12b)', () async {
      stubPost(messagesPath, wireMessage());

      await repo.postMySupportTicketMessage(ticketIdA, 'hello');

      final body = capturedBody(messagesPath);
      expect(body.keys.toSet(), {'body'});
      expect(body.containsKey('attachmentIds'), isFalse);
    });

    test('the id is path-encoded', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/support/tickets/a%2Fb/messages',
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => response(wireMessage(), status: 201));

      await repo.postMySupportTicketMessage('a/b', 'hello');

      verify(
        () => dio.post<Map<String, dynamic>>(
          '/support/tickets/a%2Fb/messages',
          data: any(named: 'data'),
        ),
      ).called(1);
    });

    test('a 409 ticket_closed surfaces as the typed ApiException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          messagesPath,
          data: any(named: 'data'),
        ),
      ).thenThrow(
        failure(const ApiException(status: 409, code: 'ticket_closed')),
      );

      await expectLater(
        repo.postMySupportTicketMessage(ticketIdA, 'hello'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 409)
              .having((e) => e.code, 'code', 'ticket_closed'),
        ),
      );
    });
  });

  group('error mapping - every operation', () {
    final mapped = <AppException>[
      const ApiException(status: 403, code: 'account_pending_deletion'),
      const UnauthorizedException(code: 'authentication_required'),
      const ValidationException(
        errors: {
          'cursor': ['bad'],
        },
      ),
      const RateLimitedException(),
      const OfflineException(),
      const NetworkException(detail: 'timeout'),
      const ApiException(status: 500, code: 'internal_error'),
    ];

    final calls = <String, Future<Object?> Function()>{
      'listMySupportTickets': () => repo.listMySupportTickets(),
      'getMySupportTicket': () => repo.getMySupportTicket(ticketIdA),
      'listMySupportTicketMessages': () =>
          repo.listMySupportTicketMessages(ticketIdA),
    };

    for (final entry in calls.entries) {
      test('${entry.key} surfaces the mapped failures untouched', () async {
        for (final error in mapped) {
          when(
            () => dio.get<Map<String, dynamic>>(
              any(),
              queryParameters: any(named: 'queryParameters'),
            ),
          ).thenThrow(failure(error));
          when(
            () => dio.get<Map<String, dynamic>>(any()),
          ).thenThrow(failure(error));

          await expectLater(
            entry.value(),
            throwsA(same(error)),
            reason: '${entry.key} / ${error.code}',
          );
        }
      });
    }

    test('createSupportTicket and postMySupportTicketMessage too', () async {
      for (final error in mapped) {
        when(
          () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
        ).thenThrow(failure(error));

        await expectLater(
          repo.createSupportTicket(subject: 'S', details: 'D'),
          throwsA(same(error)),
          reason: 'create / ${error.code}',
        );
        await expectLater(
          repo.postMySupportTicketMessage(ticketIdA, 'hello'),
          throwsA(same(error)),
          reason: 'post / ${error.code}',
        );
      }
    });

    test(
      'a 403 account_pending_deletion is recognised by the predicate',
      () async {
        stubGetThrows(
          listPath,
          failure(
            const ApiException(status: 403, code: 'account_pending_deletion'),
          ),
        );

        await expectLater(
          repo.listMySupportTickets(),
          throwsA(predicate<Object>(isAccountPendingDeletion)),
        );
      },
    );

    test('a DioException that bypassed the interceptor is Unknown', () async {
      stubGetThrows(
        listPath,
        DioException(requestOptions: RequestOptions(path: '/x')),
      );

      await expectLater(
        repo.listMySupportTickets(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('schema drift is wrapped, not leaked', () {
    Future<UnknownException> parseFailure(
      Future<Object?> Function() call,
    ) async {
      try {
        await call();
      } on UnknownException catch (e) {
        return e;
      }
      fail('expected the drifted payload to throw UnknownException');
    }

    test('a list row missing a required field', () async {
      stubGet(listPath, {
        'items': [wireSummary(subject: 'Secret subject')..remove('status')],
        'hasMore': false,
      });

      final e = await parseFailure(() => repo.listMySupportTickets());

      expect(e.detail, startsWith('parse: '));
    });

    test('an envelope without hasMore', () async {
      stubGet(listPath, {'items': <dynamic>[]});

      final e = await parseFailure(() => repo.listMySupportTickets());

      expect(e.detail, startsWith('parse: '));
    });

    test('a ticket missing its details', () async {
      stubGetPlain(ticketPath, wireTicket()..remove('details'));

      final e = await parseFailure(() => repo.getMySupportTicket(ticketIdA));

      expect(e.detail, startsWith('parse: '));
    });

    test('a message with an unparseable createdAt', () async {
      stubGet(messagesPath, {
        'items': [wireMessage(createdAt: 'not a date')],
        'hasMore': false,
      });

      final e = await parseFailure(
        () => repo.listMySupportTicketMessages(ticketIdA),
      );

      expect(e.detail, startsWith('parse: '));
    });

    test('a create answered with a drifted ticket', () async {
      stubPost(listPath, wireTicket()..remove('reference'));

      final e = await parseFailure(
        () => repo.createSupportTicket(subject: 'S', details: 'D'),
      );

      expect(e.detail, startsWith('parse: '));
    });

    test('a response with no body at all', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          ticketPath,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ticketPath),
          statusCode: 200,
        ),
      );
      when(() => dio.get<Map<String, dynamic>>(ticketPath)).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ticketPath),
          statusCode: 200,
        ),
      );

      await expectLater(
        repo.getMySupportTicket(ticketIdA),
        throwsA(isA<UnknownException>()),
      );
    });

    test('the detail carries the runtime type only - no id, no text', () async {
      stubGet(listPath, {
        'items': [
          wireSummary(ticketId: 'secret-ticket-id', subject: 'Secret subject')
            ..remove('createdAt'),
        ],
        'hasMore': false,
      });

      final e = await parseFailure(() => repo.listMySupportTickets());

      expect(e.detail, isNot(contains('secret')));
      expect(e.detail, isNot(contains('Secret')));
      expect(e.toString(), isNot(contains('Secret')));
    });
  });
}
