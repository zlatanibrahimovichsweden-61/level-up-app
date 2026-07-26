import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/date_only_converter.dart';
import 'registration_body.dart';
import 'registration_draft.dart';

part 'school_registration.freezed.dart';
part 'school_registration.g.dart';

/// The `school` arm of `POST /auth/register` — contract schema
/// `SchoolRegistration`. Contract keys are already camelCase, so NO `@JsonKey`
/// name bridge is needed and none must be added.
///
/// Required (contract line `required: [...]`): `track, registrationToken, name,
/// dateOfBirth, countryCode, cityId, stage, educationSystem, parentPhone`.
/// Optional: `governorateId, schoolId, schoolName, email, avatarId`.
///
/// **`includeIfNull: false` on every optional field is load-bearing, not
/// tidiness.** The contract's geography conditionality (adr-010) makes some
/// optional fields FORBIDDEN rather than merely absent — sending
/// `"schoolName": null` for an Egyptian student is sending the key, and the
/// server answers `validation_failed`. Omitted means omitted.
///
/// `email` and `avatarId` exist in the contract but are not collected: neither
/// appears in the Figma frames and both are optional (the server assigns a
/// default avatar). They are modeled so the shape stays faithful.
@freezed
abstract class SchoolRegistration
    with _$SchoolRegistration
    implements RegistrationBody {
  const factory SchoolRegistration({
    /// The discriminator. Defaulted rather than `required` because it is a
    /// constant of THIS shape, not data — see `discriminator.mapping` in the
    /// contract.
    @Default(kTrackSchool) String track,
    required String registrationToken,
    required String name,
    @DateOnlyConverter() required DateTime dateOfBirth,
    required String countryCode,
    @JsonKey(includeIfNull: false) String? governorateId,
    required String cityId,
    @JsonKey(includeIfNull: false) String? schoolId,
    @JsonKey(includeIfNull: false) String? schoolName,
    required String stage,
    required String educationSystem,
    required String parentPhone,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(includeIfNull: false) String? avatarId,
  }) = _SchoolRegistration;

  const SchoolRegistration._();

  factory SchoolRegistration.fromJson(Map<String, dynamic> json) =>
      _$SchoolRegistrationFromJson(json);

  /// Builds the body from the wizard draft, ENFORCING the adr-010 geography
  /// conditionality regardless of what the draft still holds.
  ///
  /// This is the last line of defence: the UI hides the wrong fields and the
  /// validator blocks submit, but a value left over from a country switch must
  /// never reach the wire. So the forbidden side is hard-nulled here rather
  /// than merely "not set":
  /// - `requiresGovernorate` (EG) → `governorateId` + `cityId` + `schoolId`
  ///   required, `schoolName` FORBIDDEN.
  /// - otherwise → `cityId` required, `schoolName` optional free text,
  ///   `schoolId` + `governorateId` FORBIDDEN.
  ///
  /// `name` and `parentPhone` come from Sign Up_1 and are never re-collected.
  /// `referralCode` is deliberately absent — there is no contract field for it
  /// (DESIGN_ISSUES #7); it is collected but never submitted.
  ///
  /// Throws [IncompleteRegistrationDraft] if a contract-required field is
  /// missing — callers must gate on `validateSchoolDraft` first.
  factory SchoolRegistration.fromDraft(RegistrationDraft draft) {
    final requiresGovernorate = draft.requiresGovernorate ?? false;
    final freeTextSchool = draft.schoolName?.trim();

    return SchoolRegistration(
      registrationToken: draft.registrationToken,
      name: requireField(draft.name, 'name'),
      dateOfBirth: requireField(draft.dateOfBirth, 'dateOfBirth'),
      countryCode: requireField(draft.countryCode, 'countryCode'),
      governorateId: requiresGovernorate
          ? requireField(draft.governorateId, 'governorateId')
          : null,
      cityId: requireField(draft.cityId, 'cityId'),
      schoolId:
          requiresGovernorate ? requireField(draft.schoolId, 'schoolId') : null,
      schoolName: requiresGovernorate
          ? null
          : (freeTextSchool == null || freeTextSchool.isEmpty
              ? null
              : freeTextSchool),
      stage: requireField(draft.stage, 'stage'),
      educationSystem: requireField(draft.educationSystem, 'educationSystem'),
      parentPhone: requireField(draft.parentPhone, 'parentPhone'),
    );
  }
}
