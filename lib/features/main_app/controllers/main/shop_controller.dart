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
  final List<ChangeNotifier> _providers = [];
  final List<ChangeNotifierProvider<ChangeNotifier>> _changeNotifierProviders = [];

  @override
  void initState() {
    super.initState();
    String? category = widget.args.category;
    _createProvider<ShopBannersProvider>(ShopBannersProvider(context: context, category: category));
    _createProvider<SlidingBannersProvider>(SlidingBannersProvider(context: context));
    _createProvider<SponsoredBannersProvider>(SponsoredBannersProvider(context: context, category: category));
    _createProvider<LeaderboardBannerProvider>(LeaderboardBannerProvider(context: context, category: category));
    _createProvider<TrendingBrandsProvider>(TrendingBrandsProvider(context: context, category: category));
    _createProvider<BestSellersProvider>(BestSellersProvider(context: context, category: category));
  }

  @override
  void dispose() {
    _providers.forEach((p) {
      p.dispose();
    });
    super.dispose();
  }

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: widget._title,
      mobile: MultiProvider(
        providers: _changeNotifierProviders,
        child: mobile.Shop(title: widget._title),
      ),
      tabletLandscape: MultiProvider(
        providers: _changeNotifierProviders,
        child: tablet.Shop(title: widget._title), //TODO
      ),
      desktop: MultiProvider(
        providers: _changeNotifierProviders,
        child: tablet.Shop(title: widget._title), //TODO?
      ),
    );
  }

  void _createProvider<T extends ChangeNotifier>(T p) {
    _providers.add(p);
    _changeNotifierProviders.add(ChangeNotifierProvider<T>(create: (context) => p));
  }
}
