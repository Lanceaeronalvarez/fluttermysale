import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../classes/route_manager.dart';
import '../utils/bottom_util.dart';
import '../utils/button_data.dart';

// ignore: must_be_immutable
class BottomBar extends StatelessWidget {
  int index = 0;
  int len = 0;

  List<ButtonData>? buttonDatas;
  BottomBar({Key? key, this.buttonDatas}) : super(key: key) {
    buttonDatas =
        buttonDatas ??
        [
          ButtonData(icon: Icons.home, label: 'Shop', link: '/'),
          ButtonData(icon: Icons.people, label: 'Brands', link: '/'),
          ButtonData(
            icon: Icons.shopping_cart,
            label: 'Checkout',
            link: App.checkout,
          ),
          ButtonData(
            icon: Icons.heart_broken_rounded,
            label: 'Wishlist',
            link: '/',
          ),
          ButtonData(
            icon: Icons.account_circle,
            label: 'Account',
            link: App.accountMenu,
          ),
        ];
  }

  List<ButtonData> get buttonData => buttonDatas!;

  @override
  Widget build(BuildContext context) {
    len = buttonDatas!.length;
    var tm = context.read<ThemeProvider>();
    index = tm.index;

    if (len > 1) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (val) {
          tm.setNavIndex(val);
          index = val;
          navigator(context);
        },
        // items: [
        //   if (len > 1)
        //     for (ButtonData bd in buttonDatas)
        //       bottomNavigationBarItem(
        //         icon: Icon(bd.icon),
        //         label: bd.label,
        //       ),
        // ],
        items: buttonData
            .map(
              (e) =>
                  bottomNavigationBarItem(icon: Icon(e.icon), label: e.label),
            )
            .toList(),
      );
    } else {
      return Container();
    }
  }

  void navigator(BuildContext context) {
    Nav.to(context, buttonData[index].link!);
  }
}
