import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

import '../../features/lead_mod/utils/utils.dart';
import '../../features/main_app/app.dart';
import '../../features/main_app/controllers/main/productlist_controller.dart';
import '../../features/main_app/models/main/banners_linkoptions_model.dart';
import '../../features/main_app/models/main/banners_model.dart';
import '../classes/route_manager.dart';

class ShopBannersOnTapHelper {
  static void onBannerTapped(BuildContext context, BannerModel banner) {
    if (banner.linkOptions != null &&
        banner.linkOptions?.getLinkOptionType() == LinkOptionType.category) {
      ProductListArguments arguments = ProductListArguments(
        initialSearchQuery: null,
        saleId: "",
        appliedCategories: [],
        appliedFilters: [],
        sort: null,
        originCategory: null,
      );
      Nav.to(context, App.productList, arguments: arguments);
    } else if (banner.bannerType == "brandBanner") {
      // support for no linkOptions category banner

      Uri uri = Uri.parse(banner.link!);

      String? saleId = uri.queryParameters["saleID"];

      if (saleId != null && saleId.isNotEmpty) {
        String? saleNameFromUri = null;
        final String path = uri.path;
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

          ProductListArguments arguments = ProductListArguments(
            initialSearchQuery: null,
            saleId: saleId,
            appliedCategories: [],
            appliedFilters: [],
            sort: null,
            originCategory: null,
          );
          Nav.to(context, App.productList, arguments: arguments);
        } else {
          String id = uri.pathSegments.last;

          // TODO: goto category screen with category id, id
        }
      } else if (banner.link != null && banner.link!.isNotEmpty) {
        String link = banner.link!;
        RegExp regExp = RegExp(r'(?<=/s/)([^?\\n\\r])+');
        RegExpMatch? match = regExp.firstMatch(link);

        String title = " ";
        if (banner.description != null && banner.description!.isNotEmpty) {
          title = banner.description!;
        }

        if (match?[0] != null) {
          ProductListArguments arguments = ProductListArguments(
            initialSearchQuery: null,
            saleId: match![0]!,
            appliedCategories: [],
            appliedFilters: [],
            sort: null,
            originCategory: null,
          );
          Nav.to(context, App.productList, arguments: arguments);
        }
      } else {
        launchInBrowser(uri);
      }
    } else {
      String? searchQuery = banner.linkOptions?.searchQuery;
      String saleId = banner.destinationId!;
      if (banner.linkOptions != null) {
        switch (banner.linkOptions!.getLinkOptionType()) {
          case LinkOptionType.sale:
            saleId = banner.linkOptions?.facets?.saleId ?? saleId;
            break;
          case LinkOptionType.category:
            break;
          case LinkOptionType.promo:
            saleId = banner.linkOptions?.facets?.promoSaleId ?? saleId;
            break;
          case LinkOptionType.unknown:
            break;
        }
      }
      ProductListArguments arguments = ProductListArguments(
        initialSearchQuery: searchQuery,
        saleId: saleId,
        appliedCategories: [],
        appliedFilters: [],
        sort: null,
        originCategory: null,
      );
      Nav.to(context, App.productList, arguments: arguments);
    }
  }
}