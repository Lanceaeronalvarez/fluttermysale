import 'package:flutter/material.dart';

class ProductDetailsPageReturnsWidget extends StatefulWidget {
  final void Function()? onTap;

  const ProductDetailsPageReturnsWidget({super.key, this.onTap});

  @override
  State<ProductDetailsPageReturnsWidget> createState() =>
      _ProductDetailsPageReturnsWidgetState();
}

class _ProductDetailsPageReturnsWidgetState
    extends State<ProductDetailsPageReturnsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [_createTitle(), _createDetails()]),
      ),
    );
  }

  Widget _createTitle() {
    return const Row(
      children: [
        Icon(Icons.replay_outlined),
        SizedBox(width: 5),
        Text(
          "Return Policy",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _createDetails() {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          const Text("Please refer to "),
          GestureDetector(
            child: Text(
              "Return Policy",
              style: const TextStyle(
                color: Colors.lightBlue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.lightBlue,
              ),
            ),
            onTap: () {
              widget.onTap?.call();
            },
          ),
        ],
      ),
    );
  }
}
