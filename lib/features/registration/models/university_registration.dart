import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/date_only_converter.dart';
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
/// Required (`:1305`): `track, registrationToken, name, dateOfBirth,
/// universityId, facultyId, studyYearId, governorateId, parentPhone`, PLUS the
/// `anyOf` at `:1306-1308` — at least one of `cityId` / `cityName`.
/// Optional: `cityId, cityName, email, avatarId` (the last two not collected —
/// see [SchoolRegistration]).
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
  ///
  /// Throws [IncompleteRegistrationDraft] if a required field is missing —
  /// callers must gate on `validateUniversityDraft` first.
  factory UniversityRegistration.fromDraft(RegistrationDraft draft) {
    final city = cityUnionFromDraft(draft);

    return UniversityRegistration(
      registrationToken: draft.registrationToken,
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
