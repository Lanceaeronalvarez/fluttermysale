import 'package:json_annotation/json_annotation.dart';

part 'cart_voucher_model.g.dart';

@JsonSerializable()
class CartVoucher {
  @JsonKey(name: 'ID')
  final String? id;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  @JsonKey(name: 'Description')
  final String? description;

  @JsonKey(name: 'Activated')
  final bool? activated;

  @JsonKey(name: 'FirstPurchase')
  final bool? firstPurchase;

  @JsonKey(name: 'DiscountLeft')
  final String? discountLeft;

  @JsonKey(name: 'Expired')
  final String? expired;

  @JsonKey(name: 'DiscountGiven')
  final String? discountGiven;

  @JsonKey(name: 'Status')
  final String? status;

  const CartVoucher({
    this.id,
    this.fullname,
    this.description,
    this.activated,
    this.firstPurchase,
    this.discountLeft,
    this.expired,
    this.discountGiven,
    this.status,
  });

  factory CartVoucher.fromJson(Map<String, dynamic> json) =>
      _$CartVoucherFromJson(json);

  Map<String, dynamic> toJson() => _$CartVoucherToJson(this);
}