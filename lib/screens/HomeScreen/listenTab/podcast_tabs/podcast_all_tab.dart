import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'dart:developer';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';

typedef OnTap = Function(Products audioObject);

class PodcastAll extends StatefulWidget {
  final bool? isHomeScreen;
  final List<Products> podcastList;

  const PodcastAll(
      {Key? key, required this.podcastList, this.isHomeScreen = false})
      : super(key: key);

  @override
  State<PodcastAll> createState() => _PodcastAllState();
}

class _PodcastAllState extends State<PodcastAll>
    with AutomaticKeepAliveClientMixin<PodcastAll> {
  List<MediaItem> mediaItems = [];
  List<int> savedPos = [];

  @override
  void initState() {
    super.initState();
    if (audioHandler.queue.value.isEmpty) initiliaze();
  }

  Future<bool> initiliaze() async {
    if (activeList.isNotEmpty &&
        activeList.first.name == widget.podcastList.first.name &&
        activeList.first.id == widget.podcastList.first.id) {
      return true;
    }

    activeList = widget.podcastList;
    await initiliazePodcast();
    return true;
  }

  onPlayButtonClicked(int index) async {
    await initiliaze();
    currentlyPlaying.value = widget.podcastList[index];
    await audioHandler.skipToQueueItem(index);
    log("Starts in: ${widget.podcastList[index].position}");
    await audioHandler.seek(
      Duration(milliseconds: widget.podcastList[index].position!),
    );
    await audioHandler.play();
    await audioHandler.seek(
      Duration(milliseconds: widget.podcastList[index].position!),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      RefreshIndicator(
        color: MyColors.primaryColor,
        onRefresh: _refresh,
        child: ValueListenableBuilder<List<String>>(
          valueListenable: playlistNotifier,
          builder: (context, playlistTitles, _) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 13, bottom: 15),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PodcastItem(
                      onTap: () {
                        onPlayButtonClicked(index);
                      },
                      index: index,
                      podcastList: widget.podcastList,
                      podcastItem: widget.podcastList[index],
                    ));
              },
              itemCount: widget.isHomeScreen == true
                  ? widget.podcastList.length > 5
                      ? 5
                      : widget.podcastList.length
                  : widget.podcastList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                endIndent: 18,
                indent: 18,
              ),
            );
          },
        ),
      ),
    ]);
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
