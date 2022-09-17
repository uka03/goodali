import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_textfield.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/course_lessons_tasks.dart';
import 'package:video_player/video_player.dart';

class CourseReadingTasks extends StatefulWidget {
  final String? title;
  final List<CourseLessonsTasks> courseReadingTasks;
  const CourseReadingTasks(
      {Key? key, this.title, required this.courseReadingTasks})
      : super(key: key);

  @override
  State<CourseReadingTasks> createState() => _CourseReadingTasksState();
}

class _CourseReadingTasksState extends State<CourseReadingTasks> {
  late VideoPlayerController _controller;
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: widget.title ?? ""),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: widget.courseReadingTasks.length,
              itemBuilder: (context, index) {
                _controllers.add(TextEditingController());

                return Column(
                  children: [
                    HtmlWidget(widget.courseReadingTasks[index].body ?? ""),
                    if (widget.courseReadingTasks[index].question != "")
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.courseReadingTasks[index].question ?? "",
                              style: const TextStyle(
                                  color: MyColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                      ),
                    const SizedBox(height: 10),
                    if (widget.courseReadingTasks[index].question != "")
                      CustomTextField(
                          controller: _controllers[index],
                          hintText: "Хариулт",
                          maxLength: 2000),
                  ],
                );
              },
            )),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: MyColors.border1, width: 0.5)),
                  child: Text(
                    "1/3",
                    style: TextStyle(color: MyColors.black),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2 + 60,
                    child:
                        CustomElevatedButton(onPress: () {}, text: "Дараах ")),
              ],
            ),
          )
        ]);
  }
}
