// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_delivery_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDeliveryAddress _$CartDeliveryAddressFromJson(Map<String, dynamic> json) =>
    CartDeliveryAddress(
      id: json['ID'] as String?,
      name: json['Name'] as String?,
      forename: json['Forename'] as String?,
      surname: json['Surname'] as String?,
      phone: json['Phone'] as String?,
      state: json['State'] as String?,
      city: json['City'] as String?,
      suburb: json['Suburb'] as String?,
      postcode: json['Postcode'] as String?,
      addressLines: json['AddressLines'] as String?,
      authToLeave: json['AuthToLeave'] as bool? ?? false,
      authComment: json['AuthComment'] as String?,
      additionalData: json['AdditionalData'] as String?,
    );

Map<String, dynamic> _$CartDeliveryAddressToJson(
  CartDeliveryAddress instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Name': instance.name,
  'Forename': instance.forename,
  'Surname': instance.surname,
  'Phone': instance.phone,
  'State': instance.state,
  'City': instance.city,
  'Suburb': instance.suburb,
  'Postcode': instance.postcode,
  'AddressLines': instance.addressLines,
  'AuthToLeave': instance.authToLeave,
  'AuthComment': instance.authComment,
  'AdditionalData': instance.additionalData,
};
