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

final BoxDecoration appPrimaryButtonBoxDecoration = const BoxDecoration(
  color: Color(0xFF54ECFF),
  boxShadow: [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
);

final BoxDecoration appSecondaryButtonBoxDecoration = const BoxDecoration(
  color: Colors.black,
  boxShadow: [BoxShadow(color: Color(0xFF54ECFF), offset: Offset(2, 2))],
);

final Color checkoutGrey = Color(0xFFEFEFEF);
final Color checkoutDarkGrey = Color(0xFFD7D7D7);
final Color beigeColor = Color(0xFFc9a184);
final Color lightBeigeColor = Color(0xFFfaf2f3);

final TextStyle textfieldStyle = TextStyle(fontSize: 16);
final InputDecoration textfieldInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: beigeColor)),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: beigeColor)),
  fillColor: lightBeigeColor,
  filled: true,
  hintStyle: TextStyle(color: beigeColor),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
);
