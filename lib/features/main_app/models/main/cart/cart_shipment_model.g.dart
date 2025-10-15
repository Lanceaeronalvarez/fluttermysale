// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_shipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartShipment _$CartShipmentFromJson(Map<String, dynamic> json) => CartShipment(
  name: json['Name'] as String,
  deliveryPrice: (json['DeliveryPrice'] as num?)?.toDouble(),
  minimumSpendForPromoPrice: (json['MinimumSpendForPromoPrice'] as num?)
      ?.toDouble(),
  amountToPromoPrice: (json['AmountToPromoPrice'] as num?)?.toDouble(),
  items: _parseItems(json['Items']),
  locationFilterHash: json['LocationFilterHash'] as String?,
  saleId: json['SaleId'] as String?,
  estimateShipmentPostcode: json['EstimateShipmentPostcode'] as String?,
  shippingAvailability: json['ShippingAvailability'] as bool?,
  minimumDeliveryPriceThreshold: (json['MinimumDeliveryPriceThreshold'] as num?)
      ?.toDouble(),
  promoPriceThresholdSource: (json['PromoPriceThresholdSource'] as num?)
      ?.toInt(),
  canSelectBeApplied: json['CanSelectBeApplied'] as bool?,
);

Map<String, dynamic> _$CartShipmentToJson(CartShipment instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'DeliveryPrice': instance.deliveryPrice,
      'MinimumSpendForPromoPrice': instance.minimumSpendForPromoPrice,
      'AmountToPromoPrice': instance.amountToPromoPrice,
      'Items': _itemsToJson(instance.items),
      'LocationFilterHash': instance.locationFilterHash,
      'SaleId': instance.saleId,
      'EstimateShipmentPostcode': instance.estimateShipmentPostcode,
      'ShippingAvailability': instance.shippingAvailability,
      'MinimumDeliveryPriceThreshold': instance.minimumDeliveryPriceThreshold,
      'PromoPriceThresholdSource': instance.promoPriceThresholdSource,
      'CanSelectBeApplied': instance.canSelectBeApplied,
    };
