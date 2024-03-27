import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.backgroundColor,
    this.width,
    this.height,
    this.icon,
    this.elevation,
    this.suffixIcon,
    this.textColor,
    this.borderRadius,
    this.textFontSize,
    this.iconColor,
    this.suffixIconColor,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? suffixIconColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconData? suffixIcon;
  final double? elevation, borderRadius, textFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 37,
      width: width ?? MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: () {
          if (isDisabled) {
            return;
          }
          onPressed();
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(elevation ?? 0),
          backgroundColor: isDisabled
              ? MaterialStateProperty.all<Color>(GoodaliColors.grayColor)
              : MaterialStateProperty.all<Color>(GoodaliColors.primaryBGColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5),
              side: BorderSide(
                  color: isDisabled
                      ? GoodaliColors.grayColor
                      : GoodaliColors.primaryBGColor),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: iconColor,
                  )
                : SizedBox(),
            // icon != null ? HSpacer(size: 14) : SizedBox(),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoodaliTextStyles.bodyText(
                  context,
                  fontSize: textFontSize ?? 12,
                  fontWeight: FontWeight.w700,
                  textColor: isDisabled
                      ? GoodaliColors.grayColor
                      : textColor ?? GoodaliColors.blackColor,
                ),
              ),
            ),
            suffixIcon != null ? HSpacer() : SizedBox(),
            suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: suffixIconColor,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
