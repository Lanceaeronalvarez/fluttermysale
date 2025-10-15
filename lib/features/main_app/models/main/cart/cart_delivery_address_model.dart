import 'package:json_annotation/json_annotation.dart';

part 'cart_delivery_address_model.g.dart';

@JsonSerializable()
class CartDeliveryAddress {
  @JsonKey(name: 'ID')
  final String? id;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Forename')
  final String? forename;

  @JsonKey(name: 'Surname')
  final String? surname;

  @JsonKey(name: 'Phone')
  final String? phone;

  @JsonKey(name: 'State')
  final String? state;

  @JsonKey(name: 'City')
  final String? city;

  @JsonKey(name: 'Suburb')
  final String? suburb;

  @JsonKey(name: 'Postcode')
  final String? postcode;

  @JsonKey(name: 'AddressLines')
  final String? addressLines;

  // Required (non-nullable) with default false when JSON key missing
  @JsonKey(name: 'AuthToLeave', defaultValue: false)
  final bool authToLeave;

  @JsonKey(name: 'AuthComment')
  final String? authComment;

  @JsonKey(name: 'AdditionalData')
  final String? additionalData;

  const CartDeliveryAddress({
    this.id,
    this.name,
    this.forename,
    this.surname,
    this.phone,
    this.state,
    this.city,
    this.suburb,
    this.postcode,
    this.addressLines,
    this.authToLeave = false, // default if constructed manually
    this.authComment,
    this.additionalData,
  });

  factory CartDeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$CartDeliveryAddressFromJson(json);
  Map<String, dynamic> toJson() => _$CartDeliveryAddressToJson(this);
}
