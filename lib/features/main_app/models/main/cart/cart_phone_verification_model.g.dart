// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_phone_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartPhoneVerification _$CartPhoneVerificationFromJson(
  Map<String, dynamic> json,
) => CartPhoneVerification(
  isRequired: json['IsRequired'] as bool?,
  fields: json['Fields'] == null
      ? null
      : CartPhoneVerificationFields.fromJson(
          json['Fields'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CartPhoneVerificationToJson(
  CartPhoneVerification instance,
) => <String, dynamic>{
  'IsRequired': instance.isRequired,
  'Fields': instance.fields,
};

CartPhoneVerificationFields _$CartPhoneVerificationFieldsFromJson(
  Map<String, dynamic> json,
) => CartPhoneVerificationFields(
  phoneNumberFormat: json['PhoneNumberFormat'] == null
      ? null
      : CartDecorationInfo.fromJson(
          json['PhoneNumberFormat'] as Map<String, dynamic>,
        ),
  verificationCodeFormat: json['VerificationCodeFormat'] == null
      ? null
      : CartDecorationInfo.fromJson(
          json['VerificationCodeFormat'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CartPhoneVerificationFieldsToJson(
  CartPhoneVerificationFields instance,
) => <String, dynamic>{
  'PhoneNumberFormat': instance.phoneNumberFormat,
  'VerificationCodeFormat': instance.verificationCodeFormat,
};
