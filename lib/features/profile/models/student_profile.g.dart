// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentProfile _$StudentProfileFromJson(Map<String, dynamic> json) =>
    _StudentProfile(
      id: json['id'] as String,
      track: $enumDecode(_$TrackEnumMap, json['track']),
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      dateOfBirth: const DateOnlyConverter().fromJson(
        json['dateOfBirth'] as String,
      ),
      avatar: ProfileAvatar.fromJson(json['avatar'] as Map<String, dynamic>),
      geography: ProfileGeography.fromJson(
        json['geography'] as Map<String, dynamic>,
      ),
      school: json['school'] == null
          ? null
          : ProfileSchool.fromJson(json['school'] as Map<String, dynamic>),
      university: json['university'] == null
          ? null
          : ProfileUniversity.fromJson(
              json['university'] as Map<String, dynamic>,
            ),
      points: ProfilePoints.fromJson(json['points'] as Map<String, dynamic>),
      level: (json['level'] as num).toInt(),
      badges: (json['badges'] as num).toInt(),
      privacy: ProfilePrivacy.fromJson(json['privacy'] as Map<String, dynamic>),
      entitlements: (json['entitlements'] as List<dynamic>)
          .map((e) => EntitlementState.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      pendingDeletion: json['pendingDeletion'] == null
          ? null
          : PendingDeletion.fromJson(
              json['pendingDeletion'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$StudentProfileToJson(_StudentProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'track': _$TrackEnumMap[instance.track]!,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'dateOfBirth': const DateOnlyConverter().toJson(instance.dateOfBirth),
      'avatar': instance.avatar,
      'geography': instance.geography,
      'school': instance.school,
      'university': instance.university,
      'points': instance.points,
      'level': instance.level,
      'badges': instance.badges,
      'privacy': instance.privacy,
      'entitlements': instance.entitlements,
      'createdAt': instance.createdAt.toIso8601String(),
      'pendingDeletion': instance.pendingDeletion,
    };

const _$TrackEnumMap = {Track.school: 'school', Track.university: 'university'};

_PendingDeletion _$PendingDeletionFromJson(Map<String, dynamic> json) =>
    _PendingDeletion(
      effectiveAt: DateTime.parse(json['effectiveAt'] as String),
    );

Map<String, dynamic> _$PendingDeletionToJson(_PendingDeletion instance) =>
    <String, dynamic>{'effectiveAt': instance.effectiveAt.toIso8601String()};

_ProfileAvatar _$ProfileAvatarFromJson(Map<String, dynamic> json) =>
    _ProfileAvatar(
      type: json['type'] as String,
      id: json['id'] as String?,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ProfileAvatarToJson(_ProfileAvatar instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'url': instance.url,
    };

_ProfileGeography _$ProfileGeographyFromJson(Map<String, dynamic> json) =>
    _ProfileGeography(
      countryCode: json['countryCode'] as String,
      governorate: json['governorate'] == null
          ? null
          : NamedRef.fromJson(json['governorate'] as Map<String, dynamic>),
      city: ProfileCity.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileGeographyToJson(_ProfileGeography instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'governorate': instance.governorate,
      'city': instance.city,
    };

CodedCity _$CodedCityFromJson(Map<String, dynamic> json) => CodedCity(
  NamedRef.fromJson(json['ref'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

FreeTextCity _$FreeTextCityFromJson(Map<String, dynamic> json) =>
    FreeTextCity(json['name'] as String, $type: json['runtimeType'] as String?);

_ProfileSchool _$ProfileSchoolFromJson(Map<String, dynamic> json) =>
    _ProfileSchool(
      school: json['school'] == null
          ? null
          : NamedRef.fromJson(json['school'] as Map<String, dynamic>),
      stage: json['stage'] as String,
      educationSystem: json['educationSystem'] as String,
      parentReportStatus: json['parentReportStatus'] as String?,
    );

Map<String, dynamic> _$ProfileSchoolToJson(_ProfileSchool instance) =>
    <String, dynamic>{
      'school': instance.school,
      'stage': instance.stage,
      'educationSystem': instance.educationSystem,
      'parentReportStatus': instance.parentReportStatus,
    };

_ProfileUniversity _$ProfileUniversityFromJson(Map<String, dynamic> json) =>
    _ProfileUniversity(
      university: NamedRef.fromJson(json['university'] as Map<String, dynamic>),
      faculty: NamedRef.fromJson(json['faculty'] as Map<String, dynamic>),
      yearNumber: (json['yearNumber'] as num).toInt(),
      termId: json['termId'] as String?,
      termNumber: (json['termNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileUniversityToJson(_ProfileUniversity instance) =>
    <String, dynamic>{
      'university': instance.university,
      'faculty': instance.faculty,
      'yearNumber': instance.yearNumber,
      'termId': instance.termId,
      'termNumber': instance.termNumber,
    };

_ProfilePoints _$ProfilePointsFromJson(Map<String, dynamic> json) =>
    _ProfilePoints(
      school: (json['school'] as num).toInt(),
      university: (json['university'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ProfilePointsToJson(_ProfilePoints instance) =>
    <String, dynamic>{
      'school': instance.school,
      'university': instance.university,
      'total': instance.total,
    };

_ProfilePrivacy _$ProfilePrivacyFromJson(Map<String, dynamic> json) =>
    _ProfilePrivacy(
      leaderboardVisible: json['leaderboardVisible'] as bool,
      scoreHidden: json['scoreHidden'] as bool,
    );

Map<String, dynamic> _$ProfilePrivacyToJson(_ProfilePrivacy instance) =>
    <String, dynamic>{
      'leaderboardVisible': instance.leaderboardVisible,
      'scoreHidden': instance.scoreHidden,
    };
