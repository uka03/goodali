import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/video_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoDetail extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetail({Key? key, required this.videoModel}) : super(key: key);

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  YoutubePlayerController? _ytbPlayerController;

  @override
  void initState() {
    initiliazeVideo(widget.videoModel.videoUrl);
    super.initState();
  }

  @override
  void dispose() {
    _ytbPlayerController?.close();
    super.dispose();
  }

  initiliazeVideo(videoUrl) {
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: videoUrl,
      params: const YoutubePlayerParams(
        showControls: true,
        origin: "https://www.youtube.com/embed/",
        startAt: Duration(seconds: 30),
        autoPlay: true,
      ),
    );
    // _controller?.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleAppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: YoutubePlayerControllerProvider(
                controller: _ytbPlayerController ??
                    YoutubePlayerController(
                        initialVideoId: widget.videoModel.videoUrl ?? ""),
                child: const YoutubePlayerIFrame(
                  aspectRatio: 16 / 9,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                widget.videoModel.title ?? "",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyColors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.videoModel.body ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.7, color: MyColors.black),
              ),
            )
          ],
        )));
  }

  Future<List<VideoModel>> getVideoList() {
    return Connection.getVideoList(context);
  }
}
