import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_request_model.g.dart';

@JsonSerializable()
class AddToCartRequest {
  String skuID;
  int userClientType;

  AddToCartRequest({required this.skuID, required this.userClientType});

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddToCartRequestToJson(this);
}
