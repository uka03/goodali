import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audio_session.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:goodali/models/products_model.dart';
import 'package:goodali/controller/audio_player_handler.dart';
import 'package:goodali/screens/audioScreens.dart/audio_description.dart';
import 'package:goodali/screens/audioScreens.dart/audio_progress_bar.dart';
import 'package:goodali/screens/audioScreens.dart/download_page.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;

class PlayAudio extends StatefulWidget {
  final Products products;
  final String albumName;
  const PlayAudio({Key? key, required this.products, required this.albumName})
      : super(key: key);

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  Stream<DurationState>? _durationState;
  Stream<DurationState>? _progressBarState;
  final ReceivePort _port = ReceivePort();

  int currentview = 0;
  int saveddouble = 0;

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPos = Duration.zero;

  String url = "";
  String manuFacturer = "";

  bool isExited = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDeviceModel();

    url = Urls.networkPath + widget.products.audio!;

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    audioPlayer.dispose();
    super.dispose();
  }

  getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      manuFacturer = androidInfo.manufacturer ?? "";
      print("manuFacturer $manuFacturer");
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    }
    if (manuFacturer == "samsung" || Platform.isIOS) {
      print(" samsunggg bnsndsj");
      initForOthers(url);
    } else {
      initForChinesePhone(url);
    }
  }

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  initForOthers(String url) async {
    try {
      duration = await audioPlayer.setUrl(url).then((value) {
            setState(() => isLoading = false);
            return value;
          }) ??
          Duration.zero;

      MediaItem item = MediaItem(
        id: url,
        title: widget.products.title ?? "",
        duration: duration,
        artUri: Uri.parse(Urls.networkPath + widget.products.banner!),
      );

      developer.log("edit ${item.id}");
      developer.log("edit ${item.duration}");

      saveddouble = Provider.of<AudioPlayerProvider>(context, listen: false)
          .getPosition(widget.products.productId ?? 0);

      savedPos = Duration(milliseconds: saveddouble);

      setState(() {
        _durationState =
            Rx.combineLatest3<MediaItem?, Duration, Duration, DurationState>(
                audioHandler.mediaItem,
                AudioService.position,
                _bufferedPositionStream,
                (mediaItem, position, buffered) => DurationState(
                      progress: position,
                      buffered: buffered,
                      total: mediaItem?.duration,
                    ));

        if (saveddouble != 0) {
          print("savedPos $savedPos");
          audioHandler.seek(savedPos);
          // audioHandler.play()
        } else {
          audioHandler.playMediaItem(item);
        }
      });

      AudioSession.instance.then((audioSession) async {
        await audioSession.configure(const AudioSessionConfiguration.speech());
        AudioSessionSettings.handleInterruption(audioSession);
      });
    } catch (e) {
      print(e);
    }
  }

  initForChinesePhone(String url) {
    setState(() {
      audioPlayer.setUrl(url);
    });
    _progressBarState =
        Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
            audioPlayer.positionStream,
            audioPlayer.playbackEventStream,
            (position, playbackEvent) => DurationState(
                  progress: position,
                  buffered: playbackEvent.bufferedPosition,
                  total: playbackEvent.duration!,
                ));
  }

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage;
      if (Platform.isIOS) {
        baseStorage = await getApplicationDocumentsDirectory();
      } else {
        baseStorage = await getExternalStorageDirectory();
      }

      await FlutterDownloader.enqueue(
          url: url,
          savedDir: baseStorage!.path,
          showNotification: true,
          openFileFromNotification: true);
    }
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
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        download(url);
                      },
                      icon: const Icon(IconlyLight.arrow_down,
                          color: MyColors.gray),
                      splashRadius: 1,
                    ),
                    const Text("Татах",
                        style: TextStyle(fontSize: 12, color: MyColors.gray))
                  ],
                ),
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
              child: manuFacturer == "samsung" || Platform.isIOS
                  ? audioPlayerWidget()
                  : audioPlayerChinesePhone(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Utils.buttonBackWard5Seconds(position, duration);
                  },
                  child: SvgPicture.asset(
                    "assets/images/replay_5.svg",
                  ),
                ),
                CircleAvatar(
                    radius: 36,
                    backgroundColor: MyColors.primaryColor,
                    child: manuFacturer == "samsung" || Platform.isIOS
                        ? playerButton()
                        : playerButtonforChinese()),
                InkWell(
                  onTap: () {
                    Utils.buttonForward15Seconds(position, duration);
                  },
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

    return AudioProgressBar(
      durationState: _durationState ?? const Stream.empty(),
      productID: widget.products.id ?? 0,
      audioPosition: audioPosition,
    );
  }

  Widget audioPlayerChinesePhone() {
    final audioPosition =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    return AudioProgressBar(
      durationState: _progressBarState!,
      productID: widget.products.id ?? 0,
      audioPosition: audioPosition,
      isChinese: true,
    );
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
              AudioPlayerModel _audio = AudioPlayerModel(
                  productID: widget.products.id,
                  audioPosition: position.inMilliseconds);
              audioPosition.addAudioPosition(_audio);
              audioHandler.pause();
            },
          );
        }
      },
    );
  }

  Widget playerButtonforChinese() {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (playing != true) {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: audioPlayer.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.pause_rounded,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              print(position);
              audioPlayer.pause();
            },
          );
        } else {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.replay,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () => audioPlayer.seek(Duration.zero),
          );
        }
      },
    );
  }
}
