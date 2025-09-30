import 'package:flutter/material.dart';

final ButtonStyle appElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF54ECFF), // bright cyan
  foregroundColor: Colors.black, // text/icon color
  elevation: 2,
  shadowColor: Colors.black54,
  minimumSize: const Size.fromHeight(48), // full width, fixed height
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  overlayColor: Colors.transparent,
);