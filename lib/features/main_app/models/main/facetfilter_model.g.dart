// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facetfilter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacetFilterModel _$ProductListFacetModelFromJson(
  Map<String, dynamic> json,
) => FacetFilterModel(
  json['name'] as String?,
  (json['values'] as List<dynamic>?)
      ?.map((e) => FacetFilterValueModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductListFacetModelToJson(
  FacetFilterModel instance,
) => <String, dynamic>{'name': instance.name, 'values': instance.values};

FacetFilterValueModel _$ValueFromJson(Map<String, dynamic> json) =>
    FacetFilterValueModel(json['value'] as String?, (json['count'] as num?)?.toInt());

Map<String, dynamic> _$ValueToJson(FacetFilterValueModel instance) => <String, dynamic>{
  'value': instance.value,
  'count': instance.count,
};
