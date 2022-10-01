import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

typedef SetIndex = void Function(int index);

class DownloadedLectureItem extends StatefulWidget {
  final Products? products;
  final PodcastListModel? podcastItem;
  final AudioPlayer audioPlayer;
  final List<AudioPlayer> audioPlayerList;
  final SetIndex setIndex;
  const DownloadedLectureItem(
      {Key? key,
      this.products,
      this.podcastItem,
      required this.audioPlayer,
      required this.audioPlayerList,
      required this.setIndex})
      : super(key: key);

  @override
  State<DownloadedLectureItem> createState() => _DownloadedLectureItemState();
}

class _DownloadedLectureItemState extends State<DownloadedLectureItem> {
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
    super.initState();

    getCachedFile(Urls.networkPath +
        (widget.podcastItem?.audio ?? widget.products!.audio ?? ""));
  }

  getCachedFile(String url) async {
    await checkCachefor(url).then((value) => initiliazeAudio(url, value));
  }

  Future<FileInfo?> checkCachefor(String url) async {
    final FileInfo? value =
        await CustomCacheManager.instance.getFileFromCache(url);
    return value;
  }

  initiliazeAudio(String url, FileInfo? fileInfo) async {
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

        widget.audioPlayer.setFilePath(audioFile!.path).then((value) {
          duration = value ?? Duration.zero;
          getSavedPosition(
                  widget.products?.productId ?? widget.podcastItem?.id ?? 0)
              .then((value) {
            if (value != Duration.zero) {
              savedPosition = value;
              position = savedPosition;
              // if (position != Duration.zero) {
              //   widget.audioPlayer.seek(position);
              // }
              widget.audioPlayer
                  .setFilePath(audioFile!.path, initialPosition: position);
            } else {}
          });
        });
        //    MediaItem item;
        // getSavedPosition().then((value) {
        //   setState(() {
        //     _durationState =
        //         Rx.combineLatest3<MediaItem?, Duration, Duration, DurationState>(
        //             audioHandler.mediaItem,
        //             AudioService.position,
        //             _bufferedPositionStream,
        //             (mediaItem, position, buffered) => DurationState(
        //                 progress: position,
        //                 buffered: buffered,
        //                 total: mediaItem?.duration));
        //     position = value;
        //     audioHandler.playbackState.listen((PlaybackState state) {
        //       if (!state.playing) {
        //         AudioPlayerModel _audio = AudioPlayerModel(
        //             productID:
        //                 widget.products?.productId ?? widget.podcastItem?.id,
        //             audioPosition: position.inMilliseconds);
        //         savePosition(_audio);
        //       }
        //     });

        //     item = MediaItem(
        //         id: url,
        //         title: widget.products?.title ?? widget.podcastItem?.title ?? "",
        //         duration: duration,
        //         artUri: Uri.parse(Urls.networkPath + banner),
        //         extras: {"position": position.inMilliseconds});

        //     developer.log("edit ${item.id}");
        //     developer.log("duration ${item.duration}");
        //     developer.log("duration ${item.extras?['position']}");

        //     audioHandler.playMediaItem(item);
        //   });
        // });

        // AudioSession.instance.then((audioSession) async {
        //   await audioSession.configure(const AudioSessionConfiguration.speech());
        //   AudioSessionSettings.handleInterruption(audioSession);
        // });
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

  @override
  Widget build(BuildContext context) {
    final downloadAudio = Provider.of<AudioDownloadProvider>(context);
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
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
                      imgPath: widget.products?.banner ??
                          widget.podcastItem?.banner ??
                          "",
                      width: 40,
                      height: 40)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.products?.title ?? widget.podcastItem?.title ?? "",
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: MyColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    CustomReadMoreText(
                        text: widget.products?.body ??
                            widget.podcastItem?.body ??
                            "")
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
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
                        productID: widget.products?.productId ??
                            widget.podcastItem?.id,
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
                    podcastItem: widget.podcastItem,
                    albumName: widget.products?.albumTitle ??
                        widget.podcastItem?.title ??
                        "",
                    isDownloaded: true,
                    notifyParent: () {},
                  ),
                );
              },
            ));
  }

  // void _removeFile() {
  //   DefaultCacheManager().removeFile().then((value) {
  //     //ignore: avoid_print
  //     print('File removed');
  //   }).onError((error, stackTrace) {
  //     //ignore: avoid_print
  //     print(error);
  //   });
  // }
}
