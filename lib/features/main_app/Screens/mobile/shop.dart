import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../models/main/banners_model.dart' as bannerModel;
import '../../providers/bestsellers_provider.dart';
import '../../providers/leaderboardbanner_provider.dart';
import '../../providers/shopbanners_provider.dart';
import '../../providers/slidingbanners_provider.dart';
import '../../providers/sponsoredbanners_provider.dart';
import '../../providers/trendingbrands_provider.dart';

class Shop extends StatefulWidget {
  final String? title;

  const Shop({Key? key, this.title}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  bool dayAndNight = false;

  List<bannerModel.Banner> _normalBannersData = [];

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
    getSlidingBanners();
  }

  Future<void> getShopBanners() async {
    ShopBannersProvider bannersProvider =
        await ShopBannersProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getShopBanners().then((
      bannerModel.GetBannersResponse? data,
    ) {
      setState(() {
        data?.groups?.forEach((bannerModel.Group it) {
          _normalBannersData.addAll(it.banners as Iterable<bannerModel.Banner>);
        });
      });
    });
  }

  Future<void> getSlidingBanners() async {
    SlidingBannersProvider bannersProvider =
        await SlidingBannersProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getSlidingBanners();
  }

  Future<void> getSponsoredBanners(String categoryId) async {
    SponsoredBannersProvider bannersProvider =
        await SponsoredBannersProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getSponsoredBanners(categoryId);
  }

  Future<void> getLeaderboardBanner(String categoryId) async {
    LeaderboardBannerProvider bannersProvider =
        await LeaderboardBannerProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getleaderboardBanners(
      "ShopPage",
      "MobileBrowser",
      categoryId,
    );
  }

  Future<void> getTrendingBrands(String categoryId) async {
    TrendingBrandsProvider bannersProvider =
        await TrendingBrandsProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getTrendingBrands(categoryId);
  }

  Future<void> getBestSellers(String category) async {
    BestSellersProvider bestSellersProvider =
        await BestSellersProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bestSellersProvider);
    bestSellersProvider.getBestSellers(category);
  }

  @override
  Widget build(BuildContext context) {
    var tm = context.read<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile: ${widget.title!}"),
        actions: actionsMenu(context),
      ),
      body: const Center(child: Text("Shop Page")),
      bottomNavigationBar: BottomBar(),
    );
  }
}
