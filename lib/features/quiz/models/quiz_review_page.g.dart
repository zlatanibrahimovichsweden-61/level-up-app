// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_review_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizReview _$QuizReviewFromJson(Map<String, dynamic> json) => _QuizReview(
  id: json['id'] as String,
  subjectName: json['subjectName'] as String?,
  scopeName: json['scopeName'] as String,
  score: (json['score'] as num).toInt(),
  totalQuestions: (json['totalQuestions'] as num).toInt(),
  finishedAt: DateTime.parse(json['finishedAt'] as String),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuizReviewQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizReviewToJson(_QuizReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subjectName': instance.subjectName,
      'scopeName': instance.scopeName,
      'score': instance.score,
      'totalQuestions': instance.totalQuestions,
      'finishedAt': instance.finishedAt.toIso8601String(),
      'questions': instance.questions,
    };
