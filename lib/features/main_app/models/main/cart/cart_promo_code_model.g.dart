// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_promo_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartPromoCode _$CartPromoCodeFromJson(Map<String, dynamic> json) =>
    CartPromoCode(
      id: json['ID'] as String?,
      amount: json['Amount'] as String?,
      code: json['Code'] as String?,
    );

Map<String, dynamic> _$CartPromoCodeToJson(CartPromoCode instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Amount': instance.amount,
      'Code': instance.code,
    };
