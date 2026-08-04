import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject.freezed.dart';
part 'subject.g.dart';

/// Catalog models for `GET /catalog/subjects`.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.

/// The contract's per-lesson/subject `answered / total` counter.
///
/// **DISPLAY ONLY.** The contract is explicit: it "never locks retakes". So
/// nothing in this app may use it to gate, disable, hide or reorder anything —
/// it is a number to render and a bar to fill, and that is all. A lesson with
/// `answered == total` is exactly as tappable as one at `0 / 0`.
@freezed
abstract class QuestionCounter with _$QuestionCounter {
  const factory QuestionCounter({
    /// Distinct questions this student has ever answered in scope.
    required int answered,
    required int total,
  }) = _QuestionCounter;

  const QuestionCounter._();

  factory QuestionCounter.fromJson(Map<String, dynamic> json) =>
      _$QuestionCounterFromJson(json);

  /// Progress as 0.0–1.0, for the bar only.
  ///
  /// The single piece of arithmetic allowed on this type. Clamped, and `total`
  /// of 0 yields 0 rather than NaN/∞ — a subject with no questions yet draws an
  /// empty bar instead of crashing the grid.
  double get fraction {
    if (total <= 0) return 0;
    return (answered / total).clamp(0, 1).toDouble();
  }
}

/// One row of `GET /catalog/subjects`.
///
/// The list is server-scoped from the authenticated student (school = education
/// system + stage) — the client sends NO scope parameters (adr-013) — and
/// [name] arrives already in the content language (adr-018), so it is rendered
/// verbatim and never looked up in the ARB.
@freezed
abstract class Subject with _$Subject {
  const factory Subject({
    required String id,
    required String name,
    required QuestionCounter questionCounter,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
