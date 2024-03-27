import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/connection/models/course_response.dart';
import 'package:goodali/utils/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TaskVideoPlayer extends StatefulWidget {
  const TaskVideoPlayer({
    super.key,
    this.task,
    required this.onExitScreen,
    required this.onFullScreen,
  });
  final TaskResponse? task;
  final Function() onExitScreen;
  final Function() onFullScreen;
  @override
  State<TaskVideoPlayer> createState() => _TaskVideoPlayerState();
}

class _TaskVideoPlayerState extends State<TaskVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.task?.videoUrl ?? "",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        forceHD: false,
        isLive: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YoutubePlayerBuilder(
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            widget.onExitScreen();
          },
          onEnterFullScreen: () {
            widget.onFullScreen();
          },
          player: YoutubePlayer(
            controller: _controller,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                  backgroundColor: GoodaliColors.borderColor,
                  playedColor: GoodaliColors.primaryColor,
                  handleColor: GoodaliColors.primaryColor,
                  bufferedColor: GoodaliColors.grayColor,
                ),
              ),
              RemainingDuration(),
              FullScreenButton(),
            ],
          ),
          builder: (context, player) => player,
        ),
      ],
    );
  }
}
