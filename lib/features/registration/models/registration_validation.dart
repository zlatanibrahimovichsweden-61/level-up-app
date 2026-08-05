/// Client-side pre-flight for `POST /auth/register`.
///
/// The server is authoritative — this does NOT replace its validation, it just
/// avoids a doomed round-trip and lets the submit button reflect the form. The
/// server's own `ProblemDetails.errors` field map is rendered through the SAME
/// per-field channel (see the screens), which is why the keys here are the
/// CONTRACT field names verbatim: one error map shape, two sources.
library;

import 'registration_draft.dart';

/// Contract request-field names — also the keys the server uses in
/// `ProblemDetails.errors`.
abstract final class RegFields {
  static const dateOfBirth = 'dateOfBirth';
  static const countryCode = 'countryCode';
  static const governorateId = 'governorateId';
  static const cityId = 'cityId';
  static const cityName = 'cityName';
  static const schoolId = 'schoolId';
  static const stage = 'stage';
  static const educationSystem = 'educationSystem';
  static const universityId = 'universityId';
  static const facultyId = 'facultyId';
  static const studyYearId = 'studyYearId';
  static const name = 'name';
  static const parentPhone = 'parentPhone';
}

/// Why a field is invalid. Mapped to localized copy at the screen — never
/// rendered from server English.
enum RegFieldIssue {
  /// Contract-required (or conditionally required) and absent.
  missing,

  /// Present but FORBIDDEN for this geography branch (adr-010). Should be
  /// unreachable through the UI — the pickers are hidden and the body factory
  /// hard-nulls them — so this firing means a cascade-clear was missed.
  forbidden,

  /// The SERVER rejected this field (`400 validation_failed`). The reason is
  /// not carried: `ProblemDetails` messages are developer-facing English and
  /// the contract does not say the `errors` values are localized, so only the
  /// field NAME is used and the copy is ours.
  rejected,
}

/// School track: the adr-010 governorate conditionality, plus the adr-028 city
/// union and optional school.
///
/// - city (adr-028 §1) → `cityId` OR `cityName`, at least one. Neither → both
///   are `missing`. Both → `cityName` is `forbidden` (the coded value is the
///   one the backend can filter on, so the free text is the half that gives).
/// - `schoolId` (adr-028 §2) → **never required**, Egypt included; still
///   forbidden outside Egypt, where the step does not exist at all.
/// - `governorateId` → **unchanged**: required for EG, forbidden otherwise.
///   adr-028 does not touch adr-010's governorate rule.
///
/// Non-geography required fields (`dateOfBirth`, `stage`, `educationSystem`,
/// `countryCode`) are checked too. `name`/`parentPhone` come from Sign Up_1 and
/// are checked defensively — a draft reaching here without them means the
/// wizard was entered out of order.
Map<String, RegFieldIssue> validateSchoolDraft(RegistrationDraft draft) {
  final issues = <String, RegFieldIssue>{};

  void requireValue(String field, Object? value) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      issues[field] = RegFieldIssue.missing;
    }
  }

  void forbidValue(String field, Object? value) {
    if (value != null && !(value is String && value.trim().isEmpty)) {
      issues[field] = RegFieldIssue.forbidden;
    }
  }

  requireValue(RegFields.name, draft.name);
  requireValue(RegFields.parentPhone, draft.parentPhone);
  requireValue(RegFields.dateOfBirth, draft.dateOfBirth);
  requireValue(RegFields.countryCode, draft.countryCode);
  _checkCityUnion(draft, issues);
  requireValue(RegFields.stage, draft.stage);
  requireValue(RegFields.educationSystem, draft.educationSystem);

  if (draft.requiresGovernorate ?? false) {
    requireValue(RegFields.governorateId, draft.governorateId);
    // schoolId is deliberately NOT required here — adr-028 §2 lets an Egyptian
    // student who cannot find their school register without one.
  } else {
    forbidValue(RegFields.governorateId, draft.governorateId);
    forbidValue(RegFields.schoolId, draft.schoolId);
  }

  return issues;
}

/// The adr-028 §1 union, shared by both tracks: exactly one of
/// `cityId` / `cityName`.
///
/// The contract expresses "at least one" as an `anyOf`, and forbids both in
/// prose (`openapi.yaml:1272-1273`). Both-present is reported against
/// `cityName` so the inline error lands on the field the student can clear by
/// going back to the picker.
void _checkCityUnion(
  RegistrationDraft draft,
  Map<String, RegFieldIssue> issues,
) {
  final coded = draft.cityId?.trim();
  final free = draft.cityName?.trim();
  final hasCoded = coded != null && coded.isNotEmpty;
  final hasFree = free != null && free.isNotEmpty;

  if (hasCoded && hasFree) {
    issues[RegFields.cityName] = RegFieldIssue.forbidden;
  } else if (!hasCoded && !hasFree) {
    // Neither half answered: report both, since either one would resolve it
    // and the screen decides which field is currently on show.
    issues[RegFields.cityId] = RegFieldIssue.missing;
    issues[RegFields.cityName] = RegFieldIssue.missing;
  }
}

/// University track — Egypt-only by shape and still no geography branch: every
/// contract field below is unconditionally required, and there is no school
/// step to be optional. The only adr-028 change here is the city, which is the
/// same union as the school track. The `universityId → facultyId →
/// studyYearId` cascade is enforced by the UI gating; this only checks presence.
Map<String, RegFieldIssue> validateUniversityDraft(RegistrationDraft draft) {
  final issues = <String, RegFieldIssue>{};

  void requireValue(String field, Object? value) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      issues[field] = RegFieldIssue.missing;
    }
  }

  requireValue(RegFields.name, draft.name);
  requireValue(RegFields.parentPhone, draft.parentPhone);
  requireValue(RegFields.dateOfBirth, draft.dateOfBirth);
  requireValue(RegFields.universityId, draft.universityId);
  requireValue(RegFields.facultyId, draft.facultyId);
  requireValue(RegFields.studyYearId, draft.studyYearId);
  requireValue(RegFields.governorateId, draft.governorateId);
  _checkCityUnion(draft, issues);

  return issues;
}

/// Dispatch on the draft's chosen track. `null` track → the wizard has not
/// reached Sign Up_2 yet, which is itself a blocking issue.
Map<String, RegFieldIssue> validateDraft(RegistrationDraft draft) =>
    switch (draft.track) {
      RegTrack.school => validateSchoolDraft(draft),
      RegTrack.university => validateUniversityDraft(draft),
      null => const {'track': RegFieldIssue.missing},
    };

/// Turns the server's `ProblemDetails.errors` field NAMES into the same
/// per-field issue map the client validator produces, so a screen renders both
/// sources through one channel. The server's message strings are dropped by
/// design — see [RegFieldIssue.rejected].
Map<String, RegFieldIssue> serverFieldIssues(Iterable<String> fields) => {
      for (final field in fields) field: RegFieldIssue.rejected,
    };

/// Raised by the submit notifier when the draft fails the client pre-flight, so
/// the request is never sent. Carries the same [RegFieldIssue] map the screen
/// renders inline.
class DraftValidationFailure implements Exception {
  const DraftValidationFailure(this.issues);

  final Map<String, RegFieldIssue> issues;

  @override
  String toString() => 'DraftValidationFailure(${issues.keys.join(', ')})';
}
