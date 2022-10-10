import 'dart:convert';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';

import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';

import 'package:goodali/models/task_answer.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CourseTasks extends StatefulWidget {
  final String? title;
  final List<CourseLessonsTasksModel> courseTasks;
  final double? initialPage;
  const CourseTasks(
      {Key? key, this.title, required this.courseTasks, this.initialPage})
      : super(key: key);

  @override
  State<CourseTasks> createState() => _CourseTasksState();
}

class _CourseTasksState extends State<CourseTasks> {
  List<TextEditingController> _controllers = [];
  late final AudioPlayer audioPlayer = AudioPlayer();
  YoutubePlayerController? _ytbPlayerController;
  List<TaskAnswers> taskAnswerList = [];

  late final PageController _pageController =
      PageController(initialPage: widget.initialPage?.toInt() ?? 0);

  List<bool> _checkboxValue = [];
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeIn;
  bool isPlaying = false;
  bool isLoading = true;
  double _current = 0;
  Stream<DurationState>? _durationState;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;
  int saveddouble = 0;

  @override
  void initState() {
    super.initState();
    print(widget.initialPage);
    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    for (var i = 0; i < widget.courseTasks.length; i++) {
      _controllers.add(TextEditingController());
      _checkboxValue.add(false);
    }
    _current = widget.initialPage?.toDouble() ?? 1.0;

    _pageController.addListener(() {
      setState(() {
        _current = _pageController.page!;
      });
    });
  }

  initiliazeAudio(String audioURl, int id) async {
    print(audioURl);
    await audioPlayer.setUrl(audioURl).then((value) {
          setState(() => isLoading = false);
          return value;
        }) ??
        Duration.zero;

    _durationState = Rx.combineLatest2<PlaybackEvent, Duration, DurationState>(
        audioPlayer.playbackEventStream,
        AudioService.position,
        (playbackEvent, position) => DurationState(
              position,
              playbackEvent.bufferedPosition,
              playbackEvent.duration,
            ));

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
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();

    // developer.log(decodedProduct.first.audioPosition.toString());
    for (var item in decodedProduct) {
      if (moodItemID == item.productID) {
        saveddouble = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }
    position = Duration(milliseconds: saveddouble);

    return position;
  }

  initiliazeVideo(videoUrl) {
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: videoUrl,
      params: const YoutubePlayerParams(
        showControls: true,
        origin: "https://www.youtube.com/embed/",
        autoPlay: true,
      ),
    );

    // _controller?.addListener(listener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    for (TextEditingController c in _controllers) {
      c.dispose();
    }
    _ytbPlayerController?.close();
    super.dispose();
  }

  @override
  void deactivate() {
    _ytbPlayerController?.pause();
    super.deactivate();
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
            title: widget.title ?? "",
            backFunction: () {
              Navigator.pop(context, _current);
            }),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.courseTasks.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      switch (widget.courseTasks[index].type) {
                        case 0:
                        case 1:
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                            child: type0(widget.courseTasks[index], index),
                          );
                        // case 1:
                        //   return Padding(
                        //     padding: const EdgeInsets.all(20),
                        //     child: type1(widget.courseTasks[index], index),
                        //   );
                        case 2:
                          initiliazeAudio(
                              Urls.networkPath +
                                  widget.courseTasks[index].listenAudio!,
                              widget.courseTasks[index].id ?? 0);

                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: listen(widget.courseTasks[index]),
                          );

                        case 4:
                          initiliazeVideo(Urls.networkPath +
                              widget.courseTasks[index].videoUrl!);

                          return video(widget.courseTasks[index], index);

                        case 5:
                        case 6:
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: exercise(widget.courseTasks[index], index),
                          );

                        default:
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: type0(widget.courseTasks[index], index),
                          );
                      }
                    }),
              ),
              Positioned(
                  bottom: 30,
                  // right: 35,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: MyColors.gray, width: 0.5),
                              borderRadius: BorderRadius.circular(14)),
                          child: Center(
                            child: Wrap(children: [
                              Text(
                                ((_current + 1).toInt()).toString(),
                                style: const TextStyle(
                                    color: MyColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text("/",
                                  style: TextStyle(
                                    color: MyColors.black,
                                    fontSize: 16,
                                  )),
                              Text(widget.courseTasks.length.toString(),
                                  style: const TextStyle(
                                      color: MyColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: CustomElevatedButton(
                                onPress: () async {
                                  _pageController.nextPage(
                                      curve: _kCurve, duration: _kDuration);

                                  if (_controllers[_current.toInt()].text !=
                                          "" ||
                                      _checkboxValue[_current.toInt()] ==
                                          true) {
                                    saveAnswer(
                                            widget.courseTasks[_current.toInt()]
                                                .id
                                                .toString(),
                                            _controllers[_current.toInt()].text,
                                            1)
                                        .whenComplete(() => showTopSnackBar(
                                            context,
                                            const CustomTopSnackBar(
                                              type: 1,
                                              text: "Амжилттай хадгалагдлаа",
                                            )));
                                  }
                                  if (_current + 1 ==
                                      widget.courseTasks.length) {
                                    Navigator.pop(context, _current);
                                  }
                                },
                                text: _current + 1 == widget.courseTasks.length
                                    ? "Дуусгах"
                                    : "Дараах"),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget type0(CourseLessonsTasksModel courseTask, int index) {
    _controllers[index].text = courseTask.answerData == ""
        ? _controllers[index].text
        : courseTask.answerData ?? "";
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (courseTask.body != "" || courseTask.body!.isNotEmpty)
          HtmlWidget(courseTask.body ?? ""),
        Text(courseTask.question ?? "",
            style: const TextStyle(
                color: MyColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        if (courseTask.isAnswer == 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: TextField(
                controller: _controllers[index],
                cursorColor: MyColors.primaryColor,
                maxLength: 2000,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Хариулт",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.border1, width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.primaryColor),
                  ),
                )),
          ),
      ],
    ));
  }

  Widget type1(CourseLessonsTasksModel courseTask, int index) {
    return Column(
      children: [
        if (courseTask.body != "" || courseTask.body!.isNotEmpty)
          HtmlWidget(courseTask.body ?? ""),
        Text(courseTask.question ?? ""),
        TextField(
            controller: _controllers[index],
            cursorColor: MyColors.primaryColor,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.border1, width: 0.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.primaryColor),
              ),
            )),
      ],
    );
  }

  Widget exercise(CourseLessonsTasksModel courseTask, int index) {
    return Column(
      children: [
        Text(courseTask.question ?? ""),
        TextField(
            controller: _controllers[index],
            cursorColor: MyColors.primaryColor,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.border1, width: 0.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.primaryColor),
              ),
            )),
      ],
    );
  }

  Widget video(CourseLessonsTasksModel courseTask, int index) {
    log(courseTask.videoUrl ?? "", name: "videoUrl");
    return Column(
      children: [
        _ytbPlayerController?.value.isReady != null
            ? YoutubePlayerControllerProvider(
                controller: _ytbPlayerController ??
                    YoutubePlayerController(
                        initialVideoId: courseTask.videoUrl ?? ""),
                child: const YoutubePlayerIFrame(
                  aspectRatio: 16 / 9,
                ),
              )
            : const CircularProgressIndicator(color: MyColors.primaryColor),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyColors.border1)),
          margin: const EdgeInsets.only(bottom: 110, left: 20, right: 20),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Checkbox(
                  shape: const CircleBorder(),
                  activeColor: MyColors.success,
                  value: _checkboxValue[index],
                  onChanged: (value) {
                    setState(() {
                      _checkboxValue[index] = value!;
                    });
                  }),
              const Text("Видеог дуустал нь үзсэн.",
                  style: TextStyle(color: MyColors.black)),
            ],
          ),
        )
      ],
    );
  }

  Widget listen(CourseLessonsTasksModel courseTask) {
    return Column(
      children: [audioPlayerWidget()],
    );
  }

  Widget audioPlayerWidget() {
    final audioPosition =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    return StreamBuilder<DurationState>(
        stream: _durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          position = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          duration = durationState?.total ?? Duration.zero;
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
    final audioPosition = Provider.of<AudioPlayerProvider>(context);
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
                    // audioHandler.pause().then((value) {
                    //   AudioPlayerModel _audio = AudioPlayerModel(
                    //       productID: moodItem[_current.toInt()].id,
                    //       audioPosition: position.inMilliseconds);
                    //   audioPosition.addAudioPosition(_audio);
                    // });
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

  Future saveAnswer(String taskId, String textFieldData, int isAnswered) async {
    Map answerData = {
      "task_id": taskId,
      "text_field_data": textFieldData,
      "is_answered": isAnswered
    };
    print(answerData);
    var data = await Connection.saveAnswer(context, answerData);
    return data['success'] ? true : false;
  }
}
