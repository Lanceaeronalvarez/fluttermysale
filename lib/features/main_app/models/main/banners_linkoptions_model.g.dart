// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_linkoptions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkOptions _$LinkOptionsFromJson(Map<String, dynamic> json) => LinkOptions()
  ..facets = json['facets'] == null
      ? null
      : Facets.fromJson(json['facets'] as Map<String, dynamic>)
  ..sorting = json['sorting'] as String?
  ..category = (json['category'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  )
  ..searchQuery = json['searchQuery'] as String?;

Map<String, dynamic> _$LinkOptionsToJson(LinkOptions instance) =>
    <String, dynamic>{
      'facets': instance.facets,
      'sorting': instance.sorting,
      'category': instance.category,
      'searchQuery': instance.searchQuery,
    };

Facets _$FacetsFromJson(Map<String, dynamic> json) => Facets()
  ..brandName = (json['skus.brandName'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..sizes = (json['skus.attributes.size'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..colors = (json['color'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..priceLimit = json['skus.attributesForFaceting.aud'] == null
      ? null
      : PriceLimit.fromJson(
          json['skus.attributesForFaceting.aud'] as Map<String, dynamic>,
        )
  ..newArrivals = (json['newArrivals'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..delivery = (json['delivery'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..saleId = json['saleId'] as String?
  ..promoSaleId = json['promoSaleId'] as String?;

Map<String, dynamic> _$FacetsToJson(Facets instance) => <String, dynamic>{
  'skus.brandName': instance.brandName,
  'skus.attributes.size': instance.sizes,
  'color': instance.colors,
  'skus.attributesForFaceting.aud': instance.priceLimit,
  'newArrivals': instance.newArrivals,
  'delivery': instance.delivery,
  'saleId': instance.saleId,
  'promoSaleId': instance.promoSaleId,
};

PriceLimit _$PriceLimitFromJson(Map<String, dynamic> json) => PriceLimit()
  ..from = (json['from'] as num?)?.toInt()
  ..to = (json['to'] as num?)?.toInt()
  ..max = (json['max'] as num?)?.toInt();

Map<String, dynamic> _$PriceLimitToJson(PriceLimit instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'max': instance.max,
    };
