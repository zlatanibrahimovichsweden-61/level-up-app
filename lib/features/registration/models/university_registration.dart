import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/date_only_converter.dart';
import '../../auth/models/device_info.dart';
import 'registration_body.dart';
import 'registration_draft.dart';

part 'university_registration.freezed.dart';
part 'university_registration.g.dart';

/// The `university` arm of `POST /auth/register` — contract schema
/// `UniversityRegistration`.
///
/// **Egypt-only BY SHAPE (adr-010): there is no `countryCode` field at all.**
/// That is why this is a separate class rather than a variant of
/// [SchoolRegistration] — adding a country here would invent contract surface.
///
/// Required (contract v2.1.0-m1, `:1432`): `track, registrationToken, device,
/// name, dateOfBirth, universityId, facultyId, studyYearId, governorateId,
/// parentPhone`, PLUS the `anyOf` at `:1433-1435` — at least one of `cityId` /
/// `cityName`.
/// Optional: `cityId, cityName, email, avatarId` (the last two not collected —
/// see [SchoolRegistration]).
///
/// `device` (`:1420`) became REQUIRED in contract 2.0.0-m1 — the same
/// `DeviceInfo` already sent to `/auth/otp/verify`, and it must be the same
/// DEVICE (the `registrationToken` is device-bound; a mismatch answers
/// `registration_token_invalid`). Passed into
/// [UniversityRegistration.fromDraft] rather than carried on the draft, being
/// ambient device state rather than wizard input.
///
/// Note `governorateId` is REQUIRED here (unlike the school body, where it is
/// conditional). It is missing from the Figma frame —
/// see docs/DESIGN_ISSUES.md #3.
///
/// `studyYearId` must reference an `active` year; a `soon` year is rejected
/// server-side with `validation_failed`, so the picker never offers one.
@freezed
abstract class UniversityRegistration
    with _$UniversityRegistration
    implements RegistrationBody {
  const factory UniversityRegistration({
    @Default(kTrackUniversity) String track,
    required String registrationToken,

    /// Contract-REQUIRED since 2.0.0-m1. No `@JsonKey`: the key is already
    /// camelCase, and `includeIfNull` cannot apply to a non-nullable field.
    required DeviceInfo device,
    required String name,
    @DateOnlyConverter() required DateTime dateOfBirth,
    required String universityId,
    required String facultyId,
    required String studyYearId,
    required String governorateId,

    /// adr-028 §1 — exactly one of these two reaches the wire, same rule as
    /// the school body. Both nullable: the contract expresses "at least one"
    /// as an `anyOf`, not by making either required.
    @JsonKey(includeIfNull: false) String? cityId,
    @JsonKey(includeIfNull: false) String? cityName,
    required String parentPhone,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(includeIfNull: false) String? avatarId,
  }) = _UniversityRegistration;

  const UniversityRegistration._();

  factory UniversityRegistration.fromJson(Map<String, dynamic> json) =>
      _$UniversityRegistrationFromJson(json);

  /// Builds the body from the wizard draft. There is still no geography branch
  /// on this track — every field below is unconditionally required — but the
  /// city is now the adr-028 §1 union, resolved by [cityUnionFromDraft] exactly
  /// as on the school body.
  ///
  /// `name` and `parentPhone` come from Sign Up_1 (never re-collected);
  /// `referralCode` is never submitted (no contract field — DESIGN_ISSUES #7).
  /// [device] is supplied by the caller (the shared `deviceInfoProvider`), not
  /// read from the draft — see the class doc.
  ///
  /// Throws [IncompleteRegistrationDraft] if a required field is missing —
  /// callers must gate on `validateUniversityDraft` first.
  factory UniversityRegistration.fromDraft(
    RegistrationDraft draft, {
    required DeviceInfo device,
  }) {
    final city = cityUnionFromDraft(draft);

    return UniversityRegistration(
      registrationToken: draft.registrationToken,
      device: device,
      name: requireField(draft.name, 'name'),
      dateOfBirth: requireField(draft.dateOfBirth, 'dateOfBirth'),
      universityId: requireField(draft.universityId, 'universityId'),
      facultyId: requireField(draft.facultyId, 'facultyId'),
      studyYearId: requireField(draft.studyYearId, 'studyYearId'),
      governorateId: requireField(draft.governorateId, 'governorateId'),
      cityId: city.cityId,
      cityName: city.cityName,
      parentPhone: requireField(draft.parentPhone, 'parentPhone'),
    );
  }
}
