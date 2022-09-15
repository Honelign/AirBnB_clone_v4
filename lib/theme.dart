import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    inputDecorationTheme: inputDecorationTheme(),
    accentColor: kPrimaryColor.withOpacity(0.25),
    visualDensity: VisualDensity.adaptivePlatformDensity,
      canvasColor:kPrimaryColor,
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black.withOpacity(0)),
      appBarTheme: const AppBarTheme(
        // 1
        systemOverlayStyle: SystemUiOverlayStyle.light, // 2
      ),

    hintColor: Colors.white

  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}



