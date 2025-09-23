import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

/**
 * Here We will be writing here All features related Helper Functions
 */

enum AppPlatform {
  ios,
  android;

  static AppPlatform? getCurrentPlatform() {
    if (Platform.isIOS) return AppPlatform.ios;
    if (Platform.isAndroid) return AppPlatform.android;
    return null;
  }
}

extension HexColorParsing on String {
  Color? toColor() {
    if (isEmpty) return null;
    try {
      return HexColor(this);
    } catch (_) {
      return null;
    }
  }
}

extension StringCasing on String {
  String toTitleCase() {
    if (trim().isEmpty) return this;
    return toLowerCase()
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

extension RangeParsing on String {
  ({double min, double max})? parseRange({
    String currency = '\$',
    String separator = '>>>',
  }) {
    final parts = replaceAll(currency, '').split(separator);
    if (parts.length != 2) return null;

    final cleanedMin = parts[0].trim();
    final cleanedMax = parts[1].trim();

    final min = double.tryParse(cleanedMin);
    final max = double.tryParse(cleanedMax);
    if (min == null || max == null) return null;

    return (min: min, max: max);
  }
}
