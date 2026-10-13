import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_invite.freezed.dart';
part 'my_invite.g.dart';

/// The caller's own Refer a Friend record - contract `MyInvite`, the `200` of
/// `GET /me/invite` (`getMyInvite`, `x-stability: stable`, `openapi.yaml:1434`).
///
/// **Server-authoritative, displayed verbatim.** [code] is "shown exactly" as
/// the server sent it (eight characters from the Crockford-style alphabet,
/// digits and capital letters without I, L, O, U), so nothing here trims,
/// upper-cases or validates it. [friendsJoined] and [pointsEarned] are the
/// server's counts: the app never multiplies one by ten to derive the other
/// (`pointsEarned` can be LOWER than `10 x friendsJoined` - no credit while the
/// sharer had no active enrolment - and a new credit lands a few moments after
/// the friend registers).
///
/// Contract keys are already camelCase, so no `@JsonKey(name:)` bridge is
/// needed and none must be added. All three fields are `required` and none is
/// nullable: a response missing one is schema drift and fails to decode
/// (`ReferralRepository` turns that into an `UnknownException`).
///
/// **The code is never logged**, and that includes the implicit way: freezed
/// would otherwise generate a `toString()` that prints every field, so any
/// `'$invite'`, `print(invite)` or failing-test message would carry it. The
/// override below drops [code] from the string form. Nothing in the
/// `referral` feature logs at all (`referral_no_logging_test.dart`).
@freezed
abstract class MyInvite with _$MyInvite {
  const MyInvite._();

  const factory MyInvite({
    /// The invite code, exactly as the server sent it. One per student, created
    /// on the first call, never changes and cannot be regenerated (R9).
    required String code,

    /// New accounts that registered with [code]. Stays counted if that student
    /// later deletes their account.
    required int friendsJoined,

    /// Points the code has earned the caller. The server's figure, not
    /// `10 x friendsJoined`.
    required int pointsEarned,
  }) = _MyInvite;

  factory MyInvite.fromJson(Map<String, dynamic> json) =>
      _$MyInviteFromJson(json);

  /// Redacted: the code is the one thing here that identifies a student's
  /// referral link, so it must not reach a log line by accident.
  ///
  /// Built from [toJson] on purpose, not by naming the two counts in an
  /// interpolation: `contract_models_test.dart` decides whether this class
  /// "takes" a contract field by looking for the field's name in the class body,
  /// and a `$pointsEarned)` in a string would satisfy it even after the real
  /// parameter was dropped (a mutation probe found exactly that: the binding
  /// stayed green with the parameter renamed away).
  @override
  String toString() => 'MyInvite(${toJson()..remove('code')})';
}
