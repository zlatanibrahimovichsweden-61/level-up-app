import 'package:freezed_annotation/freezed_annotation.dart';

import 'reference_models.dart';

part 'registration_draft.freezed.dart';

/// The registration track — the discriminator `POST /auth/register` switches on
/// (`school` → `SchoolRegistration`, `university` → `UniversityRegistration`).
enum RegTrack { school, university }

/// The immutable draft accumulated across the registration wizard, held by
/// [RegistrationController]. NOT a contract type and never serialized — the
/// final `POST /auth/register` (Day 3) builds its body from these fields.
///
/// It carries the short-lived `registrationToken` from the OTP
/// `registrationRequired` fork plus its deadline ([tokenExpiresAt]); the wizard
/// must finish inside that 10-minute window. [phone] is proven & bound to the
/// token — read-only, shown pre-filled, and NEVER submitted (the register body
/// has no student-phone field). [referralCode] is Sign Up_1's optional code:
/// the School body sends it, trimmed, as `inviteCode` when it is not empty,
/// and the University body does not send it (SQ-24(l)).
///
/// EVERY track-detail field is nullable here even where the contract marks it
/// required: the draft models a form part-way through being filled, not a
/// request body. `RegistrationBody.fromDraft` is where nullability collapses
/// back onto the contract's required set, and `registration_validation.dart` is
/// what gates the submit button so that collapse can't fail.
///
/// [requiresGovernorate] is copied off the selected country row
/// (`GET /reference/countries` → `requiresGovernorate`, true only for EG). It
/// is the adr-010 switch driving the whole geography branch — the code never
/// compares `countryCode == 'EG'` itself, because the country list is
/// server-owned and extensible.
///
/// `toString` is redacted to the type name. The draft is a minor's registration
/// in progress - the registration token, the proven phone, the student's name, a
/// parent's phone, a date of birth, a referral code - and the project rule is
/// that none of it reaches a log, an error detail or a test report by accident.
/// Freezed emits no `toString` of its own when the class declares one, so a
/// field added later cannot leak through it. Equality and `copyWith` are the
/// generated field-by-field ones.
@freezed
abstract class RegistrationDraft with _$RegistrationDraft {
  const RegistrationDraft._();

  const factory RegistrationDraft({
    required String registrationToken,
    required DateTime tokenExpiresAt,
    required String phone,
    String? name,
    String? parentPhone,
    String? referralCode,
    RegTrack? track,
    DateTime? dateOfBirth,
    // --- School geography (adr-010) ---
    String? countryCode,
    bool? requiresGovernorate,
    String? governorateId,

    /// The adr-028 §1 city union, held as two fields because the wire has two
    /// keys. Never both at once: every setter that populates one clears the
    /// other, which is what makes `cityUnionFromDraft`'s "both → throw"
    /// unreachable through the UI.
    String? cityId,
    String? cityName,
    String? schoolId,

    /// The school row picked from the search (its id and both names), held
    /// beside [schoolId] so the School form shows the school's NAME again when
    /// the student leaves it and comes back (BUG-027). Display only: the body
    /// sends [schoolId], never this.
    NamedRef? pickedSchool,

    /// adr-028 §2 — the student tapped "I can't find my school". It submits no
    /// `schoolId`, like "nothing chosen yet", but the field reads as answered.
    /// Held here rather than on the screen for the same reason (BUG-027).
    @Default(false) bool schoolSkipped,
    // --- School academic ---
    String? stage,
    String? educationSystem,
    // --- University cascade (university → faculty → year) ---
    String? universityId,
    String? facultyId,
    String? studyYearId,

    /// Names the server refused with `422 name_not_allowed` during THIS
    /// registration (this token), exactly as they were sent. The contract says
    /// not to retry the same name, so Sign Up_1 keeps such a name marked and
    /// will not go on with it, and the submit will not send it again; only a
    /// different name moves on (owner, 2026-10-10). A new token starts a new
    /// draft, and with it an empty set.
    @Default(<String>{}) Set<String> refusedNames,
  }) = _RegistrationDraft;

  /// The friendly client guard: once the token's TTL has passed, every step
  /// bounces back to `/login` ("registration expired, start again"). The server
  /// also enforces expiry — this just avoids a doomed submit.
  bool get isExpired => DateTime.now().isAfter(tokenExpiresAt);

  @override
  String toString() => 'RegistrationDraft(<redacted>)';
}
