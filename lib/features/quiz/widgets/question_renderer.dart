import 'package:flutter/widgets.dart';

import '../models/answer_result.dart';
import '../models/quiz_question.dart';

/// **The seam.**
///
/// `QuizScreen` owns the session shell — header, progress bar, `n/total`
/// counter, Confirm/Next, the AI panel, screen protection, Bloc wiring. A
/// [QuestionRenderer] owns the one part that varies: how a question is
/// presented and what choosing an answer looks like.
///
/// Today there is exactly one implementation, [McqRenderer]. The flashcard
/// frame (`225:5582`) shares the entire shell and differs only here — one flip
/// card instead of four option buttons — so putting the boundary in now is the
/// difference between adding flashcards later as a new file and reopening the
/// screen, the Bloc and the tests.
///
/// **No `FlashcardRenderer` stub exists, and none should be written yet.** The
/// contract has no flashcard content endpoint, no `flashcard` quiz type and no
/// flashcard question shape — only an entitlement a student can buy and then
/// use on nothing (docs/seif_fight.md S6). The seam is the deliverable; the
/// second renderer waits for a contract to build against.
///
/// `QuizBloc` stays renderer-agnostic: it knows a question has options and that
/// one of them gets committed, and nothing about badges or cards.
abstract class QuestionRenderer {
  const QuestionRenderer();

  Widget build(BuildContext context, QuestionPresentation presentation);
}

/// Everything a renderer needs, and nothing about the session around it.
///
/// Note there is no `quizId`, no index and no total — a renderer that could see
/// those would start drawing chrome, which is the shell's job.
@immutable
class QuestionPresentation {
  const QuestionPresentation({
    required this.question,
    required this.position,
    required this.selectedOptionId,
    required this.committedOptionId,
    required this.grade,
    required this.locked,
    required this.onSelect,
  });

  final QuizQuestion question;

  /// 1-based, for the `QUESTION n` label.
  final int position;

  /// The UNCOMMITTED choice. Nothing has been sent while this is set — the
  /// renderer reports a selection, the shell decides when to commit it.
  final String? selectedOptionId;

  /// What was actually sent, once it has been. Kept separate from [grade]
  /// because `AnswerResult` reports the CORRECT option, not the chosen one, and
  /// a graded question has to mark both.
  final String? committedOptionId;

  /// Null until the server has graded this question. Non-null means read-only:
  /// grading is committed server-side and can never be revised.
  final AnswerResult? grade;

  /// A submit is in flight — every input is inert until it lands.
  final bool locked;

  final ValueChanged<String> onSelect;

  bool get isGraded => grade != null;

  /// Whether the renderer should accept input at all.
  bool get isInteractive => !isGraded && !locked;
}
