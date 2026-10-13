import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../registration/models/reference_models.dart' show CursorPage;
import '../models/friend_models.dart';

/// The only place that touches Dio for the friend graph and for reporting a
/// student.
///
/// Twelve operations, all `x-stability: stable` and not web-only
/// (`openapi.yaml:2983-3364` and `:3663`): the eleven friend-graph operations
/// the app may call, plus `reportStudent`. They are authenticated and on the
/// main [dioProvider]: `AuthInterceptor` attaches the Bearer and
/// `ErrorInterceptor` has already mapped failures by the time they arrive here,
/// so every failure is rethrown as the typed [AppException] the interceptor
/// produced.
///
/// **`lookupStudentByPhone` is deliberately NOT here** (`POST
/// /friends/phone-lookup`, `openapi.yaml:3080`). It is the one operation that
/// would put a stranger's phone number on the wire, for minors, and it waits on
/// the owner's legal decision (DR-08). Do not add it without that decision.
///
/// **No screen consumes this layer yet**, and it carries no user copy: the
/// typed predicates in `friends_errors.dart` name the failures, and the text for
/// them belongs to the screens.
///
/// 🔴 **Every operation is default-denied** while the account is inside its
/// 30-day deletion grace window: `403 account_pending_deletion`, an
/// `ApiException` recognised by `isAccountPendingDeletion`. It is surfaced
/// untouched - no retry, no sign-out.
///
/// 🔴 **Rate limits.** Every friend, request and block WRITE shares one budget -
/// 30 per student per 60 seconds - and `reportStudent` has its own (30 chat
/// writes per 60 seconds). Either is `429 rate_limited`, a
/// [RateLimitedException] carrying the `Retry-After` the interceptor parsed.
///
/// 🔴 **The server is authoritative.** Nothing here decides who may befriend,
/// block or report whom, validates an id, or infers a state the server did not
/// return. Several answers are indistinguishable BY DESIGN (an unknown id, a
/// blocked student and a student on the other Track all look alike), and this
/// layer never tries to tell them apart.
///
/// Nothing in this file logs a name, an id, a cursor, a request or a body.
class FriendsRepository {
  FriendsRepository(this._dio);

  final Dio _dio;

  // -------------------------------------------------------------------------
  // Friends
  // -------------------------------------------------------------------------

  /// `GET /friends` (`listMyFriends`) - one page of the caller's own friends,
  /// ordered by `name` then `studentId`, pages of 20.
  ///
  /// **The operation takes no `limit`**, so none is ever sent. Only the
  /// contract's OPAQUE [cursor] is: follow it, never parse or build it. `null`
  /// means the first page and sends no `cursor` at all (an absent parameter, not
  /// `cursor: null`, which would be a malformed cursor).
  ///
  /// There is no operation that lists ANOTHER student's friends (spec-042 G4).
  /// A friend whose account is pending deletion or erased is not listed.
  ///
  /// 🔴 Branch on `hasMore`, never on `items.length`: the envelope is returned
  /// untouched so that signal survives.
  ///
  /// `400 validation_failed` on field `cursor` (a [ValidationException]) means
  /// "request page one again".
  Future<CursorPage<Friend>> listMyFriends({String? cursor}) =>
      _guard(() async {
        final res = await _dio.get<Map<String, dynamic>>(
          '/friends',
          queryParameters: {'cursor': ?cursor},
        );
        return _page(res, Friend.fromJson);
      });

  /// `DELETE /friends/{studentId}` (`removeFriend`) - ends the friendship
  /// between the caller and [studentId]. Answers `204`, so there is nothing to
  /// decode.
  ///
  /// **Idempotent**: `204` whether or not the friendship existed, so the answer
  /// never reveals anything about [studentId]. The removed student is not
  /// notified.
  Future<void> removeFriend(String studentId) => _guard(() async {
    await _dio.delete<void>('/friends/${Uri.encodeComponent(studentId)}');
  });

  /// `GET /friends/suggestions` (`listFriendSuggestions`) - one page of students
  /// from the caller's own cohort to add, as [StudentCard]s.
  ///
  /// The cohort is resolved by the server from the caller's own active
  /// enrolment, never from input, so nothing about the cohort is sent. Never
  /// includes the caller, their friends, anyone with a pending request either
  /// way, anyone blocked either way, or a pending-deletion account. A caller
  /// with no active enrolment gets an empty page - a normal answer.
  ///
  /// **Bounded:** at most 100 students in total across all pages (`hasMore:
  /// false` after the 100th). Pages of 20; no `limit`. Same cursor and
  /// `hasMore` rules as [listMyFriends].
  Future<CursorPage<StudentCard>> listFriendSuggestions({String? cursor}) =>
      _guard(() async {
        final res = await _dio.get<Map<String, dynamic>>(
          '/friends/suggestions',
          queryParameters: {'cursor': ?cursor},
        );
        return _page(res, StudentCard.fromJson);
      });

  // -------------------------------------------------------------------------
  // Friend requests
  // -------------------------------------------------------------------------

  /// `GET /friend-requests` (`listMyFriendRequests`) - one page of the caller's
  /// own pending requests in one [direction], newest first (`createdAt`
  /// descending, ties by `requestId` descending), pages of 20, no `limit`.
  ///
  /// [direction] is REQUIRED by the contract - there is no "both" - so the two
  /// tabs are two separate lists, each with its own cursor. Never reuse a
  /// cursor across directions. [FriendRequest.student] is the other party. A
  /// request whose other party is pending deletion is not listed.
  ///
  /// Same cursor and `hasMore` rules as [listMyFriends].
  Future<CursorPage<FriendRequest>> listMyFriendRequests({
    required FriendRequestDirection direction,
    String? cursor,
  }) => _guard(() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/friend-requests',
      queryParameters: {'direction': direction.wire, 'cursor': ?cursor},
    );
    return _page(res, FriendRequest.fromJson);
  });

  /// `POST /friend-requests` (`sendFriendRequest`) - sends a request to
  /// [studentId], or ACCEPTS theirs if they already asked. The body is exactly
  /// `{studentId}`.
  ///
  /// `201` either way: read [SendFriendRequestResult.status]. `pending` carries
  /// the new [FriendRequest]; `accepted` carries the new [Friend] (adr-185 D7).
  /// There is no friend, pending or daily count cap.
  ///
  /// Whether the recipient is told is NOT settled by the pinned text: the pin
  /// says "not notified (no push or inbox item in this version)", while Seif's
  /// 2026-10-09 reply (BH-B7/BH-B8/BH-G3 in `docs/BACKEND_HANDOFF.md`) says
  /// `friend_request_received` IS pushed. Nothing in this layer depends on it.
  ///
  /// Failures a screen branches on (all [ApiException]s):
  /// - `404 friend_target_unavailable` - `isFriendTargetUnavailable`. One answer
  ///   for an unknown id, the caller's own id, a pending-deletion account, the
  ///   other Track AND a block in either direction; never infer which.
  /// - `409 already_friends` - `isAlreadyFriends`.
  /// - `409 friend_request_already_pending` - `isFriendRequestAlreadyPending`.
  /// - `400 validation_failed` on `studentId` - a [ValidationException].
  Future<SendFriendRequestResult> sendFriendRequest(String studentId) =>
      _guard(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          '/friend-requests',
          data: <String, dynamic>{'studentId': studentId},
        );
        return SendFriendRequestResult.fromJson(res.data!);
      });

  /// `DELETE /friend-requests/{requestId}` (`cancelFriendRequest`) - the SENDER
  /// cancels a pending request. Answers `204`.
  ///
  /// `404 friend_request_not_found` - `isFriendRequestNotFound` - when there is
  /// no such pending request SENT BY THIS CALLER: an unknown, malformed,
  /// already-answered or someone else's id are the same answer. The caller
  /// refreshes the list; the request is as good as gone.
  Future<void> cancelFriendRequest(String requestId) => _guard(() async {
    await _dio.delete<void>(
      '/friend-requests/${Uri.encodeComponent(requestId)}',
    );
  });

  /// `POST /friend-requests/{requestId}/accept` (`acceptFriendRequest`) - the
  /// RECIPIENT accepts. Creates the friendship, deletes the request and answers
  /// the new [Friend]. No body.
  ///
  /// The sender's eligibility is re-checked at accept time (not blocked either
  /// way, not pending deletion, same Track). Failures a screen branches on:
  /// - `404 friend_request_not_found` - `isFriendRequestNotFound` - no such
  ///   pending request RECEIVED BY THIS CALLER.
  /// - `404 friend_target_unavailable` - `isFriendTargetUnavailable` - the
  ///   sender can no longer be befriended and the request HAS BEEN DELETED.
  Future<Friend> acceptFriendRequest(String requestId) => _guard(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/friend-requests/${Uri.encodeComponent(requestId)}/accept',
    );
    return Friend.fromJson(res.data!);
  });

  /// `POST /friend-requests/{requestId}/decline` (`declineFriendRequest`) - the
  /// RECIPIENT declines. Deletes the request and answers `204`. No body.
  ///
  /// The sender is not notified and may send again, with no cooldown (adr-185
  /// D7); to stop further requests the student blocks them ([blockStudent]).
  ///
  /// `404 friend_request_not_found` - `isFriendRequestNotFound` - when there is
  /// no such pending request RECEIVED BY THIS CALLER.
  Future<void> declineFriendRequest(String requestId) => _guard(() async {
    await _dio.post<void>(
      '/friend-requests/${Uri.encodeComponent(requestId)}/decline',
    );
  });

  // -------------------------------------------------------------------------
  // Blocks
  // -------------------------------------------------------------------------

  /// `GET /blocks` (`listMyBlocks`) - one page of the students the caller has
  /// blocked, as [StudentCard]s, most recently blocked first, pages of 20, no
  /// `limit`.
  ///
  /// The caller's own blocks only. A blocked student whose account is pending
  /// deletion or erased is not listed, nor is one who is now on the other Track
  /// (the block is kept and keeps its effect, and they are listed again if the
  /// two share a Track). An omitted row is skipped and never counted, so a page
  /// carries 20 items unless it is the last.
  ///
  /// Same cursor and `hasMore` rules as [listMyFriends].
  Future<CursorPage<StudentCard>> listMyBlocks({String? cursor}) =>
      _guard(() async {
        final res = await _dio.get<Map<String, dynamic>>(
          '/blocks',
          queryParameters: {'cursor': ?cursor},
        );
        return _page(res, StudentCard.fromJson);
      });

  /// `POST /blocks` (`blockStudent`) - blocks [studentId]. The body is exactly
  /// `{studentId}`. Answers `204`.
  ///
  /// **Silent and idempotent.** Removes any friendship and any pending request
  /// between the two students, in either direction; while the block exists
  /// neither can find, request or list the other (adr-185 D8). `204` ALWAYS -
  /// including for an unknown id (nothing is stored) and for a student on the
  /// other Track (stored but hidden, adr-212) - so the answer never reveals
  /// whether a student exists or which Track they are on. The blocked student
  /// is not notified. Blocking is free for every student.
  ///
  /// 🔴 Because every well-formed id gets `204`, a success proves NOTHING about
  /// the student: do not use it to infer that they exist.
  Future<void> blockStudent(String studentId) => _guard(() async {
    await _dio.post<void>(
      '/blocks',
      data: <String, dynamic>{'studentId': studentId},
    );
  });

  /// `DELETE /blocks/{studentId}` (`unblockStudent`) - removes a block. Answers
  /// `204`.
  ///
  /// **Idempotent**: `204` whether or not a block existed. Unblocking restores
  /// nothing - no friendship and no request comes back.
  Future<void> unblockStudent(String studentId) => _guard(() async {
    await _dio.delete<void>('/blocks/${Uri.encodeComponent(studentId)}');
  });

  // -------------------------------------------------------------------------
  // Reporting
  // -------------------------------------------------------------------------

  /// `POST /student-reports` (`reportStudent`) - reports [studentId]. The body
  /// is exactly `{studentId}`: no reason, no free text and no content is
  /// attached, because the operation accepts none. Answers `202`.
  ///
  /// 🔴 **`202` for EVERY well-formed id** - an unknown id, the caller's own id,
  /// a blocked student and a student on the other Track all get the identical
  /// answer, so this is not an existence oracle (adr-196 D4). A report is stored
  /// only for a real, different student, at most once per (reporter, reported);
  /// a repeat stores nothing. A success therefore proves nothing about the
  /// student, and a screen must not word it as a confirmation that a report was
  /// stored against them.
  ///
  /// Its rate limit is the CHAT write budget (30 per 60 seconds, shared with
  /// edit, delete and read), not the social one.
  Future<void> reportStudent(String studentId) => _guard(() async {
    await _dio.post<void>(
      '/student-reports',
      data: <String, dynamic>{'studentId': studentId},
    );
  });

  // -------------------------------------------------------------------------
  // Internals
  // -------------------------------------------------------------------------

  /// Decodes one list envelope, returned untouched so `hasMore` survives.
  CursorPage<T> _page<T>(
    Response<Map<String, dynamic>> res,
    T Function(Map<String, dynamic> json) fromJson,
  ) => CursorPage<T>.fromJson(
    res.data!,
    (json) => fromJson(json! as Map<String, dynamic>),
  );

  /// Runs [call] and keeps the typed boundary: a [DioException] becomes the
  /// [AppException] the ErrorInterceptor mapped onto it (or [UnknownException]
  /// if something bypassed the chain), and a decode failure - which happens
  /// OUTSIDE Dio - becomes an [UnknownException] carrying only the runtime
  /// type. A name, an id and a cursor are exactly what must never leak into an
  /// error detail.
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final err = e.error;
      throw err is AppException ? err : const UnknownException();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }
}

final friendsRepositoryProvider = Provider<FriendsRepository>(
  (ref) => FriendsRepository(ref.watch(dioProvider)),
);
