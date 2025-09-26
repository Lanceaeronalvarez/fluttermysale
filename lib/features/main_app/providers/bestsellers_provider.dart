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

  List<GetBestSellersResponse>? _getBestSellersResponse;
  bool isLoading = false;

  List<GetBestSellersResponse>? get getBestSellersResponse =>
      _getBestSellersResponse!;

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
      //res.toString() when data is a list isn't handled in library code
      Iterable it = jsonDecode(json.encode(res.data));
      List<GetBestSellersResponse> items = List<GetBestSellersResponse>.from(
        it.map((model) => GetBestSellersResponse.fromJson(model)),
      );
      _getBestSellersResponse = items;
      isLoading = false;
      notifyListeners();
    }
  }
}
