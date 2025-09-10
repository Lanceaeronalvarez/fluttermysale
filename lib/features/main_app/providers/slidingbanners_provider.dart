import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class SlidingBannersProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  List<BannerModel>? _slidingBanners;

  bool isLoading = false;

  List<BannerModel>? get slidingBanners => _slidingBanners;

  SlidingBannersProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper(context);
  }

  void getSlidingBanners() async {
    isLoading = true;

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
      GetBannersResponse response = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      _slidingBanners = [];
      response.groups?.forEach((Group group) {
        _slidingBanners?.addAll(group.banners as Iterable<BannerModel>);
      });
      isLoading = false;
      notifyListeners();
    }
  }
}
