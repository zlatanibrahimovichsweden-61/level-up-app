import 'package:freezed_annotation/freezed_annotation.dart';

import '../../profile/models/student_profile.dart' show Track;

part 'mistakes_tree.freezed.dart';
part 'mistakes_tree.g.dart';

/// `GET /me/mistakes/subjects/{subjectId}` — the contract's `oneOf`, sealed.
///
/// The spec discriminates on `track` (`openapi.yaml:977-986`):
/// - `school` → [SchoolMistakesTree]: units → chapters → lessons;
/// - `university` → [UniversityMistakesTree]: a FLAT lecture list.
///
/// Sealing the two shapes turns every branch into a compiler-checked `switch`,
/// so a third track could not appear in the contract without this app failing
/// to build — the failure mode we want, rather than a screen that silently
/// renders nothing. Same pattern as `SubjectTree`.
///
/// ---
///
/// **These are deliberately NOT `SchoolSubjectTree` / `UniversitySubjectTree`,
/// and must never be modelled as them.** The contract says so in prose
/// (`:2196-2198`): the catalog tree is the whole catalogue with an
/// answered/total counter; this one is only the branches the student currently
/// has mistakes in. Concretely:
///
/// - there is **no `questionCounter`** anywhere in this tree;
/// - **every** level carries a `mistakeCount`, including units and chapters,
///   which the catalog tree gives no counter of any kind;
/// - [UniversityMistakesTree] carries **no `quizTypes`** — "a mistakes tree is
///   a history view, not a quiz-build tree" (`:2239-2241`). Do not reuse
///   `QuizTypeTabs` against it.
///
/// ---
///
/// 🔴 **The tree is PRUNED and SUMMED** (`:953-957`). A lesson or lecture
/// appears only when its own count is greater than zero; a chapter only when it
/// has such a lesson; a unit only when it has such a chapter. Every parent's
/// count is the SUM of its descendants'.
///
/// Two consequences the UI depends on:
/// 1. **There is no dead branch to tap into.** Every row the server sends leads
///    somewhere. The client needs no filtering and no empty-child guard.
/// 2. **The client performs NO arithmetic.** The server has already summed.
///    Summing children to "check" a parent is the client-side math the contract
///    forbids everywhere else too.
///
/// **An empty tree is a NORMAL response**, not an error and not a `403`: an
/// in-scope subject the student has nothing outstanding in returns `200` with
/// `mistakeCount: 0` and an empty `units`/`lectures` (`:960-964`). A subject
/// OUTSIDE the caller's scope is `403 insufficient_scope` instead — different
/// state, and both are reachable with an empty history. **Branch on the status,
/// never on emptiness.**
sealed class MistakesTree {
  /// The `oneOf` discriminator, exactly as the server sent it.
  Track get track;

  /// Sum over the whole subject. `0` exactly when the child list is empty.
  int get mistakeCount;
}

/// The SCHOOL branch — three levels deep.
@freezed
abstract class SchoolMistakesTree
    with _$SchoolMistakesTree
    implements MistakesTree {
  const factory SchoolMistakesTree({
    /// Always [Track.school] here.
    required Track track,

    /// Sum over the whole subject; `minimum: 0`, and `0` exactly when [units]
    /// is empty.
    required int mistakeCount,

    /// Only units containing at least one mistake. **May be EMPTY — that is a
    /// normal response**, not an error.
    required List<MistakesUnit> units,
  }) = _SchoolMistakesTree;

  factory SchoolMistakesTree.fromJson(Map<String, dynamic> json) =>
      _$SchoolMistakesTreeFromJson(json);
}

/// School content level 1. Glossary: Subject → **Unit** → Chapter → Lesson.
@freezed
abstract class MistakesUnit with _$MistakesUnit {
  const factory MistakesUnit({
    required String id,
    required String name,

    /// Sum over this unit's chapters — server-computed, `minimum: 1`.
    required int mistakeCount,
    required List<MistakesChapter> chapters,
  }) = _MistakesUnit;

  factory MistakesUnit.fromJson(Map<String, dynamic> json) =>
      _$MistakesUnitFromJson(json);
}

/// School content level 2.
@freezed
abstract class MistakesChapter with _$MistakesChapter {
  const factory MistakesChapter({
    required String id,
    required String name,

    /// Sum over this chapter's lessons — server-computed, `minimum: 1`.
    required int mistakeCount,
    required List<MistakesLesson> lessons,
  }) = _MistakesChapter;

  factory MistakesChapter.fromJson(Map<String, dynamic> json) =>
      _$MistakesChapterFromJson(json);
}

/// School content level 3 — the leaf.
///
/// `minimum: 1`: a lesson with no current mistakes is pruned out rather than
/// sent as zero.
@freezed
abstract class MistakesLesson with _$MistakesLesson {
  const factory MistakesLesson({
    required String id,
    required String name,
    required int mistakeCount,
  }) = _MistakesLesson;

  factory MistakesLesson.fromJson(Map<String, dynamic> json) =>
      _$MistakesLessonFromJson(json);
}

/// The UNIVERSITY branch — one level deep.
///
/// Note the absence of `quizTypes`, which `UniversitySubjectTree` does carry:
/// this is a history view, not a quiz-build tree (`:2239-2241`).
///
/// **University counts inherit the release gate** (adr-135, `:967-970`): when an
/// admin un-releases a term for the caller's cohort, its subjects leave scope
/// and their mistakes stop being counted — the node disappears under pruning and
/// this endpoint starts answering `403 insufficient_scope` for that subject.
/// Re-releasing restores everything unchanged. There is **no release state on
/// the wire and no way to distinguish the cause** (adr-038 §3), so the client
/// must not try to explain it. School content is never release-gated (adr-073).
@freezed
abstract class UniversityMistakesTree
    with _$UniversityMistakesTree
    implements MistakesTree {
  const factory UniversityMistakesTree({
    /// Always [Track.university] here.
    required Track track,

    /// Sum over the whole subject; `0` exactly when [lectures] is empty.
    required int mistakeCount,

    /// Only lectures containing at least one mistake. May be EMPTY.
    required List<MistakesLecture> lectures,
  }) = _UniversityMistakesTree;

  factory UniversityMistakesTree.fromJson(Map<String, dynamic> json) =>
      _$UniversityMistakesTreeFromJson(json);
}

/// University content leaf — the university equivalent of a school
/// [MistakesLesson].
@freezed
abstract class MistakesLecture with _$MistakesLecture {
  const factory MistakesLecture({
    required String id,
    required String name,
    required int mistakeCount,
  }) = _MistakesLecture;

  factory MistakesLecture.fromJson(Map<String, dynamic> json) =>
      _$MistakesLectureFromJson(json);
}
