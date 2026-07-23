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
/// Day-3 fields (`dateOfBirth`, geography ids, academic ids, `avatarId`) are
/// nullable now; only `dateOfBirth` is modeled here (the rest land with the
/// track-detail screens). `dateOfBirth` is contract-required but collected on a
/// Day-3 screen, so it stays nullable until then.
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
  }) = _RegistrationDraft;

  /// The friendly client guard: once the token's TTL has passed, every step
  /// bounces back to `/login` ("registration expired, start again"). The server
  /// also enforces expiry — this just avoids a doomed submit.
  bool get isExpired => DateTime.now().isAfter(tokenExpiresAt);
}
