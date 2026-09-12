// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mistakes_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchoolMistakesTree _$SchoolMistakesTreeFromJson(Map<String, dynamic> json) =>
    _SchoolMistakesTree(
      track: $enumDecode(_$TrackEnumMap, json['track']),
      mistakeCount: (json['mistakeCount'] as num).toInt(),
      units: (json['units'] as List<dynamic>)
          .map((e) => MistakesUnit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchoolMistakesTreeToJson(_SchoolMistakesTree instance) =>
    <String, dynamic>{
      'track': _$TrackEnumMap[instance.track]!,
      'mistakeCount': instance.mistakeCount,
      'units': instance.units,
    };

const _$TrackEnumMap = {Track.school: 'school', Track.university: 'university'};

_MistakesUnit _$MistakesUnitFromJson(Map<String, dynamic> json) =>
    _MistakesUnit(
      id: json['id'] as String,
      name: json['name'] as String,
      mistakeCount: (json['mistakeCount'] as num).toInt(),
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => MistakesChapter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MistakesUnitToJson(_MistakesUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mistakeCount': instance.mistakeCount,
      'chapters': instance.chapters,
    };

_MistakesChapter _$MistakesChapterFromJson(Map<String, dynamic> json) =>
    _MistakesChapter(
      id: json['id'] as String,
      name: json['name'] as String,
      mistakeCount: (json['mistakeCount'] as num).toInt(),
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => MistakesLesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MistakesChapterToJson(_MistakesChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mistakeCount': instance.mistakeCount,
      'lessons': instance.lessons,
    };

_MistakesLesson _$MistakesLessonFromJson(Map<String, dynamic> json) =>
    _MistakesLesson(
      id: json['id'] as String,
      name: json['name'] as String,
      mistakeCount: (json['mistakeCount'] as num).toInt(),
    );

Map<String, dynamic> _$MistakesLessonToJson(_MistakesLesson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mistakeCount': instance.mistakeCount,
    };

_UniversityMistakesTree _$UniversityMistakesTreeFromJson(
  Map<String, dynamic> json,
) => _UniversityMistakesTree(
  track: $enumDecode(_$TrackEnumMap, json['track']),
  mistakeCount: (json['mistakeCount'] as num).toInt(),
  lectures: (json['lectures'] as List<dynamic>)
      .map((e) => MistakesLecture.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UniversityMistakesTreeToJson(
  _UniversityMistakesTree instance,
) => <String, dynamic>{
  'track': _$TrackEnumMap[instance.track]!,
  'mistakeCount': instance.mistakeCount,
  'lectures': instance.lectures,
};

_MistakesLecture _$MistakesLectureFromJson(Map<String, dynamic> json) =>
    _MistakesLecture(
      id: json['id'] as String,
      name: json['name'] as String,
      mistakeCount: (json['mistakeCount'] as num).toInt(),
    );

Map<String, dynamic> _$MistakesLectureToJson(_MistakesLecture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mistakeCount': instance.mistakeCount,
    };
