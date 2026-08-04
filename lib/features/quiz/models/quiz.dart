import 'package:freezed_annotation/freezed_annotation.dart';

import 'quiz_mode.dart';
import 'quiz_question.dart';
import 'quiz_type.dart';

part 'quiz.freezed.dart';
part 'quiz.g.dart';

/// Contract `Quiz` (`openapi.yaml:1426`) — the `201` body of `POST /quizzes`,
/// required `[id, mode, scopeName, questions, createdAt]`.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// This is the WHOLE session payload: every question arrives up front, in
/// serving order, without correct answers. There is no per-question fetch. The
/// quiz screen therefore never loads mid-session, and `QuizBloc` starts from a
/// value it already has rather than from a request.
@freezed
abstract class Quiz with _$Quiz {
  const factory Quiz({
    required String id,
    required QuizMode mode,

    /// University only — the contract types it `[string, "null"]` and school
    /// quizzes carry no type at all.
    QuizType? quizType,

    /// The contract's own word for it: "Lesson/lecture display name". Server
    /// copy, already in the content language (adr-018), so it is rendered
    /// verbatim and never looked up in the ARB.
    ///
    /// **This is the only scope identity the quiz endpoints return.** Neither
    /// `Quiz` nor `QuizSummary` carries a subject name, which is why the setup
    /// and result screens are titled by scope alone — see docs/DESIGN_ISSUES.md.
    required String scopeName,

    /// In serving order. May legitimately be SHORTER than the requested length:
    /// the contract only promises `not_enough_questions` when the pool is
    /// smaller than `length` in normal mode, and the later modes may return
    /// fewer by design. Nothing may assume `questions.length == length`.
    required List<QuizQuestion> questions,
    required DateTime createdAt,
  }) = _Quiz;

  const Quiz._();

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  /// The denominator of the `n/total` counter and the progress bar.
  ///
  /// Read from the questions actually delivered, NOT from the length the
  /// student asked for — a short pool must show `1/7`, not `1/10`.
  int get questionCount => questions.length;
}
