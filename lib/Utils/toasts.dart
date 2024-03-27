import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class Toast {
  Toast._();

  static void success(
    BuildContext context, {
    String? description,
    String? title,
  }) {
    FToast fToast = FToast();
    fToast.removeCustomToast();
    fToast.init(context);
    return fToast.showToast(
      toastDuration: Duration(seconds: 3),
      gravity: ToastGravity.TOP,
      isDismissable: true,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: GoodaliColors.blackColor.withOpacity(0.05),
              offset: Offset(1, 0),
              blurRadius: 12,
              spreadRadius: 10,
            ),
          ],
          color: GoodaliColors.primaryBGColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/ic_success.png",
              width: 24,
              height: 24,
            ),
            HSpacer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "Амжилттай",
                    style: GoodaliTextStyles.titleText(context),
                  ),
                  VSpacer.sm(),
                  Text(
                    description ?? "",
                    style: GoodaliTextStyles.bodyText(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static void error(
    BuildContext context, {
    String? description,
    String? title,
  }) {
    FToast fToast = FToast();
    fToast.removeCustomToast();
    fToast.init(context);
    return fToast.showToast(
      toastDuration: Duration(seconds: 3),
      gravity: ToastGravity.TOP,
      isDismissable: true,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: GoodaliColors.blackColor.withOpacity(0.05),
              offset: Offset(1, 0),
              blurRadius: 12,
              spreadRadius: 10,
            ),
          ],
          color: GoodaliColors.primaryBGColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/ic_error.png",
              width: 24,
              height: 24,
            ),
            HSpacer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "Уучлаарай",
                    style: GoodaliTextStyles.titleText(context),
                  ),
                  Column(
                    children: [
                      VSpacer.sm(),
                      Text(
                        description ?? "Алдаа гарлаа.",
                        style: GoodaliTextStyles.bodyText(context),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
