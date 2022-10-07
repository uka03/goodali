import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/audio_progressbar.dart';
import 'package:goodali/Widgets/audioplayer_button.dart';
import 'package:goodali/Widgets/audioplayer_timer.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';

import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

typedef SetIndex = void Function(int index);
typedef OnTap(Products audioObject, AudioPlayer audioPlayer);

class AlbumDetailItem extends StatefulWidget {
  final SetIndex setIndex;
  final Products products;
  final Products? albumProducts;
  final List<Products> productsList;
  final String albumName;
  final bool isBought;
  final AudioPlayer audioPlayer;
  final List<AudioPlayer> audioPlayerList;
  final Function onTap;

  const AlbumDetailItem(
      {Key? key,
      required this.products,
      required this.albumName,
      required this.productsList,
      required this.isBought,
      required this.audioPlayer,
      required this.audioPlayerList,
      required this.setIndex,
      this.albumProducts,
      required this.onTap})
      : super(key: key);

  @override
  State<AlbumDetailItem> createState() => _AlbumDetailItemState();
}

class _AlbumDetailItemState extends State<AlbumDetailItem> {
  AudioPlayerController audioPlayerController = AudioPlayerController();
  List<MediaItem> mediaItems = [];
  MediaItem mediaItem = const MediaItem(id: "", title: "");
  FileInfo? fileInfo;
  File? audioFile;
  Stream<FileResponse>? fileStream;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;
  Duration leftDuration = Duration.zero;

  int saveddouble = 0;
  int currentIndex = 0;
  bool isClicked = false;
  bool isPlaying = false;
  String url = "";
  String audioURL = "";
  String introURL = "";
  String banner = "";
  bool isbgPlaying = false;

  @override
  void initState() {
    if (widget.products.audio != "Audio failed to upload") {
      audioURL = Urls.networkPath + widget.products.audio!;
    }
    if (widget.products.intro != "Audio failed to upload") {
      introURL = Urls.networkPath + widget.products.intro!;
    }
    banner = Urls.networkPath + (widget.products.banner ?? "");

    if (widget.isBought == true || widget.products.isBought == true) {
      url = audioURL;
    } else {
      url = introURL;
    }
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
      isbgPlaying = buttonNotifier.value == ButtonState.playing ? true : false;

      if (audioURL != "" || introURL != "") {
        if (fileInfo != null) {
          audioFile = fileInfo.file;
          url = audioFile!.path;
          duration = await widget.audioPlayer.setFilePath(audioFile!.path) ??
              Duration.zero;
        } else {
          duration = await widget.audioPlayer.setUrl(url) ?? Duration.zero;
        }

        audioPlayerController
            .getSavedPosition(widget.products.productId!)
            .then((value) async {
          developer.log(value.toString());
          savedPosition = value;
          leftDuration = duration - savedPosition;
          position = savedPosition;

          for (var item in widget.productsList) {
            mediaItem = MediaItem(
                id: url,
                title: item.title ?? "",
                duration: duration,
                artUri: Uri.parse(banner),
                extras: {
                  "position": position.inMilliseconds,
                  "isDownloaded": fileInfo != null ? true : false
                });

            mediaItems.add(mediaItem);
          }

          if (!isbgPlaying) {
            developer.log(isbgPlaying.toString());
            await audioHandler.addQueueItems(mediaItems);
          }
          audioPlayerController;
        });
      }
    } on PlayerInterruptedException catch (e) {
      developer.log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Алдаа гарлаа"),
        backgroundColor: MyColors.error,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  getCachedFile(String url) async {
    fileInfo = await audioPlayerController.checkCachefor(url);
    setAudio(url, fileInfo);
  }

  void _downloadFile() {
    setState(() {
      fileStream =
          CustomCacheManager.instance.getFileStream(url, withProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return GestureDetector(
      onTap: () {
        if (widget.isBought || widget.products.isBought == true) {
          showIntroAudioModal();
          widget.audioPlayer.dispose();
        }
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
              AudioPlayerButton(
                onPlay: () {
                  setState(() {
                    isPlaying = true;
                    currentIndex =
                        widget.audioPlayerList.indexOf(widget.audioPlayer);
                  });
                  currentlyPlaying.value = widget.products;
                  buttonNotifier.value = ButtonState.playing;
                  widget.setIndex(currentIndex);
                  developer.log("play");
                  widget.onTap();
                  audioHandler.playMediaItem(mediaItems[currentIndex]);
                  audioHandler.play();
                },
                onPause: () {
                  widget.onTap();
                  developer.log("paused");
                  buttonNotifier.value = ButtonState.paused;
                  AudioPlayerModel _audio = AudioPlayerModel(
                      productID: widget.products.id,
                      audioPosition: position.inMilliseconds);
                  _audioPlayerProvider.addAudioPosition(_audio);
                  audioHandler.pause();
                },
                title: widget.products.title ?? "",
              ),
              // if (isClicked || savedPosition != Duration.zero || isPlaying)
              //   AudioProgressBar(
              //       savedPosition: savedPosition, totalPosition: leftDuration),
              const SizedBox(width: 10),
              AudioplayerTimer(
                  title: widget.products.title ?? "",
                  leftPosition: leftDuration,
                  savedPosition: savedPosition),
              const Spacer(),
              widget.products.isBought == false
                  ? IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        widget.products.isBought == true ||
                                widget.isBought == true
                            ? _downloadFile()
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
}
