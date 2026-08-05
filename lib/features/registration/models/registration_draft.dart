import 'package:freezed_annotation/freezed_annotation.dart';

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
/// has no student-phone field). [referralCode] is collected but NOT submitted
/// (no backend field — conflict #1, TODO(contract)).
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
    // --- School academic ---
    String? stage,
    String? educationSystem,
    // --- University cascade (university → faculty → year) ---
    String? universityId,
    String? facultyId,
    String? studyYearId,
  }) = _RegistrationDraft;

  /// The friendly client guard: once the token's TTL has passed, every step
  /// bounces back to `/login` ("registration expired, start again"). The server
  /// also enforces expiry — this just avoids a doomed submit.
  bool get isExpired => DateTime.now().isAfter(tokenExpiresAt);
}
