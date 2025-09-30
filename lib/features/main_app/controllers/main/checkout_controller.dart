import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/checkout_main.dart';

class CheckoutController extends StatelessController {
  const CheckoutController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(title: "Cart", mobile: CheckoutMain());
  }
}
