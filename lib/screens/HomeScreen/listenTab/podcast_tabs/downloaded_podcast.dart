import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/controller/download_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef OnTap = Function(Products audioObject);

class DownloadedPodcast extends StatefulWidget {
  const DownloadedPodcast({Key? key}) : super(key: key);

  @override
  State<DownloadedPodcast> createState() => _DownloadedPodcastState();
}

class _DownloadedPodcastState extends State<DownloadedPodcast> {
  HiveDataStore downloadedPodcast = HiveDataStore();
  DownloadController downloadController = DownloadController();
  List<Products> downloadedList = [];
  String audioPath = "";
  int currentIndex = 0;

  @override
  void initState() {
    getPathOfDownloadedAudio();
    super.initState();
  }

  getPathOfDownloadedAudio() async {
    audioPath = await downloadController.findLocalPath() ?? "";
    log(audioPath, name: "audioPath");
  }

  // _files() async {

  //   var files = await FileManager(root: audioPath).walk().toList();

  //   for (var i = 0; i < files.length; i++) {
  //     print("${files[i].path} ");
  //   }
  //   return files;
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveDataStore.box.listenable(),
      builder: ((context, Box box, child) {
        List<Products> downloadedPodcast = [];

        if (box.length > 0) {
          for (int a = 0; a < box.length; a++) {
            Products products = box.getAt(a);
            if (products.isDownloaded == true) {
              downloadedPodcast.add(products);
            }
          }
          downloadedList = downloadedPodcast;
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: downloadedList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: PodcastItem(
                      index: index,
                      podcastList: downloadedList,
                      podcastItem: downloadedList[index],
                    ));
              });
        } else {
          return Container();
        }
      }),
    );
  }
}
