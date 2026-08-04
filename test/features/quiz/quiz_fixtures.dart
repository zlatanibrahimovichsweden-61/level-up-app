/// Shared quiz fixtures, shaped from `contract/openapi.yaml` (pinned 23f0535):
/// `Quiz` (:1426), `QuizQuestion` (:1406), `AnswerResult` (:1438),
/// `QuizSummary` (:1446). Not hand-invented — every key below appears in the
/// schema, and every required key is present.
///
/// Used by the model, repository, bloc and screen tests so they all agree on
/// one payload.
library;

import 'package:level_up_app/features/quiz/models/answer_result.dart';
import 'package:level_up_app/features/quiz/models/quiz.dart';
import 'package:level_up_app/features/quiz/models/quiz_summary.dart';

/// One question with four options. [imageUrl] is null unless asked for — most
/// questions have no photo, and the "with photo" variant is the exception.
Map<String, dynamic> questionJson(
  String id, {
  int order = 1,
  String? imageUrl,
  bool isFavorite = false,
  int optionCount = 4,
}) =>
    <String, dynamic>{
      'id': id,
      'order': order,
      'text': 'Question $id?',
      'imageUrl': imageUrl,
      'thumbnailUrl': null,
      'options': <dynamic>[
        for (var i = 0; i < optionCount; i++)
          <String, dynamic>{'id': '$id-opt$i', 'text': 'Option $i'},
      ],
      'isFavorite': isFavorite,
    };

/// A school quiz: `quizType` absent entirely, exactly as the contract types it
/// for a lesson-scoped quiz.
Map<String, dynamic> quizJson({
  int questionCount = 3,
  String mode = 'normal',
  String? quizType,
  String scopeName = 'Cell Structure',
}) =>
    <String, dynamic>{
      'id': 'quiz-1',
      'mode': mode,
      'quizType': ?quizType,
      'scopeName': scopeName,
      'questions': <dynamic>[
        for (var i = 1; i <= questionCount; i++) questionJson('q$i', order: i),
      ],
      'createdAt': '2026-07-30T09:00:00Z',
    };

Quiz quiz({int questionCount = 3, String? quizType}) =>
    Quiz.fromJson(quizJson(questionCount: questionCount, quizType: quizType));

/// Same thing under a name that does not collide with a local `quiz` variable —
/// the widget tests call their mock repository `quiz`.
Quiz quizFor({int questionCount = 3, String? quizType}) =>
    quiz(questionCount: questionCount, quizType: quizType);

Map<String, dynamic> answerResultJson({
  bool correct = true,
  String correctOptionId = 'q1-opt0',
  int pointsDelta = 1,
  bool explanationAvailable = true,
}) =>
    <String, dynamic>{
      'correct': correct,
      'correctOptionId': correctOptionId,
      'pointsDelta': pointsDelta,
      'explanationAvailable': explanationAvailable,
    };

AnswerResult answerResult({
  bool correct = true,
  String correctOptionId = 'q1-opt0',
  int pointsDelta = 1,
  bool explanationAvailable = true,
}) =>
    AnswerResult.fromJson(
      answerResultJson(
        correct: correct,
        correctOptionId: correctOptionId,
        pointsDelta: pointsDelta,
        explanationAvailable: explanationAvailable,
      ),
    );

/// The PARTIALLY-ANSWERED default: 10 questions, 8 answered, 5 correct.
///
/// Deliberate — it is the shape that catches the `totalQuestions - score` bug.
/// Correct 5 · Wrong 3 (8 − 5) · Skipped 2 (10 − 8). Computing wrong from
/// `totalQuestions` would report 5 and swallow the skipped pair.
Map<String, dynamic> quizSummaryJson({
  int score = 5,
  int totalQuestions = 10,
  int answeredCount = 8,
  int pointsAwarded = 5,
  int totalPoints = 1255,
  int level = 3,
  bool leveledUp = false,
  bool newBadge = false,
}) =>
    <String, dynamic>{
      'quizId': 'quiz-1',
      'score': score,
      'totalQuestions': totalQuestions,
      'answeredCount': answeredCount,
      'pointsAwarded': pointsAwarded,
      'totalPoints': totalPoints,
      'level': level,
      'leveledUp': leveledUp,
      'newBadge': newBadge,
      'questions': <dynamic>[
        for (var i = 1; i <= totalQuestions; i++)
          <String, dynamic>{
            'questionId': 'q$i',
            'answered': i <= answeredCount,
            // null when unanswered, per the contract.
            'correct': i <= answeredCount ? i <= score : null,
          },
      ],
    };

QuizSummary quizSummary({
  int score = 5,
  int totalQuestions = 10,
  int answeredCount = 8,
  int pointsAwarded = 5,
  int totalPoints = 1255,
  int level = 3,
  bool leveledUp = false,
  bool newBadge = false,
}) =>
    QuizSummary.fromJson(
      quizSummaryJson(
        score: score,
        totalQuestions: totalQuestions,
        answeredCount: answeredCount,
        pointsAwarded: pointsAwarded,
        totalPoints: totalPoints,
        level: level,
        leveledUp: leveledUp,
        newBadge: newBadge,
      ),
    );
