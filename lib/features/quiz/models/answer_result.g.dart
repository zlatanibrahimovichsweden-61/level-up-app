// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnswerResult _$AnswerResultFromJson(Map<String, dynamic> json) =>
    _AnswerResult(
      correct: json['correct'] as bool,
      correctOptionId: json['correctOptionId'] as String,
      pointsDelta: (json['pointsDelta'] as num).toInt(),
      explanationAvailable: json['explanationAvailable'] as bool,
    );

Map<String, dynamic> _$AnswerResultToJson(_AnswerResult instance) =>
    <String, dynamic>{
      'correct': instance.correct,
      'correctOptionId': instance.correctOptionId,
      'pointsDelta': instance.pointsDelta,
      'explanationAvailable': instance.explanationAvailable,
    };
