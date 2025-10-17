// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartRequest _$AddToCartRequestFromJson(Map<String, dynamic> json) =>
    AddToCartRequest(
      skuID: json['skuID'] as String,
      userClientType: (json['userClientType'] as num).toInt(),
    );

Map<String, dynamic> _$AddToCartRequestToJson(AddToCartRequest instance) =>
    <String, dynamic>{
      'skuID': instance.skuID,
      'userClientType': instance.userClientType,
    };
