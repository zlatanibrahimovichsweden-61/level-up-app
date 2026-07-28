import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/profile/models/entitlement_state.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';

import 'profile_fixtures.dart';

/// `fromJson` against payloads shaped from `contract/openapi.yaml`
/// (`StudentProfile`, `EntitlementState`) — not hand-invented shapes.
///
/// The point of the "missing required field throws" cases: a defensive default
/// would hide contract drift, and on `points`/`level` it would show a student
/// the wrong score.
void main() {
  group('StudentProfile.fromJson', () {
    test('parses a full school profile', () {
      final profile = StudentProfile.fromJson(schoolProfileJson());

      expect(profile.track, Track.school);
      expect(profile.name, 'Ahmed Mohamed');
      // Server-authoritative trio — carried through untouched.
      expect(profile.points.total, 2450);
      expect(profile.points.school, 2450);
      expect(profile.level, 8);
      expect(profile.badges, 0);
      expect(profile.avatar.url, 'https://cdn.levelup.example/avatars/1.png');
      expect(profile.school!.stage, 'secondary2');
      expect(profile.university, isNull);
      expect(profile.geography.governorate!.nameEn, 'Cairo');
      // format: date → calendar date, no timezone shift.
      expect(profile.dateOfBirth, DateTime(2008, 5, 14));
      expect(profile.entitlements.single.type, EntitlementType.baseSubscription);
    });

    test('parses a university profile (school block null, governorate absent)',
        () {
      final json = schoolProfileJson()
        ..['track'] = 'university'
        ..['school'] = null
        ..['university'] = <String, dynamic>{
          'university': namedRefJson('uni-cairo'),
          'faculty': namedRefJson('fac-medicine'),
          'yearNumber': 2,
        }
        ..['geography'] = <String, dynamic>{
          'countryCode': 'EG',
          'city': namedRefJson('city-nasr'), // governorate key omitted entirely
        };

      final profile = StudentProfile.fromJson(json);

      expect(profile.track, Track.university);
      expect(profile.school, isNull);
      expect(profile.university!.yearNumber, 2);
      expect(profile.geography.governorate, isNull);
    });

    test('optional email may be absent entirely', () {
      final json = schoolProfileJson()..remove('email');
      expect(StudentProfile.fromJson(json).email, isNull);
    });

    test('a missing REQUIRED field throws rather than defaulting', () {
      for (final field in ['points', 'level', 'badges', 'avatar', 'track']) {
        final json = schoolProfileJson()..remove(field);
        expect(
          () => StudentProfile.fromJson(json),
          throwsA(isA<Object>()),
          reason: 'missing $field must surface as a parse failure',
        );
      }
    });

    test('an unknown track value throws — the contract set is closed', () {
      final json = schoolProfileJson()..['track'] = 'apprenticeship';
      expect(() => StudentProfile.fromJson(json), throwsA(isA<Object>()));
    });
  });

  group('EntitlementState.fromJson', () {
    test('parses both contract types with their optional dates', () {
      final base = EntitlementState.fromJson(<String, dynamic>{
        'type': 'baseSubscription',
        'active': true,
        'expiresAt': '2026-12-31T23:59:59Z',
        'inGrace': false,
        'graceEndsAt': null,
      });
      final flashcards = EntitlementState.fromJson(<String, dynamic>{
        'type': 'flashcardSubscription',
        'active': false,
        'inGrace': true,
        'graceEndsAt': '2026-08-02T00:00:00Z',
      });

      expect(base.type, EntitlementType.baseSubscription);
      expect(base.active, isTrue);
      expect(base.expiresAt, DateTime.utc(2026, 12, 31, 23, 59, 59));
      // Contract-optional: absent expiresAt parses as null, it does not throw.
      expect(flashcards.type, EntitlementType.flashcardSubscription);
      expect(flashcards.expiresAt, isNull);
      expect(flashcards.inGrace, isTrue);
    });

    test('an UNKNOWN type degrades to EntitlementType.unknown, never throws',
        () {
      // The contract marks this set extensible: a future entitlement must not
      // break every existing build's /me parse.
      final future = EntitlementState.fromJson(<String, dynamic>{
        'type': 'tutoringSubscription',
        'active': true,
        'inGrace': false,
      });

      expect(future.type, EntitlementType.unknown);
      expect(future.active, isTrue);
    });

    test('the { items: [...] } envelope of GET /me/entitlements parses', () {
      final response = EntitlementsResponse.fromJson(<String, dynamic>{
        'items': <dynamic>[
          <String, dynamic>{
            'type': 'baseSubscription',
            'active': false,
            'inGrace': false,
          },
        ],
      });

      expect(response.items, hasLength(1));
      expect(response.items.single.active, isFalse);
    });
  });
}
