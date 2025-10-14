import 'package:json_annotation/json_annotation.dart';

part 'cart_summary_model.g.dart';

@JsonSerializable()
class CartSummary {
  @JsonKey(name: 'Subtotal')
  final double? subtotal;

  @JsonKey(name: 'Delivery')
  final double? delivery;

  @JsonKey(name: 'AmountToFreeDelivery')
  final double? amountToFreeDelivery;

  @JsonKey(name: 'Discount')
  final double? discount;

  @JsonKey(name: 'Total')
  final double? total;

  @JsonKey(name: 'Tax')
  final double? tax;

  @JsonKey(name: 'Select')
  final double? select;

  @JsonKey(name: 'TotalWithSelect')
  final double? totalWithSelect;

  @JsonKey(name: 'EstimateShipmentPostcode')
  final String? estimateShipmentPostcode;

  CartSummary({
    this.subtotal,
    this.delivery,
    this.amountToFreeDelivery,
    this.discount,
    this.total,
    this.tax,
    this.select,
    this.totalWithSelect,
    this.estimateShipmentPostcode,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$CartSummaryToJson(this);
}
