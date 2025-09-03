import 'dart:math' as math;

import 'package:flutter/material.dart';

class PriceBlock extends StatelessWidget {
  final String price;
  final String? discountText;
  final String? savingsText;

  const PriceBlock({
    super.key,
    required this.price,
    this.discountText,
    this.savingsText,
  });

  bool get hasDiscount =>
      (discountText?.isNotEmpty ?? false) || (savingsText?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: hasDiscount ? Border.all(color: Colors.grey.shade400) : null,
      ),
      child: Row(
        mainAxisAlignment: hasDiscount
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          _buildPriceTrapezium(),
          if (hasDiscount) const SizedBox(width: 4),
          if (hasDiscount) _buildDiscountBlock(),
        ],
      ),
    );
  }

  Widget _buildPriceTrapezium() {
    return ClipPath(
      clipper: TrapeziumClipper(angle: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
        color: Colors.black,
        alignment: Alignment.center,
        child: Text(
          price,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountBlock() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (discountText?.isNotEmpty ?? false) _buildText(discountText!),
            if (savingsText?.isNotEmpty ?? false) _buildText(savingsText!),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    );
  }
}

class TrapeziumClipper extends CustomClipper<Path> {
  final double angle;
  TrapeziumClipper({this.angle = 20});

  @override
  Path getClip(Size size) {
    final dx = size.height * math.tan(angle * math.pi / 180);
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - dx, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
