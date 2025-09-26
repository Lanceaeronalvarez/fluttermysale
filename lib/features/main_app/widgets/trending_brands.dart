// ignore_for_file: public_member_api_docs

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/banner_image_url_helper.dart';

import '../models/main/banners_model.dart';

typedef TrendingBrandBannerTappedCallback = void Function(BannerModel);

class TrendingBrandsWidget extends StatefulWidget {
  final List<BannerModel>? brands;
  final TrendingBrandBannerTappedCallback? onTap;

  const TrendingBrandsWidget({super.key, this.brands, this.onTap});

  @override
  State<TrendingBrandsWidget> createState() => _TrendingBrandsWidgetState();
}

class _TrendingBrandsWidgetState extends State<TrendingBrandsWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final brands = widget.brands ?? [];
    final int totalPages = (brands.length / 3).ceil();

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildCarousel(brands, totalPages),
          _buildIndicator(totalPages),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text(
        'Trending Brands',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCarousel(List<BannerModel> brands, int totalPages) {
    return CarouselSlider.builder(
      itemCount: totalPages,
      options: CarouselOptions(
        aspectRatio: 2.2,
        enlargeCenterPage: false,
        viewportFraction: 1,
        autoPlay: true,
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          setState(() => _currentIndex = index);
        },
      ),
      itemBuilder: (BuildContext context, int index, int realIdx) {
        final int first = index * 3;
        final int second = first + 1;
        final int third = first + 2;

        final List<int> indexes = <int>[
          first,
          second,
          third,
        ].where((i) => i < brands.length).toList();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: indexes
              .map((idx) => Expanded(child: _buildBrandItem(brands[idx])))
              .toList(),
        );
      },
    );
  }

  Widget _buildIndicator(int totalPages) {
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

  Widget _buildBrandItem(BannerModel banner) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(banner);
        }
      },
      child: _BrandItem(brand: banner),
    );
  }
}

class _BrandItem extends StatelessWidget {
  final BannerModel brand;

  const _BrandItem({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.network(
              BannerImageUrlHelper.appendBannerSizeUrl(brand.image, 313, 603, 440),
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            brand.percentOffText ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            brand.description ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class TrendingBrand {
  final String imageUrl;
  final String description;
  final String discount;

  TrendingBrand({
    required this.imageUrl,
    required this.description,
    required this.discount,
  });
}
