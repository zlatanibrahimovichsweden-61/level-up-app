// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizSummary _$QuizSummaryFromJson(Map<String, dynamic> json) => _QuizSummary(
  quizId: json['quizId'] as String,
  score: (json['score'] as num).toInt(),
  totalQuestions: (json['totalQuestions'] as num).toInt(),
  answeredCount: (json['answeredCount'] as num).toInt(),
  pointsAwarded: (json['pointsAwarded'] as num).toInt(),
  leveledUp: json['leveledUp'] as bool,
  newBadge: json['newBadge'] as bool,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuizSummaryQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizSummaryToJson(_QuizSummary instance) =>
    <String, dynamic>{
      'quizId': instance.quizId,
      'score': instance.score,
      'totalQuestions': instance.totalQuestions,
      'answeredCount': instance.answeredCount,
      'pointsAwarded': instance.pointsAwarded,
      'leveledUp': instance.leveledUp,
      'newBadge': instance.newBadge,
      'questions': instance.questions,
    };

_QuizSummaryQuestion _$QuizSummaryQuestionFromJson(Map<String, dynamic> json) =>
    _QuizSummaryQuestion(
      questionId: json['questionId'] as String,
      answered: json['answered'] as bool,
      correct: json['correct'] as bool?,
    );

Map<String, dynamic> _$QuizSummaryQuestionToJson(
  _QuizSummaryQuestion instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'answered': instance.answered,
  'correct': instance.correct,
};
