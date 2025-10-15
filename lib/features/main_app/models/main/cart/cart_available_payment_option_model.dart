import 'package:json_annotation/json_annotation.dart';

part 'cart_available_payment_option_model.g.dart';

@JsonSerializable()
class CartAvailablePaymentOption {
  @JsonKey(name: 'Name')
  final String? name;

  const CartAvailablePaymentOption({this.name});

  factory CartAvailablePaymentOption.fromJson(Map<String, dynamic> json) =>
      _$CartAvailablePaymentOptionFromJson(json);

  Map<String, dynamic> toJson() => _$CartAvailablePaymentOptionToJson(this);
}
