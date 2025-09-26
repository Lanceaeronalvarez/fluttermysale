// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBannersResponse _$GetBannersResponseFromJson(Map<String, dynamic> json) =>
    GetBannersResponse()
      ..groups = (json['groups'] as List<dynamic>?)
          ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GetBannersResponseToJson(GetBannersResponse instance) =>
    <String, dynamic>{'groups': instance.groups};

Group _$GroupFromJson(Map<String, dynamic> json) => Group()
  ..type = json['type'] as String? ?? ''
  ..title = json['title'] as String? ?? ''
  ..isClickable = json['isClickable'] as bool? ?? false
  ..banners = (json['banners'] as List<dynamic>?)
      ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
  'type': instance.type,
  'title': instance.title,
  'isClickable': instance.isClickable,
  'banners': instance.banners,
};

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel()
  ..id = json['id'] as String?
  ..accountId = json['accountId'] as String?
  ..isAvailable = json['isAvailable'] as bool?
  ..bannerText = json['bannerText'] as String?
  ..description = json['description'] as String?
  ..startDate = json['startDate'] as String?
  ..endDate = json['endDate'] as String?
  ..destinationId = json['destinationId'] as String?
  ..image = json['image'] as String?
  ..hasImage = json['hasImage'] as bool?
  ..attributes = json['attributes'] == null
      ? null
      : Attributes.fromJson(json['attributes'] as Map<String, dynamic>)
  ..categories = (json['categories'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..bannerType = json['bannerType'] as String?
  ..percentOff = (json['percentOff'] as num?)?.toInt()
  ..isFreeDelivery = json['isFreeDelivery'] as bool?
  ..percentOffText = json['percentOffText'] as String?
  ..link = json['link'] as String?
  ..deliveryThreshold = (json['deliveryThreshold'] as num?)?.toInt()
  ..deliveryType = json['deliveryType'] as String?
  ..linkOptions = json['linkOptions'] == null
      ? null
      : LinkOptions.fromJson(json['linkOptions'] as Map<String, dynamic>);

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'isAvailable': instance.isAvailable,
      'bannerText': instance.bannerText,
      'description': instance.description,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'destinationId': instance.destinationId,
      'image': instance.image,
      'hasImage': instance.hasImage,
      'attributes': instance.attributes,
      'categories': instance.categories,
      'bannerType': instance.bannerType,
      'percentOff': instance.percentOff,
      'isFreeDelivery': instance.isFreeDelivery,
      'percentOffText': instance.percentOffText,
      'link': instance.link,
      'deliveryThreshold': instance.deliveryThreshold,
      'deliveryType': instance.deliveryType,
      'linkOptions': instance.linkOptions,
    };

Attributes _$AttributesFromJson(Map<String, dynamic> json) =>
    Attributes()..saleExternalId = json['saleExternalId'] as String?;

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{'saleExternalId': instance.saleExternalId};
