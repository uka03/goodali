import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album_detail.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album_detail_web.dart';

class AlbumItem extends StatelessWidget {
  final Products albumData;
  final bool isHomeScreen;

  const AlbumItem({Key? key, required this.albumData, this.isHomeScreen = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => kIsWeb
                  ? AlbumDetailWeb(
                      onTap: (audioObject) {
                        currentlyPlaying.value = audioObject;
                      },
                      albumProduct: albumData,
                      isHomeScreen: isHomeScreen,
                    )
                  : AlbumDetail(
                      onTap: (audioObject) {
                        currentlyPlaying.value = audioObject;
                      },
                      albumProduct: albumData,
                    ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageView(
                imgPath: albumData.banner ?? '',
                height: kIsWeb ? 210 : MediaQuery.of(context).size.width / 2 - 30,
                width: kIsWeb ? 210 : MediaQuery.of(context).size.width / 2 - 30,
              )),
          const SizedBox(height: 10),
          Text(
            albumData.title ?? "",
            style: const TextStyle(color: MyColors.black, fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 5),
          Text(
            albumData.audioCount!.toString() + " аудио",
            style: const TextStyle(fontSize: 12, color: MyColors.gray),
          ),
        ],
      ),
    );
  }
}
