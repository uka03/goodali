import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/products_model.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class DownloadedLectureItem extends StatefulWidget {
  final Products products;
  const DownloadedLectureItem({Key? key, required this.products})
      : super(key: key);

  @override
  State<DownloadedLectureItem> createState() => _DownloadedLectureItemState();
}

class _DownloadedLectureItemState extends State<DownloadedLectureItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child:
                      // Container(
                      //   width: 40,
                      //   height: 40,
                      //   color: Colors.pink,
                      // )
                      ImageView(
                          imgPath: widget.products.banner ?? "",
                          width: 40,
                          height: 40)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.products.lectureTitle ?? "",
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
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
          const SizedBox(height: 12)
        ],
      ),
    );
  }
}

void showAudioModal() {}
