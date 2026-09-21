import 'package:freezed_annotation/freezed_annotation.dart';

import '../../profile/models/student_profile.dart' show Track;
import '../../quiz/models/quiz_type.dart';
import 'subject.dart';

part 'subject_tree.freezed.dart';
part 'subject_tree.g.dart';

/// `GET /catalog/subjects/{subjectId}/tree` — the contract's `oneOf`, sealed.
///
/// The spec discriminates on `track`:
/// - `school` → [SchoolSubjectTree]: units → chapters → lessons;
/// - `university` → [UniversitySubjectTree]: quiz types + a FLAT lecture list.
///
/// Sealing the two shapes turns every branch into a compiler-checked `switch`,
/// so a third track could not appear in the contract without this app failing to
/// build — which is the failure mode we want, rather than a screen that silently
/// renders nothing. The runtime type is the discriminator; [track] carries the
/// value that was actually parsed so it stays inspectable and testable.
///
/// **One call, whole tree.** This endpoint returns the entire structure for a
/// subject, so the app fetches it ONCE per subject and drives every level below
/// from the cached object. There is deliberately no per-level endpoint and no
/// per-level fetch.
sealed class SubjectTree {
  /// The `oneOf` discriminator, exactly as the server sent it.
  Track get track;
}

/// The SCHOOL branch — three levels deep.
///
/// Note vs university: only [Lesson] carries a `questionCounter`. Units and
/// chapters have no counter of any kind, which is why their rows draw no
/// progress bar (docs/DESIGN_ISSUES.md #16).
@freezed
abstract class SchoolSubjectTree
    with _$SchoolSubjectTree
    implements SubjectTree {
  const factory SchoolSubjectTree({
    /// Always [Track.school] here.
    required Track track,
    required List<Unit> units,
  }) = _SchoolSubjectTree;

  factory SchoolSubjectTree.fromJson(Map<String, dynamic> json) =>
      _$SchoolSubjectTreeFromJson(json);
}

/// School content level 1. Glossary: Subject → **Unit** → Chapter → Lesson.
@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String name,
    required List<Chapter> chapters,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}

/// School content level 2.
@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String name,
    required List<Lesson> lessons,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

/// School content level 3 — the leaf a quiz is built from.
///
/// [questionCounter] is display-only (see [QuestionCounter]); it must never
/// decide whether this lesson can be opened.
@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String name,
    required QuestionCounter questionCounter,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

/// The UNIVERSITY branch — one level deep, plus the quiz types this subject
/// offers.
///
/// [quizTypes] is server-supplied per subject and drives the Lectures screen's
/// tab row: a subject with no practical component simply does not list
/// `practicalRevision`, and the tab must not appear. Never hardcode the tabs.
@freezed
abstract class UniversitySubjectTree
    with _$UniversitySubjectTree
    implements SubjectTree {
  const factory UniversitySubjectTree({
    /// Always [Track.university] here.
    required Track track,
    required List<QuizType> quizTypes,
    required List<Lecture> lectures,
  }) = _UniversitySubjectTree;

  factory UniversitySubjectTree.fromJson(Map<String, dynamic> json) =>
      _$UniversitySubjectTreeFromJson(json);
}

/// University content leaf — the university equivalent of a school [Lesson],
/// and what `POST /quizzes` takes as `lectureId`.
///
/// Unlike school units/chapters, a lecture DOES carry a `questionCounter`, so
/// its row has a real source for the progress bar. Same rule as everywhere else:
/// display-only, it never locks a retake.
@freezed
abstract class Lecture with _$Lecture {
  const factory Lecture({
    required String id,
    required String name,
    required QuestionCounter questionCounter,

    /// Whether this lecture has at least one active flashcard — the signal that
    /// decides whether to draw the Flashcards affordance.
    ///
    /// **`required` on the wire** (`openapi.yaml:2569`), so it is `required`
    /// here with no default. A `?? false` would have been the wrong kind of
    /// tolerant: it would render "no flashcards" for a lecture that has them
    /// and hide a whole surface without ever failing.
    ///
    /// **Content presence, never subscription state.** It is `true` for a free
    /// student too; tapping through then meets the weekly preview or
    /// `403 flashcard_subscription_required` on `getFlashcardsForLecture`. So
    /// it must never be read as an entitlement check.
    ///
    /// University track only. It is NOT on `SchoolSubjectTree` and the contract
    /// says it never will be — flashcards are a university-track surface, and a
    /// school tree carries no signal that they exist.
    required bool hasFlashcards,
  }) = _Lecture;

  factory Lecture.fromJson(Map<String, dynamic> json) =>
      _$LectureFromJson(json);
}
