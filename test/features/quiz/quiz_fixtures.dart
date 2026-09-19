/// Shared quiz fixtures, shaped from `contract/openapi.yaml` (pinned `184d6ec`,
/// v3.0.0-m1): `Quiz`, `QuizQuestion`, `AnswerResult`, `QuizSummary` (eight
/// required fields since adr-102 — no `totalPoints`/`level`). Not hand-invented
/// — every key below appears in the schema, and every required key is present.
///
/// Used by the model, repository, bloc and screen tests so they all agree on
/// one payload.
library;

import 'package:level_up_app/features/quiz/bloc/quiz_state.dart';
import 'package:level_up_app/features/quiz/models/answer_result.dart';
import 'package:level_up_app/features/quiz/models/quiz.dart';
import 'package:level_up_app/features/quiz/models/quiz_review_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_summary.dart';

/// One question with four options. [imageUrl] is null unless asked for — most
/// questions have no photo, and the "with photo" variant is the exception.
Map<String, dynamic> questionJson(
  String id, {
  int order = 1,
  String? imageUrl,
  bool isFavorite = false,
  int optionCount = 4,
}) => <String, dynamic>{
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
}) => <String, dynamic>{
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
}) => <String, dynamic>{
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
}) => AnswerResult.fromJson(
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
  bool leveledUp = false,
  bool newBadge = false,
}) => <String, dynamic>{
  'quizId': 'quiz-1',
  'score': score,
  'totalQuestions': totalQuestions,
  'answeredCount': answeredCount,
  'pointsAwarded': pointsAwarded,
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
  bool leveledUp = false,
  bool newBadge = false,
}) => QuizSummary.fromJson(
  quizSummaryJson(
    score: score,
    totalQuestions: totalQuestions,
    answeredCount: answeredCount,
    pointsAwarded: pointsAwarded,
    leveledUp: leveledUp,
    newBadge: newBadge,
  ),
);

/// The review payload matching [quizSummary]'s default shape: 10 questions,
/// q1–q8 committed, q1–q5 correct.
///
/// Deliberately the same numbers, so one fixture exercises all three row states
/// at once — 5 correct · 3 wrong (q6–q8) · 2 skipped (q9–q10, absent from
/// `grades` entirely). A question missing from the map is the skipped state;
/// there is no "unanswered" sentinel.
QuizReviewArgs quizReviewArgs({
  int totalQuestions = 10,
  int answeredCount = 8,
  int score = 5,
  bool explanationAvailable = true,
}) => QuizReviewArgs(
  questions: quiz(questionCount: totalQuestions).questions,
  grades: <String, AnswerResult>{
    for (var i = 1; i <= answeredCount; i++)
      'q$i': answerResult(
        correct: i <= score,
        correctOptionId: 'q$i-opt0',
        explanationAvailable: explanationAvailable,
      ),
  },
);

/// A session that has not been answered yet — enough to seed a terminal
/// [QuizCompleted], which retains one so the quiz can be reviewed.
QuizSession quizSession({int questionCount = 3}) =>
    QuizSession.start(quiz(questionCount: questionCount));
