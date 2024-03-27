import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    super.key,
    required this.onPressed,
    required this.logoPath,
    required this.text,
    this.logoOnline = false,
  });

  final Function() onPressed;
  final String logoPath;
  final String text;
  final bool logoOnline;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: GoodaliColors.inputColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            logoOnline
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: logoPath,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    logoPath,
                    width: 30,
                    height: 30,
                  ),
            HSpacer(),
            Expanded(
              child: Text(
                text,
                style: GoodaliTextStyles.bodyText(
                  context,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: GoodaliColors.grayColor,
              size: 26,
            )
          ],
        ),
      ),
    );
  }
}
