import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Utils/styles.dart';
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
                    index: index,
                    products: value.downloadedItem[index],
                    albumName: value.downloadedItem[index].albumTitle ?? "",
                    isBought: value.downloadedItem[index].isBought ?? true,
                    onTap: widget.onTap(value.downloadedItem[index]),
                    productsList: value.downloadedItem,
                  );
                });
          } else {
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
          }
        },
      ),
    );
  }
}
