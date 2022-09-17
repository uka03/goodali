import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audio_session.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:audio_session/audio_session.dart';
import 'package:goodali/models/mood_item.dart';

import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class MoodDetail extends StatefulWidget {
  final String moodListId;
  const MoodDetail({Key? key, required this.moodListId}) : super(key: key);

  @override
  State<MoodDetail> createState() => _MoodDetailState();
}

class _MoodDetailState extends State<MoodDetail> {
  late final Future futureMoodItem = getMoodList();
  final PageController _pageController = PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeIn;
  Stream<DurationState>? _durationState;
  Stream<DurationState>? _progressBarState;
  List<MoodItem> moodItem = [];
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;
  int saveddouble = 0;

  double _current = 0;
  bool isLoading = true;
  bool isExited = false;

  String url = "";
  String imgUrl = "";
  String manuFacturer = "";

  Widget rightButton = const Text(
    "Дараах",
    style: TextStyle(
        color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold),
  );

  final _player = ja.AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  @override
  void initState() {
    super.initState();

    getMoodList().then((value) {
      moodItem = value;
      if (value.length == 1) {
        print("url $url");
        initForOthers(Urls.networkPath + moodItem.first.audio!,
            moodItem[_current.toInt() + 1].id ?? 0);
      }
    });
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
    // _durationState.timeout(timeLimit)
    super.dispose();
  }

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  initForOthers(String url, int id) async {
    try {
      print(url);
      await audioPlayer.dynamicSet(url: url);
      duration = await audioPlayer.setUrl(url).then((value) {
            setState(() => isLoading = false);
            return value;
          }) ??
          Duration.zero;

      MediaItem item = MediaItem(
        id: url,
        title: moodItem[_current.toInt()].title ?? "",
        duration: duration,
        // artUri: Uri.parse(moodItem[_current.toInt()].banner!),
      );

      developer.log("edit ${item.id}");
      developer.log("edit ${item.duration}");

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

      getSavedPosition(id).then((value) {
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

  Future getSavedPosition(int moodItemID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();

    // developer.log(decodedProduct.first.audioPosition.toString());
    for (var item in decodedProduct) {
      print(moodItemID);
      print(item.productID);
      if (moodItemID == item.productID) {
        saveddouble = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }
    position = Duration(milliseconds: saveddouble);
    print("position $position");
    return position;
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
                        print(page);
                        print(moodItem.length);
                        if (url != "") {
                          initForOthers(
                              url, moodItem[_current.toInt() + 1].id ?? 0);
                        }
                      },
                      itemBuilder: ((context, index) {
                        imgUrl =
                            moodItem[index].banner == "Image failed to upload"
                                ? ""
                                : moodItem[index].banner!;
                        url = moodItem[index].audio == "Audio failed to upload"
                            ? ""
                            : Urls.networkPath + moodItem[index].audio!;

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
                                if (imgUrl != "") banner(imgUrl),
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
                                audioPlayerWidget()
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

  Widget banner(String imgUrl) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child:
            // Container(
            //   height: 260,
            //   width: 260,
            //   color: Colors.deepPurple[200],
            // )
            ImageView(
          imgPath: imgUrl,
          height: 260,
          width: 260,
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
                  baseBarColor: isExited ? Colors.white54 : Colors.white10,
                  onSeek: (duration) async {
                    final position = duration;
                    await audioHandler.seek(position);

                    await audioHandler.play();
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
    final audioPosition = Provider.of<AudioPlayerProvider>(
      context,
    );
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
          child: StreamBuilder<bool>(
            stream: audioHandler.playbackState
                .map((state) => state.playing)
                .distinct(),
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;

              if (isLoading) {
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
                  onPressed: () {
                    audioHandler.play();
                  },
                );
              } else {
                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.pause_rounded,
                    color: MyColors.primaryColor,
                    size: 40.0,
                  ),
                  onPressed: () {
                    AudioPlayerModel _audio = AudioPlayerModel(
                        productID: moodItem[_current.toInt()].id,
                        audioPosition: position.inMilliseconds);
                    audioPosition.addAudioPosition(_audio);
                    audioHandler.pause();
                  },
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
      audioHandler.seek(const Duration(seconds: 0));
    } else {
      audioHandler.seek(position);
    }
  }

  buttonForward15Seconds(Duration position, Duration duration) {
    position = position + const Duration(seconds: 15);

    if (duration > position) {
      audioHandler.seek(position);
    } else if (duration < position) {
      audioHandler.seek(duration);
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
