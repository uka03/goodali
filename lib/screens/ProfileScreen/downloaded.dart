import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:hive_flutter/adapters.dart';

typedef OnTap = Function(Products audioObject);

class Downloaded extends StatefulWidget {
  final OnTap onTap;
  const Downloaded({Key? key, required this.onTap}) : super(key: key);

  @override
  State<Downloaded> createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  List<Products> downloadedList = [];

  @override
  void initState() {
    getDownloadedData();
    super.initState();
  }

  Future<void> getDownloadedData() async {
    List<Products> downloaded = [];
    Box<Products> box = Hive.box<Products>("bought_podcasts");
    if (box.values.isNotEmpty) {
      for (var i = 0; i < box.values.length; i++) {
        Products? products = box.getAt(i);
        if (products?.isDownloaded == true) {
          downloaded.add(products!);
        }
      }
    }
    setState(() {
      downloadedList = downloaded;
    });
  }

  _onPlayButtonTapped(int index) async {
    if (activeList.first.title == downloadedList.first.title &&
        activeList.first.id == downloadedList.first.id) {
      await audioHandler.skipToQueueItem(index);
      await audioHandler.seek(
        Duration(milliseconds: downloadedList[index].position!),
      );
      await audioHandler.play();
    } else if (activeList.first.title != downloadedList.first.title ||
        activeList.first.id != downloadedList.first.id) {
      activeList = downloadedList;
      await initiliazePodcast();
      await audioHandler.skipToQueueItem(index);
      await audioHandler.seek(
        Duration(milliseconds: downloadedList[index].position!),
      );
      await audioHandler.play();
    }
    currentlyPlaying.value = downloadedList[index];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: downloadedList.isNotEmpty
            ? ListView.builder(
                itemCount: downloadedList.length,
                itemBuilder: (context, index) {
                  return AlbumDetailItem(
                    index: index,
                    products: downloadedList[index],
                    albumName: downloadedList[index].albumTitle ?? "",
                    isBought: downloadedList[index].isBought ?? true,
                    onTap: () {
                      _onPlayButtonTapped(index);
                    },
                    productsList: downloadedList,
                  );
                })
            : Column(
                children: [
                  const SizedBox(height: 80),
                  SvgPicture.asset("assets/images/empty_bought.svg"),
                  const SizedBox(height: 20),
                  const Text(
                    "Хоосон байна.",
                    style: TextStyle(fontSize: 14, color: MyColors.gray),
                  ),
                ],
              ));
  }
}
