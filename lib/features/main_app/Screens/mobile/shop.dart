import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/widgets/leader_banner.dart';
import 'package:flutter_mysale/features/main_app/widgets/normal_banner.dart';
import 'package:flutter_mysale/features/main_app/widgets/sliding_banner.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../models/main/banners_model.dart';
import '../../models/main/facetfilter_model.dart';
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

  String _logoImagePath = "assets/images/logo.png";

  GetBannersRequest request = GetBannersRequest(
    null,
    null,
    "10",
    null,
    null,
    null,
    true,
    true,
    null,
  );

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
    getSlidingBanners();
    getShopBanners(request);
    getLeaderboardBanner("");
  }

  Future<List<BannerModel>?> getShopBanners(GetBannersRequest request) async {
    ShopBannersProvider bannersProvider =
        await ShopBannersProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    return bannersProvider.getShopBanners(request);
  }

  Future<List<BannerModel>?> getSlidingBanners() async {
    SlidingBannersProvider bannersProvider =
        await SlidingBannersProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    return bannersProvider.getSlidingBanners();
  }

  Future<void> getSponsoredBanners(String categoryId) async {
    SponsoredBannersProvider bannersProvider =
        await SponsoredBannersProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getSponsoredBanners(categoryId);
  }

  Future<BannerModel?> getLeaderboardBanner(String categoryId) async {
    LeaderboardBannerProvider bannersProvider =
        await LeaderboardBannerProvider.withUserAgent(context);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    return bannersProvider.getleaderboardBanners(
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
        backgroundColor: Colors.white,
        leadingWidth: 56,
        centerTitle: true,
        toolbarHeight: 56,
        leading: _catergoryScreen(),
        scrolledUnderElevation: 0, // stop darkening appbar on scroll
        surfaceTintColor: Colors.transparent, // disable Material 3 tint overlay
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0, // no shadow
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.75),
          child: Divider(
            height: 0.75,
            thickness: 0.75,
            color: Color(0xFFCCA68B),
          ),
        ),
        title: SizedBox(height: 32, child: _createAppbarLogo()),
        actions: [
          IconButton(
            onPressed: () {
              Nav.to(
                context,
                App.productList,
                arguments: (
                  categoryKeys: <String>[],
                  facetFilters: FacetFilterModel(),
                  sort: "",
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _shopScrollView(),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _shopScrollView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _createLeaderBoardBanner(),
          _createSlidingBanner(),
          _createNormalBanner(),
        ],
      ),
    );
  }

  Widget _createNormalBanner() {
    return FutureBuilder<List<BannerModel>?>(
      future: getShopBanners(request),
      builder:
          (BuildContext context, AsyncSnapshot<List<BannerModel>?> snapshot) {
            if (snapshot.hasData) {
              return NormalBannerWidget(banners: snapshot.data);
            } else {
              return SizedBox();
            }
          },
    );
  }

  Widget _createSlidingBanner() {
    return FutureBuilder<List<BannerModel>?>(
      future: getSlidingBanners(),
      builder:
          (BuildContext context, AsyncSnapshot<List<BannerModel>?> snapshot) {
            if (snapshot.hasData) {
              return SlidingBannerWidget(banners: snapshot.data);
            } else {
              return SizedBox();
            }
          },
    );
  }

  Widget _createLeaderBoardBanner() {
    return FutureBuilder<BannerModel?>(
      future: getLeaderboardBanner(""),
      builder: (BuildContext context, AsyncSnapshot<BannerModel?> snapshot) {
        if (snapshot.hasData) {
          return LeaderBannerWidget(banner: snapshot.data);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _createAppbarLogo() {
    return FittedBox(
      fit: BoxFit.contain,
      child: GestureDetector(
        onTap: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 28),
          child: Image.asset(_logoImagePath),
        ),
      ),
    );
  }

  Widget _catergoryScreen() {
    return GestureDetector(
      onTap: () {
        Nav.to(context, App.categoryTree);
      },
      child: Icon(Icons.list),
    );
  }
}
