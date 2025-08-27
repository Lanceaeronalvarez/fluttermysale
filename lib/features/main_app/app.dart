import 'package:flutter_mysale/features/main_app/controllers/main/shop_controller.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';

class App extends RouteManager {
  static const String name = '';
  static const String home = '${App.name}/';
  static const String about = '${App.name}/about';
  static const String contact = '${App.name}/contact';
  static const String news = '${App.name}/news';
  static const String getappsettings = '${App.name}/getappsettings';
  static const String filtercategory = '${App.name}/filtercategory';
  static const String filtermain = '${App.name}/filtermain';
  static const String filterprice = '${App.name}/filterprice';
  static const String filterselect = '${App.name}/filterselect';
  static const String sort = '${App.name}/sort';

  App() {
    addRoute(App.home, (context) => const ShopController());
    addRoute(App.about, (context) => const AboutController());
    addRoute(App.contact, (context) => const ContactController());
    addRoute(App.news, (context) => const NewsController());
    addRoute(App.getappsettings, (context) => const GetAppSettingsController());
    addRoute(App.filtercategory, (context) => const FilterCategoryController());
    addRoute(App.filtermain, (context) => const FilterMainController());
    addRoute(App.filterprice, (context) => const FilterPriceController());
    addRoute(App.filterselect, (context) => const FilterSelectController());
    addRoute(App.sort, (context) => const SortController());
  }
}
