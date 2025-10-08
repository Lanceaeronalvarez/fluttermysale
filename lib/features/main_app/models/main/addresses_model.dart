import 'package:json_annotation/json_annotation.dart';

part 'addresses_model.g.dart';

@JsonSerializable()
class GetAddressesResponse {
  final List<AddressItem>? addresses;
  @JsonKey(name: 'address_decorations')
  final List<AddressDecoration>? addressDecorations;

  GetAddressesResponse({this.addresses, this.addressDecorations});

  factory GetAddressesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAddressesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAddressesResponseToJson(this);
}

@JsonSerializable()
class AddressItem {
  final String? id;
  final String? name;
  final String? forename;
  final String? surname;
  @JsonKey(name: 'address_lines')
  final String? addressLines;
  final String? suburb;
  final String? city;
  final String? postcode;
  final String? phone;

  AddressItem({
    this.id,
    this.name,
    this.forename,
    this.surname,
    this.addressLines,
    this.suburb,
    this.city,
    this.postcode,
    this.phone,
  });

  factory AddressItem.fromJson(Map<String, dynamic> json) =>
      _$AddressItemFromJson(json);

  Map<String, dynamic> toJson() => _$AddressItemToJson(this);
}

@JsonSerializable()
class AddressDecoration {
  final String? label;
  final String? name;
  final String? type;
  @JsonKey(name: 'class')
  final String? fieldClass;
  final String? value;
  @JsonKey(name: 'max_length')
  final int? maxLength;
  @JsonKey(name: 'min_length')
  final int? minLength;
  final String? validate;
  @JsonKey(name: 'read_only')
  final bool? readOnly;
  @JsonKey(name: 'without_comma')
  final bool? withoutComma;
  final bool? validateConsistency;
  final String? regexp;
  final List<String>? options;
  @JsonKey(name: 'data_type')
  final String? dataType;

  AddressDecoration({
    this.label,
    this.name,
    this.type,
    this.fieldClass,
    this.value,
    this.maxLength,
    this.minLength,
    this.validate,
    this.readOnly,
    this.withoutComma,
    this.validateConsistency,
    this.regexp,
    this.options,
    this.dataType,
  });

  factory AddressDecoration.fromJson(Map<String, dynamic> json) =>
      _$AddressDecorationFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDecorationToJson(this);
}

@JsonSerializable()
class ApplyAddressRequest {
  final String? countryID;
  final String? languageID;
  final String? imageSize;
  final String? deliveryAddressID;

  ApplyAddressRequest({
    this.countryID,
    this.languageID,
    this.imageSize,
    this.deliveryAddressID,
  });

  factory ApplyAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyAddressRequestToJson(this);
}
