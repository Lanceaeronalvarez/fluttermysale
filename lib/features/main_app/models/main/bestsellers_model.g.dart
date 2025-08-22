// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bestsellers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBestSellersResponse _$GetBestSellersResponseFromJson(
  Map<String, dynamic> json,
) => GetBestSellersResponse(
  json['masterProductId'] as String?,
  json['id'] as String?,
  json['name'] as String?,
  json['brandName'] as String?,
  json['description'] as String?,
  json['labelText'] as String?,
  json['price'] == null
      ? null
      : Price.fromJson(json['price'] as Map<String, dynamic>),
  json['originalPrice'] == null
      ? null
      : Price.fromJson(json['originalPrice'] as Map<String, dynamic>),
  json['priceRange'] == null
      ? null
      : PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>),
  json['priceRangeText'] as String?,
  (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  json['isAvailable'] as bool?,
  json['priceDescription'] as String?,
  (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList(),
  (json['skus'] as List<dynamic>?)
      ?.map((e) => Sku.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['seoIdentifier'] as String?,
  json['isSoldOut'] as bool?,
  (json['salePercentOff'] as num?)?.toInt(),
  json['isFreeDelivery'] as bool?,
  json['salePrice'] == null
      ? null
      : SalePrice.fromJson(json['salePrice'] as Map<String, dynamic>),
  json['salePercentOffText'] as String?,
  (json['deliveryThreshold'] as num?)?.toInt(),
  json['deliveryType'] as String?,
  (json['savedMoneyValue'] as num?)?.toDouble(),
  (json['totalPercentOff'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GetBestSellersResponseToJson(
  GetBestSellersResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'brandName': instance.brandName,
  'description': instance.description,
  'labelText': instance.labelText,
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'priceRange': instance.priceRange,
  'priceRangeText': instance.priceRangeText,
  'images': instance.images,
  'isAvailable': instance.isAvailable,
  'priceDescription': instance.priceDescription,
  'categories': instance.categories,
  'skus': instance.skus,
  'seoIdentifier': instance.seoIdentifier,
  'isSoldOut': instance.isSoldOut,
  'salePercentOff': instance.salePercentOff,
  'isFreeDelivery': instance.isFreeDelivery,
  'salePrice': instance.salePrice,
  'salePercentOffText': instance.salePercentOffText,
  'deliveryThreshold': instance.deliveryThreshold,
  'deliveryType': instance.deliveryType,
  'savedMoneyValue': instance.savedMoneyValue,
  'totalPercentOff': instance.totalPercentOff,
  'masterProductId': instance.masterProductId,
};
