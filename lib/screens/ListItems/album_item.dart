import 'package:flutter/material.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album_detail.dart';

class AlbumItem extends StatelessWidget {
  final Products albumData;
  final int audioLength;
  const AlbumItem(
      {Key? key, required this.albumData, required this.audioLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AlbumDetail(products: albumData))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.pink,
                )
                // ImageView(
                //   imgPath: albumData.banner ?? '',
                // )
                ),
          ),
          const SizedBox(height: 10),
          Text(
            albumData.title?.capitalize() ?? "",
            style: const TextStyle(fontWeight: FontWeight.w200),
          ),
          const SizedBox(height: 5),
          Text(
            audioLength.toString() + " audio",
            style: const TextStyle(fontSize: 12, color: MyColors.border2),
          ),
        ],
      ),
    );
  }
}
