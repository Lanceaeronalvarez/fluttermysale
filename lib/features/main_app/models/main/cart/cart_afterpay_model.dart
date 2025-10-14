import 'package:json_annotation/json_annotation.dart';

part 'cart_afterpay_model.g.dart';

@JsonSerializable()
class CartAfterpay {
  @JsonKey(name: 'IsAvailable', defaultValue: false)
  final bool isAvailable;

  @JsonKey(name: 'IsAvailableMobileApp', defaultValue: false)
  final bool isAvailableMobileApp;

  @JsonKey(name: 'Description')
  final String? description;

  const CartAfterpay({
    this.isAvailable = false,
    this.isAvailableMobileApp = false,
    this.description,
  });

  factory CartAfterpay.fromJson(Map<String, dynamic> json) =>
      _$CartAfterpayFromJson(json);

  Map<String, dynamic> toJson() => _$CartAfterpayToJson(this);
}
