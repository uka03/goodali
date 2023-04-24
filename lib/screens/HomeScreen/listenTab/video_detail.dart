import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/video_model.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
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
        origin: "https://www.youtube.com/embed?rel=0/",
        startAt: Duration(seconds: 0),
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
    // log(_ytbPlayerController?.initialVideoId ?? "", name: "initialVideoId");
    // log(_ytbPlayerController?.params.origin ?? "", name: "origin");
    // log(_ytbPlayerController?.value.metaData.videoId ?? "", name: "videoId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kIsWeb ? null : const SimpleAppBar(noCard: true),
        body: Column(
          children: [
            Visibility(
              visible: kIsWeb,
              child: HeaderWidget(
                title: 'Нүүр / Видео /${widget.videoModel.title}',
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Visibility(
                    visible: kIsWeb ? true : false,
                    child: Container(
                      padding: const EdgeInsets.only(left: 255, bottom: 60),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.videoModel.title ?? "",
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: MyColors.black),
                      ),
                    ),
                  ),
                  kIsWeb
                      ? Container(
                          height: 700,
                          child: YoutubePlayerControllerProvider(
                            controller: _ytbPlayerController ?? YoutubePlayerController(initialVideoId: widget.videoModel.videoUrl ?? ""),
                            child: const YoutubePlayerIFrame(
                              aspectRatio: 16 / 9,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: YoutubePlayerControllerProvider(
                            controller: _ytbPlayerController ?? YoutubePlayerController(initialVideoId: widget.videoModel.videoUrl ?? ""),
                            child: const YoutubePlayerIFrame(
                              aspectRatio: 16 / 9,
                            ),
                          ),
                        ),
                  Visibility(
                    visible: kIsWeb ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        widget.videoModel.title ?? "",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MyColors.black),
                      ),
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
                      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 255 : 20),
                      child: Text("Төстэй видео", style: TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold, height: 1.7)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _similarVideo()
                ],
              )),
            ),
          ],
        ));
  }

  Widget _similarVideo() {
    return FutureBuilder(
      future: getSimilarVideo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<VideoModel> similarVideo = snapshot.data;
          if (kIsWeb) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 255),
              child: GridView.builder(
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: similarVideo.length > 3 ? 3 : similarVideo.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) => VideoItem(
                        videoModel: similarVideo[index],
                      )),
            );
          } else {
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: similarVideo.length,
                itemBuilder: (context, index) {
                  return VideoItem(videoModel: similarVideo[index]);
                });
          }
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
