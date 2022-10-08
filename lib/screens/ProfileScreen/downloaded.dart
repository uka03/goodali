import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/ListItems/downloaded_lecture_item.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

typedef OnTap(Products audioObject, AudioPlayer audioPlayer);

class Downloaded extends StatefulWidget {
  final Function onTap;
  const Downloaded({Key? key, required this.onTap}) : super(key: key);

  @override
  State<Downloaded> createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Consumer<AudioDownloadProvider>(
        builder: (context, value, child) {
          if (value.items.isNotEmpty) {
            return ListView.builder(
                itemCount: value.items.length,
                itemBuilder: (context, index) {
                  return AlbumDetailItem(
                    products: value.downloadedItem[index],
                    audioPlayer: AudioPlayer(),
                    albumName: value.downloadedItem[index].albumTitle ?? "",
                    isBought: value.downloadedItem[index].isBought ?? true,
                    onTap: widget.onTap,
                    productsList: value.downloadedItem,
                  );
                });
          } else {
            return const Center(
              child: Text(
                "Хоосон",
                style: TextStyle(color: MyColors.gray),
              ),
            );
          }
        },
      ),
    );
  }
}
