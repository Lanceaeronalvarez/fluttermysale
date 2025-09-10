// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productlistfacet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListFacetModel _$ProductListFacetModelFromJson(
  Map<String, dynamic> json,
) => ProductListFacetModel(
  json['name'] as String?,
  (json['values'] as List<dynamic>?)
      ?.map((e) => Value.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductListFacetModelToJson(
  ProductListFacetModel instance,
) => <String, dynamic>{'name': instance.name, 'values': instance.values};

Value _$ValueFromJson(Map<String, dynamic> json) =>
    Value(json['value'] as String?, (json['count'] as num?)?.toInt());

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
  'value': instance.value,
  'count': instance.count,
};
