import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';

import 'profile_fixtures.dart';

/// The `PATCH /me` body, at the level where the decision actually lives.
///
/// The whole reason this class is hand-written is `email`, so most of this file
/// is about `email`. The contract gives it THREE states —
///
///   untouched → the key is ABSENT
///   typed     → the key carries the string
///   cleared   → the key carries an explicit JSON `null`
///
/// — and the repo's usual `@JsonKey(includeIfNull: false)` habit collapses the
/// third into the first. That collapse is silent: the request succeeds, the
/// server reads "unchanged", and the address the student deleted survives. The
/// `contains a null` assertions below are the only thing standing between this
/// app and that bug, so they assert the KEY's presence, not just its value.
void main() {
  group('only changed fields reach the wire', () {
    test('an untouched form sends nothing at all', () {
      final update = ProfileUpdate.diff(
        current: schoolProfile(),
        name: 'Ahmed Mohamed',
        email: '',
      );

      expect(update.toJson(), isEmpty);
      expect(update.isEmpty, isTrue);
    });

    test('a changed name sends `name` and NOTHING else', () {
      final update = ProfileUpdate.diff(
        current: schoolProfile(),
        name: 'Ahmed Ali',
        email: '',
      );

      expect(update.toJson(), <String, dynamic>{'name': 'Ahmed Ali'});
    });

    test('whitespace around an unchanged name is not a change', () {
      final update = ProfileUpdate.diff(
        current: schoolProfile(),
        name: '  Ahmed Mohamed  ',
        email: '',
      );

      expect(update.toJson(), isEmpty);
    });

    test('a picked avatar sends `avatarId`', () {
      final update = ProfileUpdate.diff(
        current: schoolProfile(),
        name: 'Ahmed Mohamed',
        email: '',
        avatarId: 'avatar-99',
      );

      expect(update.toJson(), <String, dynamic>{'avatarId': 'avatar-99'});
    });

    test('re-picking the avatar already on the account is not a change', () {
      final profile = schoolProfile();
      final update = ProfileUpdate.diff(
        current: profile,
        name: profile.name,
        email: '',
        avatarId: profile.avatar.id,
      );

      expect(update.toJson(), isEmpty);
    });

    test('the six read-only fields have no way into the body', () {
      // Everything the frame draws that `PATCH /me` cannot accept: there is no
      // constructor argument, no field and no key for any of it. The assertion
      // is on the whole body, so adding one later breaks this test.
      final update = ProfileUpdate.diff(
        current: schoolProfile(),
        name: 'Ahmed Ali',
        email: 'a@b.com',
        avatarId: 'avatar-99',
      );

      expect(
        update.toJson().keys,
        unorderedEquals(<String>['name', 'email', 'avatarId']),
      );
      for (final forbidden in const [
        'phone',
        'parentPhone',
        'city',
        'cityId',
        'cityName',
        'schoolId',
        'school',
        'educationSystem',
        'stage',
        'dateOfBirth',
        'track',
      ]) {
        expect(
          update.toJson().containsKey(forbidden),
          isFalse,
          reason: '$forbidden is immutable after registration (S20)',
        );
      }
    });
  });

  group('email — the three states are distinguishable', () {
    test('UNTOUCHED: the key is absent, not null', () {
      final update = ProfileUpdate.diff(
        current: profileWithEmail(), // already has ahmed@example.com
        name: 'Ahmed Mohamed',
        email: 'ahmed@example.com', // unchanged
      );

      expect(update.email, const EmailPatch.unchanged());
      expect(update.toJson().containsKey('email'), isFalse);
      expect(update.toJson(), isEmpty);
    });

    test('TYPED: the key carries the string', () {
      final update = ProfileUpdate.diff(
        current: schoolProfile(), // email: null
        name: 'Ahmed Mohamed',
        email: 'new@example.com',
      );

      expect(update.email, const EmailPatch.set('new@example.com'));
      expect(update.toJson(), <String, dynamic>{'email': 'new@example.com'});
    });

    test('CLEARED: the key is PRESENT and its value is null', () {
      final update = ProfileUpdate.diff(
        current: profileWithEmail(),
        name: 'Ahmed Mohamed',
        email: '', // the student emptied the box
      );

      expect(update.email, const EmailPatch.cleared());
      // Both halves matter. `containsKey` is the half that `includeIfNull:
      // false` would break — a body of `{}` also has a null `['email']`.
      expect(
        update.toJson().containsKey('email'),
        isTrue,
        reason:
            'clearing an email MUST send the key; omitting it means '
            '"unchanged" and the old address survives',
      );
      expect(update.toJson()['email'], isNull);
      expect(update.isEmpty, isFalse);
    });

    test('CLEARED survives JSON encoding as a literal null', () {
      // The end of the road: what Dio actually puts on the wire. A map with an
      // explicit null encodes to `"email":null`; a map missing the key does
      // not, and this is the only assertion that can tell those apart after
      // serialization.
      final update = ProfileUpdate.diff(
        current: profileWithEmail(),
        name: 'Ahmed Mohamed',
        email: '',
      );

      expect(jsonEncode(update.toJson()), '{"email":null}');
    });

    test('emptying a field that was ALREADY empty says nothing', () {
      // Without this the student who never had an email would send
      // `"email": null` on every single save — a write that changes nothing.
      final update = ProfileUpdate.diff(
        current: schoolProfile(), // email: null
        name: 'Ahmed Mohamed',
        email: '',
      );

      expect(update.email, const EmailPatch.unchanged());
      expect(update.toJson(), isEmpty);
    });

    test('replacing one address with another sends the new one', () {
      final update = ProfileUpdate.diff(
        current: profileWithEmail(),
        name: 'Ahmed Mohamed',
        email: 'other@example.com',
      );

      expect(update.toJson(), <String, dynamic>{'email': 'other@example.com'});
    });

    test('the default constructor leaves email alone', () {
      // Step 3's Settings toggles build the body this way — privacy only, and
      // an email they never asked about must not be touched.
      const update = ProfileUpdate(leaderboardVisible: false);

      expect(update.toJson(), <String, dynamic>{'leaderboardVisible': false});
      expect(update.toJson().containsKey('email'), isFalse);
    });

    test('scoreHidden false is sent, not swallowed as "falsy"', () {
      const update = ProfileUpdate(scoreHidden: false);

      expect(update.toJson(), <String, dynamic>{'scoreHidden': false});
    });
  });

  // E4-02: the update carries the student's own name, address and avatar.
  group('toString never prints what the student typed', () {
    test('ProfileUpdate names the fields, not their values', () {
      const update = ProfileUpdate(
        name: 'SENTINEL NAME',
        email: EmailPatch.set('sentinel@example.test'),
        avatarId: 'SENTINEL-AVATAR',
        scoreHidden: true,
      );

      expect(
        update.toString(),
        'ProfileUpdate(fields: [name, email, avatarId, scoreHidden])',
      );
      expect('$update', isNot(contains('SENTINEL')));
      expect('$update', isNot(contains('sentinel@')));
      // The wire body is untouched.
      expect(update.toJson(), <String, dynamic>{
        'name': 'SENTINEL NAME',
        'email': 'sentinel@example.test',
        'avatarId': 'SENTINEL-AVATAR',
        'scoreHidden': true,
      });
    });

    test('EmailPatch.set hides the address; the other arms are plain', () {
      expect(
        const EmailPatch.set('sentinel@example.test').toString(),
        'EmailPatch.set(<redacted>)',
      );
      expect(const EmailPatch.unchanged().toString(), 'EmailPatch.unchanged()');
      expect(const EmailPatch.cleared().toString(), 'EmailPatch.cleared()');
    });
  });

  group('EmailPatch', () {
    test('the three arms are not equal to each other', () {
      expect(const EmailPatch.unchanged(), isNot(const EmailPatch.cleared()));
      expect(const EmailPatch.cleared(), isNot(const EmailPatch.set('')));
      expect(const EmailPatch.set('a'), isNot(const EmailPatch.set('b')));
      expect(const EmailPatch.set('a'), const EmailPatch.set('a'));
    });
  });
}
