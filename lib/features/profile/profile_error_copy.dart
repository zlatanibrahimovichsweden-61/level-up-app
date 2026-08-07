/// The ONE place that maps a `PATCH /me` failure to localized copy — the
/// sibling of `auth_error_copy.dart` and `registration_error_copy.dart`.
///
/// Server `title`/`detail` are developer-facing English and are never shown.
/// Neither are the strings inside `ProblemDetails.errors`: the contract does
/// not state they are localized, and half the audience reads Arabic. Only the
/// stable `code` and the field NAMES cross into the UI.
library;

import '../../core/network/exceptions.dart';
import '../../l10n/app_localizations.dart';

/// Banner-level copy for a failed save.
String profileSaveErrorMessage(AppLocalizations l10n, Object? error) {
  if (isOffline(error)) return l10n.offline;
  if (error is ValidationException) return l10n.errorValidationFailed;
  return l10n.genericError;
}

/// The field names the server rejected, for the inline errors under each input.
///
/// `PATCH /me` can only reject the fields it accepts, so in practice this is
/// `name` and `email`. A name the screen does not render (say a future
/// `avatarId` rejection) is deliberately dropped rather than shown against the
/// wrong field — the banner still says something went wrong.
Set<String> rejectedFields(Object? error) =>
    error is ValidationException ? error.fields.toSet() : const <String>{};
