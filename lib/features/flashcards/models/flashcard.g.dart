// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlashcardCard _$FlashcardCardFromJson(Map<String, dynamic> json) =>
    _FlashcardCard(
      id: json['id'] as String,
      front: json['front'] as String,
      back: json['back'] as String,
      imageUrl: json['imageUrl'] as String?,
      selfGrade: $enumDecodeNullable(
        _$FlashcardSelfGradeEnumMap,
        json['selfGrade'],
      ),
    );

Map<String, dynamic> _$FlashcardCardToJson(_FlashcardCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'front': instance.front,
      'back': instance.back,
      'imageUrl': instance.imageUrl,
      'selfGrade': _$FlashcardSelfGradeEnumMap[instance.selfGrade],
    };

const _$FlashcardSelfGradeEnumMap = {
  FlashcardSelfGrade.gotIt: 'gotIt',
  FlashcardSelfGrade.again: 'again',
};
