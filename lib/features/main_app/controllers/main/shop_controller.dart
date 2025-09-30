import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/providers/bestsellers_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/leaderboardbanner_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/slidingbanners_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/sponsoredbanners_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/trendingbrands_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../Screens/mobile/shop.dart' as mobile;
import '../../Screens/tablet/shop.dart' as tablet;
import '../../providers/shopbanners_provider.dart';

class ShopArguments {
  String? category;

  ShopArguments._(this.category);

  factory ShopArguments({String? category}) {
    return ShopArguments._(category);
  }
}

class ShopController extends StatelessController {
  final ShopArguments args;

  final String _title = 'Shop Page';

  ShopController({Key? key, required this.args}) : super(key: key);

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: _title,
      mobile: MultiProvider(
        providers: _providers(),
        child: mobile.Shop(title: _title),
      ),
      tabletLandscape: MultiProvider(
        providers: _providers(),
        child: tablet.Shop(title: _title), //TODO
      ),
      desktop: MultiProvider(
        providers: _providers(),
        child: tablet.Shop(title: _title), //TODO?
      ),
    );
  }

  List<SingleChildWidget> _providers() {
    return [
      ChangeNotifierProvider<ShopBannersProvider>(
        create: (context) =>
            ShopBannersProvider(context: context, category: args.category),
      ),
      ChangeNotifierProvider<SlidingBannersProvider>(
        create: (context) => SlidingBannersProvider(context: context),
      ),
      ChangeNotifierProvider<SponsoredBannersProvider>(
        create: (context) =>
            SponsoredBannersProvider(context: context, category: args.category),
      ),
      ChangeNotifierProvider<LeaderboardBannerProvider>(
        create: (context) => LeaderboardBannerProvider(
          context: context,
          category: args.category,
        ),
      ),
      ChangeNotifierProvider<TrendingBrandsProvider>(
        create: (context) =>
            TrendingBrandsProvider(context: context, category: args.category),
      ),
      ChangeNotifierProvider<BestSellersProvider>(
        create: (context) =>
            BestSellersProvider(context: context, category: args.category),
      ),
    ];
  }
}
