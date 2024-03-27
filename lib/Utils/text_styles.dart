import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';

extension GoodaliTextStyles on TextTheme {
  static TextStyle bodyText(BuildContext context,
      {Color? textColor = GoodaliColors.blackColor,
      double fontSize = 12,
      double? height,
      FontWeight fontWeight = FontWeight.w400,
      TextDecoration? decoration}) {
    return TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
        height: height);
  }

  static TextStyle titleText(
    BuildContext context, {
    Color? textColor,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    TextDecoration? decoration,
  }) {
    return TextStyle(
        color: textColor ?? GoodaliColors.blackColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration);
  }
}
