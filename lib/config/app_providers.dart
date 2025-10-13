import 'package:flutter_mysale/features/main_app/providers/address_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/categorytree_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/checkout_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/getappsettings_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/core.dart';
import '../features/features.dart';
import '../features/main_app/providers/news_provider.dart';
import 'app_theme.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
  ChangeNotifierProvider<GlobalStateManager>(
    create: (context) => GlobalStateManager(),
  ),
  ChangeNotifierProvider<NewsProvider>(create: (context) => NewsProvider()),
  ChangeNotifierProvider<EnqueryProvider>(
    create: (context) => EnqueryProvider(),
  ),
  ChangeNotifierProvider<GetAppSettingsProvider>(
    create: (context) => GetAppSettingsProvider(),
  ),
  ChangeNotifierProvider<CategoryTreeProvider>(
    create: (context) => CategoryTreeProvider(context: context),
  ),
  ChangeNotifierProvider<CheckoutProvider>(
    lazy: false,
    create: (context) => CheckoutProvider(),
  ),
  ChangeNotifierProvider<AddressProvider>(
    create: (context) => AddressProvider(),
  ),
  ChangeNotifierProvider<AuthenthicationProvider>(
    lazy: false,
    create: (context) => AuthenthicationProvider(),
  ),
];
