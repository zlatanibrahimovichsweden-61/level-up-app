import '../../core/network/exceptions.dart';
import '../../l10n/app_localizations.dart';

/// How a failed `GET /leaderboard` reads wherever a board is shown — the
/// Leaderboard tab and Home's Top Student block. One definition, so the two
/// surfaces cannot drift apart. Offline is NOT handled here: both surfaces give
/// it its own state and copy.
///
/// `403 account_pending_deletion` is not a leaderboard failure — the account
/// is inside its 30-day deletion grace window, during which every
/// authenticated endpoint but four answers this. The contract's instruction is
/// to route to the cancel screen and neither log out nor retry. That screen
/// does not exist yet, so the board says what is actually wrong instead of
/// showing a generic error. Recognising the code is [isAccountPendingDeletion]'s
/// job.
///
/// `429 rate_limited` says so (`getLeaderboard` documents it, "Honour
/// Retry-After"): [AppLocalizations.rateLimitedIn] when the server's
/// `Retry-After` is known, else [AppLocalizations.rateLimited] (the header is
/// not guaranteed, so the message has to stand alone). Retry stays withheld
/// ([boardRetryAllowed]) - the text names the wait instead. The same two
/// strings, chosen the same way, as `supportLoadFailureText`.
String boardFailureText(AppLocalizations l10n, Object? error) {
  if (isAccountPendingDeletion(error)) return l10n.accountPendingDeletion;
  if (error is RateLimitedException) {
    final retryAfter = error.retryAfter;
    return retryAfter == null
        ? l10n.rateLimited
        : l10n.rateLimitedIn(retryAfter.inSeconds);
  }
  return l10n.genericError;
}

/// Whether a failed board may offer Retry.
///
/// Withheld for a rate-limited board: it recovers on its own clock, and the
/// contract is explicit — do not retry in a tight loop — so the button is not
/// handed to the student to hammer.
///
/// Withheld for `account_pending_deletion` for a stronger reason: it does not
/// recover on any clock. The contract says "do not log the user out and do not
/// retry" (`openapi.yaml:82`); until the deletion is cancelled every tap
/// answers the same `403`.
bool boardRetryAllowed(Object? error) =>
    !(error is RateLimitedException || isAccountPendingDeletion(error));
