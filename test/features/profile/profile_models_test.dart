import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/profile/models/entitlement_state.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';

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
      expect(profile.geography.city, isA<CodedCity>());
      // format: date → calendar date, no timezone shift.
      expect(profile.dateOfBirth, DateTime(2008, 5, 14));
      expect(
        profile.entitlements.single.type,
        EntitlementType.baseSubscription,
      );
    });

    test(
      'parses a university profile (school block null, governorate absent)',
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
            'city': namedRefJson(
              'city-nasr',
            ), // governorate key omitted entirely
          };

        final profile = StudentProfile.fromJson(json);

        expect(profile.track, Track.university);
        expect(profile.school, isNull);
        expect(profile.university!.yearNumber, 2);
        expect(profile.geography.governorate, isNull);
      },
    );

    test('a school student with NO school parses (adr-028 §2)', () {
      // The skipped-school case: `school.school` is null but the block itself
      // is present. This shape needed no model change — it was already
      // nullable under v1.0, where it meant "non-Egypt, typed a name instead".
      final json = schoolProfileJson()
        ..['school'] = <String, dynamic>{
          'school': null,
          'stage': 'secondary2',
          'educationSystem': 'nationalLanguages',
        };

      final profile = StudentProfile.fromJson(json);

      expect(profile.school, isNotNull);
      expect(profile.school!.school, isNull);
      expect(profile.school!.stage, 'secondary2');
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

    test(
      'an UNKNOWN type degrades to EntitlementType.unknown, never throws',
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
      },
    );

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

  /// adr-028 §1. Under v1.0 `geography.city` was a bare `NamedRef`, so the
  /// free-text arm below would have thrown on a well-formed `GET /me` — the one
  /// drift in this contract bump that was a runtime crash rather than a wrong
  /// message.
  group('ProfileCity — the city union', () {
    Map<String, dynamic> withCity(Object city) => schoolProfileJson()
      ..['geography'] = <String, dynamic>{
        'countryCode': 'EG',
        'governorate': namedRefJson('gov-cairo'),
        'city': city,
      };

    test('the coded arm: discriminated by the PRESENCE of id', () {
      final city = StudentProfile.fromJson(
        withCity(namedRefJson('city-nasr')),
      ).geography.city;

      expect(city, isA<CodedCity>());
      final ref = (city as CodedCity).ref;
      expect(ref.id, 'city-nasr');
      expect(ref.nameAr, 'القاهرة');
      expect(ref.nameEn, 'Cairo');
    });

    test('the free-text arm: { name } only, no id', () {
      final city = StudentProfile.fromJson(
        withCity(<String, dynamic>{'name': 'Somewhere Uncoded'}),
      ).geography.city;

      expect(city, isA<FreeTextCity>());
      expect((city as FreeTextCity).name, 'Somewhere Uncoded');
    });

    test('city is REQUIRED — an absent one throws, it is never defaulted', () {
      final json = schoolProfileJson()
        ..['geography'] = <String, dynamic>{'countryCode': 'EG'};

      expect(() => StudentProfile.fromJson(json), throwsA(isA<Object>()));
    });

    test('a switch over the union is EXHAUSTIVE — no default arm needed', () {
      // This is the whole reason for a sealed union rather than a flat class
      // with optional fields: adding a third arm must break every call site at
      // COMPILE time, not at runtime on a student's phone. If this stops
      // compiling without a `default:`, the union grew and Day 8's screens
      // need revisiting.
      String label(ProfileCity city) => switch (city) {
        CodedCity(:final ref) => ref.nameEn,
        FreeTextCity(:final name) => name,
      };

      expect(
        label(ProfileCity.coded(NamedRef.fromJson(namedRefJson('c')))),
        'Cairo',
      );
      expect(label(const ProfileCity.freeText('Al Ain')), 'Al Ain');
    });

    test('the union round-trips back to the shape it came from', () {
      final coded = StudentProfile.fromJson(
        withCity(namedRefJson('city-nasr')),
      ).geography.city.toJson();
      expect(coded['id'], 'city-nasr');

      final free = StudentProfile.fromJson(
        withCity(<String, dynamic>{'name': 'Al Ain'}),
      ).geography.city.toJson();
      expect(free['name'], 'Al Ain');
    });
  });

  /// Contract 3.22.0-m1 added two optional fields to `StudentProfile`. Both are
  /// absent from `schoolProfileJson()`, which is the point: the fixture is the
  /// payload the app has been decoding all along, and it must keep decoding.
  group('the 3.22.0-m1 additive fields', () {
    test('an EXISTING payload without either field still parses', () {
      final profile = StudentProfile.fromJson(schoolProfileJson());

      expect(profile.pendingDeletion, isNull);
      expect(profile.school!.parentReportStatus, isNull);
      // And nothing else moved.
      expect(profile.points.total, 2450);
      expect(profile.school!.stage, 'secondary2');
    });

    test('pendingDeletion parses when the key IS present', () {
      final json = schoolProfileJson()
        ..['pendingDeletion'] = <String, dynamic>{
          'effectiveAt': '2026-10-21T09:30:00Z',
        };

      final profile = StudentProfile.fromJson(json);

      expect(profile.pendingDeletion, isNotNull);
      expect(
        profile.pendingDeletion!.effectiveAt.toUtc(),
        DateTime.utc(2026, 10, 21, 9, 30),
      );
    });

    test('ABSENCE is the flag — the contract never sends null, but a null '
        'reads the same way', () {
      // `openapi.yaml:2430-2436`: "Absent otherwise — never `null`". The client
      // question is only ever "is a deletion pending?", so both decode to null
      // rather than one of them throwing.
      final absent = StudentProfile.fromJson(schoolProfileJson());
      final explicitNull = StudentProfile.fromJson(
        schoolProfileJson()..['pendingDeletion'] = null,
      );

      expect(absent.pendingDeletion, isNull);
      expect(explicitNull.pendingDeletion, isNull);
    });

    test('parentReportStatus parses both contract values', () {
      for (final value in ['active', 'inactive']) {
        final json = schoolProfileJson();
        (json['school']! as Map<String, dynamic>)['parentReportStatus'] = value;

        expect(StudentProfile.fromJson(json).school!.parentReportStatus, value);
      }
    });

    test('parentReportStatus is NOT required — `required: [stage, '
        'educationSystem]` is the whole list', () {
      final json = schoolProfileJson();
      final school = json['school']! as Map<String, dynamic>;
      school.remove('parentReportStatus');

      expect(() => StudentProfile.fromJson(json), returnsNormally);
    });

    test('an unknown parentReportStatus value does not throw', () {
      // Kept a wire String rather than a generated enum precisely so a value
      // nobody reads cannot take down the whole profile parse — and with it
      // Home, which is powered by this one call.
      final json = schoolProfileJson();
      (json['school']! as Map<String, dynamic>)['parentReportStatus'] =
          'somethingNew';

      expect(
        StudentProfile.fromJson(json).school!.parentReportStatus,
        'somethingNew',
      );
    });

    test('a university profile has no school block to carry it', () {
      final profile = StudentProfile.fromJson(universityProfileJson());
      expect(profile.school, isNull);
    });
  });
}
