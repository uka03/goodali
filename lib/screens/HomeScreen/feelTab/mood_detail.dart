import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:just_audio_cache/just_audio_cache.dart';

import 'package:goodali/models/mood_item.dart';

import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;

class MoodDetail extends StatefulWidget {
  final String moodListId;
  const MoodDetail({Key? key, required this.moodListId}) : super(key: key);

  @override
  State<MoodDetail> createState() => _MoodDetailState();
}

class _MoodDetailState extends State<MoodDetail> {
  StreamController<DurationState> _controller =
      StreamController<DurationState>.broadcast();

  late final Future futureMoodItem = getMoodList();
  final PageController _pageController = PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeIn;
  Stream<DurationState>? _durationState;
  List<MoodItem> moodItem = [];

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;

  double _current = 0;

  String url = "";

  Widget rightButton = const Text(
    "Дараах",
    style: TextStyle(
        color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold),
  );

  @override
  void initState() {
    super.initState();

    getMoodList();
    _pageController.addListener(() {
      setState(() {
        _current = _pageController.page!;
      });

      if (_current == moodItem.length - 1) {
        rightButton = const Text("Дуусгах",
            style: TextStyle(
                color: MyColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold));
      } else {
        rightButton = const Text(
          "Дараах",
          style: TextStyle(
              color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> playAudio(String url) async {
    try {
      developer.log("init $url");
      bool isExited = await audioPlayer.existedInLocal(url: url);
      print("isExited $isExited");
      if (isExited) {
        String cachedFile = await audioPlayer.getCachedPath(url: url) ?? "";
        developer.log("cached $cachedFile");
        setState(() {
          audioPlayer.setFilePath(cachedFile);
        });
      } else {
        print("jfnudonfonfd");
        setState(() {
          audioPlayer.setUrl(url);
        });
        await audioPlayer.existedInLocal(url: url);
        audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
      }
    } catch (e) {
      debugPrint('An error occured $e');
    }
    _durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        audioPlayer.positionStream,
        audioPlayer.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffE991FA),
              Color(0xff84A3F7),
            ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(IconlyLight.arrow_left, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          iconTheme: const IconThemeData(color: MyColors.black),
        ),
        body: Stack(alignment: Alignment.bottomCenter, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: futureMoodItem,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  moodItem = snapshot.data;

                  return PageView.builder(
                      controller: _pageController,
                      itemCount: moodItem.length,
                      onPageChanged: (int page) {
                        if (url != "") {
                          playAudio(url);
                        }
                      },
                      itemBuilder: ((context, index) {
                        url = moodItem[index].audio == "Audio failed to upload"
                            ? ""
                            : "https://staging.goodali.mn" +
                                moodItem[index].audio!;

                        if (moodItem[index].audio == "Audio failed to upload") {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                HtmlWidget(
                                  moodItem[index].title!,
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 40),
                                HtmlWidget(
                                  moodItem[index].body!,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (moodItem[index].banner != "")
                                  banner("https://staging.goodali.mn" +
                                      moodItem[index].banner!),
                                const SizedBox(height: 40),
                                HtmlWidget(
                                  moodItem[index].title!,
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 40),
                                HtmlWidget(
                                  moodItem[index].body!,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                                audioPlayerWidget(),
                              ],
                            ),
                          );
                        }
                      }));
                } else {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: MyColors.primaryColor),
                  );
                }
              },
            ),
          ),
          _current != 0
              ? Positioned(
                  bottom: 50,
                  left: 35,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: RawMaterialButton(
                      onPressed: () {
                        _pageController.previousPage(
                            curve: _kCurve, duration: _kDuration);
                        audioPlayer.stop();
                        _controller.close();
                      },
                      child: const Icon(IconlyLight.arrow_left,
                          color: MyColors.black),
                    ),
                  ))
              : Container(),
          Positioned(
              bottom: 50,
              right: 35,
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: RawMaterialButton(
                  onPressed: () async {
                    _pageController.nextPage(
                        curve: _kCurve, duration: _kDuration);

                    // if (url != "") {
                    //   print("duusgah");
                    //   playAudio(url);
                    // }
                    if (_current == moodItem.length - 1) {
                      audioPlayer.dispose();
                      Navigator.pop(context);
                    }
                  },
                  child: rightButton,
                ),
              )),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Row(
                children: moodItem
                    .map((entry) => (moodItem.indexOf(entry) - 1 == _current)
                        ? Container(
                            width: MediaQuery.of(context).size.width /
                                moodItem.length,
                            height: 2.0,
                            color: Colors.white.withOpacity(0.4),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width /
                                moodItem.length,
                            height: 2.0,
                            color: (_current >= moodItem.indexOf(entry))
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ))
                    .toList(),
              )),
        ]),
      ),
    );
  }

  Widget banner(String url) {
    return Center(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 260,
            width: 260,
            color: Colors.deepPurple[200],
          )
          // ImageViewer(
          //   imgPath: url,
          //   height: 260,
          //   width: 260,
          // ),
          ),
    );
  }

  Widget audioPlayerWidget() {
    return StreamBuilder<DurationState>(
        stream: _durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final position = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final duration = durationState?.total ?? Duration.zero;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ProgressBar(
                  progress: position,
                  buffered: buffered,
                  total: duration,
                  thumbColor: Colors.white,
                  thumbGlowColor: MyColors.primaryColor,
                  timeLabelTextStyle: const TextStyle(color: MyColors.gray),
                  progressBarColor: Colors.white,
                  bufferedBarColor: Colors.white54,
                  baseBarColor: Colors.white10,
                  onSeek: (duration) async {
                    final position = duration;
                    await audioPlayer.seek(position);

                    await audioPlayer.play();
                  },
                ),
                const SizedBox(height: 20),
                playerButton(position, duration)
              ],
            ),
          );
        });
  }

  Widget playerButton(Duration position, Duration duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            buttonBackWard5Seconds(position);
          },
          child: SvgPicture.asset("assets/images/replay_5.svg",
              color: Colors.white),
        ),
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.white,
          child: StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return const CircularProgressIndicator(
                    color: MyColors.primaryColor);
              } else if (playing != true) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: MyColors.primaryColor,
                    size: 40.0,
                  ),
                  onPressed: audioPlayer.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.pause_rounded,
                    color: MyColors.primaryColor,
                    size: 40.0,
                  ),
                  onPressed: audioPlayer.pause,
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
          onTap: () {
            buttonForward15Seconds(position, duration);
          },
          child: SvgPicture.asset("assets/images/forward_15.svg",
              color: Colors.white),
        ),
      ],
    );
  }

  buttonBackWard5Seconds(Duration position) {
    position = position - const Duration(seconds: 5);

    if (position < const Duration(seconds: 0)) {
      audioPlayer.seek(const Duration(seconds: 0));
    } else {
      audioPlayer.seek(position);
    }
  }

  buttonForward15Seconds(Duration position, Duration duration) {
    position = position + const Duration(seconds: 15);

    if (duration > position) {
      audioPlayer.seek(position);
    } else if (duration < position) {
      audioPlayer.seek(duration);
    }
  }

  Future<List<MoodItem>> getMoodList() async {
    moodItem = await Connection.getMoodItem(context, widget.moodListId);
    setState(() {
      moodItem = moodItem;
    });

    return moodItem;
  }
}

class DurationState {
  const DurationState({this.progress, this.buffered, this.total});
  final Duration? progress;
  final Duration? buffered;
  final Duration? total;
}
