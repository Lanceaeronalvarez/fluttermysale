// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addresses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAddressesResponse _$GetAddressesResponseFromJson(
  Map<String, dynamic> json,
) => GetAddressesResponse(
  addresses: (json['addresses'] as List<dynamic>?)
      ?.map((e) => AddressItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  addressDecorations: (json['address_decorations'] as List<dynamic>?)
      ?.map((e) => AddressDecoration.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetAddressesResponseToJson(
  GetAddressesResponse instance,
) => <String, dynamic>{
  'addresses': instance.addresses,
  'address_decorations': instance.addressDecorations,
};

AddressItem _$AddressItemFromJson(Map<String, dynamic> json) => AddressItem(
  id: json['id'] as String?,
  name: json['name'] as String?,
  forename: json['forename'] as String?,
  surname: json['surname'] as String?,
  addressLines: json['address_lines'] as String?,
  suburb: json['suburb'] as String?,
  city: json['city'] as String?,
  postcode: json['postcode'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$AddressItemToJson(AddressItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'forename': instance.forename,
      'surname': instance.surname,
      'address_lines': instance.addressLines,
      'suburb': instance.suburb,
      'city': instance.city,
      'postcode': instance.postcode,
      'phone': instance.phone,
    };

AddressDecoration _$AddressDecorationFromJson(Map<String, dynamic> json) =>
    AddressDecoration(
      label: json['label'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      fieldClass: json['class'] as String?,
      value: json['value'] as String?,
      maxLength: (json['max_length'] as num?)?.toInt(),
      minLength: (json['min_length'] as num?)?.toInt(),
      validate: json['validate'] as String?,
      readOnly: json['read_only'] as bool?,
      withoutComma: json['without_comma'] as bool?,
      validateConsistency: json['validateConsistency'] as bool?,
      regexp: json['regexp'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dataType: json['data_type'] as String?,
    );

Map<String, dynamic> _$AddressDecorationToJson(AddressDecoration instance) =>
    <String, dynamic>{
      'label': instance.label,
      'name': instance.name,
      'type': instance.type,
      'class': instance.fieldClass,
      'value': instance.value,
      'max_length': instance.maxLength,
      'min_length': instance.minLength,
      'validate': instance.validate,
      'read_only': instance.readOnly,
      'without_comma': instance.withoutComma,
      'validateConsistency': instance.validateConsistency,
      'regexp': instance.regexp,
      'options': instance.options,
      'data_type': instance.dataType,
    };

ApplyAddressRequest _$ApplyAddressRequestFromJson(Map<String, dynamic> json) =>
    ApplyAddressRequest(
      countryID: json['countryID'] as String?,
      languageID: json['languageID'] as String?,
      imageSize: json['imageSize'] as String?,
      deliveryAddressID: json['deliveryAddressID'] as String?,
    );

Map<String, dynamic> _$ApplyAddressRequestToJson(
  ApplyAddressRequest instance,
) => <String, dynamic>{
  'countryID': instance.countryID,
  'languageID': instance.languageID,
  'imageSize': instance.imageSize,
  'deliveryAddressID': instance.deliveryAddressID,
};
