import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class SlidingBannersProvider extends ChangeNotifier {
  final AppHttp _http;

  GetBannersResponse? _slidingBanners;

  bool isLoading = false;

  GetBannersResponse get slidingBanners => _slidingBanners!;

  SlidingBannersProvider(String userAgent)
    : _http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

  static Future<SlidingBannersProvider> withUserAgent(
    BuildContext context,
  ) async {
    UserAgentHelper userAgentHelper = UserAgentHelper(context);
    String userAgent = await userAgentHelper.userAgent;
    return SlidingBannersProvider(userAgent);
  }

  Future<GetBannersResponse?> getSlidingBanners() async {
    if (isLoading == true) {
      isLoading = false;
    }

    GetBannersRequest request = GetBannersRequest(
      null,
      null,
      "10",
      null,
      null,
      null,
      true,
      true,
      null,
    );

    Response res = await _http.get(
      ApiEndpoint.getSales(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _slidingBanners = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      isLoading = true;
      notifyListeners();
      return _slidingBanners;
    }
  }
}
