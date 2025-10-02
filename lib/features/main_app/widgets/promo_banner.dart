import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';

class PromoBanner extends StatelessWidget {
  VoidCallback onTap;

  PromoBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap.call();
      },
      child: Container(
        color: checkoutDarkGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'You have \$25 worth of vouchers. Don\'t forget to use them in the next 29 days.',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
