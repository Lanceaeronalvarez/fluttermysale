
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_mysale/features/main_app/models/main/app_response_model.dart';

typedef FromJsonT<T> = T Function(Object? json);

extension AppResponseParsing on Response {
  
  /// Parse the HTTP response body into AppResponse<T>.
  /*
  Sample Usage
  
  Object
  final obj = res.asAppResponse<User>((e) {
    return User.fromJson(e as Map<String, dynamic>);
  });

  List<Object>
  final obj = res.asAppResponse<List<User>>((j) {
    return (j as List)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList(),
  });

  primitive
  final val = res.asAppResponse<bool>((e) => e as bool);

  */
  AppResponse<T> asAppResponse<T>(FromJsonT<T> parseT) {

    Map<String, dynamic> map = _dataToMap();

    return AppResponse<T>.fromJson(map, parseT);
  }

  Map<String, dynamic> _dataToMap() {
    Map<String, dynamic> map;
    if (data is Map<String, dynamic>) {
      map = data;
    } else if (data is String) {
      map = jsonDecode(data) as Map<String, dynamic>;
    } else if (data is List<int>) {
      map = jsonDecode(utf8.decode(data)) as Map<String, dynamic>;
    } else {
      throw StateError(
        'Expected JSON object for AppResponse, got ${data.runtimeType}',
      );
    }
    return map;
  }

}