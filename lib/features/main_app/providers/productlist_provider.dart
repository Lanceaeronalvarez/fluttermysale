import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/main/productlist_model.dart';

class ProductListProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  ProductListResponse? _productList;

  bool isLoading = false;

  ProductListResponse get productList => _productList!;

  ProductListProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper(context);
  }

  void getProductList(GetProductListRequest request) async {
    isLoading = true;

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.get(
      ApiEndpoint.getProducts(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _productList = ProductListResponse.fromJson(jsonDecode(res.toString()));
      isLoading = false;
      notifyListeners();
    }
  }
}
