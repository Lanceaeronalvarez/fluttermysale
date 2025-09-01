import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_box.dart';
import 'package:another_xlider/models/tooltip/tooltip_position_offset.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

class PriceRangeSlider extends StatefulWidget {
  PriceRangeSlider({
    super.key,
    this.title,
    required this.minValue,
    required this.maxValue,
    required this.currentMinValue,
    required this.currentMaxValue,
    this.tooltipOffset,
    this.mergeGap,
    this.onDrag,
    this.onDragEnd,
  });

  final String? title;
  final double minValue;
  final double maxValue;
  final double currentMinValue;
  final double currentMaxValue;
  final double thumbSize = 32;
  final double? tooltipOffset;
  final double? mergeGap;
  final double minValueHideThreshold = 12;
  final double maxValueHideThreshold = 20;
  final void Function(double currentMin, double currentMax)? onDrag;
  final void Function(double currentMin, double currentMax)? onDragEnd;

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.title == null) ? SizedBox.shrink() : Text(widget.title ?? ""),
        const SizedBox(height: 20),
        _createSliderContainer(),
      ],
    );
  }

  Widget _createSliderContainer() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _createFlutterSlider(),
        Positioned.fill(
          top: widget.tooltipOffset,
          child: _createMinMaxContainer(),
        ),
      ],
    );
  }

  Widget _createMinMaxContainer() {
    final hideMin =
        (widget.currentMinValue - widget.minValue) <=
        widget.minValueHideThreshold;
    final hideMax =
        (widget.maxValue - widget.currentMaxValue) <=
        widget.maxValueHideThreshold;
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.thumbSize / 2),
        child: Stack(
          children: [
            if (!hideMin)
              _createMinMaxText(widget.minValue.toInt(), Alignment.topLeft),
            if (!hideMax)
              _createMinMaxText(widget.maxValue.toInt(), Alignment.topRight),
          ],
        ),
      ),
    );
  }

  Widget _createMinMaxText(int value, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Text(
        '$value',
        style: TextStyle(fontSize: 12, color: 'CCA68B'.toColor()),
      ),
    );
  }

  Widget _createFlutterSlider() {
    final thumbSize = widget.thumbSize;
    return FlutterSlider(
      values: [widget.currentMinValue, widget.currentMaxValue],
      rangeSlider: true,
      max: widget.maxValue,
      min: widget.minValue,
      minimumDistance: 1,
      handler: FlutterSliderHandler(child: _createPlainThumb()),
      handlerHeight: thumbSize,
      handlerWidth: thumbSize,
      rightHandler: FlutterSliderHandler(child: _createPlainThumb()),
      handlerAnimation: _createSliderAnimation(),
      trackBar: _createSliderTrackBar(),
      tooltip: _createSliderTooltip(),
      onDragging: (handlerIndex, currentMinValue, currentMaxValue) {
        widget.onDrag?.call(currentMinValue, currentMaxValue);
      },
      onDragCompleted: (handlerIndex, currentMinValue, currentMaxValue) {
        widget.onDragEnd?.call(currentMinValue, currentMaxValue);
      },
    );
  }

  Widget _createPlainThumb() {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.transparent),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, .5),
              color: Color(0x33000000),
            ),
          ],
        ),
      ),
    );
  }

  FlutterSliderHandlerAnimation _createSliderAnimation() {
    return const FlutterSliderHandlerAnimation(
      duration: Duration.zero,
      curve: Curves.linear,
      scale: 1.0,
    );
  }

  FlutterSliderTrackBar _createSliderTrackBar() {
    return FlutterSliderTrackBar(
      activeTrackBar: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(2),
      ),
      inactiveTrackBar: BoxDecoration(
        color: 'CCA68B'.toColor(),
        borderRadius: BorderRadius.circular(2),
      ),
      activeTrackBarHeight: 3,
      inactiveTrackBarHeight: 3,
    );
  }

  FlutterSliderTooltip _createSliderTooltip() {
    return FlutterSliderTooltip(
      alwaysShowTooltip: true,
      direction: FlutterSliderTooltipDirection.top,
      positionOffset: FlutterSliderTooltipPositionOffset(
        top: widget.tooltipOffset,
      ),
      boxStyle: const FlutterSliderTooltipBox(
        decoration: BoxDecoration(color: Colors.transparent),
      ),
      custom: (value) {
        return _createTooltipText(value);
      },
    );
  }

  //mergeGap
  //thumbheight

  Widget _createTooltipText(double value) {
    const TextStyle textStyle = TextStyle(fontSize: 12);

    final double currentMinValue = widget.currentMinValue;
    final double currentMaxValue = widget.currentMaxValue;
    final bool tooClose =
        (currentMaxValue - currentMinValue) <= (widget.mergeGap ?? 0);
    final bool isRightThumb = ((value - currentMaxValue).abs() < 1e-6);

    final leftText = currentMinValue.toInt().toString();
    final rightText =
        '${currentMaxValue.toInt()}${(currentMaxValue >= widget.maxValue) ? '+' : ''}';

    if (tooClose) {
      //hides right thumb if the two thumbs are close
      if (isRightThumb) {
        return const SizedBox.shrink();
      }

      return Text('$leftText–$rightText', style: textStyle);
    } else {
      final String v = (isRightThumb) ? rightText : leftText;
      return Text(v, style: textStyle);
    }
  }
}
