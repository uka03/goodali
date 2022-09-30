import 'package:flutter/material.dart';
import 'package:goodali/Providers/podcast_provider.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class ListenedPodcast extends StatefulWidget {
  const ListenedPodcast({Key? key}) : super(key: key);

  @override
  State<ListenedPodcast> createState() => _ListenedPodcastState();
}

class _ListenedPodcastState extends State<ListenedPodcast> {
  final List<AudioPlayer> audioPlayer = [];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(
      builder: (context, value, child) {
        if (value.listenedPodcast.isNotEmpty) {
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: value.listenedPodcast.length,
              itemBuilder: (context, index) {
                audioPlayer.add(AudioPlayer());
                for (var i = 0; i < audioPlayer.length; i++) {
                  if (currentIndex != i) {
                    audioPlayer[i].pause();
                  }
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: PodcastItem(
                      podcastItem: value.listenedPodcast[index],
                      audioPlayer: audioPlayer[index],
                      audioPlayerList: audioPlayer,
                      setIndex: (int index) {
                        setState(() {
                          currentIndex = index;
                        });
                      }),
                );
              });
        } else {
          return Container();
        }
      },
    );
  }
}
