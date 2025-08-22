import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../models/main/banners_model.dart';
import '../../providers/banners_provider.dart';
import '../../providers/bestsellers_provider.dart';
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

  Future<void> getBanners(
      GetBannersRequest request,
      bool getOnlyFromNetwork,
      ) async {
    UserAgentProvider userAgentProvider = Provider.of<UserAgentProvider>(
      context,
      listen: false,
    );
    String userAgent = await userAgentProvider.userAgent;
    BannersProvider bannersProvider = BannersProvider(userAgent);
    ChangeNotifierProvider(create: (context) => bannersProvider);
    bannersProvider.getBanners(request, getOnlyFromNetwork);
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
        title: Text("Mobile: ${widget.title!}"),
        actions: actionsMenu(context),
      ),
      body: const Center(child: Text("Shop Page")),
      bottomNavigationBar: BottomBar(),
    );
  }
}
