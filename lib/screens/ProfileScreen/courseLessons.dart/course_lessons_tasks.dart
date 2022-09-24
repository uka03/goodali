import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_textfield.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/course_lessons_tasks.dart';
import 'package:goodali/models/task_answer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CourseReadingTasks extends StatefulWidget {
  final String? title;
  final List<CourseLessonsTasksModel> courseReadingTasks;
  const CourseReadingTasks(
      {Key? key, this.title, required this.courseReadingTasks})
      : super(key: key);

  @override
  State<CourseReadingTasks> createState() => _CourseReadingTasksState();
}

class _CourseReadingTasksState extends State<CourseReadingTasks> {
  List<TextEditingController> _controllers = [];
  late final AudioPlayer audioPlayer = AudioPlayer();
  YoutubePlayerController? _ytbPlayerController;
  List<TaskAnswers> taskAnswerList = [];
  List<bool> _checkboxValue = [];

  bool isPlaying = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;
  int saveddouble = 0;

  @override
  void initState() {
    super.initState();

    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    audioPlayer.positionStream.listen((event) {
      position = event;
    });
    audioPlayer.durationStream.listen((event) {
      duration = event ?? Duration.zero;
    });

    audioPlayer.playingStream.listen((event) {
      isPlaying = event;
    });
  }

  initiliazeAudio(String audioURl, int id) async {
    print(audioURl);
    duration = await audioPlayer.setUrl(audioURl).then((value) {
          // setState(() => isLoading = false);
          return value;
        }) ??
        Duration.zero;
    getSavedPosition(id).then((value) {
      setState(() {
        print("duration $duration");
        if (value == Duration.zero) {
        } else {
          print(value);
          audioPlayer.seek(value);
        }

        {}
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

  initiliazeVideo(videoUrl) {
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: videoUrl,
      params: const YoutubePlayerParams(
        startAt: Duration(seconds: 30),
        autoPlay: true,
      ),
    );
    // _controller?.addListener(listener);
  }

  @override
  void dispose() {
    // _controller?.dispose();
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
      appBar: SimpleAppBar(title: widget.title ?? ""),
      body: widget.courseReadingTasks.isEmpty
          ? const Center(
              child: Text("Хичээл хоосон байна",
                  style: TextStyle(color: MyColors.gray)),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemCount: widget.courseReadingTasks.length,
                itemBuilder: (context, index) {
                  _controllers.add(TextEditingController());
                  for (var i = 0; i < widget.courseReadingTasks.length; i++) {
                    if (widget.courseReadingTasks[index].isAnswer == 3 ||
                        widget.courseReadingTasks[index].isAnswer == 4 ||
                        widget.courseReadingTasks[index].isAnswer == 2) {
                      _checkboxValue.add(false);
                    }
                  }
                  _checkboxValue.add(false);
                  if (widget.courseReadingTasks[index].videoUrl != "") {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      initiliazeVideo(
                          widget.courseReadingTasks[index].videoUrl);
                    });
                  }
                  // if (widget.courseReadingTasks[index].listenAudio != "" ||
                  //     widget.courseReadingTasks[index].listenAudio !=
                  //         "Audio failed to upload") {
                  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
                  //     initiliazeAudio(
                  //         Urls.networkPath +
                  //             widget.courseReadingTasks[index].listenAudio!,
                  //         widget.courseReadingTasks[index].id?.toInt() ?? 0);
                  //   });
                  // }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        widget.courseReadingTasks[index].body != ""
                            ? HtmlWidget(
                                widget.courseReadingTasks[index].body ?? "")
                            : Container(),
                        (widget.courseReadingTasks[index].question != "")
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.courseReadingTasks[index]
                                              .question ??
                                          "",
                                      style: const TextStyle(
                                          color: MyColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )),
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        (widget.courseReadingTasks[index].isAnswer == 1)
                            ? CustomTextField(
                                controller: _controllers[index],
                                hintText: "Хариулт",
                                maxLength: 2000)
                            : Container(),
                        if (widget.courseReadingTasks[index].type == 2 ||
                            widget.courseReadingTasks[index].type == 3)
                          CheckboxListTile(
                              activeColor: MyColors.success,
                              selectedTileColor: MyColors.success,
                              title: const Text("Аудио сонссон"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _checkboxValue[index],
                              onChanged: (value) {
                                setState(() {
                                  _checkboxValue[index] = value!;
                                });
                              }),
                        if (widget.courseReadingTasks[index].type == 2 ||
                            widget.courseReadingTasks[index].type == 3)
                          CustomTextField(
                              controller: _controllers[index],
                              hintText: "Хариулт",
                              maxLength: 2000),
                        if (widget.courseReadingTasks[index].videoUrl != "")
                          YoutubePlayerControllerProvider(
                            controller: _ytbPlayerController ??
                                YoutubePlayerController(
                                    initialVideoId: widget
                                            .courseReadingTasks[index]
                                            .videoUrl ??
                                        ""),
                            child: const YoutubePlayerIFrame(
                              aspectRatio: 16 / 9,
                            ),
                          ),
                        if (widget.courseReadingTasks[index].type == 4)
                          CheckboxListTile(
                              activeColor: MyColors.success,
                              selectedTileColor: MyColors.success,
                              title: const Text("Видео үзсэн"),
                              value: _checkboxValue[index],
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  _checkboxValue[index] = value!;
                                });
                              }),
                        if (widget.courseReadingTasks[index].type == 4)
                          CustomTextField(
                              controller: _controllers[index],
                              hintText: "Хариулт",
                              maxLength: 2000),
                        (widget.courseReadingTasks[index].type == 5 ||
                                widget.courseReadingTasks[index].type == 6)
                            ? CustomTextField(
                                controller: _controllers[index],
                                hintText: "Хариулт",
                                maxLength: 2000)
                            : Container(),
                      ],
                    ),
                  );
                },
              )),
      persistentFooterButtons: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomElevatedButton(
                onPress: () {
                  print(widget.courseReadingTasks.length);
                  print(_controllers.length);

                  for (var i = 0; i < widget.courseReadingTasks.length; i++) {
                    TaskAnswers taskAnswers = TaskAnswers(
                        isAnswered: _controllers[i].text == "" ? 0 : 1,
                        taskFieldData: _controllers[i].text);
                    taskAnswerList.add(taskAnswers);
                    saveAnswer(
                        widget.courseReadingTasks[i].id.toString(),
                        _controllers[i].text,
                        _controllers[i].text == "" ? 0 : 1);
                    print(i);
                  }
                },
                text: "Хадгалах")),
      ],
    );
  }

  Widget audioPlayerWidget() {
    final audioPosition =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: MyColors.input,
          child: IconButton(
            splashRadius: 20,
            padding: EdgeInsets.zero,
            onPressed: () async {
              if (isPlaying) {
                audioPlayer.pause();
              } else {
                await audioPlayer.play();
              }
            },
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 30,
              color: MyColors.black,
            ),
          ),
        ),
        Slider(
          value: position.inSeconds.toDouble(),
          max: duration.inSeconds.toDouble(),
          activeColor: MyColors.primaryColor,
          inactiveColor: MyColors.border1,
          onChanged: (duration) async {
            final position = Duration(microseconds: (duration * 1000).toInt());
            await audioPlayer.seek(position);

            await audioPlayer.play();
          },
        ),
      ],
    );
  }

  saveAnswer(String taskId, String textFieldData, int isAnswered) {
    Map answerData = {
      "task_id": taskId,
      "text_field_data": textFieldData,
      "is_answered": isAnswered
    };
    Connection.saveAnswer(context, answerData);
  }
}
