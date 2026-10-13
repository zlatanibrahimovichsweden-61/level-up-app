import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_question.freezed.dart';
part 'favorite_question.g.dart';

/// One row of `GET /me/favorites` (`listFavorites`, `openapi.yaml:2131`), the
/// inline item schema required `[questionId, text, subjectName, favoritedAt]`.
///
/// The contract names no component schema for it, so the name here is the
/// glossary's: a favourited Question.
///
/// The page is exactly the pool a `mode: favorites` quiz draws from. It never
/// carries an option or a correct answer, and it has no `isFavorite` flag -
/// every row IS a favourite.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
@freezed
abstract class FavoriteQuestion with _$FavoriteQuestion {
  const factory FavoriteQuestion({
    /// `Uuid`. The only value the app sends back: `PUT`/`DELETE
    /// /questions/{questionId}/favorite`.
    required String questionId,

    /// The question stem. The contract does not repeat `QuizQuestion.text`'s
    /// "only `<u>...</u>` markup" note for this field, so do not assume the
    /// absence of markup: render it through whatever renders a question stem.
    required String text,

    /// Server copy in the content language (adr-018), rendered verbatim.
    required String subjectName,

    /// When the student favourited it, as the server sent it (normally UTC).
    /// Call `.toLocal()` before formatting it for display.
    required DateTime favoritedAt,
  }) = _FavoriteQuestion;

  factory FavoriteQuestion.fromJson(Map<String, dynamic> json) =>
      _$FavoriteQuestionFromJson(json);
}
