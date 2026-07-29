import 'package:freezed_annotation/freezed_annotation.dart';

import '../../profile/models/student_profile.dart' show Track;
import 'subject.dart';

part 'subject_tree.freezed.dart';
part 'subject_tree.g.dart';

/// `GET /catalog/subjects/{subjectId}/tree` — the SCHOOL branch.
///
/// The contract returns a `oneOf` discriminated on `track`:
/// - `school` → this file: units → chapters → lessons;
/// - `university` → `UniversitySubjectTree { quizTypes, lectures[] }`.
///
/// TODO(university): model `UniversitySubjectTree` when the university Learn
/// tab is built. Until then [CatalogRepository.getSubjectTree] refuses a
/// non-school payload with a typed error rather than half-parsing it — see the
/// guard there. School is the only track this round, by scope.
///
/// **One call, whole tree.** This endpoint returns the entire nested structure,
/// so the app fetches it ONCE per subject and drives Units → Chapters → Lessons
/// from the cached object. There is deliberately no per-level endpoint and no
/// per-level fetch.
@freezed
abstract class SchoolSubjectTree with _$SchoolSubjectTree {
  const factory SchoolSubjectTree({
    /// Always [Track.school] here — it is the `oneOf` discriminator, kept in the
    /// model so the value that was actually parsed is inspectable.
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
