import 'package:json_annotation/json_annotation.dart';

part 'cart_delivery_option_model.g.dart';

@JsonSerializable()
class CartDeliveryOption {
  @JsonKey(name: 'DeliveryOptions')
  final List<String>? deliveryOptions;

  @JsonKey(name: 'PostServiceId')
  final String? postServiceId;

  @JsonKey(name: 'Price')
  final double? price;

  @JsonKey(name: 'Selected')
  final bool? selected;

  @JsonKey(name: 'IsAvailable')
  final bool? isAvailable;

  @JsonKey(name: 'Title')
  final String? title;

  const CartDeliveryOption({
    this.deliveryOptions,
    this.postServiceId,
    this.price,
    this.selected,
    this.isAvailable,
    this.title,
  });

  factory CartDeliveryOption.fromJson(Map<String, dynamic> json) =>
      _$CartDeliveryOptionFromJson(json);
  Map<String, dynamic> toJson() => _$CartDeliveryOptionToJson(this);
}