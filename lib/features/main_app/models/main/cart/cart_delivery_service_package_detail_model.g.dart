// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_delivery_service_package_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDeliveryServicePackageDetail _$CartDeliveryServicePackageDetailFromJson(
  Map<String, dynamic> json,
) => CartDeliveryServicePackageDetail(
  initialCount: (json['InitialCount'] as num?)?.toDouble(),
  remainingCount: (json['RemainingCount'] as num?)?.toDouble(),
  expiryDate: json['ExpiryDate'] as String?,
  currentCount: (json['CurrentCount'] as num?)?.toDouble(),
  amount: (json['Amount'] as num?)?.toDouble(),
  name: json['Name'] as String?,
  purchased: json['Purchased'] as bool?,
  deliveryServicePackageDetailId:
      json['DeliveryServicePackageDetailID'] as String?,
);

Map<String, dynamic> _$CartDeliveryServicePackageDetailToJson(
  CartDeliveryServicePackageDetail instance,
) => <String, dynamic>{
  'InitialCount': instance.initialCount,
  'RemainingCount': instance.remainingCount,
  'ExpiryDate': instance.expiryDate,
  'CurrentCount': instance.currentCount,
  'Amount': instance.amount,
  'Name': instance.name,
  'Purchased': instance.purchased,
  'DeliveryServicePackageDetailID': instance.deliveryServicePackageDetailId,
};
