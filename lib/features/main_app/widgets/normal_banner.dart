import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

class NormalBannerWidget extends StatefulWidget {
  final List<BannerModel>? banners;

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

  Widget normalBannerGestureDetector(BannerModel banner) {
    return GestureDetector(
      onTap: () {
        //TODO
      },
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: normalBannerView(banner),
      ),
    );
  }

  Widget normalBanner(BannerModel banner) {
    return SizedBox(child: normalBannerGestureDetector(banner));
  }

  Widget normalBannerView(BannerModel banner) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [normalBannerImage(banner), normalBannerDescription(banner)],
    );
  }

  Widget normalBannerImage(BannerModel banner) {
    return Image.network(
      appendBannerSizeUrl(banner.image),
      fit: BoxFit.contain,
    );
  }

  Widget normalBannerDescription(BannerModel banner) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            banner.description ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(banners.length, (index) {
        return normalBanner(banners[index]);
      }),
    );
  }
}
