import 'package:flutter/material.dart';

class LeaderBannerWidget extends StatefulWidget {
  final LeaderBanner? brands;

  const LeaderBannerWidget({super.key, this.brands});

  @override
  State<LeaderBannerWidget> createState() => _LeaderBannerWidgetState();
}

class _LeaderBannerWidgetState extends State<LeaderBannerWidget> {
  // Default fallback data
  final LeaderBanner defaultBrands = LeaderBanner(
    imageUrl:
        'https://mslk.com/wp-content/uploads/2015/03/MSLK-EBU-article-animation.gif',
  );

  @override
  Widget build(BuildContext context) {
    final brands = widget.brands ?? defaultBrands;

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SizedBox(
        child: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Leader banner was clicked')),
            );
          },
          child: SizedBox(
            child: Image.network(
              brands.imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
        ),
      ),
    );
  }
}

class LeaderBanner {
  final String imageUrl;

  LeaderBanner({required this.imageUrl});
}
