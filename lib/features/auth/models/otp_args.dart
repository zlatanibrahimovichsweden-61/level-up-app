import 'package:flutter/foundation.dart';

/// Payload carried from Login → OTP via the router `extra`, and used as the
/// `otpProvider` family key. Needs value equality so the family caches one
/// notifier per (phone, timing) tuple.
///
/// `phone` is already normalized E.164. `resendAfterSeconds` seeds the resend
/// countdown; `expiresInSeconds` is the code's validity window.
@immutable
class OtpArgs {
  const OtpArgs({
    required this.phone,
    required this.resendAfterSeconds,
    required this.expiresInSeconds,
  });

  final String phone;
  final int resendAfterSeconds;
  final int expiresInSeconds;

  @override
  bool operator ==(Object other) =>
      other is OtpArgs &&
      other.phone == phone &&
      other.resendAfterSeconds == resendAfterSeconds &&
      other.expiresInSeconds == expiresInSeconds;

  @override
  int get hashCode => Object.hash(phone, resendAfterSeconds, expiresInSeconds);
}
