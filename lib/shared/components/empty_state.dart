import 'package:flutter/material.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.title, this.imagePath});
  final String? title;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath ?? "assets/images/empty_state.png",
            height: 190,
          ),
          VSpacer(),
          Text(
            title ?? "Хоосон байна",
            style: GoodaliTextStyles.bodyText(context, fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
