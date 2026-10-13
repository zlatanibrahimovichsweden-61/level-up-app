import '../../core/network/exceptions.dart';
import '../../l10n/app_localizations.dart';

/// How a failed support LOAD reads - the ticket list, a ticket, its thread, and
/// a failed "load more". One definition, so the screens cannot drift apart.
/// Mirrors `notificationsFailureText`.
///
/// Offline is NOT handled here: the screen gives it its own state and copy
/// ([AppLocalizations.offline]).
///
/// `403 account_pending_deletion` is not a support failure - the account is
/// inside its 30-day deletion grace window, during which every authenticated
/// endpoint but four answers this (`openapi.yaml:62-71`), support included. The
/// contract's instruction is to neither log out nor retry, so the screen says
/// what is actually wrong instead of showing a generic error. Recognising the
/// code is [isAccountPendingDeletion]'s job.
///
/// `429 rate_limited` says so: [AppLocalizations.rateLimitedIn] when the
/// server's `Retry-After` is known, else [AppLocalizations.rateLimited] (the
/// header is not guaranteed, so the message has to stand alone). Retry stays
/// withheld ([supportRetryAllowed]) - the text names the wait instead.
///
/// A `404 not_found` (an unknown, malformed or another student's ticket) reads
/// as the generic error: the contract deliberately gives the three one answer,
/// and the screen must not tell them apart.
String supportLoadFailureText(AppLocalizations l10n, Object? error) {
  if (isAccountPendingDeletion(error)) return l10n.accountPendingDeletion;
  if (error is RateLimitedException) {
    final retryAfter = error.retryAfter;
    return retryAfter == null
        ? l10n.rateLimited
        : l10n.rateLimitedIn(retryAfter.inSeconds);
  }
  return l10n.genericError;
}

/// Whether a failed support load may offer Retry.
///
/// Withheld for a rate-limited call: it recovers on its own clock, and the
/// contract says not to retry in a tight loop.
///
/// Withheld for `account_pending_deletion`: it does not recover on any clock.
/// Until the deletion is cancelled every tap answers the same `403`
/// (`openapi.yaml:82`).
///
/// Withheld for `404 not_found`: the ticket is not the caller's, or is gone,
/// and asking again returns the same answer.
bool supportRetryAllowed(Object? error) =>
    !(error is RateLimitedException ||
        isAccountPendingDeletion(error) ||
        _isNotFound(error));

/// How a failed WRITE reads - creating a ticket or sending a reply. The text is
/// kept in the field either way; this is only the message beside it.
///
/// - offline (or a transport failure) -> [AppLocalizations.offline];
/// - `429 rate_limited` -> [AppLocalizations.rateLimitedIn] when the server's
///   `Retry-After` is known, else [AppLocalizations.rateLimited] (the header is
///   not guaranteed, so the message has to stand alone). The ticket budget is 5
///   creates per day and the reply budget 60 per hour (`openapi.yaml:2700`,
///   `:2843`);
/// - `403 account_pending_deletion` -> [AppLocalizations.accountPendingDeletion];
/// - a `400 validation_failed` -> [AppLocalizations.errorValidationFailed]. The
///   per-field part (which input to mark) is read from the exception's field
///   NAMES at the form; the server's message strings are never shown;
/// - anything else -> [AppLocalizations.genericError].
///
/// A `409 ticket_closed` on a reply is NOT a failure message: the thread
/// notifier turns it into the closed state before a screen asks for text.
String supportActionFailureText(AppLocalizations l10n, Object? error) {
  if (isOffline(error)) return l10n.offline;
  if (error is RateLimitedException) {
    final retryAfter = error.retryAfter;
    return retryAfter == null
        ? l10n.rateLimited
        : l10n.rateLimitedIn(retryAfter.inSeconds);
  }
  if (isAccountPendingDeletion(error)) return l10n.accountPendingDeletion;
  if (error is ValidationException) return l10n.errorValidationFailed;
  return l10n.genericError;
}

bool _isNotFound(Object? error) =>
    error is ApiException && error.status == 404 && error.code == 'not_found';
