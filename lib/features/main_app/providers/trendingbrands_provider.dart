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

  List<BannerModel>? _trendingBrands;

  bool isLoading = false;

  List<BannerModel>? get trendingBrands => _trendingBrands;

  final String? category;

  TrendingBrandsProvider({required this.context, this.category}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  void getTrendingBrands() async {
    isLoading = true;

    GetBannersRequest request = GetBannersRequest(
      null,
      null,
      "50",
      category ?? "",
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
      List<BannerModel> output = [];
      GetBannersResponse response = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      response.groups?.forEach((Group group) {
        if (group.type == "brand") {
          group.banners?.forEach((BannerModel banner) {
            if (banner.bannerType == "brandBanner") {
              output.add(banner);
            }
          });
        }
      });
      _trendingBrands = output;
      isLoading = false;
      notifyListeners();
    }
  }
}
