import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_textfield.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/course_lessons_tasks.dart';
import 'package:goodali/models/task_answer.dart';
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
  YoutubePlayerController? _ytbPlayerController;
  List<TaskAnswers> taskAnswerList = [];
  List<bool> _checkboxValue = [];

  @override
  void initState() {
    super.initState();

    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
      body: Padding(
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
                  initiliazeVideo(widget.courseReadingTasks[index].videoUrl);
                });
              }
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
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.courseReadingTasks[index].question ??
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
                                initialVideoId:
                                    widget.courseReadingTasks[index].videoUrl ??
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

  saveAnswer(String taskId, String textFieldData, int isAnswered) {
    Map answerData = {
      "task_id": taskId,
      "text_field_data": textFieldData,
      "is_answered": isAnswered
    };
    Connection.saveAnswer(context, answerData);
  }
}
