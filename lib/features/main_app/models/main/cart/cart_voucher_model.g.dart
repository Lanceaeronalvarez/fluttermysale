// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartVoucher _$CartVoucherFromJson(Map<String, dynamic> json) => CartVoucher(
  id: json['ID'] as String?,
  fullname: json['Fullname'] as String?,
  description: json['Description'] as String?,
  activated: json['Activated'] as bool?,
  firstPurchase: json['FirstPurchase'] as bool?,
  discountLeft: json['DiscountLeft'] as String?,
  expired: json['Expired'] as String?,
  discountGiven: json['DiscountGiven'] as String?,
  status: json['Status'] as String?,
);

Map<String, dynamic> _$CartVoucherToJson(CartVoucher instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Fullname': instance.fullname,
      'Description': instance.description,
      'Activated': instance.activated,
      'FirstPurchase': instance.firstPurchase,
      'DiscountLeft': instance.discountLeft,
      'Expired': instance.expired,
      'DiscountGiven': instance.discountGiven,
      'Status': instance.status,
    };
