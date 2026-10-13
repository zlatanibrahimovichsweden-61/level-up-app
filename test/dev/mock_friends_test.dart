import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/dev/mock_friends.dart';
import 'package:level_up_app/features/friends/friends_errors.dart';
import 'package:level_up_app/features/friends/models/friend_models.dart';
import 'package:level_up_app/features/friends/repository/friends_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart'
    show CursorPage;

/// The friend graph and reporting, served by the on-device mock.
///
/// The harness is the only place the friends screens can be walked with more
/// than one page of anything, every error path, and the contract's quieter
/// rules (a bounded suggestion list, one answer for many causes, a hidden
/// block) - the staging account has two friends and one request. So these pin
/// what the contract specifies, and drive it through the REAL
/// [FriendsRepository] and the REAL `ErrorInterceptor`, which also proves the
/// requests the app builds are the ones the mock understands.
///
/// `mock_backend.dart` does not call [MockFriendsGraph] yet (that hook belongs
/// to the integration step), so [_Adapter] below does what its dispatch block
/// will do: turn a [MockFriendsReply] into a Dio response. Every test gets a
/// FRESH graph, so nothing leaks from one test to the next.
void main() {
  group('GET /friends', () {
    test(
      '22 friends page 20 / 2 by cursor, and hasMore says when to stop',
      () async {
        final s = _Session();

        final first = await s.repo.listMyFriends();
        expect(first.items, hasLength(20));
        expect(first.hasMore, isTrue);
        expect(first.nextCursor, isNotNull);

        final second = await s.repo.listMyFriends(cursor: first.nextCursor);
        expect(second.items, hasLength(2));
        expect(second.hasMore, isFalse);
        expect(second.nextCursor, isNull);

        expect(
          {
            ...first.items.map((f) => f.studentId),
            ...second.items.map((f) => f.studentId),
          },
          {
            for (var k = 1; k <= kMockFriendsFriendCount; k++)
              mockFriendsFriendId(k),
          },
        );
      },
    );

    test('ordered by name, ties broken by studentId', () async {
      final s = _Session();

      final all = await s.allFriends();

      for (var i = 1; i < all.length; i++) {
        final byName = all[i - 1].name.compareTo(all[i].name);
        expect(
          byName < 0 ||
              (byName == 0 &&
                  all[i - 1].studentId.compareTo(all[i].studentId) < 0),
          isTrue,
          reason: 'row $i',
        );
      }
    });

    test(
      'every fifth friend hides their score: points is OMITTED, not null',
      () async {
        final s = _Session();

        final res = await s.dio.get<Map<String, dynamic>>('/friends');
        final all = [
          ...(res.data!['items'] as List).cast<Map<String, dynamic>>(),
          // The second page, so all 22 are covered.
          ...((await s.dio.get<Map<String, dynamic>>(
                    '/friends',
                    queryParameters: {'cursor': res.data!['nextCursor']},
                  )).data!['items']
                  as List)
              .cast<Map<String, dynamic>>(),
        ];

        final hidden = [
          for (final row in all)
            if (!row.containsKey('points')) row['studentId'],
        ];
        expect(
          hidden,
          unorderedEquals([5, 10, 15, 20].map(mockFriendsFriendId)),
        );
        for (final row in all) {
          expect(
            row.keys,
            containsAll([
              'studentId',
              'name',
              'avatarUrl',
              'level',
              'friendsSince',
            ]),
          );
          // No phone digits on a friend.
          expect(row.keys, isNot(contains('phone')));
        }
      },
    );

    test(
      'decodes through the real model: level is an int, friendsSince is UTC',
      () async {
        final s = _Session();

        final all = await s.allFriends();

        expect(all.where((f) => f.points == null), hasLength(4));
        for (final f in all) {
          expect(f.level, greaterThanOrEqualTo(1));
          expect(f.friendsSince.isUtc, isTrue);
          expect(f.friendsSince.isBefore(DateTime.utc(2026, 10, 9)), isTrue);
        }
      },
    );

    test(
      'the names are the invented board peers mock_backend already serves',
      () async {
        final s = _Session();
        final backend = File('lib/dev/mock_backend.dart').readAsStringSync();

        final all = await s.allFriends();

        for (final f in all) {
          expect(
            backend,
            contains("'${f.name}'"),
            reason:
                'a friend name is no longer a quoted literal in '
                'lib/dev/mock_backend.dart. mock_friends.dart deliberately '
                'reuses the leaderboard peers defined there; if those '
                'fixtures were renamed or removed, rename the friends in '
                'lib/dev/mock_friends.dart to match, or drop this test.',
          );
        }
      },
    );

    test(
      'a walk survives the last row of page one being removed (keyset)',
      () async {
        final s = _Session();
        final first = await s.repo.listMyFriends();
        final seen = first.items.map((f) => f.studentId).toSet();
        final lastOfPageOne = first.items.last.studentId;

        // The row the cursor names goes away between pages.
        await s.repo.removeFriend(lastOfPageOne);
        final second = await s.repo.listMyFriends(cursor: first.nextCursor);

        expect(second.items, hasLength(2));
        expect(
          second.items.map((f) => f.studentId).toSet().intersection(seen),
          isEmpty,
        );
        expect(second.hasMore, isFalse);
      },
    );
  });

  group('cursors', () {
    test(
      'a cursor from another list is 400 validation_failed on cursor',
      () async {
        final s = _Session();
        final friendsPage = await s.repo.listMyFriends();

        final error = await _rejection(
          s.repo.listMyBlocks(cursor: friendsPage.nextCursor),
        );

        expect(error, isA<ValidationException>());
        expect((error as ValidationException).fields, ['cursor']);
      },
    );

    test('a cursor for the other direction is rejected too', () async {
      final s = _Session();
      final incoming = await s.repo.listMyFriendRequests(
        direction: FriendRequestDirection.incoming,
      );

      final error = await _rejection(
        s.repo.listMyFriendRequests(
          direction: FriendRequestDirection.outgoing,
          cursor: incoming.nextCursor,
        ),
      );

      expect((error as ValidationException).fields, ['cursor']);
    });

    for (final bad in ['AAAA', 'not base64 !!', '']) {
      test('"$bad" is not a cursor this API issued', () async {
        final s = _Session();

        final error = await _rejection(s.repo.listMyFriends(cursor: bad));

        expect((error as ValidationException).fields, ['cursor']);
      });
    }

    test('a cursor that is not a string is rejected', () async {
      final s = _Session();

      final error = await _rejection(
        s.dio.get<Map<String, dynamic>>(
          '/friends',
          queryParameters: {'cursor': 7},
        ),
      );

      expect((error as ValidationException).fields, ['cursor']);
    });
  });

  group('GET /friends/suggestions', () {
    test('bounded: 100 students in total across five pages of 20', () async {
      final s = _Session();

      final pages = <CursorPage<StudentCard>>[];
      String? cursor;
      do {
        final page = await s.repo.listFriendSuggestions(cursor: cursor);
        pages.add(page);
        cursor = page.hasMore ? page.nextCursor : null;
      } while (cursor != null);

      expect(pages, hasLength(5));
      expect(pages.map((p) => p.items.length), everyElement(20));
      expect(pages.last.hasMore, isFalse);
      expect(pages.last.nextCursor, isNull);
      // The cohort holds more than the bound; the bound is what is served.
      expect(
        kMockFriendsSuggestionPoolCount,
        greaterThan(kMockFriendsSuggestionBound),
      );
      expect(pages.expand((p) => p.items).map((c) => c.studentId), [
        for (var k = 1; k <= kMockFriendsSuggestionBound; k++)
          mockFriendsSuggestionId(k),
      ]);
    });

    test(
      'never the caller, a friend, a requester or a blocked student',
      () async {
        final s = _Session();

        final ids = (await s.allSuggestions()).map((c) => c.studentId).toSet();

        expect(ids, hasLength(kMockFriendsSuggestionBound));
        expect(ids, isNot(contains(kMockFriendsSelfId)));
        expect(
          ids.intersection({
            for (var k = 1; k <= kMockFriendsFriendCount; k++)
              mockFriendsFriendId(k),
          }),
          isEmpty,
        );
        expect(
          ids.intersection({
            for (var k = 1; k <= kMockFriendsIncomingCount; k++)
              mockFriendsIncomingStudentId(k),
          }),
          isEmpty,
        );
        expect(
          ids.intersection({
            for (var k = 1; k <= kMockFriendsOutgoingCount; k++)
              mockFriendsOutgoingStudentId(k),
          }),
          isEmpty,
        );
        expect(
          ids.intersection({
            for (var k = 1; k <= kMockFriendsBlockedCount; k++)
              mockFriendsBlockedId(k),
          }),
          isEmpty,
        );
        expect(ids, isNot(contains(mockFriendsOtherTrackStudentId())));
        expect(ids, isNot(contains(mockFriendsPendingDeletionStudentId())));
      },
    );

    test(
      'a card is name and avatar only - no points, level or phone',
      () async {
        final s = _Session();

        final res = await s.dio.get<Map<String, dynamic>>(
          '/friends/suggestions',
        );

        for (final item
            in (res.data!['items'] as List).cast<Map<String, dynamic>>()) {
          expect(
            item.keys,
            unorderedEquals(['studentId', 'name', 'avatarUrl']),
          );
        }
      },
    );

    test(
      'the bound slides: a student who drops out is replaced by the next',
      () async {
        final s = _Session();
        final before = (await s.allSuggestions())
            .map((c) => c.studentId)
            .toList();
        expect(before, isNot(contains(mockFriendsSuggestionId(101))));

        await s.repo.sendFriendRequest(mockFriendsSuggestionId(1));
        final after = (await s.allSuggestions())
            .map((c) => c.studentId)
            .toList();

        expect(after, hasLength(kMockFriendsSuggestionBound));
        expect(after, isNot(contains(mockFriendsSuggestionId(1))));
        expect(after.last, mockFriendsSuggestionId(101));
      },
    );

    test('blocking a suggestion removes them from the list', () async {
      final s = _Session();

      await s.repo.blockStudent(mockFriendsSuggestionId(2));
      final ids = (await s.allSuggestions()).map((c) => c.studentId);

      expect(ids, isNot(contains(mockFriendsSuggestionId(2))));
      expect(ids, hasLength(kMockFriendsSuggestionBound));
    });

    test('one suggestion is long enough to wrap', () async {
      final s = _Session();

      final all = await s.allSuggestions();

      expect(
        all.map((c) => c.name.length).reduce((a, b) => a > b ? a : b),
        greaterThan(60),
      );
    });
  });

  group('GET /friend-requests', () {
    test('direction is REQUIRED', () async {
      final s = _Session();

      final error = await _rejection(
        s.dio.get<Map<String, dynamic>>('/friend-requests'),
      );

      expect(error, isA<ValidationException>());
      expect((error as ValidationException).fields, ['direction']);
    });

    test('direction must be incoming or outgoing', () async {
      final s = _Session();

      final error = await _rejection(
        s.dio.get<Map<String, dynamic>>(
          '/friend-requests',
          queryParameters: {'direction': 'both'},
        ),
      );

      expect((error as ValidationException).fields, ['direction']);
    });

    test('incoming: 22 requests page 20 / 2, newest first', () async {
      final s = _Session();

      final first = await s.repo.listMyFriendRequests(
        direction: FriendRequestDirection.incoming,
      );
      final second = await s.repo.listMyFriendRequests(
        direction: FriendRequestDirection.incoming,
        cursor: first.nextCursor,
      );

      expect(first.items, hasLength(20));
      expect(first.hasMore, isTrue);
      expect(second.items, hasLength(2));
      expect(second.hasMore, isFalse);
      final all = [...first.items, ...second.items];
      expect(all.map((r) => r.requestId), [
        for (var k = 1; k <= kMockFriendsIncomingCount; k++)
          mockFriendsIncomingRequestId(k),
      ]);
      expect(
        all.map((r) => r.direction),
        everyElement(FriendRequestDirection.incoming),
      );
      for (var i = 1; i < all.length; i++) {
        expect(
          all[i - 1].createdAt.isAfter(all[i].createdAt),
          isTrue,
          reason: 'row $i',
        );
      }
    });

    test('outgoing: one short page naming the recipients', () async {
      final s = _Session();

      final page = await s.repo.listMyFriendRequests(
        direction: FriendRequestDirection.outgoing,
      );

      expect(page.items, hasLength(kMockFriendsOutgoingCount));
      expect(page.hasMore, isFalse);
      expect(page.items.map((r) => r.student.studentId), [
        for (var k = 1; k <= kMockFriendsOutgoingCount; k++)
          mockFriendsOutgoingStudentId(k),
      ]);
      expect(
        page.items.map((r) => r.direction),
        everyElement(FriendRequestDirection.outgoing),
      );
    });

    test('the other party is a card - no points, level or phone', () async {
      final s = _Session();

      final res = await s.dio.get<Map<String, dynamic>>(
        '/friend-requests',
        queryParameters: {'direction': 'incoming'},
      );

      final first = (res.data!['items'] as List).first as Map<String, dynamic>;
      expect(
        first.keys,
        unorderedEquals(['requestId', 'direction', 'student', 'createdAt']),
      );
      expect(
        (first['student'] as Map).keys,
        unorderedEquals(['studentId', 'name', 'avatarUrl']),
      );
    });
  });

  group('POST /friend-requests', () {
    test(
      'sends a request: 201 pending, and it heads the outgoing list',
      () async {
        final s = _Session();
        final target = mockFriendsSuggestionId(1);

        final result = await s.repo.sendFriendRequest(target);

        expect(result.status, SendFriendRequestStatus.pending);
        expect(result.request?.direction, FriendRequestDirection.outgoing);
        expect(result.request?.student.studentId, target);
        expect(result.friend, isNull);
        final outgoing = await s.allRequests(FriendRequestDirection.outgoing);
        expect(outgoing, hasLength(kMockFriendsOutgoingCount + 1));
        expect(outgoing.first.requestId, result.request?.requestId);
      },
    );

    test(
      'and still heads the list when the device clock is behind the fixtures',
      () async {
        final s = _Session(start: DateTime.utc(2020));

        final result = await s.repo.sendFriendRequest(
          mockFriendsSuggestionId(1),
        );

        final outgoing = await s.allRequests(FriendRequestDirection.outgoing);
        expect(outgoing.first.requestId, result.request?.requestId);
      },
    );

    test('the suggestion is gone from the list once asked', () async {
      final s = _Session();

      await s.repo.sendFriendRequest(mockFriendsSuggestionId(1));

      final ids = (await s.allSuggestions()).map((c) => c.studentId);
      expect(ids, isNot(contains(mockFriendsSuggestionId(1))));
    });

    test('asking again is 409 friend_request_already_pending', () async {
      final s = _Session();
      await s.repo.sendFriendRequest(mockFriendsSuggestionId(1));

      final error = await _rejection(
        s.repo.sendFriendRequest(mockFriendsSuggestionId(1)),
      );

      expect(isFriendRequestAlreadyPending(error), isTrue);
      expect((error as ApiException).status, 409);
    });

    test(
      'asking the recipient of an existing outgoing request is 409 pending',
      () async {
        final s = _Session();

        final error = await _rejection(
          s.repo.sendFriendRequest(mockFriendsOutgoingStudentId(1)),
        );

        expect(isFriendRequestAlreadyPending(error), isTrue);
      },
    );

    test('asking a friend is 409 already_friends', () async {
      final s = _Session();

      final error = await _rejection(
        s.repo.sendFriendRequest(mockFriendsFriendId(1)),
      );

      expect(isAlreadyFriends(error), isTrue);
      expect((error as ApiException).status, 409);
    });

    test(
      'asking someone who already asked ACCEPTS theirs: 201 accepted',
      () async {
        final s = _Session();
        final sender = mockFriendsIncomingStudentId(1);

        final result = await s.repo.sendFriendRequest(sender);

        expect(result.status, SendFriendRequestStatus.accepted);
        expect(result.friend?.studentId, sender);
        expect(result.request, isNull);
        expect(
          await s.allRequests(FriendRequestDirection.incoming),
          hasLength(kMockFriendsIncomingCount - 1),
        );
        expect(
          (await s.allFriends()).map((f) => f.studentId),
          contains(sender),
        );
      },
    );

    test(
      'the target is unavailable: ONE answer for six different causes',
      () async {
        final graph = MockFriendsGraph(
          clock: _Clock(DateTime.utc(2026, 10, 12)).call,
        );
        // A blocked student, to make the sixth cause real.
        final blocked = mockFriendsSuggestionId(5);
        graph.handle('POST', '/blocks', const {}, {'studentId': blocked});

        final causes = <String, String>{
          'unknown id': '5f000000-0000-4000-8000-0000000fffff',
          'the caller': kMockFriendsSelfId,
          'other Track': mockFriendsOtherTrackStudentId(),
          'pending deletion': mockFriendsPendingDeletionStudentId(),
          'blocked by the caller': blocked,
          'left since the list': mockFriendsSuggestionId(
            kMockFriendsGoneSuggestion,
          ),
        };
        final answers = <String, MockFriendsReply?>{
          for (final c in causes.entries)
            c.key: graph.handle('POST', '/friend-requests', const {}, {
              'studentId': c.value,
            }),
        };

        for (final a in answers.entries) {
          expect(a.value, isA<MockFriendsProblem>(), reason: a.key);
        }
        final bodies = answers.values
            .cast<MockFriendsProblem>()
            .map((p) => (p.status, p.code, p.detail))
            .toSet();
        expect(bodies, hasLength(1), reason: 'the causes are distinguishable');
        expect(bodies.single.$1, 404);
        expect(bodies.single.$2, 'friend_target_unavailable');
      },
    );

    test('through the app: 404 friend_target_unavailable', () async {
      final s = _Session();

      final error = await _rejection(
        s.repo.sendFriendRequest(mockFriendsOtherTrackStudentId()),
      );

      expect(isFriendTargetUnavailable(error), isTrue);
      expect((error as ApiException).status, 404);
    });

    test(
      'a student who left since the list was served: refused, then unlisted',
      () async {
        final s = _Session();
        final gone = mockFriendsSuggestionId(kMockFriendsGoneSuggestion);
        expect(
          (await s.allSuggestions()).map((c) => c.studentId),
          contains(gone),
        );

        final error = await _rejection(s.repo.sendFriendRequest(gone));
        final again = await _rejection(s.repo.sendFriendRequest(gone));

        expect(isFriendTargetUnavailable(error), isTrue);
        expect(isFriendTargetUnavailable(again), isTrue);
        expect(
          (await s.allSuggestions()).map((c) => c.studentId),
          isNot(contains(gone)),
        );
      },
    );

    test('a missing studentId is 400 validation_failed on studentId', () async {
      final s = _Session();

      final error = await _rejection(
        s.dio.post<Map<String, dynamic>>(
          '/friend-requests',
          data: <String, dynamic>{},
        ),
      );

      expect((error as ValidationException).fields, ['studentId']);
    });

    test('a studentId that is not a UUID is 400 validation_failed', () async {
      final s = _Session();

      final error = await _rejection(s.repo.sendFriendRequest('not-a-uuid'));

      expect((error as ValidationException).fields, ['studentId']);
    });
  });

  group('cancel, accept and decline', () {
    test(
      'cancel removes an outgoing request: 204, then 404 friend_request_not_found',
      () async {
        final s = _Session();
        final id = mockFriendsOutgoingRequestId(1);

        await s.repo.cancelFriendRequest(id);

        expect(
          await s.allRequests(FriendRequestDirection.outgoing),
          hasLength(kMockFriendsOutgoingCount - 1),
        );
        final again = await _rejection(s.repo.cancelFriendRequest(id));
        expect(isFriendRequestNotFound(again), isTrue);
        expect((again as ApiException).status, 404);
      },
    );

    test(
      'cancel is sender only: an INCOMING request id is not found, and stays',
      () async {
        final s = _Session();

        final error = await _rejection(
          s.repo.cancelFriendRequest(mockFriendsIncomingRequestId(1)),
        );

        expect(isFriendRequestNotFound(error), isTrue);
        expect(
          await s.allRequests(FriendRequestDirection.incoming),
          hasLength(kMockFriendsIncomingCount),
        );
      },
    );

    test(
      'accept makes a friend: 200 Friend, the request is gone, the list grows',
      () async {
        final s = _Session();
        final sender = mockFriendsIncomingStudentId(1);

        final friend = await s.repo.acceptFriendRequest(
          mockFriendsIncomingRequestId(1),
        );

        expect(friend.studentId, sender);
        expect(friend.friendsSince.isUtc, isTrue);
        expect(
          await s.allRequests(FriendRequestDirection.incoming),
          hasLength(kMockFriendsIncomingCount - 1),
        );
        expect(await s.allFriends(), hasLength(kMockFriendsFriendCount + 1));
        final again = await _rejection(
          s.repo.acceptFriendRequest(mockFriendsIncomingRequestId(1)),
        );
        expect(isFriendRequestNotFound(again), isTrue);
      },
    );

    test(
      'accept is recipient only: an OUTGOING request id is not found',
      () async {
        final s = _Session();

        final error = await _rejection(
          s.repo.acceptFriendRequest(mockFriendsOutgoingRequestId(1)),
        );

        expect(isFriendRequestNotFound(error), isTrue);
      },
    );

    test(
      'accept when the sender has left: request deleted, 404 friend_target_unavailable',
      () async {
        final s = _Session();
        final id = mockFriendsIncomingRequestId(kMockFriendsGoneRequest);

        final error = await _rejection(s.repo.acceptFriendRequest(id));

        expect(isFriendTargetUnavailable(error), isTrue);
        expect(isFriendRequestNotFound(error), isFalse);
        expect(
          await s.allRequests(FriendRequestDirection.incoming),
          hasLength(kMockFriendsIncomingCount - 1),
        );
        final again = await _rejection(s.repo.acceptFriendRequest(id));
        expect(isFriendRequestNotFound(again), isTrue);
        expect(await s.allFriends(), hasLength(kMockFriendsFriendCount));
      },
    );

    test(
      'decline deletes the request: 204, then 404; the sender may ask again',
      () async {
        final s = _Session();
        final id = mockFriendsIncomingRequestId(5);

        await s.repo.declineFriendRequest(id);

        expect(
          await s.allRequests(FriendRequestDirection.incoming),
          hasLength(kMockFriendsIncomingCount - 1),
        );
        final again = await _rejection(s.repo.declineFriendRequest(id));
        expect(isFriendRequestNotFound(again), isTrue);
        // The decliner is not a friend, and there is no cooldown on asking them.
        expect(await s.allFriends(), hasLength(kMockFriendsFriendCount));
        final resend = await s.repo.sendFriendRequest(
          mockFriendsIncomingStudentId(5),
        );
        expect(resend.isPending, isTrue);
      },
    );

    test(
      'decline is recipient only: an OUTGOING request id is not found',
      () async {
        final s = _Session();

        final error = await _rejection(
          s.repo.declineFriendRequest(mockFriendsOutgoingRequestId(1)),
        );

        expect(isFriendRequestNotFound(error), isTrue);
        expect(
          await s.allRequests(FriendRequestDirection.outgoing),
          hasLength(kMockFriendsOutgoingCount),
        );
      },
    );

    test(
      'a malformed request id is the same answer as an unknown one',
      () async {
        final s = _Session();

        for (final id in [
          'nope',
          'a b',
          '00000000-0000-0000-0000-000000000000',
        ]) {
          for (final call in [
            () => s.repo.cancelFriendRequest(id),
            () => s.repo.acceptFriendRequest(id),
            () => s.repo.declineFriendRequest(id),
          ]) {
            final error = await _rejection(call());
            expect(isFriendRequestNotFound(error), isTrue, reason: '"$id"');
          }
        }
      },
    );
  });

  group('DELETE /friends/{studentId}', () {
    test('removes a friend: 204, and they can be asked again', () async {
      final s = _Session();
      final id = mockFriendsFriendId(3);

      await s.repo.removeFriend(id);

      expect(await s.allFriends(), hasLength(kMockFriendsFriendCount - 1));
      expect(
        (await s.allFriends()).map((f) => f.studentId),
        isNot(contains(id)),
      );
      expect((await s.repo.sendFriendRequest(id)).isPending, isTrue);
    });

    test(
      'idempotent: 204 for a non-friend, an unknown id and the caller',
      () async {
        final s = _Session();

        await s.repo.removeFriend(mockFriendsFriendId(3));
        await s.repo.removeFriend(mockFriendsFriendId(3));
        await s.repo.removeFriend('5f000000-0000-4000-8000-0000000fffff');
        await s.repo.removeFriend(kMockFriendsSelfId);
        await s.repo.removeFriend('not-a-uuid');

        expect(await s.allFriends(), hasLength(kMockFriendsFriendCount - 1));
      },
    );
  });

  group('blocks', () {
    test(
      '21 blocked students page 20 / 1, most recently blocked first',
      () async {
        final s = _Session();

        final first = await s.repo.listMyBlocks();
        final second = await s.repo.listMyBlocks(cursor: first.nextCursor);

        expect(first.items, hasLength(20));
        expect(first.hasMore, isTrue);
        expect(second.items, hasLength(1));
        expect(second.hasMore, isFalse);
        expect([...first.items, ...second.items].map((c) => c.studentId), [
          for (var k = 1; k <= kMockFriendsBlockedCount; k++)
            mockFriendsBlockedId(k),
        ]);
      },
    );

    test('a block lands at the top of the list', () async {
      final s = _Session();
      final id = mockFriendsSuggestionId(7);

      await s.repo.blockStudent(id);

      final all = await s.allBlocks();
      expect(all, hasLength(kMockFriendsBlockedCount + 1));
      expect(all.first.studentId, id);
    });

    test(
      'and still does when the device clock is behind the fixtures',
      () async {
        final s = _Session(start: DateTime.utc(2020));
        final id = mockFriendsSuggestionId(7);

        await s.repo.blockStudent(id);

        expect((await s.allBlocks()).first.studentId, id);
      },
    );

    test('blocking is idempotent: no duplicate row', () async {
      final s = _Session();
      final id = mockFriendsSuggestionId(7);

      await s.repo.blockStudent(id);
      await s.repo.blockStudent(id);

      expect(await s.allBlocks(), hasLength(kMockFriendsBlockedCount + 1));
    });

    test('blocking a friend ends the friendship', () async {
      final s = _Session();
      final id = mockFriendsFriendId(3);

      await s.repo.blockStudent(id);

      expect(
        (await s.allFriends()).map((f) => f.studentId),
        isNot(contains(id)),
      );
      expect((await s.allBlocks()).first.studentId, id);
    });

    test('blocking removes a pending request in either direction', () async {
      final s = _Session();

      await s.repo.blockStudent(mockFriendsIncomingStudentId(4));
      await s.repo.blockStudent(mockFriendsOutgoingStudentId(1));

      final incoming = await s.allRequests(FriendRequestDirection.incoming);
      final outgoing = await s.allRequests(FriendRequestDirection.outgoing);
      expect(incoming, hasLength(kMockFriendsIncomingCount - 1));
      expect(
        incoming.map((r) => r.student.studentId),
        isNot(contains(mockFriendsIncomingStudentId(4))),
      );
      expect(outgoing, hasLength(kMockFriendsOutgoingCount - 1));
    });

    test(
      'a blocked student cannot be asked: the same 404 as any unavailable target',
      () async {
        final s = _Session();
        final id = mockFriendsSuggestionId(7);
        await s.repo.blockStudent(id);

        final error = await _rejection(s.repo.sendFriendRequest(id));

        expect(isFriendTargetUnavailable(error), isTrue);
      },
    );

    test(
      '204 for every well-formed id, storing nothing for an unknown or own one',
      () async {
        final graph = MockFriendsGraph(
          clock: _Clock(DateTime.utc(2026, 10, 12)).call,
        );

        final answers = {
          for (final id in [
            '5f000000-0000-4000-8000-0000000fffff',
            kMockFriendsSelfId,
            mockFriendsOtherTrackStudentId(),
            mockFriendsFriendId(1),
          ])
            id: graph.handle('POST', '/blocks', const {}, {'studentId': id}),
        };

        for (final a in answers.values) {
          expect(a, isA<MockFriendsOk>());
          final ok = a! as MockFriendsOk;
          expect(ok.status, 204);
          expect(ok.data, isNull);
        }
        // Stored: the real students. Not stored: an unknown id and the caller.
        // (The fixtures already hold their own blocked students.)
        final fixtureBlocks = {
          for (var k = 1; k <= kMockFriendsBlockedCount; k++)
            mockFriendsBlockedId(k),
        };
        expect(graph.blockedStudentIds.difference(fixtureBlocks), {
          mockFriendsOtherTrackStudentId(),
          mockFriendsFriendId(1),
        });
      },
    );

    test(
      'a block of a student on the other Track is stored but never listed',
      () async {
        final graph = MockFriendsGraph(
          clock: _Clock(DateTime.utc(2026, 10, 12)).call,
        );
        final s = _Session.over(graph);
        final other = mockFriendsOtherTrackStudentId();

        await s.repo.blockStudent(other);

        expect(graph.blockedStudentIds, contains(other));
        final listed = await s.allBlocks();
        expect(listed, hasLength(kMockFriendsBlockedCount));
        expect(listed.map((c) => c.studentId), isNot(contains(other)));
      },
    );

    test('unblock is idempotent 204 and restores nothing', () async {
      final s = _Session();
      final friend = mockFriendsFriendId(3);
      await s.repo.blockStudent(friend);

      await s.repo.unblockStudent(friend);
      await s.repo.unblockStudent(friend);
      await s.repo.unblockStudent('5f000000-0000-4000-8000-0000000fffff');

      expect(await s.allBlocks(), hasLength(kMockFriendsBlockedCount));
      // No friendship and no request came back...
      expect(
        (await s.allFriends()).map((f) => f.studentId),
        isNot(contains(friend)),
      );
      // ...but they can be asked again.
      expect((await s.repo.sendFriendRequest(friend)).isPending, isTrue);
    });

    test('a missing or malformed studentId is 400 validation_failed', () async {
      final s = _Session();

      final missing = await _rejection(
        s.dio.post<void>('/blocks', data: <String, dynamic>{}),
      );
      final malformed = await _rejection(s.repo.blockStudent('x'));

      expect((missing as ValidationException).fields, ['studentId']);
      expect((malformed as ValidationException).fields, ['studentId']);
    });
  });

  group('POST /student-reports', () {
    test(
      '202 for every well-formed id; stored only for a real, different student',
      () async {
        final graph = MockFriendsGraph(
          clock: _Clock(DateTime.utc(2026, 10, 12)).call,
        );
        final real = [
          mockFriendsFriendId(1),
          mockFriendsSuggestionId(1),
          mockFriendsBlockedId(1),
          mockFriendsOtherTrackStudentId(),
        ];
        final notReal = [
          '5f000000-0000-4000-8000-0000000fffff',
          kMockFriendsSelfId,
        ];

        final answers = [
          for (final id in [...real, ...notReal])
            graph.handle('POST', '/student-reports', const {}, {
              'studentId': id,
            }),
        ];

        for (final a in answers) {
          expect(a, isA<MockFriendsOk>());
          final ok = a! as MockFriendsOk;
          expect(ok.status, 202);
          expect(ok.data, isNull);
        }
        expect(graph.reportedStudentIds, real.toSet());
      },
    );

    test('a repeat stores nothing', () async {
      final graph = MockFriendsGraph(
        clock: _Clock(DateTime.utc(2026, 10, 12)).call,
      );
      final id = mockFriendsFriendId(1);

      for (var i = 0; i < 3; i++) {
        graph.handle('POST', '/student-reports', const {}, {'studentId': id});
      }

      expect(graph.reportedStudentIds, {id});
    });

    test(
      'reporting changes no list: it is not a block and not an unfriend',
      () async {
        final s = _Session();

        await s.repo.reportStudent(mockFriendsFriendId(1));

        expect(await s.allFriends(), hasLength(kMockFriendsFriendCount));
        expect(await s.allBlocks(), hasLength(kMockFriendsBlockedCount));
      },
    );

    test('a missing or malformed studentId is 400 validation_failed', () async {
      final s = _Session();

      final malformed = await _rejection(s.repo.reportStudent('x'));
      final missing = await _rejection(
        s.dio.post<void>('/student-reports', data: <String, dynamic>{}),
      );

      expect((malformed as ValidationException).fields, ['studentId']);
      expect((missing as ValidationException).fields, ['studentId']);
    });
  });

  group('rate limits', () {
    test(
      '31 social writes inside a minute: the 31st is 429 with Retry-After',
      () async {
        final clock = _Clock(DateTime.utc(2026, 10, 12, 9));
        final s = _Session(clock: clock);
        for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
          await s.repo.removeFriend(mockFriendsFriendId(1));
        }

        final error = await _rejection(
          s.repo.removeFriend(mockFriendsFriendId(1)),
        );

        expect(error, isA<RateLimitedException>());
        expect(
          (error as RateLimitedException).retryAfter,
          const Duration(seconds: kMockFriendsWriteWindowSeconds),
        );
      },
    );

    test('Retry-After counts down with the window', () async {
      final clock = _Clock(DateTime.utc(2026, 10, 12, 9));
      final s = _Session(clock: clock);
      for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
        await s.repo.unblockStudent(mockFriendsBlockedId(1));
      }

      clock.advance(const Duration(seconds: 10));
      final error = await _rejection(
        s.repo.unblockStudent(mockFriendsBlockedId(1)),
      );

      expect(
        (error as RateLimitedException).retryAfter,
        const Duration(seconds: 50),
      );
    });

    test('every kind of social write spends the one budget', () async {
      final clock = _Clock(DateTime.utc(2026, 10, 12, 9));
      final s = _Session(clock: clock);
      final writes = <Future<Object?> Function()>[
        () => s.repo.removeFriend(mockFriendsFriendId(1)),
        () => s.repo.sendFriendRequest(mockFriendsSuggestionId(1)),
        () => s.repo.cancelFriendRequest(mockFriendsOutgoingRequestId(1)),
        () => s.repo.acceptFriendRequest(mockFriendsIncomingRequestId(1)),
        () => s.repo.declineFriendRequest(mockFriendsIncomingRequestId(3)),
        () => s.repo.blockStudent(mockFriendsSuggestionId(9)),
        () => s.repo.unblockStudent(mockFriendsBlockedId(1)),
      ];
      // Seven different writes, repeated, use up exactly thirty.
      for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
        try {
          await writes[i % writes.length]();
        } on AppException {
          // A repeat of an accept or a cancel is a 404: it still spends budget.
        }
      }

      final error = await _rejection(
        s.repo.removeFriend(mockFriendsFriendId(2)),
      );

      expect(error, isA<RateLimitedException>());
    });

    test('reads are not limited', () async {
      final s = _Session(clock: _Clock(DateTime.utc(2026, 10, 12, 9)));
      for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
        await s.repo.removeFriend(mockFriendsFriendId(1));
      }

      expect(await s.repo.listMyFriends(), isNotNull);
      expect(await s.repo.listMyBlocks(), isNotNull);
      expect(await s.repo.listFriendSuggestions(), isNotNull);
    });

    test('after the window the budget is back', () async {
      final clock = _Clock(DateTime.utc(2026, 10, 12, 9));
      final s = _Session(clock: clock);
      for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
        await s.repo.removeFriend(mockFriendsFriendId(1));
      }
      await _rejection(s.repo.removeFriend(mockFriendsFriendId(1)));

      clock.advance(const Duration(seconds: kMockFriendsWriteWindowSeconds));

      await s.repo.removeFriend(mockFriendsFriendId(1));
    });

    test('a refused write spends nothing', () async {
      final clock = _Clock(DateTime.utc(2026, 10, 12, 9));
      final s = _Session(clock: clock);
      for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
        await s.repo.removeFriend(mockFriendsFriendId(1));
      }
      clock.advance(const Duration(seconds: 10));
      for (var i = 0; i < 5; i++) {
        await _rejection(s.repo.removeFriend(mockFriendsFriendId(1)));
      }

      // The first thirty leave the window; if the five refusals had counted,
      // five of the next thirty would be refused.
      clock.advance(const Duration(seconds: 50));
      for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
        await s.repo.removeFriend(mockFriendsFriendId(1));
      }
      final error = await _rejection(
        s.repo.removeFriend(mockFriendsFriendId(1)),
      );
      expect(error, isA<RateLimitedException>());
    });

    test('reports have their OWN budget, apart from the social one', () async {
      final clock = _Clock(DateTime.utc(2026, 10, 12, 9));
      final s = _Session(clock: clock);
      for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
        await s.repo.removeFriend(mockFriendsFriendId(1));
      }

      // Social budget spent: a report still goes through.
      await s.repo.reportStudent(mockFriendsFriendId(1));

      for (var i = 1; i < kMockFriendsChatWriteLimit; i++) {
        await s.repo.reportStudent(mockFriendsFriendId(1));
      }
      final error = await _rejection(
        s.repo.reportStudent(mockFriendsFriendId(1)),
      );
      expect(error, isA<RateLimitedException>());
    });

    test('a spent report budget leaves the social writes alone', () async {
      final clock = _Clock(DateTime.utc(2026, 10, 12, 9));
      final s = _Session(clock: clock);
      for (var i = 0; i < kMockFriendsChatWriteLimit; i++) {
        await s.repo.reportStudent(mockFriendsFriendId(1));
      }
      await _rejection(s.repo.reportStudent(mockFriendsFriendId(1)));

      await s.repo.removeFriend(mockFriendsFriendId(1));
    });
  });

  group('the shape of the mock', () {
    test('POST /friends/phone-lookup is NOT served (DR-08)', () async {
      final graph = MockFriendsGraph();

      for (final method in ['POST', 'GET', 'DELETE', 'PUT']) {
        expect(
          graph.handle(method, '/friends/phone-lookup', const {}, const {}),
          isNull,
        );
      }
    });

    test(
      'through the harness a phone lookup falls through to the generic 404',
      () async {
        final s = _Session();

        final error = await _rejection(
          s.dio.post<Map<String, dynamic>>(
            '/friends/phone-lookup',
            data: <String, dynamic>{'phone': 'not-served'},
          ),
        );

        expect((error as ApiException).status, 404);
        expect(error.code, 'not_found');
      },
    );

    test(
      'a route or a method it does not serve is null, so the harness keeps looking',
      () {
        final graph = MockFriendsGraph();
        final id = mockFriendsFriendId(1);

        final notServed = <(String, String)>[
          ('POST', '/friends'),
          ('PUT', '/friends'),
          ('POST', '/friends/suggestions'),
          ('DELETE', '/friends/suggestions'),
          ('GET', '/friends/$id'),
          ('POST', '/friends/$id'),
          ('PUT', '/friend-requests'),
          ('GET', '/friend-requests/$id'),
          ('GET', '/friend-requests/$id/accept'),
          ('DELETE', '/friend-requests/$id/decline'),
          ('PUT', '/blocks'),
          ('GET', '/blocks/$id'),
          ('POST', '/blocks/$id'),
          ('GET', '/student-reports'),
          ('GET', '/conversations'),
          ('GET', '/support/tickets'),
          ('GET', '/me'),
        ];
        for (final (method, path) in notServed) {
          expect(
            graph.handle(method, path, const {}, const {}),
            isNull,
            reason: '$method $path',
          );
        }
      },
    );

    test(
      'state is per graph: a fresh session starts from the fixtures again',
      () async {
        final a = _Session();
        final b = _Session();

        await a.repo.removeFriend(mockFriendsFriendId(1));
        await a.repo.blockStudent(mockFriendsSuggestionId(1));

        expect(await a.allFriends(), hasLength(kMockFriendsFriendCount - 1));
        expect(await b.allFriends(), hasLength(kMockFriendsFriendCount));
        expect(await b.allBlocks(), hasLength(kMockFriendsBlockedCount));
      },
    );

    test('no phone number appears anywhere in the fixtures', () async {
      final s = _Session();
      final source = File('lib/dev/mock_friends.dart').readAsStringSync();

      expect(RegExp(r'\+?20\d{9,}|\b01\d{9}\b').hasMatch(source), isFalse);
      final wire = <String>[
        for (final f in await s.allFriends()) '${f.name}|${f.avatarUrl}',
        for (final c in await s.allSuggestions()) '${c.name}|${c.avatarUrl}',
        for (final c in await s.allBlocks()) '${c.name}|${c.avatarUrl}',
      ].join('\n');
      expect(RegExp(r'\+?\d{10,}').hasMatch(wire), isFalse);
    });
  });
}

/// A settable clock, so a minute can pass without waiting.
class _Clock {
  _Clock(this.now);

  DateTime now;

  DateTime call() => now;

  void advance(Duration by) => now = now.add(by);
}

/// One mock session: a graph, the Dio the app would use over it, and the real
/// repository on top.
class _Session {
  _Session({DateTime? start, _Clock? clock})
    : this.over(
        MockFriendsGraph(
          clock: (clock ?? _Clock(start ?? DateTime.utc(2026, 10, 12, 9))).call,
        ),
      );

  _Session.over(this.graph) {
    dio = Dio(BaseOptions(baseUrl: 'http://mock.local/api/v1'));
    dio.interceptors.addAll([_Adapter(graph), ErrorInterceptor()]);
    repo = FriendsRepository(dio);
  }

  final MockFriendsGraph graph;
  late final Dio dio;
  late final FriendsRepository repo;

  Future<List<Friend>> allFriends() => _walk(repo.listMyFriends);

  Future<List<StudentCard>> allSuggestions() =>
      _walk(repo.listFriendSuggestions);

  Future<List<StudentCard>> allBlocks() => _walk(repo.listMyBlocks);

  Future<List<FriendRequest>> allRequests(FriendRequestDirection direction) =>
      _walk(
        ({String? cursor}) =>
            repo.listMyFriendRequests(direction: direction, cursor: cursor),
      );
}

/// Every row of a list, following the cursor to the end.
Future<List<T>> _walk<T>(
  Future<CursorPage<T>> Function({String? cursor}) fetch,
) async {
  final items = <T>[];
  String? cursor;
  var pages = 0;
  do {
    final page = await fetch(cursor: cursor);
    items.addAll(page.items);
    cursor = page.hasMore ? page.nextCursor : null;
    expect(++pages, lessThan(30), reason: 'the cursor never ends');
  } while (cursor != null);
  return items;
}

/// What `mock_backend.dart`'s dispatch block does with a [MockFriendsReply]:
/// the same three shapes, rejected THROUGH the real ErrorInterceptor so a
/// failure arrives as the typed [AppException] a screen would receive. A route
/// the graph does not serve is the harness's generic `404 not_found`.
class _Adapter extends Interceptor {
  _Adapter(this.graph);

  final MockFriendsGraph graph;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final body = options.data is Map
        ? Map<String, dynamic>.from(options.data as Map)
        : const <String, dynamic>{};
    final reply = graph.handle(
      options.method.toUpperCase(),
      options.path,
      options.queryParameters,
      body,
    );
    switch (reply) {
      case null:
        _reject(handler, options, 404, <String, dynamic>{
          'title': 'No mock for ${options.method} ${options.path}',
          'status': 404,
          'code': 'not_found',
        });
      case MockFriendsOk(:final status, :final data):
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: status,
            data: data,
          ),
        );
      case MockFriendsValidation(:final errors):
        _reject(handler, options, 400, <String, dynamic>{
          'title': 'Validation failed',
          'status': 400,
          'code': 'validation_failed',
          'errors': errors,
        });
      case MockFriendsProblem(
        :final status,
        :final code,
        :final detail,
        :final retryAfterSeconds,
      ):
        _reject(
          handler,
          options,
          status,
          <String, dynamic>{
            'title': detail,
            'status': status,
            'code': code,
            'detail': detail,
          },
          headers: retryAfterSeconds == null
              ? null
              : <String, List<String>>{
                  'retry-after': ['$retryAfterSeconds'],
                },
        );
    }
  }

  void _reject(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    Map<String, dynamic> data, {
    Map<String, List<String>>? headers,
  }) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: status,
          data: data,
          headers: headers == null ? null : Headers.fromMap(headers),
        ),
      ),
      true,
    );
  }
}

/// The mapped [AppException] behind a rejected call - the harness runs the REAL
/// ErrorInterceptor, so this is the type a screen would receive. A call that
/// already went through a repository rethrows the [AppException] itself.
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
