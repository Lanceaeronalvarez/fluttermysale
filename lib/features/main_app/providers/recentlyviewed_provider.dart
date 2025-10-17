import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/main/recentlyviewed_model.dart';

class RecentlyViewedProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  bool isLoading = false;
  List<GetRecentlyViewedResponse> _recentlyViewed = [];

  List<GetRecentlyViewedResponse> get recentlyViewed => _recentlyViewed;

  RecentlyViewedProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> fetchRecentlyViewed() async {
    isLoading = true;
    safeNotify();

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    try {
      Response res = await _http!.post(ApiEndpoint.recentlyViewedItems());
      if (res.statusCode == 200) {
        Iterable data = jsonDecode(json.encode(res.data));
        _recentlyViewed = List<GetRecentlyViewedResponse>.from(
          data.map((e) => GetRecentlyViewedResponse.fromJson(e)),
        );
      } else {
        debugPrint("Failed to fetch recently viewed: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching recently viewed: $e");
    }

    isLoading = false;
    safeNotify();
  }

  Future<void> addToRecentlyViewed({
    required String productId,
    required String masterSkuId,
  }) async {
    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    try {
      Response res = await _http!.post(
        ApiEndpoint.addToRecentlyViewedItems(),
        data: {"productId": productId, "masterSkuId": masterSkuId},
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        debugPrint("Added item to recently viewed: $productId, $masterSkuId");
      } else {
        debugPrint("Failed to add item: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error adding to recently viewed: $e");
    }
  }
}
