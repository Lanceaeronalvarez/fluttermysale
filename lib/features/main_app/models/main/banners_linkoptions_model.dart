import 'package:json_annotation/json_annotation.dart';

part 'banners_linkoptions_model.g.dart';

@JsonSerializable()
class LinkOptions {
  Facets? facets;
  String? sorting;
  Map<String, String>? category;
  String? searchQuery;

  LinkOptions();

  factory LinkOptions.fromJson(Map<String, dynamic> json) =>
      _$LinkOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$LinkOptionsToJson(this);

  LinkOptionType getLinkOptionType() {
    if (category != null) {
      return LinkOptionType.category;
    } else if (facets != null) {
      if (facets?.saleId != null) {
        return LinkOptionType.sale;
      } else if (facets?.promoSaleId != null) {
        return LinkOptionType.promo;
      }
    }
    return LinkOptionType.unknown;
  }
}

@JsonSerializable()
class Facets {
  @JsonKey(name: "skus.brandName")
  List<String>? brandName;
  @JsonKey(name: "skus.attributes.size")
  List<String>? sizes;
  @JsonKey(name: "color")
  List<String>? colors;
  @JsonKey(name: "skus.attributesForFaceting.aud")
  PriceLimit? priceLimit;
  List<String>? newArrivals;
  List<String>? delivery;
  String? saleId;
  String? promoSaleId;

  Facets();

  factory Facets.fromJson(Map<String, dynamic> json) => _$FacetsFromJson(json);

  Map<String, dynamic> toJson() => _$FacetsToJson(this);
}

@JsonSerializable()
class PriceLimit {
  int? from;
  int? to;
  int? max;

  PriceLimit();

  factory PriceLimit.fromJson(Map<String, dynamic> json) =>
      _$PriceLimitFromJson(json);

  Map<String, dynamic> toJson() => _$PriceLimitToJson(this);
}

enum LinkOptionType { category, sale, promo, unknown }