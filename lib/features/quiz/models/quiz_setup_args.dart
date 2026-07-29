import 'package:flutter/foundation.dart';

/// What the Lessons screen hands to `/quiz/setup`.
///
/// The `lessonId` is what Day 6 will send as `POST /quizzes { lessonId, ... }`;
/// the `lessonName` is display copy the server already localized (adr-018), so
/// the setup screen can title itself without a second lookup.
///
/// Carried as go_router `extra` — typed, like `OtpArgs` and `RegistrationArgs`
/// before it — rather than as query parameters.
@immutable
class QuizSetupArgs {
  const QuizSetupArgs({required this.lessonId, required this.lessonName});

  final String lessonId;
  final String lessonName;

  @override
  bool operator ==(Object other) =>
      other is QuizSetupArgs &&
      other.lessonId == lessonId &&
      other.lessonName == lessonName;

  @override
  int get hashCode => Object.hash(lessonId, lessonName);
}
