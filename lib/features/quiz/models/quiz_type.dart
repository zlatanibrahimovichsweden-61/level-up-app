import '../../../l10n/app_localizations.dart';

/// The university quiz types — contract enum
/// `[normal, midTermRevision, finalRevision, practicalRevision]`.
///
/// It appears twice in `contract/openapi.yaml`: `UniversitySubjectTree.quizTypes`
/// (what this subject offers) and `POST /quizzes.quizType` (what the student
/// picked). School has no equivalent — a school quiz is scoped by `lessonId`
/// alone.
///
/// A generated enum is correct here for the same reason as `Track`: the contract
/// does NOT mark this set extensible — contrast `EducationSystem` and
/// `EntitlementType`, which carry an explicit "clients must tolerate unknown
/// values". A value outside these four is contract drift and must throw, not be
/// silently dropped from a student's tab row.
///
/// Wire names are already camelCase, so json_serializable maps the member names
/// directly — no `@JsonValue` bridge, per the project's no-key-bridge rule.
///
/// **There is deliberately no `flashcard` member.** The Lectures frame draws a
/// "Flashcard" tab, but flashcards are a separate `flashcardSubscription`
/// entitlement with no M1 content endpoint, and the contract's `quizTypes` enum
/// does not list them. Adding one here would invent a quiz type the server has
/// never heard of. See docs/DESIGN_ISSUES.md #18.
enum QuizType { normal, midTermRevision, finalRevision, practicalRevision }

/// The one place the four wire values become UI copy — exhaustive, so a new
/// contract value cannot be added without the compiler demanding a label.
///
/// Unlike a subject or lecture `name`, these are NOT server copy: the contract
/// sends bare enum values, so the app owns the translation.
extension QuizTypeLabel on QuizType {
  String label(AppLocalizations l10n) => switch (this) {
        QuizType.normal => l10n.quizTypeNormal,
        QuizType.midTermRevision => l10n.quizTypeMidterm,
        QuizType.finalRevision => l10n.quizTypeFinal,
        QuizType.practicalRevision => l10n.quizTypePractice,
      };
}
