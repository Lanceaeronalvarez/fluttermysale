// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productdetail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    ProductDetail(
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
      countryOfOrigin: json['countryOfOrigin'] as String?,
      deliveryInformation: json['deliveryInformation'] as String?,
      shippingInformation: json['shippingInformation'] as String?,
      returnPolicy: json['returnPolicy'] as String?,
      pricing: json['pricing'] as String?,
      seoUrl: json['seoUrl'] as String?,
      rrpText: json['rrpText'] as String?,
      sellerName: json['sellerName'] as String?,
      showSellerLink: json['showSellerLink'] as bool?,
      sellerLinkTemplate: json['sellerLinkTemplate'] as String?,
      masterSkuId: json['masterSkuId'] as String?,
      sale: json['sale'] == null
          ? null
          : Sale.fromJson(json['sale'] as Map<String, dynamic>),
      personalizationSchema: json['personalizationSchema'],
      productId: json['productId'] as String?,
      supplier: json['supplier'] as String?,
      essentialStatus: json['essentialStatus'] as String?,
      taxonomy: (json['taxonomy'] as List<dynamic>?)
          ?.map((e) => Taxonomy.fromJson(e as Map<String, dynamic>))
          .toList(),
      seoStoreId: json['seoStoreId'] as String?,
      storeName: json['storeName'] as String?,
      isStoreAvailable: json['isStoreAvailable'] as bool?,
      skuVariants: (json['skuVariants'] as List<dynamic>?)
          ?.map((e) => SkuVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      buyBoxGroup: json['buyBoxGroup'] as List<dynamic>?,
    );

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
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
      'countryOfOrigin': instance.countryOfOrigin,
      'deliveryInformation': instance.deliveryInformation,
      'shippingInformation': instance.shippingInformation,
      'returnPolicy': instance.returnPolicy,
      'pricing': instance.pricing,
      'seoUrl': instance.seoUrl,
      'rrpText': instance.rrpText,
      'sellerName': instance.sellerName,
      'showSellerLink': instance.showSellerLink,
      'sellerLinkTemplate': instance.sellerLinkTemplate,
      'masterSkuId': instance.masterSkuId,
      'sale': instance.sale,
      'personalizationSchema': instance.personalizationSchema,
      'productId': instance.productId,
      'supplier': instance.supplier,
      'essentialStatus': instance.essentialStatus,
      'taxonomy': instance.taxonomy,
      'seoStoreId': instance.seoStoreId,
      'storeName': instance.storeName,
      'isStoreAvailable': instance.isStoreAvailable,
      'skuVariants': instance.skuVariants,
      'buyBoxGroup': instance.buyBoxGroup,
    };

Sale _$SaleFromJson(Map<String, dynamic> json) => Sale(
  json['externalId'] as String?,
  json['internalId'] as String?,
  json['internalIdSeo'] as String?,
  json['saleName'] as String?,
);

Map<String, dynamic> _$SaleToJson(Sale instance) => <String, dynamic>{
  'externalId': instance.externalId,
  'internalId': instance.internalId,
  'internalIdSeo': instance.internalIdSeo,
  'saleName': instance.saleName,
};

Taxonomy _$TaxonomyFromJson(Map<String, dynamic> json) =>
    Taxonomy(json['id'] as String?, json['category'] as String?);

Map<String, dynamic> _$TaxonomyToJson(Taxonomy instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
};

SkuVariant _$SkuVariantFromJson(Map<String, dynamic> json) => SkuVariant(
  json['skuId'] as String?,
  json['name'] as String?,
  json['price'] == null
      ? null
      : Price.fromJson(json['price'] as Map<String, dynamic>),
  json['attributes'] == null
      ? null
      : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
  json['isSoldOut'] as bool?,
);

Map<String, dynamic> _$SkuVariantToJson(SkuVariant instance) =>
    <String, dynamic>{
      'skuId': instance.skuId,
      'name': instance.name,
      'price': instance.price,
      'attributes': instance.attributes,
      'isSoldOut': instance.isSoldOut,
    };
