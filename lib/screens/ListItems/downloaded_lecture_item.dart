import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class DownloadedLectureItem extends StatefulWidget {
  final Products products;
  final String audioURL;
  const DownloadedLectureItem(
      {Key? key, required this.products, required this.audioURL})
      : super(key: key);

  @override
  State<DownloadedLectureItem> createState() => _DownloadedLectureItemState();
}

class _DownloadedLectureItemState extends State<DownloadedLectureItem> {
  @override
  void initState() {
    super.initState();
    initiliazeAudio();
  }

  initiliazeAudio() {}

  @override
  Widget build(BuildContext context) {
    final downloadAudio = Provider.of<AudioDownloadProvider>(context);
    return GestureDetector(
      onTap: () {
        showAudioModal();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ImageView(
                      imgPath: widget.products.banner ?? "",
                      width: 40,
                      height: 40)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.products.title ?? "",
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: MyColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    CustomReadMoreText(text: widget.products.body ?? "")
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    splashRadius: 20,
                    onPressed: () {},
                    icon: const Icon(IconlyLight.arrow_down,
                        size: 20, color: MyColors.primaryColor)),
                IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      // _removeFile();
                      // downloadAudio.removeAudio(widget.products, widget.audioURL);
                    },
                    icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
              ],
            ),
          ),
          const SizedBox(height: 12)
        ],
      ),
    );
  }

  showAudioModal() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 80,
                  child: PlayAudio(
                    products: widget.products,
                    albumName: widget.products.albumTitle ?? "",
                    isDownloaded: true,
                  ),
                );
              },
            ));
  }

  void _removeFile() {
    DefaultCacheManager().removeFile(widget.audioURL).then((value) {
      //ignore: avoid_print
      print('File removed');
    }).onError((error, stackTrace) {
      //ignore: avoid_print
      print(error);
    });
  }
}
