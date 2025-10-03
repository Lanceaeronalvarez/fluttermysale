import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productsort_model.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

import '../../features/lead_mod/utils/utils.dart';
import '../../features/main_app/app.dart';
import '../../features/main_app/controllers/main/productlist_controller.dart';
import '../../features/main_app/models/main/banners_linkoptions_model.dart';
import '../../features/main_app/models/main/banners_model.dart';
import '../classes/route_manager.dart';

class ShopBannersOnTapHelper {
  static void onBannerTapped(BuildContext context, BannerModel banner) {
    debugPrint("banner: " + banner.toString());
    if (banner.linkOptions != null) {
      String? title;
      String? searchQuery = banner.linkOptions?.searchQuery;
      String saleId = "";
      String? sorting = banner.linkOptions?.sorting;
      ProductSortModel? sortingModel = sorting == null || sorting!.isEmpty
          ? null
          : ProductSortModel(
              key: banner.linkOptions?.sorting,
              title: banner.linkOptions?.sorting,
            );
      List<CategoryNodeModel> appliedCategories;
      if (banner.linkOptions?.category?["id"] != null && banner.linkOptions!.category!["id"]!.isNotEmpty) {
        appliedCategories = [
          CategoryNodeModel.fromJson(banner.linkOptions!.category!),
        ];
      } else {
        appliedCategories = [];
      }
      List<FacetFilterModel> appliedFilters = banner.linkOptions?.facets != null
          ? FacetFilterModel.createFromLinkOptionsFacets(
              banner.linkOptions!.facets!,
            )
          : [];
      switch (banner.linkOptions!.getLinkOptionType()) {
        case LinkOptionType.searchQuery:
          break;
        case LinkOptionType.sale:
          saleId = banner.linkOptions?.facets?.saleId ?? saleId;
          title = banner.description;
          break;
        case LinkOptionType.category:
          title = banner.linkOptions?.category?["name"];
          break;
        case LinkOptionType.promo:
          saleId = banner.linkOptions?.facets?.promoSaleId ?? saleId;
          title = banner.description;
          break;
        case LinkOptionType.unknown:
          break;
      }
      ProductListArguments arguments = ProductListArguments(
        title: title,
        initialSearchQuery: searchQuery,
        saleId: saleId ?? "",
        appliedCategories: appliedCategories,
        appliedFilters: appliedFilters,
        sort: sortingModel,
        originCategory: appliedCategories.isNotEmpty
            ? appliedCategories.first
            : null,
      );
      Nav.toNamed(context, App.productList, arguments: arguments);
    } else if (banner.bannerType == "brandBanner") {
      // support for no linkOptions category banner

      Uri uri = Uri.parse(banner.link!);

      String? saleId = uri.queryParameters["saleID"];

      if (saleId != null && saleId.isNotEmpty) {
        String? saleNameFromUri = null;
        final String path = uri.path;
        ProductListArguments arguments;
        if (path.isNotEmpty) {
          final List<String> directories = path.split("/");
          if (directories[0].isEmpty) {
            directories.remove(0);
          }
          saleNameFromUri = directories[2]
              .replaceAll('-', ' ')
              .replaceAll(" or ", " | ")
              .replaceAll(" and ", " & ")
              .fixServerApostropheS()
              .toTitleCase();

          arguments = ProductListArguments(
            title: saleNameFromUri,
            initialSearchQuery: null,
            saleId: saleId,
            appliedCategories: [],
            appliedFilters: [],
            sort: null,
            originCategory: null,
          );
        } else {
          String id = uri.pathSegments.last;
          arguments = ProductListArguments.withAppliedCategoryKeys(
            title: id,
            saleId: '',
            appliedCategoryKeys: [id],
            appliedFilters: [],
            sort: null,
          );
        }
        Nav.toNamed(context, App.productList, arguments: arguments);
      } else if (banner.link != null && banner.link!.isNotEmpty) {
        String link = banner.link!;
        RegExp regExp = RegExp(r'(?<=/s/)([^?\n\r])+');
        RegExpMatch? match = regExp.firstMatch(link);

        String title = " ";
        if (banner.description != null && banner.description!.isNotEmpty) {
          title = banner.description!;
        }

        if (match?[0] != null) {
          ProductListArguments arguments = ProductListArguments(
            title: title,
            initialSearchQuery: null,
            saleId: match![0]!,
            appliedCategories: [],
            appliedFilters: [],
            sort: null,
            originCategory: null,
          );
          Nav.toNamed(context, App.productList, arguments: arguments);
        } else {
          launchInBrowser(uri);
        }
      } else {
        launchInBrowser(uri);
      }
    } else {
      String? title = banner.description;
      String? searchQuery = banner.linkOptions?.searchQuery;
      String saleId = banner.destinationId ?? "";
      ProductListArguments arguments = ProductListArguments(
        title: title,
        initialSearchQuery: searchQuery,
        saleId: saleId,
        appliedCategories: [],
        appliedFilters: [],
        sort: null,
        originCategory: null,
      );
      Nav.toNamed(context, App.productList, arguments: arguments);
    }
  }
}
