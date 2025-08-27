import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/main/bestsellers_model.dart';

class BestSellersProvider extends ChangeNotifier {
  final AppHttp _http;

  GetBestSellersResponse? _model;
  bool isLoading = false;

  GetBestSellersResponse get getBannersResponse => _model!;

  BestSellersProvider(String userAgent)
    : _http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

  static Future<BestSellersProvider> withUserAgent(BuildContext context) async {
    UserAgentHelper userAgentHelper = UserAgentHelper(context);
    String userAgent = await userAgentHelper.userAgent;
    return BestSellersProvider(userAgent);
  }

  void getBestSellers(String category) async {
    if (isLoading == true) {
      isLoading = false;
    }

    Response res = await _http.get(
      ApiEndpoint.bestSellers(),
      params: {"category": category},
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _model = GetBestSellersResponse.fromJson(jsonDecode(res.toString()));
      isLoading = true;
      notifyListeners();
    }
  }
}
