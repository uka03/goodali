import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:just_audio/just_audio.dart';

typedef OnTap = Function(Products audioObject, List<Products> podcastList);

class PodcastAll extends StatefulWidget {
  final OnTap onTap;

  const PodcastAll({Key? key, required this.onTap}) : super(key: key);

  @override
  State<PodcastAll> createState() => _PodcastAllState();
}

class _PodcastAllState extends State<PodcastAll> {
  late final List<AudioPlayer> audioPlayers = [];

  late final future = getPodcastList();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<Products> podcastList = snapshot.data;

            return Stack(children: [
              RefreshIndicator(
                color: MyColors.primaryColor,
                onRefresh: _refresh,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 13, bottom: 15),
                  itemBuilder: (BuildContext context, int index) {
                    audioPlayers.add(AudioPlayer());
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PodcastItem(
                            onTap: () =>
                                widget.onTap(podcastList[index], podcastList),
                            setIndex: (int index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            index: index,
                            podcastList: podcastList,
                            podcastItem: podcastList[index],
                            audioPlayer: audioPlayers[index],
                            audioPlayerList: audioPlayers));
                  },
                  itemCount: podcastList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    endIndent: 18,
                    indent: 18,
                  ),
                ),
              ),
            ]);
          } else {
            return const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor));
          }
        });
  }

  Future<List<Products>> getPodcastList() {
    return Connection.getPodcastList(context);
  }

  Future<void> _refresh() async {
    setState(() {});
  }
}
