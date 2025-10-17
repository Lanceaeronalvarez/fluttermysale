import 'package:json_annotation/json_annotation.dart';

part 'cart_request_model.g.dart';

@JsonSerializable()
class CartRequest {
  @JsonKey(includeIfNull: true)
  CartDeliveryDetailsRequest? deliveryDetails;
  
  @JsonKey(defaultValue: 100)
  int imageSize;
  
  @JsonKey(defaultValue: 'EN')
  String languageID;
  
  String? itemID;

  CartRequest({
    this.deliveryDetails,
    this.imageSize = 100,
    required this.languageID,
    this.itemID,
  });

  factory CartRequest.fromJson(Map<String, dynamic> json) =>
      _$CartRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CartRequestToJson(this);
}

@JsonSerializable(includeIfNull: true)
class CartDeliveryDetailsRequest {
  @JsonKey(name: 'PickupPoint', includeIfNull: true)
  String? pickupPoint;

  @JsonKey(name: 'Postcode', includeIfNull: true)
  String? postcode;

  CartDeliveryDetailsRequest({this.pickupPoint, this.postcode});

  factory CartDeliveryDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$CartDeliveryDetailsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CartDeliveryDetailsRequestToJson(this);
}
