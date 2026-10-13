import '../../core/network/exceptions.dart';

/// The two codes `/me/deletion-request` answers for itself, as predicates. No
/// copy lives here: the words the student reads are a screen's, through
/// `AppLocalizations`, and the confirm and cancel wording is not decided.
///
/// The third code in this area, `403 account_pending_deletion`, is NOT
/// redefined here. It is not this endpoint's answer — the two operations are on
/// the rule's allowlist — but every other authenticated call's, so its one
/// definition stays in `core/network/exceptions.dart` as
/// [isAccountPendingDeletion].

/// `409 deletion_already_requested` — a deletion request is already pending for
/// this account (`contract/error-codes.md:48`; `POST /me/deletion-request`).
///
/// The repeat call did NOT start a new grace window and did not move
/// `effectiveAt`: read the live window from `GET /me`'s `pendingDeletion` and
/// show that one. Never show a fresh 30 days.
///
/// Matches on `code`, like [isAccountPendingDeletion], so a plain
/// `ApiException` (what `ErrorInterceptor` builds) is recognised.
bool isDeletionAlreadyRequested(Object? error) =>
    error is ApiException && error.code == 'deletion_already_requested';

/// `404 no_pending_deletion` — no cancellable deletion request exists for this
/// account (`contract/error-codes.md:49`; `DELETE /me/deletion-request`).
///
/// Two situations answer it, and the code does not tell them apart: there is
/// nothing pending, or erasure has already begun executing — the grace window
/// is over in fact, not just in wording, and the request can no longer be
/// withdrawn. Per-resource, so it is NOT the generic `not_found`.
bool isNoPendingDeletion(Object? error) =>
    error is ApiException && error.code == 'no_pending_deletion';
