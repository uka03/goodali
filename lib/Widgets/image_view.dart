import 'package:cached_network_image/cached_network_image.dart';
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
    return CachedNetworkImage(
      imageUrl: isQpay == true
          ? imgPath
          : imgPath == ""
              ? ""
              : Urls.host + imgPath,
      // progressIndicatorBuilder: (context, url, downloadProgress) =>
      //     CircularProgressIndicator(value: downloadProgress.progress),
      placeholder: (context, url) =>
          Container(width: width, height: height, color: Colors.purple),
      errorWidget: (context, url, error) => SizedBox(
          width: width,
          height: height,
          child: const Text(
            "No Image",
            style: TextStyle(fontSize: 12),
          )),
    );
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