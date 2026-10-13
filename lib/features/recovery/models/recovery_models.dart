/// The response bodies of the lost-phone recovery ladder
/// (`contract/openapi.yaml:462-629`).
///
/// The ladder has four operations. Two of them answer with something a
/// recovery-specific model has to carry; the other two reuse types that already
/// exist, on purpose, so there is one definition of each:
///
/// | step | operation | answers with |
/// |---|---|---|
/// | 1 | `startRecovery` | [RecoveryStartResult] |
/// | 2 | `verifyParentOtp` | [ParentVerifiedResult] |
/// | 3 | `submitNewPhone` | `OtpRequestResult` (`{resendAfterSeconds, expiresInSeconds}`, the shape `requestOtp` already answers) |
/// | 4 | `confirmRecovery` | `AuthenticatedResult` (tokens + profile, the `verifyOtp` success arm) |
///
/// **Every value here is a secret or a student's data.** A recovery id and a
/// rebind token are bearer credentials for the next step; the masked parent
/// phone is a minor's guardian's number, partly shown. So each class overrides
/// [toString] to say its type and nothing else, and none of them is ever
/// logged, put in a URL, or kept past the flow that needs it.
///
/// Hand-written and strict, like the other response records: every field is
/// required by the contract, so a missing or mistyped one throws here and the
/// repository turns it into an `UnknownException`.
library;

import 'package:flutter/foundation.dart' show immutable;

/// The `200` body of `startRecovery` (`POST /auth/recovery/start`): the
/// one-time code has been sent to the account's PARENT phone.
@immutable
class RecoveryStartResult {
  const RecoveryStartResult({
    required this.recoveryId,
    required this.parentPhoneMasked,
    required this.resendAfterSeconds,
    required this.expiresInSeconds,
  });

  factory RecoveryStartResult.fromJson(Map<String, dynamic> json) =>
      RecoveryStartResult(
        recoveryId: json['recoveryId'] as String,
        parentPhoneMasked: json['parentPhoneMasked'] as String,
        resendAfterSeconds: json['resendAfterSeconds'] as int,
        expiresInSeconds: json['expiresInSeconds'] as int,
      );

  /// Names this recovery attempt in `verifyParentOtp` (contract `Uuid`).
  final String recoveryId;

  /// The parent's number, MASKED by the server ("never the full number"). It is
  /// shown as served, character for character; the app never completes,
  /// reformats or stores it.
  final String parentPhoneMasked;

  /// Seconds until the code may be requested again.
  final int resendAfterSeconds;

  /// Seconds the code stays valid.
  final int expiresInSeconds;

  @override
  bool operator ==(Object other) =>
      other is RecoveryStartResult &&
      other.recoveryId == recoveryId &&
      other.parentPhoneMasked == parentPhoneMasked &&
      other.resendAfterSeconds == resendAfterSeconds &&
      other.expiresInSeconds == expiresInSeconds;

  @override
  int get hashCode => Object.hash(
    recoveryId,
    parentPhoneMasked,
    resendAfterSeconds,
    expiresInSeconds,
  );

  @override
  String toString() => 'RecoveryStartResult()';
}

/// The `200` body of `verifyParentOtp` (`POST /auth/recovery/verify-parent`):
/// guardianship is proven, and a short-lived rebind token is issued.
@immutable
class ParentVerifiedResult {
  const ParentVerifiedResult({
    required this.rebindToken,
    required this.expiresInSeconds,
  });

  factory ParentVerifiedResult.fromJson(Map<String, dynamic> json) =>
      ParentVerifiedResult(
        rebindToken: json['rebindToken'] as String,
        expiresInSeconds: json['expiresInSeconds'] as int,
      );

  /// Authorises the last two steps (`submitNewPhone`, `confirmRecovery`). A
  /// credential: kept in memory for the flow, never written anywhere.
  final String rebindToken;

  /// Seconds the token stays valid. Past that, `registration_token_invalid`
  /// restarts the recovery from the top.
  final int expiresInSeconds;

  @override
  bool operator ==(Object other) =>
      other is ParentVerifiedResult &&
      other.rebindToken == rebindToken &&
      other.expiresInSeconds == expiresInSeconds;

  @override
  int get hashCode => Object.hash(rebindToken, expiresInSeconds);

  @override
  String toString() => 'ParentVerifiedResult()';
}
