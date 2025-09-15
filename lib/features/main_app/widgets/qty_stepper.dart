import 'package:flutter/material.dart';

class QtyStepper extends StatelessWidget {
  final int value;
  final int min;
  final int? max;
  final double height;
  final double width;
  final double borderRadius;
  final Color? borderColor;
  final void Function(int) onMinus;
  final void Function(int) onPlus;

  QtyStepper({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    this.min = 0,
    this.max = 5,
    this.borderRadius = 5,
    this.borderColor,
    this.height = 40,
    this.width = 120,
  });

  @override
  Widget build(BuildContext context) {
    return _createContainer();
  }

  Widget _createContainer() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor ?? Colors.black.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          _createButton('–', _canMinus(), onMinus),
          _createText('$value'),
          _createButton('+', _canPlus(), onPlus),
        ],
      ),
    );
  }

  bool _canMinus() {
    return value > min;
  }

  bool _canPlus() {
    return max == null || value < max!;
  }

  Widget _createButton(String title, bool enabled, Function(int) onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (enabled) onTap.call(value);
      },
      child: SizedBox(
        width: height,
        height: height,
        child: Center(
          child: Opacity(
            opacity: enabled ? 1 : 0.35,
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createText(String title) {
    return Expanded(
      child: Center(
        child: Text(
          "$value",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
