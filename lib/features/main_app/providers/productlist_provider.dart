import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productsort_model.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/main/productlist_model.dart';

class ProductListProvider extends ChangeNotifier {
  AppHttp? _http;

  UserAgentHelper _userAgentHelper;
  String _saleId;
  List<CategoryNodeModel> _appliedCategories;
  List<FacetFilterModel> _appliedFilters;
  ProductSortModel? _sort;
  ProductListResponse? _productList;
  bool _isLoading = false;
  List<ProductItem> _products = [];
  int _page = 0;
  int _pageSize = 10;
  ProductListResponse? _initialProductListResponse;
  String? _searchQuery;

  String get saleId => _saleId;
  List<CategoryNodeModel> get appliedCategories => _appliedCategories;
  List<FacetFilterModel> get appliedFilters => _appliedFilters;
  ProductSortModel? get sort => _sort;
  ProductListResponse? get productList => _productList;
  bool get isLoading => _isLoading;
  List<ProductItem> get products => _products;
  int get page => _page;
  int get pageSize => _pageSize;
  ProductListResponse? get initialProductListResponse => _initialProductListResponse;
  String? get searchQuery => _searchQuery;

  ProductListProvider._(
    this._userAgentHelper,
    this._saleId,
    this._appliedCategories,
    this._appliedFilters,
    this._sort,
  );

  factory ProductListProvider({
    required UserAgentHelper userAgentHelper,
    required String saleId,
    required List<CategoryNodeModel> appliedCategories,
    required List<FacetFilterModel> appliedFilters,
    required ProductSortModel? sort,
  }) {
    return ProductListProvider._(
      userAgentHelper,
      saleId,
      appliedCategories,
      appliedFilters,
      sort,
    );
  }

  void getProductList() async {
    _isLoading = true;

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    GetProductListRequest request = GetProductListRequest(
      _searchQuery,
      _page.toString(),
      pageSize.toString(),
      jsonEncode(
        appliedCategories
            .map<String?>((CategoryNodeModel e) => e.key)
            .nonNulls
            .toList(),
      ),
      jsonEncode(facetFiltersToRequestArgs()),
      sort?.key,
    );

    Response res = await _http!.get(
      ApiEndpoint.getProducts(),
      params: request.toMap(),
    );
    if (res.statusCode == 200 && res.statusCode != 429) {
      _productList = ProductListResponse.fromJson(jsonDecode(res.toString()));
      _initialProductListResponse ??= _productList;
      _isLoading = false;
      notifyListeners();
    }
  }

  double? getInitialMaxPrice() {
    FacetFilterModel? priceFilter = _initialProductListResponse?.facets?.firstWhereOrNull((e) {
      return (e.name != null &&
          e.name!.isNotEmpty &&
          e.name! == FilterKey.price.key);
    });
    String maxPriceString = priceFilter?.values?.firstOrNull?.value ?? '';
    double? maxPrice = double.tryParse(maxPriceString);
    return maxPrice;
  }

  void updateSearchQuery(String? searchQuery) {
    _searchQuery = searchQuery;
  }

  void updateAppliedFilters({
    required List<CategoryNodeModel> aAppliedCategories,
    required List<FacetFilterModel> aAppliedFilters,
  }) {
    _appliedCategories = aAppliedCategories;
    _appliedFilters = aAppliedFilters;
  }

  void updateSort(ProductSortModel? sort) {
    _sort = sort;
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
      appliedFilters,
      currency: currency,
    );
    if (_saleId.isNotEmpty) {
      filterMap['saleId'] = [_saleId];
    }

    return filterMap;
  }
}
