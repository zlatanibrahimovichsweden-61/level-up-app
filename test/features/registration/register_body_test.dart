import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/registration/models/registration_body.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/registration_validation.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/stage.dart';
import 'package:level_up_app/features/registration/models/university_registration.dart';

/// The ambient device, contract-REQUIRED on both register bodies since
/// 2.0.0-m1. It is never drawn from the draft, so one shared fixture stands in
/// for the `deviceInfoProvider` value the notifier passes in production.
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');

/// A draft as it looks after Sign Up_1 (identity) + Sign Up_2 (track).
RegistrationDraft _draft({
  RegTrack track = RegTrack.school,
  String? countryCode,
  bool? requiresGovernorate,
  String? governorateId,
  String? cityId,
  String? cityName,
  String? schoolId,
  String? stage,
  String? educationSystem,
  String? universityId,
  String? facultyId,
  String? studyYearId,
  DateTime? dateOfBirth,
  String? name = 'Nour Hassan',
  String? parentPhone = '+201021871999',
  String? referralCode = 'FRIEND50',
}) {
  return RegistrationDraft(
    registrationToken: 'reg.token',
    tokenExpiresAt: DateTime.now().add(const Duration(minutes: 10)),
    phone: '+201555000111',
    name: name,
    parentPhone: parentPhone,
    referralCode: referralCode,
    track: track,
    dateOfBirth: dateOfBirth ?? DateTime(2009, 5, 1),
    countryCode: countryCode,
    requiresGovernorate: requiresGovernorate,
    governorateId: governorateId,
    cityId: cityId,
    cityName: cityName,
    schoolId: schoolId,
    stage: stage,
    educationSystem: educationSystem,
    universityId: universityId,
    facultyId: facultyId,
    studyYearId: studyYearId,
  );
}

/// A complete, valid EGYPTIAN school draft — coded city, coded school.
RegistrationDraft _egyptSchoolDraft({
  String? cityId = 'city-nasr',
  String? cityName,
  String? schoolId = 'school-42',
}) => _draft(
  countryCode: 'EG',
  requiresGovernorate: true,
  governorateId: 'gov-cairo',
  cityId: cityId,
  cityName: cityName,
  schoolId: schoolId,
  stage: Stage.secondary1.wireValue,
  educationSystem: 'ig',
);

/// A complete, valid NON-Egyptian school draft (UAE — `requiresGovernorate`
/// false). Since adr-028 §2 there is no school step at all on this flow, so the
/// default draft carries no `schoolId`.
RegistrationDraft _foreignSchoolDraft({
  String? governorateId,
  String? schoolId,
  String? cityId = 'city-dubai',
  String? cityName,
}) => _draft(
  countryCode: 'AE',
  requiresGovernorate: false,
  governorateId: governorateId,
  cityId: cityId,
  cityName: cityName,
  schoolId: schoolId,
  stage: Stage.prep2.wireValue,
  educationSystem: 'american',
);

RegistrationDraft _universityDraft({
  String? cityId = 'city-dokki',
  String? cityName,
}) => _draft(
  track: RegTrack.university,
  universityId: 'uni-cairo',
  facultyId: 'fac-medicine',
  studyYearId: 'year-2',
  governorateId: 'gov-giza',
  cityId: cityId,
  cityName: cityName,
  dateOfBirth: DateTime(2004, 3, 7),
);

void main() {
  group('SchoolRegistration.toJson — Egypt (requiresGovernorate)', () {
    test('emits the full coded-geography body', () {
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
        device: _device,
      ).toJson();

      expect(json['track'], 'school');
      expect(json['registrationToken'], 'reg.token');
      expect(json['name'], 'Nour Hassan');
      expect(json['dateOfBirth'], '2009-05-01');
      expect(json['countryCode'], 'EG');
      expect(json['governorateId'], 'gov-cairo');
      expect(json['cityId'], 'city-nasr');
      expect(json['schoolId'], 'school-42');
      expect(json['stage'], 'secondary1');
      expect(json['educationSystem'], 'ig');
      expect(json['parentPhone'], '+201021871999');
    });

    test('schoolName does not exist on this contract at all (adr-028 §2)', () {
      // v1.1 removed the field outright; the server rejects it as an unknown
      // property. There is no branch of any draft that can produce the key.
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
        device: _device,
      ).toJson();

      expect(json.containsKey('schoolName'), isFalse);
    });

    test('schoolId is OPTIONAL here too — omitted, not defaulted', () {
      // adr-028 §2: an Egyptian student who cannot find their school skips it
      // and registers anyway. Under v1.0 this threw.
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(schoolId: null),
        device: _device,
      ).toJson();

      expect(json.containsKey('schoolId'), isFalse);
      expect(json['governorateId'], 'gov-cairo');
      expect(json['cityId'], 'city-nasr');
    });

    test('unsent optional fields are omitted entirely', () {
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
        device: _device,
      ).toJson();
      expect(json.containsKey('email'), isFalse);
      expect(json.containsKey('avatarId'), isFalse);
    });
  });

  group('SchoolRegistration.toJson — non-Egypt', () {
    test('city only — no coded geography, and no school of any kind', () {
      final json = SchoolRegistration.fromDraft(
        _foreignSchoolDraft(),
        device: _device,
      ).toJson();

      expect(json['track'], 'school');
      expect(json['countryCode'], 'AE');
      expect(json['cityId'], 'city-dubai');
      expect(json.containsKey('schoolId'), isFalse);
      expect(json.containsKey('schoolName'), isFalse);
      expect(json['stage'], 'prep2');
      expect(json['educationSystem'], 'american');
    });

    test('a stale governorateId is dropped — key absent, not null', () {
      final json = SchoolRegistration.fromDraft(
        _foreignSchoolDraft(governorateId: 'gov-cairo'),
        device: _device,
      ).toJson();

      expect(json.containsKey('governorateId'), isFalse);
    });

    test('a leftover schoolId THROWS — the step does not exist here', () {
      // Not because v1.1 forbids schoolId (it does not), but because section C
      // removes the school step outside Egypt, so an id here means a
      // cascade-clear was missed.
      expect(
        () => SchoolRegistration.fromDraft(
          _foreignSchoolDraft(schoolId: 'school-42'),
          device: _device,
        ),
        throwsA(
          isA<ForbiddenRegistrationField>().having(
            (e) => e.field,
            'field',
            'schoolId',
          ),
        ),
      );
    });
  });

  group('the adr-028 §1 city union — one key or the other, never both', () {
    test('cityId only: cityName key is absent, not null', () {
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
        device: _device,
      ).toJson();

      expect(json['cityId'], 'city-nasr');
      expect(json.containsKey('cityName'), isFalse);
    });

    test('cityName only: cityId key is absent, not null', () {
      final json = SchoolRegistration.fromDraft(
        _foreignSchoolDraft(cityId: null, cityName: 'Al Ain'),
        device: _device,
      ).toJson();

      expect(json['cityName'], 'Al Ain');
      expect(json.containsKey('cityId'), isFalse);
    });

    test('NEITHER throws, naming cityId', () {
      expect(
        () => SchoolRegistration.fromDraft(
          _foreignSchoolDraft(cityId: null),
          device: _device,
        ),
        throwsA(
          isA<IncompleteRegistrationDraft>().having(
            (e) => e.field,
            'field',
            'cityId',
          ),
        ),
      );
    });

    test('BOTH throws rather than letting the server 400 it', () {
      expect(
        () => SchoolRegistration.fromDraft(
          _egyptSchoolDraft(cityName: 'Nasr City'),
          device: _device,
        ),
        throwsA(
          isA<ForbiddenRegistrationField>().having(
            (e) => e.field,
            'field',
            'cityName',
          ),
        ),
      );
    });

    test('cityName is trimmed, and blank-after-trim counts as absent', () {
      final padded = SchoolRegistration.fromDraft(
        _foreignSchoolDraft(cityId: null, cityName: '  Al Ain  '),
        device: _device,
      ).toJson();
      expect(padded['cityName'], 'Al Ain');

      // Blank is not "a city" — it falls through to the neither-arm.
      expect(
        () => SchoolRegistration.fromDraft(
          _foreignSchoolDraft(cityId: null, cityName: '   '),
          device: _device,
        ),
        throwsA(isA<IncompleteRegistrationDraft>()),
      );
    });

    test('cityName is capped at the contract maxLength of 100', () {
      final json = SchoolRegistration.fromDraft(
        _foreignSchoolDraft(cityId: null, cityName: 'x' * 140),
        device: _device,
      ).toJson();

      expect((json['cityName'] as String).length, 100);
    });

    test('the same union rules apply on the university body', () {
      final coded = UniversityRegistration.fromDraft(
        _universityDraft(),
        device: _device,
      ).toJson();
      expect(coded['cityId'], 'city-dokki');
      expect(coded.containsKey('cityName'), isFalse);

      final free = UniversityRegistration.fromDraft(
        _universityDraft(cityId: null, cityName: '  Dokki  '),
        device: _device,
      ).toJson();
      expect(free['cityName'], 'Dokki');
      expect(free.containsKey('cityId'), isFalse);

      expect(
        () => UniversityRegistration.fromDraft(
          _universityDraft(cityName: 'Dokki'),
          device: _device,
        ),
        throwsA(isA<ForbiddenRegistrationField>()),
      );
      expect(
        () => UniversityRegistration.fromDraft(
          _universityDraft(cityId: null),
          device: _device,
        ),
        throwsA(isA<IncompleteRegistrationDraft>()),
      );
    });
  });

  group('UniversityRegistration.toJson', () {
    test('emits the Egypt-only-by-shape body', () {
      final json = UniversityRegistration.fromDraft(
        _universityDraft(),
        device: _device,
      ).toJson();

      expect(json['track'], 'university');
      expect(json['registrationToken'], 'reg.token');
      expect(json['name'], 'Nour Hassan');
      expect(json['dateOfBirth'], '2004-03-07');
      expect(json['universityId'], 'uni-cairo');
      expect(json['facultyId'], 'fac-medicine');
      expect(json['studyYearId'], 'year-2');
      expect(json['governorateId'], 'gov-giza');
      expect(json['cityId'], 'city-dokki');
      expect(json['parentPhone'], '+201021871999');
    });

    test('carries NO countryCode — Egypt-only by shape (adr-010)', () {
      final json = UniversityRegistration.fromDraft(
        _universityDraft(),
        device: _device,
      ).toJson();
      expect(json.containsKey('countryCode'), isFalse);
    });
  });

  group('fields that must never be submitted', () {
    test('referralCode is collected but absent from BOTH bodies', () {
      // DESIGN_ISSUES #7 — no contract field exists for it.
      expect(
        SchoolRegistration.fromDraft(
          _egyptSchoolDraft(),
          device: _device,
        ).toJson(),
        isNot(contains('referralCode')),
      );
      expect(
        UniversityRegistration.fromDraft(
          _universityDraft(),
          device: _device,
        ).toJson(),
        isNot(contains('referralCode')),
      );
    });

    test("the student's own phone is absent (bound to the token already)", () {
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
        device: _device,
      ).toJson();
      expect(json.containsKey('phone'), isFalse);
      expect(json.values, isNot(contains('+201555000111')));
    });

    test('name + parentPhone come from the draft, not re-collected', () {
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
        device: _device,
      ).toJson();
      expect(json['name'], 'Nour Hassan');
      expect(json['parentPhone'], '+201021871999');
    });
  });

  group('dateOfBirth serialization (contract `format: date`)', () {
    test('is a bare yyyy-MM-dd, never an ISO timestamp', () {
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
        device: _device,
      ).copyWith(dateOfBirth: DateTime(2011, 12, 31)).toJson();

      expect(json['dateOfBirth'], '2011-12-31');
      expect(json['dateOfBirth'] as String, isNot(contains('T')));
    });
  });

  group('fromDraft refuses to build an incomplete body', () {
    test('missing dateOfBirth throws with the contract field name', () {
      expect(
        () => SchoolRegistration.fromDraft(
          _egyptSchoolDraft().copyWith(dateOfBirth: null),
          device: _device,
        ),
        throwsA(
          isA<IncompleteRegistrationDraft>().having(
            (e) => e.field,
            'field',
            'dateOfBirth',
          ),
        ),
      );
    });

    test('Egypt without governorateId still throws (adr-010 is untouched)', () {
      expect(
        () => SchoolRegistration.fromDraft(
          _egyptSchoolDraft().copyWith(governorateId: null),
          device: _device,
        ),
        throwsA(
          isA<IncompleteRegistrationDraft>().having(
            (e) => e.field,
            'field',
            'governorateId',
          ),
        ),
      );
    });

    test('university without studyYearId throws', () {
      expect(
        () => UniversityRegistration.fromDraft(
          _universityDraft().copyWith(studyYearId: null),
          device: _device,
        ),
        throwsA(
          isA<IncompleteRegistrationDraft>().having(
            (e) => e.field,
            'field',
            'studyYearId',
          ),
        ),
      );
    });
  });

  group('validateSchoolDraft — geography conditionality both ways', () {
    test('a complete Egypt draft is valid', () {
      expect(validateSchoolDraft(_egyptSchoolDraft()), isEmpty);
    });

    test('Egypt REQUIRES governorate + a city, but NOT a school', () {
      final issues = validateSchoolDraft(
        _egyptSchoolDraft().copyWith(
          governorateId: null,
          cityId: null,
          schoolId: null,
        ),
      );
      expect(issues[RegFields.governorateId], RegFieldIssue.missing);
      expect(issues[RegFields.cityId], RegFieldIssue.missing);
      // adr-028 §2 — this used to be `missing` and was the rule that blocked a
      // registration the server now accepts.
      expect(issues.containsKey(RegFields.schoolId), isFalse);
    });

    test('an Egyptian student with no school passes the pre-flight', () {
      expect(validateSchoolDraft(_egyptSchoolDraft(schoolId: null)), isEmpty);
    });

    test('a complete non-Egypt draft is valid', () {
      expect(validateSchoolDraft(_foreignSchoolDraft()), isEmpty);
    });

    test('non-Egypt REQUIRES a city only', () {
      final issues = validateSchoolDraft(
        _foreignSchoolDraft().copyWith(cityId: null),
      );
      expect(issues[RegFields.cityId], RegFieldIssue.missing);
      expect(issues.containsKey(RegFields.governorateId), isFalse);
      expect(issues.containsKey(RegFields.schoolId), isFalse);
    });

    test('non-Egypt FORBIDS governorate + school', () {
      final issues = validateSchoolDraft(
        _foreignSchoolDraft(governorateId: 'gov-cairo', schoolId: 'school-42'),
      );
      expect(issues[RegFields.governorateId], RegFieldIssue.forbidden);
      expect(issues[RegFields.schoolId], RegFieldIssue.forbidden);
    });

    test('non-geography required fields are checked on both branches', () {
      final issues = validateSchoolDraft(
        _egyptSchoolDraft().copyWith(
          dateOfBirth: null,
          stage: null,
          educationSystem: null,
        ),
      );
      expect(issues[RegFields.dateOfBirth], RegFieldIssue.missing);
      expect(issues[RegFields.stage], RegFieldIssue.missing);
      expect(issues[RegFields.educationSystem], RegFieldIssue.missing);
    });
  });

  group('the city union in the validator (adr-028 §1), both tracks', () {
    test('a free-text city satisfies the requirement on its own', () {
      expect(
        validateSchoolDraft(
          _foreignSchoolDraft(cityId: null, cityName: 'Al Ain'),
        ),
        isEmpty,
      );
      expect(
        validateUniversityDraft(
          _universityDraft(cityId: null, cityName: 'Dokki'),
        ),
        isEmpty,
      );
    });

    test('neither half answered reports BOTH fields as missing', () {
      final issues = validateSchoolDraft(_foreignSchoolDraft(cityId: null));
      expect(issues[RegFields.cityId], RegFieldIssue.missing);
      expect(issues[RegFields.cityName], RegFieldIssue.missing);
    });

    test('both halves populated is FORBIDDEN, reported on cityName', () {
      // The coded value is what the backend can filter and report on, so when
      // the two disagree it is the free text that gives.
      final issues = validateSchoolDraft(
        _egyptSchoolDraft(cityName: 'Nasr City'),
      );
      expect(issues[RegFields.cityName], RegFieldIssue.forbidden);
      expect(issues.containsKey(RegFields.cityId), isFalse);
    });

    test('a blank free-text city does not count as answered', () {
      final issues = validateSchoolDraft(
        _foreignSchoolDraft(cityId: null, cityName: '   '),
      );
      expect(issues[RegFields.cityId], RegFieldIssue.missing);
    });

    test('the university track carries the same rule', () {
      final issues = validateUniversityDraft(
        _universityDraft(cityName: 'Dokki'),
      );
      expect(issues[RegFields.cityName], RegFieldIssue.forbidden);
    });
  });

  group('validateUniversityDraft', () {
    test('a complete draft is valid', () {
      expect(validateUniversityDraft(_universityDraft()), isEmpty);
    });

    test('governorateId is REQUIRED here (unlike the school branch)', () {
      // Missing from the Figma frame — DESIGN_ISSUES #3.
      final issues = validateUniversityDraft(
        _universityDraft().copyWith(governorateId: null),
      );
      expect(issues[RegFields.governorateId], RegFieldIssue.missing);
    });

    test('the whole cascade is required', () {
      final issues = validateUniversityDraft(
        _universityDraft().copyWith(
          universityId: null,
          facultyId: null,
          studyYearId: null,
        ),
      );
      expect(issues[RegFields.universityId], RegFieldIssue.missing);
      expect(issues[RegFields.facultyId], RegFieldIssue.missing);
      expect(issues[RegFields.studyYearId], RegFieldIssue.missing);
    });
  });

  group('validateDraft dispatches on the track discriminator', () {
    test('school draft routes to the school rules', () {
      expect(validateDraft(_egyptSchoolDraft()), isEmpty);
    });

    test('university draft routes to the university rules', () {
      expect(validateDraft(_universityDraft()), isEmpty);
    });

    test('no track chosen yet is itself blocking', () {
      final issues = validateDraft(_egyptSchoolDraft().copyWith(track: null));
      expect(issues['track'], RegFieldIssue.missing);
    });
  });

  group('Stage', () {
    test('wire values match the contract enum exactly', () {
      expect(Stage.values.map((s) => s.wireValue), [
        'prep1',
        'prep2',
        'prep3',
        'secondary1',
        'secondary2',
        'secondary3',
      ]);
    });

    test('tryParse round-trips and rejects unknown values', () {
      expect(Stage.tryParse('secondary3'), Stage.secondary3);
      expect(Stage.tryParse('grade9'), isNull);
      expect(Stage.tryParse(null), isNull);
    });
  });
}
