import 'package:flutter/material.dart';
import 'package:goodali/Providers/podcast_provider.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:provider/provider.dart';

typedef OnTap = Function(Products audioObject);

class NotListenedPodcast extends StatefulWidget {
  final OnTap onTap;
  final List<Products> podcastList;
  const NotListenedPodcast(
      {Key? key, required this.onTap, required this.podcastList})
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
                  onTap: (product) => widget.onTap(product),
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
                  onTap: (product) => widget.onTap(product),
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
