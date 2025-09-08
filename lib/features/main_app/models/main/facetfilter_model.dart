import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'facetfilter_model.g.dart';

@JsonSerializable(includeIfNull: false)
class FacetFilterModel {
  @JsonKey(name: "saleId")
  List<String>? saleId;
  @JsonKey(name: "promoSaleId")
  List<String>? promoSaleId;
  @JsonKey(name: "skus.brandName")
  List<String>? brands;
  @JsonKey(name: "color")
  List<String>? colors;
  @JsonKey(name: "skus.attributes.size")
  List<String>? sizes;
  @JsonKey(name: "skus.attributesForFaceting.aud")
  List<String>? price;
  @JsonKey(name: "delivery")
  List<String>? delivery;
  @JsonKey(name: "newArrivals")
  List<String>? newArrivals;
  @JsonKey(name: "storeId")
  List<String>? storeId;

  FacetFilterModel({
    List<String>? saleId,
    List<String>? promoSaleId,
    List<String>? brands,
    List<String>? colors,
    List<String>? sizes,
    List<String>? price,
    List<String>? delivery,
    List<String>? newArrivals,
    List<String>? storeId,
  }) {
    this.saleId = saleId;
    this.promoSaleId = promoSaleId;
    this.brands = brands;
    this.colors = colors;
    this.sizes = sizes;
    this.price = price;
    this.delivery = delivery;
    this.newArrivals = newArrivals;
    this.storeId = storeId;
  }

  factory FacetFilterModel.fromJson(Map<String, dynamic> json) =>
      _$FacetFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$FacetFilterModelToJson(this);
}
