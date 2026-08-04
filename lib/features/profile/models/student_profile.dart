import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/date_only_converter.dart';
import '../../registration/models/reference_models.dart';
import 'entitlement_state.dart';

part 'student_profile.freezed.dart';
part 'student_profile.g.dart';

/// `GET /me` → contract `StudentProfile`. The whole (school) Home is powered by
/// this one call.
///
/// Contract keys are already camelCase — NO `@JsonKey(name:)` bridge is needed
/// and none must be added. Contract-required fields are `required` with no
/// default: if the server omits one the parse throws, which is the system
/// working — it surfaces contract drift instead of hiding it behind a `?? 0`
/// that would show a student the wrong score.
///
/// `NamedRef` is the contract's shared bilingual reference row; it is imported
/// from the registration models rather than duplicated, because duplicating a
/// contract type is how the two copies silently drift apart.

/// The student's track. Contract enum `[school, university]` is a CLOSED set
/// (unlike `EducationSystem`/`EntitlementType`, which are marked extensible), so
/// a generated enum is correct here: an unknown value must throw.
///
/// Distinct from registration's `RegTrack`, which is the wizard's local draft
/// discriminator; this one is what the server says the account actually is.
enum Track { school, university }

@freezed
abstract class StudentProfile with _$StudentProfile {
  const factory StudentProfile({
    required String id,
    required Track track,
    required String name,
    required String phone,

    /// Contract-optional, and never a login channel (adr-019).
    String? email,
    @DateOnlyConverter() required DateTime dateOfBirth,
    required ProfileAvatar avatar,
    required ProfileGeography geography,

    /// School-track block — null for university students.
    ProfileSchool? school,

    /// University-track block — null for school students.
    ProfileUniversity? university,
    required ProfilePoints points,

    /// 1–12, thresholds every 500 points. SERVER-AUTHORITATIVE — display only.
    required int level,

    /// Post-level-12 badges (every 5,000 points; first at 11,000).
    /// SERVER-AUTHORITATIVE — display only.
    required int badges,
    required ProfilePrivacy privacy,

    /// Read-only embed for first paint. The paywall source of truth is
    /// `GET /me/entitlements`.
    required List<EntitlementState> entitlements,
    required DateTime createdAt,
  }) = _StudentProfile;

  factory StudentProfile.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileFromJson(json);
}

/// The profile avatar — `{type, id?, url}`. `url` is a network image.
/// Distinct from registration's `Avatar` (`{id, url}`), which is a row in the
/// default-avatar picker; this is the one currently ON the account, and `type`
/// says whether it came from that picker (`default`) or an upload (`custom`).
///
/// `type` stays a wire `String`: the UI does not branch on it today, and
/// hard-typing a two-value enum the app never reads only adds a way to throw.
@freezed
abstract class ProfileAvatar with _$ProfileAvatar {
  const factory ProfileAvatar({
    required String type,

    /// Present for default avatars only.
    String? id,
    required String url,
  }) = _ProfileAvatar;

  factory ProfileAvatar.fromJson(Map<String, dynamic> json) =>
      _$ProfileAvatarFromJson(json);
}

/// Registration geography as the server stored it. `governorate` is Egypt-only
/// (adr-010) and null everywhere else; `city` is always present.
@freezed
abstract class ProfileGeography with _$ProfileGeography {
  const factory ProfileGeography({
    required String countryCode,
    NamedRef? governorate,
    required NamedRef city,
  }) = _ProfileGeography;

  factory ProfileGeography.fromJson(Map<String, dynamic> json) =>
      _$ProfileGeographyFromJson(json);
}

/// School-track academic block. `stage` and `educationSystem` are kept as wire
/// `String`s for the same reason `EducationSystemRef.code` is: the contract
/// marks `EducationSystem` extensible ("clients must tolerate unknown values"),
/// and a generated enum would throw on a newly-added one.
@freezed
abstract class ProfileSchool with _$ProfileSchool {
  const factory ProfileSchool({
    /// The coded school (Egypt). Null when the student typed a free-text name.
    NamedRef? school,

    /// Free-text school name (non-Egypt).
    String? schoolName,
    required String stage,
    required String educationSystem,
  }) = _ProfileSchool;

  factory ProfileSchool.fromJson(Map<String, dynamic> json) =>
      _$ProfileSchoolFromJson(json);
}

/// University-track academic block.
@freezed
abstract class ProfileUniversity with _$ProfileUniversity {
  const factory ProfileUniversity({
    required NamedRef university,
    required NamedRef faculty,
    required int yearNumber,
  }) = _ProfileUniversity;

  factory ProfileUniversity.fromJson(Map<String, dynamic> json) =>
      _$ProfileUniversityFromJson(json);
}

/// The dual point pools (adr-003). `total` is `school + university` — but it is
/// the SERVER's sum, displayed verbatim. The app never adds these up itself and
/// never uses a pool total to infer a level.
@freezed
abstract class ProfilePoints with _$ProfilePoints {
  const factory ProfilePoints({
    required int school,
    required int university,
    required int total,
  }) = _ProfilePoints;

  factory ProfilePoints.fromJson(Map<String, dynamic> json) =>
      _$ProfilePointsFromJson(json);
}

/// adr-023 privacy toggles. Enforcement is server-side; these only drive UI.
@freezed
abstract class ProfilePrivacy with _$ProfilePrivacy {
  const factory ProfilePrivacy({
    required bool leaderboardVisible,
    required bool scoreHidden,
  }) = _ProfilePrivacy;

  factory ProfilePrivacy.fromJson(Map<String, dynamic> json) =>
      _$ProfilePrivacyFromJson(json);
}
