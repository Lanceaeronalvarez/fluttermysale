import 'package:json_annotation/json_annotation.dart';

part 'authentication_model.g.dart';

@JsonSerializable()
class LoginEmailRequest {
  String? countryID;
  String? userName;
  String? password;
  String? languageID;
  String? captchaResponse;
  int? clientID;

  LoginEmailRequest({
    this.countryID,
    this.userName,
    this.password,
    this.languageID,
    this.captchaResponse,
    this.clientID,
  });

  factory LoginEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginEmailRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginEmailRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  String? languageID;
  String? countryID;
  int? clientType;
  int? clientID;
  String? foreName;
  String? surName;
  String? email;
  String? password;
  String? referredBy;
  String? invitedBy;
  String? voucherID;
  Map<String, bool>? parameters;
  String? captchaResponse;

  RegisterRequest({
    this.languageID,
    this.countryID,
    this.clientType,
    this.clientID,
    this.foreName,
    this.surName,
    this.email,
    this.password,
    this.referredBy,
    this.invitedBy,
    this.voucherID,
    this.parameters,
    this.captchaResponse,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  LoginResponseValue? d;

  LoginResponse(this.d);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginResponseValue {
  @JsonKey(name: "Value")
  Value? value;

  LoginResponseValue(this.value);

  factory LoginResponseValue.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseValueFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseValueToJson(this);
}

@JsonSerializable()
class Value {
  String? Ticket;
  bool? ReadTerms;

  Value({this.Ticket, this.ReadTerms});

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);

  Map<String, dynamic> toJson() => _$ValueToJson(this);
}
