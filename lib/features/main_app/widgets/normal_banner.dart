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
        banner.image ?? "",
        fit: BoxFit.cover,
        width: MediaQuery.sizeOf(context).width,
        height: 250,
      ),
    );
  }

  Widget normalBannerDescription(bannerModel.Banner banner) {
    return Column(
      children: [
        const SizedBox(height: 8),
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
