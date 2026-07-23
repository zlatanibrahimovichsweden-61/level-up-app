// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => _TokenPair(
  accessToken: json['accessToken'] as String,
  accessExpiresInSeconds: (json['accessExpiresInSeconds'] as num).toInt(),
  refreshToken: json['refreshToken'] as String,
  refreshExpiresInSeconds: (json['refreshExpiresInSeconds'] as num).toInt(),
);

Map<String, dynamic> _$TokenPairToJson(_TokenPair instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'accessExpiresInSeconds': instance.accessExpiresInSeconds,
      'refreshToken': instance.refreshToken,
      'refreshExpiresInSeconds': instance.refreshExpiresInSeconds,
    };
