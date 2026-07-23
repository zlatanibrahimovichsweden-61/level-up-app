import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_request_result.freezed.dart';
part 'otp_request_result.g.dart';

/// The `202` body of `POST /auth/otp/request`. Both fields are contract-required.
/// Carried to the OTP screen: `resendAfterSeconds` seeds the resend countdown,
/// `expiresInSeconds` is how long the code stays valid.
@freezed
abstract class OtpRequestResult with _$OtpRequestResult {
  const factory OtpRequestResult({
    required int resendAfterSeconds,
    required int expiresInSeconds,
  }) = _OtpRequestResult;

  factory OtpRequestResult.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestResultFromJson(json);
}
