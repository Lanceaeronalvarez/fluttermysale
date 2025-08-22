import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'productitem_model.g.dart';

@JsonSerializable()
class ProductItem {
  String? id;
  String? name;
  String? brandName;
  String? description;
  String? labelText;
  Price? price;
  Price? originalPrice;
  PriceRange? priceRange;
  String? priceRangeText;
  List<String>? images;
  bool? isAvailable;
  String? priceDescription;
  List<String>? categories;
  List<Sku>? skus;
  String? seoIdentifier;
  bool? isSoldOut;
  int? salePercentOff;
  bool? isFreeDelivery;
  SalePrice? salePrice;
  String? salePercentOffText;
  int? deliveryThreshold;
  String? deliveryType;
  double? savedMoneyValue;
  double? totalPercentOff;

  ProductItem(
    this.id,
    this.name,
    this.brandName,
    this.description,
    this.labelText,
    this.price,
    this.originalPrice,
    this.priceRange,
    this.priceRangeText,
    this.images,
    this.isAvailable,
    this.priceDescription,
    this.categories,
    this.skus,
    this.seoIdentifier,
    this.isSoldOut,
    this.salePercentOff,
    this.isFreeDelivery,
    this.salePrice,
    this.salePercentOffText,
    this.deliveryThreshold,
    this.deliveryType,
    this.savedMoneyValue,
    this.totalPercentOff,
  );

  factory ProductItem.fromJson(Map<String, dynamic> json) =>
      _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);
}

@JsonSerializable()
class Price {
  String? currency;
  double? value;

  Price(this.currency, this.value);

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);

  Map<String, dynamic> toJson() => _$PriceToJson(this);
}

@JsonSerializable()
class PriceRange {
  String? currency;
  double? from;
  double? to;

  PriceRange(this.currency, this.from, this.to);

  factory PriceRange.fromJson(Map<String, dynamic> json) =>
      _$PriceRangeFromJson(json);

  Map<String, dynamic> toJson() => _$PriceRangeToJson(this);
}

@JsonSerializable()
class SalePrice extends Price {
  SalePrice(super.currency, super.value);

  factory SalePrice.fromJson(Map<String, dynamic> json) =>
      _$SalePriceFromJson(json);

  Map<String, dynamic> toJson() => _$SalePriceToJson(this);
}

@JsonSerializable()
class Sku {
  String? id;
  Attributes? attributes;
  String? name;
  String? description;
  String? labelText;
  Price? price;
  Price? originalPrice;
  int? quantity;
  List<String>? images = null;
  String? brandName;
  String? countryOfOrigin;
  String? shippingInformation;
  String? returnPolicy;
  String? pricing;
  String? seoUrl;
  String? seoIdentifier;

  Sku(
    this.id,
    this.attributes,
    this.name,
    this.description,
    this.labelText,
    this.price,
    this.originalPrice,
    this.quantity,
    this.images,
    this.brandName,
    this.countryOfOrigin,
    this.shippingInformation,
    this.returnPolicy,
    this.pricing,
    this.seoUrl,
    this.seoIdentifier,
  );

  factory Sku.fromJson(Map<String, dynamic> json) => _$SkuFromJson(json);

  Map<String, dynamic> toJson() => _$SkuToJson(this);
}

@JsonSerializable()
class Attributes {
  String? size;
  double? weight;
  double? height;
  double? width;
  String? brandDescription;
  String? productId;

  Attributes(
    this.size,
    this.weight,
    this.height,
    this.width,
    this.brandDescription,
    this.productId,
  );

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
