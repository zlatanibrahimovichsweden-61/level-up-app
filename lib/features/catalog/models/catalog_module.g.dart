// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogModule _$CatalogModuleFromJson(Map<String, dynamic> json) =>
    _CatalogModule(
      id: json['id'] as String,
      name: json['name'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      termId: json['termId'] as String?,
      termNumber: (json['termNumber'] as num?)?.toInt(),
      subjectIds: (json['subjectIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CatalogModuleToJson(_CatalogModule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayOrder': instance.displayOrder,
      'termId': instance.termId,
      'termNumber': instance.termNumber,
      'subjectIds': instance.subjectIds,
    };
