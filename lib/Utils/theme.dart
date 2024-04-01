import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/utils/colors.dart';

ThemeData theme(BuildContext context) {
  return ThemeData(
    splashFactory: NoSplash.splashFactory,
    appBarTheme: appBarTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    dialogTheme: DialogTheme(
        elevation: 0, backgroundColor: GoodaliColors.primaryBGColor),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: GoodaliColors.inputColor),
    gapPadding: 10,
  );

  OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(width: 1, color: Colors.red),
    gapPadding: 0,
  );
  return InputDecorationTheme(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    filled: true,
    fillColor: GoodaliColors.inputColor,
    border: outlineInputBorder,
    errorBorder: errorOutlineInputBorder,
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xFFFFFFFF),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
