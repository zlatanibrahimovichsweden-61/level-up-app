import 'package:freezed_annotation/freezed_annotation.dart';

import 'quiz_option.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

/// Contract `QuizQuestion` (`openapi.yaml:1406`), required
/// `[id, order, text, options, isFavorite]`.
///
/// The schema's own description: *"NO correct answer here — grading is
/// server-side on submit."* Everything about the taking screen follows from
/// that one sentence.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,

    /// Serving order, server-assigned. The app renders `questions` in the order
    /// it received them — this is carried for fidelity and for the recap rows,
    /// not used to re-sort. Re-sorting client-side would mean deciding the
    /// server got the order wrong.
    required int order,

    /// Plain text; the contract allows `<u>…</u>` and nothing else.
    required String text,

    /// Full image, DO Spaces CDN, WebP. Null on most questions — when present,
    /// the taking screen renders the "with photo" variant (`159:1852`).
    String? imageUrl,

    /// Contract-optional companion to [imageUrl]. Parsed because the contract
    /// defines it; the taking screen shows one question at a time at full
    /// width, so there is no list context that would want the thumbnail.
    String? thumbnailUrl,

    /// `minItems: 2` — NOT fixed at four. The design draws four buttons, but a
    /// two- or three-option question is contract-legal, so the renderer builds
    /// from this list's length rather than from a hardcoded four.
    required List<QuizOption> options,

    /// **Parsed, never rendered.** It is a required field, so it must be on the
    /// model or nothing parses. But all three favourite endpoints
    /// (`PUT`/`DELETE /questions/{questionId}/favorite`, `GET /me/favorites`)
    /// are `x-stability: draft`, so there is no write path to put behind the
    /// bookmark icon the header draws (node `295:3139`).
    ///
    /// Landing the field now means the model, the JSON and the tests do not
    /// move when those endpoints are promoted — that work becomes a widget plus
    /// two repository methods. See docs/seif_fight.md S11.
    required bool isFavorite,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
