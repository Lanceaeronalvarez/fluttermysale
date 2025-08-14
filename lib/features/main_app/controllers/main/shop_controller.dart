import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../Screens/desktop/shop.dart' as desktop;
import '../../Screens/mobile/shop.dart' as mobile;
import '../../Screens/tablet/shop.dart' as tablet;

class ShopController extends StatelessController {
  final String _title = 'Shop Page';
  const ShopController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: _title,
      mobile: mobile.Shop(title: _title),
      tabletLandscape: tablet.Shop(title: _title),
      desktop: desktop.Shop(title: _title),
    );
  }
}
