import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/friends/models/friend_models.dart';

import 'friends_fixtures.dart';

/// The friend-graph wire models: `StudentCard`, `Friend`, `FriendRequest` and
/// `SendFriendRequestResult` (`openapi.yaml:4665-4714`).
///
/// What is pinned here is what a hand-written reader of the YAML gets wrong:
/// the OMITTED `points`, the two closed enums, the required keys, and the fact
/// that a minor's name and id never reach a `toString`.
void main() {
  group('StudentCard', () {
    test('decodes the three contract fields', () {
      final card = StudentCard.fromJson(wireCard());

      expect(card.studentId, studentIdA);
      expect(card.name, sampleNameA);
      expect(card.avatarUrl, 'https://example.test/avatar-a.png');
    });

    test('ignores a key it has no field for (no points, level or phone)', () {
      final card = StudentCard.fromJson({
        ...wireCard(),
        'points': 99,
        'level': 3,
        'phone': 'must-not-matter',
      });

      expect(card, studentCard());
    });

    for (final key in ['studentId', 'name', 'avatarUrl']) {
      test('a missing required "$key" throws', () {
        final json = wireCard()..remove(key);

        expect(() => StudentCard.fromJson(json), throwsA(isA<TypeError>()));
      });
    }

    test('equality is by value', () {
      expect(studentCard(), studentCard());
      expect(studentCard(), isNot(studentCard(name: sampleNameB)));
    });
  });

  group('Friend', () {
    test(
      'decodes every field, level as an int and friendsSince as an instant',
      () {
        final f = Friend.fromJson(wireFriend());

        expect(f.studentId, studentIdA);
        expect(f.name, sampleNameA);
        expect(f.level, 4);
        expect(f.points, 640);
        expect(f.friendsSince, DateTime.utc(2026, 10, 1, 9, 30));
        expect(f.friendsSince.isUtc, isTrue);
      },
    );

    test('an OMITTED points key is null - never 0', () {
      final f = Friend.fromJson(wireFriend(hidePoints: true));

      expect(f.points, isNull);
    });

    test('an explicit null points is null too', () {
      final f = Friend.fromJson(wireFriend(explicitNullPoints: true));

      expect(f.points, isNull);
    });

    test('a real zero is kept, so null and zero stay different', () {
      final f = Friend.fromJson(wireFriend(points: 0));

      expect(f.points, 0);
    });

    for (final key in [
      'studentId',
      'name',
      'avatarUrl',
      'level',
      'friendsSince',
    ]) {
      test('a missing required "$key" throws', () {
        final json = wireFriend()..remove(key);

        expect(() => Friend.fromJson(json), throwsA(isA<TypeError>()));
      });
    }

    test('an unparseable friendsSince throws', () {
      expect(
        () => Friend.fromJson(wireFriend(friendsSince: 'not a date')),
        throwsFormatException,
      );
    });
  });

  group('FriendRequest', () {
    test('decodes an incoming request with its nested StudentCard', () {
      final r = FriendRequest.fromJson(wireRequest());

      expect(r.requestId, requestIdA);
      expect(r.direction, FriendRequestDirection.incoming);
      expect(r.student, studentCard());
      expect(r.createdAt, DateTime.utc(2026, 10, 9, 12));
    });

    test('decodes an outgoing request', () {
      final r = FriendRequest.fromJson(wireRequest(direction: 'outgoing'));

      expect(r.direction, FriendRequestDirection.outgoing);
    });

    test('an unknown direction throws - the enum is closed', () {
      expect(
        () => FriendRequest.fromJson(wireRequest(direction: 'sideways')),
        throwsArgumentError,
      );
    });

    for (final key in ['requestId', 'direction', 'student', 'createdAt']) {
      test('a missing required "$key" throws', () {
        final json = wireRequest()..remove(key);

        expect(() => FriendRequest.fromJson(json), throwsA(isA<Error>()));
      });
    }

    test('the direction wire values are the contract spellings', () {
      expect(FriendRequestDirection.incoming.wire, 'incoming');
      expect(FriendRequestDirection.outgoing.wire, 'outgoing');
      expect(FriendRequestDirection.values, hasLength(2));
    });
  });

  group('SendFriendRequestResult', () {
    test('pending carries the new request', () {
      final result = SendFriendRequestResult.fromJson({
        'status': 'pending',
        'request': wireRequest(direction: 'outgoing'),
      });

      expect(result.status, SendFriendRequestStatus.pending);
      expect(result.isPending, isTrue);
      expect(result.isAccepted, isFalse);
      expect(result.request?.direction, FriendRequestDirection.outgoing);
      expect(result.friend, isNull);
    });

    test('accepted carries the new friend (adr-185 D7)', () {
      final result = SendFriendRequestResult.fromJson({
        'status': 'accepted',
        'friend': wireFriend(hidePoints: true),
      });

      expect(result.status, SendFriendRequestStatus.accepted);
      expect(result.isAccepted, isTrue);
      expect(result.isPending, isFalse);
      expect(result.friend?.studentId, studentIdA);
      expect(result.friend?.points, isNull);
      expect(result.request, isNull);
    });

    test('only status is required', () {
      final result = SendFriendRequestResult.fromJson({'status': 'pending'});

      expect(result.request, isNull);
      expect(result.friend, isNull);
    });

    test('a missing status throws', () {
      expect(
        () => SendFriendRequestResult.fromJson({'request': wireRequest()}),
        throwsA(isA<Error>()),
      );
    });

    test('an unknown status throws - the enum is closed', () {
      expect(
        () => SendFriendRequestResult.fromJson({'status': 'maybe'}),
        throwsArgumentError,
      );
    });
  });

  group('toString never carries a name or an id', () {
    bool leaks(String text) =>
        text.contains(sampleNameA) ||
        text.contains(studentIdA) ||
        text.contains(requestIdA) ||
        text.contains('example.test');

    test('StudentCard', () {
      expect(leaks('${studentCard()}'), isFalse);
    });

    test('Friend', () {
      final text = '${Friend.fromJson(wireFriend())}';

      expect(leaks(text), isFalse);
      expect(text, 'Friend(hasPoints: true)');
    });

    test('FriendRequest', () {
      expect(leaks('${FriendRequest.fromJson(wireRequest())}'), isFalse);
    });

    test('SendFriendRequestResult', () {
      final result = SendFriendRequestResult.fromJson({
        'status': 'accepted',
        'friend': wireFriend(),
      });

      expect(leaks('$result'), isFalse);
    });

    test('and a failed expectation does not print one either', () {
      // The message a mismatch builds is made from toString.
      final message =
          '${Friend.fromJson(wireFriend())} vs '
          '${StudentCard.fromJson(wireCard(name: sampleNameB))}';

      expect(message, isNot(contains(sampleNameA)));
      expect(message, isNot(contains(sampleNameB)));
    });
  });
}
