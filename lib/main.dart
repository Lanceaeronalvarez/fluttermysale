import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/checkout_cart.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

import 'config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;

  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: appProviders, child: const MysaleApp()));
}

class MysaleApp extends StatelessWidget {
  const MysaleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    // print("My App: " + tm.isDarkMode.toString());

    return MaterialApp(
      title: 'Mysale',
      debugShowCheckedModeBanner: false,
      theme: MyTheme().lightTheme,
      darkTheme: MyTheme().darkTheme,
      themeMode: tm.themeMode,
      initialRoute: '/',
      routes: Routes().routes,
      onGenerateRoute: (settings) {
        if (settings.name == App.addToCart) {
          MediaQueryData mqd = MediaQuery.of(context);
          double widthPercentage = mqd.isTablet ? 0.5 : 0.9;
          //final a = settings.arguments as CartArgs;
          return CheckoutCart(
            mode: CheckoutCartMode.addToCart,
          ).asSideMenuRoute(widthPercentage: widthPercentage);
        } else if (settings.name == App.cartModal) {
          MediaQueryData mqd = MediaQuery.of(context);
          double widthPercentage = mqd.isTablet ? 0.5 : 0.9;
          //final a = settings.arguments as CartArgs;
          return CheckoutCart(
            mode: CheckoutCartMode.cartModal,
          ).asSideMenuRoute(widthPercentage: widthPercentage);
        }
        return null;
      },
      builder: (BuildContext context, Widget? child) {
        UserAgentHelper.shared.updateMediaQueryData(context);
        return child!;
      },
    );
  }
}
