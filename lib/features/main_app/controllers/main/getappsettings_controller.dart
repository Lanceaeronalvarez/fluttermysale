import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../Screens/desktop/getappsettings.dart' as desktop;
import '../../Screens/mobile/getappsettings.dart' as mobile;
import '../../Screens/tablet/getappsettings.dart' as tablet;

class GetAppSettingsController extends StatelessController {
  final String _title = 'GetAppSettings Page';
  const GetAppSettingsController({Key? key}) : super(key: key);

  @override
  bool get shouldCheckAuthentication => true;

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: _title,
      mobile: mobile.GetAppSettings(title: _title),
      tabletLandscape: tablet.GetAppSettings(title: _title),
      desktop: desktop.GetAppSettings(title: _title),
    );
  }
}
