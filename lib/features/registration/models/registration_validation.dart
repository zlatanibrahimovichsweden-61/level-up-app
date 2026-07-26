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
  static const schoolId = 'schoolId';
  static const schoolName = 'schoolName';
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

/// School track, with the adr-010 geography conditionality.
///
/// - `requiresGovernorate == true` (EG) → `governorateId` + `cityId` +
///   `schoolId` all required; `schoolName` forbidden.
/// - otherwise → `cityId` required; `schoolName` optional free text;
///   `governorateId` + `schoolId` forbidden.
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
  requireValue(RegFields.cityId, draft.cityId);
  requireValue(RegFields.stage, draft.stage);
  requireValue(RegFields.educationSystem, draft.educationSystem);

  if (draft.requiresGovernorate ?? false) {
    requireValue(RegFields.governorateId, draft.governorateId);
    requireValue(RegFields.schoolId, draft.schoolId);
    forbidValue(RegFields.schoolName, draft.schoolName);
  } else {
    forbidValue(RegFields.governorateId, draft.governorateId);
    forbidValue(RegFields.schoolId, draft.schoolId);
    // schoolName is optional free text here — never blocks registration
    // ("never blocked" is explicit in the contract).
  }

  return issues;
}

/// University track — Egypt-only by shape, no geography branch: every contract
/// field is unconditionally required. The `universityId → facultyId →
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
  requireValue(RegFields.cityId, draft.cityId);

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
