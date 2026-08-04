// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntitlementState _$EntitlementStateFromJson(Map<String, dynamic> json) =>
    _EntitlementState(
      type: $enumDecode(
        _$EntitlementTypeEnumMap,
        json['type'],
        unknownValue: EntitlementType.unknown,
      ),
      active: json['active'] as bool,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      inGrace: json['inGrace'] as bool,
      graceEndsAt: json['graceEndsAt'] == null
          ? null
          : DateTime.parse(json['graceEndsAt'] as String),
    );

Map<String, dynamic> _$EntitlementStateToJson(_EntitlementState instance) =>
    <String, dynamic>{
      'type': _$EntitlementTypeEnumMap[instance.type]!,
      'active': instance.active,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'inGrace': instance.inGrace,
      'graceEndsAt': instance.graceEndsAt?.toIso8601String(),
    };

const _$EntitlementTypeEnumMap = {
  EntitlementType.baseSubscription: 'baseSubscription',
  EntitlementType.flashcardSubscription: 'flashcardSubscription',
  EntitlementType.unknown: 'unknown',
};

_EntitlementsResponse _$EntitlementsResponseFromJson(
  Map<String, dynamic> json,
) => _EntitlementsResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => EntitlementState.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EntitlementsResponseToJson(
  _EntitlementsResponse instance,
) => <String, dynamic>{'items': instance.items};
