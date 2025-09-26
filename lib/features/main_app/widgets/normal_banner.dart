import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/banner_image_url_helper.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/productlist_controller.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

import '../../../core/classes/route_manager.dart';
import '../app.dart';

typedef BannerTappedCallback = void Function(BannerModel);

class NormalBannerWidget extends StatefulWidget {
  final List<BannerModel>? banners;
  final BannerTappedCallback? onTap;

  const NormalBannerWidget({super.key, required this.banners, this.onTap});

  @override
  State<NormalBannerWidget> createState() => _NormalBannerWidgetState();
}

class _NormalBannerWidgetState extends State<NormalBannerWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget normalBannerGestureDetector(BannerModel banner) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(banner);
        }
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
      BannerImageUrlHelper.appendBannerSizeUrl(banner.image, 475, 325, 800),
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
