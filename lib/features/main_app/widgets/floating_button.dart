import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final bool isLoading;

  const FloatingButton({
    Key? key,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _createFloatingContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _createAddToCartButton(isLoading),
          const SizedBox(width: 12),
          _createBuyNowButton(isLoading),
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

  Widget _createAddToCartButton(bool isLoading) {
    return _buildActionButton(
      onTap: () {
        if (!isLoading) onAddToCart.call();
      },
      backgroundColor: const Color(0xFF54ECFF),
      shadowColor: Colors.black,
      highlightColor: Colors.black.withOpacity(0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(color: Colors.black),
            ),
          if (!isLoading)
            Image.asset("assets/images/icon_cart.png", width: 25, height: 25),
          if (!isLoading) const SizedBox(width: 6),
          if (!isLoading)
            const Text(
              "Add to Cart",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _createBuyNowButton(bool isLoading) {
    return _buildActionButton(
      onTap: () {
        if (!isLoading) onBuyNow.call();
      },
      backgroundColor: Colors.black,
      shadowColor: const Color(0xFF54ECFF),
      highlightColor: Colors.white.withOpacity(0.4),
      child: isLoading
          ? SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(color: Color(0xFF54ECFF)),
            )
          : const Text(
              "Buy Now",
              style: TextStyle(
                color: Color(0xFF54ECFF),
                fontWeight: FontWeight.bold,
              ),
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
