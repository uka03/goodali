import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/audio_progressbar.dart';
import 'package:goodali/Widgets/audioplayer_button.dart';
import 'package:goodali/Widgets/audioplayer_timer.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/download_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';

import 'package:goodali/models/products_model.dart';

import 'package:just_audio/just_audio.dart';

typedef OnTap = Function(Products audioObject);

class AlbumDetailItem extends StatefulWidget {
  final Products products;
  final Products? albumProducts;
  final List<Products> productsList;
  final String albumName;
  final bool isBought;
  final VoidCallback onTap;
  final int index;
  const AlbumDetailItem(
      {Key? key,
      required this.products,
      required this.albumName,
      required this.productsList,
      required this.isBought,
      this.albumProducts,
      required this.onTap,
      required this.index})
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

  var _totalduration = Duration.zero;

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

  Future<Duration> getTotalDuration() async {
    try {
      if (widget.products.duration == null || widget.products.duration == 0) {
        _totalduration = await getFileDuration(url);
      } else {
        _totalduration = Duration(milliseconds: widget.products.duration!);
      }

      setState(() {
        duration = _totalduration;
        isLoading = false;
      });

      savedPosition = widget.products.position!;

      return duration;
    } catch (e) {
      log(e.toString(), name: "detail item");
    }
    return duration;
  }

  Future<Duration> getFileDuration(String mediaPath) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double duration = double.parse(mediaInfo.getDuration()!);
    widget.products.duration = (duration * 1000).toInt();
    await widget.products.save();
    return Duration(milliseconds: (duration * 1000).toInt());
  }

  getCachedFile(String url) async {
    fileInfo = await audioPlayerController.checkCachefor(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                    widget.isBought &&
                            widget.products.lectureTitle != null &&
                            widget.products.lectureTitle!.isNotEmpty
                        ? widget.products.lectureTitle!
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
        ValueListenableBuilder(
            valueListenable: durationStateNotifier,
            builder: (context, DurationState value, child) {
              var buttonState = buttonNotifier.value;
              var currently = currentlyPlaying.value;
              bool isPlaying = currently?.title == widget.products.title &&
                      buttonState == ButtonState.playing
                  ? true
                  : false;

              return Row(
                children: [
                  AudioPlayerButton(
                    id: widget.products.id!,
                    onPlay: () async {
                      widget.onTap();
                    },
                    onPause: () {
                      audioHandler.pause();
                    },
                    title: widget.products.title ?? "",
                  ),
                  const SizedBox(width: 10),
                  isLoading
                      ? const SizedBox(
                          width: 30,
                          child: LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              minHeight: 2,
                              color: MyColors.black))
                      : Row(
                          children: [
                            (savedPosition > 0 || isPlaying)
                                ? AudioProgressBar(
                                    totalDuration: duration,
                                    title: widget.products.title ?? "",
                                    savedPostion:
                                        Duration(milliseconds: savedPosition),
                                  )
                                : Container(),
                            const SizedBox(width: 10),
                            AudioplayerTimer(
                              id: widget.products.id!,
                              title: widget.products.title ?? "",
                              totalDuration: _totalduration,
                              savedDuration:
                                  Duration(milliseconds: savedPosition),
                            ),
                          ],
                        ),
                  const Spacer(),
                  DownloadButton(products: widget.products),
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
                ],
              );
            }),
        const SizedBox(height: 12)
      ],
    );
  }
}
