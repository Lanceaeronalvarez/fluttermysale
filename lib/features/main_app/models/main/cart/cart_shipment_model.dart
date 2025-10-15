import 'package:flutter_mysale/features/main_app/models/main/cart/cart_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_shipment_model.g.dart';

@JsonSerializable()
class CartShipment {
  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'DeliveryPrice')
  final double? deliveryPrice;

  @JsonKey(name: 'MinimumSpendForPromoPrice')
  final double? minimumSpendForPromoPrice;

  @JsonKey(name: 'AmountToPromoPrice')
  final double? amountToPromoPrice;

  @JsonKey(name: 'Items', fromJson: _parseItems, toJson: _itemsToJson)
  final List<CartItem>? items;

  @JsonKey(name: 'LocationFilterHash')
  final String? locationFilterHash;

  @JsonKey(name: 'SaleId')
  final String? saleId;

  @JsonKey(name: 'EstimateShipmentPostcode')
  final String? estimateShipmentPostcode;

  @JsonKey(name: 'ShippingAvailability')
  final bool? shippingAvailability;

  @JsonKey(name: 'MinimumDeliveryPriceThreshold')
  final double? minimumDeliveryPriceThreshold;

  @JsonKey(name: 'PromoPriceThresholdSource')
  final int? promoPriceThresholdSource;

  @JsonKey(name: 'CanSelectBeApplied')
  final bool? canSelectBeApplied;

  CartShipment({
    required this.name,
    this.deliveryPrice,
    this.minimumSpendForPromoPrice,
    this.amountToPromoPrice,
    this.items,
    this.locationFilterHash,
    this.saleId,
    this.estimateShipmentPostcode,
    this.shippingAvailability,
    this.minimumDeliveryPriceThreshold,
    this.promoPriceThresholdSource,
    this.canSelectBeApplied,
  });

  factory CartShipment.fromJson(Map<String, dynamic> json) =>
      _$CartShipmentFromJson(json);
  Map<String, dynamic> toJson() => _$CartShipmentToJson(this);
}

List<CartItem>? _parseItems(dynamic raw) => (raw as List<dynamic>?)
    ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
    .toList();

Object? _itemsToJson(List<CartItem>? list) =>
    list?.map((e) => e.toJson()).toList();