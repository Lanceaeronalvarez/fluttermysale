import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/api_endpoints.dart';
import 'package:flutter_mysale/config/app_http.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/filter_category_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productlist_model.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

class FilterKey {
  String key;
  String displayName;

  FilterKey._(this.key, this.displayName);

  static final FilterKey brandName = FilterKey._('skus.brandName', 'Brand');
  static final FilterKey size = FilterKey._('skus.attributes.size', 'Size');
  static final FilterKey price = FilterKey._(
    'skus.attributesForFaceting.aud',
    'Price',
  );
  static final FilterKey sort = FilterKey._('sort', 'Sort');
  static final FilterKey color = FilterKey._('color', 'Color');
  static final FilterKey categories = FilterKey._('categories', 'Category');

  static final List<FilterKey> _all = [
    brandName,
    size,
    price,
    sort,
    color,
    categories,
  ];

  static String getDisplayNameWithKey(String key) {
    return _all.firstWhereOrNull((fk) {
          return fk.key == key;
        })?.displayName ??
        '';
  }
}

class FilterProvider extends ChangeNotifier {
  String _saleId = '';
  String _searchQuery = '';
  int _productTotal = 0;
  double _minPrice; //min price of slider
  double _maxPrice; //max price of slider
  double _currentMinPrice;
  double _currentMaxPrice;
  String _currency;
  List<FilterCategoryModel> _filterCategories;
  List<CategoryNodeModel> _appliedCategories;
  List<FacetFilterModel> _facetFilters;
  List<FacetFilterModel> _appliedFilters;
  CategoryNodeModel? _originCategory;

  int get productTotal => _productTotal;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get currentMinPrice => _currentMinPrice;
  double get currentMaxPrice => _currentMaxPrice;
  String get currency => _currency;
  List<FilterCategoryModel> get filterCategories => _filterCategories;
  List<CategoryNodeModel> get appliedCategories => _appliedCategories;
  List<FacetFilterModel> get facetFilters => _facetFilters;
  CategoryNodeModel? get originCategory => _originCategory;

  //used in filter_select
  List<FacetFilterValueModel> _displayedFacetFilterValues = [];
  List<FacetFilterValueModel> get displayedFacetFilterValues =>
      _displayedFacetFilterValues;

  FilterProvider._(
    this._saleId,
    this._searchQuery,
    this._productTotal,
    this._minPrice,
    this._maxPrice,
    this._currentMinPrice,
    this._currentMaxPrice,
    this._currency,
    this._filterCategories,
    this._appliedCategories,
    this._facetFilters,
    this._appliedFilters,
    this._originCategory,
  );

  factory FilterProvider({
    required String saleId,
    required String searchQuery,
    required int productTotal,
    required String currency,
    required double maxPrice,
    required List<CategoryNodeModel> categories,
    required List<CategoryNodeModel> selectedCategories,
    required List<FacetFilterModel> facetFilters,
    required List<FacetFilterModel> appliedFilters,
    required CategoryNodeModel? originCategory,
  }) {
    List<FilterKey> includedFilters = [
      FilterKey.brandName,
      FilterKey.price,
      FilterKey.size,
    ];
    List<FacetFilterModel> arrangedFacetFilters = includedFilters
        .map<FacetFilterModel?>((filterKey) {
          FacetFilterModel? facetFilter = facetFilters.firstWhereOrNull((ff) {
            if (ff.name != null && ff.name!.isNotEmpty) {
              return ff.name!.toLowerCase() == filterKey.key.toLowerCase();
            } else {
              return false;
            }
          });
          return facetFilter;
        })
        .nonNulls
        .toList();

    double defaultMinPrice = 0;

    FilterProvider provider = FilterProvider._(
      saleId,
      searchQuery,
      productTotal,
      defaultMinPrice, //min price
      maxPrice, //max price
      defaultMinPrice, //current min price
      maxPrice, //current max price
      currency,
      [], //categories
      selectedCategories, //applied categories
      arrangedFacetFilters, //filters
      appliedFilters, //applied filters
      originCategory, //origin category
    );

    //TODO: JCA no preapplied filters yet
    //Important to be generated
    provider._appliedFilters = arrangedFacetFilters.map<FacetFilterModel>((ff) {
      List<FacetFilterValueModel> values =
          appliedFilters.firstWhereOrNull((FacetFilterModel element) {
            return provider._facetFilterKeyMatched(element.name, ff.name);
          })?.values ??
          [];
      return FacetFilterModel(ff.name ?? '', values);
    }).toList();

    List<CategoryNodeModel> categoriesToShow = [...categories];
    if (originCategory != null) {
      String? originRootKey = originCategory.key?.split('>>>').firstOrNull;
      categoriesToShow = categoriesToShow
          .where((CategoryNodeModel element) {
            return provider._facetFilterKeyMatched(originRootKey, element.key);
          })
          .nonNulls
          .toList();
          
    }

    provider._setCategories(categoriesToShow);

    FacetFilterValueModel? facetFilterPrice = provider
        .getAppliedFilter(FilterKey.price.key)
        ?.values
        ?.firstOrNull;
    if (facetFilterPrice != null) {
      final priceRange = (facetFilterPrice.value ?? '').parseRange(
        currency: provider._currency,
      );
      if (priceRange != null) {
        provider._currentMinPrice = priceRange.min;
        provider._currentMaxPrice = priceRange.max;
      }
    }

    return provider;
  }

  void _setCategories(
    List<CategoryNodeModel> categories, {
    bool callNotify = true,
  }) {
    const int rootDepth = 1;
    _filterCategories = [
      for (CategoryNodeModel category in categories)
        _generateFilterCategoryModelFrom(
          category,
          rootDepth,
          _appliedCategories,
        ),
    ];
    if (callNotify) notifyListeners();
  }

  FilterCategoryModel _generateFilterCategoryModelFrom(
    CategoryNodeModel category,
    int depth,
    List<CategoryNodeModel> sCategories,
  ) {
    List<FilterCategoryModel> filterCategoryChildren = [];
    if (category.hasChild &&
        category.children != null &&
        category.children!.isNotEmpty) {
      filterCategoryChildren = category.children!
          .map((child) {
            return _generateFilterCategoryModelFrom(
              child,
              depth + 1,
              sCategories,
            );
          })
          .toList(growable: false);
    }

    final FilterCategoryStatus status = _generateInitialCategoryStatus(
      category.key ?? '',
      sCategories,
    );

    return FilterCategoryModel(
      category: category,
      fChildren: List.unmodifiable(filterCategoryChildren),
      depth: depth,
      isExpanded: false,
      status: status,
    );
  }

  FilterCategoryStatus _generateInitialCategoryStatus(
    String categoryKey,
    List<CategoryNodeModel> sCategories,
  ) {
    if (categoryKey.isNotEmpty) {
      for (CategoryNodeModel sCategory in sCategories) {
        if (sCategory.key != null && categoryKey.startsWith(sCategory.key!)) {
          return FilterCategoryStatus.checked;
        }
      }
    }
    return FilterCategoryStatus.unchecked;
  }

  void generateSelectedCategories({bool callNotify = true}) {
    List<CategoryNodeModel> result = [];
    for (FilterCategoryModel filterCategory in _filterCategories) {
      result.addAll(_collectSelectedCategories(filterCategory));
    }
    _appliedCategories = result;

    if (callNotify) notifyListeners();
  }

  List<CategoryNodeModel> _collectSelectedCategories(
    FilterCategoryModel filterCategory,
  ) {
    switch (filterCategory.status) {
      case FilterCategoryStatus.checked:
        return [filterCategory.category];
      case FilterCategoryStatus.partial:
        List<CategoryNodeModel> res = [];
        for (FilterCategoryModel child in filterCategory.filterChildren) {
          res.addAll(_collectSelectedCategories(child));
        }
        return res;
      case FilterCategoryStatus.unchecked:
        return [];
    }
  }

  void toggleIsExpanded(FilterCategoryModel fCategory) {
    fCategory.toggleIsExpanded();
    notifyListeners();
  }

  void toggleIsExpandedOffAllFilterCategories() {
    for (FilterCategoryModel fc in filterCategories) {
      fc.childrenIsExpandedToggleOff();
    }
  }

  void setStatusOfLeafCategories(
    FilterCategoryModel fCategory,
    bool isSelected,
  ) {
    fCategory.setStatusOfLeafCategories(isSelected);
  }

  FacetFilterModel? _getFacetFilter(String filterKey) {
    return _facetFilters.firstWhereOrNull((k) {
      return _facetFilterKeyMatched(k.name, filterKey);
    });
  }

  void clearAllSelecteCategories({bool callNotify = true}) {
    for (FilterCategoryModel filterCategory in _filterCategories) {
      setStatusOfLeafCategories(filterCategory, false);
    }
    generateSelectedCategories(callNotify: callNotify);
  }

  void resetDisplayedFacetFilterValues({
    required String filterKey,
    bool callNotify = true,
  }) {
    FacetFilterModel? facetFilter = _getFacetFilter(filterKey);
    if (facetFilter?.values != null) {
      _displayedFacetFilterValues = facetFilter!.values!;
    } else {
      _displayedFacetFilterValues = [];
    }

    if (callNotify) notifyListeners();
  }

  void searchDisplayedFacetFilterValues({
    required String filterKey,
    required String searchTerm,
  }) {
    FacetFilterModel? facetFilter = _getFacetFilter(filterKey);
    if (facetFilter?.values != null) {
      if (searchTerm.isEmpty) {
        _displayedFacetFilterValues = facetFilter!.values!;
      } else {
        _displayedFacetFilterValues = facetFilter!.values!.where((value) {
          return value.value?.toLowerCase().contains(searchTerm) ?? false;
        }).toList();
      }
    } else {
      _displayedFacetFilterValues = [];
    }

    notifyListeners();
  }

  void sortDisplayedFacetFilterValues({
    required String filterKey,
    required bool ascending,
    required bool byName,
    bool callNotify = true,
  }) {
    List<FacetFilterValueModel> ffv = [
      ...(_getFacetFilter(filterKey)?.values ?? []),
    ];
    if (byName) {
      ffv.sort((FacetFilterValueModel a, FacetFilterValueModel b) {
        if (ascending) {
          return b.value?.toLowerCase().compareTo(
                a.value?.toLowerCase() ?? '',
              ) ??
              -1;
        } else {
          return a.value?.toLowerCase().compareTo(
                b.value?.toLowerCase() ?? '',
              ) ??
              -1;
        }
      });
    } else {
      ffv.sort((FacetFilterValueModel a, FacetFilterValueModel b) {
        if (ascending) {
          return (a.count ?? 0) - (b.count ?? 0);
        } else {
          return (b.count ?? 0) - (a.count ?? 0);
        }
      });
    }
    _displayedFacetFilterValues = ffv;
    if (callNotify) notifyListeners();
  }

  FacetFilterModel? getAppliedFilter(String filterKey) {
    return _appliedFilters.firstWhereOrNull((k) {
      return _facetFilterKeyMatched(k.name, filterKey);
    });
  }

  bool isFacetFilterValueSelected({
    required String filterKey,
    required FacetFilterValueModel facetFilterValue,
  }) {
    FacetFilterModel? appliedFacetFilter = getAppliedFilter(filterKey);
    return appliedFacetFilter?.values?.firstWhereOrNull((filter) {
          return _facetFilterKeyMatched(facetFilterValue.value, filter.value);
        }) !=
        null;
  }

  //used for removing applied filters via filterbar
  void removeAppliedFilter({required String facetFilterValueKey}) {
    FacetFilterModel? targetFacet = null;
    FacetFilterValueModel? targetFacetValue = null;
    for (FacetFilterModel ff in _appliedFilters) {
      for (FacetFilterValueModel ffv in (ff.values ?? [])) {
        if (_facetFilterKeyMatched(facetFilterValueKey, ffv.value)) {
          targetFacetValue = ffv;
          targetFacet = ff;
          break;
        }
      }
      if (targetFacetValue != null && targetFacet != null) break;
    }

    if (targetFacetValue != null && targetFacet != null) {
      if (_facetFilterKeyMatched(targetFacet.name, FilterKey.price.key)) {
        updateAppliedFilterPrice(_minPrice, _maxPrice, callNotify: false);
      } else {
        targetFacet.values?.remove(targetFacetValue);
      }
    }

    notifyListeners();
  }

  //used for removing applied filtercategory via filterbar
  void removeAppliedFilterCategory({required CategoryNodeModel category}) {
    CategoryNodeModel? targetCategory = null;
    for (CategoryNodeModel sc in _appliedCategories) {
      if (_facetFilterKeyMatched(category.key, sc.key)) {
        targetCategory = sc;
        break;
      }
    }
    if (targetCategory != null &&
        targetCategory.key != null &&
        targetCategory.key!.isNotEmpty) {
      FilterCategoryModel? targetFilterCategory = _findCategoryByPath(
        _filterCategories,
        targetCategory.key!,
      );
      if (targetFilterCategory != null) {
        setStatusOfLeafCategories(targetFilterCategory, false);
        generateSelectedCategories(callNotify: true);
      }
    }
  }

  FilterCategoryModel? _findCategoryByPath(
    List<FilterCategoryModel> roots,
    String path, {
    String separator = '>>>',
  }) {
    final parts = path
        .split(separator)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return null;

    var currentLevel = roots;
    FilterCategoryModel? current;
    var acc = '';

    for (var i = 0; i < parts.length; i++) {
      acc = (i == 0) ? parts[0] : '$acc$separator${parts[i]}';

      FilterCategoryModel? found;
      for (final n in currentLevel) {
        final k = n.category.key;
        if (k != null && k == acc) {
          found = n;
          break;
        }
      }
      if (found == null) return null;

      current = found;
      currentLevel = found.filterChildren;
    }
    return current;
  }

  void addOrRemoveAppliedFilter(
    String filterKey,
    FacetFilterValueModel facetFilterValue, {
    bool callNotify = true,
  }) {
    FacetFilterModel? appliedFacetFilter = getAppliedFilter(filterKey);
    if (appliedFacetFilter?.values != null) {
      int? retrievedFilterIndex = null;
      for (final (index, ffv) in appliedFacetFilter!.values!.indexed) {
        if (_facetFilterKeyMatched(ffv.value, facetFilterValue.value)) {
          retrievedFilterIndex = index;
          break;
        }
      }

      if (retrievedFilterIndex == null) {
        appliedFacetFilter.values?.add(facetFilterValue);
      } else {
        appliedFacetFilter.values?.removeAt(retrievedFilterIndex);
      }
    } else {}
    if (callNotify) notifyListeners();
  }

  void clearAllAppliedFilters() {
    for (FacetFilterModel ff in _appliedFilters) {
      clearAppliedFilter(ff.name ?? '', callNotify: false);
    }
    clearAllSelecteCategories(callNotify: false);
    notifyListeners();
  }

  void clearAppliedFilter(String filterKey, {bool callNotify = true}) {
    FacetFilterModel? appliedFacetFilter = getAppliedFilter(filterKey);
    appliedFacetFilter?.values = [];
    if (filterKey == FilterKey.price.key) {
      _currentMinPrice = _minPrice;
      _currentMaxPrice = _maxPrice;
    }
    if (callNotify) notifyListeners();
  }

  void updateAppliedFilterPrice(
    double currentMinPrice,
    double currentMaxPrice, {
    bool callNotify = true,
  }) {
    FacetFilterModel? appliedFacetFilter = getAppliedFilter(
      FilterKey.price.key,
    );
    if (currentMinPrice <= _minPrice && currentMaxPrice >= _maxPrice) {
      appliedFacetFilter?.values = [];
    } else {
      String price =
          '${_currency}${currentMinPrice.toInt()} to ${_currency}${currentMaxPrice.toInt()}';
      FacetFilterValueModel newValue = FacetFilterValueModel(price, 1);
      appliedFacetFilter?.values = [newValue];
    }
    _currentMinPrice = currentMinPrice;
    _currentMaxPrice = currentMaxPrice;

    if (callNotify) notifyListeners();
  }

  List<FacetFilterValueModel> getFlatAppliedFilters() {
    List<FacetFilterValueModel> v = [];
    for (FacetFilterModel ff in _appliedFilters) {
      v.addAll(ff.values ?? []);
    }
    return v;
  }

  //used for both FacetFilterModel and FacetFilterValueModel
  //similar to productlistprovider
  bool _facetFilterKeyMatched(String? key1, String? key2) {
    return key1 != null &&
        key2 != null &&
        key1.isNotEmpty &&
        key2.isNotEmpty &&
        key1.toLowerCase() == key2.toLowerCase();
  }

  //similar to productlistprovider
  bool isOriginCategorySelected() {
    if (_originCategory == null) {
      return false;
    } else {
      return (_appliedCategories.firstWhereOrNull(
            (e) => _facetFilterKeyMatched(e.key, _originCategory?.key),
          ) !=
          null);
    }
  }

  GetProductListRequest generateGetProductListRequest() {
    List<String> appliedCategories = _appliedCategories
        .map<String?>((CategoryNodeModel e) => e.key)
        .nonNulls
        .toList();
    Map<String, List<String>> filterMap = FacetFilterModel.toMapStringValues(
      _appliedFilters,
      currency: _currency,
    );
    if (_saleId.isNotEmpty) {
      filterMap['saleId'] = [_saleId];
    }
    return GetProductListRequest(
      _searchQuery,
      '0',
      '10',
      jsonEncode(appliedCategories),
      jsonEncode(filterMap),
      '',
    );
  }

  bool isLoading = false;
  UserAgentHelper? _userAgentHelper;
  AppHttp? _http;
  //CancelToken? _cancelToken;

  void getProductList(BuildContext context) async {
    isLoading = true;

    //commented cancel logic, still debugging request cancellation
    //_cancelToken?.cancel('cancel current request, will have a new getProductList request');
    //_cancelToken = CancelToken();

    _userAgentHelper ??= UserAgentHelper.shared;
    final userAgent = await _userAgentHelper!.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.get(
      ApiEndpoint.getProducts(),
      params: generateGetProductListRequest().toMap(),
      token: null, //put cancel token here
    );

    //_cancelToken?.whenCancel.then((_){});
    //_cancelToken = null;

    if (res.statusCode == 200 && res.statusCode != 429) {
      final pl = ProductListResponse.fromJson(jsonDecode(res.toString()));
      isLoading = false;
      _productTotal = pl.total ?? 0;
      notifyListeners();
    }
  }

  void appyFilterToProductList(ProductListProvider productListProvider) {
    productListProvider.updateAppliedFilters(
      aAppliedCategories: _appliedCategories,
      aAppliedFilters: _appliedFilters,
    );
    productListProvider.resetProductList();
    productListProvider.getProductList();
  }
}
