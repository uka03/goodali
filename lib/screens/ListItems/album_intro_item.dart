import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

typedef SetIndex = void Function(int index);

class AlbumIntroItem extends StatefulWidget {
  final SetIndex setIndex;
  final Products products;
  final Products? albumProducts;
  final List<Products> productsList;
  final String albumName;

  final AudioPlayer audioPlayer;
  final List<AudioPlayer> audioPlayerList;

  const AlbumIntroItem(
      {Key? key,
      required this.products,
      required this.albumName,
      required this.productsList,
      required this.audioPlayer,
      required this.audioPlayerList,
      required this.setIndex,
      this.albumProducts})
      : super(key: key);
  @override
  State<AlbumIntroItem> createState() => _AlbumIntroItemState();
}

class _AlbumIntroItemState extends State<AlbumIntroItem> {
  FileInfo? fileInfo;
  File? audioFile;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;
  int saveddouble = 0;
  int currentIndex = 0;
  bool isClicked = false;
  bool isPlaying = false;
  String url = "";

  @override
  void initState() {
    widget.audioPlayer.setLoopMode(LoopMode.off);

    String introURL = Urls.networkPath + widget.products.intro!;
    url = introURL;
    getCachedFile(url);
    super.initState();
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }

  Future<void> setAudio(String url, FileInfo? fileInfo) async {
    try {
      widget.audioPlayer.positionStream.listen((event) {
        position = event;
      });
      widget.audioPlayer.durationStream.listen((event) {
        duration = event ?? Duration.zero;
      });
      widget.audioPlayer.playingStream.listen((event) {
        isPlaying = event;
      });

      widget.audioPlayer.setUrl(url).then((value) {
        duration = value ?? Duration.zero;
        getSavedPosition(widget.products.productId!).then((value) async {
          if (value != Duration.zero) {
            savedPosition = value;
            position = savedPosition;

            await widget.audioPlayer.setUrl(url, initialPosition: position);
            log(position.toString(), name: "intro");
            log(duration.toString(), name: "Introduration");
          } else {}
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future getSavedPosition(int moodItemID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();
    for (var item in decodedProduct) {
      if (moodItemID == item.productID) {
        saveddouble = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }
    savedPosition = Duration(milliseconds: saveddouble);
    return savedPosition;
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
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return GestureDetector(
      onTap: () {
        showIntroAudioModal();
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
                      currentIndex =
                          widget.audioPlayerList.indexOf(widget.audioPlayer);
                    });
                    widget.setIndex(currentIndex);
                    AudioPlayerModel _audio = AudioPlayerModel(
                        productID: widget.products.productId,
                        audioPosition: position.inMilliseconds);
                    _audioPlayerProvider.addAudioPosition(_audio);
                    if (isPlaying) {
                      widget.audioPlayer.pause();
                    } else {
                      widget.audioPlayer.play();
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 30,
                    color: MyColors.black,
                  ),
                ),
              ),
              // if (isClicked || savedPosition != Duration.zero)
              //   Row(
              //     children: [
              //       const SizedBox(width: 14),
              //       SizedBox(
              //         width: 90,
              //         child: SfLinearGauge(
              //           minimum: 0,
              //           maximum: duration.inSeconds.toDouble() / 10,
              //           showLabels: false,
              //           showAxisTrack: false,
              //           showTicks: false,
              //           ranges: [
              //             LinearGaugeRange(
              //               position: LinearElementPosition.inside,
              //               edgeStyle: LinearEdgeStyle.bothCurve,
              //               startValue: 0,
              //               color: MyColors.border1,
              //               endValue: duration.inSeconds.toDouble() / 10,
              //             ),
              //           ],
              //           barPointers: [
              //             LinearBarPointer(
              //                 position: LinearElementPosition.inside,
              //                 edgeStyle: LinearEdgeStyle.bothCurve,
              //                 color: MyColors.primaryColor,
              //                 // color: MyColors.border1,
              //                 value: position.inSeconds.toDouble() / 10)
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              const SizedBox(width: 10),
              Text(formatTime(duration - position) + "мин",
                  style: const TextStyle(fontSize: 12, color: MyColors.black)),
              const Spacer(),
              widget.products.isBought == false
                  ? IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        addToCard(cart);
                      },
                      icon: const Icon(IconlyLight.buy, color: MyColors.gray))
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
    widget.audioPlayer.pause();
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
              builder:
                  (BuildContext _, void Function(void Function()) setState) {
                // setState(() {});
                return IntroAudio(
                    products: widget.products,
                    productsList: widget.productsList,
                    audioPlayer: widget.audioPlayer);
              },
            ));
  }

  addToCard(cart) {
    cart.addItemsIndex(widget.products.productId!,
        albumID: widget.albumProducts?.productId!);
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
        content: Text("Сагсанд байна"),
        backgroundColor: MyColors.error,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}
