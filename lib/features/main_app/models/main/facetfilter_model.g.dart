// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facetfilter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacetFilterModel _$FacetFilterModelFromJson(
  Map<String, dynamic> json,
) => FacetFilterModel(
  saleId: (json['saleId'] as List<dynamic>?)?.map((e) => e as String).toList(),
  promoSaleId: (json['promoSaleId'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  brands: (json['skus.brandName'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  colors: (json['color'] as List<dynamic>?)?.map((e) => e as String).toList(),
  sizes: (json['skus.attributes.size'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  price: (json['skus.attributesForFaceting.aud'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  delivery: (json['delivery'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  newArrivals: (json['newArrivals'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  storeId: (json['storeId'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FacetFilterModelToJson(FacetFilterModel instance) =>
    <String, dynamic>{
      'saleId': ?instance.saleId,
      'promoSaleId': ?instance.promoSaleId,
      'skus.brandName': ?instance.brands,
      'color': ?instance.colors,
      'skus.attributes.size': ?instance.sizes,
      'skus.attributesForFaceting.aud': ?instance.price,
      'delivery': ?instance.delivery,
      'newArrivals': ?instance.newArrivals,
      'storeId': ?instance.storeId,
    };
