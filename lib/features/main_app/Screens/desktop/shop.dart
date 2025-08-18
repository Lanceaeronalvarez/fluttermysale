import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';
import 'package:flutter_mysale/features/main_app/providers/banners_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/useragent_provider.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';

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
