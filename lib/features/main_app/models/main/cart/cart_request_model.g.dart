// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartRequest _$CartRequestFromJson(Map<String, dynamic> json) => CartRequest(
  deliveryDetails: json['deliveryDetails'] == null
      ? null
      : CartDeliveryDetailsRequest.fromJson(
          json['deliveryDetails'] as Map<String, dynamic>,
        ),
  imageSize: (json['imageSize'] as num?)?.toInt() ?? 100,
  languageID: json['languageID'] as String? ?? 'EN',
  itemID: json['itemID'] as String?,
);

Map<String, dynamic> _$CartRequestToJson(CartRequest instance) =>
    <String, dynamic>{
      'deliveryDetails': instance.deliveryDetails,
      'imageSize': instance.imageSize,
      'languageID': instance.languageID,
      'itemID': instance.itemID,
    };

CartDeliveryDetailsRequest _$CartDeliveryDetailsRequestFromJson(
  Map<String, dynamic> json,
) => CartDeliveryDetailsRequest(
  pickupPoint: json['PickupPoint'] as String?,
  postcode: json['Postcode'] as String?,
);

Map<String, dynamic> _$CartDeliveryDetailsRequestToJson(
  CartDeliveryDetailsRequest instance,
) => <String, dynamic>{
  'PickupPoint': instance.pickupPoint,
  'Postcode': instance.postcode,
};
