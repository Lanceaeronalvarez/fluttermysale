// ignore_for_file: public_member_api_docs

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TrendingBrandsWidget extends StatefulWidget {
  final List<TrendingBrand>? brands;

  const TrendingBrandsWidget({super.key, this.brands});

  @override
  State<TrendingBrandsWidget> createState() => _TrendingBrandsWidgetState();
}

class _TrendingBrandsWidgetState extends State<TrendingBrandsWidget> {
  int _currentIndex = 0;

  final List<TrendingBrand> defaultBrands = [
    TrendingBrand(
      imageUrl:
          'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      description: 'Brand A',
      discount: 'Up to 30% Off',
    ),
    TrendingBrand(
      imageUrl:
          'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2xvdGhlc3xlbnwwfHwwfHx8MA%3D%3D',
      description: 'Brand B',
      discount: 'Up to 40% Off',
    ),
    TrendingBrand(
      imageUrl:
          'https://images.unsplash.com/photo-1503602642458-232111445657?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      description: 'Brand C',
      discount: 'Up to 20% Off',
    ),
    TrendingBrand(
      imageUrl:
          'https://images.unsplash.com/photo-1521334884684-d80222895322?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      description: 'Brand D',
      discount: 'Up to 50% Off',
    ),
    TrendingBrand(
      imageUrl:
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      description: 'Brand E',
      discount: 'Up to 30% Off',
    ),
    TrendingBrand(
      imageUrl:
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      description: 'Brand F',
      discount: 'Up to 80% Off',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final brands = widget.brands ?? defaultBrands;
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

  Widget _buildCarousel(List<TrendingBrand> brands, int totalPages) {
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
              .map((idx) => Expanded(child: _BrandItem(brand: brands[idx])))
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
}

class _BrandItem extends StatelessWidget {
  final TrendingBrand brand;

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
              brand.imageUrl,
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            brand.discount,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            brand.description,
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
