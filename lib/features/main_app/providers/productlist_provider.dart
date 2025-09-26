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
import '../models/main/banners_linkoptions_model.dart';
import '../models/main/productlist_model.dart';

class ProductListProvider extends ChangeNotifier {
  AppHttp? _http;

  UserAgentHelper _userAgentHelper;
  String _saleId;
  List<CategoryNodeModel> _appliedCategories;
  List<String>? _appliedCategoryKeys;
  List<FacetFilterModel> _appliedFilters;
  ProductSortModel? _sort;
  ProductListResponse? _productList;
  bool _isLoading = false;
  List<ProductItem> _products = [];
  int _page = 0;
  int _pageSize = 10;
  ProductListResponse? _initialProductListResponse;
  String? _searchQuery;
  CategoryNodeModel?
  _originCategory; // if plp came from categories/subcategories otherwise this should be null

  String get saleId => _saleId;

  List<CategoryNodeModel> get appliedCategories => _appliedCategories;

  List<String>? get appliedCategoryKeys => _appliedCategoryKeys;

  List<FacetFilterModel> get appliedFilters => _appliedFilters;

  ProductSortModel? get sort => _sort;

  ProductListResponse? get productList => _productList;

  bool get isLoading => _isLoading;

  List<ProductItem> get products => _products;

  int get page => _page;

  int get pageSize => _pageSize;
  ProductListResponse? get initialProductListResponse =>
      _initialProductListResponse;
  String? get searchQuery => _searchQuery;
  CategoryNodeModel? get originCategory => _originCategory;

  ProductListProvider._(
    this._userAgentHelper,
    this._searchQuery,
    this._saleId,
    this._appliedCategories,
    this._appliedCategoryKeys,
    this._appliedFilters,
    this._sort,
    this._originCategory,
  );

  factory ProductListProvider({
    required UserAgentHelper userAgentHelper,
    required String searchQuery,
    required String saleId,
    required List<CategoryNodeModel> appliedCategories,
    List<String>? appliedCategoryKeys,
    required List<FacetFilterModel> appliedFilters,
    required ProductSortModel? sort,
    required CategoryNodeModel? originCategory,
  }) {
    ProductListProvider p = ProductListProvider._(
      userAgentHelper,
      searchQuery,
      saleId,
      appliedCategories,
      appliedCategoryKeys,
      appliedFilters,
      sort,
      originCategory,
    );

    if (originCategory != null &&
        originCategory.key != null &&
        originCategory.key!.isNotEmpty) {
      bool isRootCategory = originCategory.key!.split('>>>').length == 1;
      //if origincategory is not root and also not selected, add to applied filters
      if (!isRootCategory && !p._isOriginCategorySelected()) {
        p._appliedCategories.add(originCategory);
      }
    }

    return p;
  }

  void getProductList() async {
    _isLoading = true;

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    String categoryKeys;
    if (_appliedCategoryKeys == null || appliedCategories.isNotEmpty) {
      categoryKeys = jsonEncode(
        appliedCategories
            .map<String?>((CategoryNodeModel e) => e.key)
            .nonNulls
            .toList(),
      );
    } else {
      categoryKeys = jsonEncode(_appliedCategoryKeys);
    }

    GetProductListRequest request = GetProductListRequest(
      _searchQuery,
      _page.toString(),
      pageSize.toString(),
      categoryKeys,
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
    FacetFilterModel? priceFilter = _initialProductListResponse?.facets
        ?.firstWhereOrNull((e) {
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
    _updateOriginCategory();
  }

  void _updateOriginCategory() {
    if (_originCategory != null && !_isOriginCategorySelected()) {
      //update originCategory to root category if originCategory is removed from appliedCategories
      String? rootKey = _originCategory?.key?.split('>>>').firstOrNull;
      if (rootKey != null && rootKey.isNotEmpty) {
        List<CategoryNodeModel> categories =
            initialProductListResponse?.categories ?? [];
        CategoryNodeModel? rootCategory = categories.firstWhereOrNull((e) {
          return _facetFilterKeyMatched(e.key, rootKey);
        });
        if (rootCategory != null) {
          _originCategory = rootCategory;
        }
      }
    }
  }

  //used for both FacetFilterModel and FacetFilterValueModel
  //similar to filterprovider
  bool _facetFilterKeyMatched(String? key1, String? key2) {
    return key1 != null &&
        key2 != null &&
        key1.isNotEmpty &&
        key2.isNotEmpty &&
        key1.toLowerCase() == key2.toLowerCase();
  }

  //similar to filterprovider
  bool _isOriginCategorySelected() {
    if (_originCategory == null) {
      return false;
    } else {
      return (appliedCategories.firstWhereOrNull(
            (e) => _facetFilterKeyMatched(e.key, _originCategory?.key),
          ) !=
          null);
    }
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
