// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_delivery_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDeliveryOption _$CartDeliveryOptionFromJson(Map<String, dynamic> json) =>
    CartDeliveryOption(
      deliveryOptions: (json['DeliveryOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      postServiceId: json['PostServiceId'] as String?,
      price: (json['Price'] as num?)?.toDouble(),
      selected: json['Selected'] as bool?,
      isAvailable: json['IsAvailable'] as bool?,
      title: json['Title'] as String?,
    );

Map<String, dynamic> _$CartDeliveryOptionToJson(CartDeliveryOption instance) =>
    <String, dynamic>{
      'DeliveryOptions': instance.deliveryOptions,
      'PostServiceId': instance.postServiceId,
      'Price': instance.price,
      'Selected': instance.selected,
      'IsAvailable': instance.isAvailable,
      'Title': instance.title,
    };
