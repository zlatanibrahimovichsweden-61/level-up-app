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

    /// adr-036 term signals, added in contract 1.2.0-m1. **Optional AND
    /// nullable, and null is NORMAL** — school subjects carry `termId: null`
    /// outright, and a university subject can too when its cohort has no
    /// schedule row. `termId` is opaque (adr-026 §7): never
    /// hardcode one and never derive an order from it. `termNumber` is the
    /// only orderable/labellable term signal on the wire — term NAMES are
    /// never sent, so any label is rendered client-side (adr-026 §5).
    ///
    /// No default, deliberately: a defaulted `termNumber` would fabricate an
    /// ordinal the server never sent.
    ///
    /// A year-long university course arrives as TWO subjects with an IDENTICAL
    /// [name], one per term (adr-036 §2) — `termNumber` is what tells them
    /// apart.
    String? termId,
    int? termNumber,
    required QuestionCounter questionCounter,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
