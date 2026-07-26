import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/registration/models/registration_body.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/registration_validation.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/stage.dart';
import 'package:level_up_app/features/registration/models/university_registration.dart';

/// A draft as it looks after Sign Up_1 (identity) + Sign Up_2 (track).
RegistrationDraft _draft({
  RegTrack track = RegTrack.school,
  String? countryCode,
  bool? requiresGovernorate,
  String? governorateId,
  String? cityId,
  String? schoolId,
  String? schoolName,
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
    schoolId: schoolId,
    schoolName: schoolName,
    stage: stage,
    educationSystem: educationSystem,
    universityId: universityId,
    facultyId: facultyId,
    studyYearId: studyYearId,
  );
}

/// A complete, valid EGYPTIAN school draft.
RegistrationDraft _egyptSchoolDraft({String? schoolName}) => _draft(
      countryCode: 'EG',
      requiresGovernorate: true,
      governorateId: 'gov-cairo',
      cityId: 'city-nasr',
      schoolId: 'school-42',
      schoolName: schoolName,
      stage: Stage.secondary1.wireValue,
      educationSystem: 'ig',
    );

/// A complete, valid NON-Egyptian school draft (UAE — `requiresGovernorate` false).
RegistrationDraft _foreignSchoolDraft({
  String? governorateId,
  String? schoolId,
  String? schoolName = 'Dubai British School',
}) =>
    _draft(
      countryCode: 'AE',
      requiresGovernorate: false,
      governorateId: governorateId,
      cityId: 'city-dubai',
      schoolId: schoolId,
      schoolName: schoolName,
      stage: Stage.prep2.wireValue,
      educationSystem: 'american',
    );

RegistrationDraft _universityDraft() => _draft(
      track: RegTrack.university,
      universityId: 'uni-cairo',
      facultyId: 'fac-medicine',
      studyYearId: 'year-2',
      governorateId: 'gov-giza',
      cityId: 'city-dokki',
      dateOfBirth: DateTime(2004, 3, 7),
    );

void main() {
  group('SchoolRegistration.toJson — Egypt (requiresGovernorate)', () {
    test('emits the full coded-geography body', () {
      final json = SchoolRegistration.fromDraft(_egyptSchoolDraft()).toJson();

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

    test('schoolName is FORBIDDEN — the key is absent, not null', () {
      // Even when the draft still carries free text (e.g. typed before the
      // student switched the country to Egypt), it must never reach the wire.
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(schoolName: 'Leftover Free Text'),
      ).toJson();

      expect(json.containsKey('schoolName'), isFalse);
    });

    test('unsent optional fields are omitted entirely', () {
      final json = SchoolRegistration.fromDraft(_egyptSchoolDraft()).toJson();
      expect(json.containsKey('email'), isFalse);
      expect(json.containsKey('avatarId'), isFalse);
    });
  });

  group('SchoolRegistration.toJson — non-Egypt', () {
    test('city + optional free-text school, no coded geography', () {
      final json = SchoolRegistration.fromDraft(_foreignSchoolDraft()).toJson();

      expect(json['track'], 'school');
      expect(json['countryCode'], 'AE');
      expect(json['cityId'], 'city-dubai');
      expect(json['schoolName'], 'Dubai British School');
      expect(json['stage'], 'prep2');
      expect(json['educationSystem'], 'american');
    });

    test('governorateId + schoolId are FORBIDDEN — keys absent, not null', () {
      // Stale ids left over from an Egypt selection must be dropped.
      final json = SchoolRegistration.fromDraft(
        _foreignSchoolDraft(governorateId: 'gov-cairo', schoolId: 'school-42'),
      ).toJson();

      expect(json.containsKey('governorateId'), isFalse);
      expect(json.containsKey('schoolId'), isFalse);
    });

    test('schoolName never blocks: absent when blank, trimmed when present', () {
      final blank =
          SchoolRegistration.fromDraft(_foreignSchoolDraft(schoolName: '   '))
              .toJson();
      expect(blank.containsKey('schoolName'), isFalse);

      final padded = SchoolRegistration.fromDraft(
        _foreignSchoolDraft(schoolName: '  Al Ain Academy  '),
      ).toJson();
      expect(padded['schoolName'], 'Al Ain Academy');
    });
  });

  group('UniversityRegistration.toJson', () {
    test('emits the Egypt-only-by-shape body', () {
      final json =
          UniversityRegistration.fromDraft(_universityDraft()).toJson();

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
      final json =
          UniversityRegistration.fromDraft(_universityDraft()).toJson();
      expect(json.containsKey('countryCode'), isFalse);
    });
  });

  group('fields that must never be submitted', () {
    test('referralCode is collected but absent from BOTH bodies', () {
      // DESIGN_ISSUES #7 — no contract field exists for it.
      expect(
        SchoolRegistration.fromDraft(_egyptSchoolDraft()).toJson(),
        isNot(contains('referralCode')),
      );
      expect(
        UniversityRegistration.fromDraft(_universityDraft()).toJson(),
        isNot(contains('referralCode')),
      );
    });

    test("the student's own phone is absent (bound to the token already)", () {
      final json = SchoolRegistration.fromDraft(_egyptSchoolDraft()).toJson();
      expect(json.containsKey('phone'), isFalse);
      expect(json.values, isNot(contains('+201555000111')));
    });

    test('name + parentPhone come from the draft, not re-collected', () {
      final json = SchoolRegistration.fromDraft(_egyptSchoolDraft()).toJson();
      expect(json['name'], 'Nour Hassan');
      expect(json['parentPhone'], '+201021871999');
    });
  });

  group('dateOfBirth serialization (contract `format: date`)', () {
    test('is a bare yyyy-MM-dd, never an ISO timestamp', () {
      final json = SchoolRegistration.fromDraft(
        _egyptSchoolDraft(),
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
        ),
        throwsA(
          isA<IncompleteRegistrationDraft>()
              .having((e) => e.field, 'field', 'dateOfBirth'),
        ),
      );
    });

    test('Egypt without schoolId throws (coded list is mandatory there)', () {
      expect(
        () => SchoolRegistration.fromDraft(
          _egyptSchoolDraft().copyWith(schoolId: null),
        ),
        throwsA(
          isA<IncompleteRegistrationDraft>()
              .having((e) => e.field, 'field', 'schoolId'),
        ),
      );
    });

    test('university without studyYearId throws', () {
      expect(
        () => UniversityRegistration.fromDraft(
          _universityDraft().copyWith(studyYearId: null),
        ),
        throwsA(
          isA<IncompleteRegistrationDraft>()
              .having((e) => e.field, 'field', 'studyYearId'),
        ),
      );
    });
  });

  group('validateSchoolDraft — geography conditionality both ways', () {
    test('a complete Egypt draft is valid', () {
      expect(validateSchoolDraft(_egyptSchoolDraft()), isEmpty);
    });

    test('Egypt REQUIRES governorate + city + school', () {
      final issues = validateSchoolDraft(
        _egyptSchoolDraft().copyWith(
          governorateId: null,
          cityId: null,
          schoolId: null,
        ),
      );
      expect(issues[RegFields.governorateId], RegFieldIssue.missing);
      expect(issues[RegFields.cityId], RegFieldIssue.missing);
      expect(issues[RegFields.schoolId], RegFieldIssue.missing);
    });

    test('Egypt FORBIDS schoolName', () {
      final issues = validateSchoolDraft(
        _egyptSchoolDraft(schoolName: 'Some Free Text'),
      );
      expect(issues[RegFields.schoolName], RegFieldIssue.forbidden);
    });

    test('a complete non-Egypt draft is valid (free-text school allowed)', () {
      expect(validateSchoolDraft(_foreignSchoolDraft()), isEmpty);
    });

    test('non-Egypt REQUIRES city only', () {
      final issues =
          validateSchoolDraft(_foreignSchoolDraft().copyWith(cityId: null));
      expect(issues[RegFields.cityId], RegFieldIssue.missing);
      expect(issues.containsKey(RegFields.governorateId), isFalse);
      expect(issues.containsKey(RegFields.schoolId), isFalse);
    });

    test('non-Egypt allows an omitted schoolName — never blocks', () {
      expect(
        validateSchoolDraft(_foreignSchoolDraft(schoolName: null)),
        isEmpty,
      );
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
      expect(
        Stage.values.map((s) => s.wireValue),
        ['prep1', 'prep2', 'prep3', 'secondary1', 'secondary2', 'secondary3'],
      );
    });

    test('tryParse round-trips and rejects unknown values', () {
      expect(Stage.tryParse('secondary3'), Stage.secondary3);
      expect(Stage.tryParse('grade9'), isNull);
      expect(Stage.tryParse(null), isNull);
    });
  });
}
