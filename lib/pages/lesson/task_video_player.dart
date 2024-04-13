import 'package:flutter/material.dart';
import 'package:goodali/connection/models/course_response.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _controller.loadVideoById(videoId: widget.task?.videoUrl ?? "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: YoutubePlayer(
        aspectRatio: 16 / 9,
        controller: _controller,
      ),
    );
    // return Stack(
    //   children: [
    //     YoutubePlayerBuilder(
    //       onExitFullScreen: () {
    //         widget.onExitScreen();
    //       },
    //       onEnterFullScreen: () {
    //         widget.onFullScreen();
    //       },
    //       player: YoutubePlayer(
    //         controller: _controller,
    //         bottomActions: [
    //           CurrentPosition(),
    //           ProgressBar(
    //             isExpanded: true,
    //             colors: ProgressBarColors(
    //               backgroundColor: GoodaliColors.borderColor,
    //               playedColor: GoodaliColors.primaryColor,
    //               handleColor: GoodaliColors.primaryColor,
    //               bufferedColor: GoodaliColors.grayColor,
    //             ),
    //           ),
    //           RemainingDuration(),
    //           FullScreenButton(),
    //         ],
    //       ),
    //       builder: (context, player) => player,
    //     ),
    //   ],
    // );
  }
}
