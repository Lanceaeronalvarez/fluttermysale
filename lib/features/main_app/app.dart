import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/productlist_controller.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/shop_controller.dart';
import 'package:flutter_mysale/features/main_app/widgets/image_gallery.dart';
import 'package:flutter_mysale/features/main_app/widgets/image_gallery_zoom.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';

class App extends RouteManager {
  static const String name = '';
  static const String home = '${App.name}/';
  static const String about = '${App.name}/about';
  static const String contact = '${App.name}/contact';
  static const String news = '${App.name}/news';
  static const String productList = '${App.name}/productlist';
  static const String getappsettings = '${App.name}/getappsettings';
  static const String categoryTree = '${App.name}/categorytree';
  static const String filtercategory = '${App.name}/filtercategory';
  static const String filtermain = '${App.name}/filtermain';
  static const String filterprice = '${App.name}/filterprice';
  static const String filterselect = '${App.name}/filterselect';
  static const String productSort = '${App.name}/sort';
  static const String imagegallery = '${App.name}/imagegallery';
  static const String imagegalleryzoom = '${App.name}/imagegalleryzoom';
  static const String checkout = '${App.name}/checkout)';
  static const String cartModal =
      '${App.name}/cart/modal'; //not added on routes, navigation handled in MaterialApp onGenerateRoute since this have a custom transition

  App() {
    addRoute(App.home, (context) => const ShopController());
    addRoute(App.productList, (context) {
      ProductListArguments args =
          (ModalRoute.of(context)?.settings.arguments as ProductListArguments);
      return ProductListController(args: args);
    });
    addRoute(App.getappsettings, (context) => const GetAppSettingsController());
    addRoute(App.categoryTree, (context) => const CategoryTreeController());
    addRoute(App.filtercategory, (context) => const FilterCategoryController());
    addRoute(App.filtermain, (context) => const FilterMainController());
    addRoute(App.filterprice, (context) => const FilterPriceController());
    addRoute(App.filterselect, (context) => const FilterSelectController());
    addRoute(App.productSort, (context) => const ProductSortController());
    addRoute(App.imagegallery, (context) => const ImageGalleryWidget());
    addRoute(App.imagegalleryzoom, (context) => const ImageGalleryZoomWidget());
    addRoute(
      App.checkout,
      (context) => const CheckoutCartController.CheckoutController(),
    );
  }
}
