import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:goodali/utils/colors.dart';
import 'package:lottie/lottie.dart';

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return BackdropFilter(
      key: Key("loader"),
      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: customLoader(),
    );
  }
}

Widget customLoader() {
  return Lottie.asset(
    "assets/animations/loader.json",
    width: 100,
    height: 100,
    delegates: LottieDelegates(
      values: [
        ValueDelegate.color(
          const ['**', 'Ellipse 2', '**'],
          value: GoodaliColors.primaryColor,
        ),
      ],
    ),
  );
}
