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
/// Required (contract `required: [...]`, `:1280`): `track, registrationToken,
/// name, dateOfBirth, countryCode, stage, educationSystem, parentPhone`, PLUS
/// the `anyOf` at `:1281-1283` — at least one of `cityId` / `cityName`.
/// Optional: `governorateId, cityId, cityName, schoolId, email, avatarId`.
///
/// **`includeIfNull: false` on every optional field is load-bearing, not
/// tidiness.** Some optional fields are FORBIDDEN rather than merely absent —
/// `governorateId` outside Egypt (adr-010), and whichever half of the city
/// union the student did not use (adr-028 §1). Sending `"cityName": null` is
/// sending the key, and the server answers `validation_failed`. Omitted means
/// omitted.
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

    /// adr-028 §1 — exactly one of these two reaches the wire. Both are
    /// nullable because the contract expresses "at least one" as an `anyOf`
    /// rather than by making either required.
    @JsonKey(includeIfNull: false) String? cityId,
    @JsonKey(includeIfNull: false) String? cityName,
    @JsonKey(includeIfNull: false) String? schoolId,
    required String stage,
    required String educationSystem,
    required String parentPhone,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(includeIfNull: false) String? avatarId,
  }) = _SchoolRegistration;

  const SchoolRegistration._();

  factory SchoolRegistration.fromJson(Map<String, dynamic> json) =>
      _$SchoolRegistrationFromJson(json);

  /// Builds the body from the wizard draft, ENFORCING the contract's
  /// conditionality regardless of what the draft still holds.
  ///
  /// This is the last line of defence: the UI hides the wrong fields and the
  /// validator blocks submit, but a value left over from a country switch must
  /// never reach the wire.
  /// - `governorateId` — adr-010, UNCHANGED by adr-028: required for
  ///   `requiresGovernorate` (EG), FORBIDDEN otherwise, so it is hard-nulled
  ///   rather than merely "not set".
  /// - city — adr-028 §1: exactly one of `cityId` / `cityName`; see
  ///   [cityUnionFromDraft].
  /// - `schoolId` — adr-028 §2: optional for EVERY school student, Egypt
  ///   included. It is serialized when present and simply omitted when not.
  ///   Outside Egypt it is FORBIDDEN, not because v1.1 rejects it but because
  ///   the school step does not exist in that flow, so a non-Egypt draft
  ///   carrying one is a cascade bug.
  ///
  /// `name` and `parentPhone` come from Sign Up_1 and are never re-collected.
  /// `referralCode` is deliberately absent — there is no contract field for it
  /// (DESIGN_ISSUES #7); it is collected but never submitted.
  ///
  /// Throws [IncompleteRegistrationDraft] if a contract-required field is
  /// missing and [ForbiddenRegistrationField] if a forbidden one is present —
  /// callers must gate on `validateSchoolDraft` first.
  factory SchoolRegistration.fromDraft(RegistrationDraft draft) {
    final requiresGovernorate = draft.requiresGovernorate ?? false;
    final city = cityUnionFromDraft(draft);

    if (!requiresGovernorate) {
      forbidField(
        draft.schoolId,
        'schoolId',
        'the coded school list is Egyptian, so the step does not exist here '
            '(adr-028 §2)',
      );
    }

    return SchoolRegistration(
      registrationToken: draft.registrationToken,
      name: requireField(draft.name, 'name'),
      dateOfBirth: requireField(draft.dateOfBirth, 'dateOfBirth'),
      countryCode: requireField(draft.countryCode, 'countryCode'),
      governorateId: requiresGovernorate
          ? requireField(draft.governorateId, 'governorateId')
          : null,
      cityId: city.cityId,
      cityName: city.cityName,
      schoolId: requiresGovernorate ? draft.schoolId : null,
      stage: requireField(draft.stage, 'stage'),
      educationSystem: requireField(draft.educationSystem, 'educationSystem'),
      parentPhone: requireField(draft.parentPhone, 'parentPhone'),
    );
  }
}
