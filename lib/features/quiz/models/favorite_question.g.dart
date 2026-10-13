// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteQuestion _$FavoriteQuestionFromJson(Map<String, dynamic> json) =>
    _FavoriteQuestion(
      questionId: json['questionId'] as String,
      text: json['text'] as String,
      subjectName: json['subjectName'] as String,
      favoritedAt: DateTime.parse(json['favoritedAt'] as String),
    );

Map<String, dynamic> _$FavoriteQuestionToJson(_FavoriteQuestion instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'text': instance.text,
      'subjectName': instance.subjectName,
      'favoritedAt': instance.favoritedAt.toIso8601String(),
    };
