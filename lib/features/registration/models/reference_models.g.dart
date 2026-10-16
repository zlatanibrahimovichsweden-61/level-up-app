// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NamedRef _$NamedRefFromJson(Map<String, dynamic> json) => _NamedRef(
  id: json['id'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
);

Map<String, dynamic> _$NamedRefToJson(_NamedRef instance) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_Country _$CountryFromJson(Map<String, dynamic> json) => _Country(
  code: json['code'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  requiresGovernorate: json['requiresGovernorate'] as bool,
);

Map<String, dynamic> _$CountryToJson(_Country instance) => <String, dynamic>{
  'code': instance.code,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'requiresGovernorate': instance.requiresGovernorate,
};

_EducationSystemRef _$EducationSystemRefFromJson(Map<String, dynamic> json) =>
    _EducationSystemRef(
      code: json['code'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$EducationSystemRefToJson(_EducationSystemRef instance) =>
    <String, dynamic>{
      'code': instance.code,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'status': instance.status,
    };

_SchoolStageRef _$SchoolStageRefFromJson(Map<String, dynamic> json) =>
    _SchoolStageRef(
      stage: json['stage'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$SchoolStageRefToJson(_SchoolStageRef instance) =>
    <String, dynamic>{'stage': instance.stage, 'status': instance.status};

_UniversityRef _$UniversityRefFromJson(Map<String, dynamic> json) =>
    _UniversityRef(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      faculties: (json['faculties'] as List<dynamic>)
          .map((e) => FacultyRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UniversityRefToJson(_UniversityRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'faculties': instance.faculties,
    };

_FacultyRef _$FacultyRefFromJson(Map<String, dynamic> json) => _FacultyRef(
  id: json['id'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  years: (json['years'] as List<dynamic>)
      .map((e) => StudyYearRef.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FacultyRefToJson(_FacultyRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'years': instance.years,
    };

_StudyYearRef _$StudyYearRefFromJson(Map<String, dynamic> json) =>
    _StudyYearRef(
      id: json['id'] as String,
      yearNumber: (json['yearNumber'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$StudyYearRefToJson(_StudyYearRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'yearNumber': instance.yearNumber,
      'status': instance.status,
    };

_Avatar _$AvatarFromJson(Map<String, dynamic> json) =>
    _Avatar(id: json['id'] as String, url: json['url'] as String);

Map<String, dynamic> _$AvatarToJson(_Avatar instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
};

_CursorPage<T> _$CursorPageFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _CursorPage<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  nextCursor: json['nextCursor'] as String?,
  hasMore: json['hasMore'] as bool,
);

Map<String, dynamic> _$CursorPageToJson<T>(
  _CursorPage<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'nextCursor': instance.nextCursor,
  'hasMore': instance.hasMore,
};
