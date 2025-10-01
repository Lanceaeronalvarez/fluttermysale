import 'package:flutter/material.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/core/helpers/deeplink_helper.dart';
import 'package:flutter_mysale/core/helpers/shop_banners_ontap_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/productlist_controller.dart';
import 'package:flutter_mysale/features/main_app/widgets/leaderboard_banner.dart';
import 'package:flutter_mysale/features/main_app/widgets/normal_banner.dart';
import 'package:flutter_mysale/features/main_app/widgets/product_carousel.dart';
import 'package:flutter_mysale/features/main_app/widgets/sliding_banner.dart';
import 'package:flutter_mysale/features/main_app/widgets/trending_brands.dart';
import 'package:provider/provider.dart';

import '../../models/main/banners_model.dart';
import '../../models/main/productitem_model.dart';
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

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
    (Provider.of<SlidingBannersProvider>(context, listen: false)).getSlidingBanners();
    (Provider.of<ShopBannersProvider>(context, listen: false)).getShopBanners();
    (Provider.of<SponsoredBannersProvider>(context, listen: false)).getSponsoredBanners();
    (Provider.of<LeaderboardBannerProvider>(context, listen: false)).getleaderboardBanners("MobileBrowser");
    (Provider.of<TrendingBrandsProvider>(context, listen: false)).getTrendingBrands();
    (Provider.of<BestSellersProvider>(context, listen: false)).getBestSellers();
  }

  bool hasCategory() {
    final ShopBannersProvider provider = Provider.of<ShopBannersProvider>(
      context,
      listen: false,
    );
    String? category = provider.category;
    return category != null && category.isNotEmpty;
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
        leading: hasCategory() ? null : _catergoryScreen(),
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
        title: widget.title != null && widget.title!.isNotEmpty
            ? Text(widget.title!, style: TextStyle(color: Colors.black))
            : SizedBox(height: 32, child: _createAppbarLogo()),
        actions: [
          IconButton(
            onPressed: () {
              ProductListArguments args = ProductListArguments(
                saleId: '',
                appliedCategories: [],
                appliedFilters: [],
                sort: null,
                originCategory: null,
              );
              Nav.toNamed(context, App.productList, arguments: args);
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
        // TODO: optimize, maybe slower than list/grid?
        children: [
          _createLeaderBoardBanner(),
          _createPromoBanner(),
          _createSlidingBanner(),
          _createTrendingBrands(),
          _createSponsoredBanner(),
          _createNormalBanner(),
          _createBestSellers(),
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
          return NormalBannerWidget(
            banners: _normalBanners,
            onTap: (BannerModel? banner) {
              if (banner != null) {
                ShopBannersOnTapHelper.onBannerTapped(context, banner);
              }
            },
          );
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
          return SlidingBannerWidget(
            banners: provider.slidingBanners,
            onTap: (BannerModel? banner) {
              if (banner != null) {
                ShopBannersOnTapHelper.onBannerTapped(context, banner);
              }
            },
          );
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
          return LeaderboardBannerWidget(
            banner: provider.leaderboardBanner,
            onTap: (BannerModel? banner) {
              if (banner?.link == null) {
                return;
              }
              DeepLinkHelper.processDeeplinkUri(
                context,
                Uri.parse((banner!.link)!),
              );
            },
          );
        }
      },
    );
  }

  Widget _createTrendingBrands() {
    return Consumer<TrendingBrandsProvider>(
      builder: (_, provider, __) {
        if (provider.trendingBrands == null ||
            provider.trendingBrands!.isEmpty) {
          return SizedBox();
        } else {
          return TrendingBrandsWidget(
            brands: provider.trendingBrands,
            onTap: (BannerModel? banner) {
              if (banner != null) {
                ShopBannersOnTapHelper.onBannerTapped(context, banner);
              }
            },
          );
        }
      },
    );
  }

  Widget _createSponsoredBanner() {
    return Consumer<SponsoredBannersProvider>(
      builder: (_, provider, __) {
        if (provider.sponsoredBanners == null ||
            provider.sponsoredBanners!.isEmpty) {
          return SizedBox();
        } else {
          return SlidingBannerWidget(
            banners: provider.sponsoredBanners,
            onTap: (BannerModel? banner) {
              if (banner != null) {
                ShopBannersOnTapHelper.onBannerTapped(context, banner);
              }
            },
          );
        }
      },
    );
  }

  Widget _createPromoBanner() {
    return Consumer<ShopBannersProvider>(
      builder: (_, provider, __) {
        if (provider.shopBanners == null) {
          return SizedBox();
        } else {
          List<BannerModel> promoBanners = [];
          provider.shopBanners?.groups?.forEach((Group it) {
            if (it.type == "promo") {
              if (it.banners?.first != null) {
                promoBanners.add(it.banners!.first);
              }
            }
          });
          return NormalBannerWidget(
            banners: promoBanners,
            onTap: (BannerModel? banner) {
              if (banner != null) {
                ShopBannersOnTapHelper.onBannerTapped(context, banner);
              }
            },
          );
        }
      },
    );
  }

  Widget _createBestSellers() {
    return Consumer<BestSellersProvider>(
      builder: (_, provider, __) {
        if (provider.getBestSellersResponse == null ||
            provider.getBestSellersResponse!.isEmpty) {
          return SizedBox();
        } else {
          return ProductCarousel(
            products: provider.getBestSellersResponse,
            onTap: (ProductItem productItem) {
              //TODO: pdp
            },
            title: '',
          );
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
