import 'package:flutter_mysale/features/main_app/models/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'productdetail_model.g.dart';

@JsonSerializable()
class ProductDetail extends ProductItem {
  final String? countryOfOrigin;
  final String? deliveryInformation;
  final String? shippingInformation;
  final String? returnPolicy;
  final String? pricing;
  final String? seoUrl;
  final String? rrpText;
  final String? sellerName;
  final bool? showSellerLink;
  final String? sellerLinkTemplate;
  final String? masterSkuId;
  final Sale? sale;
  final dynamic personalizationSchema;
  final String? productId;
  final String? supplier;
  final String? essentialStatus;
  final List<Taxonomy>? taxonomy;
  final String? seoStoreId;
  final String? storeName;
  final bool? isStoreAvailable;
  //TODO skuVariants: change to list of ProductDetail
  final List<SkuVariant>? skuVariants;
  final List<dynamic>? buyBoxGroup;

  ProductDetail(
    super.id,
    super.name,
    super.brandName,
    super.description,
    super.labelText,
    super.price,
    super.originalPrice,
    super.priceRange,
    super.priceRangeText,
    super.images,
    super.isAvailable,
    super.priceDescription,
    super.categories,
    super.skus,
    super.seoIdentifier,
    super.isSoldOut,
    super.salePercentOff,
    super.isFreeDelivery,
    super.salePrice,
    super.salePercentOffText,
    super.deliveryThreshold,
    super.deliveryType,
    super.savedMoneyValue,
    super.totalPercentOff, {

    // ProductDetail-specific fields
    this.countryOfOrigin,
    this.deliveryInformation,
    this.shippingInformation,
    this.returnPolicy,
    this.pricing,
    this.seoUrl,
    this.rrpText,
    this.sellerName,
    this.showSellerLink,
    this.sellerLinkTemplate,
    this.masterSkuId,
    this.sale,
    this.personalizationSchema,
    this.productId,
    this.supplier,
    this.essentialStatus,
    this.taxonomy,
    this.seoStoreId,
    this.storeName,
    this.isStoreAvailable,
    this.skuVariants,
    this.buyBoxGroup,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    final productItem = ProductItem.fromJson(json);

    return ProductDetail(
      productItem.id,
      productItem.name,
      productItem.brandName,
      productItem.description,
      productItem.labelText,
      productItem.price,
      productItem.originalPrice,
      productItem.priceRange,
      productItem.priceRangeText,
      productItem.images,
      productItem.isAvailable,
      productItem.priceDescription,
      productItem.categories,
      productItem.skus,
      productItem.seoIdentifier,
      productItem.isSoldOut,
      productItem.salePercentOff,
      productItem.isFreeDelivery,
      productItem.salePrice,
      productItem.salePercentOffText,
      productItem.deliveryThreshold,
      productItem.deliveryType,
      productItem.savedMoneyValue,
      productItem.totalPercentOff,
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
  }

  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);
}

extension ProductDetailMapper on ProductDetail {
  static ProductDetail fromProductItem(ProductItem item) {
    return ProductDetail(
      item.id,
      item.name,
      item.brandName,
      item.description,
      item.labelText,
      item.price,
      item.originalPrice,
      item.priceRange,
      item.priceRangeText,
      item.images,
      item.isAvailable,
      item.priceDescription,
      item.categories,
      item.skus,
      item.seoIdentifier,
      item.isSoldOut,
      item.salePercentOff,
      item.isFreeDelivery,
      item.salePrice,
      item.salePercentOffText,
      item.deliveryThreshold,
      item.deliveryType,
      item.savedMoneyValue,
      item.totalPercentOff,

      // default null for fields unique to ProductDetail
      countryOfOrigin: null,
      deliveryInformation: null,
      shippingInformation: null,
      returnPolicy: null,
      pricing: null,
      seoUrl: null,
      rrpText: null,
      sellerName: null,
      showSellerLink: null,
      sellerLinkTemplate: null,
      masterSkuId: null,
      sale: null,
      personalizationSchema: null,
      productId: item.id?.toString(),
      supplier: null,
      essentialStatus: null,
      taxonomy: null,
      seoStoreId: null,
      storeName: null,
      isStoreAvailable: null,
      skuVariants: null,
      buyBoxGroup: null,
    );
  }
}

@JsonSerializable()
class Sale {
  final String? externalId;
  final String? internalId;
  final String? internalIdSeo;
  final String? saleName;

  Sale(this.externalId, this.internalId, this.internalIdSeo, this.saleName);

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

  Map<String, dynamic> toJson() => _$SaleToJson(this);
}

@JsonSerializable()
class Taxonomy {
  final String? id;
  final String? category;

  Taxonomy(this.id, this.category);

  factory Taxonomy.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyToJson(this);
}

@JsonSerializable()
class SkuVariant {
  final String? skuId;
  final String? name;
  final Price? price;
  final Attributes? attributes;
  final bool? isSoldOut;

  SkuVariant(
    this.skuId,
    this.name,
    this.price,
    this.attributes,
    this.isSoldOut,
  );

  factory SkuVariant.fromJson(Map<String, dynamic> json) =>
      _$SkuVariantFromJson(json);

  Map<String, dynamic> toJson() => _$SkuVariantToJson(this);
}
