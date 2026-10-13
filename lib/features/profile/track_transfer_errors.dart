/// The two refusals that are particular to `transferToUniversity`
/// (`POST /me/track-transfer`, `openapi.yaml:1338`).
///
/// They live in this file rather than beside [isAccountPendingDeletion] in
/// `core/network/exceptions.dart` because, unlike that predicate, they are one
/// operation's errors (`contract/error-codes.md:59-60`: "`transferToUniversity`
/// only"), and `exceptions.dart` is shared by every feature.
///
/// Both match on `code` rather than on an exception subclass or the status, the
/// same way `isAccountPendingDeletion` and `isAccountBanned` do: the contract's
/// discriminator is the code ("**Read `code` to tell them apart.**",
/// `openapi.yaml:1400`), and a plain [ApiException] - what `ErrorInterceptor`
/// builds, and what tests construct - is recognised alongside any future
/// subclass. Neither status is consulted, so the `403`s of this operation are
/// told apart purely by code: `track_transfer_not_eligible` is NOT
/// `account_pending_deletion` (use [isAccountPendingDeletion] for that one).
///
/// The contract's order of refusals, for whoever branches on these:
/// `403 account_pending_deletion` first, then `409 track_transfer_not_allowed`,
/// then `403 track_transfer_not_eligible`, then `400 validation_failed` for the
/// body. A refused call changes nothing.
library;

import '../../core/network/exceptions.dart';

/// `403 track_transfer_not_eligible` - the caller is on the School track but
/// not at the final school stage (`secondary3`), so they may not transfer yet.
///
/// Contract client rule: hide or disable the transfer control and explain that
/// it opens in the final school year. It is checked AFTER
/// `track_transfer_not_allowed` and BEFORE body validation, so a student who
/// gets it has not been told anything about their ids.
bool isTrackTransferNotEligible(Object? error) =>
    error is ApiException && error.code == kTrackTransferNotEligibleCode;

/// `409 track_transfer_not_allowed` - the caller is already on the University
/// track: they registered there, or they already transferred. ONE code for both
/// causes (the app cannot and must not tell which).
///
/// Contract client rule: re-read `GET /me`, render the University track, and
/// never offer the transfer again. A transfer happens once and never reverses.
bool isTrackTransferNotAllowed(Object? error) =>
    error is ApiException && error.code == kTrackTransferNotAllowedCode;

/// `error-codes.md` machine codes, named so a test (or a mock) can build the
/// exact refusal without retyping the string.
const kTrackTransferNotEligibleCode = 'track_transfer_not_eligible';
const kTrackTransferNotAllowedCode = 'track_transfer_not_allowed';
