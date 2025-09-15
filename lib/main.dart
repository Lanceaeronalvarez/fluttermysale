import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/checkoutcart.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
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
        if (settings.name == App.cartModal) {
          //final a = settings.arguments as CartArgs;
          return CheckoutCart(
            mode: CheckoutCartMode.addToCart,
          ).asSideMenuRoute();
        }
        return null;
      },
    );
  }
}
