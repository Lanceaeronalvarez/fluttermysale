import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'banners_linkoptions_model.dart';

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
    Map<String, dynamic> map = {
      'lastGroupType': lastGroupType,
      'offset': offset,
      'limit': limit,
      'category': category,
      'saleCategoryID': saleCategoryID,
      'includeCampaignBanners': includeCampaignBanners,
      'includePromoSales': includePromoSales,
      'bannergroups': bannergroups,
    };
    map.removeWhere((k, v) => (v == null));
    return map;
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
  List<BannerModel>? banners;

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class BannerModel {
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

  BannerModel();

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

  @override
  String toString() {
    var encoder = JsonEncoder.withIndent("   ");
    return encoder.convert(toJson());
  }
}

@JsonSerializable()
class Attributes {
  String? saleExternalId;

  Attributes();

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}