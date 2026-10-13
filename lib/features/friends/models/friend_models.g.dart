// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentCard _$StudentCardFromJson(Map<String, dynamic> json) => _StudentCard(
  studentId: json['studentId'] as String,
  name: json['name'] as String,
  avatarUrl: json['avatarUrl'] as String,
);

Map<String, dynamic> _$StudentCardToJson(_StudentCard instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
    };

_Friend _$FriendFromJson(Map<String, dynamic> json) => _Friend(
  studentId: json['studentId'] as String,
  name: json['name'] as String,
  avatarUrl: json['avatarUrl'] as String,
  level: (json['level'] as num).toInt(),
  points: (json['points'] as num?)?.toInt(),
  friendsSince: DateTime.parse(json['friendsSince'] as String),
);

Map<String, dynamic> _$FriendToJson(_Friend instance) => <String, dynamic>{
  'studentId': instance.studentId,
  'name': instance.name,
  'avatarUrl': instance.avatarUrl,
  'level': instance.level,
  'points': instance.points,
  'friendsSince': instance.friendsSince.toIso8601String(),
};

_FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    _FriendRequest(
      requestId: json['requestId'] as String,
      direction: $enumDecode(
        _$FriendRequestDirectionEnumMap,
        json['direction'],
      ),
      student: StudentCard.fromJson(json['student'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FriendRequestToJson(_FriendRequest instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'direction': _$FriendRequestDirectionEnumMap[instance.direction]!,
      'student': instance.student,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FriendRequestDirectionEnumMap = {
  FriendRequestDirection.incoming: 'incoming',
  FriendRequestDirection.outgoing: 'outgoing',
};

_SendFriendRequestResult _$SendFriendRequestResultFromJson(
  Map<String, dynamic> json,
) => _SendFriendRequestResult(
  status: $enumDecode(_$SendFriendRequestStatusEnumMap, json['status']),
  request: json['request'] == null
      ? null
      : FriendRequest.fromJson(json['request'] as Map<String, dynamic>),
  friend: json['friend'] == null
      ? null
      : Friend.fromJson(json['friend'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SendFriendRequestResultToJson(
  _SendFriendRequestResult instance,
) => <String, dynamic>{
  'status': _$SendFriendRequestStatusEnumMap[instance.status]!,
  'request': instance.request,
  'friend': instance.friend,
};

const _$SendFriendRequestStatusEnumMap = {
  SendFriendRequestStatus.pending: 'pending',
  SendFriendRequestStatus.accepted: 'accepted',
};
