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

  List<BannerModel>? _sponsoredBanners;

  bool isLoading = false;

  List<BannerModel>? get sponsoredBanners => _sponsoredBanners;

  final String? category;

  SponsoredBannersProvider({required this.context, this.category}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  void getSponsoredBanners() async {
    isLoading = true;

    GetBannersRequest request = GetBannersRequest(
      null,
      null,
      "999",
      category ?? "",
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
      List<BannerModel> output = [];
      GetBannersResponse response = GetBannersResponse.fromJson(jsonDecode(res.toString()));
      response.groups?.forEach((Group group) {
        if (group.type == "brand") {
          group.banners?.forEach((BannerModel banner) {
            banner.categories?.forEach((String category) {
              if (category.toLowerCase() == "sponsored") {
                output.add(banner);
              }
            });
          });
        }
      });

      _sponsoredBanners = output;
      isLoading = false;
      notifyListeners();
    }
  }
}
