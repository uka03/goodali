import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';

showModalSheet(
  BuildContext context, {
  required Widget child,
  VoidCallback? onPressed,
  String? buttonText,
  bool withExpanded = true,
  bool dismissable = true,
  bool isScrollControlled = false,
  double? height,
}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: dismissable,
    elevation: 0,
    backgroundColor: GoodaliColors.primaryBGColor,
    isScrollControlled: isScrollControlled,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              // bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
          child: Container(
            height: height,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 24, left: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 6,
                      decoration: BoxDecoration(
                          color: GoodaliColors.blackColor,
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
                withExpanded
                    ? Expanded(
                        child: child,
                      )
                    : child,
              ],
            ),
          ),
        ),
      );
    },
  );
}
