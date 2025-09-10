import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/models/main/banners_model.dart';

class ShippingAndDeliveryWidget extends StatefulWidget {
  final BannerModel? banner;

  const ShippingAndDeliveryWidget({super.key, this.banner});

  @override
  State<ShippingAndDeliveryWidget> createState() =>
      _ShippingAndDeliveryWidgetState();
}

class _ShippingAndDeliveryWidgetState extends State<ShippingAndDeliveryWidget> {
  TextEditingController? postcodeTextField;
  double price = 9.99;
  String appName = "Ozsale";

  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _createTitle(),
            _createSoldby(),
            _createShippingCalculator(),
            _createDispatch(),
          ],
        ),
      ),
    );
  }

  Widget _createTitle() {
    return const Row(
      children: [
        Icon(Icons.fire_truck),
        SizedBox(width: 5),
        Text(
          "Shipping",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _createSoldby() {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          const Text("Sold and delivered by "),
          GestureDetector(
            child: Text(
              App.name == '' ? appName : App.name,
              style: const TextStyle(
                color: Colors.lightBlue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.lightBlue,
              ),
            ),
            onTap: () {
              //on tap logic
            },
          ),
        ],
      ),
    );
  }

  Widget _createShippingCalculator() {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          Text("\$$price"),
          const SizedBox(width: 5),
          Container(
            width: MediaQuery.sizeOf(context).width / 1.8,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Container(
                      width: 80,
                      height: 57,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 56, 56, 56),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: const Color.fromARGB(255, 56, 56, 56),
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: TextField(
                    controller: postcodeTextField,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDispatch() {
    return Container(
      alignment: Alignment.centerLeft,
      child: const Text("Dispatched in 5-7 Business Days from Australia"),
    );
  }
}
