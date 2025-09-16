import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';

class ShippingAndDeliveryWidget extends StatefulWidget {
  final String appName;
  final bool isFreeDelivery;
  final double? price;
  final void Function()? onTap;

  const ShippingAndDeliveryWidget({
    super.key,
    required this.appName,
    required this.isFreeDelivery,
    this.price,
    this.onTap,
  });

  @override
  State<ShippingAndDeliveryWidget> createState() =>
      _ShippingAndDeliveryWidgetState();
}

class _ShippingAndDeliveryWidgetState extends State<ShippingAndDeliveryWidget> {
  TextEditingController? postcodeTextField;
  double price = 9.99; // temp data
  final String _imagePath = "assets/images/free_shipping.png";
  final String _icShippingImagePath = "assets/images/ic_product_shipping.png";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _createTitle(),
            _createSoldby(),
            widget.isFreeDelivery
                ? _createFreeDelivery()
                : _createShippingCalculator(),
            _createDispatch(),
          ],
        ),
      ),
    );
  }

  Widget _createTitle() {
    return Row(
      children: [
        Image.asset(_icShippingImagePath, width: 25, height: 25),
        const SizedBox(width: 5),
        const Text(
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
              App.name == '' ? widget.appName : App.name,
              style: const TextStyle(
                color: Colors.lightBlue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.lightBlue,
              ),
            ),
            onTap: () {
              Nav.to(
                context,
                App.productList,
                arguments: (
                  categoryKeys: <String>[],
                  facetFilters: FacetFilterModel(),
                  sort: "",
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _createFreeDelivery() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Image.asset(_imagePath),
    );
  }

  Widget _createShippingCalculatorButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          widget.onTap?.call();
        },
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
          child: const Text("OK", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _createShippingCalculatorTextField() {
    return TextField(
      controller: postcodeTextField,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _createShippingCalculator() {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          Text("\$${widget.price ?? price}"),
          const SizedBox(width: 5),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 3,
            child: _createShippingCalculatorTextField(),
          ),
          _createShippingCalculatorButton(),
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
