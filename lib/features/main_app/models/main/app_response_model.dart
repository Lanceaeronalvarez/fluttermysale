import 'package:json_annotation/json_annotation.dart';

part 'app_response_model.g.dart';

/// Top-level envelope: { "d": { ... } }
@JsonSerializable(genericArgumentFactories: true)
class AppResponse<T> {
  final ResponseD<T> d;

  AppResponse({required this.d});

  factory AppResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$AppResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$AppResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class ResponseD<T> {
  final bool isAuthenticated;

  @JsonKey(name: 'Result')
  final bool result;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Value')
  final T? value;

  ResponseD({
    required this.isAuthenticated,
    required this.result,
    this.message,
    this.value,
  });

  factory ResponseD.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ResponseDFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ResponseDToJson(this, toJsonT);
}
