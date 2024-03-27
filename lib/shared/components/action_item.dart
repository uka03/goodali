import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    super.key,
    required this.iconPath,
    required this.onPressed,
    this.isDot = false,
    this.count,
  });
  final String iconPath;
  final bool isDot;
  final int? count;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: GoodaliColors.inputColor,
                borderRadius: BorderRadius.circular(20)),
            child: Image.asset(
              iconPath,
              width: 24,
              color: GoodaliColors.grayColor,
            ),
          ),
          isDot
              ? Positioned(
                  right: 4,
                  top: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 141, 128),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      (count ?? 0).toString(),
                      style: GoodaliTextStyles.bodyText(
                        context,
                        textColor: GoodaliColors.whiteColor,
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
