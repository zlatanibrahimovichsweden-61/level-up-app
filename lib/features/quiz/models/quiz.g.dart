// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quiz _$QuizFromJson(Map<String, dynamic> json) => _Quiz(
  id: json['id'] as String,
  mode: $enumDecode(_$QuizModeEnumMap, json['mode']),
  quizType: $enumDecodeNullable(_$QuizTypeEnumMap, json['quizType']),
  scopeName: json['scopeName'] as String,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$QuizToJson(_Quiz instance) => <String, dynamic>{
  'id': instance.id,
  'mode': _$QuizModeEnumMap[instance.mode]!,
  'quizType': _$QuizTypeEnumMap[instance.quizType],
  'scopeName': instance.scopeName,
  'questions': instance.questions,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$QuizModeEnumMap = {
  QuizMode.normal: 'normal',
  QuizMode.retakeWrong: 'retakeWrong',
  QuizMode.favorites: 'favorites',
};

const _$QuizTypeEnumMap = {
  QuizType.normal: 'normal',
  QuizType.midTermRevision: 'midTermRevision',
  QuizType.finalRevision: 'finalRevision',
  QuizType.practicalRevision: 'practicalRevision',
};
