import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class ShopBannersProvider extends ChangeNotifier {
  final AppHttp _http;

  GetBannersResponse? _shopBanners;

  bool isLoading = false;

  GetBannersResponse get shopBanners => _shopBanners!;

  List<BannerModel> normalBannersData = [];

  ShopBannersProvider(String userAgent)
    : _http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

  static Future<ShopBannersProvider> withUserAgent(BuildContext context) async {
    UserAgentHelper userAgentHelper = UserAgentHelper(context);
    String userAgent = await userAgentHelper.userAgent;
    return ShopBannersProvider(userAgent);
  }

  Future<List<BannerModel>?> getShopBanners(GetBannersRequest request) async {
    if (isLoading == true) {
      isLoading = false;
    }

    Response res = await _http.get(
      ApiEndpoint.getSales(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _shopBanners = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      isLoading = true;
      notifyListeners();

      _shopBanners?.groups?.forEach((Group it) {
        if (it.type == "main") {
          normalBannersData.addAll(it.banners as Iterable<BannerModel>);
        }
      });

      return normalBannersData;
    }
  }
}
