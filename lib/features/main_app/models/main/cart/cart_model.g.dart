// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartValue _$CartValueFromJson(Map<String, dynamic> json) => CartValue(
  isEmpty: json['IsEmpty'] as bool? ?? false,
  itemsCount: (json['ItemsCount'] as num?)?.toInt() ?? 0,
  isAgeRestricted: json['IsAgeRestricted'] as bool? ?? false,
  threeDSecureRequired: json['ThreeDSecureRequired'] as bool? ?? false,
  shipments: (json['Shipments'] as List<dynamic>?)
      ?.map((e) => CartShipment.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: json['Summary'] == null
      ? null
      : CartSummary.fromJson(json['Summary'] as Map<String, dynamic>),
  deliveryAddress: json['DeliveryAddress'] == null
      ? null
      : CartDeliveryAddress.fromJson(
          json['DeliveryAddress'] as Map<String, dynamic>,
        ),
  deliveryOptions: (json['DeliveryOptions'] as List<dynamic>?)
      ?.map((e) => CartDeliveryOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  deliverySerivePackageDetail: json['DeliveryServicePackageDetail'] == null
      ? null
      : CartDeliveryServicePackageDetail.fromJson(
          json['DeliveryServicePackageDetail'] as Map<String, dynamic>,
        ),
  availablePaymentOptions: (json['AvailablePaymentOptions'] as List<dynamic>?)
      ?.map(
        (e) => CartAvailablePaymentOption.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  afterpay: json['Afterpay'] == null
      ? null
      : CartAfterpay.fromJson(json['Afterpay'] as Map<String, dynamic>),
  decorationInfoList: (json['DecorationInfoList'] as List<dynamic>?)
      ?.map((e) => CartDecorationInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  vouchers: (json['Vouchers'] as List<dynamic>?)
      ?.map((e) => CartVoucher.fromJson(e as Map<String, dynamic>))
      .toList(),
  promoCodeList: (json['PromoCodeList'] as List<dynamic>?)
      ?.map((e) => CartPromoCode.fromJson(e as Map<String, dynamic>))
      .toList(),
  appliedVoucherId: json['VoucherID'] as String?,
  phoneVerification: json['PhoneVerification'] == null
      ? null
      : CartPhoneVerification.fromJson(
          json['PhoneVerification'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CartValueToJson(CartValue instance) => <String, dynamic>{
  'IsEmpty': instance.isEmpty,
  'ItemsCount': instance.itemsCount,
  'IsAgeRestricted': instance.isAgeRestricted,
  'ThreeDSecureRequired': instance.threeDSecureRequired,
  'Shipments': instance.shipments,
  'Summary': instance.summary,
  'DeliveryAddress': instance.deliveryAddress,
  'DeliveryOptions': instance.deliveryOptions,
  'DeliveryServicePackageDetail': instance.deliverySerivePackageDetail,
  'AvailablePaymentOptions': instance.availablePaymentOptions,
  'Afterpay': instance.afterpay,
  'DecorationInfoList': instance.decorationInfoList,
  'Vouchers': instance.vouchers,
  'PromoCodeList': instance.promoCodeList,
  'VoucherID': instance.appliedVoucherId,
  'PhoneVerification': instance.phoneVerification,
};
