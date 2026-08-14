import 'package:flutter/foundation.dart';

import 'quiz_type.dart';

/// What the Learn stack hands to `/quiz/setup`.
///
/// The two constructors mirror `POST /quizzes` exactly: `mode: normal` takes a
/// `lessonId` (school) OR a `lectureId` + `quizType` (university) — never both.
/// Making them separate constructors means an impossible combination cannot be
/// built, rather than being validated later.
///
/// [scopeName] is the contract's own word for it (`Quiz.scopeName`: "Lesson /
/// lecture display name"). It is server copy, already localized (adr-018), so
/// the setup screen can title itself without a second lookup.
///
/// Carried as go_router `extra` — typed, like `OtpArgs` and `RegistrationArgs`
/// before it — rather than as query parameters.
@immutable
class QuizSetupArgs {
  /// School: the quiz is scoped by lesson, and there is no quiz type.
  const QuizSetupArgs.lesson({
    required String this.lessonId,
    required this.scopeName,
  }) : lectureId = null,
       quizType = null;

  /// University: the quiz is scoped by lecture, plus the type selected on the
  /// Lectures screen's tab row.
  const QuizSetupArgs.lecture({
    required String this.lectureId,
    required this.scopeName,
    required QuizType this.quizType,
  }) : lessonId = null;

  /// Set for school, null for university.
  final String? lessonId;

  /// Set for university, null for school.
  final String? lectureId;

  /// University only — the contract makes it meaningless for school.
  final QuizType? quizType;

  final String scopeName;

  @override
  bool operator ==(Object other) =>
      other is QuizSetupArgs &&
      other.lessonId == lessonId &&
      other.lectureId == lectureId &&
      other.quizType == quizType &&
      other.scopeName == scopeName;

  @override
  int get hashCode => Object.hash(lessonId, lectureId, quizType, scopeName);
}
