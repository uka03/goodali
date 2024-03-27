import 'package:flutter/material.dart';
import 'package:goodali/pages/home/components/lectures_section.dart';
import 'package:goodali/pages/home/components/podcast_section.dart';
import 'package:goodali/pages/home/components/video_section.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/utils/spacer.dart';

class ListenPage extends StatelessWidget {
  const ListenPage({
    super.key,
    required this.homeProvider,
  });
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LecturesSection(lectures: homeProvider.lectures ?? []),
        VSpacer(),
        PodcastSection(
          podcasts: homeProvider.podcasts ?? [],
        ),
        VSpacer(),
        VideoSection(
          videos: homeProvider.videos ?? [],
        )
      ],
    );
  }
}
