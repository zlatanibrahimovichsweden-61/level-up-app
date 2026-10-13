/// The friend-graph error codes and the predicates that recognise them.
///
/// Four codes, exactly as `contract/error-codes.md:36-39` lists them (all new in
/// 3.29.0-m1, spec-042 / adr-185). Each is an `ApiException` the
/// `ErrorInterceptor` built from the response's `ProblemDetails.code`, so the
/// predicates match on `code` - like `isAccountPendingDeletion` - and a plain
/// `ApiException(status:, code:)` is recognised without a subclass.
///
/// **No user copy lives here.** The server's `title`/`detail` are
/// developer-facing English and are never shown; mapping a predicate to AR/EN
/// text is the screen's job, and no screen exists yet. What the contract tells
/// the client to do for each code is recorded on the predicate, as a rule for
/// whoever writes that mapping.
///
/// Three failures that also apply to these operations are deliberately NOT
/// re-declared here, because the app already has the one place that owns them:
/// - `403 account_pending_deletion` - `isAccountPendingDeletion`
///   (`core/network/exceptions.dart`). Every friend-graph operation can return
///   it; the client rule is: do not log out, do not retry, route to the cancel
///   screen.
/// - `429 rate_limited` - `RateLimitedException`, with the `Retry-After` the
///   interceptor parsed. Friend, request and block writes share ONE budget of
///   30 per student per 60 seconds; `reportStudent` has its own (chat writes).
/// - `400 validation_failed` - `ValidationException`; on a list operation its
///   `cursor` field means "request page one again".
library;

import '../../core/network/exceptions.dart';

/// The `code` strings, verbatim from `contract/error-codes.md`.
abstract final class FriendErrorCodes {
  /// `404` - `sendFriendRequest`, `acceptFriendRequest`.
  static const friendTargetUnavailable = 'friend_target_unavailable';

  /// `404` - `acceptFriendRequest`, `declineFriendRequest`,
  /// `cancelFriendRequest`.
  static const friendRequestNotFound = 'friend_request_not_found';

  /// `409` - `sendFriendRequest` only.
  static const alreadyFriends = 'already_friends';

  /// `409` - `sendFriendRequest` only.
  static const friendRequestAlreadyPending = 'friend_request_already_pending';
}

/// `404 friend_target_unavailable` - this student cannot be sent (or, at accept
/// time, can no longer be accepted from) a friend request.
///
/// 🔴 **One answer for many causes, on purpose (spec-042 G2):** an unknown id,
/// the caller's own id, a pending-deletion account, a student on the other
/// Track and a student blocked in EITHER direction all return this identical
/// body, so it is neither an account-existence nor a block oracle. On
/// `acceptFriendRequest` the request has been deleted.
///
/// Client rule (`error-codes.md:36`): show a neutral "can't add this student"
/// message and **never infer a block** - no screen may word, order or style this
/// differently for any suspected cause.
bool isFriendTargetUnavailable(Object? error) =>
    error is ApiException &&
    error.code == FriendErrorCodes.friendTargetUnavailable;

/// `404 friend_request_not_found` - no such pending request FOR THIS CALLER in
/// the role the operation needs.
///
/// `cancelFriendRequest` needs a request the caller SENT; `acceptFriendRequest`
/// and `declineFriendRequest` need one the caller RECEIVED. An unknown id, a
/// malformed id, an already-answered request and another pair's request are the
/// same answer - never `403` - so a request's existence is not disclosed.
///
/// Client rule (`error-codes.md:37`): refresh the request list.
bool isFriendRequestNotFound(Object? error) =>
    error is ApiException &&
    error.code == FriendErrorCodes.friendRequestNotFound;

/// `409 already_friends` - the caller and this student are already friends.
///
/// Returned by `sendFriendRequest` only, and checked AFTER
/// `friend_target_unavailable`, so it only ever describes an eligible student.
///
/// Client rule (`error-codes.md:38`): show the friend as added.
bool isAlreadyFriends(Object? error) =>
    error is ApiException && error.code == FriendErrorCodes.alreadyFriends;

/// `409 friend_request_already_pending` - the caller already has a pending
/// request to this student.
///
/// Returned by `sendFriendRequest` only. The existing request is unchanged and
/// there is no resend. (If the OTHER student had asked first, the send accepts
/// theirs instead - `201`, `status: accepted` - and this is not returned.)
///
/// Client rule (`error-codes.md:39`): show the request as sent.
bool isFriendRequestAlreadyPending(Object? error) =>
    error is ApiException &&
    error.code == FriendErrorCodes.friendRequestAlreadyPending;
