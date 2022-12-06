import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/video_model.dart';
import 'package:goodali/screens/ListItems/video_item.dart';
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
        startAt: Duration(seconds: 0),
        autoPlay: true,
        showFullscreenButton: true,
      ),
    );
    // _controller?.addListener(listener);
  }

  // initiliazeSimilarVideo(videoUrl) {
  //   _ytbPlayerController = YoutubePlayerController(
  //     initialVideoId: videoUrl,
  //     params: const YoutubePlayerParams(
  //       showControls: true,
  //       origin: "https://www.youtube.com/embed/",
  //       startAt: Duration(seconds: 0),
  //       autoPlay: true,
  //     ),
  //   );
  //   // _controller?.addListener(listener);
  // }

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
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Төстэй видео",
                    style: TextStyle(
                        color: MyColors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.7)),
              ),
            ),
            const SizedBox(height: 30),
            _similarVideo()
          ],
        )));
  }

  Widget _similarVideo() {
    return FutureBuilder(
      future: getSimilarVideo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<VideoModel> similarVideo = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: similarVideo.length,
              itemBuilder: (context, index) {
                return VideoItem(videoModel: similarVideo[index]);
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.secondary,
            ),
          );
        }
      },
    );
  }

  Future<List<VideoModel>> getSimilarVideo() {
    Map videoID = {"video_id": widget.videoModel.id};
    return Connection.getSimilarVideo(context, videoID);
  }
}
