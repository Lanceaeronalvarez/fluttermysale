import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class TrendingBrandsProvider extends ChangeNotifier {
  final AppHttp _http;

  GetBannersResponse? _trendingBrands;

  bool isLoading = false;

  GetBannersResponse get trendingBrands => _trendingBrands!;

  TrendingBrandsProvider(String userAgent)
    : _http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

  void getTrendingBrands(String categoryId) async {
    if (isLoading == true) {
      isLoading = false;
    }

    GetBannersRequest request = GetBannersRequest(
      null,
      null,
      "50",
      categoryId,
      null,
      null,
      true,
      null,
      "7,8,9",
    );

    Response res = await _http.get(
      ApiEndpoint.getSales2(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _trendingBrands = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      isLoading = true;
      notifyListeners();
    }
  }
}
