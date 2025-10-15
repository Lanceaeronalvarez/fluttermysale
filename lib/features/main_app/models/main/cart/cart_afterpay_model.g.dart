// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_afterpay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartAfterpay _$CartAfterpayFromJson(Map<String, dynamic> json) => CartAfterpay(
  isAvailable: json['IsAvailable'] as bool? ?? false,
  isAvailableMobileApp: json['IsAvailableMobileApp'] as bool? ?? false,
  description: json['Description'] as String?,
);

Map<String, dynamic> _$CartAfterpayToJson(CartAfterpay instance) =>
    <String, dynamic>{
      'IsAvailable': instance.isAvailable,
      'IsAvailableMobileApp': instance.isAvailableMobileApp,
      'Description': instance.description,
    };
