import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/video_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_detail.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoItem extends StatefulWidget {
  final VideoModel videoModel;
  const VideoItem({Key? key, required this.videoModel}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => VideoDetail(videoModel: widget.videoModel))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageView(
              imgPath: widget.videoModel.banner ?? "",
              height: 180,
              width: MediaQuery.of(context).size.width),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.videoModel.title ?? "",
                  style: const TextStyle(color: MyColors.black, fontSize: 16),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
