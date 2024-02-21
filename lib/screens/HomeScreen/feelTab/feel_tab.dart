import 'dart:developer';

import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/audio_progressbar.dart';
import 'package:goodali/Widgets/audioplayer_button.dart';
import 'package:goodali/Widgets/audioplayer_timer.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/get_mood_list.dart';

import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/ListItems/mood_item.dart';

class FeelTabbar extends StatefulWidget {
  final bool? isHomeScreen;

  const FeelTabbar({Key? key, this.isHomeScreen = false}) : super(key: key);

  @override
  State<FeelTabbar> createState() => _FeelTabbarState();
}

class _FeelTabbarState extends State<FeelTabbar> with AutomaticKeepAliveClientMixin<FeelTabbar> {
  late final futureMoodList = getMoodList();
  bool isLoading = true;
  bool isDone = true;
  List<Products> moodMain = [];
  Products? products;
  int savedPosition = 0;
  var _totalduration = Duration.zero;
  Duration duration = Duration.zero;
  String url = "";

  Future<Duration> getFileDuration(String mediaPath) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double duration = double.parse(mediaInfo.getDuration()!);
    moodMain[0].duration = (duration * 1000).toInt();
    await moodMain[0].save();
    return Duration(milliseconds: (duration * 1000).toInt());
  }

  Future<Duration> getTotalDuration(String url) async {
    try {
      if (moodMain[0].duration == null || moodMain[0].duration == 0) {
        _totalduration = await getFileDuration(url);
      } else {
        _totalduration = Duration(milliseconds: moodMain[0].duration!);
      }

      if (mounted) {
        setState(() {
          duration = _totalduration;
          isLoading = false;
        });
      }

      savedPosition = moodMain[0].position!;

      return duration;
    } catch (e) {
      log(e.toString(), name: "mood main");
    }
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    getMoodMain();
    super.build(context);
    return Material(
      child: FutureBuilder(
          future: futureMoodList,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              List<GetMoodList> moodList = snapshot.data;
              if (moodList.isNotEmpty) {
                return isDone
                    ? const Center(child: CircularProgressIndicator(color: MyColors.primaryColor))
                    : (kIsWeb)
                        ? Container(
                            padding: widget.isHomeScreen == false
                                ? const EdgeInsets.only(left: 255, right: 255)
                                : EdgeInsets.zero,
                            color: widget.isHomeScreen == true ? Colors.white : const Color(0xfffcf4f1),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Мүүд",
                                        style: TextStyle(
                                          color: MyColors.black,
                                          fontSize: 56,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: ImageView(imgPath: moodMain[0].banner ?? "", width: 30, height: 30),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  moodMain[0].title ?? "",
                                                  style: const TextStyle(
                                                      color: MyColors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                const SizedBox(height: 5),
                                                CustomReadMoreText(text: moodMain[0].body ?? "")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      ValueListenableBuilder(
                                          valueListenable: durationStateNotifier,
                                          builder: (context, DurationState value, child) {
                                            var buttonState = buttonNotifier.value;
                                            var currently = currentlyPlaying.value;
                                            bool isPlaying = currently?.title == moodMain[0].title &&
                                                    buttonState == ButtonState.playing
                                                ? true
                                                : false;
                                            return Row(
                                              children: [
                                                AudioPlayerButton(
                                                  id: moodMain[0].id!,
                                                  onPlay: () async {
                                                    currentlyPlaying.value = moodMain.first;
                                                    if (activeList.first.title == moodMain.first.title &&
                                                        activeList.first.id == moodMain.first.id) {
                                                      currentlyPlaying.value = moodMain.first;
                                                      await audioHandler.skipToQueueItem(0);
                                                      await audioHandler.seek(
                                                        Duration(milliseconds: moodMain.first.position!),
                                                      );
                                                      await audioHandler.play();
                                                    } else if (activeList.first.title != moodMain.first.title ||
                                                        activeList.first.id != moodMain.first.id) {
                                                      activeList = moodMain;
                                                      await initiliazePodcast();
                                                      await audioHandler.skipToQueueItem(0);
                                                      await audioHandler.seek(
                                                        Duration(milliseconds: moodMain.first.position!),
                                                      );
                                                      await audioHandler.play();
                                                    }
                                                  },
                                                  onPause: () {
                                                    audioHandler.pause();
                                                  },
                                                  title: moodMain[0].title ?? "",
                                                ),
                                                const SizedBox(width: 10),
                                                isLoading
                                                    ? const SizedBox(
                                                        width: 30,
                                                        child: LinearProgressIndicator(
                                                            backgroundColor: Colors.transparent,
                                                            minHeight: 2,
                                                            color: MyColors.black))
                                                    : Row(
                                                        children: [
                                                          (savedPosition > 0 || isPlaying)
                                                              ? AudioProgressBar(
                                                                  totalDuration: duration,
                                                                  title: moodMain[0].title ?? "",
                                                                  savedPostion: Duration(milliseconds: savedPosition),
                                                                )
                                                              : Container(),
                                                          const SizedBox(width: 10),
                                                          AudioplayerTimer(
                                                            id: moodMain[0].id!,
                                                            title: moodMain[0].title ?? "",
                                                            totalDuration: _totalduration,
                                                            savedDuration: Duration(milliseconds: savedPosition),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            );
                                          }),
                                      const SizedBox(height: 600),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  flex: 2,
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: moodList.length,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                    ),
                                    itemBuilder: (BuildContext context, int index) {
                                      return MoodListItem(
                                          getMoodList: moodList[index], isHomeScreen: widget.isHomeScreen);
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 30.0, bottom: 20, right: 20, left: 20),
                                child: Text("Мүүд",
                                    style: TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20, left: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: ImageView(imgPath: moodMain[0].banner ?? "", width: 30, height: 30),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                moodMain[0].title ?? "",
                                                style: const TextStyle(
                                                    color: MyColors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              const SizedBox(height: 5),
                                              CustomReadMoreText(text: moodMain[0].body ?? "")
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    ValueListenableBuilder(
                                        valueListenable: durationStateNotifier,
                                        builder: (context, DurationState value, child) {
                                          var buttonState = buttonNotifier.value;
                                          var currently = currentlyPlaying.value;
                                          bool isPlaying = currently?.title == moodMain[0].title &&
                                                  buttonState == ButtonState.playing
                                              ? true
                                              : false;

                                          return Row(
                                            children: [
                                              AudioPlayerButton(
                                                id: moodMain[0].id!,
                                                onPlay: () async {
                                                  currentlyPlaying.value = moodMain.first;
                                                  if (activeList.first.title == moodMain.first.title &&
                                                      activeList.first.id == moodMain.first.id) {
                                                    currentlyPlaying.value = moodMain.first;
                                                    await audioHandler.skipToQueueItem(0);
                                                    await audioHandler.seek(
                                                      Duration(milliseconds: moodMain.first.position!),
                                                    );
                                                    await audioHandler.play();
                                                  } else if (activeList.first.title != moodMain.first.title ||
                                                      activeList.first.id != moodMain.first.id) {
                                                    activeList = moodMain;
                                                    await initiliazePodcast();
                                                    await audioHandler.skipToQueueItem(0);
                                                    await audioHandler.seek(
                                                      Duration(milliseconds: moodMain.first.position!),
                                                    );
                                                    await audioHandler.play();
                                                  }
                                                },
                                                onPause: () {
                                                  audioHandler.pause();
                                                },
                                                title: moodMain[0].title ?? "",
                                              ),
                                              const SizedBox(width: 10),
                                              isLoading
                                                  ? const SizedBox(
                                                      width: 30,
                                                      child: LinearProgressIndicator(
                                                          backgroundColor: Colors.transparent,
                                                          minHeight: 2,
                                                          color: MyColors.black))
                                                  : Row(
                                                      children: [
                                                        (savedPosition > 0 || isPlaying)
                                                            ? AudioProgressBar(
                                                                totalDuration: duration,
                                                                title: moodMain[0].title ?? "",
                                                                savedPostion: Duration(milliseconds: savedPosition),
                                                              )
                                                            : Container(),
                                                        const SizedBox(width: 10),
                                                        AudioplayerTimer(
                                                          id: moodMain[0].id!,
                                                          title: moodMain[0].title ?? "",
                                                          totalDuration: _totalduration,
                                                          savedDuration: Duration(milliseconds: savedPosition),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: moodList.length,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1 / 1.4,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 15,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return MoodListItem(
                                        getMoodList: moodList[index], isHomeScreen: widget.isHomeScreen);
                                  },
                                ),
                              ),
                            ],
                          );
              } else {
                return Container();
              }
            } else {
              return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor));
            }
          }),
    );
  }

  Future<List<GetMoodList>> getMoodList() {
    return Connection.getMoodList(context, "1");
  }

  Future<void> getMoodMain() async {
    if (moodMain.isNotEmpty) return;
    var listData = await Connection.getMoodMain(context);
    setState(() {
      isDone = false;
    });
    url = Urls.networkPath + listData.first.audio!;

    await dataMoodStore.addProduct(products: listData.first);
    moodMain = await dataMoodStore.getMoodMainfromBox(listData.first.title!);
    for (var element in moodMain) {
      if (element.id == listData.first.id) {
        products = element;
        savedPosition = element.position ?? 0;
      }
    }

    if (url != "") {
      await getTotalDuration(url);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
