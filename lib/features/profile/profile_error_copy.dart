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
///
/// `PATCH /me` is NOT on the account-deletion allowlist — only `GET /me` is
/// (`openapi.yaml:67-69`). So the two halves of the same path behave
/// differently during grace: the profile still loads, and saving it answers
/// `403`. Without this branch the student would read "something went wrong"
/// about an edit the server will refuse for the next thirty days.
String profileSaveErrorMessage(AppLocalizations l10n, Object? error) {
  if (isOffline(error)) return l10n.offline;
  if (isAccountPendingDeletion(error)) return l10n.accountPendingDeletion;
  if (error is ValidationException || isProfileNameNotAllowed(error)) {
    return l10n.errorValidationFailed;
  }
  return l10n.genericError;
}

/// The field names the server rejected, for the inline errors under each input.
///
/// `PATCH /me` can only reject the fields it accepts, so in practice this is
/// `name` and `email`. A name the screen does not render (say a future
/// `avatarId` rejection) is deliberately dropped rather than shown against the
/// wrong field — the banner still says something went wrong.
///
/// `422 name_not_allowed` names no field, but it can only be about `name`, so
/// it marks that field with the same approved "Please check this field" a
/// `400` gets.
Set<String> rejectedFields(Object? error) => switch (error) {
  ValidationException(:final fields) => fields.toSet(),
  _ when isProfileNameNotAllowed(error) => const {'name'},
  _ => const <String>{},
};

/// `422 name_not_allowed` — the new or changed name contains a blocked term,
/// and nothing was saved.
///
/// It is in the upstream contract from 3.47.0-m1 (`updateMyProfile`), past the
/// vendored pin (3.46.0-m1). It is handled ahead of the pin on the owner's
/// word (2026-10-10), because staging already enforces it. The response does
/// not repeat the name; the student's typed text stays in the field.
///
/// Named for the profile so it never meets sign-up's `isNameNotAllowed` in one
/// import scope: the two features keep their own copy mapping.
bool isProfileNameNotAllowed(Object? error) =>
    error is ApiException && error.code == 'name_not_allowed';
