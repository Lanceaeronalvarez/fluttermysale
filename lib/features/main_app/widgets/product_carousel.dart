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
    final products = widget.products ?? [];

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
}
