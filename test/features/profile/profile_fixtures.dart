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
        'school': namedRefJson('school-42'),
        'schoolName': null,
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

const baseEntitlement = EntitlementState(
  type: EntitlementType.baseSubscription,
  active: true,
  inGrace: false,
);
