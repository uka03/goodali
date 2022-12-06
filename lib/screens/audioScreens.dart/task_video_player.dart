import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  String url = "";
  @override
  void initState() {
    url = widget.courseTasks.videoUrl!;
    initiliazeVideo(url);
    print("url $url ");
    super.initState();
  }

  YoutubePlayerController? _ytbPlayerController;

  @override
  void dispose() {
    _ytbPlayerController?.pause();
    super.dispose();
  }

  // initiliazeVideo(String videoUrl) {
  //   log(videoUrl, name: "videoUrl");
  //   _controller = YoutubePlayerController(
  //     initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
  //     flags: const YoutubePlayerFlags(
  //       mute: false,
  //       disableDragSeek: false,
  //       loop: false,
  //       isLive: false,
  //       autoPlay: false,
  //       hideThumbnail: true,
  //       forceHD: false,
  //       enableCaption: true,
  //     ),
  //   )..addListener(listener);
  // }

  initiliazeVideo(videoUrl) {
    log(videoUrl, name: "vide");
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: videoUrl,
      params: const YoutubePlayerParams(
        showControls: true,
        origin: "https://www.youtube.com/embed/",

        // autoPlay: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayerControllerProvider(
          controller: _ytbPlayerController ??
              YoutubePlayerController(
                  initialVideoId: widget.courseTasks.videoUrl ?? ""),
          child: const YoutubePlayerIFrame(
            aspectRatio: 16 / 9,
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
