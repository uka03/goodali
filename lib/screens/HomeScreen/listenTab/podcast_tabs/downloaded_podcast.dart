import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/screens/ListItems/downloaded_lecture_item.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

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
      // print(value.downloadedPodcast.length);
      if (value.downloadedPodcast.isNotEmpty) {
        return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.downloadedPodcast.length,
            itemBuilder: (context, index) {
              audioPlayer.add(AudioPlayer());

              for (var i = 0; i < audioPlayer.length; i++) {
                if (currentIndex != i) {
                  audioPlayer[i].pause();
                }
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: DownloadedLectureItem(
                  audioPlayer: audioPlayer[index],
                  podcastItem: value.downloadedPodcast[index],
                  audioPlayerList: audioPlayer,
                  setIndex: (int index) {},
                ),
              );
            });
      } else {
        return Container();
      }
    }));
  }
}
