import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard.freezed.dart';
part 'flashcard.g.dart';

/// The two self-grades a student can record on a card.
///
/// The contract calls this **a CLOSED set, unlike `EntitlementType`**
/// (`openapi.yaml:2469`–`2474`), so a generated enum is correct here and an
/// unknown value must throw rather than degrade — the contract's own reason is
/// that a third value "would render as neither and decides product behaviour
/// nobody has specified". Same rule as [Track], opposite of `EntitlementType`.
///
/// 🔴 **The server keeps the LATEST value and nothing else.** No history, no
/// score, no streak, no review schedule — a second grade replaces the first.
/// The value exists so a client can offer a "show me my `again` cards" filter
/// that survives a reinstall or a second device. Do NOT build spaced repetition
/// on it; none is specified anywhere.
enum FlashcardSelfGrade { gotIt, again }

/// One flashcard as the study surface serves it (spec-028,
/// `openapi.yaml:2476`).
///
/// Contract keys are already camelCase, so no `@JsonKey(name:)` bridge is
/// needed — the same reason `MistakesSubject` has none.
@freezed
abstract class FlashcardCard with _$FlashcardCard {
  const factory FlashcardCard({
    required String id,

    /// The prompt side.
    required String front,

    /// The answer side. **Free multi-line text, and it may hold several
    /// answers** — the contract says to render it as a block, not as a single
    /// label.
    required String back,

    /// Absolute, content-addressed CDN URL for the card's image — or `null`.
    ///
    /// Contract-`required` but nullable, and **`null` is the answer in every
    /// environment today**: no card-image CDN origin is provisioned anywhere.
    /// It is not an error and not a missing image. When a value does appear it
    /// is immutable — a corrected image produces a DIFFERENT URL, never new
    /// bytes at the same one — so it is safe to cache forever.
    required String? imageUrl,

    /// YOUR latest grade for this card, or `null` if you have never graded it.
    ///
    /// A property of the READER, not of the card: two students holding the same
    /// page see different values, which is why it can never be cached across
    /// accounts.
    required FlashcardSelfGrade? selfGrade,
  }) = _FlashcardCard;

  factory FlashcardCard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardCardFromJson(json);
}
