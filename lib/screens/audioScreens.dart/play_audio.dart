import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audio_session.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';

import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/audio_description.dart';
import 'package:goodali/screens/audioScreens.dart/audio_progress_bar.dart';
import 'package:goodali/screens/audioScreens.dart/download_page.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class PlayAudio extends StatefulWidget {
  final Products products;
  final String albumName;
  final bool? isDownloaded;
  final String? downloadedAudioPath;
  const PlayAudio(
      {Key? key,
      required this.products,
      required this.albumName,
      this.isDownloaded = false,
      this.downloadedAudioPath})
      : super(key: key);

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  AudioPlayer audioPlayer = AudioPlayer();
  Stream<DurationState>? _durationState;
  Future<FileInfo>? fileFuture;
  Stream<FileResponse>? fileStream;

  FileInfo? fileInfo;

  int currentview = 0;
  int saveddouble = 0;

  PlayerState? playerState;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPos = Duration.zero;

  File? audioFile;

  String url = "";
  String manuFacturer = "";
  String taskId = "";

  bool isExited = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    url = Urls.networkPath + widget.products.audio!;
    getCachedFile(url);
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  getCachedFile(String url) async {
    fileInfo = await checkCacheFor(url);

    developer.log(fileInfo?.file.path ?? "jfn");
    _initAudioPlayer(url, fileInfo);
  }

  void _downloadFile() {
    setState(() {
      fileStream =
          CustomCacheManager.instance.getFileStream(url, withProgress: true);

      print("fileStream ");
    });
  }

  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value =
        await CustomCacheManager.instance.getFileFromCache(url);
    return value;
  }

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  _initAudioPlayer(String url, FileInfo? fileInfo) async {
    try {
      if (fileInfo != null) {
        developer.log(fileInfo.file.path);

        audioFile = fileInfo.file;
        audioPlayer.setFilePath(audioFile!.path);
        duration = await audioPlayer.setFilePath(audioFile!.path).then((value) {
              setState(() => isLoading = false);
              return value;
            }) ??
            Duration.zero;
      } else {
        developer.log(url);
        duration = await audioPlayer.setUrl(url).then((value) {
              setState(() => isLoading = false);
              return value;
            }) ??
            Duration.zero;
      }
      audioPlayer.positionStream.listen((event) {
        if (event.inMilliseconds != 0) {
          AudioPlayerModel _audio = AudioPlayerModel(
              productID: widget.products.productId,
              audioPosition: event.inMilliseconds);
          print(_audio);
          Provider.of<AudioPlayerProvider>(context, listen: false)
              .addAudioPosition(_audio);
        }
      });

      MediaItem item = MediaItem(
        id: url,
        title: widget.products.title ?? "",
        duration: duration,
        artUri: Uri.parse(Urls.networkPath + widget.products.banner!),
      );

      developer.log("edit ${item.id}");
      developer.log("edit ${item.duration}");

      getSavedPosition().then((value) {
        developer.log(value.toString());
        setState(() {
          _durationState =
              Rx.combineLatest3<MediaItem?, Duration, Duration, DurationState>(
                  audioHandler.mediaItem,
                  AudioService.position,
                  _bufferedPositionStream,
                  (mediaItem, position, buffered) => DurationState(
                      progress: position,
                      buffered: buffered,
                      total: mediaItem?.duration));
          print("duration $duration");
          if (value == Duration.zero) {
            audioHandler.playMediaItem(item);
          } else {
            print(value);
            audioHandler.seek(value);
          }

          {}
        });
      });

      AudioSession.instance.then((audioSession) async {
        await audioSession.configure(const AudioSessionConfiguration.speech());
        AudioSessionSettings.handleInterruption(audioSession);
      });
    } catch (e) {
      print(e);
    }
  }

  Future getSavedPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();

    // developer.log(decodedProduct.first.audioPosition.toString());
    for (var item in decodedProduct) {
      if (widget.products.productId == item.productID) {
        saveddouble = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }
    position = Duration(milliseconds: saveddouble);
    print("position $position");
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return playAudio();
  }

  Widget playAudio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 6,
              decoration: BoxDecoration(
                  color: MyColors.gray,
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageView(
                imgPath: widget.products.banner ?? "",
                width: 220,
                height: 220,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              widget.albumName,
              style: const TextStyle(fontSize: 12, color: MyColors.gray),
            ),
            const SizedBox(height: 10),
            Text(
              widget.products.lectureTitle?.capitalize() ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 46),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                fileInfo != null
                    ? Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(IconlyLight.arrow_down,
                                color: MyColors.primaryColor),
                            splashRadius: 1,
                          ),
                          const Text("Татсан",
                              style:
                                  TextStyle(fontSize: 12, color: MyColors.gray))
                        ],
                      )
                    : DownloadPage(
                        fileStream: fileStream,
                        downloadFile: _downloadFile,
                        products: widget.products),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AudioDescription(
                                    description: widget.products.body ?? "")));
                      },
                      icon: const Icon(
                        IconlyLight.info_square,
                        color: MyColors.gray,
                      ),
                      splashRadius: 1,
                    ),
                    const Text("Тайлбар",
                        style: TextStyle(fontSize: 12, color: MyColors.gray))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: audioPlayerWidget()),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: buttonBackWard5Seconds,
                  child: SvgPicture.asset(
                    "assets/images/replay_5.svg",
                  ),
                ),
                CircleAvatar(
                    radius: 36,
                    backgroundColor: MyColors.primaryColor,
                    child: playerButton()),
                InkWell(
                  onTap: buttonForward15Seconds,
                  child: SvgPicture.asset(
                    "assets/images/forward_15.svg",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget audioPlayerWidget() {
    final audioPosition =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    return StreamBuilder<DurationState>(
        stream: _durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          position = savedPos == Duration.zero
              ? durationState?.progress ?? Duration.zero
              : position;
          final buffered = durationState?.buffered ?? Duration.zero;
          duration = savedPos == Duration.zero
              ? durationState?.total ?? Duration.zero
              : duration;

          return ProgressBar(
            progress: position,
            buffered: buffered,
            total: duration,
            thumbColor: MyColors.primaryColor,
            thumbGlowColor: MyColors.primaryColor,
            timeLabelTextStyle: const TextStyle(color: MyColors.gray),
            progressBarColor: MyColors.primaryColor,
            bufferedBarColor: MyColors.primaryColor.withOpacity(0.3),
            baseBarColor: MyColors.border1,
            onSeek: (duration) async {
              await audioHandler.seek(duration);
              await audioHandler.play();
            },
          );
        });
  }

  Widget playerButton() {
    final audioPosition =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    return StreamBuilder<bool>(
      stream:
          audioHandler.playbackState.map((state) => state.playing).distinct(),
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;

        if (isLoading) {
          return const CircularProgressIndicator(color: Colors.white);
        } else if (playing != true) {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              audioHandler.play();
            },
          );
        } else {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.pause_rounded,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              print("judujbds ${widget.products.id}");
              AudioPlayerModel _audio = AudioPlayerModel(
                  productID: widget.products.productId,
                  audioPosition: position.inMilliseconds);
              audioPosition.addAudioPosition(_audio);
              audioHandler.pause();
            },
          );
        }
      },
    );
  }

  buttonForward15Seconds() {
    position = position + const Duration(seconds: 15);
    print(position);
    print(duration);
    if (duration > position) {
      audioHandler.seek(position);
    } else if (duration < position) {
      audioHandler.seek(duration);
    }
  }

  buttonBackWard5Seconds() {
    position = position - const Duration(seconds: 5);

    if (position < const Duration(seconds: 0)) {
      audioHandler.seek(const Duration(seconds: 0));
    } else {
      audioHandler.seek(position);
    }
  }
}
