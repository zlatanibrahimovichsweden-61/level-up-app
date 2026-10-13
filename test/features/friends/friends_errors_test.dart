import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/friends/friends_errors.dart';

/// The four friend-graph error codes and the predicates that recognise them
/// (`contract/error-codes.md:36-39`).
void main() {
  // (code, HTTP status, predicate) - the table the contract states.
  final cases = <({String code, int status, bool Function(Object?) matches})>[
    (
      code: 'friend_target_unavailable',
      status: 404,
      matches: isFriendTargetUnavailable,
    ),
    (
      code: 'friend_request_not_found',
      status: 404,
      matches: isFriendRequestNotFound,
    ),
    (code: 'already_friends', status: 409, matches: isAlreadyFriends),
    (
      code: 'friend_request_already_pending',
      status: 409,
      matches: isFriendRequestAlreadyPending,
    ),
  ];

  group('the codes are the contract\'s', () {
    late String errorCodes;

    setUpAll(() {
      errorCodes = File('contract/error-codes.md').readAsStringSync();
    });

    test('the constants spell the four codes exactly', () {
      expect(FriendErrorCodes.friendTargetUnavailable, cases[0].code);
      expect(FriendErrorCodes.friendRequestNotFound, cases[1].code);
      expect(FriendErrorCodes.alreadyFriends, cases[2].code);
      expect(FriendErrorCodes.friendRequestAlreadyPending, cases[3].code);
    });

    for (final c in cases) {
      test('${c.code} is a ${c.status} row in contract/error-codes.md', () {
        // `| `code` | 404 | ...` - the code and its status, as the table has
        // them. If the pin moves a code or its status, this is where it shows.
        expect(
          RegExp(
            '^\\| `${c.code}` \\| ${c.status} \\|',
            multiLine: true,
          ).hasMatch(errorCodes),
          isTrue,
        );
      });
    }
  });

  group('each predicate recognises exactly its own code', () {
    for (final c in cases) {
      test(c.code, () {
        final error = ApiException(status: c.status, code: c.code);

        for (final other in cases) {
          expect(
            other.matches(error),
            other.code == c.code,
            reason: '${c.code} vs ${other.code}',
          );
        }
      });
    }

    test('a plain ApiException is enough - no subclass is needed', () {
      expect(
        isFriendTargetUnavailable(
          const ApiException(status: 404, code: 'friend_target_unavailable'),
        ),
        isTrue,
      );
    });
  });

  group('everything else is not a friend-graph error', () {
    final others = <String, Object?>{
      'null': null,
      'a String': 'friend_target_unavailable',
      'a plain Exception': Exception('friend_target_unavailable'),
      'UnknownException': const UnknownException(),
      'OfflineException': const OfflineException(),
      'NetworkException': const NetworkException(),
      'a different ApiException': const ApiException(
        status: 404,
        code: 'not_found',
      ),
      'account_pending_deletion': const ApiException(
        status: 403,
        code: 'account_pending_deletion',
      ),
      'rate_limited': const RateLimitedException(),
      'validation_failed': const ValidationException(errors: {}),
      'a 401': const UnauthorizedException(code: 'authentication_required'),
    };

    for (final entry in others.entries) {
      test(entry.key, () {
        for (final c in cases) {
          expect(c.matches(entry.value), isFalse, reason: c.code);
        }
      });
    }
  });

  test('the shared failures keep their one owner', () {
    // Not re-declared in the friends feature: the app already recognises them.
    expect(
      isAccountPendingDeletion(
        const ApiException(status: 403, code: 'account_pending_deletion'),
      ),
      isTrue,
    );
    expect(const RateLimitedException(), isA<ApiException>());
  });
}
