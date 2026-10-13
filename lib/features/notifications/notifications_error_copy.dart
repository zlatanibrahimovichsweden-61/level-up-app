import '../../core/network/exceptions.dart';
import '../../l10n/app_localizations.dart';

/// How a failed `GET /me/notifications` reads on the inbox — the full-screen
/// error AND a failed "load more". One definition, so the two cannot drift
/// apart. Mirrors the leaderboard's `boardFailureText`.
///
/// Offline is NOT handled here: the screen gives it its own state and copy
/// ([AppLocalizations.offline]).
///
/// `403 account_pending_deletion` is not an inbox failure — the account is
/// inside its 30-day deletion grace window, during which every authenticated
/// endpoint but four answers this (`openapi.yaml:62-71`). The contract's
/// instruction is to neither log out nor retry, so the inbox says what is
/// actually wrong instead of showing a generic error. Recognising the code is
/// [isAccountPendingDeletion]'s job.
///
/// `429 rate_limited` says so, defensively: `listMyNotifications` documents no
/// 429 in the pinned contract, but the error interceptor maps any 429
/// `rate_limited` answer to a [RateLimitedException], so the inbox can meet
/// one. [AppLocalizations.rateLimitedIn] when the server's `Retry-After` is
/// known, else [AppLocalizations.rateLimited]; Retry stays withheld
/// ([notificationsRetryAllowed]). The same two strings, chosen the same way, as
/// `supportLoadFailureText`.
String notificationsFailureText(AppLocalizations l10n, Object? error) {
  if (isAccountPendingDeletion(error)) return l10n.accountPendingDeletion;
  if (error is RateLimitedException) {
    final retryAfter = error.retryAfter;
    return retryAfter == null
        ? l10n.rateLimited
        : l10n.rateLimitedIn(retryAfter.inSeconds);
  }
  return l10n.genericError;
}

/// Whether a failed inbox may offer Retry.
///
/// Withheld for a rate-limited call: it recovers on its own clock, and the
/// contract says not to retry in a tight loop, so the button is not handed to
/// the student to hammer.
///
/// Withheld for `account_pending_deletion` for a stronger reason: it does not
/// recover on any clock. Until the deletion is cancelled every tap answers the
/// same `403` (`openapi.yaml:82`).
bool notificationsRetryAllowed(Object? error) =>
    !(error is RateLimitedException || isAccountPendingDeletion(error));
