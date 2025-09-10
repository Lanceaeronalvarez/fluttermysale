import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class SponsoredBannersProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  GetBannersResponse? _sponsoredBanners;

  bool isLoading = false;

  GetBannersResponse? get sponsoredBanners => _sponsoredBanners;

  SponsoredBannersProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper(context);
  }

  void getSponsoredBanners(String categoryId) async {
    isLoading = true;

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

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.get(
      ApiEndpoint.getSales(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _sponsoredBanners = GetBannersResponse.fromJson(
        jsonDecode(res.toString()),
      );
      isLoading = false;
      notifyListeners();
    }
  }
}
