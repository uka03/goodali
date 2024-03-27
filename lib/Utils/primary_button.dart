import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnable = true,
    this.backgroundColor = GoodaliColors.primaryColor,
    this.width,
    this.height,
    this.icon,
    this.elevation,
    this.suffixIcon,
    this.textColor,
    this.borderRadius,
    this.textFontSize,
    this.letterSpacing,
    this.iconColor,
    this.suffixIconColor,
    this.textAlign,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isEnable;
  final Color backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? suffixIconColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextAlign? textAlign;
  final double? elevation, borderRadius, textFontSize, letterSpacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 37,
      width: width ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          if (isEnable) {
            onPressed();
          }
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(elevation ?? 0),
          backgroundColor: isEnable
              ? MaterialStateProperty.all<Color>(backgroundColor)
              : MaterialStateProperty.all<Color>(GoodaliColors.borderColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              side: BorderSide(
                  color:
                      isEnable ? backgroundColor : GoodaliColors.borderColor),
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
                textAlign: textAlign ?? TextAlign.center,
                style: GoodaliTextStyles.bodyText(
                  context,
                  fontSize: textFontSize ?? 12,
                  fontWeight: FontWeight.bold,
                  textColor: isEnable
                      ? textColor ?? GoodaliColors.whiteColor
                      : GoodaliColors.grayColor,
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
