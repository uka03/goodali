import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_textfield.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/course_lessons_tasks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  YoutubePlayerController? _controller;

  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
  }

  initiliazeVideo(videoUrl) {
    print(videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoUrl,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
    _controller?.addListener(listener);
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  void listener() {
    if (_controller?.value != null) {
      if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller ?? YoutubePlayerController(initialVideoId: ""),
        showVideoProgressIndicator: true,
        progressIndicatorColor: MyColors.primaryColor,
        onReady: () {
          _isPlayerReady = true;

          _controller?.addListener(listener);
        },
      ),
      builder: (context, player) {
        return Scaffold(
            appBar: SimpleAppBar(title: widget.title ?? ""),
            body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  itemCount: widget.courseReadingTasks.length,
                  itemBuilder: (context, index) {
                    _controllers.add(TextEditingController());
                    if (widget.courseReadingTasks[index].videoUrl != "") {
                      initiliazeVideo(
                          widget.courseReadingTasks[index].videoUrl);
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
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
                          if (widget.courseReadingTasks[index].videoUrl != "")
                            player
                        ],
                      ),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 25),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: MyColors.border1, width: 0.5)),
                      child: Text(
                        "1/3",
                        style: TextStyle(color: MyColors.black),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2 + 40,
                        child: CustomElevatedButton(
                            onPress: () {}, text: "Дараах ")),
                  ],
                ),
              )
            ]);
      },
    );
  }
}
