import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class LeaderboardBannerProvider extends ChangeNotifier {
  final AppHttp _http;

  GetBannersResponse? _leaderboardBanners;

  bool isLoading = false;

  GetBannersResponse get leaderboardBanners => _leaderboardBanners!;

  LeaderboardBannerProvider(String userAgent)
    : _http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

  static Future<LeaderboardBannerProvider> withUserAgent(
    BuildContext context,
  ) async {
    UserAgentHelper userAgentHelper = UserAgentHelper(context);
    String userAgent = await userAgentHelper.userAgent;
    return LeaderboardBannerProvider(userAgent);
  }

  Future<GetBannersResponse?> getleaderboardBanners(
    String pageName,
    String frontEnd,
    String category,
  ) async {
    if (isLoading == true) {
      isLoading = false;
    }

    Map<String, dynamic> request = {
      "pageName": pageName,
      "limit": 50,
      "bannergroups": 12,
      "frontEnd": frontEnd,
      "category": category,
    };

    request.removeWhere((k, v) => (v == null));

    Response res = await _http.get(ApiEndpoint.getSales2(), params: request);
    if (res.statusCode == 200 && res.statusCode != 429) {
      _leaderboardBanners = GetBannersResponse.fromJson(
        jsonDecode(res.toString()),
      );
      isLoading = true;
      notifyListeners();
      return _leaderboardBanners;
    }
  }
}
