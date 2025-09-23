import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/main/productlist_model.dart';

class ProductListProvider extends ChangeNotifier {
  AppHttp? _http;

  UserAgentHelper _userAgentHelper;
  String _saleId;
  List<String> _categoryKeys;
  List<FacetFilterModel>
  _facetFilters; //TODO: JCA should rename to appliedFilters
  String _sort;
  ProductListResponse? _productList;
  bool _isLoading = false;
  List<ProductItem> _products = [];
  int _page = 0;
  int _pageSize = 10;
  double? _initialMaxPrice;

  String get saleId => _saleId;
  List<String> get categoryKeys => _categoryKeys;
  List<FacetFilterModel> get facetFilters => _facetFilters;
  String get sort => _sort;
  ProductListResponse? get productList => _productList;
  bool get isLoading => _isLoading;
  List<ProductItem> get products => _products;
  int get page => _page;
  int get pageSize => _pageSize;
  double? get initialMaxPrice => _initialMaxPrice;

  ProductListProvider._(
    this._userAgentHelper,
    this._saleId,
    this._categoryKeys,
    this._facetFilters,
    this._sort,
  );

  factory ProductListProvider({
    required UserAgentHelper userAgentHelper,
    required String saleId,
    required List<String> categoryKeys,
    required List<FacetFilterModel> facetFilters,
    required String sort,
  }) {
    return ProductListProvider._(
      userAgentHelper,
      saleId,
      categoryKeys,
      facetFilters,
      sort,
    );
  }

  void getProductList(GetProductListRequest request) async {
    _isLoading = true;

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
      if (initialMaxPrice == null) {
        _setInitialMaxPrice();
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setInitialMaxPrice() {
    FacetFilterModel? priceFilter = _productList?.facets?.firstWhereOrNull((e) {
      return (e.name != null &&
          e.name!.isNotEmpty &&
          e.name! == FilterKey.price.key);
    });
    String maxPriceString = priceFilter?.values?.firstOrNull?.value ?? '';
    double? maxPrice = double.tryParse(maxPriceString);
    _initialMaxPrice ??= maxPrice;
  }

  void updateAppliedFilters({
    required List<String>? aCategoryKeys,
    required List<FacetFilterModel>? aFacetFilters,
    required String? aSort,
  }) {
    if (aCategoryKeys != null) {
      _categoryKeys = aCategoryKeys;
    }
    if (aFacetFilters != null) {
      _facetFilters = aFacetFilters;
    }
    if (aSort != null) {
      _sort = aSort;
    }
  }

  void incrementPage() {
    _page = _page + 1;
  }

  void resetProductList() {
    _products = [];
    _page = 0;
  }

  // TODO: JCA get currency somewhere
  Map<String, List<String>> facetFiltersToRequestArgs({
    String currency = '\$',
  }) {
    Map<String, List<String>> filterMap = FacetFilterModel.toMapStringValues(
      facetFilters,
      currency: currency,
    );
    if (_saleId.isNotEmpty) {
      filterMap['saleId'] = [_saleId];
    }

    return filterMap;
  }
}
