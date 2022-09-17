import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';

import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class AlbumDetailItem extends StatefulWidget {
  final Products products;
  final List<Products> productsList;
  final String albumName;
  final bool isBought;
  final int index;
  final AudioPlayer audioPlayer;

  const AlbumDetailItem(
      {Key? key,
      required this.products,
      required this.albumName,
      required this.productsList,
      required this.isBought,
      this.index = 0,
      required this.audioPlayer})
      : super(key: key);

  @override
  State<AlbumDetailItem> createState() => _AlbumDetailItemState();
}

class _AlbumDetailItemState extends State<AlbumDetailItem> {
  bool isPlaying = false;
  bool isClicked = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  FileInfo? fileInfo;
  File? audioFile;
  String url = "";

  @override
  void initState() {
    widget.audioPlayer.positionStream.listen((event) {
      position = event;
    });
    widget.audioPlayer.durationStream.listen((event) {
      duration = event ?? Duration.zero;
    });

    widget.audioPlayer.playingStream.listen((event) {
      isPlaying = event;
    });
    String audioURL = Urls.networkPath + widget.products.audio!;
    String introURL = Urls.networkPath + widget.products.intro!;

    print(widget.products.isBought);
    url = widget.isBought == true
        ? audioURL
        : widget.products.isBought == true
            ? audioURL
            : introURL;

    print(url);

    getCachedFile(url);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // audioPlayer.dispose();
  }

  Future<void> setAudio(String url, FileInfo? fileInfo) async {
    try {
      if (fileInfo != null) {
        audioFile = fileInfo.file;
        duration =
            await widget.audioPlayer.setFilePath(audioFile!.path).then((value) {
                  return value;
                }) ??
                Duration.zero;
      } else {
        print(url);
        widget.audioPlayer.setUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }

  getCachedFile(String url) async {
    fileInfo = await checkCachefor(url);

    setAudio(url, fileInfo);
  }

  Future<FileInfo?> checkCachefor(String url) async {
    final FileInfo? value =
        await CustomCacheManager.instance.getFileFromCache(url);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return GestureDetector(
      onTap: () {
        widget.isBought || widget.products.isBought == true
            ? showAudioModal()
            : showIntroAudioModal();
        widget.audioPlayer.dispose();
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
                      widget.isBought
                          ? widget.products.lectureTitle ?? ""
                          : widget.products.title ?? "",
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
          Row(
            children: [
              CircleAvatar(
                backgroundColor: MyColors.input,
                child: IconButton(
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    setState(() {
                      isClicked = true;
                    });
                    if (isPlaying) {
                      await widget.audioPlayer.pause();
                    } else {
                      await widget.audioPlayer.play();
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 30,
                    color: MyColors.black,
                  ),
                ),
              ),
              if (isClicked)
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        activeColor: MyColors.primaryColor,
                        inactiveColor: MyColors.border1,
                        onChanged: (duration) async {
                          final position =
                              Duration(microseconds: (duration * 1000).toInt());
                          await widget.audioPlayer.seek(position);

                          await widget.audioPlayer.play();
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(width: 10),
              Text(formatTime(duration - position) + "мин",
                  style: const TextStyle(fontSize: 12, color: MyColors.black)),
              const Spacer(),
              widget.products.isBought == false
                  ? IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        widget.products.isBought == true ||
                                widget.isBought == true
                            ? downloadAudio()
                            : addToCard(cart);
                      },
                      icon: Icon(
                          widget.isBought
                              ? IconlyLight.arrow_down
                              : IconlyLight.buy,
                          color: fileInfo != null
                              ? MyColors.primaryColor
                              : MyColors.gray))
                  : Container(),
              IconButton(
                  splashRadius: 20,
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
            ],
          ),
          const SizedBox(height: 12)
        ],
      ),
    );
  }

  showIntroAudioModal() {
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
                return IntroAudio(
                    products: widget.products,
                    productsList: widget.productsList);
              },
            ));
  }

  addToCard(cart) {
    cart.addItemsIndex(widget.products.productId!);
    if (!cart.sameItemCheck) {
      cart.addProducts(widget.products);
      cart.addTotalPrice(widget.products.price?.toDouble() ?? 0.0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Сагсанд амжилттай нэмэгдлээ"),
        backgroundColor: MyColors.success,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Product is already added in cart"),
        backgroundColor: MyColors.error,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  downloadAudio() {}

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
                    albumName: widget.albumName,
                  ),
                );
              },
            ));
  }
}
