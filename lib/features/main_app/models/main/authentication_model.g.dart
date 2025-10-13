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

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      languageID: json['languageID'] as String?,
      countryID: json['countryID'] as String?,
      clientType: (json['clientType'] as num?)?.toInt(),
      clientID: (json['clientID'] as num?)?.toInt(),
      foreName: json['foreName'] as String?,
      surName: json['surName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      referredBy: json['referredBy'] as String?,
      invitedBy: json['invitedBy'] as String?,
      voucherID: json['voucherID'] as String?,
      parameters: (json['parameters'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      captchaResponse: json['captchaResponse'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'languageID': instance.languageID,
      'countryID': instance.countryID,
      'clientType': instance.clientType,
      'clientID': instance.clientID,
      'foreName': instance.foreName,
      'surName': instance.surName,
      'email': instance.email,
      'password': instance.password,
      'referredBy': instance.referredBy,
      'invitedBy': instance.invitedBy,
      'voucherID': instance.voucherID,
      'parameters': instance.parameters,
      'captchaResponse': instance.captchaResponse,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginResponse', json, ($checkedConvert) {
      final val = LoginResponse(
        $checkedConvert(
          'd',
          (v) => v == null
              ? null
              : LoginResponseValue.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{'d': instance.d};

LoginResponseValue _$LoginResponseValueFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LoginResponseValue',
      json,
      ($checkedConvert) {
        final val = LoginResponseValue(
          isAuthenticated: $checkedConvert('IsAuthenticated', (v) => v as bool),
          result: $checkedConvert('Result', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
          value: $checkedConvert(
            'Value',
            (v) => v == null ? null : Value.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'isAuthenticated': 'IsAuthenticated',
        'result': 'Result',
        'message': 'Message',
        'value': 'Value',
      },
    );

Map<String, dynamic> _$LoginResponseValueToJson(LoginResponseValue instance) =>
    <String, dynamic>{
      'IsAuthenticated': instance.isAuthenticated,
      'Result': instance.result,
      'Message': instance.message,
      'Value': instance.value,
    };

Value _$ValueFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Value', json, ($checkedConvert) {
      final val = Value(
        Ticket: $checkedConvert('Ticket', (v) => v as String?),
        ReadTerms: $checkedConvert('ReadTerms', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
  'Ticket': instance.Ticket,
  'ReadTerms': instance.ReadTerms,
};
