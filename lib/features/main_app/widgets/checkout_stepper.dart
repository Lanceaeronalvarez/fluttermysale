import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';

enum CheckoutStep { cart, contact, shipping, payment }

class CheckoutStepper extends StatelessWidget {
  CheckoutStep currentCheckoutStep;
  ValueChanged<CheckoutStep> valueChanged;
  List<(CheckoutStep, String)> checkoutSteps = [
    (CheckoutStep.cart, 'CART'),
    (CheckoutStep.contact, 'CONTACT'),
    (CheckoutStep.shipping, 'SHIPPING'),
    (CheckoutStep.payment, 'PAYMENT'),
  ];

  CheckoutStepper({
    required this.currentCheckoutStep,
    required this.valueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: LayoutBuilder(
        builder: (lContext, constraints) {
          // Hide the number circle on very tight widths

          final minimalView = constraints.maxWidth < 380;

          List<Widget> widgets = [];
          for (final step in checkoutSteps.indexed) {
            int index = step.$1;
            CheckoutStep cs = step.$2.$1;
            String title = step.$2.$2;
            widgets.add(
              _createStepper(valueChanged, cs, title, index, minimalView),
            );
            if (index < checkoutSteps.length - 1) {
              widgets.add(_createStepperSeparator(minimalView));
            }
          }

          return SizedBox(
            height: 50,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widgets,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createStepperSeparator(bool minimalView) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: minimalView ? 6 : 12,
        height: 2,
        decoration: BoxDecoration(color: checkoutDarkGrey),
      ),
    );
  }

  Widget _createStepper(
    ValueChanged<CheckoutStep> valueChanged,
    CheckoutStep checkoutStep,
    String title,
    int index,
    bool minimalView,
  ) {
    bool isSelected = checkoutStep == currentCheckoutStep;
    return GestureDetector(
      onTap: () {
        currentCheckoutStep = checkoutStep;
        valueChanged.call(checkoutStep);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          if (!minimalView)
            CircleAvatar(
              radius: 10,
              backgroundColor: isSelected ? Colors.black : checkoutDarkGrey,
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          const SizedBox(width: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
