// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mistakes_subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MistakesSubject _$MistakesSubjectFromJson(Map<String, dynamic> json) =>
    _MistakesSubject(
      id: json['id'] as String,
      name: json['name'] as String,
      termId: json['termId'] as String?,
      termNumber: (json['termNumber'] as num?)?.toInt(),
      mistakeCount: (json['mistakeCount'] as num).toInt(),
    );

Map<String, dynamic> _$MistakesSubjectToJson(_MistakesSubject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'termId': instance.termId,
      'termNumber': instance.termNumber,
      'mistakeCount': instance.mistakeCount,
    };
