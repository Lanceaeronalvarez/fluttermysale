import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const FloatingButton({
    Key? key,
    required this.onAddToCart,
    required this.onBuyNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _createFloatingContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _createAddToCartButton(),
          const SizedBox(width: 12),
          _createBuyNowButton(),
        ],
      ),
    );
  }

  Widget _createFloatingContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: child,
    );
  }

  Widget _createAddToCartButton() {
    return _buildActionButton(
      onTap: onAddToCart,
      backgroundColor: const Color(0xFF54ECFF),
      shadowColor: Colors.black,
      highlightColor: Colors.black.withOpacity(0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/icon_cart.png", width: 25, height: 25),
          const SizedBox(width: 6),
          const Text(
            "Add to Cart",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _createBuyNowButton() {
    return _buildActionButton(
      onTap: onBuyNow,
      backgroundColor: Colors.black,
      shadowColor: const Color(0xFF54ECFF),
      highlightColor: Colors.white.withOpacity(0.4),
      child: const Text(
        "Buy Now",
        style: TextStyle(color: Color(0xFF54ECFF), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color shadowColor,
    required Color highlightColor,
    required Widget child,
  }) {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(color: shadowColor, offset: const Offset(2, 2)),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
