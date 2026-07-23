// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpRequestResult _$OtpRequestResultFromJson(Map<String, dynamic> json) =>
    _OtpRequestResult(
      resendAfterSeconds: (json['resendAfterSeconds'] as num).toInt(),
      expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$OtpRequestResultToJson(_OtpRequestResult instance) =>
    <String, dynamic>{
      'resendAfterSeconds': instance.resendAfterSeconds,
      'expiresInSeconds': instance.expiresInSeconds,
    };
