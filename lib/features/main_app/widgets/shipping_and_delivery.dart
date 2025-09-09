import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

class ShippingAndDeliveryWidget extends StatefulWidget {
  final BannerModel? banner;

  const ShippingAndDeliveryWidget({super.key, this.banner});

  @override
  State<ShippingAndDeliveryWidget> createState() =>
      _ShippingAndDeliveryWidgetState();
}

class _ShippingAndDeliveryWidgetState extends State<ShippingAndDeliveryWidget> {
  // Default fallback data

  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          _createTitle(),
          _createSoldby(),
          _createShippingCalculator(),
          _createDispatch(),
        ],
      ),
    );
  }

  Widget _createTitle() {
    return Row(children: [Icon(Icons.fire_truck), Text("Shipping")]);
  }

  Widget _createSoldby() {
    return Row(
      children: [
        Text("Sold and delivered by"),
        GestureDetector(
          child: Text("Sold and delivered by"),
          onTap: () {
            //on tap logic
          },
        ),
      ],
    );
  }

  Widget _createShippingCalculator() {
    return Row(
      children: [
        Text("9.99"),
        Stack(children: [
        
      ],
    ),
      ],
    );
  }

  Widget _createDispatch() {
    return Container(
      child: Text("Dispatched in 5-7 Business Days from Australia"),
    );
  }
}
