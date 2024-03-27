import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/connection/models/video_response.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/videos_page.dart';
import 'package:goodali/shared/components/custom_title.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/utils.dart';

class VideoSection extends StatelessWidget {
  const VideoSection({
    super.key,
    required this.videos,
  });

  final List<VideoResponseData?> videos;

  @override
  Widget build(BuildContext context) {
    return videos.isNotEmpty == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(
                title: "Видео",
                onArrowPressed: () {
                  Navigator.pushNamed(context, VideosPage.routeName);
                },
              ),
              VSpacer(),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: getListViewlength(videos.length),
                separatorBuilder: (context, index) => VSpacer(),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return VideoItem(video: video);
                },
              )
            ],
          )
        : SizedBox();
  }
}
