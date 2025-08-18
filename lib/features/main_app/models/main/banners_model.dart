import 'package:json_annotation/json_annotation.dart';

part 'banners_model.g.dart';

class GetBannersRequest {
  String? lastGroupType;
  String? offset;
  String? limit;
  String? category;
  String? saleCategoryID;
  String? categoryId;
  bool? includeCampaignBanners;
  bool? includePromoSales;
  String? bannergroups;

  GetBannersRequest(
    this.lastGroupType,
    this.offset,
    this.limit,
    this.category,
    this.saleCategoryID,
    this.categoryId,
    this.includeCampaignBanners,
    this.includePromoSales,
    this.bannergroups,
  );

  Map<String, dynamic> toMap() {
    return {
      'lastGroupType': lastGroupType,
      'offset': offset,
      'limit': limit,
      'category': category,
      'saleCategoryID': saleCategoryID,
      'includeCampaignBanners': includeCampaignBanners,
      'includePromoSales': includePromoSales,
      'bannergroups': bannergroups,
    };
  }
}

@JsonSerializable()
class GetBannersResponse {
  List<Group>? groups;

  GetBannersResponse();

  factory GetBannersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBannersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBannersResponseToJson(this);
}

@JsonSerializable()
class Group {
  @JsonKey(defaultValue: "")
  String? type;
  @JsonKey(defaultValue: "")
  String? title;
  @JsonKey(defaultValue: false)
  bool? isClickable;
  List<Banner>? banners;

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class Banner {
  String? id;
  String? accountId;
  bool? isAvailable;
  String? bannerText;
  String? description;
  String? startDate;
  String? endDate;
  String? destinationId;
  String? image;
  bool? hasImage;
  Attributes? attributes;
  List<String>? categories;
  String? bannerType;
  int? percentOff;
  bool? isFreeDelivery;
  String? percentOffText;
  String? link;
  int? deliveryThreshold;
  String? deliveryType;
  LinkOptions? linkOptions;

  Banner();

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);

  Map<String, dynamic> toJson() => _$BannerToJson(this);
}

@JsonSerializable()
class Attributes {
  String? saleExternalId;

  Attributes();

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}

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
