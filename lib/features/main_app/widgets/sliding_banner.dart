import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SlidingBannerWidget extends StatefulWidget {
  final List<SlidingBanners>? brands;

  const SlidingBannerWidget({super.key, this.brands});

  @override
  State<SlidingBannerWidget> createState() => _SlidingBannerWidgetState();
}

class _SlidingBannerWidgetState extends State<SlidingBannerWidget> {
  // Default fallback data
  final List<SlidingBanners> defaultBrands = [
    SlidingBanners(
      imageUrl:
          'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      description: 'HUGE SAVINGS on Footwear',
    ),
    SlidingBanners(
      imageUrl:
          'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2xvdGhlc3xlbnwwfHwwfHx8MA%3D%3D',
      description: "HUGE SAVINGS on Women's Apparel",
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final brands = widget.brands ?? defaultBrands;

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: brands.length,
            options: CarouselOptions(
              aspectRatio: 1.4,
              enlargeCenterPage: false,
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIdx) {
              return SizedBox(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sliding banner $index was clicked'),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: Image.network(
                          brands[index].imageUrl,
                          fit: BoxFit.cover,
                          width: MediaQuery.sizeOf(context).width,
                          height: 250,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        brands[index].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(brands.length, (index) {
              return Container(
                child: _currentIndex == index
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 5,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(5),
                        child: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 5,
                        ),
                      ),
              );
            }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class SlidingBanners {
  final String imageUrl;
  final String description;

  SlidingBanners({required this.imageUrl, required this.description});
}
