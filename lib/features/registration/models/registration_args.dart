import 'package:flutter/foundation.dart';

/// Payload carried from OTP (`registrationRequired` fork) → `/register` via the
/// router `extra`. It seeds [RegistrationController] with the token, its TTL, and
/// the proven phone.
///
/// `registrationToken` + `expiresInSeconds` come from the OTP verify result;
/// `phone` is the E.164 number the OTP step already proved — carried here so the
/// identity screen can show it read-only (conflict #2: it is never submitted).
///
/// Value equality lets the router pass it as `extra` and lets a re-entry compare
/// tokens to decide whether to re-seed the draft.
@immutable
class RegistrationArgs {
  const RegistrationArgs({
    required this.registrationToken,
    required this.expiresInSeconds,
    required this.phone,
  });

  final String registrationToken;
  final int expiresInSeconds;
  final String phone;

  @override
  bool operator ==(Object other) =>
      other is RegistrationArgs &&
      other.registrationToken == registrationToken &&
      other.expiresInSeconds == expiresInSeconds &&
      other.phone == phone;

  @override
  int get hashCode =>
      Object.hash(registrationToken, expiresInSeconds, phone);
}
