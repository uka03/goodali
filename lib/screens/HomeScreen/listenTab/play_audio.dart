import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:goodali/models/products_model.dart';
import 'package:goodali/controller/audio_player_handler.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
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
  int currentview = 0;
  int saveddouble = 0;

  List<Widget> pages = [];
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPos = Duration.zero;

  String url = "";
  String manuFacturer = "";

  bool isExited = false;
  bool isLoading = true;

  final _player = ja.AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  @override
  void initState() {
    super.initState();
    getDeviceModel();
    pages = [playAudio(), audioDesc()];

    url = Urls.networkPath + widget.products.audio!;
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
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
    _init(url);
  }

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  Future<void> _init(String url) async {
    try {
      if (manuFacturer == "samsung" || Platform.isIOS) {
        print(" samsunggg bnsndsj");
        initForOthers(url);
      } else {
        initForChinesePhone(url);
      }
    } catch (e) {
      debugPrint('An error occured $e');
    }
  }

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
        // artUri: Uri.parse(moodItem[_current.toInt()].banner!),
      );

      developer.log("edit ${item.id}");
      developer.log("edit ${item.duration}");

      saveddouble = Provider.of<AudioPlayerProvider>(context, listen: false)
          .getPosition(widget.products.productId ?? 0);

      savedPos = Duration(milliseconds: saveddouble);

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

      AudioSession.instance.then((audioSession) async {
        await audioSession.configure(const AudioSessionConfiguration.speech());
        _handleInterruptions(audioSession);
      });

      setState(() {
        if (saveddouble != 0) {
          print("savedPos $savedPos");
          audioHandler.seek(savedPos);
          // audioHandler.play()
        } else {
          developer.log("edit ${item.duration}");
          audioHandler.playMediaItem(item);
        }
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

  void _handleInterruptions(AudioSession audioSession) {
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
      print('PAUSE');
      _player.pause();
    });
    _player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      print('interruption begin: ${event.begin}');
      print('interruption type: ${event.type}');
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              _player.setVolume(_player.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_player.playing) {
              _player.pause();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(min(1.0, _player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) _player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
    audioSession.devicesChangedEventStream.listen((event) {
      print('Devices added: ${event.devicesAdded}');
      print('Devices removed: ${event.devicesRemoved}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // final saveAudio = Provider.of<AudioPlayerProvider>(context, listen: false);
    return playAudio();
  }

  buttonBackWard5Seconds() {
    position = position - const Duration(seconds: 5);

    if (position < const Duration(seconds: 0)) {
      audioHandler.seek(const Duration(seconds: 0));
    } else {
      audioHandler.seek(position);
    }
  }

  buttonForward15Seconds() {
    position = position + const Duration(seconds: 15);

    if (duration > position) {
      audioHandler.seek(position);
    } else if (duration < position) {
      audioHandler.seek(duration);
    }
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
            Container(
              width: 220,
              height: 220,
              color: Colors.pink,
            ),
            // ImageView(
            //   imgPath: widget.products.banner ?? "",
            //   width: 220,
            //   height: 220,
            // ),
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
                      onPressed: () {},
                      icon: const Icon(
                        IconlyLight.arrow_down,
                        color: MyColors.gray,
                      ),
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
                        setState(() {
                          currentview = 1;
                        });
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
                  onTap: buttonBackWard5Seconds,
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
          final position = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final duration = durationState?.total ?? Duration.zero;

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

              AudioPlayerModel _audio = AudioPlayerModel(
                  productID: widget.products.id,
                  audioPosition: position.inMilliseconds);
              audioPosition.addAudioPosition(_audio);
            },
          );
        });
  }

  Widget audioPlayerChinesePhone() {
    return StreamBuilder<DurationState>(
        stream: _progressBarState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final position = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          duration = durationState?.total ?? Duration.zero;
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
              await audioPlayer.seek(duration);
              await audioPlayer.play();
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

  Widget audioDesc() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                currentview = 0;
              });
            },
            icon: const Icon(
              IconlyLight.arrow_left,
              color: MyColors.gray,
            ),
            splashRadius: 1,
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.center,
            child: Text("Тайлбар",
                style: TextStyle(
                    color: MyColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          HtmlWidget(widget.products.body ?? "",
              textStyle: const TextStyle(color: MyColors.gray))
        ],
      ),
    );
  }
}
