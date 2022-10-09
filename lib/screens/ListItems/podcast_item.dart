import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/podcast_provider.dart';
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
import 'package:goodali/screens/audioScreens.dart/download_page.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

typedef OnTap = Function(Products audioObject);

class PodcastItem extends StatefulWidget {
  final Products podcastItem;
  final List<Products> podcastList;
  final OnTap onTap;
  final int index;

  const PodcastItem({
    Key? key,
    required this.podcastItem,
    required this.podcastList,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PodcastItem> createState() => _PodcastItemState();
}

class _PodcastItemState extends State<PodcastItem> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerController audioPlayerController = AudioPlayerController();
  String audioUrl = "";
  bool isPlaying = false;

  int saveddouble = 0;
  int currentIndex = 0;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;
  Duration leftDuration = Duration.zero;

  FileInfo? fileInfo;
  File? audioFile;
  Stream<FileResponse>? fileStream;
  List<MediaItem> mediaItems = [];
  MediaItem item = const MediaItem(id: "", title: "");
  String banner = "";
  bool isbgPlaying = false;
  bool isLoading = true;

  @override
  void initState() {
    if (widget.podcastItem.audio != "Audio failed to upload") {
      audioUrl = Urls.networkPath + (widget.podcastItem.audio ?? "");
    }
    banner = Urls.networkPath + (widget.podcastItem.banner ?? "");
    getCachedFile(audioUrl);
    super.initState();
  }

  Future<void> setAudio(String url, FileInfo? fileInfo) async {
    try {
      isbgPlaying = buttonNotifier.value == ButtonState.playing ? true : false;

      if (url != "") {
        if (fileInfo != null) {
          audioFile = fileInfo.file;
          audioUrl = audioFile!.path;
          duration =
              await audioPlayer.setFilePath(audioFile!.path) ?? Duration.zero;
        } else {
          audioUrl = url;
          duration = await audioPlayer.setUrl(url) ?? Duration.zero;
        }

        audioPlayerController
            .getSavedPosition(widget.podcastItem.id!)
            .then((value) async {
          savedPosition = value;
          if (!mounted) return;
          setState(() {
            leftDuration = duration - savedPosition;
            isLoading = false;
          });

          position = savedPosition;
          developer.log(duration.toString(), name: "leftDuration");

          for (var e in widget.podcastList) {
            item = MediaItem(
                id: audioUrl,
                title: e.title ?? "",
                duration: duration,
                artUri: Uri.parse(banner),
                extras: {
                  "position": position.inMilliseconds,
                  "isDownloaded": fileInfo != null ? true : false
                });
            mediaItems.add(item);
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
      fileStream = CustomCacheManager.instance
          .getFileStream(audioUrl, withProgress: true);
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
            AudioPlayerButton(
              onPlay: () {
                setState(() {
                  isPlaying = true;
                });
                audioHandler.playMediaItem(mediaItems[widget.index]);

                audioHandler.play();
                currentlyPlaying.value = widget.podcastItem;
                buttonNotifier.value = ButtonState.playing;
                podcastProvider.addPodcastID(widget.podcastItem.id ?? 0);
                if (!podcastProvider.sameItemCheck) {
                  podcastProvider.addListenedPodcast(
                      widget.podcastItem, widget.podcastList);
                }
                developer.log("play");
                widget.onTap(widget.podcastItem);
              },
              onPause: () {
                widget.onTap(widget.podcastItem);
                developer.log("paused");

                buttonNotifier.value = ButtonState.paused;
                AudioPlayerModel _audio = AudioPlayerModel(
                    productID: widget.podcastItem.id,
                    audioPosition: position.inMilliseconds);
                _audioPlayerProvider.addAudioPosition(_audio);
                audioHandler.pause().then((value) =>
                    podcastProvider.unListenedPodcastFun(
                        widget.podcastItem, widget.podcastList));
              },
              title: widget.podcastItem.title ?? "",
            ),
            const SizedBox(width: 14),
            if (savedPosition != Duration.zero || isPlaying)
              isLoading
                  ? Container()
                  : AudioProgressBar(
                      savedPosition: savedPosition, totalDuration: duration),
            const SizedBox(width: 14),
            AudioplayerTimer(
                title: widget.podcastItem.title ?? "",
                leftPosition: leftDuration,
                savedPosition: savedPosition),
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
                    products: widget.podcastItem,
                    isPodcast: true,
                  ),
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
