import 'package:flutter/material.dart';

final ButtonStyle appElevatedButtonStyle =
    ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF54ECFF), // bright cyan
      foregroundColor: Colors.black, // text/icon color
      elevation: 2,
      shadowColor: Colors.black54,
      minimumSize: const Size.fromHeight(48), // full width, fixed height
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ).copyWith(
      // remove tap ripple/overlay
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    );

final BoxDecoration appPrimaryButtonBoxDecoration = const BoxDecoration(
  color: Color(0xFF54ECFF),
  boxShadow: [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
);

final BoxDecoration appSecondaryButtonBoxDecoration = const BoxDecoration(
  color: Colors.black,
  boxShadow: [BoxShadow(color: Color(0xFF54ECFF), offset: Offset(2, 2))],
);
