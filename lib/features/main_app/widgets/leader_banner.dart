import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

class LeaderBannerWidget extends StatefulWidget {
  final BannerModel? banner;

  const LeaderBannerWidget({super.key, this.banner});

  @override
  State<LeaderBannerWidget> createState() => _LeaderBannerWidgetState();
}

class _LeaderBannerWidgetState extends State<LeaderBannerWidget> {
  // Default fallback data

  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SizedBox(
        child: GestureDetector(
          onTap: () {
            //TODO: on tap loginc
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
