import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class BannersProvider extends ChangeNotifier {
  final AppHttp _http;

  GetBannersResponse? _model;
  bool isLoading = false;

  GetBannersResponse get getBannersResponse => _model!;

  BannersProvider(String userAgent)
    : _http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

  void getBanners(GetBannersRequest request, bool getOnlyFromNetwork) async {
    if (isLoading == true) {
      isLoading = false;
    }

    Response res = await _http.get(
      getOnlyFromNetwork ? ApiEndpoint.getSales() : ApiEndpoint.getSales2(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _model = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      isLoading = true;
      notifyListeners();
    }
  }
}
