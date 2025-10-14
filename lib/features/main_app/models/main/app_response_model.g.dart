// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppResponse<T> _$AppResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => AppResponse<T>(
  d: ResponseD<T>.fromJson(
    json['d'] as Map<String, dynamic>,
    (value) => fromJsonT(value),
  ),
);

Map<String, dynamic> _$AppResponseToJson<T>(
  AppResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'d': instance.d.toJson((value) => toJsonT(value))};

ResponseD<T> _$ResponseDFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ResponseD<T>(
  isAuthenticated: json['IsAuthenticated'] as bool? ?? false,
  result: json['Result'] as bool? ?? false,
  message: json['Message'] as String?,
  value: _$nullableGenericFromJson(json['Value'], fromJsonT),
);

Map<String, dynamic> _$ResponseDToJson<T>(
  ResponseD<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'IsAuthenticated': instance.isAuthenticated,
  'Result': instance.result,
  'Message': instance.message,
  'Value': _$nullableGenericToJson(instance.value, toJsonT),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
