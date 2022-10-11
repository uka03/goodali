import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/main.dart';
import 'dart:developer';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';

typedef OnTap = Function(Products audioObject);

class PodcastAll extends StatefulWidget {
  final bool? isHomeScreen;
  final List<Products> podcastList;
  final OnTap onTap;

  const PodcastAll(
      {Key? key,
      required this.onTap,
      required this.podcastList,
      this.isHomeScreen = false})
      : super(key: key);

  @override
  State<PodcastAll> createState() => _PodcastAllState();
}

class _PodcastAllState extends State<PodcastAll>
    with AutomaticKeepAliveClientMixin<PodcastAll> {
  AudioPlayerController audioPlayerController = AudioPlayerController();
  List<MediaItem> mediaItems = [];
  List<int> savedPos = [];

  @override
  void initState() {
    _initiliazePodcast();
    super.initState();
  }

  _initiliazePodcast() async {
    log("_initiliazePodcast");
    audioPlayerController.initiliaze();

    for (var item in widget.podcastList) {
      int savedPosition = await AudioPlayerController()
          .getSavedPosition(audioPlayerController.toAudioModel(item));
      savedPos.add(savedPosition);

      MediaItem mediaItem = MediaItem(
        id: item.productId.toString(),
        artUri: Uri.parse(Urls.networkPath + item.banner!),
        title: item.title!,
        extras: {
          'url': Urls.networkPath + item.audio!,
          "saved_position": savedPosition
        },
      );

      mediaItems.add(mediaItem);
    }

    await audioHandler.updateQueue(mediaItems);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      RefreshIndicator(
        color: MyColors.primaryColor,
        onRefresh: _refresh,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 13, bottom: 15),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PodcastItem(
                  onTap: (product) => widget.onTap(product),
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
          separatorBuilder: (BuildContext context, int index) => const Divider(
            endIndent: 18,
            indent: 18,
          ),
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
