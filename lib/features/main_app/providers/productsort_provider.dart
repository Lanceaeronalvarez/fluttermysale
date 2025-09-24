import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/config.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/productsort_model.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

class ProductSortProvider extends ChangeNotifier {
  ProductSortModel? _selectedSortItem;
  List<ProductSortModel>? _sortItems;

  ProductSortModel? get selectedSortItem => _selectedSortItem;
  List<ProductSortModel> get sortItems => _sortItems ?? [];

  ProductSortProvider._(this._selectedSortItem, this._sortItems);

  factory ProductSortProvider({required ProductSortModel? selectedSortItem, required List<ProductSortModel>? sortItems}) {
    return ProductSortProvider._(selectedSortItem, sortItems);
  }

  void setSelectedSortItem(
    ProductSortModel? selectedSortItem,
    ProductListProvider productListProvider,
  ) {
    _selectedSortItem = selectedSortItem;
    if (selectedSortItem != null) {
      productListProvider.updateSort(selectedSortItem);
      productListProvider.resetProductList();
      productListProvider.getProductList();
    }
    notifyListeners();
  }

  void setInitialSortInfo(
    ProductSortModel? selectedSortItem,
    List<ProductSortModel>? sortItems,
  ) {
    _selectedSortItem = selectedSortItem;
    _sortItems = sortItems;
  }

  bool isLoading = false;
  String? error;

  void fetchSortItems(UserAgentHelper userAgentHelper) async {
    if (_sortItems != null) {
      notifyListeners();
      return;
    }

    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners(); //notify observers that the request have started

    try {
      String userAgent = await userAgentHelper.userAgent;
      AppHttp http = AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

      Response response = await http.get(
        ApiEndpoint.getSorting(),
        params: {
          'platform': AppPlatform.getCurrentPlatform()?.name ?? '',
          'countryID': 'au',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed: ${response.statusCode}');
      }

      List<dynamic> list = (response.data as List<dynamic>?) ?? [];
      _sortItems = list
          .map((e) => ProductSortModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); //notify observers that the request is completed
    }
  }
}
