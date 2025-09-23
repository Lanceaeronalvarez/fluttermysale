import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/main/bestsellers_model.dart';

class BestSellersProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  GetBestSellersResponse? _model;
  bool isLoading = false;

  GetBestSellersResponse get getBannersResponse => _model!;

  BestSellersProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  void getBestSellers(String category) async {
    isLoading = true;

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.get(
      ApiEndpoint.bestSellers(),
      params: {"category": category},
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _model = GetBestSellersResponse.fromJson(jsonDecode(res.toString()));
      isLoading = false;
      notifyListeners();
    }
  }
}
