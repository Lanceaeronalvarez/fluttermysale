import 'package:json_annotation/json_annotation.dart';

part 'cart_promo_code_model.g.dart';

@JsonSerializable()
class CartPromoCode {
  @JsonKey(name: 'ID')
  final String? id;

  @JsonKey(name: 'Amount')
  final String? amount;

  @JsonKey(name: 'Code')
  final String? code;

  const CartPromoCode({this.id, this.amount, this.code});

  factory CartPromoCode.fromJson(Map<String, dynamic> json) =>
      _$CartPromoCodeFromJson(json);

  Map<String, dynamic> toJson() => _$CartPromoCodeToJson(this);
}
