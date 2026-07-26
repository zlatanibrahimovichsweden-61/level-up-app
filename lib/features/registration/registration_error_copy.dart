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
      case 'validation_failed':
        return l10n.errorValidationFailed;
    }
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
/// the server's `400 validation_failed` field map.
Map<String, RegFieldIssue> fieldIssuesFrom(Object? error) => switch (error) {
      DraftValidationFailure(:final issues) => issues,
      ValidationException(:final fields) => serverFieldIssues(fields),
      _ => const {},
    };

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
