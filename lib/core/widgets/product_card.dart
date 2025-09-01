import 'package:flutter/material.dart';

import '../../features/main_app/models/model.dart';
import 'price_block.dart';

class ProductCard extends StatefulWidget {
  final ProductItem product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final Color cardColor;
  final Color textColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? width;
  final double? height;
  final double imageHeight;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.cardColor = Colors.white,
    this.textColor = Colors.black,
    this.borderRadius,
    this.borderWidth,
    this.width = 300,
    this.height = 0,
    this.imageHeight = 200,
  });

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final radius = widget.borderRadius ?? 0.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
          border: widget.borderWidth != null
              ? Border.all(color: Colors.grey, width: widget.borderWidth!)
              : null,
        ),
        child: _buildProductCard(product, radius),
      ),
    );
  }

  Widget _buildProductCard(ProductItem product, double radius) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(
          product.images != null && product.images!.isNotEmpty
              ? product.images!.first
              : null,
          radius,
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBrandName(product.brandName ?? ""),
              _buildDescription(product.description ?? ""),
              const SizedBox(height: 25),
              _buildPriceSection(product),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String? imageUrl, double radius) {
    return ClipRRect(
      borderRadius: radius > 0
          ? BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            )
          : BorderRadius.zero,
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: widget.imageHeight,
              width: double.infinity,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image)),
            )
          : Container(
              height: widget.imageHeight,
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.image, size: 40)),
            ),
    );
  }

  Widget _buildBrandName(String category) {
    return Row(
      children: [
        Expanded(
          child: Text(
            category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildFavoriteButton(),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () {
        setState(() => _isAdded = !_isAdded);
        widget.onFavoritePressed?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _isAdded ? Colors.redAccent : Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isAdded ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildDescription(String name) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildPriceSection(ProductItem product) {
    final priceText = product.salePrice != null
        ? "\$${formatPrice(product.salePrice!.value)}"
        : "\$${formatPrice(product.price?.value)}";

    final discountText = product.salePercentOffText;
    final savingsText = product.savedMoneyValue != null
        ? "SAVE \$${product.savedMoneyValue!.toStringAsFixed(2)}"
        : null;

    final originalPriceText = "\$${formatPrice(product.price?.value)}";

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PriceBlock(
            price: priceText,
            discountText: discountText,
            savingsText: savingsText,
          ),
          Text(
            "Don't pay $originalPriceText",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
          ),
        ],
      ),
    );
  }

  String formatPrice(double? value) {
    if (value == null) return "0";
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }
}
