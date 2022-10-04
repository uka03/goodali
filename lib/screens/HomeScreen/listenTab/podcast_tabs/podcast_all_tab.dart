import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:just_audio/just_audio.dart';

typedef OnTap = Function(
    PodcastListModel audioObject, List<PodcastListModel> podcastList);

class PodcastAll extends StatefulWidget {
  final OnTap onTap;

  const PodcastAll({Key? key, required this.onTap}) : super(key: key);

  @override
  State<PodcastAll> createState() => _PodcastAllState();
}

class _PodcastAllState extends State<PodcastAll> {
  late final List<AudioPlayer> audioPlayers = [];

  late final future = getPodcastList();
  FileInfo? fileInfo;
  File? audioFile;

  double sliderValue = 0.0;
  int saveddouble = 0;
  int currentIndex = 0;
  String url = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    audioPlayers.map((e) => e.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<PodcastListModel> podcastList = snapshot.data;

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

  Future<List<PodcastListModel>> getPodcastList() {
    return Connection.getPodcastList(context);
  }

  Future<void> _refresh() async {
    setState(() {});
  }
}
