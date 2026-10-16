import '../../core/network/exceptions.dart';
import '../../l10n/app_localizations.dart';
import 'models/registration_validation.dart';

/// The ONE place that maps a registration failure to localized copy — the
/// sibling of `auth_error_copy.dart`.
///
/// Server `title`/`detail` are developer-facing English and are never shown.
/// Neither are the strings inside `ProblemDetails.errors`: the contract does not
/// state they are localized, and half the audience reads Arabic. Only the stable
/// `code` and the field NAMES cross into the UI.

/// Banner-level copy for a failed submit.
String registrationErrorMessage(AppLocalizations l10n, Object? error) {
  if (isOffline(error)) return l10n.offline;
  if (error is DraftValidationFailure) return l10n.errorValidationFailed;
  if (error is ApiException) {
    switch (error.code) {
      case 'registration_token_invalid':
        return l10n.registrationTokenInvalid;
      case 'phone_already_registered':
        return l10n.phoneAlreadyRegistered;
      case 'school_stage_not_available':
        return l10n.registrationSchoolStageNotAvailable;
      case 'education_system_not_available':
        return l10n.registrationEducationSystemNotAvailable;
      case 'validation_failed':
      case 'name_not_allowed':
        return l10n.errorValidationFailed;
    }
  }
  return l10n.genericError;
}

/// In-field copy for a failed `/reference/*` load, used by every picker.
///
/// Three outcomes, one slot. `429 rate_limited` gets its own line because the
/// generic "something went wrong" invites the student to hammer Retry, which is
/// the one thing that cannot help — but it is still just a message in the
/// EXISTING error state, with the existing user-tapped Retry button. No
/// countdown, no gating, no auto-retry.
///
/// `404 country_not_found` deliberately gets NO special copy (Seif's notice
/// §3: the generic geography error state "stays as-is"). A student picks the
/// country from a list, so it should be unreachable; mapping the code keeps it
/// out of `unknown` without inventing UI for it.
String referenceErrorMessage(AppLocalizations l10n, Object? error) {
  if (isOffline(error)) return l10n.offline;
  if (error is RateLimitedException) {
    final retryAfter = error.retryAfter;
    // The header is not guaranteed, so the message has to stand alone.
    return retryAfter == null
        ? l10n.rateLimited
        : l10n.rateLimitedIn(retryAfter.inSeconds);
  }
  return l10n.genericError;
}

/// Copy for one field's inline error.
String fieldIssueMessage(AppLocalizations l10n, RegFieldIssue issue) =>
    switch (issue) {
      RegFieldIssue.missing => l10n.fieldRequired,
      RegFieldIssue.forbidden => l10n.fieldNotAllowed,
      RegFieldIssue.rejected => l10n.fieldRejected,
    };

/// Per-field issues, whichever side produced them — the client pre-flight or
/// the server's `400 validation_failed` field map. A `422 name_not_allowed`
/// names no field, but it can only be about `name`, so it lands there as the
/// same approved "Please check this field" a `400` would give it.
Map<String, RegFieldIssue> fieldIssuesFrom(Object? error) => switch (error) {
  DraftValidationFailure(:final issues) => issues,
  ValidationException(:final fields) => serverFieldIssues(fields),
  _ when isNameNotAllowed(error) => const {
    RegFields.name: RegFieldIssue.rejected,
  },
  // `422 school_stage_not_available` / `education_system_not_available` name
  // no field either, but each can only be about its own: the stage, the system.
  _ when isSchoolStageNotAvailable(error) => const {
    RegFields.stage: RegFieldIssue.rejected,
  },
  _ when isEducationSystemNotAvailable(error) => const {
    RegFields.educationSystem: RegFieldIssue.rejected,
  },
  _ => const {},
};

/// `422 school_stage_not_available` — the School body's `stage` is not open for
/// registration yet (`listSchoolStages` said `soon`, or said `active` and has
/// since changed). Also the code the server answers when BOTH the stage and the
/// education system are closed. The `registrationToken` is not consumed, so the
/// student fixes the choice on the School form and resubmits with the SAME
/// token: this never restarts the registration ([restartsRegistration]).
bool isSchoolStageNotAvailable(Object? error) =>
    error is ApiException && error.code == 'school_stage_not_available';

/// `422 education_system_not_available` — only the School body's
/// `educationSystem` is not open yet. Same token rule as
/// [isSchoolStageNotAvailable].
bool isEducationSystemNotAvailable(Object? error) =>
    error is ApiException && error.code == 'education_system_not_available';

/// `422 name_not_allowed` — the name contains a blocked term.
///
/// It is in the upstream contract from 3.47.0-m1 (`completeRegistration`),
/// past the vendored pin (3.46.0-m1). It is handled ahead of the pin on the
/// owner's word (2026-10-10). The contract says the check runs before the
/// `registrationToken` is used, so the same token can be resubmitted with
/// another name while it is still valid; it also says not to retry the same
/// name. The response does not repeat the name.
///
/// The name is asked on Sign Up_1, not on the detail screen that submits, so
/// the detail screens send the student back there with the draft (and its
/// token) intact. Nothing resubmits on its own: the next request is the
/// student's own Start learning.
bool isNameNotAllowed(Object? error) =>
    error is ApiException && error.code == 'name_not_allowed';

/// Does this failure mean the whole registration must restart at `/login`?
///
/// `registration_token_invalid` — the token expired, was consumed, or came from
/// another device. `phone_already_registered` — an account appeared since the
/// OTP was verified. Both are unrecoverable in-place: the contract's answer to
/// each is to start again at phone → OTP.
bool restartsRegistration(Object? error) =>
    error is ApiException &&
    const {
      'registration_token_invalid',
      'phone_already_registered',
    }.contains(error.code);
