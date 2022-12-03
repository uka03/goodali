import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

typedef OnChanged = Function(bool isWatched);

class TaskVideoPlayer extends StatefulWidget {
  final CourseLessonsTasksModel courseTasks;
  final OnChanged onChanged;
  final int index;
  const TaskVideoPlayer(
      {Key? key,
      required this.courseTasks,
      required this.index,
      required this.onChanged})
      : super(key: key);

  @override
  State<TaskVideoPlayer> createState() => _TaskVideoPlayerState();
}

class _TaskVideoPlayerState extends State<TaskVideoPlayer> {
  late YoutubePlayerController _controller;
  bool isWatched = false;

  @override
  void initState() {
    initiliazeVideo(widget.courseTasks.videoUrl!);
    super.initState();
  }

  void listener() {
    if (mounted && !_controller.value.isFullScreen) {
      setState(() {});
      print(_controller.value.hasError);
      print(_controller.value.errorCode);
    }
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  void dispose() {
    _controller.dispose();
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  initiliazeVideo(String videoUrl) {
    log(videoUrl, name: "videoUrl");
    _controller = YoutubePlayerController(
      initialVideoId: videoUrl,
      flags: const YoutubePlayerFlags(
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        hideThumbnail: true,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: YoutubePlayer(
            controller: _controller,
            // showVideoProgressIndicator: true,
            onReady: () {
              _controller.addListener(listener);
            },
            bottomActions: [
              CurrentPosition(),
            ],
            progressIndicatorColor: MyColors.primaryColor,
            progressColors: ProgressBarColors(
              playedColor: MyColors.primaryColor,
              handleColor: MyColors.primaryColor.withOpacity(0.5),
            ),
          ),
        ),
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
                  value: isWatched,
                  onChanged: (value) {
                    setState(() {
                      isWatched = value!;
                    });
                    widget.onChanged.call(value!);
                  }),
              const Text("Видеог дуустал нь үзсэн.",
                  style: TextStyle(color: MyColors.black)),
            ],
          ),
        )
      ],
    );
  }
}
