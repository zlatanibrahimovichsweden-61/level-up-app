import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/referral/models/my_invite.dart';

/// `MyInvite` (`GET /me/invite`): the three required fields decode verbatim, a
/// missing or mistyped one fails loudly, and the code never shows up in the
/// string form.
void main() {
  // A sample in the contract's alphabet (`^[0-9A-HJKMNP-TV-Z]{8}$`), nobody's
  // real code.
  const sampleCode = 'K7M2Q9XD';

  Map<String, dynamic> wire({
    Object? code = sampleCode,
    Object? friendsJoined = 4,
    Object? pointsEarned = 30,
  }) => <String, dynamic>{
    'code': code,
    'friendsJoined': friendsJoined,
    'pointsEarned': pointsEarned,
  };

  group('decoding', () {
    test('reads the three fields verbatim', () {
      final invite = MyInvite.fromJson(wire());

      expect(invite.code, sampleCode);
      expect(invite.friendsJoined, 4);
      expect(invite.pointsEarned, 30);
    });

    test('the code is shown exactly: not trimmed, not re-cased', () {
      // Not a valid code on the wire (the server never sends one), which is the
      // point: nothing on the client "fixes" what the server said.
      final invite = MyInvite.fromJson(wire(code: ' k7m2q9xd '));

      expect(invite.code, ' k7m2q9xd ');
    });

    test('pointsEarned is the server figure, not 10 x friendsJoined', () {
      final invite = MyInvite.fromJson(
        wire(friendsJoined: 4, pointsEarned: 30),
      );

      expect(invite.pointsEarned, isNot(invite.friendsJoined * 10));
      expect(invite.pointsEarned, 30);
    });

    test('zero counts are a normal answer', () {
      final invite = MyInvite.fromJson(wire(friendsJoined: 0, pointsEarned: 0));

      expect(invite.friendsJoined, 0);
      expect(invite.pointsEarned, 0);
    });

    test('an integer sent as a JSON number with a fraction part of zero '
        'still decodes (num.toInt)', () {
      final invite = MyInvite.fromJson(
        wire(friendsJoined: 4.0, pointsEarned: 30.0),
      );

      expect(invite.friendsJoined, 4);
      expect(invite.pointsEarned, 30);
    });

    test('unknown extra keys are ignored', () {
      final invite = MyInvite.fromJson(<String, dynamic>{
        ...wire(),
        'futureField': 'x',
      });

      expect(invite.code, sampleCode);
    });

    for (final key in ['code', 'friendsJoined', 'pointsEarned']) {
      test('a response without $key is schema drift and throws', () {
        final json = wire()..remove(key);

        expect(() => MyInvite.fromJson(json), throwsA(isA<TypeError>()));
      });
    }

    test('a null code is not accepted', () {
      expect(
        () => MyInvite.fromJson(wire(code: null)),
        throwsA(isA<TypeError>()),
      );
    });

    test('a string count is not accepted', () {
      expect(
        () => MyInvite.fromJson(wire(friendsJoined: '4')),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('value semantics', () {
    test('equal when every field is equal', () {
      expect(MyInvite.fromJson(wire()), MyInvite.fromJson(wire()));
      expect(
        MyInvite.fromJson(wire()).hashCode,
        MyInvite.fromJson(wire()).hashCode,
      );
    });

    test('different when any field differs', () {
      expect(
        MyInvite.fromJson(wire()),
        isNot(MyInvite.fromJson(wire(code: 'ZZZZZZZZ'))),
      );
      expect(
        MyInvite.fromJson(wire()),
        isNot(MyInvite.fromJson(wire(friendsJoined: 5))),
      );
      expect(
        MyInvite.fromJson(wire()),
        isNot(MyInvite.fromJson(wire(pointsEarned: 40))),
      );
    });

    test('toJson round-trips', () {
      expect(MyInvite.fromJson(wire()).toJson(), wire());
    });
  });

  group('never logged', () {
    test('toString does not contain the code', () {
      final invite = MyInvite.fromJson(wire());

      expect(invite.toString(), isNot(contains(sampleCode)));
      expect('$invite', isNot(contains(sampleCode)));
      expect(
        invite.toString(),
        'MyInvite({friendsJoined: 4, pointsEarned: 30})',
      );
    });

    test('a failing-matcher description does not either', () {
      // `expect` formats the actual value with toString; a mismatch message is
      // exactly the sort of text that ends up in CI logs.
      final invite = MyInvite.fromJson(wire());

      String? description;
      try {
        expect(invite, 'not an invite');
      } on TestFailure catch (e) {
        description = e.message;
      }

      expect(description, isNotNull);
      expect(description, contains('MyInvite('));
      expect(description, isNot(contains(sampleCode)));
    });
  });
}
