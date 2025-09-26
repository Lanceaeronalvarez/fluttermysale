import 'package:flutter/cupertino.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

import '../../features/main_app/app.dart';
import '../../features/main_app/controllers/main/productlist_controller.dart';
import '../../features/main_app/models/main/facetfilter_model.dart';

class DeepLinkHelper {
  static bool processDeeplinkUri(BuildContext context, Uri uri) {
    debugPrint("Deeplink: " + uri.toString());
    final String path = uri.path;
    debugPrint("Path: " + path.toString());
    if (path.isNotEmpty) {
      final List<String> directories = path.split("/");
      if (directories.isEmpty) {
        _navigateToShopRoot(context);
        return true;
      }
      if (directories[0].isEmpty) {
        directories.removeAt(0);
        if (directories.isEmpty) {
          _navigateToShopRoot(context);
          return true;
        }
      }
      debugPrint("Directories: " + directories.toString());

      if (directories[0] == "ItemsList.aspx") {
        //saleBannerDetailsProvider.getDetails(uri.queryParameters["saleID"])
        // TODO: needs provider that calls the endpoint "getSaleBannerDetails2"
        // TODO: callback will call _deepLinkSaleItems
      } else if (directories[0] == "shop") {
        if (directories[1] == "sale") {
          // Specific Sale and Trending Now
          if (directories.length < 5) {
            return false;
          }
          String saleName = directories[2]
              .replaceAll("-", " ")
              .replaceAll(" or ", " | ")
              .replaceAll(" and ", " & ")
              .fixServerApostropheS()
              .toTitleCase();
          if (directories[3] != "s") {
            return false;
          }
          String saleId = directories[4];

          if (directories.length == 5) {
            String? saleIdParam = uri.queryParameters["saleID"];
            _deepLinkSaleItems(context, saleName, saleId, saleIdParam!);
          } else {
            if (!_deeplinkProductDetail(context, 5, saleId, directories)) {
              return false;
            }
          }
        } else if (directories[1] == "sales") {
          // Main sale category
          if (directories.length != 4) {
            return false;
          }
          String categoryName = directories[2].split("-").last.toTitleCase();
          String categoryId = directories[3];
          _deepLinkSaleCategory(context, categoryName, categoryId);
        } else if (directories[1] == "brand") {
          // Brand product list
          if (directories.length != 4) {
            return false;
          }
          String brandName = directories[2]
              .replaceAll("-", " ")
              .replaceAll(" or ", " | ")
              .replaceAll(" and ", " & ")
              .fixServerApostropheS()
              .toTitleCase();
          String brandId = directories[3];
          _deepLinkBrandProductList(context, brandName, brandId);
        } else if (directories[1] == "brands") {
          // Brands category
          if (directories.length != 2) {
            return false;
          }
          _deepLinkBrands(context);
        } else if (directories[1] == "search") {
          // Search
          if (directories.length != 2) {
            return false;
          }
          String? searchQuery = uri.queryParameters["query"];
          _deepLinkSearchQuery(context, searchQuery!);
        } else {
          if (directories.length == 3) {
            // Product list for subcategory
            String categoryId = _capitalizeCategoryKey(
              directories[1].replaceAll("-", ">>>").replaceAll("-and-", " & "),
            );
            String categoryName = categoryId.split(">>>").last.toTitleCase();
            _deepLinkSaleCategoryItems(context, categoryName, categoryId);
          }
        }
      } else if (directories[0] == "product") {
        if (!_deeplinkProductDetail(context, 0, null, directories)) {
          return false;
        }
      } else if (directories[0] == "brands") {
        // Brands category
        if (directories.length != 1) {
          return false;
        }
        _deepLinkBrands(context);
      } else {
        launchInBrowser(uri);
      }
    }
    return true;
  }

  static String _capitalizeCategoryKey(String str) {
    bool delimiter = true;
    String output = str;
    final int len = output.length;

    for (int i = 0; i < len; ++i) {
      String c = output[i];
      if (delimiter) {
        if (c != ' ') {
          // Convert to title case and switch out of whitespace mode.
          output.replaceRange(i, i + 1, c.toTitleCase());
          delimiter = false;
        }
      } else if (c == '>') {
        delimiter = true;
      } else {
        output.replaceRange(i, i + 1, c.toLowerCase());
      }
    }

    return output;
  }

  static bool _deeplinkProductDetail(
    BuildContext context,
    int index,
    String? saleId,
    List<String> directories,
  ) {
    if (!((directories.length - index == 4) &&
        directories[index] == "product" &&
        directories[index + 2] == "s")) {
      return false;
    }
    String productName = directories[index + 1]
        .replaceAll('-', ' ')
        .replaceAll(" or ", " | ")
        .replaceAll(" and ", " & ")
        .fixServerApostropheS()
        .toTitleCase();
    String productId = directories[index + 3];
    _deepLinkSaleItemDetails(context, saleId, productId, productName);
    return true;
  }

  static void _deepLinkSaleItemDetails(
    BuildContext context,
    String? saleId,
    String seoIdentifierId,
    String productName,
  ) {
    //TODO: pdp
  }

  static void openLocationFilterHash(
    BuildContext context,
    String locationFilterHash,
  ) {
    FacetFilterModel brand = FacetFilterModel.createBrands([locationFilterHash]);
    FacetFilterModel supplier = FacetFilterModel.createSupplierFromLocationFilterHash(locationFilterHash);

    ProductListArguments arguments = ProductListArguments(
      initialSearchQuery: locationFilterHash,
      saleId: "",
      appliedCategories: [],
      appliedFilters: [supplier, brand],
      sort: null,
      originCategory: null,
    );
    Nav.toNamed(context, App.productList, arguments: arguments);
  }

  static void _deepLinkSaleItems(
    BuildContext context,
    String bannerTitle,
    String saleId,
    String bannerId,
  ) {
    ProductListArguments arguments = ProductListArguments(
      initialSearchQuery: null,
      saleId: "",
      appliedCategories: [],
      appliedFilters: [],
      sort: null,
      originCategory: null,
    );
    Nav.toNamed(context, App.productList, arguments: arguments);
  }

  static void _deepLinkSearchQuery(BuildContext context, String searchQuery) {
    ProductListArguments arguments = ProductListArguments(
      initialSearchQuery: searchQuery,
      saleId: "",
      appliedCategories: [],
      appliedFilters: [],
      sort: null,
      originCategory: null,
    );
    Nav.toNamed(context, App.productList, arguments: arguments);
  }

  static void _deepLinkSaleCategory(
    BuildContext context,
    String categoryName,
    String categoryIdentifier,
  ) {
    Nav.to(context, App.home, arguments: (category: categoryIdentifier));
  }

  static void _deepLinkSaleCategoryItems(
    BuildContext context,
    String categoryName,
    String categoryIdentifier,
  ) {
    ProductListArguments arguments =
        ProductListArguments.withAppliedCategoryKeys(
          initialSearchQuery: null,
          saleId: "",
          appliedCategoryKeys: [categoryIdentifier],
          appliedFilters: [],
          sort: null,
        );
    Nav.toNamed(context, App.productList, arguments: arguments);
  }

  static void _deepLinkBrands(BuildContext context) {
    //TODO: brands page
  }

  static void _deepLinkBrandProductList(
    BuildContext context,
    String brandName,
    String brandId,
  ) {
    ProductListArguments arguments = ProductListArguments(
      initialSearchQuery: null,
      saleId: "",
      appliedCategories: [],
      appliedFilters: [
        FacetFilterModel.createBrands([brandId]),
      ],
      sort: null,
      originCategory: null,
    );
    Nav.toNamed(context, App.productList, arguments: arguments);
  }

  static void _navigateToShopRoot(BuildContext context) {
    Nav.to(context, App.home);
  }
}
