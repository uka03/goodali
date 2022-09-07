import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';

class ImageView extends StatelessWidget {
  final String imgPath;
  final double? height;
  final double? width;
  final bool? isQpay;
  const ImageView(
      {Key? key, required this.imgPath, this.height, this.width, this.isQpay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("https://staging.goodali.mn" + imgPath);
    return Image.network(
      isQpay == true ? imgPath : "https://staging.goodali.mn" + imgPath,
      width: width,
      height: height,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: MyColors.primaryColor,
            strokeWidth: 2,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Text("Error"),
    );
  }
}
