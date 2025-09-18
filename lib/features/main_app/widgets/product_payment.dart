import 'package:flutter/material.dart';

class ProductPaymentWidget extends StatefulWidget {
  final bool isAfterpayEnabled;
  final bool isLPayEnabled;
  final bool isKlarnaEnabled;
  final bool isGenoaPayEnabled;

  const ProductPaymentWidget({
    super.key,
    required this.isAfterpayEnabled,
    required this.isLPayEnabled,
    required this.isKlarnaEnabled,
    required this.isGenoaPayEnabled,
  });

  @override
  State<ProductPaymentWidget> createState() => _ProductPaymentWidgetState();
}

class _ProductPaymentWidgetState extends State<ProductPaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _createTitle(),
            _createDetails(),
            _createAvailablePayments(),
          ],
        ),
      ),
    );
  }

  Widget _createTitle() {
    return const Row(
      children: [
        Icon(Icons.payment),
        SizedBox(width: 5),
        Text(
          "Payment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _createDetails() {
    return const Padding(
      padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 10),
      child: Text(
        "We accept the following. Simply select your preferred payment method at checkout.",
      ),
    );
  }

  Widget _createAvailablePayments() {
    List<String> images = <String>[];

    images.add("assets/images/paypal_logo_bw.png");
    if (widget.isAfterpayEnabled) {
      images.add("assets/images/afterpay_logo_bw.png");
    }
    if (widget.isLPayEnabled) {
      images.add("assets/images/lpay_logo_bw.png");
    }
    if (widget.isKlarnaEnabled) {
      images.add("assets/images/klarna_logo_bw.png");
    }
    if (widget.isGenoaPayEnabled) {
      images.add("assets/images/genoa_logo_bw.png");
    }

    return SizedBox(
      width: double.infinity,
      child: GridView.builder(
        itemCount: images.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(images[index]);
        },
      ),
    );
  }
}
