import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/podcast_provider.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/screens/audioScreens.dart/download_page.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'dart:developer' as developer;

typedef SetIndex = void Function(int index);
typedef OnTap(PodcastListModel audioObject, AudioPlayer audioPlayer);

class PodcastItem extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final PodcastListModel podcastItem;
  final List<AudioPlayer> audioPlayerList;
  final AudioHandler? audioHandler;
  final Function setIndex;
  final List<PodcastListModel> podcastList;
  final Function onTap;
  final int index;
  final List<AudioHandler>? audioHandlerList;

  const PodcastItem(
      {Key? key,
      required this.podcastItem,
      required this.audioPlayer,
      required this.audioPlayerList,
      required this.setIndex,
      required this.podcastList,
      required this.index,
      required this.onTap,
      this.audioHandler,
      this.audioHandlerList})
      : super(key: key);

  @override
  State<PodcastItem> createState() => _PodcastItemState();
}

class _PodcastItemState extends State<PodcastItem> {
  AudioPlayerProvider _audioPlayerProvider = AudioPlayerProvider();
  String audioUrl = "";
  bool isPlaying = false;
  bool isClicked = false;
  int saveddouble = 0;
  int currentIndex = 0;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;

  FileInfo? fileInfo;
  File? audioFile;
  Stream<FileResponse>? fileStream;
  MediaItem item = MediaItem(id: "", title: "");
  AudioPlayerController? audioPlayerController;

  @override
  void initState() {
    if (widget.podcastItem.audio != "Audio failed to upload") {
      audioUrl = Urls.networkPath + widget.podcastItem.audio!;
    }

    getCachedFile(audioUrl);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setAudio(String url, FileInfo? fileInfo) async {
    try {
      if (fileInfo != null) {
        audioFile = fileInfo.file;
        await widget.audioPlayer.setFilePath(audioFile!.path).then((value) {
          setState(() {
            duration = value ?? Duration.zero;
          });
        });
      } else {
        if (url == "") {
          print("buruu url");
        } else {
          await widget.audioPlayer.setUrl(url).then((value) async {
            if (!mounted) return;
            setState(() {
              duration = value ?? Duration.zero;
            });
            String banner =
                Urls.networkPath + (widget.podcastItem.banner ?? "");
            print("duration$duration");

            getSavedPosition(widget.podcastItem.id!).then((value) {
              savedPosition = value;
              position = savedPosition;

              item = MediaItem(
                  id: audioUrl,
                  title: widget.podcastItem.title ?? "",
                  duration: duration,
                  artUri: Uri.parse(banner),
                  extras: {"position": position.inMilliseconds});
              widget.audioHandler?.playMediaItem(item);
            });
          });
        }
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
    print("savedPosition $savedPosition");
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

  void _downloadFile() {
    setState(() {
      fileStream = CustomCacheManager.instance
          .getFileStream(audioUrl, withProgress: true);

      print("fileStream ");
    });
  }

  @override
  Widget build(BuildContext context) {
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final podcastProvider = Provider.of<PodcastProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ImageView(
                  height: 40,
                  width: 40,
                  imgPath: widget.podcastItem.banner ?? ""),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.podcastItem.title ?? "",
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
                    text: widget.podcastItem.body ?? "",
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            ValueListenableBuilder(
              valueListenable: buttonNotifier,
              builder: (BuildContext context, value, Widget? child) {
                switch (value) {
                  case ButtonState.loading:
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: MyColors.gray,
                      ),
                    );
                  case ButtonState.playing:
                    return CircleAvatar(
                      backgroundColor: MyColors.input,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.pause_rounded,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        onPressed: () {
                          widget.onTap();
                          buttonNotifier.value = ButtonState.paused;
                          AudioPlayerModel _audio = AudioPlayerModel(
                              productID: widget.podcastItem.id,
                              audioPosition: position.inMilliseconds);
                          _audioPlayerProvider.addAudioPosition(_audio);
                          widget.audioHandler?.pause();
                        },
                      ),
                    );
                  case ButtonState.paused:
                    return CircleAvatar(
                        backgroundColor: MyColors.input,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          onPressed: () async {
                            setState(() {
                              isClicked = true;
                              currentIndex = widget.audioPlayerList
                                  .indexOf(widget.audioPlayer);
                            });
                            print("currentIndex $currentIndex");
                            buttonNotifier.value = ButtonState.playing;
                            widget.setIndex(currentIndex);
                            podcastProvider
                                .addPodcastID(widget.podcastItem.id ?? 0);
                            if (!podcastProvider.sameItemCheck) {
                              podcastProvider.addListenedPodcast(
                                  widget.podcastItem, widget.podcastList);
                            }
                            widget.onTap();
                            await widget.audioHandler?.play();
                          },
                        ));
                  default:
                    return Container();
                }
              },
            ),
            if (isClicked)
              Row(
                children: [
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 90,
                    child: ValueListenableBuilder(
                      valueListenable: durationStateNotifier,
                      builder: (BuildContext context, DurationState value,
                          Widget? child) {
                        position = value.progress ?? Duration.zero;
                        duration = value.total ?? Duration.zero;

                        print("position $position");
                        print("duration $duration");

                        return SfLinearGauge(
                          minimum: 0,
                          maximum: value.total!.inSeconds.toDouble() / 10,
                          showLabels: false,
                          showAxisTrack: false,
                          showTicks: false,
                          ranges: [
                            LinearGaugeRange(
                              position: LinearElementPosition.inside,
                              edgeStyle: LinearEdgeStyle.bothCurve,
                              startValue: 0,
                              color: MyColors.border1,
                              endValue: value.total!.inSeconds.toDouble() / 10,
                            ),
                          ],
                          barPointers: [
                            LinearBarPointer(
                                position: LinearElementPosition.inside,
                                edgeStyle: LinearEdgeStyle.bothCurve,
                                color: MyColors.primaryColor,
                                value:
                                    value.progress!.inSeconds.toDouble() / 10)
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(width: 10),
            Text(formatTime(duration - position) + "мин",
                style: const TextStyle(fontSize: 12, color: MyColors.black)),
            const Spacer(),
            fileInfo != null
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(IconlyLight.arrow_down,
                        color: MyColors.primaryColor),
                    splashRadius: 1,
                  )
                : DownloadPage(
                    fileStream: fileStream,
                    downloadFile: _downloadFile,
                    podcastItem: widget.podcastItem),
            IconButton(
                splashRadius: 20,
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
          ],
        ),
        const SizedBox(height: 12)
      ],
    );
  }
}
