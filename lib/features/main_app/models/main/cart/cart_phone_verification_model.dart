import 'package:flutter_mysale/features/main_app/models/main/cart/cart_decoration_info_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_phone_verification_model.g.dart';

@JsonSerializable()
class CartPhoneVerification {
  @JsonKey(name: 'IsRequired')
  final bool? isRequired;

  @JsonKey(name: 'Fields')
  final CartPhoneVerificationFields? fields;

  const CartPhoneVerification({this.isRequired, this.fields});

  factory CartPhoneVerification.fromJson(Map<String, dynamic> json) =>
      _$CartPhoneVerificationFromJson(json);

  Map<String, dynamic> toJson() => _$CartPhoneVerificationToJson(this);
}

@JsonSerializable()
class CartPhoneVerificationFields {
  @JsonKey(name: 'PhoneNumberFormat')
  final CartDecorationInfo? phoneNumberFormat;

  @JsonKey(name: 'VerificationCodeFormat')
  final CartDecorationInfo? verificationCodeFormat;

  const CartPhoneVerificationFields({
    this.phoneNumberFormat,
    this.verificationCodeFormat,
  });

  factory CartPhoneVerificationFields.fromJson(Map<String, dynamic> json) =>
      _$CartPhoneVerificationFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$CartPhoneVerificationFieldsToJson(this);
}
