import 'package:flutter/material.dart';

class NormalBannerWidget extends StatefulWidget {
  final List<NormalBanner>? brands;

  const NormalBannerWidget({super.key, this.brands});

  @override
  State<NormalBannerWidget> createState() => _NormalBannerWidgetState();
}

class _NormalBannerWidgetState extends State<NormalBannerWidget> {
  // Default fallback data
  final List<NormalBanner> defaultBrands = [
    NormalBanner(
      imageUrl:
          'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: "TIMELESS STYLES AT IRRESITIBLE PRICES",
      priceDrop: "PRICE DROP 20%",
      freeShipping: true,
    ),
    NormalBanner(
      imageUrl:
          'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      description: "TIMELESS STYLES AT IRRESITIBLE PRICES",
      priceDrop: "PRICE DROP 10%",
      freeShipping: false,
    ),
    NormalBanner(
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1728759436968-db4b52249ffa?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: "TIMELESS STYLES AT IRRESITIBLE PRICES",
      priceDrop: "",
      freeShipping: true,
    ),
    NormalBanner(
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1676225678979-80df276a983e?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: "TIMELESS STYLES AT IRRESITIBLE PRICES",
      priceDrop: "",
      freeShipping: false,
    ),
    NormalBanner(
      imageUrl:
          'https://images.unsplash.com/photo-1670014543406-a26719b352ca?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: "TIMELESS STYLES AT IRRESITIBLE PRICES",
      priceDrop: "PRICE DROP 10%",
      freeShipping: false,
    ),
    NormalBanner(
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: "TIMELESS STYLES AT IRRESITIBLE PRICES",
      priceDrop: "PRICE DROP 20%",
      freeShipping: true,
    ),
    NormalBanner(
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1675183689638-a68fe7048da9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: "TIMELESS STYLES AT IRRESITIBLE PRICES",
      priceDrop: "",
      freeShipping: false,
    ),
  ];

  Widget priceDropWidget(NormalBanner banner) {
    return banner.priceDrop != ""
        ? Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              banner.priceDrop,
              style: const TextStyle(color: Colors.white),
            ),
          )
        : const SizedBox();
  }

  Widget freeShippingWidget(NormalBanner banner) {
    return banner.freeShipping
        ? Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Row(
              children: [
                Icon(Icons.fire_truck, color: Colors.white),
                SizedBox(width: 2),
                Text("Free Shipping", style: TextStyle(color: Colors.white)),
              ],
            ),
          )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final banner = widget.brands ?? defaultBrands;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(banner.length, (index) {
        return SizedBox(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Normal banner $index was clicked')),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Image.network(
                        banner[index].imageUrl,
                        fit: BoxFit.cover,
                        width: MediaQuery.sizeOf(context).width,
                        height: 250,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          priceDropWidget(banner[index]),
                          freeShippingWidget(banner[index]),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  banner[index].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class NormalBanner {
  final String imageUrl;
  final String description;
  final String priceDrop;
  final bool freeShipping;

  NormalBanner({
    required this.imageUrl,
    required this.description,
    required this.priceDrop,
    required this.freeShipping,
  });
}
