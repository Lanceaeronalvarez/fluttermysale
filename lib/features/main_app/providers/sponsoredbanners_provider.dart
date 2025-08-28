import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class SponsoredBannersProvider extends ChangeNotifier {
  final AppHttp _http;

  GetBannersResponse? _sponsoredBanners;

  bool isLoading = false;

  GetBannersResponse get sponsoredBanners => _sponsoredBanners!;

  SponsoredBannersProvider(String userAgent)
    : _http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

  static Future<SponsoredBannersProvider> withUserAgent(
    BuildContext context,
  ) async {
    UserAgentHelper userAgentHelper = UserAgentHelper(context);
    String userAgent = await userAgentHelper.userAgent;
    return SponsoredBannersProvider(userAgent);
  }

  void getSponsoredBanners(String categoryId) async {
    if (isLoading == true) {
      isLoading = false;
    }

    GetBannersRequest request = GetBannersRequest(
      null,
      null,
      "999",
      categoryId,
      null,
      null,
      true,
      null,
      null,
    );

    Response res = await _http.get(
      ApiEndpoint.getSales(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _sponsoredBanners = GetBannersResponse.fromJson(
        jsonDecode(res.toString()),
      );
      isLoading = true;
      notifyListeners();
    }
  }
}
