import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/providers/bestsellers_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/leaderboardbanner_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/slidingbanners_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/sponsoredbanners_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/trendingbrands_provider.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../Screens/mobile/shop.dart' as mobile;
import '../../Screens/tablet/shop.dart' as tablet;
import '../../providers/shopbanners_provider.dart';

class ShopArguments {
  String? title;
  String? category;

  ShopArguments._(this.title, this.category);

  factory ShopArguments({String? title, String? category}) {
    return ShopArguments._(title, category);
  }
}

class ShopController extends StatefulController {
  final ShopArguments args;

  final String _title = 'Shop Page';

  ShopController({Key? key, required this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShopControllerState();
  }
}

class _ShopControllerState extends ControllerState<ShopController> {
  late final List<
      ChangeNotifierProvider<ChangeNotifier>> _providers;

  @override
  void initState() {
    super.initState();
    String? category = widget.args.category;
    _providers = [
      ChangeNotifierProvider<ShopBannersProvider>(create: (context) =>
          ShopBannersProvider(context: context, category: category),
      ),
      ChangeNotifierProvider<SlidingBannersProvider>(create: (context) =>
          SlidingBannersProvider(context: context),
      ),
      ChangeNotifierProvider<SponsoredBannersProvider>(create: (context) =>
          SponsoredBannersProvider(context: context, category: category),
      ),
      ChangeNotifierProvider<LeaderboardBannerProvider>(create: (context) =>
          LeaderboardBannerProvider(context: context, category: category),
      ),
      ChangeNotifierProvider<TrendingBrandsProvider>(create: (context) =>
          TrendingBrandsProvider(context: context, category: category),
      ),
      ChangeNotifierProvider<BestSellersProvider>(create: (context) =>
          BestSellersProvider(context: context, category: category),
      )
    ];
  }

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: widget._title,
      mobile: MultiProvider(
        providers: _providers,
        child: mobile.Shop(title: widget.args.title),
      ),
      tabletLandscape: MultiProvider(
        providers: _providers,
        child: tablet.Shop(title: widget.args.title), //TODO
      ),
      desktop: MultiProvider(
        providers: _providers,
        child: tablet.Shop(title: widget.args.title), //TODO?
      ),
    );
  }
}
