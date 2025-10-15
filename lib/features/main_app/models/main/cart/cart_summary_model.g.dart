// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartSummary _$CartSummaryFromJson(Map<String, dynamic> json) => CartSummary(
  subtotal: (json['Subtotal'] as num?)?.toDouble(),
  delivery: (json['Delivery'] as num?)?.toDouble(),
  amountToFreeDelivery: (json['AmountToFreeDelivery'] as num?)?.toDouble(),
  discount: (json['Discount'] as num?)?.toDouble(),
  total: (json['Total'] as num?)?.toDouble(),
  tax: (json['Tax'] as num?)?.toDouble(),
  select: (json['Select'] as num?)?.toDouble(),
  totalWithSelect: (json['TotalWithSelect'] as num?)?.toDouble(),
  estimateShipmentPostcode: json['EstimateShipmentPostcode'] as String?,
);

Map<String, dynamic> _$CartSummaryToJson(CartSummary instance) =>
    <String, dynamic>{
      'Subtotal': instance.subtotal,
      'Delivery': instance.delivery,
      'AmountToFreeDelivery': instance.amountToFreeDelivery,
      'Discount': instance.discount,
      'Total': instance.total,
      'Tax': instance.tax,
      'Select': instance.select,
      'TotalWithSelect': instance.totalWithSelect,
      'EstimateShipmentPostcode': instance.estimateShipmentPostcode,
    };
