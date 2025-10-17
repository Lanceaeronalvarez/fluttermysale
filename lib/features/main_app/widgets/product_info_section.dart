import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/widgets/price_block.dart';
import 'package:flutter_mysale/features/main_app/models/main/productdetail_model.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductDetail product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createBrandName(),
          const SizedBox(height: 4),
          _createProductName(),
          const SizedBox(height: 8),
          _createPriceBlock(),
        ],
      ),
    );
  }

  Widget _createBrandName() {
    return Text(
      product.brandName ?? "",
      style: const TextStyle(
        fontSize: 20,
        color: Colors.brown,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationColor: Colors.brown,
      ),
    );
  }

  Widget _createProductName() {
    return Text(
      product.name ?? "No description",
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _createPriceBlock() {
    return PriceBlock(
      price: '${product.price?.value?.toMoneyString()}',
      discountText: '${product.totalPercentOff?.toMoneyString()}% OFF',
      savingsText: 'SAVE ${product.savedMoneyValue?.toMoneyString()}',
    );
  }
}
