import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/banner_image_url_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

typedef SlidingBannerTappedCallback = void Function(BannerModel);

class SlidingBannerWidget extends StatefulWidget {
  final List<BannerModel>? banners;
  final SlidingBannerTappedCallback? onTap;

  const SlidingBannerWidget({super.key, this.banners, this.onTap});

  @override
  State<SlidingBannerWidget> createState() => _SlidingBannerWidgetState();
}

class _SlidingBannerWidgetState extends State<SlidingBannerWidget> {
  int _currentIndex = 0;

  Widget slidingBanner(BannerModel banner) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!(banner);
          }
        },
        child: slidingBannerView(banner),
      ),
    );
  }

  Widget slidingBannerView(BannerModel banner) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        slidingBannerImage(banner),
        const SizedBox(height: 16),
        slidingBannerDescription(banner),
      ],
    );
  }

  Widget slidingBannerImage(BannerModel banner) {
    return SizedBox(
      child: Image.network(
        BannerImageUrlHelper.appendBannerSizeUrl(banner.image, 475, 325, 800),
        fit: BoxFit.cover,
        width: MediaQuery.sizeOf(context).width,
        height: 250,
      ),
    );
  }

  Widget slidingBannerDescription(BannerModel banner) {
    return Text(
      banner.description ?? "",
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }

  Widget slidingBannerIndicator(List<BannerModel> banners) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(banners.length, (index) {
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
    );
  }

  Widget carouselBuilder(List<BannerModel> banners) {
    return CarouselSlider.builder(
      itemCount: banners.length,
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
        return slidingBanner(banners[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners ?? [];

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          carouselBuilder(banners),
          slidingBannerIndicator(banners),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
