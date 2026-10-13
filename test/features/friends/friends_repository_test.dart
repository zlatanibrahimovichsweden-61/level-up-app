import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/features/friends/friends_errors.dart';
import 'package:level_up_app/features/friends/models/friend_models.dart';
import 'package:level_up_app/features/friends/repository/friends_repository.dart';

import '../../guards/rules.dart' show stripComments;
import 'friends_fixtures.dart';

/// One request the repository made, as the [_FakeDio] saw it.
class _Request {
  _Request(this.method, this.path, this.data, this.query, this.options);

  final String method;
  final String path;
  final Object? data;
  final Map<String, dynamic>? query;
  final Options? options;
}

/// A [Dio] that records every call and answers from [reply].
///
/// Recording (rather than mocktail's matching) is deliberate: the rules worth
/// pinning are the NEGATIVE ones - no `limit`, no `cursor: null`, no body on an
/// accept, no `options` - and a recorder shows exactly what was sent.
class _FakeDio extends Fake implements Dio {
  final requests = <_Request>[];

  /// The body for a request, or a throw. Defaults to failing the test loudly.
  Object? Function(_Request request) reply = (r) =>
      throw StateError('unexpected ${r.method} ${r.path}');

  _Request get only => requests.single;

  Future<Response<T>> _handle<T>(
    String method,
    String path,
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
  ) async {
    final request = _Request(method, path, data, query, options);
    requests.add(request);
    final body = reply(request);
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: body as T?,
    );
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) => _handle<T>('GET', path, data, queryParameters, options);

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => _handle<T>('POST', path, data, queryParameters, options);

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _handle<T>('DELETE', path, data, queryParameters, options);
}

/// What `ErrorInterceptor` hands the repository: a [DioException] whose
/// `error` is the mapped [AppException].
DioException _failure(AppException mapped) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  error: mapped,
);

/// The friend graph and reporting: twelve stable operations, no screen.
///
/// The rules guarded here are the ones the contract states in PROSE and that a
/// client can silently get wrong:
/// - the list operations take NO `limit`, and the cursor is opaque - followed,
///   never built, and ABSENT (not null) on page one;
/// - a page with `hasMore: true` is not the end, whatever its size;
/// - `GET /friend-requests` always names a `direction`;
/// - every write sends exactly `{studentId}` (or nothing), never a reason, a
///   name or a phone number;
/// - `friend_target_unavailable` and the other codes arrive as the typed
///   [AppException] the interceptor mapped, untouched;
/// - the phone lookup is not here at all.
void main() {
  late _FakeDio dio;
  late FriendsRepository repo;

  setUp(() {
    dio = _FakeDio();
    repo = FriendsRepository(dio);
  });

  group('listMyFriends', () {
    test('decodes a page: friends, the hidden score, the envelope', () async {
      dio.reply = (_) => wirePage(
        [
          wireFriend(),
          wireFriend(
            studentId: studentIdB,
            name: sampleNameB,
            hidePoints: true,
          ),
        ],
        hasMore: true,
        nextCursor: 'b3BhcXVl',
      );

      final page = await repo.listMyFriends();

      expect(page.items.map((f) => f.studentId), [studentIdA, studentIdB]);
      expect(page.items.map((f) => f.points), [640, null]);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'b3BhcXVl');
    });

    test('page one sends GET /friends with NO query at all', () async {
      dio.reply = (_) => wirePage([]);

      await repo.listMyFriends();

      expect(dio.only.method, 'GET');
      expect(dio.only.path, '/friends');
      // No `cursor`, not even `cursor: null` (that is a malformed cursor), and
      // no `limit` - the operation takes none.
      expect(dio.only.query, isEmpty);
      expect(dio.only.data, isNull);
      expect(dio.only.options, isNull);
    });

    test('forwards the cursor verbatim and sends nothing else', () async {
      dio.reply = (_) => wirePage([]);

      await repo.listMyFriends(cursor: 'b3BhcXVlLw==');

      expect(dio.only.query, {'cursor': 'b3BhcXVlLw=='});
    });

    test('an EMPTY page is a normal response, not an error', () async {
      dio.reply = (_) => wirePage([]);

      final page = await repo.listMyFriends();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test(
      'hasMore is the server\'s word, not a function of the row count',
      () async {
        dio.reply = (_) =>
            wirePage([wireFriend()], hasMore: true, nextCursor: 'c');

        final shortButNotLast = await repo.listMyFriends();

        expect(shortButNotLast.items, hasLength(1));
        expect(shortButNotLast.hasMore, isTrue);

        dio.reply = (_) => wirePage([
          for (var i = 0; i < 20; i++) wireFriend(studentId: 'id-$i'),
        ]);

        final fullButLast = await repo.listMyFriends();

        expect(fullButLast.items, hasLength(20));
        expect(fullButLast.hasMore, isFalse);
      },
    );
  });

  group('removeFriend', () {
    test(
      'sends DELETE /friends/{studentId} with no body and no query',
      () async {
        dio.reply = (_) => null;

        await repo.removeFriend(studentIdA);

        expect(dio.only.method, 'DELETE');
        expect(dio.only.path, '/friends/$studentIdA');
        expect(dio.only.data, isNull);
        expect(dio.only.query, isNull);
        expect(dio.only.options, isNull);
      },
    );

    test('an id cannot reshape the path', () async {
      dio.reply = (_) => null;

      await repo.removeFriend('a/b?c');

      expect(dio.only.path, '/friends/a%2Fb%3Fc');
    });

    test(
      'completes with nothing on 204 - the answer reveals nothing',
      () async {
        dio.reply = (_) => null;

        await expectLater(repo.removeFriend(studentIdA), completion(isNull));
      },
    );
  });

  group('listFriendSuggestions', () {
    test('decodes StudentCards - no points, level or phone', () async {
      dio.reply = (_) => wirePage(
        [wireCard(), wireCard(studentId: studentIdB, name: sampleNameB)],
        hasMore: true,
        nextCursor: 'next',
      );

      final page = await repo.listFriendSuggestions();

      expect(page.items.map((c) => c.studentId), [studentIdA, studentIdB]);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'next');
    });

    test('sends GET /friends/suggestions with no query on page one', () async {
      dio.reply = (_) => wirePage([]);

      await repo.listFriendSuggestions();

      expect(dio.only.method, 'GET');
      expect(dio.only.path, '/friends/suggestions');
      expect(dio.only.query, isEmpty);
      expect(dio.only.data, isNull);
    });

    test('forwards the cursor verbatim', () async {
      dio.reply = (_) => wirePage([]);

      await repo.listFriendSuggestions(cursor: 'abc');

      expect(dio.only.query, {'cursor': 'abc'});
    });

    test('an empty page (no active enrolment) is a normal answer', () async {
      dio.reply = (_) => wirePage([]);

      final page = await repo.listFriendSuggestions();

      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
    });
  });

  group('listMyFriendRequests', () {
    test('incoming: names the direction, decodes the other party', () async {
      dio.reply = (_) => wirePage([wireRequest()]);

      final page = await repo.listMyFriendRequests(
        direction: FriendRequestDirection.incoming,
      );

      expect(dio.only.method, 'GET');
      expect(dio.only.path, '/friend-requests');
      expect(dio.only.query, {'direction': 'incoming'});
      expect(page.items.single.requestId, requestIdA);
      expect(page.items.single.direction, FriendRequestDirection.incoming);
      expect(page.items.single.student, studentCard());
    });

    test(
      'outgoing: names the direction and adds the cursor when given',
      () async {
        dio.reply = (_) => wirePage([wireRequest(direction: 'outgoing')]);

        final page = await repo.listMyFriendRequests(
          direction: FriendRequestDirection.outgoing,
          cursor: 'next-page',
        );

        expect(dio.only.query, {
          'direction': 'outgoing',
          'cursor': 'next-page',
        });
        expect(page.items.single.direction, FriendRequestDirection.outgoing);
      },
    );

    test('keeps hasMore and the cursor for the caller to follow', () async {
      dio.reply = (_) =>
          wirePage([wireRequest()], hasMore: true, nextCursor: 'more');

      final page = await repo.listMyFriendRequests(
        direction: FriendRequestDirection.incoming,
      );

      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'more');
    });
  });

  group('sendFriendRequest', () {
    test('sends POST /friend-requests with exactly {studentId}', () async {
      dio.reply = (_) => {
        'status': 'pending',
        'request': wireRequest(direction: 'outgoing'),
      };

      await repo.sendFriendRequest(studentIdA);

      expect(dio.only.method, 'POST');
      expect(dio.only.path, '/friend-requests');
      expect(dio.only.data, {'studentId': studentIdA});
      expect(dio.only.query, isNull);
    });

    test('pending: returns the new request', () async {
      dio.reply = (_) => {
        'status': 'pending',
        'request': wireRequest(requestId: requestIdB, direction: 'outgoing'),
      };

      final result = await repo.sendFriendRequest(studentIdA);

      expect(result.isPending, isTrue);
      expect(result.request?.requestId, requestIdB);
      expect(result.friend, isNull);
    });

    test(
      'accepted: THEIR request was waiting, so the two are friends',
      () async {
        dio.reply = (_) => {
          'status': 'accepted',
          'friend': wireFriend(hidePoints: true),
        };

        final result = await repo.sendFriendRequest(studentIdA);

        expect(result.isAccepted, isTrue);
        expect(result.friend?.studentId, studentIdA);
        expect(result.friend?.points, isNull);
        expect(result.request, isNull);
      },
    );
  });

  group('cancelFriendRequest', () {
    test('sends DELETE /friend-requests/{requestId}, no body', () async {
      dio.reply = (_) => null;

      await repo.cancelFriendRequest(requestIdA);

      expect(dio.only.method, 'DELETE');
      expect(dio.only.path, '/friend-requests/$requestIdA');
      expect(dio.only.data, isNull);
      expect(dio.only.query, isNull);
    });

    test('a request id is encoded like every other path segment', () async {
      dio.reply = (_) => null;

      await repo.cancelFriendRequest('x/y');

      expect(dio.only.path, '/friend-requests/x%2Fy');
    });
  });

  group('acceptFriendRequest', () {
    test('sends POST /friend-requests/{id}/accept with NO body', () async {
      dio.reply = (_) => wireFriend();

      await repo.acceptFriendRequest(requestIdA);

      expect(dio.only.method, 'POST');
      expect(dio.only.path, '/friend-requests/$requestIdA/accept');
      expect(dio.only.data, isNull);
      expect(dio.only.query, isNull);
    });

    test('an id cannot reshape the path', () async {
      dio.reply = (_) => wireFriend();

      await repo.acceptFriendRequest('x/y?z');

      expect(dio.only.path, '/friend-requests/x%2Fy%3Fz/accept');
    });

    test('returns the new Friend, hidden score and all', () async {
      dio.reply = (_) => wireFriend(
        studentId: studentIdB,
        name: sampleNameB,
        level: 9,
        hidePoints: true,
      );

      final friend = await repo.acceptFriendRequest(requestIdA);

      expect(friend.studentId, studentIdB);
      expect(friend.level, 9);
      expect(friend.points, isNull);
    });
  });

  group('declineFriendRequest', () {
    test('sends POST /friend-requests/{id}/decline with NO body', () async {
      dio.reply = (_) => null;

      await repo.declineFriendRequest(requestIdA);

      expect(dio.only.method, 'POST');
      expect(dio.only.path, '/friend-requests/$requestIdA/decline');
      expect(dio.only.data, isNull);
      expect(dio.only.query, isNull);
    });

    test('an id cannot reshape the path', () async {
      dio.reply = (_) => null;

      await repo.declineFriendRequest('x/y?z');

      expect(dio.only.path, '/friend-requests/x%2Fy%3Fz/decline');
    });

    test('completes with nothing on 204', () async {
      dio.reply = (_) => null;

      await expectLater(
        repo.declineFriendRequest(requestIdA),
        completion(isNull),
      );
    });
  });

  group('listMyBlocks', () {
    test('decodes StudentCards and keeps the envelope', () async {
      dio.reply = (_) => wirePage([wireCard()], hasMore: true, nextCursor: 'n');

      final page = await repo.listMyBlocks();

      expect(page.items.single, studentCard());
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'n');
    });

    test('sends GET /blocks with no query on page one', () async {
      dio.reply = (_) => wirePage([]);

      await repo.listMyBlocks();

      expect(dio.only.method, 'GET');
      expect(dio.only.path, '/blocks');
      expect(dio.only.query, isEmpty);
    });

    test('forwards the cursor verbatim', () async {
      dio.reply = (_) => wirePage([]);

      await repo.listMyBlocks(cursor: 'zzz');

      expect(dio.only.query, {'cursor': 'zzz'});
    });
  });

  group('blockStudent', () {
    test('sends POST /blocks with exactly {studentId}', () async {
      dio.reply = (_) => null;

      await repo.blockStudent(studentIdA);

      expect(dio.only.method, 'POST');
      expect(dio.only.path, '/blocks');
      expect(dio.only.data, {'studentId': studentIdA});
      expect(dio.only.query, isNull);
    });

    test('completes with nothing on 204 - a success proves nothing', () async {
      dio.reply = (_) => null;

      await expectLater(repo.blockStudent(studentIdA), completion(isNull));
    });
  });

  group('unblockStudent', () {
    test('sends DELETE /blocks/{studentId}, no body', () async {
      dio.reply = (_) => null;

      await repo.unblockStudent(studentIdA);

      expect(dio.only.method, 'DELETE');
      expect(dio.only.path, '/blocks/$studentIdA');
      expect(dio.only.data, isNull);
      expect(dio.only.query, isNull);
    });

    test('an id cannot reshape the path', () async {
      dio.reply = (_) => null;

      await repo.unblockStudent('a/b?c');

      expect(dio.only.path, '/blocks/a%2Fb%3Fc');
    });
  });

  group('reportStudent', () {
    test('sends POST /student-reports with exactly {studentId}', () async {
      dio.reply = (_) => null;

      await repo.reportStudent(studentIdA);

      expect(dio.only.method, 'POST');
      expect(dio.only.path, '/student-reports');
      // The operation accepts no reason and no content - none is ever sent.
      expect(dio.only.data, {'studentId': studentIdA});
      expect(dio.only.query, isNull);
    });

    test('completes with nothing on 202', () async {
      dio.reply = (_) => null;

      await expectLater(repo.reportStudent(studentIdA), completion(isNull));
    });
  });

  group('documented failures arrive as the typed exception, untouched', () {
    Future<Object> thrownBy(Future<Object?> call) async {
      try {
        await call;
      } on Object catch (e) {
        return e;
      }
      fail('expected the call to throw');
    }

    test('sendFriendRequest: 404 friend_target_unavailable', () async {
      const mapped = ApiException(
        status: 404,
        code: 'friend_target_unavailable',
      );
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(repo.sendFriendRequest(studentIdA));

      expect(error, same(mapped));
      expect(isFriendTargetUnavailable(error), isTrue);
    });

    test('sendFriendRequest: 409 already_friends', () async {
      const mapped = ApiException(status: 409, code: 'already_friends');
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(repo.sendFriendRequest(studentIdA));

      expect(error, same(mapped));
      expect(isAlreadyFriends(error), isTrue);
    });

    test('sendFriendRequest: 409 friend_request_already_pending', () async {
      const mapped = ApiException(
        status: 409,
        code: 'friend_request_already_pending',
      );
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(repo.sendFriendRequest(studentIdA));

      expect(error, same(mapped));
      expect(isFriendRequestAlreadyPending(error), isTrue);
    });

    test('sendFriendRequest: 400 validation_failed on studentId', () async {
      const mapped = ValidationException(
        errors: {
          'studentId': ['Must be a UUID.'],
        },
      );
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(repo.sendFriendRequest('not-a-uuid'));

      expect(error, same(mapped));
      expect((error as ValidationException).fields, ['studentId']);
    });

    test('acceptFriendRequest: 404 friend_request_not_found', () async {
      const mapped = ApiException(
        status: 404,
        code: 'friend_request_not_found',
      );
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(repo.acceptFriendRequest(requestIdA));

      expect(error, same(mapped));
      expect(isFriendRequestNotFound(error), isTrue);
    });

    test(
      'acceptFriendRequest: 404 friend_target_unavailable (request deleted)',
      () async {
        const mapped = ApiException(
          status: 404,
          code: 'friend_target_unavailable',
        );
        dio.reply = (_) => throw _failure(mapped);

        final error = await thrownBy(repo.acceptFriendRequest(requestIdA));

        expect(error, same(mapped));
        expect(isFriendTargetUnavailable(error), isTrue);
        expect(isFriendRequestNotFound(error), isFalse);
      },
    );

    test('declineFriendRequest: 404 friend_request_not_found', () async {
      const mapped = ApiException(
        status: 404,
        code: 'friend_request_not_found',
      );
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(repo.declineFriendRequest(requestIdA));

      expect(error, same(mapped));
      expect(isFriendRequestNotFound(error), isTrue);
    });

    test('cancelFriendRequest: 404 friend_request_not_found', () async {
      const mapped = ApiException(
        status: 404,
        code: 'friend_request_not_found',
      );
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(repo.cancelFriendRequest(requestIdA));

      expect(error, same(mapped));
      expect(isFriendRequestNotFound(error), isTrue);
    });

    test(
      'a list: 400 validation_failed on cursor means "page one again"',
      () async {
        const mapped = ValidationException(
          errors: {
            'cursor': ['Malformed.'],
          },
        );
        dio.reply = (_) => throw _failure(mapped);

        final error = await thrownBy(repo.listMyFriends(cursor: 'bad'));

        expect(error, same(mapped));
        expect((error as ValidationException).fields, contains('cursor'));
      },
    );

    test('listMyFriendRequests: 400 validation_failed on direction', () async {
      const mapped = ValidationException(
        errors: {
          'direction': ['Required.'],
        },
      );
      dio.reply = (_) => throw _failure(mapped);

      final error = await thrownBy(
        repo.listMyFriendRequests(direction: FriendRequestDirection.incoming),
      );

      expect(error, same(mapped));
    });

    test(
      '429 rate_limited keeps the Retry-After the interceptor parsed',
      () async {
        const mapped = RateLimitedException(retryAfter: Duration(seconds: 42));
        dio.reply = (_) => throw _failure(mapped);

        final error = await thrownBy(repo.blockStudent(studentIdA));

        expect(error, same(mapped));
        expect(
          (error as RateLimitedException).retryAfter,
          const Duration(seconds: 42),
        );
      },
    );
  });

  group('every operation keeps the typed boundary', () {
    // One row per operation: the twelve the app may call.
    final operations = <String, Future<Object?> Function(FriendsRepository)>{
      'listMyFriends': (r) => r.listMyFriends(),
      'removeFriend': (r) => r.removeFriend(studentIdA),
      'listFriendSuggestions': (r) => r.listFriendSuggestions(),
      'listMyFriendRequests': (r) =>
          r.listMyFriendRequests(direction: FriendRequestDirection.incoming),
      'sendFriendRequest': (r) => r.sendFriendRequest(studentIdA),
      'cancelFriendRequest': (r) => r.cancelFriendRequest(requestIdA),
      'acceptFriendRequest': (r) => r.acceptFriendRequest(requestIdA),
      'declineFriendRequest': (r) => r.declineFriendRequest(requestIdA),
      'listMyBlocks': (r) => r.listMyBlocks(),
      'blockStudent': (r) => r.blockStudent(studentIdA),
      'unblockStudent': (r) => r.unblockStudent(studentIdA),
      'reportStudent': (r) => r.reportStudent(studentIdA),
    };

    // The failures that can come back from ANY authenticated operation.
    final shared = <String, AppException>{
      '401 session_superseded': const UnauthorizedException(
        code: 'session_superseded',
      ),
      '403 account_pending_deletion': const ApiException(
        status: 403,
        code: 'account_pending_deletion',
      ),
      '429 rate_limited': const RateLimitedException(
        retryAfter: Duration(seconds: 7),
      ),
      '5xx internal_error': const ApiException(
        status: 500,
        code: 'internal_error',
      ),
      'offline': const OfflineException(),
      'timeout': const NetworkException(detail: 'timeout'),
    };

    test('there are twelve operations', () {
      expect(operations, hasLength(12));
    });

    for (final op in operations.entries) {
      for (final failure in shared.entries) {
        test('${op.key}: ${failure.key}', () async {
          dio.reply = (_) => throw _failure(failure.value);

          await expectLater(op.value(repo), throwsA(same(failure.value)));
        });
      }

      test('${op.key}: a DioException the chain never mapped is unknown and '
          'carries nothing from it', () async {
        // Message and error both hold the sample name: neither may reach
        // the exception the screen receives.
        dio.reply = (_) => throw DioException(
          requestOptions: RequestOptions(path: '/x'),
          message: sampleNameA,
          error: sampleNameA,
        );

        try {
          await op.value(repo);
          fail('expected a throw');
        } on UnknownException catch (e) {
          expect(e.detail, isNull);
        }
      });

      test(
        '${op.key}: account_pending_deletion is recognised, never retried',
        () async {
          dio.reply = (_) => throw _failure(
            const ApiException(status: 403, code: 'account_pending_deletion'),
          );

          try {
            await op.value(repo);
            fail('expected a throw');
          } on Object catch (e) {
            expect(isAccountPendingDeletion(e), isTrue);
          }
          // One attempt: the layer does not retry on its own.
          expect(dio.requests, hasLength(1));
        },
      );
    }

    // The operations that decode a body: a payload the contract does not allow
    // is a typed failure carrying only the runtime type - never the payload.
    final decoders = <String, Future<Object?> Function(FriendsRepository)>{
      'listMyFriends': operations['listMyFriends']!,
      'listFriendSuggestions': operations['listFriendSuggestions']!,
      'listMyFriendRequests': operations['listMyFriendRequests']!,
      'sendFriendRequest': operations['sendFriendRequest']!,
      'acceptFriendRequest': operations['acceptFriendRequest']!,
      'listMyBlocks': operations['listMyBlocks']!,
    };

    for (final op in decoders.entries) {
      test('${op.key}: a payload missing a required field is a typed parse '
          'failure that leaks nothing', () async {
        // Every shape here has the sample name in it and is missing `studentId`
        // / `requestId` / `level`, whichever the operation needs.
        final broken = {...wireCard()}..remove('studentId');
        dio.reply = (_) => switch (op.key) {
          'sendFriendRequest' => {
            'status': 'accepted',
            'friend': {...wireFriend()}..remove('level'),
          },
          'acceptFriendRequest' => {...wireFriend()}..remove('level'),
          'listMyFriendRequests' => wirePage([wireRequest(student: broken)]),
          _ => wirePage([broken]),
        };

        try {
          await op.value(repo);
          fail('expected a throw');
        } on UnknownException catch (e) {
          // The type name and nothing else: a decoder error's own text (a
          // cast message, a quoted payload) has spaces and colons, so
          // `parse: $e` would not match.
          expect(e.detail, matches(RegExp(r'^parse: \w+$')));
          expect(e.detail, isNot(contains(sampleNameA)));
          expect(e.detail, isNot(contains(studentIdA)));
        }
      });

      test('${op.key}: an empty body is a typed parse failure', () async {
        dio.reply = (_) => null;

        await expectLater(op.value(repo), throwsA(isA<UnknownException>()));
      });
    }

    // Payloads whose decoder error QUOTES the value it choked on: a malformed
    // timestamp (FormatException) and an unknown enum value (ArgumentError).
    // `StudentCard` has no such field - every one of its fields is a plain
    // string - so listFriendSuggestions and listMyBlocks are covered by the
    // `^parse: \w+$` check above only.
    final quoting = <String, ({Object? body, String type})>{
      'listMyFriends': (
        body: wirePage([wireFriend(friendsSince: sampleNameA)]),
        type: 'FormatException',
      ),
      'listMyFriendRequests': (
        body: wirePage([wireRequest(direction: sampleNameA)]),
        type: 'ArgumentError',
      ),
      'sendFriendRequest': (
        body: {'status': sampleNameA},
        type: 'ArgumentError',
      ),
      'acceptFriendRequest': (
        body: wireFriend(friendsSince: sampleNameA),
        type: 'FormatException',
      ),
    };

    test(
      'the quoting payloads really would leak if the text were surfaced',
      () {
        // Guards the tests below against being vacuous: the raw decoder error
        // of each payload does contain the sample name.
        for (final decode in <Object? Function()>[
          () => Friend.fromJson(wireFriend(friendsSince: sampleNameA)),
          () => FriendRequest.fromJson(wireRequest(direction: sampleNameA)),
          () => SendFriendRequestResult.fromJson({'status': sampleNameA}),
        ]) {
          expect(
            decode,
            throwsA(predicate((e) => e.toString().contains(sampleNameA))),
          );
        }
      },
    );

    for (final c in quoting.entries) {
      test('${c.key}: a decoder error that quotes the payload is reduced to '
          'its type', () async {
        dio.reply = (_) => c.value.body;

        try {
          await decoders[c.key]!(repo);
          fail('expected a throw');
        } on UnknownException catch (e) {
          expect(e.detail, 'parse: ${c.value.type}');
          expect(e.detail, isNot(contains(sampleNameA)));
        }
      });
    }
  });

  group('friendsRepositoryProvider', () {
    test('wraps the app Dio', () async {
      dio.reply = (_) => wirePage([wireFriend()]);
      final container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );
      addTearDown(container.dispose);

      final page = await container
          .read(friendsRepositoryProvider)
          .listMyFriends();

      expect(page.items.single.studentId, studentIdA);
      expect(dio.only.path, '/friends');
    });
  });

  group('the data layer stays inside its brief', () {
    late List<({String path, String code})> sources;

    setUpAll(() {
      sources = [
        for (final entity in Directory(
          'lib/features/friends',
        ).listSync(recursive: true))
          if (entity is File &&
              entity.path.endsWith('.dart') &&
              !entity.path.endsWith('.g.dart') &&
              !entity.path.endsWith('.freezed.dart'))
            (
              path: entity.path.replaceAll(r'\', '/'),
              code: stripComments(entity.readAsStringSync()),
            ),
      ];
    });

    test('the friends sources are actually being scanned', () {
      expect(
        sources.map((s) => s.path.split('/').last),
        containsAll([
          'friend_models.dart',
          'friends_errors.dart',
          'friends_repository.dart',
        ]),
      );
    });

    test('lookupStudentByPhone is not here (DR-08)', () {
      for (final s in sources) {
        expect(s.code, isNot(contains('phone-lookup')), reason: s.path);
        expect(s.code, isNot(contains('lookupStudentByPhone')), reason: s.path);
        expect(s.code, isNot(contains('PhoneLookup')), reason: s.path);
      }
    });

    test('nothing logs: a name, an id or a body must never reach a log', () {
      final logging = RegExp(
        r'\b(print|debugPrint|log)\s*\(|developer\.|Logger\b',
      );
      for (final s in sources) {
        expect(logging.hasMatch(s.code), isFalse, reason: s.path);
      }
    });

    test('there is no user-facing copy and no widget in the data layer', () {
      for (final s in sources) {
        expect(s.code, isNot(contains('AppLocalizations')), reason: s.path);
        expect(s.code, isNot(contains('Text(')), reason: s.path);
        expect(s.code, isNot(contains('package:flutter/')), reason: s.path);
      }
    });
  });
}
