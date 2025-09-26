// ignore_for_file: public_member_api_docs
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/widgets/product_card.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';

typedef ProductCarouselTappedCallback = void Function(ProductItem);

class ProductCarousel extends StatefulWidget {
  final List<ProductItem>? products;
  final String title;
  final ProductCarouselTappedCallback? onTap;

  const ProductCarousel({
    super.key,
    this.products,
    required this.title,
    this.onTap,
  });

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final products = widget.products ?? _mockProducts();

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createHeader(),
          const SizedBox(height: 8),
          _createCarousel(products),
          _createIndicator(products.length),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        widget.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _createCarousel(List<ProductItem> products) {
    return CarouselSlider.builder(
      carouselController: _controller,
      itemCount: products.length,
      itemBuilder: (context, index, realIdx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _createProductCard(products[index]),
        );
      },
      options: CarouselOptions(
        height: 360,
        enlargeCenterPage: false,
        enableInfiniteScroll: true,
        viewportFraction: 0.33,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        autoPlayAnimationDuration: const Duration(milliseconds: 300),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _createIndicator(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Image.asset(
            _currentIndex == index
                ? 'assets/images/indicator_selected.png'
                : 'assets/images/indicator_unselected.png',
            width: 20,
            height: 20,
          ),
        );
      }),
    );
  }

  Widget _createProductCard(ProductItem productItem) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(productItem);
        }
      },
      child: ProductCard(product: productItem, borderRadius: 8, borderWidth: 1),
    );
  }

  List<ProductItem> _mockProducts() {
    return [
      ProductItem(
        "1",
        "Air Max 270",
        "Nike",
        "Breathable running shoes with modern design.",
        "Best Seller",
        Price("USD", 120.0),
        Price("USD", 150.0),
        null,
        null,
        [
          "https://cdn.mysalemarketplace.com/v1/files/bffa8ee4-22e7-45fa-805a-883311382e86/f77e22ffe59d8daa2c2ea933918e1a17_225x360.jpg?profile=img&b",
        ],
        true,
        "Now only \$120",
        ["Shoes", "Sportswear"],
        [],
        "nike-air-max-270",
        false,
        20,
        true,
        SalePrice("USD", 120.0),
        "20% OFF",
        50,
        "Standard",
        30.0,
        20.0,
      ),
      ProductItem(
        "2",
        "Galaxy S23",
        "Samsung",
        "Latest flagship smartphone with pro-grade camera.",
        "Hot Deal",
        Price("USD", 999.0),
        Price("USD", 1199.0),
        null,
        null,
        [
          "https://cdn.mysalemarketplace.com/v1/files/bffa8ee4-22e7-45fa-805a-883311382e86/b77612f2fde3582ccdb066f004a51ff7_225x360.jpg?profile=img&b",
        ],
        true,
        "Discounted to \$999",
        ["Electronics", "Smartphones"],
        [],
        "samsung-galaxy-s23",
        false,
        15,
        true,
        SalePrice("USD", 5),
        "15% OFF",
        0,
        "Express",
        200.0,
        15.0,
      ),
      ProductItem(
        "3",
        "Leather Handbag",
        "Gucci",
        "Premium quality leather handbag with gold-tone hardware.",
        "Luxury",
        Price("USD", 130),
        Price("USD", 130),
        null,
        null,
        [
          "https://cdn.mysalemarketplace.com/v1/files/bffa8ee4-22e7-45fa-805a-883311382e86/6ce24061dc5deb66ae376676bfd369fa_225x360.jpg?profile=img&b",
        ],
        true,
        "High End",
        ["Bags", "Luxury"],
        [],
        "leather-handbag",
        false,
        20,
        false,
        SalePrice("USD", 12),
        "20% OFF",
        200,
        "Express",
        300.0,
        20.0,
      ),
      ProductItem(
        "4",
        "Wireless Headphones",
        "Sony",
        "Noise-cancelling over-ear headphones with 30h battery life.",
        "Tech Pick",
        Price("USD", 4),
        Price("USD", 5),
        null,
        null,
        [
          "https://cdn.mysalemarketplace.com/v1/files/bffa8ee4-22e7-45fa-805a-883311382e86/8c2e64e9660bf17a0bc54d9aaf7c9248_225x360.jpg?profile=img&b",
        ],
        true,
        "Electronics",
        ["Audio", "Headphones"],
        [],
        "wireless-headphones",
        false,
        20,
        true,
        SalePrice("USD", 199),
        "20% OFF",
        100,
        "Standard",
        50.0,
        20.0,
      ),
      ProductItem(
        "5",
        "Classic White Sneakers",
        "Adidas",
        "Clean and versatile sneakers perfect for everyday wear.",
        "Best Seller",
        Price("USD", 89),
        Price("USD", 120),
        null,
        null,
        [
          "https://cdn.mysalemarketplace.com/v1/files/bffa8ee4-22e7-45fa-805a-883311382e86/35602707dc8c5287c3b95699ecd5f2cc_50x50.jpg?profile=img&b",
        ],
        true,
        "Discounted",
        ["Shoes", "Sneakers"],
        [],
        "classic-white-sneakers",
        false,
        25,
        true,
        SalePrice("USD", 89.99),
        "25% OFF",
        50,
        "Standard",
        30.0,
        25.0,
      ),
    ];
  }
}
