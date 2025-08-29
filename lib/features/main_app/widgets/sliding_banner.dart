import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart'
    as bannerModel;

class SlidingBannerWidget extends StatefulWidget {
  final List<bannerModel.Banner>? banners;

  const SlidingBannerWidget({super.key, this.banners});

  @override
  State<SlidingBannerWidget> createState() => _SlidingBannerWidgetState();
}

class _SlidingBannerWidgetState extends State<SlidingBannerWidget> {
  int _currentIndex = 0;

  String appendBannerSizeUrl(String? url) {
    // will move to utils
    int width = 475;
    int height = 325;
    int resolutionOverride = 800;

    if (url != null) {
      String removedExtension = url.substring(0, url.lastIndexOf("."));
      String extension = "";

      int i = url.lastIndexOf('.');
      if (i > 0) {
        extension = url.substring(i + 1);
      }

      url = "${removedExtension}_${width}x${height}.${extension}";

      if (url.contains("?")) {
        url = "$url&width=$resolutionOverride";
      } else {
        url = "$url?width=$resolutionOverride";
      }
      return url;
    } else {
      return "";
    }
  }

  Widget slidingBanner(bannerModel.Banner banner) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          //TODO: on tap logic
        },
        child: slidingBannerView(banner),
      ),
    );
  }

  Widget slidingBannerView(bannerModel.Banner banner) {
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

  Widget slidingBannerImage(bannerModel.Banner banner) {
    return SizedBox(
      child: Image.network(
        appendBannerSizeUrl(banner.image),
        fit: BoxFit.cover,
        width: MediaQuery.sizeOf(context).width,
        height: 250,
      ),
    );
  }

  Widget slidingBannerDescription(bannerModel.Banner banner) {
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

  Widget slidingBannerIndicator(List<bannerModel.Banner> banners) {
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

  Widget carouselBuilder(List<bannerModel.Banner> banners) {
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
