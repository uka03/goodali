import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/provider/video_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});
  static String routeName = "/videos_page";

  @override
  State<VideosPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideosPage> {
  late VideoProvider videoProvider;
  @override
  void initState() {
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoProvider.getVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(builder: (context, proivder, _) {
      return GeneralScaffold(
        appBar: kIsWeb ? CustomWebAppbar() : AppbarWithBackButton() as PreferredSizeWidget,
        child: Container(
          margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text(
                  "Видео",
                  style: GoodaliTextStyles.titleText(context, fontSize: 32),
                ),
              ),
              Expanded(
                child: kIsWeb
                    ? GridView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: proivder.videos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final video = proivder.videos[index];
                          return VideoItem(video: video);
                        },
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: proivder.videos.length,
                        separatorBuilder: (context, index) => VSpacer(),
                        itemBuilder: (context, index) {
                          final video = proivder.videos[index];
                          return VideoItem(video: video);
                        },
                      ),
              )
            ],
          ),
        ),
      );
    });
  }
}
