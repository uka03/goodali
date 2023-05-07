import 'dart:convert';
import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as prog;
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/controller/progress_notifier.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/models/task_answer.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/task_type_0.dart';
import 'package:goodali/screens/audioScreens.dart/task_video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseTasks extends StatefulWidget {
  final String? title;
  final List<CourseLessonsTasksModel> courseTasks;
  final double? initialPage;
  final String? lessonName;
  const CourseTasks({Key? key, this.title, required this.courseTasks, this.initialPage, this.lessonName}) : super(key: key);

  @override
  State<CourseTasks> createState() => _CourseTasksState();
}

class _CourseTasksState extends State<CourseTasks> {
  final List<TextEditingController> _controllers = [];

  late final AudioPlayer audioPlayer = AudioPlayer();

  List<TaskAnswers> taskAnswerList = [];

  late final PageController _pageController = PageController(initialPage: widget.initialPage?.toInt() ?? 0);

  final List<bool> _checkboxValue = [];
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeIn;
  bool isPlaying = false;
  bool isLoading = true;
  bool isTyping = false;
  double _current = 0;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;
  int saveddouble = 0;

  @override
  void initState() {
    for (var i = 0; i < widget.courseTasks.length; i++) {
      TextEditingController controller = TextEditingController();
      controller.text = widget.courseTasks[i].answerData ?? "";
      _controllers.add(controller);

      _checkboxValue.add(false);
    }
    _current = widget.initialPage?.toDouble() ?? 1.0;

    _pageController.addListener(() {
      setState(() {
        _current = _pageController.page!;
      });
    });

    super.initState();
  }

  initiliazeAudio(String audioURl, int id) async {
    // log(audioURl);
    await audioPlayer.setUrl(audioURl).then((value) {
          setState(() => isLoading = false);
          return value;
        }) ??
        Duration.zero;

    getSavedPosition(id).then((value) {
      setState(() {
        if (value == Duration.zero) {
        } else {
          audioPlayer.seek(value);
        }
      });
    });
  }

  Future getSavedPosition(int moodItemID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString.map((res) => AudioPlayerModel.fromJson(json.decode(res))).toList();

    // developer.log(decodedProduct.first.audioPosition.toString());
    for (var item in decodedProduct) {
      if (moodItemID == item.productID) {
        saveddouble = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }
    position = Duration(milliseconds: saveddouble);

    return position;
  }

  @override
  void dispose() {
    _pageController.dispose();

    for (TextEditingController c in _controllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _current);
        return true;
      },
      child: Scaffold(
        appBar: kIsWeb
            ? null
            : SimpleAppBar(
                title: widget.title ?? "",
                data: _current,
                noCard: true,
              ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              Visibility(
                visible: kIsWeb,
                child: HeaderWidget(
                  title: widget.lessonName,
                  subtitle: widget.title,
                  isProfile: true,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.courseTasks.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        switch (widget.courseTasks[index].type) {
                          case 0:
                          case 1:
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: TaskType0(courseTask: widget.courseTasks[index], textController: _controllers[index]),
                            );
                          case 2:
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: listen(index),
                            );
                          case 4:
                            return TaskVideoPlayer(
                                courseTasks: widget.courseTasks[index],
                                index: index,
                                onChanged: (isWatched) {
                                  setState(() => _checkboxValue[index] = isWatched);
                                },
                                textController: _controllers[index]);

                          case 5:
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: exercise(widget.courseTasks[index], index),
                            );
                          case 6:
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: exercise(widget.courseTasks[index], index),
                            );

                          default:
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: TaskType0(courseTask: widget.courseTasks[index], textController: _controllers[index]),
                            );
                        }
                      }),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.white, border: Border.all(color: MyColors.gray, width: 0.5), borderRadius: BorderRadius.circular(14)),
                      child: Center(
                        child: Wrap(children: [
                          Text(
                            ((_current + 1).toInt()).toString(),
                            style: const TextStyle(color: MyColors.black, fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          ),
                          const Text("/",
                              style: TextStyle(
                                color: MyColors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              )),
                          Text(widget.courseTasks.length.toString(),
                              style: const TextStyle(color: MyColors.black, fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomElevatedButton(onPress: _onPressed, text: _current + 1 == widget.courseTasks.length ? "Дуусгах" : "Дараах"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  _onPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_controllers[_current.toInt()].text != "" || _checkboxValue[_current.toInt()] == true || widget.courseTasks[_current.toInt()].isAnswer == 0) {
      String answerData = _controllers[_current.toInt()].text.toString();
      await saveAnswer(widget.courseTasks[_current.toInt()].id.toString(), answerData, 1);
      setState(() {
        widget.courseTasks[_current.toInt()].answerData = _controllers[_current.toInt()].text.toString();
      });

      await TopSnackBar.successFactory(msg: "Амжилттай хадгалагдлаа", duration: 1).show(context);
      if (_current + 1 == widget.courseTasks.length) {
        Navigator.pop(context, _current);
      }
      _pageController.nextPage(curve: _kCurve, duration: _kDuration);
    } else {
      _pageController.nextPage(curve: _kCurve, duration: _kDuration);
    }
  }

  Widget type1(CourseLessonsTasksModel courseTask, int index) {
    return Column(
      children: [
        if (courseTask.body != "" || courseTask.body!.isNotEmpty)
          Text(
            parseHtmlString(courseTask.body ?? ""),
            style: const TextStyle(fontFamily: "Gilroy", height: 1.6),
          ),
        Text(courseTask.question ?? ""),
        TextField(
            controller: _controllers[index],
            cursorColor: MyColors.primaryColor,
            onTap: () => setState(() {
                  isTyping = true;
                }),
            onChanged: (value) {},
            decoration: InputDecoration(
              suffixIcon: isTyping
                  ? GestureDetector(
                      onTap: () {
                        _controllers[index].text = "";
                        setState(() {
                          isTyping = false;
                        });
                      },
                      child: const Icon(Icons.close, color: MyColors.black),
                    )
                  : const SizedBox(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.border1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
              ),
            )),
      ],
    );
  }

  Widget exercise(CourseLessonsTasksModel courseTask, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (courseTask.banner != null && courseTask.banner != "Image failed to upload") banner(courseTask.banner!),
            if (courseTask.body != "" || courseTask.body!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                child: HtmlWidget(
                  courseTask.body ?? "",
                  textStyle: const TextStyle(fontFamily: "Gilroy", height: 1.6),
                ),
              ),
            if (courseTask.listenAudio != null && courseTask.listenAudio != 'Audio failed to upload')
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: listen(index),
              ),
            if (courseTask.isAnswer == 1)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _controllers[index],
                  maxLength: 2000,
                  maxLines: null,
                  cursorColor: MyColors.primaryColor,
                  onTap: () => setState(() {
                    isTyping = true;
                  }),
                  decoration: InputDecoration(
                    hintText: "Хариулт",
                    suffixIcon: isTyping
                        ? GestureDetector(
                            onTap: () {
                              _controllers[index].text = "";
                              setState(() {
                                isTyping = false;
                              });
                            },
                            child: const Icon(Icons.close, color: MyColors.black),
                          )
                        : const SizedBox(),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.border1),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget banner(String imgUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ImageView(
            imgPath: imgUrl,
            height: 260,
            width: 260,
          ),
        ),
      ),
    );
  }

  Widget listen(index) {
    Products prodItem = Products(
      title: widget.title,
      banner: widget.courseTasks[index].banner,
      id: widget.courseTasks[index].id,
      body: widget.courseTasks[index].body,
      albumTitle: widget.lessonName,
      audio: widget.courseTasks[index].listenAudio,
      productId: widget.courseTasks[index].id,
      duration: 0,
      position: 0,
    );
    widget.courseTasks[index].products = prodItem;
    // initiliazeAudio(Urls.networkPath + widget.courseTasks[index].listenAudio!, widget.courseTasks[index].id ?? 0);
    String url = Urls.networkPath + widget.courseTasks[index].listenAudio!;
    getTotalDuration(url, widget.courseTasks[index].products!);
    initiliazeAudio(Urls.networkPath + widget.courseTasks[index].listenAudio!, widget.courseTasks[index].id ?? 0);

    return Column(
      children: [audioPlayerWidget(index, prodItem)],
    );
  }

  var totalDuration = Duration.zero;
  var currentDuration = Duration.zero;

  Future<void> getTotalDuration(url, Products products) async {
    try {
      if (products.duration == null || products.duration == 0) {
        totalDuration = await getFileDuration(url, products);
      } else {
        totalDuration = Duration(milliseconds: products.duration!);
      }
      await initiliaze(products);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Duration> getFileDuration(String mediaPath, Products products) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double _duration = double.parse(mediaInfo.getDuration()!);
    products.duration = (_duration * 1000).toInt();
    return Duration(milliseconds: (_duration * 1000).toInt());
  }

  Future<bool> initiliaze(Products products) async {
    currentlyPlaying.value = products;
    if (activeList.isNotEmpty && activeList.first.id == products.id) {
      return true;
    } else {
      activeList.clear();
    }
    activeList.add(products);
    await initiliazePodcast();
    await audioHandler.seek(
      savedPosition,
    );
    return true;
  }

  Widget audioPlayerWidget(int index, Products prod) {
    return ValueListenableBuilder(
        valueListenable: progressNotifier,
        builder: (context, ProgressBarState value, child) {
          currentDuration = value.current;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                prog.ProgressBar(
                  progress: currentDuration,
                  buffered: currentDuration,
                  total: totalDuration,
                  thumbGlowColor: MyColors.primaryColor,
                  timeLabelTextStyle: const TextStyle(color: MyColors.gray),
                  baseBarColor: MyColors.border1,
                  progressBarColor: MyColors.primaryColor,
                  thumbColor: MyColors.primaryColor,
                  bufferedBarColor: MyColors.primaryColor.withAlpha(20),
                  onSeek: (duration) {
                    audioHandler.seek(duration);
                  },
                ),
                const SizedBox(height: 20),
                playerButton(index, prod)
              ],
            ),
          );
        });
  }

  Widget playerButton(int index, Products prod) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            buttonBackWard5Seconds(currentDuration);
          },
          child: SvgPicture.asset("assets/images/replay_5.svg", color: MyColors.primaryColor),
        ),
        CircleAvatar(
          radius: 36,
          backgroundColor: MyColors.primaryColor,
          child: ValueListenableBuilder(
            valueListenable: buttonNotifier,
            builder: (BuildContext context, ButtonState? buttonValue, Widget? child) {
              bool isPlaying = buttonValue == ButtonState.playing ? true : false;
              bool isBuffering = buttonValue == ButtonState.loading ? true : false;

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
                    onPlayButtonClicked(prod);
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
          child: SvgPicture.asset("assets/images/forward_15.svg", color: MyColors.primaryColor),
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

  onPlayButtonClicked(Products products) async {
    currentlyPlaying.value = products;
    audioHandler.play();
  }

  Future saveAnswer(String taskId, String textFieldData, int isAnswered) async {
    Map answerData = {"task_id": taskId, "text_field_data": textFieldData, "is_answered": isAnswered};

    return Connection.saveAnswer(context, answerData);
  }
}
