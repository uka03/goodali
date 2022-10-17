import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/podcast_provider.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:goodali/services/podcast_service.dart';
import 'package:provider/provider.dart';

typedef OnTap = Function(Products audioObject);

class NotListenedPodcast extends StatefulWidget {
  final List<Products> podcastList;
  final PodcastService service;
  const NotListenedPodcast(
      {Key? key, required this.podcastList, required this.service})
      : super(key: key);

  @override
  State<NotListenedPodcast> createState() => _NotListenedPodcastState();
}

class _NotListenedPodcastState extends State<NotListenedPodcast>
    with AutomaticKeepAliveClientMixin<NotListenedPodcast> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PodcastProvider>(
      builder: (context, value, child) {
        if (value.unListenedPodcast.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.unListenedPodcast.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: PodcastItem(
                  index: index,
                  podcastItem: value.unListenedPodcast[index],
                  podcastList: value.unListenedPodcast,
                  onTap: (product) => () {},
                  service: widget.service,
                ),
              );
            },
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.podcastList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: PodcastItem(
                  index: index,
                  podcastItem: widget.podcastList[index],
                  podcastList: widget.podcastList,
                  onTap: (product) => () {},
                  service: widget.service,
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
