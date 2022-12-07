import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/download_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:provider/provider.dart';

typedef OnTap = Function(Products audioObject);

class Downloaded extends StatefulWidget {
  final OnTap onTap;
  const Downloaded({Key? key, required this.onTap}) : super(key: key);

  @override
  State<Downloaded> createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  List<Products> downloadedList = [];

  _onPlayButtonTapped(int index) async {
    currentlyPlaying.value = downloadedList[index];
    if (activeList.last.lectureTitle == downloadedList.last.lectureTitle &&
        activeList.last.id == downloadedList.last.id) {
      await audioHandler.skipToQueueItem(index);
      await audioHandler.seek(
        Duration(milliseconds: downloadedList[index].position!),
      );
      await audioHandler.play();
    } else {
      activeList = downloadedList;
      await initiliazePodcast();
      await audioHandler.skipToQueueItem(index);
      await audioHandler.seek(
        Duration(milliseconds: downloadedList[index].position!),
      );
      await audioHandler.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadController>(
      builder: (context, value, child) {
        List<Products> list = [];
        for (var element in value.episodeTasks) {
          list.add(element.products!);
        }
        downloadedList = removeDuplicates(list);

        if (list.isEmpty) {
          return Column(
            children: [
              const SizedBox(height: 80),
              SvgPicture.asset("assets/images/empty_bought.svg"),
              const SizedBox(height: 20),
              const Text(
                "Хоосон байна.",
                style: TextStyle(fontSize: 14, color: MyColors.gray),
              ),
            ],
          );
        } else {
          return ListView.builder(
              itemCount: downloadedList.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AlbumDetailItem(
                    index: index,
                    products: downloadedList[index],
                    albumName: downloadedList[index].albumTitle ?? "",
                    isBought: downloadedList[index].isBought ?? true,
                    onTap: () async {
                      _onPlayButtonTapped(index);
                    },
                    productsList: const [],
                  ),
                );
              });
        }
      },
    );
  }
}
