import 'package:json_annotation/json_annotation.dart';

part 'cart_delivery_service_package_detail_model.g.dart';

@JsonSerializable()
class CartDeliveryServicePackageDetail {
  @JsonKey(name: 'InitialCount')
  final double? initialCount;

  @JsonKey(name: 'RemainingCount')
  final double? remainingCount;

  @JsonKey(name: 'ExpiryDate')
  final String? expiryDate;

  @JsonKey(name: 'CurrentCount')
  final double? currentCount;

  @JsonKey(name: 'Amount')
  final double? amount;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Purchased')
  final bool? purchased;

  @JsonKey(name: 'DeliveryServicePackageDetailID')
  final String? deliveryServicePackageDetailId;

  const CartDeliveryServicePackageDetail({
    this.initialCount,
    this.remainingCount,
    this.expiryDate,
    this.currentCount,
    this.amount,
    this.name,
    this.purchased,
    this.deliveryServicePackageDetailId,
  });

  factory CartDeliveryServicePackageDetail.fromJson(
    Map<String, dynamic> json,
  ) => _$CartDeliveryServicePackageDetailFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CartDeliveryServicePackageDetailToJson(this);
}
