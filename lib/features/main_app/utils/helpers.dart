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
    String separator = 'to',
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

extension StringValidator on String {
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(
      r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(this.trim());
  }
}

extension StringServerApostropheS on String {
  String fixServerApostropheS() {
    bool foundWhiteSpace = false;
    int whiteSpacePosition = -1;
    bool foundS = false;
    String output = this;
    final int len = output.length;
    for (int i = 0; i <= len; ++i) {
      if (foundS) {
        if (i >= len || output[i] == ' ') {
          if (whiteSpacePosition >= 1 && i - whiteSpacePosition == 2) {
            output.replaceRange(
              whiteSpacePosition,
              whiteSpacePosition + 1,
              '\'',
            );
          }
          foundS = false;
        }
      }
      if (i >= len) {
        break;
      }
      final String c = output[i];
      if (c == ' ') {
        foundWhiteSpace = true;
        whiteSpacePosition = i;
        foundS = false;
      } else {
        if (foundWhiteSpace) {
          if (c == 's' || c == 'S') {
            foundS = true;
          }
        }
        foundWhiteSpace = false;
      }
    }
    return output;
  }
}

extension MediaQuerySizeExt on MediaQueryData {
  bool get isTablet => size.shortestSide >= 600;
}
