import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

typedef OnTap = Function(Products audioObject);

class DownloadedPodcast extends StatefulWidget {
  const DownloadedPodcast({Key? key}) : super(key: key);

  @override
  State<DownloadedPodcast> createState() => _DownloadedPodcastState();
}

class _DownloadedPodcastState extends State<DownloadedPodcast> {
  List<AudioPlayer> audioPlayer = [];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioDownloadProvider>(builder: ((context, value, child) {
      if (value.downloadedPodcast.isNotEmpty) {
        return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.downloadedPodcast.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: PodcastItem(
                    index: index,
                    podcastList: value.downloadedPodcast,
                    podcastItem: value.downloadedPodcast[index],
                    onTap: (product) => () {},
                  ));
            });
      } else {
        return Container();
      }
    }));
  }
}
