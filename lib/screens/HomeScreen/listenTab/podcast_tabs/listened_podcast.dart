import 'package:flutter/material.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';

import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';

typedef OnTap = Function(Products audioObject);

class ListenedPodcast extends StatefulWidget {
  final HiveDataStore dataStore;
  const ListenedPodcast({Key? key, required this.dataStore}) : super(key: key);

  @override
  State<ListenedPodcast> createState() => _ListenedPodcastState();
}

class _ListenedPodcastState extends State<ListenedPodcast>
    with AutomaticKeepAliveClientMixin<ListenedPodcast> {
  final List<AudioPlayer> audioPlayer = [];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: HiveDataStore.box.listenable(),
      builder: (context, Box box, widget) {
        if (box.length > 0) {
          List<Products> data = [];
          for (int a = 0; a < box.length; a++) {
            Products item = box.getAt(a);
            if (item.position! > 0) data.add(item);
          }
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: PodcastItem(
                    index: index,
                    podcastList: data,
                    podcastItem: data[index],
                    onTap: () async {
                      if (activeList.first.title == data.first.title &&
                          activeList.first.id == data.first.id) {
                        await audioHandler.skipToQueueItem(index);
                        await audioHandler.seek(
                          Duration(milliseconds: data[index].position!),
                        );
                        await audioHandler.play();
                        currentlyPlaying.value = data[index];
                      } else if (activeList.first.title != data.first.title ||
                          activeList.first.id != data.first.id) {
                        activeList = data;

                        await initiliazePodcast();
                        await audioHandler.skipToQueueItem(index);
                        await audioHandler.seek(
                          Duration(milliseconds: data[index].position!),
                        );
                        await audioHandler.play();
                      }
                      currentlyPlaying.value = data[index];
                    },
                  ),
                );
              });
        } else {
          return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
