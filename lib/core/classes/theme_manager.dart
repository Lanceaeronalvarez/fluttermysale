import '../../architect.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';

class AppTheme {
  ThemeData? light;
  ThemeData? dark;

  AppTheme([
    this.light,
    this.dark,
  ]) {
    light = light ??
        ThemeData(
          brightness: Brightness.light,
          primarySwatch: AppColors.white,
          scaffoldBackgroundColor: const Color.fromARGB(255, 222, 255, 252),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: AppColors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: AppColors.white,
          ),
          popupMenuTheme: const PopupMenuThemeData(
            color: Color.fromARGB(255, 11, 238, 250),
            elevation: 15,
            enableFeedback: true,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color.fromARGB(255, 213, 247, 249),
            elevation: 10,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.white,
            selectedItemColor: Colors.black,
            elevation: 10,
            showSelectedLabels: true,
          ),
          useMaterial3: true, bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white).data,
        );

    dark = dark ??
        ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.yellow,
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            buttonColor: Colors.white,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.space,
            selectedItemColor: AppColors.white,
            elevation: 10,
            showSelectedLabels: true,
          ),
          useMaterial3: true,
        );
  }

  ThemeData get lightTheme => light!;
  ThemeData get darkTheme => dark!;

  AppTheme copyWith({
    ThemeData? light,
    ThemeData? dark,
  }) {
    return AppTheme(
      light ?? this.light,
      dark ?? this.dark,
    );
  }
}
