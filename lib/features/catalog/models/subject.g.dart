// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionCounter _$QuestionCounterFromJson(Map<String, dynamic> json) =>
    _QuestionCounter(
      answered: (json['answered'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionCounterToJson(_QuestionCounter instance) =>
    <String, dynamic>{'answered': instance.answered, 'total': instance.total};

_Subject _$SubjectFromJson(Map<String, dynamic> json) => _Subject(
  id: json['id'] as String,
  name: json['name'] as String,
  termId: json['termId'] as String?,
  termNumber: (json['termNumber'] as num?)?.toInt(),
  questionCounter: QuestionCounter.fromJson(
    json['questionCounter'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SubjectToJson(_Subject instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'termId': instance.termId,
  'termNumber': instance.termNumber,
  'questionCounter': instance.questionCounter,
};
