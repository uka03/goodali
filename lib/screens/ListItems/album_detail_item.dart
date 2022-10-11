import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/constans.dart';
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
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

typedef OnTap = Function(Products audioObject);

class AlbumDetailItem extends StatefulWidget {
  final Products products;
  final Products? albumProducts;
  final List<Products> productsList;
  final String albumName;
  final bool isBought;
  final AudioPlayer audioPlayer;
  final OnTap onTap;

  const AlbumDetailItem(
      {Key? key,
      required this.products,
      required this.albumName,
      required this.productsList,
      required this.isBought,
      required this.audioPlayer,
      this.albumProducts,
      required this.onTap})
      : super(key: key);

  @override
  State<AlbumDetailItem> createState() => _AlbumDetailItemState();
}

class _AlbumDetailItemState extends State<AlbumDetailItem> {
  AudioPlayerController audioPlayerController = AudioPlayerController();
  List<MediaItem> mediaItems = [];
  AudioPlayer audioPlayer = AudioPlayer();
  MediaItem mediaItem = const MediaItem(id: "", title: "");
  FileInfo? fileInfo;
  File? audioFile;
  Stream<FileResponse>? fileStream;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int savedPosition = 0;

  int saveddouble = 0;
  int currentIndex = 0;
  bool isClicked = false;
  bool isPlaying = false;
  bool isLoading = true;
  bool isbgPlaying = false;
  String url = "";
  String audioURL = "";
  String introURL = "";
  String banner = "";
  MediaItem item = MediaItem(id: '', title: "");
  @override
  void initState() {
    if (widget.products.audio != "Audio failed to upload") {
      audioURL = Urls.networkPath + (widget.products.audio ?? "");
    }
    banner = Urls.networkPath + (widget.products.banner ?? "");

    url = audioURL;

    if (url != '') {
      getTotalDuration();
    }

    super.initState();
  }

  // Future<void> setAudio(Duration duration) async {
  //   try {
  //     isbgPlaying = buttonNotifier.value == ButtonState.playing ? true : false;
  //     developer.log(isbgPlaying.toString(), name: "isbgPlaying");

  //     item = MediaItem(
  //         id: widget.products.id.toString(),
  //         title: widget.products.title ?? "",
  //         album: widget.albumName,
  //         duration: duration,
  //         artUri: Uri.parse(banner),
  //         extras: {
  //           "audioUrl": Urls.networkPath + (widget.products.audio ?? "")
  //         });
  //     mediaItems.add(item);

  //     // await audioHandler.updateQueue(mediaItems);

  //     audioPlayerController.initiliaze();
  //   } on PlayerInterruptedException catch (e) {
  //     developer.log(e.toString());
  //   }
  // }

  Future<Duration> getTotalDuration() async {
    try {
      var _totalduration = await audioPlayer.setUrl(url) ?? Duration.zero;
      if (mounted) {
        setState(() {
          duration = _totalduration;
          isLoading = false;
        });
      }
      developer.log(duration.toString());
      // setAudio(duration);
    } catch (e) {}
    return duration;
  }

  getCachedFile(String url) async {
    fileInfo = await audioPlayerController.checkCachefor(url);
  }

  void _downloadFile() {
    setState(() {
      fileStream =
          CustomCacheManager.instance.getFileStream(url, withProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return GestureDetector(
      onTap: () {
        playerExpandProgress.value = playerMaxHeight;
        currentlyPlaying.value = widget.products;
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
                  });

                  audioHandler.playMediaItem(item);
                  audioHandler.play();

                  widget.onTap(widget.products);
                },
                onPause: () {
                  widget.onTap(widget.products);
                  developer.log("paused");

                  AudioPlayerModel _audio = AudioPlayerModel(
                      productID: widget.products.id,
                      audioPosition: position.inMilliseconds);
                  _audioPlayerProvider.addAudioPosition(_audio);
                  audioHandler.pause();
                },
                title: widget.products.lectureTitle == ""
                    ? widget.products.title ?? ""
                    : widget.products.lectureTitle ?? '',
              ),
              // if (isClicked)
              //   AudioProgressBar(
              //       savedPosition: savedPosition, totalDuration: duration),
              const SizedBox(width: 10),
              isLoading
                  ? const SizedBox(
                      width: 30,
                      child: LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          minHeight: 2,
                          color: MyColors.black))
                  : AudioplayerTimer(
                      title: widget.products.title ?? "",
                      totalDuration: duration),
              const Spacer(),
              widget.products.isBought == false
                  ? IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        _downloadFile();
                      },
                      icon: Icon(IconlyLight.arrow_down,
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
}
