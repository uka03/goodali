import 'dart:convert';

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

class PodcastItem extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final PodcastListModel podcastItem;
  final List<AudioPlayer> audioPlayerList;
  final Function setIndex;

  const PodcastItem(
      {Key? key,
      required this.podcastItem,
      required this.audioPlayer,
      required this.audioPlayerList,
      required this.setIndex})
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
      widget.audioPlayer.positionStream.listen((event) {
        setState(() {
          position = event;
        });
      });
      widget.audioPlayer.durationStream.listen((event) {
        duration = event ?? Duration.zero;
      });

      widget.audioPlayer.playingStream.listen((event) {
        isPlaying = event;
      });
      if (fileInfo != null) {
        print("fileInfo null ylgaatai");
        audioFile = fileInfo.file;

        widget.audioPlayer.setFilePath(audioFile!.path).then((value) {
          setState(() {
            duration = value ?? Duration.zero;
          });
        });
      } else {
        print(url);
        if (url == "") {
          print("buruu url");
        } else {
          widget.audioPlayer.setUrl(url).then((value) {
            setState(() {
              duration = value ?? Duration.zero;
            });
            print(duration);
            getSavedPosition(widget.podcastItem.id!).then((value) {
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

          widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
        }
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

                  podcastProvider.addPodcastID(widget.podcastItem.id ?? 0);
                  if (!podcastProvider.sameItemCheck) {
                    podcastProvider.addListenedPodcast(widget.podcastItem);
                  }

                  if (isPlaying) {
                    await widget.audioPlayer.pause();
                  } else {
                    await widget.audioPlayer.play();
                  }
                  AudioPlayerModel _audio = AudioPlayerModel(
                      productID: widget.podcastItem.id,
                      audioPosition: position.inMilliseconds);
                  _audioPlayerProvider.addAudioPosition(_audio);
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
