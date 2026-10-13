/// Readiness E4-02 (R2c): the credential- and personal-data-bearing value
/// objects do not print themselves.
///
/// `TokenPair`, `AuthResult` (both arms), `RegistrationDraft`, `DeviceInfo`,
/// `Phone`, `ProfileUpdate` and `EmailPatch.set` used to stringify their
/// fields: freezed generates a `toString()` that prints every one of them, and
/// the two hand-written classes interpolated the number and the address. The
/// project rule is that neither a credential nor a minor's personal data reaches
/// a log, an error detail or a test report by accident (the newer friends,
/// referral, recovery, terms and deletion models are redacted for that reason).
/// Nothing logs today, so this was latent; it became live the day a logger, a
/// `ProviderObserver` or an interpolated error message appeared, and the
/// uncaught-error output the app does not override would have printed them.
///
/// Three layers, so that no single mistake re-opens it:
///
/// 1. DYNAMIC - every type is built with sentinel values and its string form is
///    searched for them. This is the behaviour, whatever produced it.
/// 2. GENERATED CODE - a freezed model's own `toString` is only suppressed while
///    the class body declares one. If somebody deletes the override, the
///    regenerated `.freezed.dart` prints the fields again; this reads the
///    committed generated files and fails on it.
/// 3. SOURCE - a hand-written `toString` in these files may not interpolate a
///    field that holds a credential or personal data.
///
/// Plus a census of every freezed model in `lib/`, so a NEW model cannot start
/// printing a token, a phone number, an address, a date of birth, a student id,
/// an avatar, a person's name or text a student wrote (a ticket's subject,
/// details or reply body). A catalogue title (a subject, a unit, a lecture) is
/// not a person and is allowed by class name, in [_catalogueNameClasses]. The
/// census group's `knownUnredacted` list is the ratchet for a model that cannot
/// be fixed at once; it may only shrink, and it is EMPTY since the second
/// integration round redacted the last four (`StudentProfile` and its free-text
/// `ProfileCity`, `SchoolRegistration`, `UniversityRegistration`,
/// `LeaderboardEntry`) and the review of that round added the student-authored
/// text and the avatar a student uploaded (`SupportTicketSummary`,
/// `SupportTicket`, `SupportTicketMessage`, `ProfileAvatar`).
///
/// **What the census can and cannot see.** It reads each generated `toString`
/// and flags a printed FIELD by its NAME (see [_printsPersonalData]). It does
/// not know what a value is, so a personal value under a name the matcher does
/// not list goes unseen, and a nested model is judged by its own string form,
/// not by the field that holds it. An empty list therefore means "no generated
/// string prints a field with one of those names", not "every model is
/// redacted"; the models it leaves alone on purpose (catalogue titles, scores,
/// the registration reference rows) are the ones that hold nothing a student
/// wrote or is.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/models/auth_outcome.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/models/phone.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/university_registration.dart';
import 'package:level_up_app/features/support/models/support_models.dart';

// Sentinels: unmistakable, and none a substring of another.
const _access = 'SENTINEL-ACCESS-TOKEN';
const _refresh = 'SENTINEL-REFRESH-TOKEN';
const _regToken = 'SENTINEL-REGISTRATION-TOKEN';
const _phoneLocal = '01000000099';
const _phoneE164 = '+201000000099';
const _parentPhone = '+201000000077';
const _name = 'SENTINEL NAME';
const _email = 'sentinel@example.test';
const _deviceId = 'SENTINEL-DEVICE-ID';
const _model = 'SENTINEL-HANDSET-MODEL';
const _studentId = 'SENTINEL-STUDENT-ID';
const _avatarId = 'SENTINEL-AVATAR-ID';
const _referral = 'SENTINEL-REFERRAL';
const _cityName = 'SENTINEL-CITY';
const _schoolId = 'SENTINEL-SCHOOL-ID';
const _refusedName = 'SENTINEL REFUSED NAME';
const _profileSecret = 'SENTINEL-PROFILE-VALUE';
const _photoUrl = 'https://sentinel.example.test/SENTINEL-PHOTO.jpg';
const _ticketSubject = 'SENTINEL-TICKET-SUBJECT';
const _ticketDetails = 'SENTINEL-TICKET-DETAILS';
const _ticketBody = 'SENTINEL-TICKET-BODY';

/// Every value above, as a string that must never appear in a string form.
const _sentinels = <String>[
  _photoUrl,
  _ticketSubject,
  _ticketDetails,
  _ticketBody,
  _access,
  _refresh,
  _regToken,
  _phoneLocal,
  _phoneE164,
  _parentPhone,
  _name,
  _email,
  _deviceId,
  _model,
  _studentId,
  _avatarId,
  _referral,
  _cityName,
  _schoolId,
  _refusedName,
  _profileSecret,
  '1000000099', // the national digits, without the dial code or the 0
  '2010000000',
  'sentinel@', // an address fragment
];

/// The sentinels [text] contains. Empty means the string is clean.
List<String> _leaks(String text) => [
  for (final s in _sentinels)
    if (text.contains(s)) s,
];

const _tokens = TokenPair(
  accessToken: _access,
  accessExpiresInSeconds: 900,
  refreshToken: _refresh,
  refreshExpiresInSeconds: 5184000,
);

AuthResult _authenticated({bool? inviteCodeApplied}) =>
    AuthResult.authenticated(
      tokens: _tokens,
      profile: const <String, dynamic>{
        'id': _studentId,
        'name': _name,
        'phone': _phoneE164,
        'email': _email,
        'note': _profileSecret,
      },
      inviteCodeApplied: inviteCodeApplied,
    );

const _registrationRequired = AuthResult.registrationRequired(
  registrationToken: _regToken,
  expiresInSeconds: 600,
);

RegistrationDraft _fullDraft() => RegistrationDraft(
  registrationToken: _regToken,
  tokenExpiresAt: DateTime(2030),
  phone: _phoneE164,
  name: _name,
  parentPhone: _parentPhone,
  referralCode: _referral,
  track: RegTrack.school,
  dateOfBirth: DateTime(2010, 5, 17),
  countryCode: 'EG',
  requiresGovernorate: true,
  governorateId: 'gov-1',
  cityName: _cityName,
  schoolId: _schoolId,
  pickedSchool: const NamedRef(
    id: _schoolId,
    nameAr: 'SENTINEL-SCHOOL-AR',
    nameEn: 'SENTINEL-SCHOOL-EN',
  ),
  stage: 'secondary',
  educationSystem: 'national',
  refusedNames: const {_refusedName},
);

/// [value] as the wire carries it: encoded, then decoded again.
Map<String, dynamic> _wire(Object value) =>
    jsonDecode(jsonEncode(value)) as Map<String, dynamic>;

ProfileUpdate _fullUpdate() => const ProfileUpdate(
  name: _name,
  email: EmailPatch.set(_email),
  avatarId: _avatarId,
  leaderboardVisible: true,
  scoreHidden: false,
);

const _device = DeviceInfo(
  deviceId: _deviceId,
  platform: 'android',
  model: _model,
);

StudentProfile _profile({ProfileCity? city}) => StudentProfile(
  id: _studentId,
  track: Track.school,
  name: _name,
  phone: _phoneE164,
  email: _email,
  dateOfBirth: DateTime(2010, 5, 17),
  avatar: const ProfileAvatar(type: 'custom', id: _avatarId, url: _photoUrl),
  geography: ProfileGeography(
    countryCode: 'EG',
    city: city ?? const ProfileCity.freeText(_cityName),
  ),
  points: const ProfilePoints(school: 10, university: 0, total: 10),
  level: 1,
  badges: 0,
  privacy: const ProfilePrivacy(leaderboardVisible: true, scoreHidden: false),
  entitlements: const [],
  createdAt: DateTime.utc(2026, 9),
);

SchoolRegistration _schoolBody() => SchoolRegistration(
  registrationToken: _regToken,
  device: _device,
  name: _name,
  dateOfBirth: DateTime(2010, 5, 17),
  countryCode: 'EG',
  governorateId: 'gov-1',
  cityName: _cityName,
  schoolId: _schoolId,
  stage: 'secondary',
  educationSystem: 'national',
  parentPhone: _parentPhone,
  email: _email,
  avatarId: _avatarId,
  inviteCode: _referral,
);

UniversityRegistration _universityBody() => UniversityRegistration(
  registrationToken: _regToken,
  device: _device,
  name: _name,
  dateOfBirth: DateTime(2006, 3, 2),
  universityId: 'uni-1',
  facultyId: 'fac-1',
  studyYearId: 'year-1',
  governorateId: 'gov-1',
  cityName: _cityName,
  parentPhone: _parentPhone,
  email: _email,
  avatarId: _avatarId,
);

const _entry = LeaderboardEntry(
  rank: 3,
  studentId: _studentId,
  name: _name,
  avatarUrl: _avatarId,
  points: 1200,
  isMe: false,
);

final _ticketAt = DateTime.utc(2026, 9, 1, 10);

const _avatar = ProfileAvatar(type: 'custom', id: _avatarId, url: _photoUrl);

SupportTicketSummary _ticketSummary() => SupportTicketSummary(
  ticketId: 'ticket-1',
  reference: 'TK-1',
  subject: _ticketSubject,
  status: 'open',
  createdAt: _ticketAt,
  lastActivityAt: _ticketAt,
);

SupportTicket _ticket() => SupportTicket(
  ticketId: 'ticket-1',
  reference: 'TK-1',
  subject: _ticketSubject,
  details: _ticketDetails,
  status: 'open',
  createdAt: _ticketAt,
  lastActivityAt: _ticketAt,
  closedAt: null,
);

SupportTicketMessage _ticketMessage() => SupportTicketMessage(
  messageId: 'message-1',
  authorKind: SupportAuthorKinds.student,
  body: _ticketBody,
  createdAt: _ticketAt,
);

void main() {
  group('layer 1 - behaviour: no string form carries a credential or personal '
      'data', () {
    // The probe has to be able to tell: a class that prints its field leaks.
    test('control: the probe flags a value that does print its secret', () {
      expect(_leaks('Leaky(token: $_access)'), [_access]);
      expect(_leaks('Leaky(phone: $_phoneE164)'), contains(_phoneE164));
      expect(_leaks('Leaky(email: $_email)'), contains(_email));
      expect(_leaks('Leaky()'), isEmpty);
    });

    final cases = <String, Object>{
      'TokenPair': _tokens,
      'AuthResult.authenticated': _authenticated(inviteCodeApplied: true),
      'AuthResult.registrationRequired': _registrationRequired,
      'DeviceInfo': const DeviceInfo(
        deviceId: _deviceId,
        platform: 'android',
        model: _model,
      ),
      'Phone': Phone.tryParse(_phoneLocal)!,
      'Phone (from E.164)': Phone.tryParse(_phoneE164)!,
      'RegistrationDraft (every field set)': _fullDraft(),
      'RegistrationDraft (required fields only)': RegistrationDraft(
        registrationToken: _regToken,
        tokenExpiresAt: DateTime(2030),
        phone: _phoneE164,
      ),
      'ProfileUpdate (every field set)': _fullUpdate(),
      'EmailPatch.set': const EmailPatch.set(_email),
      // The four the first pass left on the known-gap list (second integration
      // round): a profile and its free-text city, the two registration request
      // bodies and another student's leaderboard row.
      'StudentProfile (free-text city)': _profile(),
      'StudentProfile (coded city)': _profile(
        city: const ProfileCity.coded(
          NamedRef(id: _schoolId, nameAr: _cityName, nameEn: _cityName),
        ),
      ),
      'ProfileCity.freeText': const ProfileCity.freeText(_cityName),
      'SchoolRegistration': _schoolBody(),
      'UniversityRegistration': _universityBody(),
      'LeaderboardEntry': _entry,
      // Added by the review of that round: text a student wrote, and the photo
      // a student uploaded as an avatar.
      'SupportTicketSummary': _ticketSummary(),
      'SupportTicket': _ticket(),
      'SupportTicketMessage': _ticketMessage(),
      'ProfileAvatar': _avatar,
      // Not in the defect list; they carry sentinels too and print nothing of
      // them (the default `Instance of ...`). Pinned so a future `toString`
      // that "helpfully" lists the fields cannot slip in unnoticed.
      'OtpArgs': const OtpArgs(
        phone: _phoneE164,
        resendAfterSeconds: 60,
        expiresInSeconds: 300,
      ),
      'AuthenticatedOutcome': const AuthenticatedOutcome(studentId: _studentId),
      'RegistrationRequiredOutcome': const RegistrationRequiredOutcome(
        registrationToken: _regToken,
        expiresInSeconds: 600,
      ),
    };

    for (final entry in cases.entries) {
      test('${entry.key}: toString() and interpolation are sentinel-free', () {
        expect(_leaks(entry.value.toString()), isEmpty);
        expect(_leaks('${entry.value}'), isEmpty);
        expect(_leaks('value=${entry.value} / list=${[entry.value]}'), isEmpty);
      });
    }

    test('the redacted strings still say WHAT they are (not an empty '
        'string, so a failing test names the type)', () {
      expect(_tokens.toString(), startsWith('TokenPair('));
      expect(
        _authenticated().toString(),
        startsWith('AuthResult.authenticated('),
      );
      expect(
        _registrationRequired.toString(),
        startsWith('AuthResult.registrationRequired('),
      );
      expect(
        const DeviceInfo(deviceId: _deviceId, platform: 'ios').toString(),
        startsWith('DeviceInfo('),
      );
      expect(Phone.tryParse(_phoneLocal)!.toString(), startsWith('Phone('));
      expect(_fullDraft().toString(), startsWith('RegistrationDraft('));
      expect(_fullUpdate().toString(), startsWith('ProfileUpdate('));
      expect(
        const EmailPatch.set(_email).toString(),
        startsWith('EmailPatch.set('),
      );
      expect(_profile().toString(), 'StudentProfile(<redacted>)');
      expect(
        const ProfileCity.freeText(_cityName).toString(),
        'ProfileCity(<redacted>)',
      );
      expect(_schoolBody().toString(), 'SchoolRegistration(<redacted>)');
      expect(
        _universityBody().toString(),
        'UniversityRegistration(<redacted>)',
      );
      expect(_entry.toString(), 'LeaderboardEntry(<redacted>)');
      expect(_ticketSummary().toString(), 'SupportTicketSummary(<redacted>)');
      expect(_ticket().toString(), 'SupportTicket(<redacted>)');
      expect(_ticketMessage().toString(), 'SupportTicketMessage(<redacted>)');
      expect(_avatar.toString(), 'ProfileAvatar(<redacted>)');
    });

    test('ProfileUpdate names WHICH fields it carries, never their values', () {
      expect(
        _fullUpdate().toString(),
        'ProfileUpdate(fields: [name, email, avatarId, leaderboardVisible, '
        'scoreHidden])',
      );
      expect(const ProfileUpdate().toString(), 'ProfileUpdate(fields: [])');
      expect(
        const ProfileUpdate(email: EmailPatch.cleared()).toString(),
        'ProfileUpdate(fields: [email])',
      );
    });

    test('the arms that hold nothing sensitive keep their plain strings', () {
      expect(const EmailPatch.unchanged().toString(), 'EmailPatch.unchanged()');
      expect(const EmailPatch.cleared().toString(), 'EmailPatch.cleared()');
      // A contract-sized pair of integers: not personal data, left as freezed
      // generates it (the census below allows it).
      expect(
        const OtpRequestResult(
          resendAfterSeconds: 60,
          expiresInSeconds: 300,
        ).toString(),
        'OtpRequestResult(resendAfterSeconds: 60, expiresInSeconds: 300)',
      );
    });
  });

  group('redacting the string form changed nothing else', () {
    test('TokenPair: value equality, hashCode, copyWith and JSON', () {
      const other = TokenPair(
        accessToken: _access,
        accessExpiresInSeconds: 900,
        refreshToken: _refresh,
        refreshExpiresInSeconds: 5184000,
      );
      expect(other, _tokens);
      expect(other.hashCode, _tokens.hashCode);
      expect(_tokens.copyWith(accessToken: 'x').accessToken, 'x');
      expect(_tokens.copyWith(accessToken: 'x'), isNot(_tokens));
      expect(TokenPair.fromJson(_tokens.toJson()), _tokens);
      expect(_tokens.toJson(), {
        'accessToken': _access,
        'accessExpiresInSeconds': 900,
        'refreshToken': _refresh,
        'refreshExpiresInSeconds': 5184000,
      });
    });

    test('AuthResult: both arms still decode, encode and compare by value', () {
      final authed = _authenticated(inviteCodeApplied: false);
      // Through the encoder, as the wire does: a nested TokenPair is turned
      // into a map by jsonEncode, not by the union's own toJson.
      expect(AuthResult.fromJson(_wire(authed)), authed);
      expect(_wire(authed)['result'], 'authenticated');
      expect(authed, isA<AuthenticatedResult>());
      expect(
        AuthResult.fromJson(_wire(_registrationRequired)),
        _registrationRequired,
      );
      expect(_wire(_registrationRequired)['result'], 'registrationRequired');
      expect(_registrationRequired, isA<RegistrationRequiredResult>());
      expect(authed, isNot(_registrationRequired));
      expect(
        _registrationRequired.hashCode,
        const AuthResult.registrationRequired(
          registrationToken: _regToken,
          expiresInSeconds: 600,
        ).hashCode,
      );
    });

    test('DeviceInfo: value equality, copyWith and JSON', () {
      const device = DeviceInfo(
        deviceId: _deviceId,
        platform: 'android',
        model: _model,
      );
      expect(DeviceInfo.fromJson(device.toJson()), device);
      expect(device.copyWith(model: null).model, isNull);
      expect(device.toJson(), {
        'deviceId': _deviceId,
        'platform': 'android',
        'model': _model,
      });
    });

    test('RegistrationDraft: value equality, hashCode and copyWith', () {
      final draft = _fullDraft();
      expect(draft, _fullDraft());
      expect(draft.hashCode, _fullDraft().hashCode);
      expect(draft.copyWith(name: 'x').name, 'x');
      expect(draft.copyWith(name: 'x'), isNot(draft));
      expect(draft.refusedNames, {_refusedName});
      expect(
        RegistrationDraft(
          registrationToken: 't',
          tokenExpiresAt: DateTime(2000),
          phone: 'p',
        ).isExpired,
        isTrue,
      );
    });

    test('StudentProfile and ProfileCity: equality, hashCode, copyWith and '
        'JSON', () {
      final profile = _profile();
      expect(profile, _profile());
      expect(profile.hashCode, _profile().hashCode);
      expect(profile.copyWith(level: 2).level, 2);
      expect(profile.copyWith(level: 2), isNot(profile));
      expect(StudentProfile.fromJson(_wire(profile)), profile);
      expect(_wire(profile)['name'], _name);
      expect(_wire(profile)['phone'], _phoneE164);
      expect((_wire(profile)['geography'] as Map)['city'], {'name': _cityName});

      const free = ProfileCity.freeText(_cityName);
      expect(free, const ProfileCity.freeText(_cityName));
      expect(free.hashCode, const ProfileCity.freeText(_cityName).hashCode);
      expect(free, isNot(const ProfileCity.freeText('elsewhere')));
      expect(free.toJson(), {'name': _cityName});
      expect(ProfileCity.fromJson(free.toJson()), free);
      const coded = ProfileCity.coded(
        NamedRef(id: _schoolId, nameAr: 'a', nameEn: 'b'),
      );
      expect(ProfileCity.fromJson(coded.toJson()), coded);
      expect(coded, isNot(free));
    });

    test('SchoolRegistration and UniversityRegistration: equality, '
        'hashCode, copyWith and the request body', () {
      final school = _schoolBody();
      expect(school, _schoolBody());
      expect(school.hashCode, _schoolBody().hashCode);
      expect(school.copyWith(stage: 'x').stage, 'x');
      expect(school.copyWith(stage: 'x'), isNot(school));
      expect(SchoolRegistration.fromJson(_wire(school)), school);
      final schoolWire = _wire(school);
      expect(schoolWire['registrationToken'], _regToken);
      expect(schoolWire['inviteCode'], _referral);
      expect(schoolWire['track'], 'school');

      final university = _universityBody();
      expect(university, _universityBody());
      expect(university.hashCode, _universityBody().hashCode);
      expect(university.copyWith(facultyId: 'x').facultyId, 'x');
      expect(university.copyWith(facultyId: 'x'), isNot(university));
      expect(UniversityRegistration.fromJson(_wire(university)), university);
      final universityWire = _wire(university);
      expect(universityWire['parentPhone'], _parentPhone);
      expect(universityWire['track'], 'university');
      // Omitted, not null: the redaction did not touch includeIfNull.
      expect(universityWire.containsKey('cityId'), isFalse);
    });

    test('LeaderboardEntry: equality, hashCode, copyWith and JSON', () {
      const same = LeaderboardEntry(
        rank: 3,
        studentId: _studentId,
        name: _name,
        avatarUrl: _avatarId,
        points: 1200,
        isMe: false,
      );
      expect(same, _entry);
      expect(same.hashCode, _entry.hashCode);
      expect(_entry.copyWith(isMe: true).isMe, isTrue);
      expect(_entry.copyWith(isMe: true), isNot(_entry));
      expect(LeaderboardEntry.fromJson(_entry.toJson()), _entry);
      expect(_entry.toJson(), {
        'rank': 3,
        'studentId': _studentId,
        'name': _name,
        'avatarUrl': _avatarId,
        'points': 1200,
        'isMe': false,
      });
    });

    test('the support tickets: equality, hashCode, copyWith, JSON and the '
        'getters', () {
      final summary = _ticketSummary();
      expect(summary, _ticketSummary());
      expect(summary.hashCode, _ticketSummary().hashCode);
      expect(summary.copyWith(status: 'closed').isClosed, isTrue);
      expect(summary.copyWith(status: 'closed'), isNot(summary));
      expect(SupportTicketSummary.fromJson(summary.toJson()), summary);
      expect(summary.toJson()['subject'], _ticketSubject);
      expect(summary.isClosed, isFalse);

      final ticket = _ticket();
      expect(ticket, _ticket());
      expect(ticket.hashCode, _ticket().hashCode);
      expect(ticket.copyWith(details: 'x').details, 'x');
      expect(ticket.copyWith(details: 'x'), isNot(ticket));
      expect(SupportTicket.fromJson(ticket.toJson()), ticket);
      expect(ticket.toJson()['subject'], _ticketSubject);
      expect(ticket.toJson()['details'], _ticketDetails);
      expect(ticket.knownStatus, SupportTicketStatus.open);

      final message = _ticketMessage();
      expect(message, _ticketMessage());
      expect(message.hashCode, _ticketMessage().hashCode);
      expect(message.copyWith(body: 'x').body, 'x');
      expect(message.copyWith(body: 'x'), isNot(message));
      expect(SupportTicketMessage.fromJson(message.toJson()), message);
      expect(message.toJson()['body'], _ticketBody);
      expect(message.isStudent, isTrue);
    });

    test('ProfileAvatar: equality, hashCode, copyWith and JSON', () {
      const same = ProfileAvatar(type: 'custom', id: _avatarId, url: _photoUrl);
      expect(same, _avatar);
      expect(same.hashCode, _avatar.hashCode);
      expect(_avatar.copyWith(url: 'x').url, 'x');
      expect(_avatar.copyWith(url: 'x'), isNot(_avatar));
      expect(ProfileAvatar.fromJson(_avatar.toJson()), _avatar);
      expect(_avatar.toJson(), {
        'type': 'custom',
        'id': _avatarId,
        'url': _photoUrl,
      });
      // The profile that holds it still round-trips, avatar included.
      expect(StudentProfile.fromJson(_wire(_profile())).avatar, _avatar);
    });

    test('Phone and ProfileUpdate: the wire values are untouched', () {
      expect(Phone.tryParse(_phoneLocal)!.e164, _phoneE164);
      expect(Phone.tryParse(_phoneLocal), Phone.tryParse(_phoneE164));
      expect(_fullUpdate().toJson(), {
        'name': _name,
        'email': _email,
        'avatarId': _avatarId,
        'leaderboardVisible': true,
        'scoreHidden': false,
      });
      expect(const ProfileUpdate(email: EmailPatch.cleared()).toJson(), {
        'email': null,
      });
    });
  });

  group('layer 2 - the committed generated code', () {
    // Models whose generated `toString` would print their fields if the
    // hand-written override were ever removed. Reading the generated file is
    // what notices: the override lives in the .dart, the damage in the
    // .freezed.dart.
    const redactedFreezed = [
      'lib/features/auth/models/token_pair.freezed.dart',
      'lib/features/auth/models/auth_result.freezed.dart',
      'lib/features/auth/models/device_info.freezed.dart',
      'lib/features/registration/models/registration_draft.freezed.dart',
      // One freezed class per file, so the whole file must be free of one.
      'lib/features/registration/models/school_registration.freezed.dart',
      'lib/features/registration/models/university_registration.freezed.dart',
      'lib/features/leaderboard/models/leaderboard_models.freezed.dart',
      // Three classes in this file, all redacted, so none may print.
      'lib/features/support/models/support_models.freezed.dart',
    ];

    for (final path in redactedFreezed) {
      test('$path emits no toString() at all', () {
        final generated = File(path).readAsStringSync();
        expect(
          RegExp(r'String\s+toString\s*\(').hasMatch(generated),
          isFalse,
          reason:
              '$path generates a toString() again - the class body lost its '
              'redacted override, so every field is printed',
        );
      });
    }

    test('student_profile.freezed.dart generates no toString for '
        'StudentProfile, ProfileAvatar or either ProfileCity arm', () {
      // The file also holds the profile's small nested blocks (points, privacy,
      // the school and university blocks), which keep a generated one: it is
      // the classes below that carry the person (and the photo they uploaded).
      final printed = _generatedToStringFields(
        File(
          'lib/features/profile/models/student_profile.freezed.dart',
        ).readAsStringSync(),
      ).keys.toSet();
      expect(printed, isNotEmpty, reason: 'the extractor found nothing');
      expect(printed, isNot(contains('StudentProfile')));
      expect(printed, isNot(contains('ProfileAvatar')));
      expect(printed, isNot(contains('ProfileCity.coded')));
      expect(printed, isNot(contains('ProfileCity.freeText')));
    });

    test('each of those classes declares the override in its own source', () {
      const sources = {
        'lib/features/auth/models/token_pair.dart': 'TokenPair(<redacted>)',
        'lib/features/auth/models/device_info.dart': 'DeviceInfo(<redacted>)',
        'lib/features/registration/models/registration_draft.dart':
            'RegistrationDraft(<redacted>)',
        'lib/features/auth/models/auth_result.dart': '<redacted>',
        'lib/features/registration/models/school_registration.dart':
            'SchoolRegistration(<redacted>)',
        'lib/features/registration/models/university_registration.dart':
            'UniversityRegistration(<redacted>)',
        'lib/features/leaderboard/models/leaderboard_models.dart':
            'LeaderboardEntry(<redacted>)',
        'lib/features/profile/models/student_profile.dart':
            'StudentProfile(<redacted>)',
      };
      for (final e in sources.entries) {
        final src = File(e.key).readAsStringSync();
        expect(
          RegExp(r'@override\s+String\s+toString\s*\(').hasMatch(src),
          isTrue,
          reason: '${e.key} has no toString override',
        );
        expect(src, contains(e.value), reason: e.key);
      }
      // Files that hold more than one redacted class: each one is named.
      final profileSrc = File(
        'lib/features/profile/models/student_profile.dart',
      ).readAsStringSync();
      expect(profileSrc, contains("'ProfileAvatar(<redacted>)'"));
      final supportSrc = File(
        'lib/features/support/models/support_models.dart',
      ).readAsStringSync();
      for (final redacted in const [
        'SupportTicketSummary(<redacted>)',
        'SupportTicket(<redacted>)',
        'SupportTicketMessage(<redacted>)',
      ]) {
        expect(supportSrc, contains("'$redacted'"));
      }
    });
  });

  group('layer 3 - hand-written toString bodies interpolate nothing '
      'sensitive', () {
    const handWritten = [
      'lib/features/auth/models/phone.dart',
      'lib/features/auth/models/token_pair.dart',
      'lib/features/auth/models/device_info.dart',
      'lib/features/auth/models/auth_result.dart',
      'lib/features/registration/models/registration_draft.dart',
      'lib/features/profile/models/profile_update.dart',
      'lib/features/profile/models/student_profile.dart',
      'lib/features/registration/models/school_registration.dart',
      'lib/features/registration/models/university_registration.dart',
      'lib/features/leaderboard/models/leaderboard_models.dart',
      'lib/features/support/models/support_models.dart',
    ];

    test('control: the extractor and the matcher see an interpolation', () {
      final bodies = _toStringBodies(
        "class A { @override String toString() => 'A(\$secretToken)'; "
        "@override String toString() { return 'B(\${x.phone})'; } }",
      );
      expect(bodies, hasLength(2));
      expect(_sensitiveInterpolations(bodies[0]), isNotEmpty);
      expect(_sensitiveInterpolations(bodies[1]), isNotEmpty);
      expect(_sensitiveInterpolations("'A(<redacted>)'"), isEmpty);
    });

    for (final path in handWritten) {
      test(path, () {
        final bodies = _toStringBodies(
          _withoutComments(File(path).readAsStringSync()),
        );
        expect(bodies, isNotEmpty, reason: '$path declares no toString');
        for (final body in bodies) {
          expect(
            _sensitiveInterpolations(body),
            isEmpty,
            reason: '$path: toString interpolates a sensitive field: $body',
          );
        }
      });
    }
  });

  group('census - no freezed model prints a field named like a credential, a '
      'student id, an avatar, a personal name or text a student wrote', () {
    // Generated `toString` bodies that interpolate a field with one of those
    // names (see [_printsPersonalData] for the exact rule - it goes by the
    // field's NAME, so this is not "every model is redacted"). A model on
    // [knownUnredacted] would be a KNOWN gap with an owner; the list may only
    // shrink, and it is EMPTY: the profile and its free-text city, the two
    // registration bodies, a leaderboard row, the three support-ticket models
    // and the profile avatar are all redacted, so from here a freezed model in
    // `lib/` that prints such a field fails this test.
    const knownUnredacted = <String>{};

    test('control: the matcher tells personal data from a plain field', () {
      expect(_credentialField('registrationToken'), isTrue);
      expect(_credentialField('parentPhone'), isTrue);
      expect(_credentialField('email'), isTrue);
      expect(_credentialField('dateOfBirth'), isTrue);
      expect(_credentialField('deviceId'), isTrue);
      expect(_credentialField('inviteCode'), isTrue);
      expect(_credentialField('studentId'), isTrue);
      expect(_credentialField('avatarUrl'), isTrue);
      expect(_credentialField('resendAfterSeconds'), isFalse);
      expect(_credentialField('expiresInSeconds'), isFalse);
      expect(_credentialField('nameAr'), isFalse);
      expect(_credentialField('parentReportStatus'), isFalse);

      // A bare `name` is a person's when the class is not catalogue content.
      expect(_printsPersonalData('LeaderboardEntry', 'name'), isTrue);
      expect(_printsPersonalData('ProfileCity.freeText', 'name'), isTrue);
      expect(_printsPersonalData('LeaderboardEntry', 'studentId'), isTrue);
      expect(_printsPersonalData('Subject', 'name'), isFalse);
      expect(_printsPersonalData('Lecture', 'name'), isFalse);
      expect(_printsPersonalData('MistakesChapter', 'name'), isFalse);
      expect(_printsPersonalData('Subject', 'id'), isFalse);
    });

    test('control: the matcher tells text a student wrote from catalogue '
        'text', () {
      // A ticket's subject, opening text and reply body are the student's own.
      expect(_studentAuthoredText('subject'), isTrue);
      expect(_studentAuthoredText('details'), isTrue);
      expect(_studentAuthoredText('body'), isTrue);
      expect(_studentAuthoredText('Message'), isTrue);
      expect(_printsPersonalData('SupportTicket', 'details'), isTrue);
      expect(_printsPersonalData('SupportTicketMessage', 'body'), isTrue);
      // Not them: the name of a subject, an id, a question's own wording.
      expect(_studentAuthoredText('subjectName'), isFalse);
      expect(_studentAuthoredText('subjectIds'), isFalse);
      expect(_studentAuthoredText('messageId'), isFalse);
      expect(_studentAuthoredText('text'), isFalse);
      expect(_printsPersonalData('QuizQuestion', 'text'), isFalse);
      expect(_printsPersonalData('QuizHistoryItem', 'subjectName'), isFalse);
      // The avatar a student uploaded is a photo of them; the picker's preset
      // row and an image in a question are not.
      expect(_printsPersonalData('ProfileAvatar', 'url'), isTrue);
      expect(_printsPersonalData('Avatar', 'url'), isFalse);
      expect(_printsPersonalData('QuizQuestion', 'imageUrl'), isFalse);
    });

    test(
      'control: the extractor reads the class and every field it prints',
      () {
        const generated = '''
@override
String toString() {
  return 'Buddy(studentId: \$studentId, name: \$name, points: \$points)';
}
''';
        expect(_generatedToStringFields(generated), {
          'Buddy': {'studentId', 'name', 'points'},
        });
        // And the matcher flags that synthetic model on the two fields a person
        // is behind, and not on the score.
        final flagged = {
          for (final f in _generatedToStringFields(generated)['Buddy']!)
            if (_printsPersonalData('Buddy', f)) f,
        };
        expect(flagged, {'studentId', 'name'});
      },
    );

    test('only the known models still print personal data', () {
      final offenders = <String, Set<String>>{};
      var scanned = 0;
      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File) continue;
        final path = entity.path.replaceAll(r'\', '/');
        if (!path.endsWith('.freezed.dart')) continue;
        scanned++;
        final printed = <String>{
          for (final e in _generatedToStringFields(
            entity.readAsStringSync(),
          ).entries)
            for (final field in e.value)
              if (_printsPersonalData(e.key, field)) '${e.key}.$field',
        };
        if (printed.isNotEmpty) offenders[path] = printed;
      }
      // Not vacuous: the scan really walked the generated models (30 when this
      // was written; it may grow, a collapse to nothing means the path broke).
      expect(scanned, greaterThan(20));
      final unexpected = {
        for (final e in offenders.entries)
          if (!knownUnredacted.contains(e.key)) e.key: e.value,
      };
      expect(
        unexpected,
        isEmpty,
        reason:
            'a freezed model prints a credential or personal data. Add '
            '`const X._();` and an `@override String toString()` that names no '
            'field, then regenerate (see TokenPair / MyInvite / StudentCard). '
            'A catalogue title class belongs in _catalogueNameClasses instead.',
      );
    });
  });
}

// ---------------------------------------------------------------------------
// Source helpers
// ---------------------------------------------------------------------------

/// A field whose value is a credential or identifies a person, whatever class
/// it is on: a token, a phone, an address, a date of birth, a student id, an
/// avatar. A bare `name` is not here, because it is a person's on one class and
/// a subject's title on another; see [_printsPersonalData].
bool _credentialField(String field) => RegExp(
  r'token|phone|e164|email|deviceid|birth|dob|password|secret|otp|'
  r'invitecode|referralcode|rebind|studentid|avatar',
  caseSensitive: false,
).hasMatch(field);

/// Catalogue content, whose generated `toString` may print its `name`: the
/// title of a module, subject, unit, chapter, lesson or lecture is the same for
/// every student and is not a person. A NEW class that prints a `name` is
/// flagged until it is redacted or, if it really is a catalogue title, listed
/// here on purpose.
const _catalogueNameClasses = {
  'CatalogModule',
  'Subject',
  'Unit',
  'Chapter',
  'Lesson',
  'Lecture',
  'MistakesSubject',
  'MistakesUnit',
  'MistakesChapter',
  'MistakesLesson',
  'MistakesLecture',
};

/// A field whose value is text the student typed: a support ticket's subject,
/// its opening text, a reply's body. Exact names only (a `subjectName` is the
/// catalogue's title, a `messageId` is an id), and a model that prints one of
/// them is a student's words in a log.
bool _studentAuthoredText(String field) => const {
  'subject',
  'details',
  'body',
  'message',
  'comment',
  'note',
  'notes',
  'feedback',
}.contains(field.toLowerCase());

/// Fields that are personal on ONE class and plain on others of the same name,
/// so the name alone cannot say. `ProfileAvatar.url` is the student's own
/// uploaded photo when the avatar is `custom`; the picker's `Avatar.url` is a
/// preset image the same for everyone, and a question's `imageUrl` is content.
const _personalFieldsByClass = <String, Set<String>>{
  'ProfileAvatar': {'url'},
};

/// Whether a generated `toString` on [cls] that prints [field] prints a
/// credential, a person's identifying data or text a student wrote.
bool _printsPersonalData(String cls, String field) =>
    _credentialField(field) ||
    _studentAuthoredText(field) ||
    (_personalFieldsByClass[cls]?.contains(field) ?? false) ||
    (field.toLowerCase() == 'name' && !_catalogueNameClasses.contains(cls));

/// The field names each generated `toString()` interpolates, by the class name
/// it opens with (`Foo(a: $a, b: $b)` -> `{Foo: {a, b}}`).
Map<String, Set<String>> _generatedToStringFields(String generated) {
  final out = <String, Set<String>>{};
  for (final m in RegExp(
    r"String toString\(\) \{\s*return '([^']*)';",
  ).allMatches(generated)) {
    final body = m.group(1)!;
    final cls = body.split('(').first;
    for (final f in RegExp(r'\$\{?([A-Za-z_]\w*)').allMatches(body)) {
      (out[cls] ??= <String>{}).add(f.group(1)!);
    }
  }
  return out;
}

/// Drops `//` line comments (doc comments included), leaving string literals
/// alone so a quoted `//` is not mistaken for one.
String _withoutComments(String src) {
  final out = StringBuffer();
  for (final line in src.split('\n')) {
    var inString = '';
    var cut = line.length;
    for (var i = 0; i < line.length; i++) {
      final c = line[i];
      if (inString.isNotEmpty) {
        if (c == r'\') {
          i++;
        } else if (c == inString) {
          inString = '';
        }
      } else if (c == "'" || c == '"') {
        inString = c;
      } else if (c == '/' && i + 1 < line.length && line[i + 1] == '/') {
        cut = i;
        break;
      }
    }
    out.writeln(line.substring(0, cut));
  }
  return out.toString();
}

/// The text of every `String toString()` body: from the `=>` or `{` to the end
/// of the statement / block.
List<String> _toStringBodies(String src) {
  final bodies = <String>[];
  for (final m in RegExp(
    r'String\s+toString\s*\(\s*\)\s*(=>|\{)',
  ).allMatches(src)) {
    if (m.group(1) == '=>') {
      final end = src.indexOf(';', m.end);
      bodies.add(src.substring(m.end, end < 0 ? src.length : end));
    } else {
      var depth = 1;
      var i = m.end;
      while (i < src.length && depth > 0) {
        if (src[i] == '{') depth++;
        if (src[i] == '}') depth--;
        i++;
      }
      bodies.add(src.substring(m.end, i));
    }
  }
  return bodies;
}

/// The interpolated expressions in [body] that name a credential or a person's
/// data, or dump a whole JSON map (which holds the values).
List<String> _sensitiveInterpolations(String body) {
  final hits = <String>[];
  for (final m in RegExp(r'\$\{([^}]*)\}|\$([A-Za-z_]\w*)').allMatches(body)) {
    final expr = m.group(1) ?? m.group(2)!;
    final dumpsJson = expr.contains('toJson()') && !expr.contains('.keys');
    final sensitive = RegExp(
      r'token|phone|e164|email|deviceid|model|value|name|birth|dob|profile|'
      r'password|secret|otp|code|school|avatar|student|parent|referral|city',
      caseSensitive: false,
    ).hasMatch(expr.replaceAll('toJson()', ''));
    if (dumpsJson || sensitive) hits.add(expr);
  }
  return hits;
}
