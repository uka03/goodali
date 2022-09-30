import 'dart:convert';

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
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import 'package:syncfusion_flutter_gauges/gauges.dart';

typedef SetIndex = void Function(int index);

class AlbumDetailItem extends StatefulWidget {
  final SetIndex setIndex;
  final Products products;
  final Products? albumProducts;
  final List<Products> productsList;
  final String albumName;
  final bool isBought;
  final AudioPlayer audioPlayer;
  final List<AudioPlayer> audioPlayerList;
  // final Duration duration;
  // final Dura

  const AlbumDetailItem(
      {Key? key,
      required this.products,
      required this.albumName,
      required this.productsList,
      required this.isBought,
      required this.audioPlayer,
      required this.audioPlayerList,
      required this.setIndex,
      this.albumProducts})
      : super(key: key);

  @override
  State<AlbumDetailItem> createState() => _AlbumDetailItemState();
}

class _AlbumDetailItemState extends State<AlbumDetailItem> {
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

    String audioURL = Urls.networkPath + widget.products.audio!;
    String introURL = Urls.networkPath + widget.products.intro!;

    url = widget.isBought == true
        ? audioURL
        : widget.products.isBought == true
            ? audioURL
            : introURL;

    getCachedFile(url);

    super.initState();
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    developer.log(state.toString());
    if (state == AppLifecycleState.paused) {
      widget.audioPlayer.stop();
    }
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
      if (fileInfo != null) {
        audioFile = fileInfo.file;
        duration =
            await widget.audioPlayer.setFilePath(audioFile!.path).then((value) {
                  return value;
                }) ??
                Duration.zero;
      } else {
        print(url);
        widget.audioPlayer.setUrl(url).then((value) {
          duration = value ?? Duration.zero;
          getSavedPosition(widget.products.productId!).then((value) {
            developer.log(value.toString());
            if (value != Duration.zero) {
              savedPosition = value;
              position = savedPosition;
              // if (position != Duration.zero) {
              //   widget.audioPlayer.seek(position);
              // }
              widget.audioPlayer.setUrl(url, initialPosition: position);
            } else {}
          });
        });

        await widget.audioPlayer
            .setAudioSource(AudioSource.uri(Uri.parse(url)));
      }
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
    print("position $savedPosition");
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
              if (isClicked || savedPosition != Duration.zero)
                Row(
                  children: [
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 90,
                      child: SfLinearGauge(
                        minimum: 0,
                        maximum: duration.inSeconds.toDouble() / 10,
                        showLabels: false,
                        showAxisTrack: false,
                        showTicks: false,
                        ranges: [
                          LinearGaugeRange(
                            position: LinearElementPosition.inside,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            startValue: 0,
                            color: MyColors.border1,
                            endValue: duration.inSeconds.toDouble() / 10,
                          ),
                        ],
                        barPointers: [
                          LinearBarPointer(
                              position: LinearElementPosition.inside,
                              edgeStyle: LinearEdgeStyle.bothCurve,
                              color: MyColors.primaryColor,
                              // color: MyColors.border1,
                              value: position.inSeconds.toDouble() / 10)
                        ],
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
