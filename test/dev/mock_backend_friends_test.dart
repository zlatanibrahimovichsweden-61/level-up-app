import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_friends.dart';
import 'package:level_up_app/features/friends/friends_errors.dart';
import 'package:level_up_app/features/friends/models/friend_models.dart';
import 'package:level_up_app/features/friends/repository/friends_repository.dart';

/// The friend graph, reached through the real `buildMockDio` chain
/// (MockBackendInterceptor -> ErrorInterceptor) and the real repository. The
/// rules themselves are pinned in `mock_friends_test.dart`; this proves the
/// dispatch block in `mock_backend.dart` is wired.
void main() {
  FriendsRepository newRepo() =>
      FriendsRepository(buildMockDio(latency: Duration.zero));

  test('friends, suggestions, requests and blocks are served', () async {
    final repo = newRepo();

    expect((await repo.listMyFriends()).items, hasLength(20));
    expect((await repo.listFriendSuggestions()).items, hasLength(20));
    expect(
      (await repo.listMyFriendRequests(
        direction: FriendRequestDirection.incoming,
      )).items,
      hasLength(20),
    );
    expect((await repo.listMyBlocks()).items, hasLength(20));
  });

  test(
    'a write and its documented failures arrive as typed exceptions',
    () async {
      final repo = newRepo();

      final sent = await repo.sendFriendRequest(mockFriendsSuggestionId(1));
      expect(sent.isPending, isTrue);

      await expectLater(
        repo.sendFriendRequest(mockFriendsSuggestionId(1)),
        throwsA(predicate(isFriendRequestAlreadyPending)),
      );
      await expectLater(
        repo.sendFriendRequest(mockFriendsOtherTrackStudentId()),
        throwsA(predicate(isFriendTargetUnavailable)),
      );
      await repo.blockStudent(mockFriendsSuggestionId(2));
      await repo.reportStudent(mockFriendsSuggestionId(2));
    },
  );

  test('the phone lookup is not served: the generic 404', () async {
    final dio = buildMockDio(latency: Duration.zero);

    try {
      await dio.post<Object?>(
        '/friends/phone-lookup',
        data: <String, dynamic>{'phone': 'not-served'},
      );
      fail('expected a rejection');
    } on DioException catch (e) {
      expect((e.error! as ApiException).status, 404);
      expect((e.error! as ApiException).code, 'not_found');
    }
  });

  test('429 carries a Retry-After through the harness', () async {
    final repo = newRepo();
    for (var i = 0; i < kMockFriendsSocialWriteLimit; i++) {
      await repo.unblockStudent(mockFriendsBlockedId(1));
    }

    await expectLater(
      repo.unblockStudent(mockFriendsBlockedId(1)),
      throwsA(
        isA<RateLimitedException>().having(
          (e) => e.retryAfter,
          'retryAfter',
          isNotNull,
        ),
      ),
    );
  });
}
