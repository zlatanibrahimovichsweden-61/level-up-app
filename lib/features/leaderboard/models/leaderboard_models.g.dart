// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    _LeaderboardEntry(
      rank: (json['rank'] as num).toInt(),
      studentId: json['studentId'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      points: (json['points'] as num).toInt(),
      isMe: json['isMe'] as bool,
    );

Map<String, dynamic> _$LeaderboardEntryToJson(_LeaderboardEntry instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'studentId': instance.studentId,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'points': instance.points,
      'isMe': instance.isMe,
    };
