// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizHistoryItem _$QuizHistoryItemFromJson(Map<String, dynamic> json) =>
    _QuizHistoryItem(
      id: json['id'] as String,
      subjectName: json['subjectName'] as String,
      scopeName: json['scopeName'] as String,
      mode: $enumDecode(_$QuizModeEnumMap, json['mode']),
      score: (json['score'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
    );

Map<String, dynamic> _$QuizHistoryItemToJson(_QuizHistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subjectName': instance.subjectName,
      'scopeName': instance.scopeName,
      'mode': _$QuizModeEnumMap[instance.mode]!,
      'score': instance.score,
      'totalQuestions': instance.totalQuestions,
      'finishedAt': instance.finishedAt.toIso8601String(),
    };

const _$QuizModeEnumMap = {
  QuizMode.normal: 'normal',
  QuizMode.retakeWrong: 'retakeWrong',
  QuizMode.favorites: 'favorites',
};
