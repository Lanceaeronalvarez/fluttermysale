import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

typedef LeaderboardBannerTappedCallback = void Function(BannerModel? banner);

class LeaderboardBannerWidget extends StatefulWidget {
  final BannerModel? banner;
  final LeaderboardBannerTappedCallback? onTap;

  const LeaderboardBannerWidget({super.key, this.banner, this.onTap});

  @override
  State<LeaderboardBannerWidget> createState() => _LeaderboardBannerWidgetState();
}

class _LeaderboardBannerWidgetState extends State<LeaderboardBannerWidget> {
  // Default fallback data

  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SizedBox(
        child: GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!(widget.banner);
            }
          },
          child: SizedBox(
            child: banner?.image != null
                ? Image.network(
                    banner!.image!,
                    fit: BoxFit.cover,
                    width: MediaQuery.sizeOf(context).width,
                  )
                : SizedBox(),
          ),
        ),
      ),
    );
  }
}
