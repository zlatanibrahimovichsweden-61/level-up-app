import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_option.freezed.dart';
part 'quiz_option.g.dart';

/// One selectable answer — the inline object in `QuizQuestion.options`
/// (`openapi.yaml:1418`–`1423`), required `[id, text]`.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// **There is deliberately no `correct` field.** The contract never ships
/// correctness with a question — "correct answers never ship with questions
/// (content protection — the bank is the product)". Correctness arrives once,
/// in `AnswerResult.correctOptionId`, after the student has committed. Adding a
/// speculative `bool? correct` here would invite a client-graded form, which is
/// exactly the design the per-question submit model exists to prevent.
///
/// The A/B/C/D letter badge is NOT a field either: it is positional, derived
/// from the option's index at render time, so it stays correct in RTL without
/// the server having to care about presentation.
@freezed
abstract class QuizOption with _$QuizOption {
  const factory QuizOption({required String id, required String text}) =
      _QuizOption;

  factory QuizOption.fromJson(Map<String, dynamic> json) =>
      _$QuizOptionFromJson(json);
}
