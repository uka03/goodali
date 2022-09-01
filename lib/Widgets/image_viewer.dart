import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';

class ImageViewer extends StatefulWidget {
  final String imgPath;
  final double? height;
  final double? width;
  final bool? isQpay;
  const ImageViewer(
      {Key? key,
      required this.imgPath,
      this.height,
      this.width,
      this.isQpay = false})
      : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.isQpay == true
          ? widget.imgPath
          : "https://staging.goodali.mn" + widget.imgPath,
      key: ValueKey("https://staging.goodali.mn" + widget.imgPath),
      width: widget.width,
      height: widget.height,
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
      errorBuilder: (context, error, stackTrace) => Container(
          width: widget.width,
          height: widget.height,
          color: Colors.deepPurple[200],
          child: const Center(child: Text("Error fetch image"))),
    );
  }
}
