// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'university_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UniversityRegistration _$UniversityRegistrationFromJson(
  Map<String, dynamic> json,
) => _UniversityRegistration(
  track: json['track'] as String? ?? kTrackUniversity,
  registrationToken: json['registrationToken'] as String,
  device: DeviceInfo.fromJson(json['device'] as Map<String, dynamic>),
  name: json['name'] as String,
  dateOfBirth: const DateOnlyConverter().fromJson(
    json['dateOfBirth'] as String,
  ),
  universityId: json['universityId'] as String,
  facultyId: json['facultyId'] as String,
  studyYearId: json['studyYearId'] as String,
  governorateId: json['governorateId'] as String,
  cityId: json['cityId'] as String?,
  cityName: json['cityName'] as String?,
  parentPhone: json['parentPhone'] as String,
  email: json['email'] as String?,
  avatarId: json['avatarId'] as String?,
);

Map<String, dynamic> _$UniversityRegistrationToJson(
  _UniversityRegistration instance,
) => <String, dynamic>{
  'track': instance.track,
  'registrationToken': instance.registrationToken,
  'device': instance.device,
  'name': instance.name,
  'dateOfBirth': const DateOnlyConverter().toJson(instance.dateOfBirth),
  'universityId': instance.universityId,
  'facultyId': instance.facultyId,
  'studyYearId': instance.studyYearId,
  'governorateId': instance.governorateId,
  'cityId': ?instance.cityId,
  'cityName': ?instance.cityName,
  'parentPhone': instance.parentPhone,
  'email': ?instance.email,
  'avatarId': ?instance.avatarId,
};
