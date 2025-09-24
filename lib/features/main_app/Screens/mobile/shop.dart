import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/productlist_controller.dart';
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

  List<BannerModel> _normalBanners = [];
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

  void getShopBanners(GetBannersRequest request) {
    final ShopBannersProvider provider = Provider.of<ShopBannersProvider>(
      context,
      listen: false,
    );
    provider.getShopBanners(request);
  }

  void getSlidingBanners() {
    final SlidingBannersProvider provider = Provider.of<SlidingBannersProvider>(
      context,
      listen: false,
    );
    provider.getSlidingBanners();
  }

  void getSponsoredBanners(String categoryId) {
    final SponsoredBannersProvider provider =
        Provider.of<SponsoredBannersProvider>(context, listen: false);
    provider.getSponsoredBanners(categoryId);
  }

  void getLeaderboardBanner(String categoryId) {
    final LeaderboardBannerProvider provider =
        Provider.of<LeaderboardBannerProvider>(context, listen: false);
    provider.getleaderboardBanners("ShopPage", "MobileBrowser", categoryId);
  }

  void getTrendingBrands(String categoryId) {
    final TrendingBrandsProvider provider = Provider.of<TrendingBrandsProvider>(
      context,
      listen: false,
    );
    provider.getTrendingBrands(categoryId);
  }

  void getBestSellers(String category) {
    final BestSellersProvider provider = Provider.of<BestSellersProvider>(
      context,
      listen: false,
    );
    provider.getBestSellers(category);
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
        scrolledUnderElevation: 0,
        // stop darkening appbar on scroll
        surfaceTintColor: Colors.transparent,
        // disable Material 3 tint overlay
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        // no shadow
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
              ProductListArguments args = ProductListArguments(
                saleId: '',
                appliedCategories: [],
                appliedFilters: [],
                sort: null,
              );
              Nav.to(context, App.productList, arguments: args);
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
    return Consumer<ShopBannersProvider>(
      builder: (_, provider, __) {
        if (provider.shopBanners == null) {
          return SizedBox();
        } else {
          provider.shopBanners?.groups?.forEach((Group it) {
            if (it.type == "main") {
              _normalBanners.addAll(
                it.banners as Iterable<BannerModel>,
              ); //TODO: paging
            }
          });
          return NormalBannerWidget(banners: _normalBanners);
        }
      },
    );
  }

  Widget _createSlidingBanner() {
    return Consumer<SlidingBannersProvider>(
      builder: (_, provider, __) {
        if (provider.slidingBanners == null) {
          return SizedBox();
        } else {
          return SlidingBannerWidget(banners: provider.slidingBanners);
        }
      },
    );
  }

  Widget _createLeaderBoardBanner() {
    return Consumer<LeaderboardBannerProvider>(
      builder: (_, provider, __) {
        if (provider.leaderboardBanner == null) {
          return SizedBox();
        } else {
          return LeaderBannerWidget(banner: provider.leaderboardBanner);
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
