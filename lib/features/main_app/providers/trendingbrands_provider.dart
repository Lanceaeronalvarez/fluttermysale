import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class TrendingBrandsProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  GetBannersResponse? _trendingBrands;

  bool isLoading = false;

  GetBannersResponse get trendingBrands => _trendingBrands!;

  TrendingBrandsProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  void getTrendingBrands(String categoryId) async {
    isLoading = true;

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

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.get(
      ApiEndpoint.getSales2(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _trendingBrands = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      isLoading = false;
      notifyListeners();
    }
  }
}
