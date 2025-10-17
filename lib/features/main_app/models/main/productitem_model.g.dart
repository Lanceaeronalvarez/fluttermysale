// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productitem_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItem _$ProductItemFromJson(Map<String, dynamic> json) => ProductItem(
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

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
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
    };

Price _$PriceFromJson(Map<String, dynamic> json) =>
    Price(json['currency'] as String?, (json['value'] as num?)?.toDouble());

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
  'currency': instance.currency,
  'value': instance.value,
};

PriceRange _$PriceRangeFromJson(Map<String, dynamic> json) => PriceRange(
  json['currency'] as String?,
  (json['from'] as num?)?.toDouble(),
  (json['to'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PriceRangeToJson(PriceRange instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'from': instance.from,
      'to': instance.to,
    };

SalePrice _$SalePriceFromJson(Map<String, dynamic> json) =>
    SalePrice(json['currency'] as String?, (json['value'] as num?)?.toDouble());

Map<String, dynamic> _$SalePriceToJson(SalePrice instance) => <String, dynamic>{
  'currency': instance.currency,
  'value': instance.value,
};

Sku _$SkuFromJson(Map<String, dynamic> json) => Sku(
  json['id'] as String?,
  json['attributes'] == null
      ? null
      : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
  json['name'] as String?,
  json['description'] as String?,
  json['labelText'] as String?,
  json['price'] == null
      ? null
      : Price.fromJson(json['price'] as Map<String, dynamic>),
  json['originalPrice'] == null
      ? null
      : Price.fromJson(json['originalPrice'] as Map<String, dynamic>),
  (json['quantity'] as num?)?.toInt(),
  (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  json['brandName'] as String?,
  json['countryOfOrigin'] as String?,
  json['shippingInformation'] as String?,
  json['returnPolicy'] as String?,
  json['pricing'] as String?,
  json['seoUrl'] as String?,
  json['seoIdentifier'] as String?,
);

Map<String, dynamic> _$SkuToJson(Sku instance) => <String, dynamic>{
  'id': instance.id,
  'attributes': instance.attributes,
  'name': instance.name,
  'description': instance.description,
  'labelText': instance.labelText,
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'quantity': instance.quantity,
  'images': instance.images,
  'brandName': instance.brandName,
  'countryOfOrigin': instance.countryOfOrigin,
  'shippingInformation': instance.shippingInformation,
  'returnPolicy': instance.returnPolicy,
  'pricing': instance.pricing,
  'seoUrl': instance.seoUrl,
  'seoIdentifier': instance.seoIdentifier,
};

Attributes _$AttributesFromJson(Map<String, dynamic> json) => Attributes(
  json['size'] as String?,
  json['weight'] as String?,
  json['height'] as String?,
  json['width'] as String?,
  json['brandDescription'] as String?,
  json['productId'] as String?,
);

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{
      'size': instance.size,
      'weight': instance.weight,
      'height': instance.height,
      'width': instance.width,
      'brandDescription': instance.brandDescription,
      'productId': instance.productId,
    };
