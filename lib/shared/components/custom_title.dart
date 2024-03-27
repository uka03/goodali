import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/text_styles.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key, required this.title, this.onArrowPressed});
  final String title;
  final Function()? onArrowPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoodaliTextStyles.titleText(
              context,
              fontSize: 24,
            ),
          ),
          onArrowPressed != null
              ? CustomButton(
                  onPressed: onArrowPressed,
                  child: Image.asset(
                    "assets/icons/ic_arrow_right.png",
                    width: 24,
                    height: 24,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
