import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';

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

showAlertDialog(BuildContext context,
    {String? image,
    required Widget title,
    Widget? content,
    List<Widget>? actions,
    VoidCallback? onCancel,
    VoidCallback? onOk,
    String? okText,
    String? cancelText,
    bool dismissible = true,
    EdgeInsets? titlePadding,
    Color? backgroundColor,
    Color? barrierColor}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: barrierColor,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: GoodaliColors.primaryBGColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        insetPadding: EdgeInsets.zero,
        title: title,
        content: content,
        actions: actions ??
            <Widget>[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            width: double.infinity,
                            backgroundColor: GoodaliColors.grayColor,
                            text: cancelText ?? "",
                            onPressed: () {
                              if (onCancel != null) {
                                onCancel();
                              }
                            },
                          ),
                        ),
                        HSpacer.sm(),
                        Expanded(
                          child: PrimaryButton(
                            width: double.infinity,
                            text: okText ?? "Ok",
                            onPressed: () {
                              if (onOk != null) {
                                onOk();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
      );
    },
  );
}
