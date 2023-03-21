import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

typedef OnChanged = Function(bool isWatched);

class TaskVideoPlayer extends StatefulWidget {
  final CourseLessonsTasksModel courseTasks;
  final OnChanged onChanged;
  final int index;
  final TextEditingController textController;

  const TaskVideoPlayer({Key? key, required this.courseTasks, required this.index, required this.onChanged, required this.textController})
      : super(key: key);

  @override
  State<TaskVideoPlayer> createState() => _TaskVideoPlayerState();
}

class _TaskVideoPlayerState extends State<TaskVideoPlayer> {
  bool isWatched = false;
  String url = "";
  bool isTyping = false;

  @override
  void initState() {
    if (widget.courseTasks.videoUrl != null && widget.courseTasks.videoUrl!.isNotEmpty) {
      url = widget.courseTasks.videoUrl!;
      initiliazeVideo(url);
    }
    super.initState();
  }

  YoutubePlayerController? _ytbPlayerController;

  @override
  void dispose() {
    _ytbPlayerController?.stop();
    _ytbPlayerController?.pause();
    super.dispose();
  }

  initiliazeVideo(String videoUrl) {
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: videoUrl,
      params: const YoutubePlayerParams(
        showControls: true,
        origin: "https://www.youtube.com/embed/",
        showFullscreenButton: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.courseTasks.body != "" || widget.courseTasks.body!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: HtmlWidget(
                widget.courseTasks.body ?? "",
                textStyle: const TextStyle(fontFamily: "Gilroy", height: 1.6),
              ),
            ),
          if (url.isNotEmpty)
            YoutubePlayerControllerProvider(
              controller: _ytbPlayerController ?? YoutubePlayerController(initialVideoId: widget.courseTasks.videoUrl ?? ""),
              child: const YoutubePlayerIFrame(
                aspectRatio: 16 / 9,
              ),
            ),
          const SizedBox(height: 10),
          if (url.isNotEmpty)
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MyColors.border1)),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Checkbox(
                      shape: const CircleBorder(),
                      activeColor: MyColors.success,
                      value: isWatched,
                      onChanged: (value) {
                        setState(() {
                          isWatched = value!;
                        });
                        widget.onChanged.call(value!);
                      }),
                  const Text("Видеог дуустал нь үзсэн.", style: TextStyle(color: MyColors.black)),
                ],
              ),
            ),
          if (widget.courseTasks.isAnswer == 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
              child: TextField(
                controller: widget.textController,
                cursorColor: MyColors.primaryColor,
                maxLength: 2000,
                maxLines: null,
                onTap: () => setState(() {
                  isTyping = true;
                }),
                decoration: InputDecoration(
                  hintText: "Хариулт",
                  suffixIcon: isTyping
                      ? GestureDetector(
                          onTap: () {
                            widget.textController.text = "";
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
    );
  }
}
