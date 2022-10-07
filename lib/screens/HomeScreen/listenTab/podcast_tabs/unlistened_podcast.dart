import 'package:flutter/material.dart';
import 'package:goodali/Providers/podcast_provider.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

typedef OnTap = Function(Products audioObject, List<Products> podcastList);

class NotListenedPodcast extends StatefulWidget {
  final OnTap onTap;
  const NotListenedPodcast({Key? key, required this.onTap}) : super(key: key);

  @override
  State<NotListenedPodcast> createState() => _NotListenedPodcastState();
}

class _NotListenedPodcastState extends State<NotListenedPodcast> {
  final List<AudioPlayer> audioPlayers = [];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(
      builder: (context, value, child) {
        if (value.unListenedPodcast.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.unListenedPodcast.length,
            itemBuilder: (context, index) {
              audioPlayers.add(AudioPlayer());
              for (var i = 0; i < audioPlayers.length; i++) {
                if (currentIndex != i) {
                  audioPlayers[i].pause();
                }
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: PodcastItem(
                  index: index,
                  podcastItem: value.unListenedPodcast[index],
                  audioPlayer: audioPlayers[index],
                  audioPlayerList: audioPlayers,
                  setIndex: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  podcastList: value.unListenedPodcast,
                  onTap: () => widget.onTap(
                      value.unListenedPodcast[index], value.unListenedPodcast),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
