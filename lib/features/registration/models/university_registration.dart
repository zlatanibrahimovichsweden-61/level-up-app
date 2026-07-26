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
/// Required: `track, registrationToken, name, dateOfBirth, universityId,
/// facultyId, studyYearId, governorateId, cityId, parentPhone`.
/// Optional: `email, avatarId` (not collected — see [SchoolRegistration]).
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
    required String cityId,
    required String parentPhone,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(includeIfNull: false) String? avatarId,
  }) = _UniversityRegistration;

  const UniversityRegistration._();

  factory UniversityRegistration.fromJson(Map<String, dynamic> json) =>
      _$UniversityRegistrationFromJson(json);

  /// Builds the body from the wizard draft. Every field is unconditionally
  /// required here — there is no geography branch on this track.
  ///
  /// `name` and `parentPhone` come from Sign Up_1 (never re-collected);
  /// `referralCode` is never submitted (no contract field — DESIGN_ISSUES #7).
  ///
  /// Throws [IncompleteRegistrationDraft] if a required field is missing —
  /// callers must gate on `validateUniversityDraft` first.
  factory UniversityRegistration.fromDraft(RegistrationDraft draft) {
    return UniversityRegistration(
      registrationToken: draft.registrationToken,
      name: requireField(draft.name, 'name'),
      dateOfBirth: requireField(draft.dateOfBirth, 'dateOfBirth'),
      universityId: requireField(draft.universityId, 'universityId'),
      facultyId: requireField(draft.facultyId, 'facultyId'),
      studyYearId: requireField(draft.studyYearId, 'studyYearId'),
      governorateId: requireField(draft.governorateId, 'governorateId'),
      cityId: requireField(draft.cityId, 'cityId'),
      parentPhone: requireField(draft.parentPhone, 'parentPhone'),
    );
  }
}
