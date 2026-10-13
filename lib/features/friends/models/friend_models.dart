import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_models.freezed.dart';
part 'friend_models.g.dart';

/// `direction` on `GET /friend-requests` and on every [FriendRequest]
/// (`openapi.yaml:3115-3155`, `:4693-4704`): the contract's closed enum
/// `[incoming, outgoing]`.
///
/// `incoming` is a request sent TO the caller; `outgoing` is one the caller
/// sent. The wire names are already the Dart member names, so
/// json_serializable maps them directly - no `@JsonValue` bridge, per the
/// project's no-key-bridge rule. The contract does not mark this set
/// extensible (contrast `EntitlementType`), so an unknown value is contract
/// drift and throws rather than being coerced; the repository wraps that into
/// a typed `UnknownException`.
enum FriendRequestDirection {
  incoming,
  outgoing;

  /// The wire value - what `GET /friend-requests` takes as `direction`.
  String get wire => name;
}

/// `SendFriendRequestResult.status` (`openapi.yaml:4705-4714`): the closed
/// enum `[pending, accepted]`.
///
/// `pending` - the request was created. `accepted` - the other student had
/// already asked, so the two are now friends (adr-185 D7). Same strictness as
/// [FriendRequestDirection].
enum SendFriendRequestStatus { pending, accepted }

/// Another student as the friend-graph surfaces show them (`StudentCard`,
/// `openapi.yaml:4665-4674`): suggestions, requests and blocks.
///
/// **Name and avatar only** - never points, level or any phone digits
/// (adr-185 D4/D5). All three fields are `required` in the contract and all
/// three are required here: a missing one throws, and the repository wraps that
/// into a typed `UnknownException`.
///
/// [studentId] is the only handle: it is what `sendFriendRequest`,
/// `blockStudent`, `unblockStudent`, `removeFriend` and `reportStudent` take.
/// [name] is a student's own display name (user-generated content) and [avatarUrl]
/// is a URI the server issued.
///
/// `toString` is redacted: a card is a minor's name and id, and the project
/// rule is that neither reaches a log, an error detail or a test report by
/// accident. Equality is the generated field-by-field one.
@freezed
abstract class StudentCard with _$StudentCard {
  const StudentCard._();

  const factory StudentCard({
    required String studentId,
    required String name,
    required String avatarUrl,
  }) = _StudentCard;

  factory StudentCard.fromJson(Map<String, dynamic> json) =>
      _$StudentCardFromJson(json);

  @override
  String toString() => 'StudentCard(<redacted>)';
}

/// One of the caller's friends (`Friend`, `openapi.yaml:4675-4692`), from
/// `GET /friends`, `POST /friend-requests/{requestId}/accept` and the
/// `accepted` arm of `POST /friend-requests`.
///
/// Five fields are `required`: [studentId], [name], [avatarUrl], [level] and
/// [friendsSince]. [level] is the same number the friend sees on their own
/// `GET /me`; it is displayed, never derived.
///
/// 🔴 **[points] is nullable on purpose.** The contract OMITS it when the
/// friend has `scoreHidden` (adr-023/111/113) **and** whenever that setting
/// cannot be read. So `null` means "this app is not shown a score" - it is
/// never `0`, and a screen must not render a number for it.
///
/// [friendsSince] is the server's instant (normally UTC); call `.toLocal()`
/// before formatting it for display.
///
/// `toString` is redacted to whether a score is shown.
@freezed
abstract class Friend with _$Friend {
  const Friend._();

  const factory Friend({
    required String studentId,
    required String name,
    required String avatarUrl,
    required int level,
    int? points,
    required DateTime friendsSince,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  // Deliberately names no field the contract marks `required`: the contract-
  // models guard looks for each such name inside this class's source, and a
  // `$level,` here would satisfy it even with the real parameter deleted.
  @override
  String toString() => 'Friend(hasPoints: ${points != null})';
}

/// One pending friend request, seen from the caller's side (`FriendRequest`,
/// `openapi.yaml:4693-4704`).
///
/// All four fields are `required`. [student] is the OTHER party, whichever
/// [direction] the request has. [requestId] is the handle `cancelFriendRequest`
/// (outgoing only), `acceptFriendRequest` and `declineFriendRequest` (incoming
/// only) take; it is not a student id.
///
/// [createdAt] is the server's instant (normally UTC); call `.toLocal()`
/// before formatting it for display.
///
/// `toString` is redacted to the direction.
@freezed
abstract class FriendRequest with _$FriendRequest {
  const FriendRequest._();

  const factory FriendRequest({
    required String requestId,
    required FriendRequestDirection direction,
    required StudentCard student,
    required DateTime createdAt,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  @override
  String toString() => 'FriendRequest(direction: ${direction.name})';
}

/// The answer to `POST /friend-requests` (`SendFriendRequestResult`,
/// `openapi.yaml:4705-4714`): `201` either way.
///
/// - [status] `pending` - the request was created and [request] is present.
/// - [status] `accepted` - the other student had already asked, so the two are
///   now friends and [friend] is present (adr-185 D7).
///
/// Only [status] is `required` on the wire; [request] and [friend] are each
/// present for exactly one status, per the contract's own description. They are
/// decoded as the contract states them and no stronger rule is invented here -
/// a consumer that needs one reads it through the status.
///
/// `toString` is redacted to the status.
@freezed
abstract class SendFriendRequestResult with _$SendFriendRequestResult {
  const SendFriendRequestResult._();

  const factory SendFriendRequestResult({
    required SendFriendRequestStatus status,
    FriendRequest? request,
    Friend? friend,
  }) = _SendFriendRequestResult;

  factory SendFriendRequestResult.fromJson(Map<String, dynamic> json) =>
      _$SendFriendRequestResultFromJson(json);

  /// True when the request was created and is waiting for the other student.
  bool get isPending => status == SendFriendRequestStatus.pending;

  /// True when the other student had already asked and the two are now friends.
  bool get isAccepted => status == SendFriendRequestStatus.accepted;

  @override
  String toString() => 'SendFriendRequestResult(status: ${status.name})';
}
