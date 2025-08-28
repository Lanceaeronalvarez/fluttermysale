import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart'
    as bannerModel;

class NormalBannerWidget extends StatefulWidget {
  final List<bannerModel.Banner?> banners;

  const NormalBannerWidget({super.key, required this.banners});

  @override
  State<NormalBannerWidget> createState() => _NormalBannerWidgetState();
}

class _NormalBannerWidgetState extends State<NormalBannerWidget> {
  @override
  void initState() {
    super.initState();
  }

  String appendBannerSizeUrl(String? url) {
    int width = 475;
    int height = 325;

    if (url != null) {
      String removedExtension = url.substring(0, url.lastIndexOf("."));
      String extension = "";

      int i = url.lastIndexOf('.');
      if (i > 0) {
        extension = url.substring(i + 1);
      }

      url = "${removedExtension}_${width}x${height}.${extension}";

      if (url.contains("?")) {
        url = "${url}&width=800";
      } else {
        url = "$url?width=800";
      }
      print("bannerrul $url");
      return url;
    } else {
      return "";
    }
  }

  Widget normalBannerGestureDetector(bannerModel.Banner banner) {
    return GestureDetector(
      onTap: () {
        //TODO
      },
      child: normalBannerView(banner),
    );
  }

  Widget normalBanner(bannerModel.Banner banner) {
    return SizedBox(child: normalBannerGestureDetector(banner));
  }

  Widget normalBannerView(bannerModel.Banner banner) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [normalBannerImage(banner), normalBannerDescription(banner)],
    );
  }

  Widget normalBannerImage(bannerModel.Banner banner) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Image.network(
        appendBannerSizeUrl(banner.image),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget normalBannerDescription(bannerModel.Banner banner) {
    return Column(
      children: [
        Text(
          banner.description ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final banner = widget.banners;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(banner.length, (index) {
        return normalBanner(banner[index]!);
      }),
    );
  }
}
