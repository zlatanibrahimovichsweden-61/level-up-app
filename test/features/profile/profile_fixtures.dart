/// Shared `GET /me` fixtures, shaped from `contract/openapi.yaml`
/// (`StudentProfile`) — not hand-invented. Used by the model, repository,
/// notifier and Home screen tests so they all agree on one payload.
library;

import 'package:level_up_app/features/profile/models/entitlement_state.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';

Map<String, dynamic> namedRefJson(String id) => <String, dynamic>{
      'id': id,
      'nameAr': 'القاهرة',
      'nameEn': 'Cairo',
    };

/// A level-8 school student with 2,450 points — the frame's own figures, so the
/// rendered Home can be compared against Figma `337:5303` directly.
Map<String, dynamic> schoolProfileJson() => <String, dynamic>{
      'id': '0197b2f3-9999-7cc3-9b4e-000000000001',
      'track': 'school',
      'name': 'Ahmed Mohamed',
      'phone': '+201001234567',
      'email': null,
      'dateOfBirth': '2008-05-14',
      'avatar': <String, dynamic>{
        'type': 'default',
        'id': '0197b2f3-0008-7cc3-9b4e-000000000001',
        'url': 'https://cdn.levelup.example/avatars/1.png',
      },
      'geography': <String, dynamic>{
        'countryCode': 'EG',
        'governorate': namedRefJson('gov-cairo'),
        'city': namedRefJson('city-nasr'),
      },
      'school': <String, dynamic>{
        // adr-028 §2 removed `schoolName` from the contract entirely; only the
        // coded `school` (nullable) remains.
        'school': namedRefJson('school-42'),
        'stage': 'secondary2',
        'educationSystem': 'nationalLanguages',
      },
      'university': null,
      'points': <String, dynamic>{
        'school': 2450,
        'university': 0,
        'total': 2450,
      },
      'level': 8,
      'badges': 0,
      'privacy': <String, dynamic>{
        'leaderboardVisible': true,
        'scoreHidden': false,
      },
      'entitlements': <dynamic>[
        <String, dynamic>{
          'type': 'baseSubscription',
          'active': true,
          'expiresAt': '2026-12-31T23:59:59Z',
          'inGrace': false,
          'graceEndsAt': null,
        },
      ],
      'createdAt': '2026-07-26T10:00:00Z',
    };

StudentProfile schoolProfile() => StudentProfile.fromJson(schoolProfileJson());

/// The same student one track over: `school` null, the `university` block
/// populated. Everything Home renders (name, avatar, points, level, badges) is
/// track-agnostic — which is the point of the university Home test.
Map<String, dynamic> universityProfileJson() => <String, dynamic>{
      ...schoolProfileJson(),
      'track': 'university',
      'name': 'Mona Adel',
      'school': null,
      'university': <String, dynamic>{
        'university': namedRefJson('uni-cairo'),
        'faculty': namedRefJson('fac-medicine'),
        'yearNumber': 1,
      },
      'points': <String, dynamic>{
        'school': 0,
        'university': 2450,
        'total': 2450,
      },
    };

StudentProfile universityProfile() =>
    StudentProfile.fromJson(universityProfileJson());

/// A school student whose city was TYPED, not picked — the adr-028 §1
/// free-text arm of the `ProfileCity` union. No `id`, so `ProfileCity.fromJson`
/// takes the [FreeTextCity] branch.
Map<String, dynamic> freeTextCityProfileJson() => <String, dynamic>{
      ...schoolProfileJson(),
      'geography': <String, dynamic>{
        'countryCode': 'AE',
        'governorate': null,
        'city': <String, dynamic>{'name': 'Al Ain'},
      },
    };

StudentProfile freeTextCityProfile() =>
    StudentProfile.fromJson(freeTextCityProfileJson());

/// The same student WITH an email on file — the only starting point from which
/// "clear it" is a reachable instruction.
Map<String, dynamic> profileWithEmailJson() => <String, dynamic>{
      ...schoolProfileJson(),
      'email': 'ahmed@example.com',
    };

StudentProfile profileWithEmail() =>
    StudentProfile.fromJson(profileWithEmailJson());

const baseEntitlement = EntitlementState(
  type: EntitlementType.baseSubscription,
  active: true,
  inGrace: false,
);
