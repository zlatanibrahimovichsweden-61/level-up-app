// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchoolSubjectTree _$SchoolSubjectTreeFromJson(Map<String, dynamic> json) =>
    _SchoolSubjectTree(
      track: $enumDecode(_$TrackEnumMap, json['track']),
      units: (json['units'] as List<dynamic>)
          .map((e) => Unit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchoolSubjectTreeToJson(_SchoolSubjectTree instance) =>
    <String, dynamic>{
      'track': _$TrackEnumMap[instance.track]!,
      'units': instance.units,
    };

const _$TrackEnumMap = {Track.school: 'school', Track.university: 'university'};

_Unit _$UnitFromJson(Map<String, dynamic> json) => _Unit(
  id: json['id'] as String,
  name: json['name'] as String,
  chapters: (json['chapters'] as List<dynamic>)
      .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UnitToJson(_Unit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'chapters': instance.chapters,
};

_Chapter _$ChapterFromJson(Map<String, dynamic> json) => _Chapter(
  id: json['id'] as String,
  name: json['name'] as String,
  lessons: (json['lessons'] as List<dynamic>)
      .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChapterToJson(_Chapter instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lessons': instance.lessons,
};

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  name: json['name'] as String,
  questionCounter: QuestionCounter.fromJson(
    json['questionCounter'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'questionCounter': instance.questionCounter,
};

_UniversitySubjectTree _$UniversitySubjectTreeFromJson(
  Map<String, dynamic> json,
) => _UniversitySubjectTree(
  track: $enumDecode(_$TrackEnumMap, json['track']),
  quizTypes: (json['quizTypes'] as List<dynamic>)
      .map((e) => $enumDecode(_$QuizTypeEnumMap, e))
      .toList(),
  lectures: (json['lectures'] as List<dynamic>)
      .map((e) => Lecture.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UniversitySubjectTreeToJson(
  _UniversitySubjectTree instance,
) => <String, dynamic>{
  'track': _$TrackEnumMap[instance.track]!,
  'quizTypes': instance.quizTypes.map((e) => _$QuizTypeEnumMap[e]!).toList(),
  'lectures': instance.lectures,
};

const _$QuizTypeEnumMap = {
  QuizType.normal: 'normal',
  QuizType.midTermRevision: 'midTermRevision',
  QuizType.finalRevision: 'finalRevision',
  QuizType.practicalRevision: 'practicalRevision',
};

_Lecture _$LectureFromJson(Map<String, dynamic> json) => _Lecture(
  id: json['id'] as String,
  name: json['name'] as String,
  questionCounter: QuestionCounter.fromJson(
    json['questionCounter'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$LectureToJson(_Lecture instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'questionCounter': instance.questionCounter,
};
