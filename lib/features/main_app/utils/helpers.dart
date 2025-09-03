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
