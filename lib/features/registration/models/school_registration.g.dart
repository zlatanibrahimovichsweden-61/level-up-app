// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchoolRegistration _$SchoolRegistrationFromJson(Map<String, dynamic> json) =>
    _SchoolRegistration(
      track: json['track'] as String? ?? kTrackSchool,
      registrationToken: json['registrationToken'] as String,
      name: json['name'] as String,
      dateOfBirth: const DateOnlyConverter().fromJson(
        json['dateOfBirth'] as String,
      ),
      countryCode: json['countryCode'] as String,
      governorateId: json['governorateId'] as String?,
      cityId: json['cityId'] as String,
      schoolId: json['schoolId'] as String?,
      schoolName: json['schoolName'] as String?,
      stage: json['stage'] as String,
      educationSystem: json['educationSystem'] as String,
      parentPhone: json['parentPhone'] as String,
      email: json['email'] as String?,
      avatarId: json['avatarId'] as String?,
    );

Map<String, dynamic> _$SchoolRegistrationToJson(_SchoolRegistration instance) =>
    <String, dynamic>{
      'track': instance.track,
      'registrationToken': instance.registrationToken,
      'name': instance.name,
      'dateOfBirth': const DateOnlyConverter().toJson(instance.dateOfBirth),
      'countryCode': instance.countryCode,
      'governorateId': ?instance.governorateId,
      'cityId': instance.cityId,
      'schoolId': ?instance.schoolId,
      'schoolName': ?instance.schoolName,
      'stage': instance.stage,
      'educationSystem': instance.educationSystem,
      'parentPhone': instance.parentPhone,
      'email': ?instance.email,
      'avatarId': ?instance.avatarId,
    };
