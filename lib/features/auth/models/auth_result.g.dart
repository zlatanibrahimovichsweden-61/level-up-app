// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticatedResult _$AuthenticatedResultFromJson(Map<String, dynamic> json) =>
    AuthenticatedResult(
      tokens: TokenPair.fromJson(json['tokens'] as Map<String, dynamic>),
      profile: json['profile'] as Map<String, dynamic>,
      inviteCodeApplied: json['inviteCodeApplied'] as bool?,
      $type: json['result'] as String?,
    );

Map<String, dynamic> _$AuthenticatedResultToJson(
  AuthenticatedResult instance,
) => <String, dynamic>{
  'tokens': instance.tokens,
  'profile': instance.profile,
  'inviteCodeApplied': ?instance.inviteCodeApplied,
  'result': instance.$type,
};

RegistrationRequiredResult _$RegistrationRequiredResultFromJson(
  Map<String, dynamic> json,
) => RegistrationRequiredResult(
  registrationToken: json['registrationToken'] as String,
  expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
  $type: json['result'] as String?,
);

Map<String, dynamic> _$RegistrationRequiredResultToJson(
  RegistrationRequiredResult instance,
) => <String, dynamic>{
  'registrationToken': instance.registrationToken,
  'expiresInSeconds': instance.expiresInSeconds,
  'result': instance.$type,
};
