import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/checkoutcart.dart'
    as universal;

class CheckoutCartController extends StatelessController {
  const CheckoutCartController.CheckoutController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(title: "Cart", mobile: universal.CheckoutCart());
  }
}
