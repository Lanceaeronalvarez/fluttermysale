import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../models/main/banners_model.dart';
import '../../providers/bestsellers_provider.dart';
import '../../providers/leaderboardbanner_provider.dart';
import '../../providers/shopbanners_provider.dart';
import '../../providers/slidingbanners_provider.dart';
import '../../providers/sponsoredbanners_provider.dart';
import '../../providers/trendingbrands_provider.dart';
import '../../providers/useragent_provider.dart';

class Shop extends StatefulWidget {
  final String? title;

  const Shop({Key? key, this.title}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  bool dayAndNight = false;

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
  }

  Future<void> getShopBanners(GetBannersRequest request) async {
    UserAgentProvider userAgentProvider = Provider.of<UserAgentProvider>(
      context,
      listen: false,
    );
    String userAgent = await userAgentProvider.userAgent;
    ShopBannersProvider bannersProvider = ShopBannersProvider(userAgent);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getShopBanners(request);
  }

  Future<void> getSlidingBanners() async {
    UserAgentProvider userAgentProvider = Provider.of<UserAgentProvider>(
      context,
      listen: false,
    );
    String userAgent = await userAgentProvider.userAgent;
    SlidingBannersProvider bannersProvider = SlidingBannersProvider(userAgent);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getSlidingBanners();
  }

  Future<void> getSponsoredBanners(String categoryId) async {
    UserAgentProvider userAgentProvider = Provider.of<UserAgentProvider>(
      context,
      listen: false,
    );
    String userAgent = await userAgentProvider.userAgent;
    SponsoredBannersProvider bannersProvider = SponsoredBannersProvider(
      userAgent,
    );
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getSponsoredBanners(categoryId);
  }

  Future<void> getLeaderboardBanner(String categoryId) async {
    UserAgentProvider userAgentProvider = Provider.of<UserAgentProvider>(
      context,
      listen: false,
    );
    String userAgent = await userAgentProvider.userAgent;
    LeaderboardBannerProvider bannersProvider = LeaderboardBannerProvider(
      userAgent,
    );
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getleaderboardBanners(
      "ShopPage",
      "DesktopBrowser",
      categoryId,
    );
  }

  Future<void> getTrendingBrands(String categoryId) async {
    UserAgentProvider userAgentProvider = Provider.of<UserAgentProvider>(
      context,
      listen: false,
    );
    String userAgent = await userAgentProvider.userAgent;
    TrendingBrandsProvider bannersProvider = TrendingBrandsProvider(userAgent);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getTrendingBrands(categoryId);
  }

  Future<void> getBestSellers(String category) async {
    UserAgentProvider userAgentProvider = Provider.of<UserAgentProvider>(
      context,
      listen: false,
    );
    String userAgent = await userAgentProvider.userAgent;
    BestSellersProvider bestSellersProvider = BestSellersProvider(userAgent);
    ChangeNotifierProvider(create: (context) => bestSellersProvider);
    bestSellersProvider.getBestSellers(category);
  }

  @override
  Widget build(BuildContext context) {
    var tm = context.read<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Desktop: ${widget.title!}"),
        actions: actionsMenu(context),
      ),
      body: const Center(child: Text("Shop Page")),
      bottomNavigationBar: BottomBar(),
    );
  }
}
