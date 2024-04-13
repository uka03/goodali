import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/video_response.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/provider/video_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_read_more.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, this.video});

  static String routeName = "/video_player";
  final VideoResponseData? video;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoProvider videoProvider;
  late AudioProvider audioProvider;
  late YoutubePlayerController _controller;
  late VideoResponseData? video;

  @override
  void initState() {
    super.initState();
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.setPlayerState(context, GoodaliPlayerState.disposed);
    video = widget.video;
    videoProvider.getVideosSimilar(video?.id.toString() ?? "");
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _controller.loadVideoById(videoId: widget.video?.videoUrl ?? "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppbarWithBackButton(),
          body: SingleChildScrollView(
            child: Container(
              margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
              child: Column(
                children: [
                  YoutubePlayerControllerProvider(
                    controller: _controller,
                    child: YoutubePlayer(
                      aspectRatio: 16 / 9,
                      controller: _controller,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            VSpacer(),
                            Text(
                              video?.title ?? "",
                              style: GoodaliTextStyles.titleText(context, fontSize: 24),
                            ),
                            CustomReadMore(
                              text: removeHtmlTags(video?.body ?? ""),
                              trimLines: 6,
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.similarVideos?.length ?? 0,
                        separatorBuilder: (context, index) => VSpacer(),
                        itemBuilder: (context, index) {
                          final videoItem = provider.similarVideos?[index];
                          return VideoItem(
                            video: videoItem,
                            onItemPressed: (videoVal) async {
                              _controller.loadVideoById(videoId: videoVal?.videoUrl ?? "");
                              setState(() {
                                video = videoVal;
                              });
                              await provider.getVideosSimilar(videoVal?.id.toString() ?? "");
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
