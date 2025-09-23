import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/api_endpoints.dart';
import 'package:flutter_mysale/config/app_http.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

class CategoryTreeProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  bool isLoading = false;
  String? error;
  List<CategoryNodeModel> categories = [];
  String? clearanceUrl = null;

  CategoryTreeProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  // TODO: JCA completion is just for testing filters, should be removed eventually
  void getCategoryTree({bool forceApiCall = false, void Function(List<CategoryNodeModel>)? completion = null}) async {
    if (isLoading) return;
    if (categories.isNotEmpty && !forceApiCall) return;

    isLoading = true;
    error = null;
    notifyListeners(); //notify observers that the request have started

    try {
      final userAgent = await _userAgentHelper.userAgent;
      _http ??= AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

      final unsortedCategories = await _fetch();

      //TODO should be in config/somewhere if it will be shown/hidden
      unsortedCategories.add(_createBrandCategory());

      //TODO should be in config/somewhere if it will be shown/hidden
      //unsortedCategories.add(_createGiftcardCategory());

      clearanceUrl = await _fetchClearance();
      if (clearanceUrl != null && !clearanceUrl!.isEmpty) {
        unsortedCategories.add(_createClearanceCategory());
      }

      categories = sort(unsortedCategories);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      completion?.call(categories);
      notifyListeners(); //notify observers that the request is completed
    }
  }

  // API CALL
  Future<List<CategoryNodeModel>> _fetch() async {
    //TODO: JCA hardcoded country
    Response response = await _http!.get(
      ApiEndpoint.getCategoryTree(),
      params: {
        'platform': AppPlatform.getCurrentPlatform()?.name ?? '',
        'countryID': 'au',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed: ${response.statusCode}');
    }

    final List<dynamic> list = (response.data as List<dynamic>?) ?? [];

    final List<CategoryNodeModel> unsortedCategories = list
        .map((e) => CategoryNodeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return unsortedCategories;
  }

  //TODO: JCA implementation only temp, clearanceurl should be checked first in preference/cache then call the proper api
  Future<String?> _fetchClearance() async {
    Response response = await _http!.get(
      ApiEndpoint.getPublicAppSettings(),
      params: {'countryID': 'as'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed: ${response.statusCode}');
    }

    final map = Map<String, dynamic>.from(response.data);
    final clearanceUrl =
        map['d']?['Value']?['Shop']?['ClearanceUrl'] as String?;

    return clearanceUrl;
  }

  List<CategoryNodeModel> sort(List<CategoryNodeModel> categories) {
    List<CategoryNodeModel> sortedCategories = [];

    final urlCategories = categories.where((c) {
      return c.getNodeType() == NodeType.url;
    }).toList();
    sortedCategories.addAll(urlCategories);

    final usualCategories = categories.where((c) {
      final nodeType = c.getNodeType() ?? NodeType.unknown;
      return (nodeType == NodeType.usual) || (nodeType == NodeType.unknown);
    }).toList();
    sortedCategories.addAll(usualCategories);

    final brandCategories = categories.where((c) {
      return (c.getNodeType() == NodeType.brands);
    }).toList();
    sortedCategories.addAll(brandCategories);

    final fixedCategories = categories.where((c) {
      return (c.getNodeType() == NodeType.fixed);
    }).toList();
    sortedCategories.addAll(fixedCategories);

    final giftcardCategories = categories.where((c) {
      return (c.getNodeType() == NodeType.giftcards);
    }).toList();
    sortedCategories.addAll(giftcardCategories);

    final clearanceCategories = categories.where((c) {
      return (c.getNodeType() == NodeType.clearance);
    }).toList();
    sortedCategories.addAll(clearanceCategories);

    return sortedCategories;
  }

  CategoryNodeModel _createBrandCategory() {
    return CategoryNodeModel(
      key: "",
      id: "",
      name: "Brands",
      children: null,
      nodeType: NodeType.brands.name,
    );
  }

  CategoryNodeModel _createGiftcardCategory() {
    return CategoryNodeModel(
      key: "",
      id: "",
      name: "Gift Cards",
      children: null,
      nodeType: NodeType.giftcards.name,
    );
  }

  CategoryNodeModel _createClearanceCategory() {
    return CategoryNodeModel(
      key: "",
      id: "",
      name: "Clearance",
      children: null,
      nodeType: NodeType.clearance.name,
      textColor: "#FF0000",
    );
  }
}
