import '../../core/network/exceptions.dart';
import '../../l10n/app_localizations.dart';

/// The ONE place that maps a legal-document failure to copy. Existing approved
/// strings only — no line here was written for this screen.

/// `404 legal_document_unavailable`: no approved text is configured, so the
/// server serves none ("never an empty 200"). Distinct from `not_found`.
bool isLegalDocumentUnavailable(Object? error) =>
    error is ApiException &&
    error.status == 404 &&
    error.code == 'legal_document_unavailable';

/// The line under the icon when the document cannot be shown. Offline has its
/// own state and line (`offline`), so it is not mapped here.
///
/// - unavailable → `legalNotPublished`, the line the screen showed before any
///   document existed ("This document hasn't been published yet.").
/// - `429 rate_limited` → `rateLimitedIn` when `Retry-After` came, else
///   `rateLimited`: the `/reference` lines the registration pickers use.
/// - anything else → `genericError`.
String legalFailureText(AppLocalizations l10n, Object? error) {
  if (isLegalDocumentUnavailable(error)) return l10n.legalNotPublished;
  if (error is RateLimitedException) {
    final retryAfter = error.retryAfter;
    return retryAfter == null
        ? l10n.rateLimited
        : l10n.rateLimitedIn(retryAfter.inSeconds);
  }
  return l10n.genericError;
}

/// Is Retry worth offering? Not for an unavailable document: asking again
/// gets the same answer until one is published, and the next visit asks again
/// anyway. A rate limit keeps its Retry, as on the registration pickers: the
/// line says when, and the tap is the student's own.
bool legalRetryAllowed(Object? error) => !isLegalDocumentUnavailable(error);
