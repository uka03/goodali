import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';

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
    return ExtendedImage.network(
      isQpay == true
          ? imgPath
          : imgPath == ""
              ? ""
              : Urls.networkPath + imgPath,
      cacheHeight: (height?.toInt() ?? 100) * window.devicePixelRatio.ceil(),
      height: height,
      width: width,
      fit: BoxFit.cover,
      cache: true, // store in cache
      enableMemoryCache: false, // do not store in memory
      enableLoadState: false, // hide spinner
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(
              padding: const EdgeInsets.all(8),
              height: width,
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                    color: MyColors.primaryColor,
                    strokeWidth: 2,
                    value:
                        state.loadingProgress?.expectedTotalBytes?.toDouble()),
              ),
            );

          case LoadState.completed:
            return null;
          case LoadState.failed:
            return SizedBox(
                width: width,
                height: height,
                child: const Text(
                  "No Image",
                  style: TextStyle(fontSize: 12),
                ));
        }
      },
    );

    // CachedNetworkImage(
    //   imageUrl: isQpay == true
    //       ? imgPath
    //       : imgPath == ""
    //           ? ""
    //           : Urls.networkPath + imgPath,
    //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
    //     child: CircularProgressIndicator(
    //         color: MyColors.primaryColor,
    //         strokeWidth: 2,
    //         value: downloadProgress.progress),
    //   ),
    //   cacheManager: CustomCacheManager.instance,
    //   height: height,
    //   width: width,
    //   fit: BoxFit.cover,
    //   errorWidget: (context, url, error) {
    //     return SizedBox(
    //         width: width,
    //         height: height,
    //         child: const Text(
    //           "No Image",
    //           style: TextStyle(fontSize: 12),
    //         ));
    //   },
    // );
  }
}




// Image(
//       image: NetworkImage(
//         isQpay == true ? imgPath : image,
//       ),
//       width: width,
//       height: height,
//       loadingBuilder: (BuildContext context, Widget child,
//           ImageChunkEvent? loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Center(
//           child: CircularProgressIndicator(
//             color: MyColors.primaryColor,
//             strokeWidth: 2,
//             value: loadingProgress.expectedTotalBytes != null
//                 ? loadingProgress.cumulativeBytesLoaded /
//                     loadingProgress.expectedTotalBytes!
//                 : null,
//           ),
//         );
//       },
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stack) {
//           if (error is NetworkImageLoadException && error.statusCode == 404) {
//             return const Text("404");
//           }

//         return SizedBox(
//             width: width,
//             height: height,
//             child: const Text(
//               "No Image",
//               style: TextStyle(fontSize: 12),
//             ));
//       },
//     );