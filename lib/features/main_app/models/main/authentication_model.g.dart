// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginEmailRequest _$LoginEmailRequestFromJson(Map<String, dynamic> json) =>
    LoginEmailRequest(
      countryID: json['countryID'] as String?,
      userName: json['userName'] as String?,
      password: json['password'] as String?,
      languageID: json['languageID'] as String?,
      captchaResponse: json['captchaResponse'] as String?,
      clientID: (json['clientID'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginEmailRequestToJson(LoginEmailRequest instance) =>
    <String, dynamic>{
      'countryID': instance.countryID,
      'userName': instance.userName,
      'password': instance.password,
      'languageID': instance.languageID,
      'captchaResponse': instance.captchaResponse,
      'clientID': instance.clientID,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      json['d'] == null
          ? null
          : LoginResponseValue.fromJson(json['d'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{'d': instance.d};

LoginResponseValue _$LoginResponseValueFromJson(Map<String, dynamic> json) =>
    LoginResponseValue(
      json['Value'] == null
          ? null
          : Value.fromJson(json['Value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseValueToJson(LoginResponseValue instance) =>
    <String, dynamic>{'Value': instance.value};

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
  Ticket: json['Ticket'] as String?,
  ReadTerms: json['ReadTerms'] as bool?,
);

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
  'Ticket': instance.Ticket,
  'ReadTerms': instance.ReadTerms,
};
