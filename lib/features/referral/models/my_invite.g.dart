// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyInvite _$MyInviteFromJson(Map<String, dynamic> json) => _MyInvite(
  code: json['code'] as String,
  friendsJoined: (json['friendsJoined'] as num).toInt(),
  pointsEarned: (json['pointsEarned'] as num).toInt(),
);

Map<String, dynamic> _$MyInviteToJson(_MyInvite instance) => <String, dynamic>{
  'code': instance.code,
  'friendsJoined': instance.friendsJoined,
  'pointsEarned': instance.pointsEarned,
};
