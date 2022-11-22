import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/controller/progress_notifier.dart';
import 'package:goodali/models/products_model.dart';
import 'package:http/http.dart';

import 'package:iconly/iconly.dart';
import 'dart:developer' as developer;

class MoodDetail extends StatefulWidget {
  final String moodListId;
  final String? id;
  const MoodDetail({Key? key, required this.moodListId, this.id})
      : super(key: key);

  @override
  State<MoodDetail> createState() => _MoodDetailState();
}

class _MoodDetailState extends State<MoodDetail> {
  final PageController _pageController = PageController();
  final HiveMoodDataStore dataMoodStore = HiveMoodDataStore();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeIn;
  Products? products;
  List<Products> moodItem = [];

  double _current = 0;
  String url = "";
  String imgUrl = "";

  var totalDuration = Duration.zero;
  var currentDuration = Duration.zero;
  var savedPosition = 0;
  var boxList = [];

  Widget rightButton = const Text(
    "Дараах",
    style: TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  );

  @override
  void initState() {
    getMoodList();
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _current = _pageController.page!;
      });

      if (_current == moodItem.length - 1) {
        rightButton = const Text("Дуусгах",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold));
      } else {
        rightButton = const Text(
          "Дараах",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<Duration> getTotalDuration(url, Products products) async {
    try {
      print("2 dahi function");
      print(products.title);
      if (products.duration == null || products.duration == 0) {
        totalDuration = await getFileDuration(url, products);
      } else {
        totalDuration = Duration(milliseconds: products.duration!);
      }

      return totalDuration;
    } catch (e) {
      developer.log(e.toString(), name: "mood error");
    }
    return totalDuration;
  }

  Future<Duration> getFileDuration(String mediaPath, Products products) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double _duration = double.parse(mediaInfo.getDuration()!);
    products.duration = (_duration * 1000).toInt();
    await products.save();
    return Duration(milliseconds: (_duration * 1000).toInt());
  }

  Future<bool> initiliaze(Products products) async {
    print("3 dahi function");
    if (activeList.isNotEmpty && activeList.first.id == products.id) {
      return true;
    } else {
      activeList.clear();
    }
    activeList.add(products);
    await initiliazePodcast();
    return true;
  }

  onPlayButtonClicked(Products products) async {
    currentlyPlaying.value = products;

    developer.log("Starts in: $savedPosition");
    await audioHandler.seek(
      Duration(milliseconds: savedPosition),
    );
    audioHandler.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 244, 241, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(IconlyLight.arrow_left, color: MyColors.black)),
        iconTheme: const IconThemeData(color: MyColors.black),
      ),
      body: Stack(alignment: Alignment.bottomCenter, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ValueListenableBuilder(
            valueListenable: HiveMoodDataStore.box.listenable(),
            builder: (context, Box box, _) {
              if (box.length > 0) {
                List<Products> moodList = [];
                for (var i = 0; i < box.length; i++) {
                  Products products = box.get(i);
                  if (products.moodListId == int.parse(widget.moodListId)) {
                    moodList.add(products);
                  }
                }

                moodItem = moodList;

                return PageView.builder(
                    controller: _pageController,
                    itemCount: moodItem.length,
                    onPageChanged: (int page) {
                      if (url != "") {}
                    },
                    itemBuilder: ((context, index) {
                      imgUrl =
                          moodItem[index].banner == "Image failed to upload"
                              ? ""
                              : moodItem[index].banner!;
                      url = moodItem[index].audio == "Audio failed to upload"
                          ? ""
                          : Urls.networkPath + moodItem[index].audio!;

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            banner(imgUrl),
                            const SizedBox(height: 20),
                            HtmlWidget(
                              moodItem[index].title!,
                              textStyle: const TextStyle(
                                  color: MyColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            const SizedBox(height: 40),
                            HtmlWidget(
                              moodItem[index].body!,
                              textStyle: const TextStyle(
                                  color: MyColors.black, fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            if (url != "") audioPlayerWidget(index)
                          ],
                        ),
                      );
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
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: RawMaterialButton(
                    onPressed: () {
                      _pageController.previousPage(
                          curve: _kCurve, duration: _kDuration);
                    },
                    child:
                        const Icon(IconlyLight.arrow_left, color: Colors.white),
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
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: RawMaterialButton(
                onPressed: () async {
                  _pageController.nextPage(
                      curve: _kCurve, duration: _kDuration);
                  if (_current == moodItem.length - 1) {
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
                          color: Colors.white,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width /
                              moodItem.length,
                          height: 2.0,
                          color: (_current >= moodItem.indexOf(entry))
                              ? MyColors.primaryColor
                              : Colors.white,
                        ))
                  .toList(),
            )),
      ]),
    );
  }

  Widget banner(String imgUrl) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ImageView(
          imgPath: imgUrl,
          height: 260,
          width: 260,
        ),
      ),
    );
  }

  Widget audioPlayerWidget(int index) {
    return ValueListenableBuilder(
        valueListenable: progressNotifier,
        builder: (context, ProgressBarState value, child) {
          currentDuration = value.current;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ProgressBar(
                  progress: currentDuration,
                  buffered: currentDuration,
                  total: totalDuration,
                  thumbGlowColor: MyColors.primaryColor,
                  timeLabelTextStyle: const TextStyle(color: MyColors.gray),
                  baseBarColor: MyColors.border1,
                  progressBarColor: MyColors.primaryColor,
                  thumbColor: MyColors.primaryColor,
                  bufferedBarColor: MyColors.primaryColor.withAlpha(20),
                  onSeek: (duration) async {
                    await audioHandler.seek(duration);
                  },
                ),
                const SizedBox(height: 20),
                playerButton(index)
              ],
            ),
          );
        });
  }

  Widget playerButton(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            buttonBackWard5Seconds(currentDuration);
          },
          child: SvgPicture.asset("assets/images/replay_5.svg",
              color: MyColors.primaryColor),
        ),
        CircleAvatar(
          radius: 36,
          backgroundColor: MyColors.primaryColor,
          child: ValueListenableBuilder(
            valueListenable: buttonNotifier,
            builder: (BuildContext context, ButtonState? buttonValue,
                Widget? child) {
              bool isPlaying =
                  buttonValue == ButtonState.playing ? true : false;
              bool isBuffering =
                  buttonValue == ButtonState.loading ? true : false;

              if (isBuffering) {
                return const CircularProgressIndicator(color: Colors.white);
              } else if (isPlaying != true) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  onPressed: () {
                    onPlayButtonClicked(products!);
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
                  onPressed: () async {
                    // await updateSavedPosition();
                    audioHandler.pause();
                  },
                );
              }
            },
          ),
        ),
        InkWell(
          onTap: () {
            buttonForward15Seconds(currentDuration, totalDuration);
          },
          child: SvgPicture.asset("assets/images/forward_15.svg",
              color: MyColors.primaryColor),
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

  Future<List<Products>> getMoodList() async {
    var listData = await Connection.getMoodItem(
        context, widget.id != null ? widget.id! : widget.moodListId);
    setState(() {
      moodItem = listData;
    });
    String url = "";

    for (var item in moodItem) {
      if (item.audio != "Audio failed to upload") {
        url = Urls.networkPath + item.audio!;
      }
      await dataMoodStore.addProduct(products: item);
      var list = await dataMoodStore.getMoodListfromBox();
      for (var element in list) {
        if (element.id == item.id) {
          products = element;
          savedPosition = element.position ?? 0;
        }
      }
    }
    developer.log(savedPosition.toString(), name: "moodItem duration");
    if (url != "") {
      await getTotalDuration(url, products!);
      await initiliaze(products!);
    }
    return listData;
  }
}
