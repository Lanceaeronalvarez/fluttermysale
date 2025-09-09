import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class LeaderboardBannerProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  BannerModel? _leaderboardBanner;

  bool isLoading = false;

  BannerModel? get leaderboardBanner => _leaderboardBanner;

  LeaderboardBannerProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper(context);
  }

  void getleaderboardBanners(
    String pageName,
    String frontEnd,
    String category,
  ) async {
    isLoading = true;

    Map<String, dynamic> request = {
      "pageName": pageName,
      "limit": 50,
      "bannergroups": 12,
      "frontEnd": frontEnd,
      "category": category,
    };

    request.removeWhere((k, v) => (v == null));

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.get(ApiEndpoint.getSales2(), params: request);
    if (res.statusCode == 200 && res.statusCode != 429) {
      GetBannersResponse response = GetBannersResponse.fromJson(
        jsonDecode(res.toString()),
      );
      response?.groups?.forEach((Group group) {
        _leaderboardBanner = group.banners?[0];
      });
      isLoading = false;
      notifyListeners();
    }
  }
}
