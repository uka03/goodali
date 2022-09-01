import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/models/media_state.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/controller/audio_player_handler.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

late AudioHandler _audioHandler;

class PlayAudio extends StatefulWidget {
  final Products products;
  final String albumName;
  const PlayAudio({Key? key, required this.products, required this.albumName})
      : super(key: key);

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  late Stream<DurationState> _durationState;

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Duration savedPos = Duration.zero;

  String url = "";

  @override
  void initState() {
    super.initState();
    url = "https://staging.goodali.mn" + widget.products.intro!;

    _durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        audioPlayer.positionStream,
        audioPlayer.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            ));
    _init();
  }

  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          _audioHandler.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem, position));

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );

  Future<void> _init() async {
    try {
      setState(() {
        // if (await audioPlayer.existedInLocal(url: url) == false) {
        audioPlayer.setUrl(url);

        // }
        // audioPlayer.dynamicSet(url: url);
      });
    } catch (e) {
      debugPrint('An error occured $e');
    }
  }

  @override
  void dispose() {
    super.dispose();

    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final saveAudio = Provider.of<AudioPlayerProvider>(context, listen: false);
    return SizedBox(
      height: MediaQuery.of(context).size.height - 60,
      child: Padding(
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
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                widget.albumName,
                style: const TextStyle(fontSize: 12, color: MyColors.gray),
              ),
              const SizedBox(height: 10),
              Text(
                widget.products.title?.capitalize() ?? "",
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
                        onPressed: () {},
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
                child: StreamBuilder<DurationState>(
                    stream: _durationState,
                    builder: (context, snapshot) {
                      final durationState = snapshot.data;
                      position = savedPos == Duration.zero
                          ? durationState?.progress ?? Duration.zero
                          : savedPos;
                      final buffered = durationState?.buffered ?? Duration.zero;
                      duration = durationState?.total ?? Duration.zero;
                      return ProgressBar(
                        progress: position,
                        buffered: buffered,
                        total: duration,
                        thumbColor: MyColors.primaryColor,
                        thumbGlowColor: MyColors.primaryColor,
                        timeLabelTextStyle:
                            const TextStyle(color: MyColors.gray),
                        progressBarColor: MyColors.primaryColor,
                        bufferedBarColor:
                            MyColors.primaryColor.withOpacity(0.3),
                        baseBarColor: MyColors.border1,
                        onSeek: (duration) async {
                          await audioPlayer.seek(duration);
                          await audioPlayer.play();

                          // AudioPlayerModel _audio = AudioPlayerModel(
                          //     productID: widget.products.productId,
                          //     audioPosition: duration.inSeconds.toDouble());
                          // print(_audio);
                          // saveAudio.addAudioPosition(_audio);
                        },
                      );
                    }),
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
                    child: StreamBuilder<PlayerState>(
                      stream: audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
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
                        } else if (processingState !=
                            ProcessingState.completed) {
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
                    ),
                  ),
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
      ),
    );
  }

  buttonBackWard5Seconds() {
    position = position - const Duration(seconds: 5);

    if (position < const Duration(seconds: 0)) {
      audioPlayer.seek(const Duration(seconds: 0));
    } else {
      audioPlayer.seek(position);
    }
  }

  buttonForward15Seconds() {
    position = position + const Duration(seconds: 15);

    if (duration > position) {
      audioPlayer.seek(position);
    } else if (duration < position) {
      audioPlayer.seek(duration);
    }
  }
}

class DurationState {
  const DurationState({this.progress, this.buffered, this.total});
  final Duration? progress;
  final Duration? buffered;
  final Duration? total;
}
